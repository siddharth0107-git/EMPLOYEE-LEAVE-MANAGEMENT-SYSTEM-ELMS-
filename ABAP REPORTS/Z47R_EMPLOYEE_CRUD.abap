REPORT Z47R_EMPLOYEE_CRUD.

TABLES: Z47T_EMP.

*---------------------------------------------------------------------*
* OPERATION
*---------------------------------------------------------------------*
SELECTION-SCREEN BEGIN OF BLOCK B1 WITH FRAME TITLE TEXT-001.

  PARAMETERS:
    P_ADD  RADIOBUTTON GROUP G1 DEFAULT 'X',
    P_READ RADIOBUTTON GROUP G1,
    P_EDIT RADIOBUTTON GROUP G1,
    P_DEL  RADIOBUTTON GROUP G1.

SELECTION-SCREEN END OF BLOCK B1.

*---------------------------------------------------------------------*
* EMPLOYEE DETAILS
*---------------------------------------------------------------------*
SELECTION-SCREEN BEGIN OF BLOCK B2 WITH FRAME TITLE TEXT-002.

  PARAMETERS:
    P_EMPID  TYPE Z47T_EMP-EMPID OBLIGATORY,
    P_NAME   TYPE Z47T_EMP-EMPNAME,
    P_DEPT   TYPE Z47T_EMP-DEPTID,
    P_DESIG  TYPE Z47T_EMP-DESIG,
    P_JDATE  TYPE Z47T_EMP-JOINDATE,
    P_SALARY TYPE Z47T_EMP-SALARY,
    P_EMAIL  TYPE Z47T_EMP-EMAIL,
    P_PHONE  TYPE Z47T_EMP-PHONENO.

SELECTION-SCREEN END OF BLOCK B2.

*---------------------------------------------------------------------*
* DATA
*---------------------------------------------------------------------*
DATA: LS_EMP TYPE Z47T_EMP.

*---------------------------------------------------------------------*
* CRUD PROCESSING
*---------------------------------------------------------------------*
START-OF-SELECTION.

  CLEAR LS_EMP.

  CASE 'X'.

*---------------------------------------------------------------------*
* CREATE
*---------------------------------------------------------------------*
    WHEN P_ADD.

      SELECT SINGLE *
        FROM Z47T_EMP
        INTO LS_EMP
        WHERE EMPID = P_EMPID.

      IF SY-SUBRC = 0.
        MESSAGE 'Employee ID already exists' TYPE 'I'.
        RETURN.
      ENDIF.

      LS_EMP-MANDT   = SY-MANDT.
      LS_EMP-EMPID   = P_EMPID.
      LS_EMP-EMPNAME = P_NAME.
      LS_EMP-DEPTID  = P_DEPT.
      LS_EMP-DESIG   = P_DESIG.
      LS_EMP-JOINDATE = P_JDATE.
      LS_EMP-SALARY  = P_SALARY.
      LS_EMP-EMAIL   = P_EMAIL.
      LS_EMP-PHONENO = P_PHONE.

      INSERT Z47T_EMP FROM LS_EMP.

      IF SY-SUBRC = 0.
        COMMIT WORK AND WAIT.
        MESSAGE 'Employee created successfully' TYPE 'S'.
      ELSE.
        ROLLBACK WORK.
        MESSAGE 'Error creating employee' TYPE 'I'.
      ENDIF.

*---------------------------------------------------------------------*
* READ
*---------------------------------------------------------------------*
    WHEN P_READ.

      SELECT SINGLE *
        FROM Z47T_EMP
        INTO LS_EMP
        WHERE EMPID = P_EMPID.

      IF SY-SUBRC = 0.
        WRITE: / 'Employee ID:', LS_EMP-EMPID,
               / 'Name:', LS_EMP-EMPNAME,
               / 'Department:', LS_EMP-DEPTID,
               / 'Designation:', LS_EMP-DESIG,
               / 'Join Date:', LS_EMP-JOINDATE,
               / 'Salary:', LS_EMP-SALARY,
               / 'Email:', LS_EMP-EMAIL,
               / 'Phone:', LS_EMP-PHONENO.
      ELSE.
        MESSAGE 'Employee not found' TYPE 'I'.
      ENDIF.

*---------------------------------------------------------------------*
* EDIT
*---------------------------------------------------------------------*
    WHEN P_EDIT.

      SELECT SINGLE *
        FROM Z47T_EMP
        INTO LS_EMP
        WHERE EMPID = P_EMPID.

      IF SY-SUBRC <> 0.
        MESSAGE 'Employee not found' TYPE 'I'.
        RETURN.
      ENDIF.

      LS_EMP-EMPNAME  = P_NAME.
      LS_EMP-DEPTID   = P_DEPT.
      LS_EMP-DESIG    = P_DESIG.
      LS_EMP-JOINDATE = P_JDATE.
      LS_EMP-SALARY   = P_SALARY.
      LS_EMP-EMAIL    = P_EMAIL.
      LS_EMP-PHONENO  = P_PHONE.

      UPDATE Z47T_EMP FROM LS_EMP.

      IF SY-SUBRC = 0.
        COMMIT WORK AND WAIT.
        MESSAGE 'Employee updated successfully' TYPE 'S'.
      ELSE.
        ROLLBACK WORK.
        MESSAGE 'Error updating employee' TYPE 'I'.
      ENDIF.

*---------------------------------------------------------------------*
* DELETE
*---------------------------------------------------------------------*
    WHEN P_DEL.

      DELETE FROM Z47T_EMP
        WHERE EMPID = P_EMPID.

      IF SY-SUBRC = 0.
        COMMIT WORK AND WAIT.
        MESSAGE 'Employee deleted successfully' TYPE 'S'.
      ELSE.
        ROLLBACK WORK.
        MESSAGE 'Employee not found or could not be deleted' TYPE 'I'.
      ENDIF.

  ENDCASE.