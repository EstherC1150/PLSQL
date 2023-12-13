SET SERVEROUTPUT ON

-- CURSOR FOR LOOP : 우리가 OPEN, FETCH, CLOSE하지 않아도 되는...
-- 자동으로 열고 끝을 낸다
DECLARE
    CURSOR emp_cursor IS
        SELECT employee_id, last_name, job_id
        FROM employees
        WHERE department_id = &부서번호;
BEGIN
    FOR emp_rec IN emp_cursor LOOP
        DBMS_OUTPUT.PUT(emp_cursor%ROWCOUNT);
        DBMS_OUTPUT.PUT(': ' ||emp_rec.employee_id);
        DBMS_OUTPUT.PUT(', ' || emp_rec.last_name);
        DBMS_OUTPUT.PUT_LINE(', ' || emp_rec.job_id);
    END LOOP;   -- END LOOP가 되는 순간 CLOSE 커서가 되어버린다. 따라서 틈이 없음 / 커서가 끝났다는 의미도 있음
    -- DBMS_OUTPUT.PUT(emp_cursor%ROWCOUNT); 이렇게 접근하게 되면 오류가 난다
END;
/

-- 이 형태는 사실상 커서의 속성을 사용할 수 없음
BEGIN
    FOR emp_rec IN (SELECT employee_id, last_name
                    FROM employees
                    WHERE department_id = &부서번호)LOOP
        DBMS_OUTPUT.PUT(', ' ||emp_rec.employee_id);
        DBMS_OUTPUT.PUT_LINE(', ' || emp_rec.last_name);
    END LOOP;
END;
/

-- 1) 모든 사원의 사원번호, 이름, 부서이름 출력
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
-- 2) 부서번호가 50이거나 80인 사원들의 사원이름, 급여, 연봉 출력
-- 연봉 : (급여 * 12 + (NVL(급여, 0) * NVL(커미션, 0) * 12)
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

-- 매개변수 사용 커서
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

-- 현재 존재하는 모든 부서의 각 소속사원을 출력하고, 없는 경우 '현재 소속사원이 없습니다.' 라고 출력하기
-- format
-- 커서 2개, 루프문 2개 써서
/*
=== 부서명 : 부서 풀네임
1. 사원번호, 사원이름, 입사일, 업무
2. 사원번호, 사원이름, 입사일, 업무
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
        DBMS_OUTPUT.PUT_LINE('====== 부서명 : ' || dept_rec.department_name);
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
            DBMS_OUTPUT.PUT_LINE('현재 소속 사원이 없습니다.');
        END IF;
        CLOSE emp_cursor;
        
    END LOOP;
END;
/

-- 매개변수를 기반으로 cursor for loop 쓸 때
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
 

-- 예외처리
-- 1) 이미 정의되어있고 이름도 존재하는 예외사항
DECLARE
    v_ename employees.last_name%TYPE;
BEGIN
    SELECT last_name
    INTO v_ename
    FROM employees
    WHERE department_id = &부서번호;
    
    DBMS_OUTPUT.PUT_LINE('v_ename');
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('해당 부서에 속한 사원이 없습니다');
    WHEN TOO_MANY_ROWS THEN
        DBMS_OUTPUT.PUT_LINE('해당 부서에는 여러명의 사원이 존재합니다');
        DBMS_OUTPUT.PUT_LINE('예외처리가 끝났습니다.');
END;
/

--2) 이미 정의는 되어있지만 고유의 이름이 존재하지 않는 예외사항
DECLARE
    e_emps_remaining EXCEPTION;
    PRAGMA EXCEPTION_INIT(e_emps_remaining, -02292);
BEGIN
    DELETE FROM departments
    WHERE department_id = &부서번호;
EXCEPTION
    WHEN e_emps_remaining THEN
        DBMS_OUTPUT.PUT_LINE('해당 부서에 속한 사원이 존재합니다.');
END;
/

--3) 사용자 정의 사항 : 오라클 입장에서는 예외가 아니어야 한다
DECLARE
    e_no_deptno EXCEPTION;
    v_ex_code NUMBER;
    v_ex_msg VARCHAR2(1000);
BEGIN
    DELETE FROM departments
    WHERE department_id = &부서번호;
    
    IF SQL%ROWCOUNT = 0 THEN
        RAISE e_no_deptno;
        -- DBMS_OUTPUT.PUT_LINE('해당 부서번호는 존재하지 않습니다.');
    END IF;
    
    DBMS_OUTPUT.PUT_LINE('해당 부서번호가 삭제되었습니다.');
EXCEPTION
    WHEN e_no_deptno THEN
        DBMS_OUTPUT.PUT_LINE('해당 부서번호는 존재하지 않습니다.');
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
    
-- test_employee 테이블을 사용하여 특정 사원을 삭제하는 PL/SQL 작성
-- 입력처리는 치환변수를 사용
-- 해당 사원이 없는 경우를 확인해서 '해당 사원이 존재하지 않습니다.'를 출력
-- 사용자 정의 함수
-- 교수님 방식
DECLARE
    v_eid employees.employee_id%TYPE := &사원번호;
    
    e_no_emp EXCEPTION;
BEGIN
    DELETE test_employee
    WHERE employee_id = v_eid;
    
    IF SQL%ROWCOUNT = 0 THEN
    RAISE e_no_emp;
    END IF;
    
    DBMS_OUTPUT.PUT(v_eid ||', ');
    DBMS_OUTPUT.PUT_LINE('삭제되었습니다.');
EXCEPTION
    WHEN e_no_emp THEN
        DBMS_OUTPUT.PUT(v_eid ||', ');
        DBMS_OUTPUT.PUT_LINE('현재 테이블에 사원이 존재하지 않습니다.');
END;
/

DECLARE
    e_no_emp EXCEPTION;
BEGIN
    DELETE FROM test_employee
    WHERE employee_id = &사원번호;
    
    IF SQL%ROWCOUNT = 0 THEN
    RAISE e_no_emp;

    END IF;
EXCEPTION
    WHEN e_no_emp THEN
        DBMS_OUTPUT.PUT_LINE('해당 사원이 없습니다');
END;
/

ROLLBACK;


-- PROCEDURE
CREATE OR REPLACE PROCEDURE test_pro    -- 첫번째 방법 : 덮어쓰기 / 두번째 방법 : 프로시저 들어가서...
-- ()
IS
-- DECLARE 생략, 공간은 살아있다
-- DECLARE : 선언부
-- 지역변수, 레코드, 커서, EXCEPTION
BEGIN
    DBMS_OUTPUT.PUT_LINE('First Procedure');
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('예외처리');
END;
/

-- 1) 블록 내부에서 호출
BEGIN
    test_pro;
END;
/

-- 2) EXECUTE 명령어 사용 : 간단한 실행
-- PROCEDURE가 여러 개 있으면 하나밖에 실행못함
EXECUTE test_pro;

-- PROCEDURE 삭제
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
    v_id employees.employee_id%TYPE := &사원번호;
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

-- 애초에 OUT 모드는 값을 그냥 담는 용도로만 쓴다고 생각하기
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

-- IN OUT : 그러나 주로 사용하는 용도는 포맷을 변경하는 용도로...
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
    1. 주민등록번호를 입력하면
    다음과 같이 출력되도록 yedam_ju 프로시저를 작성하시오.
    
    EXECUTE yedam_ju(9501011667777)
    EXECUTE yedam_ju(1511013689977)
    
    -> 950101-1******
    
    추가) 해당 주민등록번호를 기준으로 실제 생년월일을 출력하는 부분도 추가
    9501011667777 => 1995년10월11일
    1511013689977 => 2015년11월01일
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


/*  추가) 해당 주민등록번호를 기준으로 실제 생년월일을 출력하는 부분도 추가
    9501011667777 => 1995년10월11일
    1511013689977 => 2015년11월01일
    
    rr쓰면 안됨!
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
    
    -- 추가
    v_gender := SUBSTR(j_id_no, 7, 1);
    
    IF v_gender IN ('1', '2', '5', '6') THEN
        v_birth := '19' || SUBSTR(j_id_no, 1, 2) || '년'
                        || SUBSTR(j_id_no, 3, 2) || '월'
                        || SUBSTR(j_id_no, 5, 2) || '일';
    ELSIF v_gender IN ('3', '4', '7', '8') THEN
        v_birth := '20' || SUBSTR(j_id_no, 1, 2) || '년'
                        || SUBSTR(j_id_no, 3, 2) || '월'
                        || SUBSTR(j_id_no, 5, 2) || '일';
    END IF;
    DBMS_OUTPUT.PUT_LINE(v_birth);
END;
/
EXECUTE yedam_ju('9501011667777');
EXECUTE yedam_ju('1511013689977');

/*
    2.
    사원번호를 입력할 경우
    삭제하는 TEST_PRO 프로시저를 생성하시오.
    단, 해당사원이 없는 경우 "해당사원이 없습니다." 출력
    예) EXECUTE TEST_PRO(176)
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
        DBMS_OUTPUT.PUT_LINE('해당 사원이 없습니다');
END;
/
EXECUTE TEST_PRO(101);
EXECUTE TEST_PRO(800);
Rollback;

/*
    3.
    다음과 같이 PL/SQL 블록을 실행할 경우 
    사원번호를 입력할 경우 사원의 이름(last_name)의 첫번째 글자를 제외하고는
    '*'가 출력되도록 yedam_emp 프로시저를 생성하시오.
    
    실행) EXECUTE yedam_emp(176)
    실행결과) TAYLOR -> T*****  <- 이름 크기만큼 별표(*) 출력
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

