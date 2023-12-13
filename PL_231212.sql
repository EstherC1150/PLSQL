SET SERVEROUTPUT ON

/*
    2. 치환변수(&)를 사용해서 숫자를 입력하면 해당 구구단이 출력되도록 하시오.
    예) 2 입력시
    2 * 1 = 2
    2 * 2 = 4
    2 * 3 = 6
    2 * 4 = 8
    2 * 5 = 10
    2 * 6 = 12
    2 * 7 = 14
    2 * 8 = 16
    2 * 9 = 18
    
    입력 : 단
    출력 : 특정 포맷 ( 단 * 곱하는 수 = 결과)
    
    => 곱하는 수 : 1에서 9 사이의 정수값
*/
-- 기본 LOOP
DECLARE
    -- 단 : 숫자타입, 치환변수 입력
    v_dan NUMBER(1,0) := &단;
    v_num NUMBER := 1;
BEGIN
    -- 반복문 시작
    LOOP
        -- 출력 : 단 * 곱하는 수 = (단 * 곱하는 수)
        DBMS_OUTPUT.PUT_LINE(v_dan || ' * ' || v_num || ' = ' || (v_dan * v_num));
        -- 이때 곱하는 수는 1부터 9까지 1씩 증가 => 반복문으로 제어
        v_num := v_num + 1;
        EXIT WHEN v_num > 9;
    END LOOP;
END;
/

-- FOR LOOP
DECLARE
    v_dan NUMBER(1,0) := &단;
BEGIN
    FOR v_num IN 1..9 LOOP
        DBMS_OUTPUT.PUT_LINE(v_dan || ' * ' || v_num || ' = ' || (v_dan * v_num));
    END LOOP;
END;
/

-- WHILE LOOP
DECLARE
    v_dan NUMBER(1,0) := &단;
    v_num NUMBER := 1;   
BEGIN
    WHILE v_num <= 9 LOOP
    DBMS_OUTPUT.PUT_LINE(v_dan || ' * ' || v_num || ' = ' || (v_dan * v_num));
    v_num := v_num + 1;
    END LOOP;
END;
/


/*
    3. 구구단 2~9단까지 출력되도록 하시오.
*/
BEGIN
    FOR v_num IN 2..9 LOOP
        DBMS_OUTPUT.PUT_LINE(v_num ||'단');
        FOR v_dan IN 1..9 LOOP
            DBMS_OUTPUT.PUT_LINE(v_num || ' * ' || v_dan || ' = ' || (v_dan * v_num));
        END LOOP;
    END LOOP;
END;
/

-- 옆으로 나란히 출력하기
DECLARE
    v_dan NUMBER(2,0) := 2;
    v_num NUMBER(2,0) := 1;
    v_msg VARCHAR2(1000);
BEGIN
    WHILE v_num < 10 LOOP
        v_dan := 2; -- 안쪽 루프에 사용되는 변수가 적절한 시기에 초기화 되어야 한다
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
    4. 구구단 1~9단까지 출력되도록 하시오.
        (단, 홀수단 출력)
*/
BEGIN
    FOR v_dan IN 1..9 LOOP
        IF mod(v_dan,2) = 1 THEN DBMS_OUTPUT.PUT_LINE(v_dan ||'단');
            FOR v_num IN 1..9 LOOP
                DBMS_OUTPUT.PUT_LINE(v_dan || ' * ' || v_num || ' = ' || (v_dan * v_num));
            END LOOP;
        END IF;
    END LOOP;
END;
/

-- FOR LOOP + IF문
BEGIN
    FOR v_dan IN 1..9 LOOP -- 특정 단을 2~9까지 반복하는 LOOP문
        IF MOD(v_dan,2) <> 0 THEN
            FOR v_num IN 1..9 LOOP -- 특정 단의 1~9까지 곱하는 LOOP문 
                DBMS_OUTPUT.PUT_LINE(v_dan || ' X ' || v_num || ' = ' || (v_dan * v_num));
            END LOOP;
            DBMS_OUTPUT.PUT_LINE('');
        END IF;
    END LOOP;
END;
/

-- FOR LOOP + IF문
-- CONTINUE 이용해서...
BEGIN
    FOR v_dan IN 1..9 LOOP
        IF MOD(v_dan, 2) = 0 THEN
            CONTINUE;   -- 왜 쓰냐면...들여쓰기 때문에...들여쓰기가 한 단계 더 안 들어가도 되니까 가독성을 위해서
        END IF;
            FOR v_num IN 1..9 LOOP
                DBMS_OUTPUT.PUT_LINE(v_dan || ' X ' || v_num || ' = ' || (v_dan * v_num));
            END LOOP;
        DBMS_OUTPUT.PUT_LINE('');
    END LOOP;
END;
/

-- RECORD : 변수쪽, 그래서 DECLARE쪽에 정의 해 주어야 함
-- 레코드는 전역이 아니고 로컬이다, 그 블럭 안에서만 사용 가능
DECLARE
    -- 이름에 type을 적어주면 좋다
    -- 블럭이 바뀌면 다시...
    TYPE info_rec_type IS RECORD
        ( no NUMBER NOT NULL := 1,
          name VARCHAR2(1000) := 'No Name',
          birth DATE);
    
    -- 변수 선언
    user_info info_rec_type;
BEGIN
    -- 변수 명만 put라인에 넣어서 출력하는 건 안됨
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
    WHERE employee_id = &사원번호;
    
    -- .필드로 접근하기
    DBMS_OUTPUT.PUT_LINE('사원번호 ' || emp_info_rec.employee_id);
    DBMS_OUTPUT.PUT_LINE('이름 ' || emp_info_rec.last_name);
    DBMS_OUTPUT.PUT_LINE('직무 ' || emp_info_rec.job_id);
END;
/

-- 사원번호, 이름, 부서이름 : 내부에 그 테이블을 제외한 컬럼 등을 불러오기 위해선 ROWTYPE이 한계가 있다
DECLARE
    TYPE emp_rec_type IS RECORD
         ( eid employees.employee_id%TYPE,  -- NUMBER
           ename employees.last_name%TYPE,  -- VARCHAR2
           deptname departments.department_name%TYPE);  -- VARCHAR2
    emp_rec emp_rec_type;
BEGIN
    -- 얘는 *를 사용할 수 없다 : 넘어오는 컬럼이 총 15개 : JOIN을 했으니까 : USING쓰면 중복 컬럼 제외해서 14개 넘어옴
    SELECT employee_id, last_name, department_name 
    INTO emp_rec
    FROM employees e JOIN departments d ON(e.department_id = d.department_id)
    WHERE employee_id = &사원번호;
    
    DBMS_OUTPUT.PUT_LINE('이름 : ' || emp_rec.ename);
END;
/

-- TABLE
DECLARE
    -- 1) 정의
    TYPE num_table_type IS TABLE OF NUMBER
         INDEX BY BINARY_INTEGER;
    -- 2) 선언
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
    -- 1) 정의
    TYPE num_table_type IS TABLE OF NUMBER
         INDEX BY BINARY_INTEGER;
    -- 2) 선언
    num_list num_table_type;
BEGIN
    FOR i IN 1..9 LOOP
        num_list(i) := 2 * 1;
    END LOOP;
    
    -- 순환하는 애를 가져올 때...
    FOR idx IN num_list.FIRST..num_list.LAST LOOP
        -- 테이블 내부에 있는 값을 가져올 때는 항상 확인 작업을 하기...
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



-- 모든 데이터를 다 들고오기
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
    
-- 교수님 풀이
DECLARE
    v_min employees.employee_id%TYPE; -- 최소 사원번호
    v_MAX employees.employee_id%TYPE; -- 최대 사원번호
    v_result NUMBER(1,0);             -- 사원의 존재유무를 확인
    emp_record employees%ROWTYPE;     -- Employees 테이블의 한 행에 대응
    
    TYPE emp_table_type IS TABLE OF emp_record%TYPE
        INDEX BY PLS_INTEGER;
    
    emp_table emp_table_type;
BEGIN
    -- 최소 사원번호, 최대 사원번호
    SELECT MIN(employee_id), MAX(employee_id)
    INTO v_min, v_max
    FROM employees;
    
    FOR eid IN v_min .. v_max LOOP
        SELECT COUNT(*)     -- 존재 여부를 체크
        INTO v_result
        FROM employees
        WHERE employee_id = eid;
        
        IF v_result = 0 THEN    -- 사원이 없다는 말
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
-- 한줄만 반환, 따라서 LOOP를 필수적으로 사용
DECLARE
    -- cursor 안에서는 순수한 select문 사용
    CURSOR emp_dept_cursor IS
        SELECT employee_id, last_name
        FROM employees
        WHERE department_id = &부서번호;
        
    v_eid employees.employee_id%TYPE;
    v_ename employees.last_name%TYPE;
BEGIN
    -- cursor OPEN
    -- select 문이 가지고 있는 결과가 메모리에 올라간다
    OPEN emp_dept_cursor;
    
    -- pointer가 첫번째로 이동
    -- 실제 우리에게 데이터가 넘어오는 순간
    FETCH emp_dept_cursor INTO v_eid, v_ename;
    DBMS_OUTPUT.PUT_LINE(v_eid);
    DBMS_OUTPUT.PUT_LINE(v_ename);
    
    CLOSE emp_dept_cursor;
    -- close가 된 후에는 접근하지 말기 : 접근을 하지 못함
END;
/
    SELECT employee_id, last_name
    FROM employees
    WHERE department_id = 50;
    
DECLARE
    CURSOR emp_info_cursor IS
        SELECT employee_id eid, last_name ename, hire_date hdate
        FROM employees
        WHERE department_id =&부서번호
        ORDER BY hire_date DESC;
        
    emp_rec emp_info_cursor%ROWTYPE;
BEGIN
    -- select한 결과를 기반으로 들고 오기 때문에 별칭을 사용해도 된다
    OPEN emp_info_cursor;
    
    LOOP
        -- FETCH와 EXIT WHEN은 같이 움직인다
        FETCH emp_info_cursor INTO emp_rec;
        EXIT WHEN emp_info_cursor%NOTFOUND;
        -- EXIT WHEN emp_info_cursor%NOTFOUND OR emp_info_cursor%ROWCOUNT > 10;
            -- ROWCOUNT : 어디에서 사용하느냐에 따라 의미가 달라짐 / LOOP 에서는 의미가 변한다
            -- 현재 가리키는 게 몇번째인지 는 LOOP 안에서의 의미
            -- 커서의 총 데이터 숫자 : 몇개를 들고있는데? 는 LOOP 밖에서
        -- EXIT WHEN emp_info_cursor%ROWCOUNT > 10;
        DBMS_OUTPUT.PUT(emp_info_cursor%ROWCOUNT || ', ');
        DBMS_OUTPUT.PUT(emp_rec.eid || ', ');
        DBMS_OUTPUT.PUT(emp_rec.ename || ', ');
        DBMS_OUTPUT.PUT_LINE(emp_rec.hdate);
    END LOOP;
    -- 커서의 총 데이터 숫자
    -- 얘는 ↓ close 되기 전에 해당 코드를 확인해야 한다
    IF emp_info_cursor%ROWCOUNT = 0 THEN
        DBMS_OUTPUT.PUT_LINE('현재 커서의 데이터는 존재하지 않습니다.');
    END IF;
    
    -- 커서는 문법적인 문제가 있지 않는 이상 안에 내용이 없어도 오류가 없음
    CLOSE emp_info_cursor;
END;
/

-- 1) 모든 사원의 사원번호, 이름, 부서이름 출력
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
    
-- 2) 부서번호가 50이거나 80인 사원들의 사원이름, 급여, 연봉 출력
-- 연봉 : (급여 * 12 + (NVL(급여, 0) * NVL(커미션, 0) * 12))
-- 2-1)
DECLARE
    CURSOR emp_sal_cursor IS
        SELECT department_id, employee_id, last_name, salary, (salary * 12 + (NVL(salary, 0) * NVL(commission_pct, 0) * 12)) total
        FROM employees
        WHERE department_id IN(50,80)   -- OR이 틀린건 아니지만 : 보기 중에서 하나 >> IN 연산자
        ORDER BY department_id;
        
    emp_rec emp_sal_cursor%ROWTYPE;
BEGIN
    IF NOT emp_sal_cursor%ISOPEN THEN   -- cursor가 close된 상태에서 유일하게 접근 할 수 있다
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
    
    -- 다 썼다 싶으면 close하기 : 누수가 발생 될 수도 있음
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

