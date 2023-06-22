# !/usr/bin/env python
# -*- coding: utf-8 -*-
import logging

import pandas as pd
import pymysql

u = input("Enter username: ")
p = input("Enter password: ")

while True:
    try:
        connection = pymysql.connect(
            host='localhost',
            user=u,
            password=p,
            database='medipharm',
            charset='utf8mb4',
            cursorclass=pymysql.cursors.DictCursor,
            autocommit=True
        )
        break
    except pymysql.err.OperationalError as e:
        print('Error: %d: %s' % (e.args[0], e.args[1]))
        u = input("Enter username: ")
        p = input("Enter password: ")


def work():
    try:
        loggedIn = True

        c1 = connection.cursor()
        givenID = int(input('Enter employee ID: '))
        givenID_type = 'SELECT employeeID, employeeType, firstName FROM employee WHERE employeeID = %s'
        c1.execute(givenID_type, (givenID,))
        result = c1.fetchone()

        if result is None:
            print('Error: Employee ID does not exist.')
            work()

        empType = result.get('employeeType')
        empName = result.get('firstName')

        print('\n#####################\n' +
              '### WELCOME ' + empName.upper() + '! ###\n' +
              '#####################\n')

        while loggedIn:
            if empType == 'Manager':
                isManager = True
            else:
                isManager = False

            loggedIn = userinput(isManager, givenID)
            c1.close()

    except pymysql.Error as e:
        print('Error: %d: %s' % (e.args[0], e.args[1]))

    finally:
        if connection:
            connection.close()
            print('Closing connection.')


def userinput(isManager, givenID):
    loggedIn = True

    while loggedIn:
        if isManager:
            choice = int(input('\nWhat would you like to do?\n' +
                                  '1. Add new stored drug.\n' +
                                  '2. Delete stored drug.\n' +
                                  '3. Print drug inventory.\n' +
                                  '4. Update stored drug quantity.\n' +
                                  '5. Get invoices.\n' +
                                  '6. Update customer information\n' +
                                  '7. Add employee.\n' +
                                  '8. Delete employee.\n' +
                                  '0. Log out.\n' +
                                  'Enter option: '))
            if choice in [1, 2, 3, 4, 5, 6, 7, 8]:
                menu_input(choice, givenID)
                userinput(isManager, givenID)
            else:
                print('Not authorized to do anything else.')

        else:
            choice = int(input('\nWhat would you like to do?\n' +
                                  '1. Add new stored drug.\n' +
                                  '2. Delete stored drug.\n' +
                                  '3. Print drug inventory.\n' +
                                  '4. Update stored drug quantity.\n' +
                                  '5. Get invoices.\n' +
                                  '6. Update customer information\n' +
                                  '0. Log out.\n' +
                                  'Enter option: '))
            if choice in [1, 2, 3, 4, 5, 6]:
                menu_input(choice, givenID)
                userinput(isManager, givenID)
            else:
                print('Not authorized to do anything else.')

        if choice == 0:
            print('Logging out...')
            return False
        else:
            return True


def menu_input(selected, givenID):
    if selected == 1:
        selected_1()

    elif selected == 2:
        print('\n#####################\n' +
              '### DELETING STORED DRUG ###\n' +
              '#####################\n')
        print('Which drug are you deleting?')
        drugID = int(input('Enter drug ID to delete here: '))

        del_tuple_drug(drugID)

    elif selected == 3:
        print('\n#####################\n' +
              '### PRINTING DRUG INVENTORY ###\n' +
              '#####################\n')
        return_drug_stock()

    elif selected == 4:
        print('\n#####################\n' +
              '### UPDATING DRUG QUANTITY ###\n' +
              '#####################\n')
        drugID = int(input('Enter drug ID to update here: '))
        newQuant = int(input('Enter new quantity here: '))

        update_drug_quant(drugID, newQuant)

    elif selected == 5:
        print('\n#####################\n' +
              '### PRINTING INVOICES ###\n' +
              '#####################\n')
        invoice_type = int(input('Are you wanting to print customer or supplier invoices?\n' +
                                 '1. customer\n' +
                                 '2. supplier\n' +
                                 'Enter value: '))
        if invoice_type == 1:
            invoice_type = 'customer'
        else:
            invoice_type = 'supplier'

        receipt_id = int(input('Which receipt ID are you searching for? '))

        get_invoice(invoice_type, receipt_id)

    elif selected == 6:
        print('\n#####################\n' +
              '### UPDATE CUSTOMER INFORMATION ###\n' +
              '#####################\n')
        print('Which customer are you updating?')
        custID = int(input('Enter customer ID: '))
        field = int(input('Which field are you updating?\n' +
                          '1. Phone number\n' +
                          '2. Email address\n' +
                          'Enter value: '))

        if field == 1:
            field = 'mobile'
            newField = input('Enter new phone number: ')
        else:
            field = 'email'
            newField = input('Enter new email: ')

        update_cust_info(custID, field, newField)

    elif selected == 7:
        selected_7(givenID)

    elif selected == 8:
        print('\n#####################\n' +
              '### DELETING EMPLOYEE ###\n' +
              '#####################\n')
        print('Sad to see them go! Which employee are you removing?')
        empID = input('Enter ID of employee to remove: ')
        del_employee(empID)

    else:
        print('Not authorized to do anything else.')


def new_tuple_drug(params):
    c2 = connection.cursor()
    c2.callproc('NewTupleDrug', tuple((par for par in params)))
    print("Adding tuple now...")

    query = 'SELECT * FROM drug'
    c2.execute(query)
    for row in c2.fetchall():
        print(row)
        c2.close()


def del_tuple_drug(id):
    c3 = connection.cursor()
    c3.callproc('DelTupleDrug', (id, ))
    print("Deleting tuple now...")

    query = 'SELECT * FROM drug'
    c3.execute(query)
    for row in c3.fetchall():
        print(row)
        c3.close()


def return_drug_stock():
    c4 = connection.cursor()
    c4.callproc('returnDrugStock')
    print("Returning all drugs and their stock...")
    for row in c4.fetchall():
        print(row)
        c4.close()


def get_cust_receipt(id):
    c5 = connection.cursor()
    c5.callproc('getCustomerReceipt', (id, ))
    print("Returning customer receipt...")
    for row in c5.fetchall():
        print(row)
        c5.close()


def get_supp_receipt(id):
    c6 = connection.cursor()
    c6.callproc('getSupplierReceipt', (id,))
    print("Returning supplier receipt...")
    for row in c6.fetchall():
        print(row)
        c6.close()


def get_invoice(invoice_type, receipt_id):
    c7 = connection.cursor()
    c7.callproc('getInvoice', (invoice_type, receipt_id))
    print("Returning invoice...")
    if c7.fetchall()[0]['message'] == 'Customer Invoice Selected':
        get_cust_receipt(receipt_id)
        c7.close()
    elif c7.fetchall()[0]['message'] == 'Supplier Invoice Selected':
        get_supp_receipt(receipt_id)
        c7.close()


def update_cust_info(custID, field, newField):
    c8 = connection.cursor()
    c8.callproc('updateCustomerInfo', (custID, field, newField))
    print("Updating customer info...")

    query = 'SELECT * FROM customer WHERE customerID = %s'
    c8.execute(query, (custID, ))
    for row in c8.fetchall():
        print(row)
        c8.close()


def update_drug_quant(drugID, quant):
    c9 = connection.cursor()
    c9.callproc('updateDrugQuantity', (drugID, quant))
    print("Updating drug quantity...")

    query = 'SELECT drugID, drugName, quantity FROM drug WHERE drugID = drugID'
    c9.execute(query)
    for row in c9.fetchall():
        print(row)
        c9.close()


def add_address(params):
    c10 = connection.cursor()
    c10.callproc('AddAddress', tuple((par for par in params)))
    print("Adding address...")
    for row in c10.fetchall():
        print(row)
        c10.close()


def add_employee(params):
    c11 = connection.cursor()
    c11.callproc('AddEmployee', tuple((par for par in params)))
    print("Adding employee...")

    query = 'SELECT * FROM employee'
    c11.execute(query)
    for row in c11.fetchall():
        print(row)
        c11.close()


def del_employee(empID):
    c12 = connection.cursor()
    c12.callproc('DeleteEmployee', (empID, ))
    print("Deleting employee...")

    query = 'SELECT * FROM employee'
    c12.execute(query)
    for row in c12.fetchall():
        print(row)
        c12.close()


def selected_1():
    print('\n#####################\n' +
          '### ADDING NEW DRUG ###\n' +
          '#####################\n')
    print('Enter the details on the drug.')
    drugName = input('Enter name of drug: ')
    scientificName = input('Enter scientific name of drug: ')
    drugCategory = int(input('Which drug category?\n' +
                             '1. depressant\n' +
                             '2. stimulant\n' +
                             '3. hallucinogen\n' +
                             '4. anesthetic\n' +
                             '5. analgesic\n' +
                             '6. inhalant\n' +
                             '7. cannabis\n' +
                             'Enter value: '))

    if drugCategory == 1:
        drugCategory = 'depressant'
    elif drugCategory == 2:
        drugCategory = 'stimulant'
    elif drugCategory == 3:
        drugCategory = 'hallucinogen'
    elif drugCategory == 4:
        drugCategory = 'anesthetic'
    elif drugCategory == 5:
        drugCategory = 'analgesic'
    elif drugCategory == 6:
        drugCategory = 'inhalant'
    elif drugCategory == 7:
        drugCategory = 'cannabis'
    else:
        print('Not a category of drug.')

    storageTemp = float(input('Enter storage temperature: '))

    dangerousLevel = int(input('Which controlled drug?\n' +
                               '1. Schedule I\n' +
                               '2. Schedule II\n' +
                               '3. Schedule III\n' +
                               '4. Schedule IV\n' +
                               '5. Schedule V\n' +
                               'Enter value: '))

    if dangerousLevel == 1:
        dangerousLevel = 'Schedule I'
    elif dangerousLevel == 2:
        dangerousLevel = 'Schedule II'
    elif dangerousLevel == 3:
        dangerousLevel = 'Schedule III'
    elif dangerousLevel == 4:
        dangerousLevel = 'Schedule IV'
    elif dangerousLevel == 5:
        dangerousLevel = 'Schedule V'
    else:
        print('Not a recognized control of drug.')

    quantity = float(input('Enter quantity: '))

    manufacturerName = int(input('Which manufacturer?\n' +
                                 '1. HealthPro Manufacturing\n' +
                                 '2. Apex Solutions\n' +
                                 'Enter value: '))

    if manufacturerName == 1:
        manufacturerName = 'HealthPro Manufacturing'
    elif manufacturerName == 2:
        manufacturerName = 'Apex Solutions'
    else:
        print('Not a recognized manufacturer.')

    unitPrice = float(input('Enter unit price: '))

    storageLocation = int(input('Which storage location?\n' +
                                '1. Lockbox\n' +
                                '2. Safe/cabinet\n' +
                                '3. Cold storage\n' +
                                '4. Lab\n' +
                                'Enter value: '))

    new_tuple_drug([drugName, scientificName, drugCategory, storageTemp,
                    dangerousLevel, quantity, manufacturerName, unitPrice, storageLocation])


def selected_7(givenID):
    print('\n#####################\n' +
          '### ADDING NEW EMPLOYEE ###\n' +
          '#####################\n')

    print('First, enter details of address of new employee!')
    streetNum = int(input('Enter street number: '))
    streetName = input('Enter street name: ')
    city = input('Enter city: ')
    state = input('Enter state: ')
    zipcode = input('Enter zipcode: ')
    print('Processing address...')
    add_address([streetNum, streetName, city, state, zipcode])

    print('\nNow, enter details of new employee!')
    empType = input('Is the new employee a manager?\n' +
                    '1. Yes. Give managerial permissions.\n' +
                    '2. No. Restrict permissions.\n' +
                    'Enter value: ')
    firstName = input('Enter employee first name: ')
    lastName = input('Enter employee last name: ')
    DOB = input('Enter employee date of birth (YYYY-MM-DD): ')
    mobilePhone = input('Enter employee phone number: ')
    emailAddress = input('Enter employee email address: ')

    add_employee([givenID, empType, firstName, lastName, DOB, mobilePhone, emailAddress])


if __name__ == '__main__':
    work()
