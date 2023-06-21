# !/usr/bin/env python
# -*- coding: utf-8 -*-
import logging
import pymysql
import pandas as pd

u = input("Enter username: ")
p = input("Enter password: ")

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
except pymysql.Error as e:
    code, msg = e.args
    print("Cannot connect to the database ", code, msg)


def work():
    try:
        # frupobu93iP_
        c1 = connection.cursor()
        # query = 'SELECT * FROM drug'
        # df1 = pd.read_sql(query, connection)
        # print(df1)
        # c1.close()

        # Working procedures/helpers:
        # new_tuple_drug([4, 'Amphetamine', '(RS)-2-phenylpropan-2-amine', 'stimulant', '25.00', 'Schedule III', '100',
        #                 'Apex Solutions', '10.00', 1])
        # del_tuple_drug(4)
        # return_drug_stock()
        # get_cust_receipt(1)
        # get_supp_receipt(100)
        # get_invoice('employee', 1)
        # update_cust_info([1, 'mobile', '9086738912'])
        # update_drug_quant(2, -100)

        # Python doesn't like ints that start with a zero so changed zipcode to a string instead
        add_address([40, 'Tuttle Street', 'Boston', 'MA', '02126'])

        c1.close()

    except pymysql.Error as e:
        print('Error: %d: %s' % (e.args[0], e.args[1]))

    finally:
        if connection:
            connection.close()
            print('Closing connection.')


def new_tuple_drug(params):
    c2 = connection.cursor()
    c2.callproc('NewTupleDrug', tuple((par for par in params)))
    print("Adding tuple now...")
    for row in c2.fetchall():
        print(row)
        c2.close()


def del_tuple_drug(id):
    c3 = connection.cursor()
    c3.callproc('DelTupleDrug', (id, ))
    print("Deleting tuple now...")
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


def get_invoice(type, id):
    c7 = connection.cursor()
    c7.callproc('getInvoice', (type, id))
    print("Returning invoice...")
    if c7.fetchall()[0]['message'] == 'Customer Invoice Selected':
        get_cust_receipt(id)
        c7.close()
    elif c7.fetchall()[0]['message'] == 'Supplier Invoice Selected':
        get_supp_receipt(id)
        c7.close()


def update_cust_info(params):
    c8 = connection.cursor()
    c8.callproc('updateCustomerInfo', tuple((par for par in params)))
    print("Updating customer info...")
    for row in c8.fetchall():
        print(row)
        c8.close()


def update_drug_quant(id, quant):
    c9 = connection.cursor()
    c9.callproc('updateDrugQuantity', (id, quant))
    print("Updating drug quantity...")
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




if __name__ == '__main__':
    work()