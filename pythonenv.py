#!/usr/bin/env python
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
        database='sharkdb',
        charset='utf8mb4',
        cursorclass=pymysql.cursors.DictCursor,
        autocommit=True
    )
except pymysql.err.OperationalError as e:
    print('Error: %d: %s' % (e.args[0], e.args[1]))


def work():
    try:
        t = input('Enter town: ')
        s = input('Enter state: ')

        c1 = connection.cursor()
        query = 'SELECT * FROM township WHERE `town` = %s AND `state` = %s'
        df1 = pd.read_sql(query, connection, params=(t, s))
        print(df1)

        if df1.empty:
            print('This town and state does not exist in this database. Reenter.')
            print('This is the list of legitimate towns and states in this database.')
            c3 = connection.cursor()
            query = 'SELECT town, state FROM township'
            c3.execute(query)
            for row in c3.fetchall():
                print(row)
            work()
        else:
            all_receivers(t, s)
            c1.close()

    except pymysql.Error as e:
        print('Error: %d: %s' % (e.args[0], e.args[1]))

    finally:
        if connection:
            connection.close()
            print('Closing connection.')


def all_receivers(t, s):
    c2 = connection.cursor()
    c2.callproc('allReceivers', (t, s))
    print('Obtaining receivers now...')
    for row in c2.fetchall():
        print(row)
    c2.close()


if __name__ == '__main__':
    work()
