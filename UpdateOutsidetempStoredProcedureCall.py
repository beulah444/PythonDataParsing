import psycopg2
from config import config


def update_outsideTemp():
    """ update the  outside tempature from weather data table to existing tables
     Historicaldata and Currentdata """
    conn = None
    try:
        # read database configuration
        params = config()
        # connect to the PostgreSQL database
        conn = psycopg2.connect(**params)
        # create a cursors object for execution of two stored procedures
        cur1 = conn.cursor()
        cur2 = conn.cursor()
        # another way to call a stored procedure
        # cur.execute("SELECT * FROM update_outtempinHistoricaldatatable(); ")
        cur1.callproc('update_outtempinHistoricaldatatable')
        cur2.callproc('update_outtempinCurrentdatatable')
        # process the result set
        row1 = cur1.fetchone()
        row2 = cur2.fetchone()
        while row1 is not None:
            print(row1)
            row1 = cur1.fetchone()
        while row2 is not None:
            print(row2)
            row2 = cur2.fetchone()
        # close the communication with the PostgreSQL database server
        cur1.close()
        cur2.close()
    except (Exception, psycopg2.DatabaseError) as error:
        print(error)
    finally:
        if conn is not None:
            conn.close()

if __name__ == '__main__':
    update_outsideTemp()
