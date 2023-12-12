DROP TABLE employee;
-- 6
CREATE TABLE department (
    deptid number(10) PRIMARY KEY,
    deptname varchar2(10),
    location varchar2(10),
    tel varchar(15)
);

CREATE TABLE employee (
    empid number(10) PRIMARY KEY,
    empname varchar2(10),
    hiredate date,
    addr varchar2(12),
    tel varchar2(15),
    deptid number(10) REFERENCES department(deptid)
    -- 테이블레벨로 걸기 ↓
    -- deptid NUMBER(10), 
    -- CONSTRAINT emp_dept_FK FOREIGN KEY(deptid) REFERENCES department(deptid)
);

DESC department;
DESC employee;

-- 7
ALTER TABLE employee
ADD birthday date;

-- 8 
INSERT INTO department values(1001, '총무팀', '본101호', '053-777-8777');
INSERT INTO department values(1002, '회계팀', '본102호', '053-888-9999');
INSERT INTO department values(1003, '영업팀', '본103호', '053-222-3333');

--TO_DATE
--INSERT INTO employee (empid, empname, hiredate, addr, tel,deptid) values(20121945, '박민수', TO_DATE('12/03/02', 'YY/MM/DD'), '대구', '010-1111-1234', 1001);

INSERT INTO employee (empid, empname, hiredate, addr, tel,deptid) values(20121945, '박민수', '2012-03-02', '대구', '010-1111-1234', 1001);
INSERT INTO employee (empid, empname, hiredate, addr, tel,deptid) values(20101817, '박준식', '2010-09-01', '경산', '010-2222-1234', 1003);
INSERT INTO employee (empid, empname, hiredate, addr, tel,deptid) values(20122245, '선아라', '2012-03-02', '대구', '010-3333-1222', 1002);
INSERT INTO employee (empid, empname, hiredate, addr, tel,deptid) values(20121729, '이범수', '2011-03-02', '서울', '010-3333-4444', 1001);
INSERT INTO employee (empid, empname, hiredate, addr, tel,deptid) values(20121646, '이융희', '2012-09-01', '부산', '010-1234-2222', 1003);

-- 9
ALTER TABLE employee
MODIFY empname not null;

-- 10 (교집합)
SELECT e.empname, e.hiredate, d.deptname
FROM employee e  JOIN department d ON (e.deptid = d.deptid)
WHERE d.deptname like '총무팀';

--SELECT e.empname, e.hiredate, d.deptname
--FROM employee e, department d
--WHERE e.deptid = d.deptid
--AND d.deptname = '총무팀';

--표준SQL
--SELECT e.empname, e.hiredate, d.deptname
--FROM employee e JOIN department d
--ON(e.deptid = d.deptid)
--WHERE d.deptname = '총무팀';

--*****모든 부서의 부서정보
--별칭을 붙이는걸 권장
SELECT e.employee_id, e.first_name, d.department_name
FROM employees e LEFT OUTER JOIN departments d
                                    ON(e.department_id = d.department_id);
--오라클조인 / 아우터조인(+)
SELECT e.employee_id, e.first_name, d.department_name
FROM employees e, departments d
WHERE e.department_id = d.department_id(+);

-- 11
DELETE FROM employee
WHERE addr = '대구';

-- 12
UPDATE employee
SET deptid = (SELECT deptid
                            FROM department
                            WHERE deptname = '회계팀')
WHERE deptid = (SELECT deptid
                                    FROM department
                                    WHERE deptname = '총무팀');

-- 13
--서브쿼리는 값을 대체하는 것으로 가장 많이 쓰임
--서브쿼리 쓸 때는 단일값으로...
SELECT e.empid, e.empname, e.birthday, d.deptname
FROM employee e JOIN department d ON (d.deptid = e.deptid)
WHERE hiredate > (SELECT hiredate
                                        FROM employee
                                        WHERE empid = 20121729);

--상호연관 서브쿼리 : 메인쿼리의 값을 사용하는 서브쿼리 형태
--동작이 일반적인 서브쿼리와는 다르다
--조인을 하지 않는다 하더라도 테이블 별칭이 붙어야한다 : 지정을해야하니까
SELECT empid,
                 empname,
                 (SELECT deptname FROM department WHERE deptid = e.deptid) AS deptname
FROM employee e;

-- 14
--뷰 : 특정셀렉트문을 단축키로 등록한것
--용도가 다양함
--뷰는 alter 없다
CREATE VIEW emp_chong
AS 
SELECT e.empname, e.addr, d.deptname
FROM employee e left join department d ON e.deptid = d.deptid
WHERE d.deptname like '총무팀';

--replace : 우리한테 안 알려준다 : 쓰는 거 주의하기
--CREATE OR REPLACE VIEW는 이미 같은 이름의 뷰를 생성할 경우 존재하고 있는 뷰를 갱신(덮어쓰기)하기도 합니다
CREATE OR REPLACE VIEW emp_vu
AS
    SELECT e.empname, e.addr, d.deptname
    FROM employee e JOIN department d ON (d.deptid = e.deptid)
    WHERE d.deptname = '총무팀';


-- rownum 넘버링
-- 페이징할때에 가장 이상적인것은 서브쿼리를 2번 쓰는것...
SELECT r.*
FROM (
                SELECT ROWNUM rn, e.*
                FROM employees e
                ORDER BY employee_id) r
WHERE rn BETWEEN 1 AND 10;


SELECT ROWNUM rn, e.*
                FROM employees e
                ORDER BY first_name;

