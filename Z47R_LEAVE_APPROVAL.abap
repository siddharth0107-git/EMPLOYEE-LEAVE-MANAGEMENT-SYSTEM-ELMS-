REPORT Z47R_LEAVE_APPROVAL.

TABLES:
  Z47T_LEAVE,
  Z47T_EMP,
  Z47T_APPR.

*---------------------------------------------------------------------*
* SELECTION SCREEN
*---------------------------------------------------------------------*

SELECTION-SCREEN BEGIN OF BLOCK B1
  WITH FRAME TITLE TEXT-001.

  SELECTION-SCREEN COMMENT /1(25) TEXT-004 FOR FIELD P_LEAVE.
  PARAMETERS P_LEAVE TYPE Z47T_LEAVE-LEAVEID OBLIGATORY.

  SELECTION-SCREEN COMMENT /1(25) TEXT-008 FOR FIELD P_REASON.
  PARAMETERS P_REASON TYPE Z47T_LEAVE-REASON.

SELECTION-SCREEN END OF BLOCK B1.

SELECTION-SCREEN BEGIN OF BLOCK B2
  WITH FRAME TITLE TEXT-003.

  SELECTION-SCREEN COMMENT /1(15) TEXT-005 FOR FIELD P_APPR.
  PARAMETERS P_APPR RADIOBUTTON GROUP G1 DEFAULT 'X'.

  SELECTION-SCREEN COMMENT /1(15) TEXT-007 FOR FIELD P_REJ.
  PARAMETERS P_REJ RADIOBUTTON GROUP G1.

  SELECTION-SCREEN COMMENT /1(25) TEXT-006 FOR FIELD P_COMM.
  PARAMETERS P_COMM TYPE Z47T_APPR-APPR_COMMENT.

SELECTION-SCREEN END OF BLOCK B2.

*---------------------------------------------------------------------*
* START OF SELECTION
*---------------------------------------------------------------------*

START-OF-SELECTION.
  PERFORM PROCESS_LEAVE_APPROVAL.

*---------------------------------------------------------------------*
* MAKE REASON FIELD DISPLAY-ONLY
*---------------------------------------------------------------------*

AT SELECTION-SCREEN OUTPUT.
  LOOP AT SCREEN.
    IF SCREEN-NAME = 'P_REASON'.
      SCREEN-INPUT = 0.
      MODIFY SCREEN.
    ENDIF.
  ENDLOOP.

*---------------------------------------------------------------------*
* DISPLAY REASON WHEN LEAVE ID IS ENTERED
*---------------------------------------------------------------------*

AT SELECTION-SCREEN ON P_LEAVE.
  CLEAR P_REASON.

  SELECT SINGLE REASON
    FROM Z47T_LEAVE
    INTO P_REASON
    WHERE LEAVEID = P_LEAVE.

*---------------------------------------------------------------------*
* F4 HELP: SHOW LEAVE REQUESTS WITHOUT APPROVAL RECORDS
*---------------------------------------------------------------------*

AT SELECTION-SCREEN ON VALUE-REQUEST FOR P_LEAVE.

  TYPES: BEGIN OF TY_LEAVE_HELP,
           LEAVEID TYPE Z47T_LEAVE-LEAVEID,
           EMP_ID  TYPE Z47T_LEAVE-EMP_ID,
           REASON  TYPE Z47T_LEAVE-REASON,
         END OF TY_LEAVE_HELP.

  DATA: LT_LEAVE_HELP TYPE STANDARD TABLE OF TY_LEAVE_HELP.

  SELECT L~LEAVEID,
         L~EMP_ID,
         L~REASON
    FROM Z47T_LEAVE AS L
    LEFT OUTER JOIN Z47T_APPR AS A
      ON A~LEAVE_ID = L~LEAVEID
    WHERE A~LEAVE_ID IS NULL
    INTO TABLE @LT_LEAVE_HELP.

  CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
    EXPORTING
      RETFIELD    = 'LEAVEID'
      DYNPPROG    = SY-REPID
      DYNPNR      = SY-DYNNR
      DYNPROFIELD = 'P_LEAVE'
      VALUE_ORG   = 'S'
    TABLES
      VALUE_TAB   = LT_LEAVE_HELP
    EXCEPTIONS
      OTHERS      = 1.

*---------------------------------------------------------------------*
* FORM: PROCESS LEAVE APPROVAL
*---------------------------------------------------------------------*

FORM PROCESS_LEAVE_APPROVAL.

  DATA:
    LS_LEAVE     TYPE Z47T_LEAVE,
    LS_EMP       TYPE Z47T_EMP,
    LS_APPR      TYPE Z47T_APPR,
    LS_FORM      TYPE Z47S_LEAVE_DATA,
    LV_MAX_ID    TYPE Z47T_APPR-APPROVAL_ID,
    LV_FORM_NAME TYPE TDSFNAME,
    LV_FUNCTION  TYPE RS38L_FNAM.

*---------------------------------------------------------------------*
* FETCH LEAVE DETAILS
*---------------------------------------------------------------------*

  SELECT SINGLE *
    FROM Z47T_LEAVE
    INTO LS_LEAVE
    WHERE LEAVEID = P_LEAVE.

  IF SY-SUBRC <> 0.
    MESSAGE 'Leave request not found' TYPE 'I'.
    RETURN.
  ENDIF.

*---------------------------------------------------------------------*
* FETCH EMPLOYEE DETAILS
*---------------------------------------------------------------------*

  SELECT SINGLE *
    FROM Z47T_EMP
    INTO LS_EMP
    WHERE EMPID = LS_LEAVE-EMP_ID.

  IF SY-SUBRC <> 0.
    MESSAGE 'Employee record not found' TYPE 'I'.
    RETURN.
  ENDIF.

*---------------------------------------------------------------------*
* CHECK EXISTING APPROVAL
*---------------------------------------------------------------------*

  SELECT SINGLE *
    FROM Z47T_APPR
    INTO LS_APPR
    WHERE LEAVE_ID = P_LEAVE.

  IF SY-SUBRC = 0.
    MESSAGE 'Approval record already exists' TYPE 'I'.
    RETURN.
  ENDIF.

*---------------------------------------------------------------------*
* PREPARE APPROVAL RECORD
*---------------------------------------------------------------------*

  CLEAR LS_APPR.

  LS_APPR-MANDT        = SY-MANDT.
  LS_APPR-LEAVE_ID     = P_LEAVE.
  LS_APPR-MANAGER_ID   = '10001'.
  LS_APPR-APPR_DATE    = SY-DATUM.
  LS_APPR-APPR_COMMENT = P_COMM.

  IF P_APPR = 'X'.
    LS_APPR-APPR_STATUS = 'APPROVED'.
  ELSE.
    LS_APPR-APPR_STATUS = 'REJECTED'.
  ENDIF.

*---------------------------------------------------------------------*
* GENERATE APPROVAL ID
*---------------------------------------------------------------------*

  SELECT MAX( APPROVAL_ID )
    FROM Z47T_APPR
    INTO LV_MAX_ID.

  LS_APPR-APPROVAL_ID = LV_MAX_ID + 1.

*---------------------------------------------------------------------*
* INSERT APPROVAL RECORD
*---------------------------------------------------------------------*

  INSERT Z47T_APPR FROM LS_APPR.

  IF SY-SUBRC <> 0.
    ROLLBACK WORK.
    MESSAGE 'Error processing leave approval' TYPE 'I'.
    RETURN.
  ENDIF.

  COMMIT WORK AND WAIT.

*---------------------------------------------------------------------*
* PREPARE SMART FORM DATA
*---------------------------------------------------------------------*

  CLEAR LS_FORM.

  LS_FORM-EMPID        = LS_EMP-EMPID.
  LS_FORM-EMPNAME      = LS_EMP-EMPNAME.
  LS_FORM-DEPTID       = LS_EMP-DEPTID.
  LS_FORM-DESIG        = LS_EMP-DESIG.

  LS_FORM-LEAVE_ID     = LS_LEAVE-LEAVEID.
  LS_FORM-FROM_DATE    = LS_LEAVE-FROM_DATE.
  LS_FORM-TO_DATE      = LS_LEAVE-TO_DATE.
  LS_FORM-LEAVEDAYS    = LS_LEAVE-LEAVEDAYS.
  LS_FORM-REASON       = LS_LEAVE-REASON.

  LS_FORM-LEAVE_STATUS = LS_APPR-APPR_STATUS.
  LS_FORM-COMMENT      = LS_APPR-APPR_COMMENT.
  LS_FORM-DATE         = SY-DATUM.

*---------------------------------------------------------------------*
* GET SMART FORM FUNCTION MODULE
*---------------------------------------------------------------------*

  LV_FORM_NAME = 'Z47SF_LEAVE_APPROVAL'.

  CALL FUNCTION 'SSF_FUNCTION_MODULE_NAME'
    EXPORTING
      FORMNAME           = LV_FORM_NAME
    IMPORTING
      FM_NAME            = LV_FUNCTION
    EXCEPTIONS
      NO_FORM            = 1
      NO_FUNCTION_MODULE = 2
      OTHERS             = 3.

  IF SY-SUBRC <> 0.
    MESSAGE 'Could not find Smart Form function module' TYPE 'I'.
    RETURN.
  ENDIF.

*---------------------------------------------------------------------*
* CALL SMART FORM
*---------------------------------------------------------------------*

  CALL FUNCTION LV_FUNCTION
    EXPORTING
      IS_LEAVE = LS_FORM
    EXCEPTIONS
      FORMATTING_ERROR = 1
      INTERNAL_ERROR   = 2
      SEND_ERROR       = 3
      USER_CANCELED    = 4
      OTHERS            = 5.

  IF SY-SUBRC = 0.
    MESSAGE 'Leave approval processed and form generated' TYPE 'S'.
  ELSE.
    MESSAGE 'Approval saved, but Smart Form output failed' TYPE 'I'.
  ENDIF.

ENDFORM.