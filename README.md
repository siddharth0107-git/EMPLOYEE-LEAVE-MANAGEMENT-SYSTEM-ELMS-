# Employee Leave Management System (ELMS)

## Project Overview

The **Employee Leave Management System (ELMS)** is a SAP ABAP project developed to maintain employee information, manage leave requests, and record manager approval or rejection decisions.

The project consists of four ABAP programs. The process concludes by generating a Leave Approval Letter, which is displayed in SAP print preview and can be printed.

## Project Outputs

### 1. Employee Management and Leave Management

This program displays employee and leave information through reports.

**Employee Report output:**
- Employee ID
- Employee Name
- Department
- Designation
- Joining Date
- Salary
- Email
- Phone Number

**Leave Report output:**
- Displays leave-related information and approval details.

The selection screen provides filters and radio buttons to choose between the Employee Report and Leave Report.

### 2. Employee CRUD Operations

This program is used to maintain employee records.

It supports four operations:

- **Create:** Add a new employee record.
- **Read:** Display existing employee details.
- **Update:** Modify employee information.
- **Delete:** Remove an employee record according to the program's deletion logic.

The employee maintenance screen includes fields such as Employee ID, Employee Name, Department ID, Designation, Joining Date, Salary, Email, and Phone Number.

The output includes employee details and an update confirmation message.

### 3. Employee Leave Request

This program allows an employee's leave request to be entered.

The request screen contains:

- Employee ID
- From Date
- To Date
- Reason for Leave

After entering these details, the leave request can be reviewed by the manager through the Leave Approval Program.

### 4. Leave Approval Program

This program is used by the manager to review submitted leave requests.

The manager can:
- Review the leave request.
- Manually select **Approve** or **Reject**.
- Enter a comment explaining the decision.
- Record the decision and comment against the leave request.

The updated leave status can then be viewed in the leave report.

### 5. Final Output – Leave Approval Letter

After the manager records the decision, the application generates a formatted Leave Approval Letter.

The letter displays:
- Employee Name
- Employee ID
- Department
- Leave Period
- Leave Status
- Number of Leave Days
- Manager Comment

The final letter is displayed in SAP print preview and can be printed using the available SAP print settings.

## Project Execution Flow

1. Run the Employee Management and Leave Management Program.
2. View employee details or leave information.
3. Use the Employee CRUD Program to create, read, update, or delete employee records.
4. Enter a leave request using the Employee Leave Request Program.
5. The manager reviews the request in the Leave Approval Program.
6. The manager manually approves or rejects the request and enters a comment.
7. View the final Leave Approval Letter in SAP print preview and print it if required.

## Technologies and SAP Components

- SAP ABAP
- ABAP Dictionary (DDIC)
- ALV Reports
- Selection Screens
- Form-based output (the exact form technology should be confirmed in the SAP system)

## Important Notes

- The manager manually reviews and approves or rejects leave requests. The project does not demonstrate automatic approval.
- Exact program names, transaction codes, DDIC table names, and technical field names should be added from the SAP system.
- The exact Smart Form name, interface, and driver program have not been confirmed in the project documentation.

## Conclusion

The Employee Leave Management System demonstrates employee record management, employee and leave reporting, leave request entry, manager approval processing, and leave approval letter generation using SAP ABAP.
