SET SERVEROUTPUT ON

DECLARE
    v_eid NUMBER;
    v_ename employees.first_name%TYPE;
    v_job VARCHAR2(1000);
BEGIN
    SELECT employee_id, first_name, job_id
    INTO v_eid, v_ename, v_job
    FROM employees
    WHERE employee_id = 100;
    
    DBMS_OUTPUT.PUT_LINE('사원번호 : ' || v_eid);
    DBMS_OUTPUT.PUT_LINE('사원이름 : ' || v_ename);
    DBMS_OUTPUT.PUT_LINE('업무 : ' || v_job);
END;
/

DECLARE
    -- 문자를 입력 받을 때에는 ' ' 붙여준다!
    v_eid employees.employee_id%TYPE := &사원번호;
    v_ename employees.last_name%TYPE;
BEGIN
    SELECT first_name || ', ' || last_name
    INTO v_ename
    FROM employees
    WHERE employee_id = v_eid;
    
    DBMS_OUTPUT.PUT_LINE('사원번호 : ' || v_eid);
    DBMS_OUTPUT.PUT_LINE('사원이름 : ' || v_ename);
END;
/

-- BEGIN 안에 SELECT절을 밖에서 먼저 확인하고 실행하기
-- 1) 특정 사원의 매니저에 해당하는 사원번호를 출력 (특정 사원은 치환변수를 사용해서 입력)
DECLARE
    v_eid employees.employee_id%TYPE := &사원번호;
    v_ename employees.last_name%TYPE;
    v_mgr employees.manager_id%TYPE;
BEGIN
    SELECT first_name || ', ' || last_name, manager_id
    INTO v_ename, v_mgr
    FROM employees
    WHERE employee_id = v_eid;
    
    --SELECT manager_id
    --INTO v_mgr
    --FROM employees
    --WHERE employee_id = &사원번호;
    --DBMS_OUTPUT.PUT_LINE('상사번호 : ' || v_mgr);
    
    DBMS_OUTPUT.PUT_LINE('사원번호 : ' || v_eid);
    DBMS_OUTPUT.PUT_LINE('사원이름 : ' || v_ename);
    DBMS_OUTPUT.PUT_LINE('담당매니저 : ' || v_emag);
END;
/

-- INSERT, UPDATE
DECLARE
    v_deptno departments.department_id%TYPE;
    v_comm employees.commission_pct%TYPE := 0.1;
BEGIN
    SELECT department_id
    INTO v_deptno
    FROM employees
    WHERE employee_id = &사원번호;
    
    INSERT INTO employees(employee_id, last_name, email, hire_date, job_id, department_id)
    VALUES (1000, 'Hong', 'hkd@google.com', sysdate, 'IT_PROG', v_deptno);
    
    DBMS_OUTPUT.PUT_LINE('등록 결과 : ' || SQL%ROWCOUNT);
    
    UPDATE employees
    SET salary = (NVL(salary, 0) + 10000) * v_comm
    WHERE employee_id = 1000;
    
    DBMS_OUTPUT.PUT_LINE('수정 결과 : ' || SQL%ROWCOUNT);
    
END;
/
ROLLBACK;
SELECT * FROM employees WHERE employee_id = 1000;


BEGIN
    DELETE FROM employees
    WHERE employee_id = &사원번호;
    
    IF SQL%ROWCOUNT = 0 THEN
        DBMS_OUTPUT.PUT_LINE('해당 사원은 존재하지 않습니다.');
    END IF;
END;
/


/*
    1. 사원번호를 입력할 경우
    사원번호, 사원이름, 부서이름을
    출력하는 PL/SQL을 작성하시오.
    사원번호는 치환변수를 통해 입력받습니다.
*/
DECLARE
    v_eid employees.employee_id%TYPE;
    v_ename employees.last_name%TYPE;
    dept_n departments.department_name%TYPE;
BEGIN
    SELECT employee_id, last_name, department_name
    INTO v_eid, v_ename, dept_n
    FROM employees e JOIN departments d ON (e.department_id = d.department_id)
    WHERE employee_id= &사원번호;
    
    /*
    SELECT employee_id, first_name, department_id
    INTO v_empid, v_ename, v_deptid
    FROM employees
    WHERE employee_id = &사원번호;
    
    SELECT department_name
    INTO v_deptname
    FROM departments
    WHERE department_id = v_deptid;
    */
    
    DBMS_OUTPUT.PUT_LINE('사원번호 : ' || v_eid);
    DBMS_OUTPUT.PUT_LINE('사원이름 : ' || v_ename);
    DBMS_OUTPUT.PUT_LINE('부서 : ' || dept_n);
END;
/

/*
    2. 사원번호를 입력할 경우
    사원이름, 급여, 연봉을 출력하는 PL/SQL을 작성하시오.
    사원번호는 치환변수를 사용하고 연봉은 아래의 공식을 기반으로 연산하시오.
    (급여 * 12 + (NVL(급여, 0) * NVL(커미션, 0) * 12))
*/
DECLARE
    v_ename employees.last_name%TYPE;
    v_sal employees.salary%TYPE;
    v_total v_sal%TYPE;
BEGIN
    SELECT last_name, salary, (salary * 12 + (NVL(salary, 0) * NVL(commission_pct, 0) * 12))
    INTO v_ename, v_sal, v_total
    FROM employees
    WHERE employee_id = &사원번호;
    
    DBMS_OUTPUT.PUT_LINE('사원이름 : ' || v_ename);
    DBMS_OUTPUT.PUT_LINE('사원급여 : ' || v_sal);
    DBMS_OUTPUT.PUT_LINE('연봉 : ' || v_total);
    
    /*
    별도 연산 방법
    DECLARE 에 변수 하나가 더 들어간다
    SELECT last_name, salary, commission_pct
    ...
    v_annual := v_sal * 12 + NVL(v_sal, 0) * NVL(v_total, 0) * 12;
    
    DBMS_OUTPUT.PUT_LINE('연봉 : ' || v_annual);
    */
END;
/

    SELECT last_name, salary, (salary * 12 + (NVL(salary, 0) * NVL(commission_pct, 0) * 12)) AS total
    FROM employees
    WHERE employee_id = 100;
    

-- 기본 IF문
BEGIN
    DELETE FROM employees
    WHERE employee_id = &사원번호;
    
    IF SQL%ROWCOUNT = 0 THEN
        DBMS_OUTPUT.PUT_LINE('정상적으로 실행되지 않았습니다.');
        DBMS_OUTPUT.PUT_LINE('해당 사원은 존재하지 않습니다.');
    END IF;
END;
/

-- IF ~ ELSE문 :  팀장급
DECLARE
    v_count NUMBER;
BEGIN
    SELECT COUNT(employee_id)
    INTO v_count
    FROM employees
    WHERE manager_id = &eid;

    If v_count = 0 THEN
        DBMS_OUTPUT.PUT_LINE('일반 사원입니다.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('팀장입니다.');
    END IF;
END;
/

-- IF ~ ELSIF ~ ELSE 문 : 연차
DECLARE
    v_hdate NUMBER;
BEGIN
    SELECT TRUNC(MONTHS_BETWEEN(sysdate, hire_date) / 12)
    INTO v_hdate
    FROM employees
    WHERE employee_id = &사원번호;
    
    IF v_hdate < 5 THEN    -- 입사한 지 5년 미만
            DBMS_OUTPUT.PUT_LINE('입사한 지 5년 미만입니다..');
    ELSIF v_hdate < 10 THEN     -- 입사한 지 5년 이상 10년 미만
            DBMS_OUTPUT.PUT_LINE('입사한 지 10년 미만입니다..');
    ELSIF v_hdate < 15 THEN     -- 입사한 지 10년 이상 15년 미만
            DBMS_OUTPUT.PUT_LINE('입사한 지 15년 미만입니다..');    
    ELSIF v_hdate < 20 THEN     -- 입사한 지 15년 이상 20년 미만
            DBMS_OUTPUT.PUT_LINE('입사한 지 20년 미만입니다..');    
    END IF;
END;
/

    SELECT employee_id, TRUNC(MONTHS_BETWEEN(sysdate, hire_date) / 12), TRUNC((sysdate-hire_date) / 365)
    FROM employees
    ORDER BY 2 DESC;
    
/*
    3-1.
    사원번호를 입력(치환변수사용&)할 경우
    입사일이 2005년 이후(2005년 포함)이면 'New employee' 출력
                     2005년 이전이면 'Career employee' 출력
    >> 함수를 쓰면 가장 좋다
    // 입력 : 사원번호
    // 출력 : 입사일
    // 조건문(IF)문 -> 입사일 >= 2005년 'New employee' 출력
                                  아니면 'Career employee' 출력
*/
-- rr yy : 날짜를 나타내는...

-- 1) 날짜 그대로 비교하는 경우
DECLARE
     v_hdate DATE;
BEGIN
    SELECT hire_date
    INTO v_hdate
    FROM employees
    WHERE employee_id = &사원번호;
        
    IF v_hdate >=  TO_DATE('2005-01-01', 'yyyy-MM-dd') THEN
            DBMS_OUTPUT.PUT_LINE('New employee');
    ELSE
            DBMS_OUTPUT.PUT_LINE('Career employee');
    END IF;
    
END;
/
-- 2) 년도만 비교하는 경우
DECLARE
     v_year CHAR(4 char);
BEGIN
    SELECT TO_CHAR(hire_date, 'yyyy')
    INTO v_year
    FROM employees
    WHERE employee_id = &사원번호;
        
    IF v_year >=  '2005' THEN
            DBMS_OUTPUT.PUT_LINE('New employee');
    ELSE
            DBMS_OUTPUT.PUT_LINE('Career employee');
    END IF;
    
END;
/

/*
    3-2.
    사원번호를 입력(치환변수사용&) 할 경우
    입사일이 2005년 이후(2005년 포함) 이면 'New employee' 출력
                     2005년 이전이면 'Career employee' 출력
    단, DBMS_OUTPUT.PUT_LINE()은 코드 상 한번만 작성
*/
DECLARE
    v_year CHAR(4 char);
     -- v_msg VARCHAR2(1000);
    v_msg VARCHAR2(1000) := 'Career employee';
BEGIN
    SELECT TO_CHAR(hire_date, 'yyyy')
    INTO v_year
    FROM employees
    WHERE employee_id = &사원번호;
    
    /*        
    IF v_year >=  '2005' THEN
            v_msg := 'New employee';
    ELSE
            v_msg := 'Career employee';
    END IF;
    DBMS_OUTPUT.PUT_LINE(v_msg);
    */
    IF v_year >= '2005' THEN
        v_msg := 'New employee';
    END IF;
    DBMS_OUTPUT.PUT_LINE(v_msg);
        
END;
/

/*
    4.
    급여가 5000이하이면 20% 인상된 급여
    급여가 10000이하이면 15% 인상된 급여
    급여가 15000이하이면 10% 인상된 급여
    급여가 15001이상이면 급여 인상 없음
    
    사원번호를 입력(치환변수) 하면 사원이름, 급여, 인상된 급여가 출력되도록 PL/SQL 블록을 생성하시오
    
    입력 : 사원번호
    출력 : 사원이름, 급여
*/
DECLARE
    v_ename employees.last_name%TYPE;
    v_sal employees.salary%TYPE;
    v_upSal NUMBER := 0;
BEGIN
    SELECT last_name, salary
    INTO v_ename, v_sal
    FROM employees
    WHERE employee_id = &사원번호;
    
    IF v_sal <= 5000 THEN
        v_upSal := 20;
    ELSIF v_sal <= 10000 THEN
        v_upSal := 15;
    ELSIF v_sal <= 15000 THEN
        v_upSal := 10;
    END IF;
    
    DBMS_OUTPUT.PUT_LINE('사원이름 : ' || v_ename);
    DBMS_OUTPUT.PUT_LINE('급여 : ' || v_sal);
    DBMS_OUTPUT.PUT_LINE('인상된 급여 : ' || (v_sal * (1 + v_upSal / 100)));
    
END;
/

 SELECT last_name, salary, (salary + (salary * 0.2))
 FROM employees
 WHERE employee_id = 100;
 
 -- LOOP
 -- 1에서 10까지 정수값을 더한 결과를 출력
 -- 기본 LOOP(조건 없이 계속 반복) : EXIT 항상 존재 기본 루프문 안에
 DECLARE
    v_num NUMBER(2,0) := 1;     -- 1 ~ 10
    v_sum NUMBER(2,0) := 0;     -- 결과 
BEGIN
    LOOP
        DBMS_OUTPUT.PUT_LINE(v_num);
        v_sum := v_sum + v_num;
        v_num := v_num + 1;
        EXIT WHEN v_num > 10;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('====');
    DBMS_OUTPUT.PUT_LINE(v_sum);
 END;
 /
 
 -- WHIE LOOP
  DECLARE
    v_num NUMBER(2,0) := 1;     -- 1 ~ 10
    v_sum NUMBER(2,0) := 0;     -- 결과 
BEGIN
    WHILE v_num <= 10 LOOP
        DBMS_OUTPUT.PUT_LINE(v_num);
        v_sum := v_sum + v_num;
        v_num := v_num + 1;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('====');
    DBMS_OUTPUT.PUT_LINE(v_sum);
 END;
 /
 
 -- FOR LOOP 
-- 1) FOR LOOP의 임시변수 => DECLARE절에 정의된 변수이름과 같으면 안됨
 DECLARE
    v_sum NUMBER(2,0) := 0;
    v_n NUMBER(2,0) := 99;
 BEGIN
 -- 내부에 선언되는 변수는 사라짐, 구별된 형태로 쓰는게 좋다
    --FOR v_n  IN 1..10 LOOP
    FOR num  IN 1..10 LOOP
        v_sum := v_sum + num;
        --DBMS_OUTPUT.PUT_LINE(v_n);
    END LOOP;
    --DBMS_OUTPUT.PUT_LINE('===');
    --DBMS_OUTPUT.PUT_LINE(v_n);
    DBMS_OUTPUT.PUT_LINE(v_sum);
 END;
 /
 
-- 2) FOR LOOP는 기본적으로 오름차순 정렬, 내림차순으로 값을 받아오고자 한다면 REVERSE를 사용해야 함
  DECLARE
    v_n NUMBER(2,0) := 99;
 BEGIN
 -- 내부에 선언되는 변수는 사라짐, 구별된 형태로 쓰는게 좋다
 -- 임시변수는 readOnly
    FOR v_n  IN REVERSE 1..10 LOOP
    --FOR v_n IN 10..1 LOOP >> 이렇게 하면 FOR문이 안 열림 따라서 REVERSE 사용
        DBMS_OUTPUT.PUT_LINE(v_n);
    END LOOP;
    DBMS_OUTPUT.PUT_LINE(v_n);
 END;
 /
 
 /*
    1. 다음과 같이 출력되도록 하시오.
    *               -- 첫번째 줄, *가 하나
    **              -- 두번째 줄, *가 두개
    ***             -- 세번째 줄, *가 세개
    ****            -- 네번째 줄, *가 네개
    *****           -- 다섯번째 줄, *가 다섯개
    ||
 */
 --이중루프 써서 해보기
-- 1)  DBMS_OUTPUT.PUT_LINE();
 BEGIN
    FOR line IN 1..5 LOOP       -- 라인, 줄
        FOR star IN 1..line LOOP    -- 별(*)
            DBMS_OUTPUT.PUT('*');
        END LOOP;
    DBMS_OUTPUT.PUT_LINE('');
    END LOOP;
END;
 /
 
-- 2) DBMS_OUTPUT.PUT();
DECLARE
    v_cnt   NUMBER(1,0) := 1;
    v_str   NUMBER(1,0) := 1;
BEGIN
    LOOP
        v_str := 1;     -- 여기서 포인트! 시작하기 전에 반드시 초기화 되어주어야 함
        LOOP
            DBMS_OUTPUT.PUT('*');
            v_str := v_str + 1;
            EXIT WHEN v_str > v_cnt;
        END LOOP;
        DBMS_OUTPUT.PUT_LINE('');
        v_cnt := v_cnt + 1;
        EXIT WHEN v_cnt > 5;
    END LOOP;
END;
/
    
-- --------------------------------------------------------------------------------- 
 -- 기본 LOOP
DECLARE
    v_str   VARCHAR2(6 char) := '';
    v_cnt   NUMBER(1, 0)  := 1;
 BEGIN
     LOOP
            v_str := v_str || '*';
            DBMS_OUTPUT.PUT_LINE(v_str);
            v_cnt := v_cnt + 1;
            EXIT WHEN v_cnt > 5;
        END LOOP;
 END;
 /

-- WHILE LOOP
DECLARE
    v_cnt   NUMBER := 1;
    v_str   VARCHAR2(6 char) := '';
 BEGIN
     WHILE v_cnt <= 5 LOOP
            v_str := v_str || '*';
            DBMS_OUTPUT.PUT_LINE(v_str);
            v_cnt := v_cnt + 1;
        END LOOP;
 END;
 /
 
 -- 또다른 방법 >> LENGTH쓰기
DECLARE
    v_str   VARCHAR2(6 char) := '*';
 BEGIN
    WHILE LENGTH(v_str) <= 5 LOOP
        DBMS_OUTPUT.PUT_LINE(v_str);
        v_str := v_str || '*';
    END LOOP;
 END;
 /
 
-- FOR LOOP
DECLARE
    v_str   VARCHAR2(6 char) := '';
 BEGIN
    --FOR IN 사이에 있는 변수는 readOnly임
    FOR num IN 1..5 LOOP
        v_str := v_str || '*';
        DBMS_OUTPUT.PUT_LINE(v_str);
    END LOOP;
 END;
 /

 
 
 
 
 
 
 
 
 
 
 
 
 
 
 