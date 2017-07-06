import psycopg2
from config import config

def LoadData():

    """ insert Historical Data from CSV file into the Historical_data table """
    Historysql = """COPY Historicaldata(Historical_date,Time,ChilledWaterSendingTons,Outside_Temp,Tank_Status)
    FROM 'C:\\Users\\beula\\ImportfromCSVtoPostgres\\HistoricalDataa.csv' DELIMITER ',' CSV HEADER;"""

    """ insert Current Data from CSV file into the Current_data table """
    Currentsql = """COPY Currentdata(Present_date,Time,ChilledWaterSendingTons,Outside_Temp,Tank_Status,DeltaT)
    FROM 'C:\\Users\\beula\\ImportfromCSVtoPostgres\\CurrentData.csv' DELIMITER ',' CSV HEADER;"""

    """ insert Current Data from CSV file into the Current_data table """
    Weathersql = """COPY Weatherdata(Date,MaxT,MinT,pcpn,snow,snwg)
        FROM 'C:\\Users\\beula\\ImportfromCSVtoPostgres\\WeatherData.csv' DELIMITER ',' CSV HEADER;"""
    conn = None
    try:
        # read database configuration
        params = config()
        # connect to the PostgreSQL database
        conn = psycopg2.connect(**params)
        # create a new cursor
        cur = conn.cursor()
        # execute the INSERT statement
        cur.execute(Historysql)
        cur.execute(Currentsql)
        cur.execute(Weathersql)
        # commit the changes to the database
        conn.commit()
        # close communication with the database
        cur.close()
    except (Exception, psycopg2.DatabaseError) as error:
        print(error)
    finally:
        if conn is not None:
            conn.close()

if __name__ == '__main__':
    LoadData()
