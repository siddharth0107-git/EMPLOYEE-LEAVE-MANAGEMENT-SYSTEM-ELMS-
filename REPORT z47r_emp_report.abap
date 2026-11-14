REPORT z47r_emp_report.

TYPE-POOLS: slis.

TABLES:
  z47t_emp,
  z47t_dept,
  z47t_leave,
  z47t_appr.


*---------------------------------------------------------------------*
* SELECTION SCREEN
*---------------------------------------------------------------------*

SELECTION-SCREEN BEGIN OF BLOCK b1
  WITH FRAME TITLE TEXT-001.

  SELECT-OPTIONS:
    empid FOR z47t_emp-empid,
    empnm FOR z47t_emp-empname,
    dept  FOR z47t_dept-dept_id,
    desig FOR z47t_emp-desig.

SELECTION-SCREEN END OF BLOCK b1.


SELECTION-SCREEN BEGIN OF BLOCK b2
  WITH FRAME TITLE TEXT-002.

  SELECT-OPTIONS:
    jdate FOR z47t_emp-joindate,
    sal   FOR z47t_emp-salary.

SELECTION-SCREEN END OF BLOCK b2.


SELECTION-SCREEN BEGIN OF BLOCK b3
  WITH FRAME TITLE TEXT-003.

  PARAMETERS:
    p_emp   RADIOBUTTON GROUP g1 DEFAULT 'X',
    p_leave RADIOBUTTON GROUP g1.

SELECTION-SCREEN END OF BLOCK b3.


*---------------------------------------------------------------------*
* START OF SELECTION
*---------------------------------------------------------------------*

START-OF-SELECTION.

  IF p_emp = 'X'.

    PERFORM display_employee_report.

  ELSE.

    PERFORM display_leave_report.

  ENDIF.


*---------------------------------------------------------------------*
* FORM: DISPLAY EMPLOYEE REPORT
*---------------------------------------------------------------------*

FORM display_employee_report.

  DATA:
    lt_fieldcat TYPE slis_t_fieldcat_alv,
    ls_fieldcat TYPE slis_fieldcat_alv,
    ls_layout   TYPE slis_layout_alv.

*---------------------------------------------------------------------*
* FETCH EMPLOYEE DATA
*---------------------------------------------------------------------*

  SELECT
    e~empid,
    e~empname,
    d~dept_name,
    e~desig,
    e~joindate,
    e~salary,
    e~email,
    e~phoneno

    FROM z47t_emp AS e

    LEFT OUTER JOIN z47t_dept AS d
      ON e~deptid = d~dept_id

    WHERE e~empid IN @empid
      AND e~empname IN @empnm
      AND e~deptid IN @dept
      AND e~desig IN @desig
      AND e~joindate IN @jdate
      AND e~salary IN @sal

    INTO TABLE @DATA(lt_emp).

*---------------------------------------------------------------------*
* CHECK EMPLOYEE DATA
*---------------------------------------------------------------------*

  IF lt_emp IS INITIAL.

    MESSAGE 'No employee records found'
      TYPE 'I'.

    RETURN.

  ENDIF.

*---------------------------------------------------------------------*
* FIELD CATALOG
*---------------------------------------------------------------------*

  CLEAR ls_fieldcat.

  ls_fieldcat-fieldname = 'EMPID'.
  ls_fieldcat-seltext_m = 'Employee ID'.

  APPEND ls_fieldcat TO lt_fieldcat.


  CLEAR ls_fieldcat.

  ls_fieldcat-fieldname = 'EMPNAME'.
  ls_fieldcat-seltext_m = 'Employee Name'.

  APPEND ls_fieldcat TO lt_fieldcat.


  CLEAR ls_fieldcat.

  ls_fieldcat-fieldname = 'DEPT_NAME'.
  ls_fieldcat-seltext_m = 'Department'.

  APPEND ls_fieldcat TO lt_fieldcat.


  CLEAR ls_fieldcat.

  ls_fieldcat-fieldname = 'DESIG'.
  ls_fieldcat-seltext_m = 'Designation'.

  APPEND ls_fieldcat TO lt_fieldcat.


  CLEAR ls_fieldcat.

  ls_fieldcat-fieldname = 'JOINDATE'.
  ls_fieldcat-seltext_m = 'Joining Date'.

  APPEND ls_fieldcat TO lt_fieldcat.


  CLEAR ls_fieldcat.

  ls_fieldcat-fieldname = 'SALARY'.
  ls_fieldcat-seltext_m = 'Salary'.

  APPEND ls_fieldcat TO lt_fieldcat.


  CLEAR ls_fieldcat.

  ls_fieldcat-fieldname = 'EMAIL'.
  ls_fieldcat-seltext_m = 'Email'.

  APPEND ls_fieldcat TO lt_fieldcat.


  CLEAR ls_fieldcat.

  ls_fieldcat-fieldname = 'PHONENO'.
  ls_fieldcat-seltext_m = 'Phone Number'.

  APPEND ls_fieldcat TO lt_fieldcat.

*---------------------------------------------------------------------*
* ALV LAYOUT
*---------------------------------------------------------------------*

  ls_layout-zebra = 'X'.

  ls_layout-colwidth_optimize = 'X'.

*---------------------------------------------------------------------*
* DISPLAY EMPLOYEE ALV
*---------------------------------------------------------------------*

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program = sy-repid
      i_grid_title       = 'EMPLOYEE DETAILS REPORT'
      is_layout          = ls_layout
      it_fieldcat        = lt_fieldcat
    TABLES
      t_outtab           = lt_emp
    EXCEPTIONS
      program_error      = 1
      OTHERS             = 2.

*---------------------------------------------------------------------*
* CHECK ALV DISPLAY
*---------------------------------------------------------------------*

  IF sy-subrc <> 0.

    MESSAGE 'Error displaying employee ALV report'
      TYPE 'I'.

  ENDIF.

ENDFORM.


*---------------------------------------------------------------------*
* FORM: DISPLAY LEAVE REPORT
*---------------------------------------------------------------------*

FORM display_leave_report.

  DATA:
    lt_fieldcat TYPE slis_t_fieldcat_alv,
    ls_fieldcat TYPE slis_fieldcat_alv,
    ls_layout   TYPE slis_layout_alv.

*---------------------------------------------------------------------*
* FETCH LEAVE DATA
*---------------------------------------------------------------------*

  SELECT
    e~empid,
    e~empname,
    d~dept_name,
    l~leaveid,
    l~from_date,
    l~to_date,
    l~leavedays,
    l~reason,
    a~appr_status,
    a~appr_comment

    FROM z47t_emp AS e

    INNER JOIN z47t_leave AS l
      ON e~empid = l~emp_id

    LEFT OUTER JOIN z47t_dept AS d
      ON e~deptid = d~dept_id

    LEFT OUTER JOIN z47t_appr AS a
      ON l~leaveid = a~leave_id

    WHERE e~empid IN @empid
      AND e~empname IN @empnm
      AND e~deptid IN @dept
      AND e~desig IN @desig
      AND e~joindate IN @jdate
      AND e~salary IN @sal

    INTO TABLE @DATA(lt_leave).

*---------------------------------------------------------------------*
* CHECK LEAVE DATA
*---------------------------------------------------------------------*

  IF lt_leave IS INITIAL.

    MESSAGE 'No leave records found'
      TYPE 'I'.

    RETURN.

  ENDIF.

*---------------------------------------------------------------------*
* FIELD CATALOG
*---------------------------------------------------------------------*

  CLEAR ls_fieldcat.

  ls_fieldcat-fieldname = 'EMPID'.
  ls_fieldcat-seltext_m = 'Employee ID'.

  APPEND ls_fieldcat TO lt_fieldcat.


  CLEAR ls_fieldcat.

  ls_fieldcat-fieldname = 'EMPNAME'.
  ls_fieldcat-seltext_m = 'Employee Name'.

  APPEND ls_fieldcat TO lt_fieldcat.


  CLEAR ls_fieldcat.

  ls_fieldcat-fieldname = 'DEPT_NAME'.
  ls_fieldcat-seltext_m = 'Department'.

  APPEND ls_fieldcat TO lt_fieldcat.


  CLEAR ls_fieldcat.

  ls_fieldcat-fieldname = 'LEAVEID'.
  ls_fieldcat-seltext_m = 'Leave ID'.

  APPEND ls_fieldcat TO lt_fieldcat.


  CLEAR ls_fieldcat.

  ls_fieldcat-fieldname = 'FROM_DATE'.
  ls_fieldcat-seltext_m = 'From Date'.

  APPEND ls_fieldcat TO lt_fieldcat.


  CLEAR ls_fieldcat.

  ls_fieldcat-fieldname = 'TO_DATE'.
  ls_fieldcat-seltext_m = 'To Date'.

  APPEND ls_fieldcat TO lt_fieldcat.


  CLEAR ls_fieldcat.

  ls_fieldcat-fieldname = 'LEAVEDAYS'.
  ls_fieldcat-seltext_m = 'Leave Days'.

  APPEND ls_fieldcat TO lt_fieldcat.


  CLEAR ls_fieldcat.

  ls_fieldcat-fieldname = 'REASON'.
  ls_fieldcat-seltext_m = 'Leave Reason'.

  APPEND ls_fieldcat TO lt_fieldcat.


  CLEAR ls_fieldcat.

  ls_fieldcat-fieldname = 'APPR_STATUS'.
  ls_fieldcat-seltext_m = 'Approval Status'.

  APPEND ls_fieldcat TO lt_fieldcat.


  CLEAR ls_fieldcat.

  ls_fieldcat-fieldname = 'APPR_COMMENT'.
  ls_fieldcat-seltext_m = 'Approval Comment'.

  APPEND ls_fieldcat TO lt_fieldcat.

*---------------------------------------------------------------------*
* ALV LAYOUT
*---------------------------------------------------------------------*

  ls_layout-zebra = 'X'.

  ls_layout-colwidth_optimize = 'X'.

*---------------------------------------------------------------------*
* DISPLAY LEAVE ALV
*---------------------------------------------------------------------*

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program = sy-repid
      i_grid_title       = 'EMPLOYEE LEAVE REPORT'
      is_layout          = ls_layout
      it_fieldcat        = lt_fieldcat
    TABLES
      t_outtab           = lt_leave
    EXCEPTIONS
      program_error      = 1
      OTHERS             = 2.

*---------------------------------------------------------------------*
* CHECK ALV DISPLAY
*---------------------------------------------------------------------*

  IF sy-subrc <> 0.

    MESSAGE 'Error displaying leave ALV report'
      TYPE 'I'.

  ENDIF.

ENDFORM.