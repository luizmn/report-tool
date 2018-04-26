# "Database code" for the DB Report.
# Please execute create_views.sql before running this file

import datetime
import psycopg2

posts = ''

# function used to conenct to the database


def db_connection():
    '''Connect to database'''
    try:
        dbcon = psycopg2.connect("dbname=news")
    except:
        print ("Unable to connect to the database")
    return dbcon

# Question 1
# Get the most read authors


def top_authors(dbcon):
    '''Get most read authors'''
    dbcon = db_connection()
    cur = dbcon.cursor()
    cur.execute("select * from top_authors")
    posts = cur.fetchall()
    dbcon.close()
    print ("\nTop Authors: \n")
    i = 0
    for post in posts:
        i += 1
        print (i, "- Author: ", post[0], " - Views", post[1])

# Question 2
# Get the 3 most read articles


def top_articles(dbcon):
    '''Get 3 most read articles'''
    dbcon = db_connection()
    cur = dbcon.cursor()
    cur.execute("select * from top_articles limit 3")
    posts = cur.fetchall()
    dbcon.close()
    print ("\nTop Articles: \n")
    i = 0
    for post in posts:
        i += 1
        print (i, "- Article: ", post[0], " - Views", post[1])

# Question 3
# Get the days with most errors


def error_days(dbcon):
    '''Get which days have most errors'''
    dbcon = db_connection()
    cur = dbcon.cursor()
    cur.execute("select access_date, rate from access_info")
    posts = cur.fetchall()
    dbcon.close()
    print ("\nDays with error requests higher than 1%: \n")
    i = 0
    for post in posts:
        i += 1
        print (i, "- Date: ", post[0], " - Error rate:", post[1], "%")


top_authors(db_connection())
top_articles(db_connection())
error_days(db_connection())
