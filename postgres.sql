--First stored procedure to update currentdata table with outside temparature
create or replace function update_outtempinHistoricaldatatable() returns setof Historicaldata as
$BODY$
declare
eachDay Historicaldata%rowtype;
begin
  for eachDay in 
         (select distinct historical_date from Historicaldata 
         order by historical_date asc)
         loop
            --min
            update Historicaldata set outside_temp=(select mint from Weatherdata
            where date=eachDay.historical_date)
            where historical_date=eachDay.historical_date
            and time between '00:00:00' and '09:45:00';
            --min
            update Historicaldata set outside_temp=(select mint from Weatherdata
            where date=eachDay.historical_date)
            where historical_date=eachDay.historical_date
            and time between '20:00:00' and '24:00:00';
            --max+min/2
            update Historicaldata set outside_temp=(select (maxt+mint)/2 as average from Weatherdata
            where date=eachDay.historical_date)
            where historical_date=eachDay.historical_date
            and time between '10:00:00' and '11:45:00';
            --max+min/2
            update Historicaldata set outside_temp=(select (maxt+mint)/2 as average from Weatherdata
            where date=eachDay.historical_date)
            where historical_date=eachDay.historical_date
            and time between '18:00:00' and '19:45:00';
            --max
            update Historicaldata set outside_temp=(select maxt from Weatherdata
            where date=eachDay.historical_date)
            where historical_date=eachDay.historical_date
            and time between '12:00:00' and '17:45:00';
            return next eachDay;
         end loop;  
         return; 
end;
$BODY$ 
language plpgsql;       

--Second stored procedure to update currentdata table with outside temparature
create or replace function update_outtempinCurrentdatatable() returns setof Currentdata as
$BODY$
declare
eachDay Currentdata%rowtype;
begin
  for eachDay in 
         (select distinct present_date from Currentdata 
         order by present_date asc)
         loop
            --min
            update Currentdata set outside_temp=(select mint from Weatherdata
            where date=eachDay.present_date)
            where present_date=eachDay.present_date
            and time between '00:00:00' and '09:45:00';
            --min
            update Currentdata set outside_temp=(select mint from Weatherdata
            where date=eachDay.present_date)
            where present_date=eachDay.present_date
            and time between '20:00:00' and '24:00:00';
            --max+min/2
            update Currentdata set outside_temp=(select (maxt+mint)/2 as average from Weatherdata
            where date=eachDay.present_date)
            where present_date=eachDay.present_date
            and time between '10:00:00' and '11:45:00';
            --max+min/2
            update Currentdata set outside_temp=(select (maxt+mint)/2 as average from Weatherdata
            where date=eachDay.present_date)
            where present_date=eachDay.present_date
            and time between '18:00:00' and '19:45:00';
            --max
            update Currentdata set outside_temp=(select maxt from Weatherdata
            where date=eachDay.present_date)
            where present_date=eachDay.present_date
            and time between '12:00:00' and '17:45:00';
            return next eachDay;
         end loop;  
         return; 
end;
$BODY$ 
language plpgsql;       


--run these queries separetely in database to update tables
select * from update_outtempinHistoricaldatatable();

select * from update_outtempinCurrentdatatable();


