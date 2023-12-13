SET SERVEROUTPUT ON

/*
    2. ġȯ����(&)�� ����ؼ� ���ڸ� �Է��ϸ� �ش� �������� ��µǵ��� �Ͻÿ�.
    ��) 2 �Է½�
    2 * 1 = 2
    2 * 2 = 4
    2 * 3 = 6
    2 * 4 = 8
    2 * 5 = 10
    2 * 6 = 12
    2 * 7 = 14
    2 * 8 = 16
    2 * 9 = 18
    
    �Է� : ��
    ��� : Ư�� ���� ( �� * ���ϴ� �� = ���)
    
    => ���ϴ� �� : 1���� 9 ������ ������
*/
-- �⺻ LOOP
DECLARE
    -- �� : ����Ÿ��, ġȯ���� �Է�
    v_dan NUMBER(1,0) := &��;
    v_num NUMBER := 1;
BEGIN
    -- �ݺ��� ����
    LOOP
        -- ��� : �� * ���ϴ� �� = (�� * ���ϴ� ��)
        DBMS_OUTPUT.PUT_LINE(v_dan || ' * ' || v_num || ' = ' || (v_dan * v_num));
        -- �̶� ���ϴ� ���� 1���� 9���� 1�� ���� => �ݺ������� ����
        v_num := v_num + 1;
        EXIT WHEN v_num > 9;
    END LOOP;
END;
/

-- FOR LOOP
DECLARE
    v_dan NUMBER(1,0) := &��;
BEGIN
    FOR v_num IN 1..9 LOOP
        DBMS_OUTPUT.PUT_LINE(v_dan || ' * ' || v_num || ' = ' || (v_dan * v_num));
    END LOOP;
END;
/

-- WHILE LOOP
DECLARE
    v_dan NUMBER(1,0) := &��;
    v_num NUMBER := 1;   
BEGIN
    WHILE v_num <= 9 LOOP
    DBMS_OUTPUT.PUT_LINE(v_dan || ' * ' || v_num || ' = ' || (v_dan * v_num));
    v_num := v_num + 1;
    END LOOP;
END;
/


/*
    3. ������ 2~9�ܱ��� ��µǵ��� �Ͻÿ�.
*/
BEGIN
    FOR v_num IN 2..9 LOOP
        DBMS_OUTPUT.PUT_LINE(v_num ||'��');
        FOR v_dan IN 1..9 LOOP
            DBMS_OUTPUT.PUT_LINE(v_num || ' * ' || v_dan || ' = ' || (v_dan * v_num));
        END LOOP;
    END LOOP;
END;
/

-- ������ ������ ����ϱ�
DECLARE
    v_dan NUMBER(2,0) := 2;
    v_num NUMBER(2,0) := 1;
    v_msg VARCHAR2(1000);
BEGIN
    WHILE v_num < 10 LOOP
        v_dan := 2; -- ���� ������ ���Ǵ� ������ ������ �ñ⿡ �ʱ�ȭ �Ǿ�� �Ѵ�
        WHILE v_dan < 10 LOOP
            v_msg := v_dan || ' X ' || v_num || ' = ' || (v_dan * v_num) || ' ';
            DBMS_OUTPUT.PUT(RPAD(v_msg, 13, ' '));
            v_dan := v_dan + 1;
        END LOOP;
        DBMS_OUTPUT.PUT_LINE('');
        v_num := v_num + 1;
    END LOOP;
END;
/
/*
    4. ������ 1~9�ܱ��� ��µǵ��� �Ͻÿ�.
        (��, Ȧ���� ���)
*/
BEGIN
    FOR v_dan IN 1..9 LOOP
        IF mod(v_dan,2) = 1 THEN DBMS_OUTPUT.PUT_LINE(v_dan ||'��');
            FOR v_num IN 1..9 LOOP
                DBMS_OUTPUT.PUT_LINE(v_dan || ' * ' || v_num || ' = ' || (v_dan * v_num));
            END LOOP;
        END IF;
    END LOOP;
END;
/

-- FOR LOOP + IF��
BEGIN
    FOR v_dan IN 1..9 LOOP -- Ư�� ���� 2~9���� �ݺ��ϴ� LOOP��
        IF MOD(v_dan,2) <> 0 THEN
            FOR v_num IN 1..9 LOOP -- Ư�� ���� 1~9���� ���ϴ� LOOP�� 
                DBMS_OUTPUT.PUT_LINE(v_dan || ' X ' || v_num || ' = ' || (v_dan * v_num));
            END LOOP;
            DBMS_OUTPUT.PUT_LINE('');
        END IF;
    END LOOP;
END;
/

-- FOR LOOP + IF��
-- CONTINUE �̿��ؼ�...
BEGIN
    FOR v_dan IN 1..9 LOOP
        IF MOD(v_dan, 2) = 0 THEN
            CONTINUE;   -- �� ���ĸ�...�鿩���� ������...�鿩���Ⱑ �� �ܰ� �� �� ���� �Ǵϱ� �������� ���ؼ�
        END IF;
            FOR v_num IN 1..9 LOOP
                DBMS_OUTPUT.PUT_LINE(v_dan || ' X ' || v_num || ' = ' || (v_dan * v_num));
            END LOOP;
        DBMS_OUTPUT.PUT_LINE('');
    END LOOP;
END;
/

-- RECORD : ������, �׷��� DECLARE�ʿ� ���� �� �־�� ��
-- ���ڵ�� ������ �ƴϰ� �����̴�, �� �� �ȿ����� ��� ����
DECLARE
    -- �̸��� type�� �����ָ� ����
    -- ���� �ٲ�� �ٽ�...
    TYPE info_rec_type IS RECORD
        ( no NUMBER NOT NULL := 1,
          name VARCHAR2(1000) := 'No Name',
          birth DATE);
    
    -- ���� ����
    user_info info_rec_type;
BEGIN
    -- ���� �� put���ο� �־ ����ϴ� �� �ȵ�
    -- DBMS_OUTPUT.PUT_LINE(user_info);
    DBMS_OUTPUT.PUT_LINE(user_info.no);
    user_info.birth := sysdate;
    DBMS_OUTPUT.PUT_LINE(user_info.birth);
END;
/

DECLARE
    emp_info_rec employees%ROWTYPE;
BEGIN
    SELECT * 
    INTO emp_info_rec
    FROM employees
    WHERE employee_id = &�����ȣ;
    
    -- .�ʵ�� �����ϱ�
    DBMS_OUTPUT.PUT_LINE('�����ȣ ' || emp_info_rec.employee_id);
    DBMS_OUTPUT.PUT_LINE('�̸� ' || emp_info_rec.last_name);
    DBMS_OUTPUT.PUT_LINE('���� ' || emp_info_rec.job_id);
END;
/

-- �����ȣ, �̸�, �μ��̸� : ���ο� �� ���̺��� ������ �÷� ���� �ҷ����� ���ؼ� ROWTYPE�� �Ѱ谡 �ִ�
DECLARE
    TYPE emp_rec_type IS RECORD
         ( eid employees.employee_id%TYPE,  -- NUMBER
           ename employees.last_name%TYPE,  -- VARCHAR2
           deptname departments.department_name%TYPE);  -- VARCHAR2
    emp_rec emp_rec_type;
BEGIN
    -- ��� *�� ����� �� ���� : �Ѿ���� �÷��� �� 15�� : JOIN�� �����ϱ� : USING���� �ߺ� �÷� �����ؼ� 14�� �Ѿ��
    SELECT employee_id, last_name, department_name 
    INTO emp_rec
    FROM employees e JOIN departments d ON(e.department_id = d.department_id)
    WHERE employee_id = &�����ȣ;
    
    DBMS_OUTPUT.PUT_LINE('�̸� : ' || emp_rec.ename);
END;
/

-- TABLE
DECLARE
    -- 1) ����
    TYPE num_table_type IS TABLE OF NUMBER
         INDEX BY BINARY_INTEGER;
    -- 2) ����
    num_list num_table_type;
BEGIN
    -- array[0] => table(0)
    num_list(-1000) := 1;
    num_list(1234)  := 2;
    num_list(11111) := 3;
    
    DBMS_OUTPUT.PUT_LINE(num_list.COUNT);
    DBMS_OUTPUT.PUT_LINE(num_list(1234));
END;
/

DECLARE
    -- 1) ����
    TYPE num_table_type IS TABLE OF NUMBER
         INDEX BY BINARY_INTEGER;
    -- 2) ����
    num_list num_table_type;
BEGIN
    FOR i IN 1..9 LOOP
        num_list(i) := 2 * 1;
    END LOOP;
    
    -- ��ȯ�ϴ� �ָ� ������ ��...
    FOR idx IN num_list.FIRST..num_list.LAST LOOP
        -- ���̺� ���ο� �ִ� ���� ������ ���� �׻� Ȯ�� �۾��� �ϱ�...
        IF num_list.EXISTS(idx) THEN
            DBMS_OUTPUT.PUT_LINE(num_list(idx));
        END IF;
    END LOOP;
END;
/

DECLARE
    TYPE emp_table_type IS TABLE OF employees%ROWTYPE
         INDEX BY BINARY_INTEGER;
         
    emp_table emp_table_type;
    emp_rec employees%ROWTYPE;
BEGIN
    FOR eid IN 100..110 LOOP
        SELECT *
        INTO emp_rec
        FROM employees
        WHERE employee_id = eid;
        
        emp_table(eid) := emp_rec;    
    END LOOP;
    DBMS_OUTPUT.PUT_LINE(emp_table(100).employee_id);
    DBMS_OUTPUT.PUT_LINE(emp_table(100).last_name);
END;
/
SELECT * FROM employees ORDER BY employee_id;



-- ��� �����͸� �� ������
DECLARE
    TYPE emp_table_type IS TABLE OF employees%ROWTYPE
         INDEX BY BINARY_INTEGER;
         
    emp_table emp_table_type;
    emp_rec employees%ROWTYPE;
    
    empFirstId employees.employee_id%TYPE := 0;
    empLastId employees.employee_id%TYPE := 0;
BEGIN
    SELECT MIN(employee_id), MAX(employee_id)
    INTO empFirstId, empLastId
    FROM employees;

    FOR eid IN empFirstId..empLastId LOOP
        SELECT *
        INTO emp_rec
        FROM employees
        WHERE employee_id = eid;
        
        emp_table(eid) := emp_rec;    
    END LOOP;
    
    FOR idx IN emp_table.FIRST..emp_table.LAST LOOP
        DBMS_OUTPUT.PUT(emp_table(idx).employee_id ||',');
        DBMS_OUTPUT.PUT_LINE(emp_table(idx).last_name);
    END LOOP;
END;
/
    SELECT MIN(employee_id), MAX(employee_id)
    FROM employees;
    
-- ������ Ǯ��
DECLARE
    v_min employees.employee_id%TYPE; -- �ּ� �����ȣ
    v_MAX employees.employee_id%TYPE; -- �ִ� �����ȣ
    v_result NUMBER(1,0);             -- ����� ���������� Ȯ��
    emp_record employees%ROWTYPE;     -- Employees ���̺��� �� �࿡ ����
    
    TYPE emp_table_type IS TABLE OF emp_record%TYPE
        INDEX BY PLS_INTEGER;
    
    emp_table emp_table_type;
BEGIN
    -- �ּ� �����ȣ, �ִ� �����ȣ
    SELECT MIN(employee_id), MAX(employee_id)
    INTO v_min, v_max
    FROM employees;
    
    FOR eid IN v_min .. v_max LOOP
        SELECT COUNT(*)     -- ���� ���θ� üũ
        INTO v_result
        FROM employees
        WHERE employee_id = eid;
        
        IF v_result = 0 THEN    -- ����� ���ٴ� ��
            CONTINUE;
        END IF;
        
        SELECT *
        INTO emp_record
        FROM employees
        WHERE employee_id = eid;
        
        emp_table(eid) := emp_record;     
    END LOOP;
    
    FOR eid IN emp_table.FIRST .. emp_table.LAST LOOP
        IF emp_table.EXISTS(eid) THEN
            DBMS_OUTPUT.PUT(emp_table(eid).employee_id || ', ');
            DBMS_OUTPUT.PUT_LINE(emp_table(eid).last_name);
        END IF;
    END LOOP;    
END;
/


-- CURSOR
-- ���ٸ� ��ȯ, ���� LOOP�� �ʼ������� ���
DECLARE
    -- cursor �ȿ����� ������ select�� ���
    CURSOR emp_dept_cursor IS
        SELECT employee_id, last_name
        FROM employees
        WHERE department_id = &�μ���ȣ;
        
    v_eid employees.employee_id%TYPE;
    v_ename employees.last_name%TYPE;
BEGIN
    -- cursor OPEN
    -- select ���� ������ �ִ� ����� �޸𸮿� �ö󰣴�
    OPEN emp_dept_cursor;
    
    -- pointer�� ù��°�� �̵�
    -- ���� �츮���� �����Ͱ� �Ѿ���� ����
    FETCH emp_dept_cursor INTO v_eid, v_ename;
    DBMS_OUTPUT.PUT_LINE(v_eid);
    DBMS_OUTPUT.PUT_LINE(v_ename);
    
    CLOSE emp_dept_cursor;
    -- close�� �� �Ŀ��� �������� ���� : ������ ���� ����
END;
/
    SELECT employee_id, last_name
    FROM employees
    WHERE department_id = 50;
    
DECLARE
    CURSOR emp_info_cursor IS
        SELECT employee_id eid, last_name ename, hire_date hdate
        FROM employees
        WHERE department_id =&�μ���ȣ
        ORDER BY hire_date DESC;
        
    emp_rec emp_info_cursor%ROWTYPE;
BEGIN
    -- select�� ����� ������� ��� ���� ������ ��Ī�� ����ص� �ȴ�
    OPEN emp_info_cursor;
    
    LOOP
        -- FETCH�� EXIT WHEN�� ���� �����δ�
        FETCH emp_info_cursor INTO emp_rec;
        EXIT WHEN emp_info_cursor%NOTFOUND;
        -- EXIT WHEN emp_info_cursor%NOTFOUND OR emp_info_cursor%ROWCOUNT > 10;
            -- ROWCOUNT : ��𿡼� ����ϴ��Ŀ� ���� �ǹ̰� �޶��� / LOOP ������ �ǹ̰� ���Ѵ�
            -- ���� ����Ű�� �� ���°���� �� LOOP �ȿ����� �ǹ�
            -- Ŀ���� �� ������ ���� : ��� ����ִµ�? �� LOOP �ۿ���
        -- EXIT WHEN emp_info_cursor%ROWCOUNT > 10;
        DBMS_OUTPUT.PUT(emp_info_cursor%ROWCOUNT || ', ');
        DBMS_OUTPUT.PUT(emp_rec.eid || ', ');
        DBMS_OUTPUT.PUT(emp_rec.ename || ', ');
        DBMS_OUTPUT.PUT_LINE(emp_rec.hdate);
    END LOOP;
    -- Ŀ���� �� ������ ����
    -- ��� �� close �Ǳ� ���� �ش� �ڵ带 Ȯ���ؾ� �Ѵ�
    IF emp_info_cursor%ROWCOUNT = 0 THEN
        DBMS_OUTPUT.PUT_LINE('���� Ŀ���� �����ʹ� �������� �ʽ��ϴ�.');
    END IF;
    
    -- Ŀ���� �������� ������ ���� �ʴ� �̻� �ȿ� ������ ��� ������ ����
    CLOSE emp_info_cursor;
END;
/

-- 1) ��� ����� �����ȣ, �̸�, �μ��̸� ���
DECLARE
    CURSOR emp_list_cursor IS
        SELECT employee_id, last_name, department_name
        FROM employees e LEFT JOIN departments d ON(e.department_id = d.department_id)
        ORDER BY employee_id;
    emp_rec emp_list_cursor%ROWTYPE;
    
    --v_eid employees.employee_id%TYPE;
    --v_ename employees.last_name%TYPE;
    --v_deptname departments.department_name%TYPE;
BEGIN
    OPEN emp_list_cursor;
    
    LOOP
        FETCH emp_list_cursor INTO emp_rec;
        EXIT WHEN emp_list_cursor%NOTFOUND;
        
        DBMS_OUTPUT.PUT(emp_rec.employee_id  || ', ');
        DBMS_OUTPUT.PUT(emp_rec.last_name  || ', ');
        DBMS_OUTPUT.PUT_LINE(emp_rec.department_name);
        
        --DBMS_OUTPUT.PUT(v_eid  || ', ');
        --DBMS_OUTPUT.PUT(v_ename  || ', ');
        --DBMS_OUTPUT.PUT_LINE(v_deptname);
    END LOOP;
    
    CLOSE emp_list_cursor;
END;
/
    SELECT employee_id, last_name, department_name
    FROM employees e JOIN departments d ON(e.department_id = d.department_id)
    ORDER BY employee_id;
    
-- 2) �μ���ȣ�� 50�̰ų� 80�� ������� ����̸�, �޿�, ���� ���
-- ���� : (�޿� * 12 + (NVL(�޿�, 0) * NVL(Ŀ�̼�, 0) * 12))
-- 2-1)
DECLARE
    CURSOR emp_sal_cursor IS
        SELECT department_id, employee_id, last_name, salary, (salary * 12 + (NVL(salary, 0) * NVL(commission_pct, 0) * 12)) total
        FROM employees
        WHERE department_id IN(50,80)   -- OR�� Ʋ���� �ƴ����� : ���� �߿��� �ϳ� >> IN ������
        ORDER BY department_id;
        
    emp_rec emp_sal_cursor%ROWTYPE;
BEGIN
    IF NOT emp_sal_cursor%ISOPEN THEN   -- cursor�� close�� ���¿��� �����ϰ� ���� �� �� �ִ�
        OPEN emp_sal_cursor;
    END IF;
    
    LOOP
        FETCH emp_sal_cursor INTO emp_rec;
        EXIT WHEN emp_sal_cursor%NOTFOUND;
        
        DBMS_OUTPUT.PUT(emp_rec.department_id  || ' | ');
        DBMS_OUTPUT.PUT(emp_rec.employee_id  || ' | ');
        DBMS_OUTPUT.PUT(emp_rec.last_name  || ' | ');
        DBMS_OUTPUT.PUT(emp_rec.salary  || ' | ');
        DBMS_OUTPUT.PUT_LINE(emp_rec.total);
    END LOOP;
    
    -- �� ��� ������ close�ϱ� : ������ �߻� �� ���� ����
    CLOSE emp_sal_cursor;
END;
/

-- 2-2)
DECLARE
    CURSOR emp_sal_cursor IS
        SELECT employee_id, salary, commission_pct
        FROM employees
        WHERE department_id IN(50,80)
        ORDER BY department_id;
        
    v_eid employees.employee_id%TYPE;
    v_sal employees.salary%TYPE;
    v_comm employees.commission_pct%TYPE;
    v_annual v_sal%TYPE;
BEGIN
    OPEN emp_sal_cursor;
    
    LOOP
        FETCH emp_sal_cursor INTO v_eid, v_sal, v_comm;
        EXIT WHEN emp_sal_cursor%NOTFOUND;
        
        v_annual := NVL(v_sal, 0) * 12 + NVL(v_sal, 0) * NVL(v_comm, 0) * 12;
        DBMS_OUTPUT.PUT_LINE(v_eid || ', ' || v_sal || ', ' || v_annual);        
    END LOOP;
    CLOSE emp_sal_cursor;
END;
/

