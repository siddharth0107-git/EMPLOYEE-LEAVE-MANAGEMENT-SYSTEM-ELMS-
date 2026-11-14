# Employee Leave Management System (ELMS)

A SAP ABAP project for maintaining employee information, managing leave
requests, recording manager approval or rejection decisions, and
generating a Leave Approval Letter for SAP print preview.

## Project Overview

The Employee Leave Management System (ELMS) is demonstrated through four
ABAP programs. The workflow begins with employee and leave reporting,
continues through employee record maintenance and leave request
submission, and ends with manager approval processing and a formatted
leave approval letter.

## Project Outputs

### 1. Employee Management and Leave Management

This program displays employee and leave information through reports.
The selection screen provides filters and radio-button options to choose
between the Employee Report and Leave Report.

**Employee Report fields:** - Employee ID - Employee Name - Department -
Designation - Joining Date - Salary - Email - Phone Number

**Leave Report:** Displays leave-related information and approval
details.

### 2. Employee CRUD Operations

This program maintains employee records using four operations: -
**Create:** Add a new employee record. - **Read:** Display existing
employee details. - **Update:** Modify employee information. -
**Delete:** Remove an employee record according to the program's
deletion logic.

The maintenance screen includes Employee ID, Employee Name, Department
ID, Designation, Joining Date, Salary, Email, and Phone Number. The
walkthrough also shows an update confirmation.

### 3. Employee Leave Request

This program captures an employee leave request using the following
fields: - Employee ID - From Date - To Date - Reason for Leave

The submitted request can then be reviewed in the Leave Approval
Program.

### 4. Leave Approval Program

The manager reviews a submitted leave request and manually selects
**Approve** or **Reject**. The manager can also enter a comment. The
decision and comment are recorded against the request and can be viewed
in the leave report.

### 5. Final Output -- Leave Approval Letter

After the manager records the decision, the application generates a
formatted Leave Approval Letter. The letter displays employee
information, the leave period, leave status, number of leave days, and
the manager's comment. It is shown in SAP print preview and can be
printed using the available SAP print settings.

## Screenshots

The screenshots below are extracted from the supplied ELMS project
walkthrough video.

### Program 1 -- Selection Screen

Selection criteria and options to choose the Employee Report or Leave
Report.

![Program 1 -- Selection Screen](screenshots/output_01.jpg)

### Program 1 -- Employee Details Report

Employee master information displayed in report format.

![Program 1 -- Employee Details Report](screenshots/output_02.jpg)

### Program 1 -- Employee Leave Report

Leave information and approval-related details.

![Program 1 -- Employee Leave Report](screenshots/output_03.jpg)

### Program 2 -- Employee CRUD Options

Options to create, read, update and delete employee records.

![Program 2 -- Employee CRUD Options](screenshots/output_04.jpg)

### Program 2 -- Employee Details Entry

Employee information entered for record maintenance.

![Program 2 -- Employee Details Entry](screenshots/output_05.jpg)

### Program 2 -- Update Confirmation

Confirmation displayed after an employee record is updated.

![Program 2 -- Update Confirmation](screenshots/output_06.jpg)

### Program 3 -- Employee Leave Request

Screen for entering employee ID, leave dates and reason.

![Program 3 -- Employee Leave Request](screenshots/output_07.jpg)

### Program 4 -- Manager Leave Approval

Manager review screen with approval/rejection and comment fields.

![Program 4 -- Manager Leave Approval](screenshots/output_08.jpg)

### Final Output -- Leave Approval Letter

Leave approval letter displayed in SAP print preview.

![Final Output -- Leave Approval Letter](screenshots/output_09.jpg)

## Project Execution Flow

1.  Run the Employee Management and Leave Management Program.
2.  View employee details or leave information.
3.  Use the Employee CRUD Program to create, read, update, or delete
    employee records.
4.  Enter a leave request using the Employee Leave Request Program.
5.  The manager reviews the request in the Leave Approval Program.
6.  The manager manually approves or rejects the request and enters a
    comment.
7.  View the final Leave Approval Letter in SAP print preview and print
    it if required.

## Technologies and SAP Components

-   SAP ABAP
-   ABAP Dictionary (DDIC)
-   ALV Reports
-   Selection Screens
-   Form-based output (the exact form technology should be confirmed in
    the SAP system)

## Important Notes

-   The manager manually reviews and approves or rejects leave requests.
    Automatic approval is not demonstrated.
-   Exact program names, transaction codes, DDIC table names, and
    technical field names should be added from the SAP system.
-   The exact Smart Form name, interface, and driver program have not
    been confirmed in the project documentation.

## Conclusion

The Employee Leave Management System demonstrates employee record
management, employee and leave reporting, leave request entry, manager
approval processing, and leave approval letter generation using SAP
ABAP.
