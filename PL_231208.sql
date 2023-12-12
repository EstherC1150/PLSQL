--DBMS 내부 설정을 일시적으로 변경
--프로시저가 정상적으로 동작하기 위해서는 이 설정이 ON이 되어있어야 함 
SET SERVEROUTPUT ON

BEGIN
    DBMS_OUTPUT.PUT_LINE('Hi! PL/SQL');
END;
/

DECLARE
    v_today DATE;
    --Constant와 NOT NULL은 값이 있어야 한다
    v_literal CONSTANT NUMBER(2,0) := 10;
    --나 이전에 선언된 것만 불러서 쓸 수 있음
    v_count NUMBER(3,0) := v_literal + 100;
    --varchar2(100) : (100 byte)와 같음
    v_msg VARCHAR2(100 char) NOT NULL := 'Hello, PL/SQL';
BEGIN
    --v_literal := 1234; --> 상수에 값을 집어넣으려 하면 오류남
    DBMS_OUTPUT.PUT_LINE(v_count);
END;
/

BEGIN
    DBMS_OUTPUT.PUT_LINE(TO_CHAR(sysdate, 'yyyy"년"MM"월"dd"일"'));
    --이렇게 단독으로 들어가는 함수, 그룹함수는 의미가 없다
    COUNT(1);
END;
/

BEGIN
    INSERT INTO employee (empid, empname)
    values (1000, 'Hong');
END;
/

ROLLBACK;

--INSERT같은 경우 각각 커밋을 해 주지 않으면 중첩되서 묶인다
DECLARE
    v_sal NUMBER := 1000;
    v_comm NUMBER := v_sal * 0.1;
    v_msg VARCHAR2(1000) := '초기화 || ';
BEGIN
    INSERT INTO employee (empid, empname)
    values (1000, 'Hong');
    COMMIT;
    DECLARE
        v_sal NUMBER := 9999;
        v_comm NUMBER := v_sal * 0.2;
        v_annual NUMBER;
    BEGIN
        INSERT INTO employee (empid, empname)
        values (1000, 'Hong');
        COMMIT;
        v_annual := (v_sal + v_comm) * 12;
        v_msg := v_msg || '내부블록 || ';
        DBMS_OUTPUT.PUT_LINE('연봉 : ' || v_annual);
    END;
    --v_annual은 안에서 실행되고 사라졌다 그래서 오류남
    --v_annual := v_annual + 1000;
    v_msg := v_msg || '바깥 블록';
    DBMS_OUTPUT.PUT_LINE(v_msg);
END;
/
