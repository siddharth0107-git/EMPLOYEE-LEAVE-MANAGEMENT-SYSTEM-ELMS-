REPORT Z47R_LEAVE_REQUEST.

*---------------------------------------------------------------------*
* SELECTION SCREEN
*---------------------------------------------------------------------*

PARAMETERS:
  P_EMPID TYPE Z47T_LEAVE-EMP_ID OBLIGATORY,
  P_FROM  TYPE Z47T_LEAVE-FROM_DATE OBLIGATORY,
  P_TO    TYPE Z47T_LEAVE-TO_DATE OBLIGATORY,
  P_REASON TYPE Z47T_LEAVE-REASON OBLIGATORY.

*---------------------------------------------------------------------*
* DATA
*---------------------------------------------------------------------*

DATA:
  LS_LEAVE       TYPE Z47T_LEAVE,
  LS_EMP         TYPE Z47T_EMP,
  LV_MAX_LEAVEID TYPE Z47T_LEAVE-LEAVEID,
  LV_LEAVEDAYS   TYPE I.

*---------------------------------------------------------------------*
* PROCESS LEAVE REQUEST
*---------------------------------------------------------------------*

START-OF-SELECTION.

* Check that the employee exists
  SELECT SINGLE *
    FROM Z47T_EMP
    INTO LS_EMP
    WHERE EMPID = P_EMPID.

  IF SY-SUBRC <> 0.
    MESSAGE 'Employee ID does not exist' TYPE 'E'.
  ENDIF.

* Validate dates
  IF P_TO < P_FROM.
    MESSAGE 'To Date cannot be earlier than From Date' TYPE 'E'.
  ENDIF.

* Calculate leave days, including both From Date and To Date
  LV_LEAVEDAYS = P_TO - P_FROM + 1.

* Generate next Leave ID
  SELECT MAX( LEAVEID )
    FROM Z47T_LEAVE
    INTO LV_MAX_LEAVEID.

  IF LV_MAX_LEAVEID IS INITIAL.
    LV_MAX_LEAVEID = 0.
  ENDIF.

  LS_LEAVE-MANDT     = SY-MANDT.
  LS_LEAVE-LEAVEID   = LV_MAX_LEAVEID + 1.
  LS_LEAVE-EMP_ID    = P_EMPID.
  LS_LEAVE-FROM_DATE = P_FROM.
  LS_LEAVE-TO_DATE   = P_TO.
  LS_LEAVE-LEAVEDAYS = LV_LEAVEDAYS.
  LS_LEAVE-REASON    = P_REASON.

* Save leave request
  INSERT Z47T_LEAVE FROM LS_LEAVE.

  IF SY-SUBRC = 0.
    COMMIT WORK AND WAIT.

    MESSAGE |Leave request submitted. Leave ID: { LS_LEAVE-LEAVEID }, Days: { LV_LEAVEDAYS }|
      TYPE 'S'.
  ELSE.
    ROLLBACK WORK.
    MESSAGE 'Could not save leave request' TYPE 'E'.
  ENDIF.