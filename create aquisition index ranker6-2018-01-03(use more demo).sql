/******  raw data start******/
Insert Into dbo.aquisition_lsd_model (
      [BroadcastDate]
	  ,[STDate]
	  ,[TCastStartTime]
	  ,[YearInt]
      ,[HourInt]
      ,[TCastDaypart]
      ,[TCastName]
      ,[show]
      ,[ProgramID]
      ,[TCastID]
      ,[TCastOriginator]
      ,[TCastOriginatorID]
      ,[TCastOriginatorType]
      ,[TCastStandardType]
      ,[TCastExpandedType]
      ,[TCastPremeireFlag]
	  ,[TCastDuration]
	  ,[HH]
	  ,[P1849]
      ,[P2554])
SELECT [BroadcastDate]
      ,CASE
	   WHEN ([TCastStartTime]>=convert(time,'0:0:0',108) and [TCastStartTime]<convert(time,'3:0:0',108))
	   THEN 
	   DATEADD(day,1,[BroadcastDate])
	   ELSE
	   [BroadcastDate]
	   END as [STDate]
      ,[TCastStartTime]
	  ,DATEPART(YEAR,[BroadcastDate]) as YearInt
	  ,DATEPART(HOUR,[TCastStartTime]) as HourInt
      ,[TCastDaypart]
      ,[TCastName]
	  ,[show]
      ,[ProgramID]
      ,[TCastID]
      ,[TCastOriginator]
      ,[TCastOriginatorID]
      ,[TCastOriginatorType]
      ,[TCastStandardType]
      ,[TCastExpandedType]
      ,[TCastPremeireFlag]
	  ,[TCastDuration]
      ,[HHProjection]
	  ,[P1849]
      ,[P2554]
	   from dbo.aquisition_lsd
where BroadcastDate>='2018-04-01' and [MarketBreak]='Composite'
go

with cet as(
select *, rn=ROW_NUMBER()OVER(PARTITION BY BroadcastDate,TCastStartTime,TCastOriginator,TCastName ORDER BY HH desc)
from dbo.aquisition_lsd_model
)
delete from cet where rn>1

/****** add quarter and weekday flag******/
Declare @m int;
update dbo.aquisition_lsd_model
set @m=MONTH(BroadcastDate),
    quaterint=case when (@m=1 or @m=2 or @m=3) then 1 when (@m=4 or @m=5 or @m=6) then 2 when (@m=7 or @m=8 or @m=9) then 3 else 4 end,
    weekdayint=case when (DATEPART(dw,BroadcastDate)=1 or DATEPART(dw,BroadcastDate)=7) then 1 else 0 end
	;

/******  add column about leadin ******/
with cet as (
select [TCastOriginator],[STDate],[TCastStartTime],
       rn=ROW_NUMBER() OVER(ORDER BY [TCastOriginator],[STDate],[TCastStartTime])
from dbo.aquisition_lsd_model
)
update dbo.aquisition_lsd_model
set id=cet.rn
from cet
where dbo.aquisition_lsd_model.[TCastOriginator]=cet.[TCastOriginator]
and dbo.aquisition_lsd_model.[STDate]=cet.[STDate]
and dbo.aquisition_lsd_model.[TCastStartTime]=cet.[TCastStartTime];
go

with shif as(
select id+1 as idnew,TCastOriginator,STDate,TCastStartTime,HH,P1849,P2554,TCastDuration,show,TCastStandardType
from dbo.aquisition_lsd_model)
update dbo.aquisition_lsd_model
set  dbo.aquisition_lsd_model.LeadinSd=shif.STDate,
	 dbo.aquisition_lsd_model.LeadinSt=shif.TCastStartTime,
	 dbo.aquisition_lsd_model.LeadinDur=shif.TCastDuration,
	 dbo.aquisition_lsd_model.LeadinShow =shif.show,
	 dbo.aquisition_lsd_model.LeadinType=shif.TCastStandardType,
	 dbo.aquisition_lsd_model.LeadinRate_HH=shif.HH,
	 dbo.aquisition_lsd_model.LeadinRate_P1849=shif.P1849,
	 dbo.aquisition_lsd_model.LeadinRate_P2554=shif.P2554
from shif
where dbo.aquisition_lsd_model.id=shif.idnew and dbo.aquisition_lsd_model.TCastOriginator=shif.TCastOriginator;
go

update dbo.aquisition_lsd_model
set ValLead=(case 
             when abs(DATEDIFF(minute, 
			 cast(rtrim(cast(MONTH(LeadinSd) as nchar))+'/'+rtrim(cast(DAY(LeadinSd) as nchar))+'/'+rtrim(cast(YEAR(LeadinSd) as nchar))+' '+rtrim(cast(DATEPART(HOUR, LeadinSt) as nchar))+':'+rtrim(cast(DATEPART(MINUTE, LeadinSt) as nchar))+':0:0' as datetime),
			 cast(rtrim(cast(MONTH(STDate) as nchar))+'/'+rtrim(cast(DAY(STDate) as nchar))+'/'+rtrim(cast(YEAR(STDate) as nchar))+' '+rtrim(cast(DATEPART(HOUR, TCastStartTime) as nchar))+':'+rtrim(cast(DATEPART(MINUTE, TCastStartTime) as nchar))+':0:0' as datetime) 
			 
			                  )-LeadinDur)<3 
			 then 1
			 else 0
			 end);
go

/***find time period with usable data (have at least  4 shows aired in the same time period)****/

IF OBJECT_ID('dbo.temp_telcount', 'U') IS NOT NULL  DROP TABLE dbo.temp_telcount;
IF OBJECT_ID('dbo.temp_showcount', 'U') IS NOT NULL  DROP TABLE dbo.temp_showcount;

update dbo.aquisition_lsd_model
set TCastLessThan5Flag=1
;
go

 select YearInt, quaterint,weekdayint,TCastDaypart,TCastOriginator,show,TCastPremeireFlag,count(show) as telct
 into dbo.temp_telcount
 from dbo.aquisition_lsd_model
 where ([TCastStandardType]='DAYTIME DRAMA' 
     or ([TCastStandardType]='GENERAL DRAMA' and [TCastExpandedType]!='SERIES - REALITY')
	 or ([TCastStandardType]='SITUATION COMEDY' and TCastOriginatorType!='BROADCAST'))
 group by YearInt, quaterint,weekdayint,TCastDaypart,TCastOriginator,show,TCastPremeireFlag
;
go

 select YearInt, quaterint,weekdayint,TCastDaypart,TCastOriginator,TCastPremeireFlag, count(show) as showct, 1 as vflag
 into dbo.temp_showcount
 from dbo.temp_telcount
 where telct>=5
 group by YearInt, quaterint,weekdayint,TCastDaypart,TCastOriginator,TCastPremeireFlag
 ;
go

update dbo.temp_showcount
set vflag=0
where showct>=4
;
go

update dbo.aquisition_lsd_model
set TCastLessThan5Flag=vflag
from  dbo.temp_showcount
where aquisition_lsd_model.YearInt=temp_showcount.YearInt
and aquisition_lsd_model.quaterint=temp_showcount.quaterint
and aquisition_lsd_model.weekdayint=temp_showcount.weekdayint
and aquisition_lsd_model.TCastDaypart=temp_showcount.TCastDaypart
and aquisition_lsd_model.TCastOriginator=temp_showcount.TCastOriginator
and aquisition_lsd_model.TCastPremeireFlag=temp_showcount.TCastPremeireFlag
 ;
 go

/******  add average as base******/
IF OBJECT_ID('dbo.temp_show_avg', 'U') IS NOT NULL  DROP TABLE dbo.temp_show_avg;
SELECT [TCastOriginator],[YearInt],[TCastDaypart],quaterint,weekdayint,show,TCastPremeireFlag,
       avg(HH) as show_avg_HH,avg(P1849) as show_avg_P1849,avg(P2554) as show_avg_P2554
  into dbo.temp_show_avg
  FROM [ion].[dbo].[aquisition_lsd_model] as a
  where TCastLessThan5Flag=0 
  and  ([TCastStandardType]='DAYTIME DRAMA'
       or ([TCastStandardType]='GENERAL DRAMA' and [TCastExpandedType]!='SERIES - REALITY')
		or ([TCastStandardType]='SITUATION COMEDY' and TCastOriginatorType!='BROADCAST'))
  group by [TCastOriginator],[YearInt],[TCastDaypart],quaterint,weekdayint,show,TCastPremeireFlag
go

update dbo.aquisition_lsd_model
set   dbo.aquisition_lsd_model.HHAvg=NULL,
      dbo.aquisition_lsd_model.P1849Avg=NULL,
      dbo.aquisition_lsd_model.P2554Avg=NULL;

with ave as(
select [TCastOriginator],[YearInt],[TCastDaypart],quaterint,weekdayint,TCastPremeireFlag,
       AVG(show_avg_HH) as avghh,AVG(show_avg_P1849) as avgp1,AVG(show_avg_P2554) as avgp2
from dbo.temp_show_avg
group by [TCastOriginator],[YearInt],[TCastDaypart],quaterint,weekdayint,TCastPremeireFlag
)
update dbo.aquisition_lsd_model
set  dbo.aquisition_lsd_model.HHAvg=ave.avghh,
     dbo.aquisition_lsd_model.P1849Avg=ave.avgp1,
	 dbo.aquisition_lsd_model.P2554Avg=ave.avgp2
from ave
where dbo.aquisition_lsd_model.[YearInt]=ave.[YearInt]
  and dbo.aquisition_lsd_model.[TCastDaypart]=ave.[TCastDaypart]
  and dbo.aquisition_lsd_model.[TCastOriginator]=ave.[TCastOriginator]
  and dbo.aquisition_lsd_model.[quaterint]=ave.[quaterint]
  and dbo.aquisition_lsd_model.[weekdayint]=ave.[weekdayint]
  and dbo.aquisition_lsd_model.[TCastPremeireFlag]=ave.[TCastPremeireFlag]
  ;
go


/******  add rating behavior******/
update dbo.aquisition_lsd_model
set HHBev=NULL,
    P1849Bev=NULL,
    P2554Bev=NULL;
go

declare @p_HH float;
declare @p_P1849 float;
declare @p_P2554 float;

update dbo.aquisition_lsd_model
set  @p_HH=case when ValLead=1
     then (case when (HH/cast(LeadinRate_HH as float))>1.1 then 1.1 else HH/cast(LeadinRate_HH as float) end)
	 else 1 end,
	 @p_P1849=case when ValLead=1
     then (case when (P1849/cast(LeadinRate_P1849 as float))>1.1 then 1.1 else P1849/cast(LeadinRate_P1849 as float) end)
	 else 1 end,
	 @p_P2554=case when ValLead=1
     then (case when (P2554/cast(LeadinRate_P2554 as float))>1.1 then 1.1 else P2554/cast(LeadinRate_P2554 as float) end)
	 else 1 end,
	 HHBev=HH/cast(HHAvg as float)*@p_HH*@p_HH,
	 P1849Bev=P1849/cast(P1849Avg as float)*@p_P1849*@p_P1849,
	 P2554Bev=P2554/cast(P2554Avg as float)*@p_P2554*@p_P2554
where P2554Avg>0 and LeadinRate_P2554>0 and P1849Avg>0 and LeadinRate_P1849>0 and HHAvg>0 and LeadinRate_HH>0
;
go

update dbo.aquisition_lsd_model
set HHBev=(case when HHBev<10 then HHBev else null end),
    P1849Bev=(case when P1849Bev<10 then P1849Bev else null end),
    P2554Bev=(case when P2554Bev<10 then P2554Bev else null end);
go


/***raw data done**/
IF OBJECT_ID('dbo.temp1', 'U') IS NOT NULL  DROP TABLE dbo.temp1;
Select YearInt, TCastOriginator,quaterint,weekdayint,TCastDaypart,TCastPremeireFlag,show,avg(HHBev) as hhbev,avg(P1849Bev) as p1849bev,avg(P2554Bev) as p2554bev,count(show) as ct
into dbo.temp1
from dbo.aquisition_lsd_model
where TCastLessThan5Flag=0  and
       ([TCastStandardType]='DAYTIME DRAMA'
       or ([TCastStandardType]='GENERAL DRAMA' and [TCastExpandedType]!='SERIES - REALITY')
		or ([TCastStandardType]='SITUATION COMEDY' and TCastOriginatorType!='BROADCAST'))
group by YearInt, TCastOriginator,quaterint,weekdayint,TCastDaypart,TCastPremeireFlag,show
;
go
