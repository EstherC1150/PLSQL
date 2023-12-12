--DBMS ���� ������ �Ͻ������� ����
--���ν����� ���������� �����ϱ� ���ؼ��� �� ������ ON�� �Ǿ��־�� �� 
SET SERVEROUTPUT ON

BEGIN
    DBMS_OUTPUT.PUT_LINE('Hi! PL/SQL');
END;
/

DECLARE
    v_today DATE;
    --Constant�� NOT NULL�� ���� �־�� �Ѵ�
    v_literal CONSTANT NUMBER(2,0) := 10;
    --�� ������ ����� �͸� �ҷ��� �� �� ����
    v_count NUMBER(3,0) := v_literal + 100;
    --varchar2(100) : (100 byte)�� ����
    v_msg VARCHAR2(100 char) NOT NULL := 'Hello, PL/SQL';
BEGIN
    --v_literal := 1234; --> ����� ���� ��������� �ϸ� ������
    DBMS_OUTPUT.PUT_LINE(v_count);
END;
/

BEGIN
    DBMS_OUTPUT.PUT_LINE(TO_CHAR(sysdate, 'yyyy"��"MM"��"dd"��"'));
    --�̷��� �ܵ����� ���� �Լ�, �׷��Լ��� �ǹ̰� ����
    COUNT(1);
END;
/

BEGIN
    INSERT INTO employee (empid, empname)
    values (1000, 'Hong');
END;
/

ROLLBACK;

--INSERT���� ��� ���� Ŀ���� �� ���� ������ ��ø�Ǽ� ���δ�
DECLARE
    v_sal NUMBER := 1000;
    v_comm NUMBER := v_sal * 0.1;
    v_msg VARCHAR2(1000) := '�ʱ�ȭ || ';
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
        v_msg := v_msg || '���κ�� || ';
        DBMS_OUTPUT.PUT_LINE('���� : ' || v_annual);
    END;
    --v_annual�� �ȿ��� ����ǰ� ������� �׷��� ������
    --v_annual := v_annual + 1000;
    v_msg := v_msg || '�ٱ� ���';
    DBMS_OUTPUT.PUT_LINE(v_msg);
END;
/
