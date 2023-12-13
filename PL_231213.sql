SET SERVEROUTPUT ON

-- CURSOR FOR LOOP : �츮�� OPEN, FETCH, CLOSE���� �ʾƵ� �Ǵ�...
-- �ڵ����� ���� ���� ����
DECLARE
    CURSOR emp_cursor IS
        SELECT employee_id, last_name, job_id
        FROM employees
        WHERE department_id = &�μ���ȣ;
BEGIN
    FOR emp_rec IN emp_cursor LOOP
        DBMS_OUTPUT.PUT(emp_cursor%ROWCOUNT);
        DBMS_OUTPUT.PUT(': ' ||emp_rec.employee_id);
        DBMS_OUTPUT.PUT(', ' || emp_rec.last_name);
        DBMS_OUTPUT.PUT_LINE(', ' || emp_rec.job_id);
    END LOOP;   -- END LOOP�� �Ǵ� ���� CLOSE Ŀ���� �Ǿ������. ���� ƴ�� ���� / Ŀ���� �����ٴ� �ǹ̵� ����
    -- DBMS_OUTPUT.PUT(emp_cursor%ROWCOUNT); �̷��� �����ϰ� �Ǹ� ������ ����
END;
/

-- �� ���´� ��ǻ� Ŀ���� �Ӽ��� ����� �� ����
BEGIN
    FOR emp_rec IN (SELECT employee_id, last_name
                    FROM employees
                    WHERE department_id = &�μ���ȣ)LOOP
        DBMS_OUTPUT.PUT(', ' ||emp_rec.employee_id);
        DBMS_OUTPUT.PUT_LINE(', ' || emp_rec.last_name);
    END LOOP;
END;
/

-- 1) ��� ����� �����ȣ, �̸�, �μ��̸� ���
DECLARE
    CURSOR emp_list_cursor IS
        SELECT employee_id, last_name, department_name
        FROM employees e LEFT JOIN departments d ON(e.department_id = d.department_id)
        ORDER BY employee_id;
BEGIN
    FOR emp_list IN emp_list_cursor LOOP
        DBMS_OUTPUT.PUT(emp_list.employee_id  || ', ');
        DBMS_OUTPUT.PUT(emp_list.last_name  || ', ');
        DBMS_OUTPUT.PUT_LINE(emp_list.department_name);
    END LOOP;
END;
/
-- 2) �μ���ȣ�� 50�̰ų� 80�� ������� ����̸�, �޿�, ���� ���
-- ���� : (�޿� * 12 + (NVL(�޿�, 0) * NVL(Ŀ�̼�, 0) * 12)
DECLARE
    CURSOR emp_sal_cursor IS
        SELECT department_id, employee_id, last_name, salary, (salary * 12 + (NVL(salary, 0) * NVL(commission_pct, 0) * 12)) total
        FROM employees
        WHERE department_id IN(50,80)
        ORDER BY department_id;
        
BEGIN
    FOR emp_sal IN emp_sal_cursor LOOP
        DBMS_OUTPUT.PUT(emp_sal.department_id  || ' | ');
        DBMS_OUTPUT.PUT(emp_sal.employee_id  || ' | ');
        DBMS_OUTPUT.PUT(emp_sal.last_name  || ' | ');
        DBMS_OUTPUT.PUT(emp_sal.salary  || ' | ');
        DBMS_OUTPUT.PUT_LINE(emp_sal.total);
    END LOOP;
END;
/

-- �Ű����� ��� Ŀ��
DECLARE
    CURSOR emp_cursor (p_deptno NUMBER) IS
        SELECT last_name, hire_date
        FROM employees
        WHERE department_id = p_deptno;
    emp_info emp_cursor%ROWTYPE;
BEGIN
    OPEN emp_cursor(60);
    
    FETCH emp_cursor INTO emp_info;
    DBMS_OUTPUT.PUT_LINE(emp_info.last_name);
    
    -- OPEN emp_cursor(80);
    CLOSE emp_cursor;
END;
/

-- ���� �����ϴ� ��� �μ��� �� �Ҽӻ���� ����ϰ�, ���� ��� '���� �Ҽӻ���� �����ϴ�.' ��� ����ϱ�
-- format
-- Ŀ�� 2��, ������ 2�� �Ἥ
/*
=== �μ��� : �μ� Ǯ����
1. �����ȣ, ����̸�, �Ի���, ����
2. �����ȣ, ����̸�, �Ի���, ����
.
.
.
*/
DECLARE
    CURSOR dept_cursor IS
        SELECT department_id, department_name
        FROM departments;
    
    CURSOR emp_cursor (p_deptno NUMBER) IS
        SELECT last_name, hire_date, job_id
        FROM employees
        WHERE department_id = p_deptno;
        
    emp_rec emp_cursor%ROWTYPE;
BEGIN
    FOR dept_rec IN dept_cursor LOOP
        DBMS_OUTPUT.PUT_LINE('====== �μ��� : ' || dept_rec.department_name);
        OPEN emp_cursor(dept_rec.department_id);
        
        LOOP
            FETCH emp_cursor INTO emp_rec;
            EXIT WHEN emp_cursor%NOTFOUND;
            DBMS_OUTPUT.PUT(emp_cursor%ROWCOUNT);
            DBMS_OUTPUT.PUT(', ' || emp_rec.last_name);
            DBMS_OUTPUT.PUT(', ' || emp_rec.hire_date);
            DBMS_OUTPUT.PUT_LINE(', ' || emp_rec.job_id);
        END LOOP;
        
        IF emp_cursor%ROWCOUNT = 0 THEN
            DBMS_OUTPUT.PUT_LINE('���� �Ҽ� ����� �����ϴ�.');
        END IF;
        CLOSE emp_cursor;
        
    END LOOP;
END;
/

-- �Ű������� ������� cursor for loop �� ��
DECLARE
    CURSOR emp_cursor (p_deptno NUMBER) IS
        SELECT last_name, hire_date, job_id
        FROM employees
        WHERE department_id = p_deptno;
BEGIN
    FOR emp_rec IN emp_cursor(50) LOOP
        DBMS_OUTPUT.PUT(emp_cursor%ROWCOUNT);
        DBMS_OUTPUT.PUT(', ' || emp_rec.last_name);
        DBMS_OUTPUT.PUT(', ' || emp_rec.hire_date);
        DBMS_OUTPUT.PUT_LINE(', ' || emp_rec.job_id);
    END LOOP;
END;
/

-- FOR UPDATE, WHERE CURRENT OF
DECLARE
    CURSOR sal_info_cursor IS
        SELECT salary, commission_pct
        FROM employees
        WHERE department_id = 60
        FOR UPDATE OF salary, commission_pct NOWAIT;
BEGIN
    FOR sal_info IN sal_info_cursor LOOP
        IF sal_info.commission_pct IS NULL THEN
            UPDATE employees
            SET salary = sal_info.salary * 1.1
            WHERE CURRENT OF sal_info_cursor;
        ELSE
            UPDATE employees
            SET salary = sal_info.salary + sal_info.salary * sal_info.commission_pct
            WHERE CURRENT OF sal_info_cursor;
        END IF;
    END LOOP;
END;
/
ROLLBACK;

 SELECT salary, commission_pct
 FROM employees
 WHERE department_id = 60;
 

-- ����ó��
-- 1) �̹� ���ǵǾ��ְ� �̸��� �����ϴ� ���ܻ���
DECLARE
    v_ename employees.last_name%TYPE;
BEGIN
    SELECT last_name
    INTO v_ename
    FROM employees
    WHERE department_id = &�μ���ȣ;
    
    DBMS_OUTPUT.PUT_LINE('v_ename');
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('�ش� �μ��� ���� ����� �����ϴ�');
    WHEN TOO_MANY_ROWS THEN
        DBMS_OUTPUT.PUT_LINE('�ش� �μ����� �������� ����� �����մϴ�');
        DBMS_OUTPUT.PUT_LINE('����ó���� �������ϴ�.');
END;
/

--2) �̹� ���Ǵ� �Ǿ������� ������ �̸��� �������� �ʴ� ���ܻ���
DECLARE
    e_emps_remaining EXCEPTION;
    PRAGMA EXCEPTION_INIT(e_emps_remaining, -02292);
BEGIN
    DELETE FROM departments
    WHERE department_id = &�μ���ȣ;
EXCEPTION
    WHEN e_emps_remaining THEN
        DBMS_OUTPUT.PUT_LINE('�ش� �μ��� ���� ����� �����մϴ�.');
END;
/

--3) ����� ���� ���� : ����Ŭ ���忡���� ���ܰ� �ƴϾ�� �Ѵ�
DECLARE
    e_no_deptno EXCEPTION;
    v_ex_code NUMBER;
    v_ex_msg VARCHAR2(1000);
BEGIN
    DELETE FROM departments
    WHERE department_id = &�μ���ȣ;
    
    IF SQL%ROWCOUNT = 0 THEN
        RAISE e_no_deptno;
        -- DBMS_OUTPUT.PUT_LINE('�ش� �μ���ȣ�� �������� �ʽ��ϴ�.');
    END IF;
    
    DBMS_OUTPUT.PUT_LINE('�ش� �μ���ȣ�� �����Ǿ����ϴ�.');
EXCEPTION
    WHEN e_no_deptno THEN
        DBMS_OUTPUT.PUT_LINE('�ش� �μ���ȣ�� �������� �ʽ��ϴ�.');
    WHEN OTHERS THEN
        v_ex_code := SQLCODE;
        v_ex_msg := SQLERRM;
        DBMS_OUTPUT.PUT_LINE(v_ex_code);
        DBMS_OUTPUT.PUT_LINE(v_ex_msg);
END;
/

CREATE TABLE test_employee
AS
    SELECT *
    FROM employees;
    
-- test_employee ���̺��� ����Ͽ� Ư�� ����� �����ϴ� PL/SQL �ۼ�
-- �Է�ó���� ġȯ������ ���
-- �ش� ����� ���� ��츦 Ȯ���ؼ� '�ش� ����� �������� �ʽ��ϴ�.'�� ���
-- ����� ���� �Լ�
-- ������ ���
DECLARE
    v_eid employees.employee_id%TYPE := &�����ȣ;
    
    e_no_emp EXCEPTION;
BEGIN
    DELETE test_employee
    WHERE employee_id = v_eid;
    
    IF SQL%ROWCOUNT = 0 THEN
    RAISE e_no_emp;
    END IF;
    
    DBMS_OUTPUT.PUT(v_eid ||', ');
    DBMS_OUTPUT.PUT_LINE('�����Ǿ����ϴ�.');
EXCEPTION
    WHEN e_no_emp THEN
        DBMS_OUTPUT.PUT(v_eid ||', ');
        DBMS_OUTPUT.PUT_LINE('���� ���̺� ����� �������� �ʽ��ϴ�.');
END;
/

DECLARE
    e_no_emp EXCEPTION;
BEGIN
    DELETE FROM test_employee
    WHERE employee_id = &�����ȣ;
    
    IF SQL%ROWCOUNT = 0 THEN
    RAISE e_no_emp;

    END IF;
EXCEPTION
    WHEN e_no_emp THEN
        DBMS_OUTPUT.PUT_LINE('�ش� ����� �����ϴ�');
END;
/

ROLLBACK;


-- PROCEDURE
CREATE OR REPLACE PROCEDURE test_pro    -- ù��° ��� : ����� / �ι�° ��� : ���ν��� ����...
-- ()
IS
-- DECLARE ����, ������ ����ִ�
-- DECLARE : �����
-- ��������, ���ڵ�, Ŀ��, EXCEPTION
BEGIN
    DBMS_OUTPUT.PUT_LINE('First Procedure');
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('����ó��');
END;
/

-- 1) ��� ���ο��� ȣ��
BEGIN
    test_pro;
END;
/

-- 2) EXECUTE ��ɾ� ��� : ������ ����
-- PROCEDURE�� ���� �� ������ �ϳ��ۿ� �������
EXECUTE test_pro;

-- PROCEDURE ����
DROP PROCEDURE test_pro;


-- IN
CREATE PROCEDURE raise_salary
(p_eid IN NUMBER)
IS

BEGIN
    -- p_eid := 100;
    
    UPDATE employees
    SET salary = salary * 1.1
    WHERE employee_id = p_eid;
END;
/

DECLARE
    v_id employees.employee_id%TYPE := &�����ȣ;
    v_num CONSTANT NUMBER := v_id;
BEGIN
    RAISE_SALARY(v_id);
    RAISE_SALARY(v_num);
    RAISE_SALARY(v_num + 100);
    RAISE_SALARY(200);
END;
/

CREATE PROCEDURE pro_plus
( p_x IN NUMBER,
  p_y IN NUMBER,
  p_result OUT NUMBER)
IS
    v_sum NUMBER;
BEGIN
    DBMS_OUTPUT.PUT(p_x);
    DBMS_OUTPUT.PUT(' + ' || p_y);
    DBMS_OUTPUT.PUT_LINE(' = ' || p_result);
    
    v_sum := p_x + p_y;
END;
/

-- ���ʿ� OUT ���� ���� �׳� ��� �뵵�θ� ���ٰ� �����ϱ�
DECLARE
    v_first NUMBER := 10;
    v_second NUMBER := 12;
    v_result NUMBER := 100;
BEGIN
    DBMS_OUTPUT.PUT_LINE('before : ' || v_result);
    pro_plus(v_first, v_second, v_result);
    DBMS_OUTPUT.PUT_LINE('after : ' || v_result);  
END;
/

-- IN OUT : �׷��� �ַ� ����ϴ� �뵵�� ������ �����ϴ� �뵵��...
-- 01012341234 => 010-1234-1234
CREATE OR REPLACE PROCEDURE format_phone
(p_phone_no IN OUT VARCHAR2)
IS
    
BEGIN
    p_phone_no := SUBSTR(p_phone_no, 1, 3)
            || '-' || SUBSTR(p_phone_no, 4, 4)
            || '-' || SUBSTR(p_phone_no, 8);
END;
/

DECLARE
    v_no VARCHAR2(50) := '01012341234';
BEGIN
    DBMS_OUTPUT.PUT_LINE('before ' || v_no);
    format_phone(v_no);
    DBMS_OUTPUT.PUT_LINE('after ' || v_no);
END;
/

/*
    1. �ֹε�Ϲ�ȣ�� �Է��ϸ�
    ������ ���� ��µǵ��� yedam_ju ���ν����� �ۼ��Ͻÿ�.
    
    EXECUTE yedam_ju(9501011667777)
    EXECUTE yedam_ju(1511013689977)
    
    -> 950101-1******
    
    �߰�) �ش� �ֹε�Ϲ�ȣ�� �������� ���� ��������� ����ϴ� �κе� �߰�
    9501011667777 => 1995��10��11��
    1511013689977 => 2015��11��01��
*/
CREATE OR REPLACE PROCEDURE yedam_ju
(j_id_no IN VARCHAR2)
IS
   v_result VARCHAR2(100); 
BEGIN
    -- j_id_no := SUBSTR(j_id_no, 1, 6) || '-' || SUBSTR(j_id_no, 7, 1) || '******';
    v_result := SUBSTR(j_id_no, 1, 6) || '-' || RPAD(SUBSTR(j_id_no, 7, 1),7, '*');
    DBMS_OUTPUT.PUT_LINE(v_result);
END;
/

EXECUTE yedam_ju('9501011667777');
EXECUTE yedam_ju('1511013689977');

/*
DECLARE
    v_no VARCHAR2(50) := '9501011667777';
    v_no2 VARCHAR2(50) := '1511013689977';
BEGIN
    yedam_ju(v_no);
    DBMS_OUTPUT.PUT_LINE(v_no);
    yedam_ju(v_no2);
    DBMS_OUTPUT.PUT_LINE(v_no2);
END;
/
*/


/*  �߰�) �ش� �ֹε�Ϲ�ȣ�� �������� ���� ��������� ����ϴ� �κе� �߰�
    9501011667777 => 1995��10��11��
    1511013689977 => 2015��11��01��
    
    rr���� �ȵ�!
*/
CREATE OR REPLACE PROCEDURE yedam_ju
(j_id_no IN VARCHAR2)
IS
   v_result VARCHAR2(100);
   v_gender CHAR;
   v_birth VARCHAR2(11 char);
BEGIN
    -- j_id_no := SUBSTR(j_id_no, 1, 6) || '-' || SUBSTR(j_id_no, 7, 1) || '******';
    v_result := SUBSTR(j_id_no, 1, 6) || '-' || RPAD(SUBSTR(j_id_no, 7, 1),7, '*');
    DBMS_OUTPUT.PUT_LINE(v_result);
    
    -- �߰�
    v_gender := SUBSTR(j_id_no, 7, 1);
    
    IF v_gender IN ('1', '2', '5', '6') THEN
        v_birth := '19' || SUBSTR(j_id_no, 1, 2) || '��'
                        || SUBSTR(j_id_no, 3, 2) || '��'
                        || SUBSTR(j_id_no, 5, 2) || '��';
    ELSIF v_gender IN ('3', '4', '7', '8') THEN
        v_birth := '20' || SUBSTR(j_id_no, 1, 2) || '��'
                        || SUBSTR(j_id_no, 3, 2) || '��'
                        || SUBSTR(j_id_no, 5, 2) || '��';
    END IF;
    DBMS_OUTPUT.PUT_LINE(v_birth);
END;
/
EXECUTE yedam_ju('9501011667777');
EXECUTE yedam_ju('1511013689977');

/*
    2.
    �����ȣ�� �Է��� ���
    �����ϴ� TEST_PRO ���ν����� �����Ͻÿ�.
    ��, �ش����� ���� ��� "�ش����� �����ϴ�." ���
    ��) EXECUTE TEST_PRO(176)
*/
CREATE OR REPLACE PROCEDURE TEST_PRO
(emp_no IN test_employee.employee_id%TYPE)
IS
    e_no_emp EXCEPTION;
BEGIN
    DELETE FROM test_employee
    WHERE employee_id = emp_no;
    
    IF SQL%ROWCOUNT = 0 THEN
    RAISE e_no_emp;

    END IF;
EXCEPTION
    WHEN e_no_emp THEN
        DBMS_OUTPUT.PUT_LINE('�ش� ����� �����ϴ�');
END;
/
EXECUTE TEST_PRO(101);
EXECUTE TEST_PRO(800);
Rollback;

/*
    3.
    ������ ���� PL/SQL ����� ������ ��� 
    �����ȣ�� �Է��� ��� ����� �̸�(last_name)�� ù��° ���ڸ� �����ϰ��
    '*'�� ��µǵ��� yedam_emp ���ν����� �����Ͻÿ�.
    
    ����) EXECUTE yedam_emp(176)
    ������) TAYLOR -> T*****  <- �̸� ũ�⸸ŭ ��ǥ(*) ���
*/
CREATE OR REPLACE PROCEDURE yedam_emp
(p_phone_no IN OUT VARCHAR2)
IS
    
BEGIN
    p_phone_no := SUBSTR(p_phone_no, 1, 3)
            || '-' || SUBSTR(p_phone_no, 4, 4)
            || '-' || SUBSTR(p_phone_no, 8);
END;
/

DECLARE
    SELECT last_name FROM test_employee
    WHERE employee_id = emp_no;
BEGIN
    DBMS_OUTPUT.PUT_LINE('before ' || v_no);
    format_phone(v_no);
    DBMS_OUTPUT.PUT_LINE('after ' || v_no);
END;
/

