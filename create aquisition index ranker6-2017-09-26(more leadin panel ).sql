/******  raw data start******/
with a as(
    select * from dbo.net_rating_1617
)
Insert Into dbo.aquisition ([id]
      ,[BroadcastDate]
      ,[STDate]
      ,[YearInt]
      ,[MarketBreak]
      ,[TCastStartTime]
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
      ,[TCastSpecialFlag]
      ,[TCastBreakoutFlag]
      ,[TCastCoverageArea]
      ,[TCastTrackageName]
      ,[TCastEpisodeTitle]
      ,[TCastLiveFlag]
      ,[TCastComplexFlag]
      ,[TCastGAAFlag]
      ,[TCastGappedFlag]
      ,[TCastLongTermFlag]
      ,[TCastMultiDayFlag]
      ,[TCastPremeireFlag]
      ,[TCastRepeatsFlag]
      ,[TCastLessThan5Flag]
      ,[TCastOriginalAcquired]
      ,[TCastDuration]
      ,[TCastCommercialDuration]
      ,[PlayDelayLabel]
      ,[MedianAge]
      ,[MedianIncome]
      ,[HHProjection]
      ,[HHNCCMProjection]
      ,[HHPUT]
      ,[HHUE]
      ,[F2554]
      ,[M2554]
      ,[P2554]
      ,[P0299])
SELECT 1 as id 
      ,a.[BroadcastDate]
     ,CASE
	   WHEN (a.[TCastStartTime]>=convert(time,'0:0:0',108) and a.[TCastStartTime]<convert(time,'3:0:0',108))
	   THEN 
	   DATEADD(day,1,a.[BroadcastDate])
	   ELSE
	   a.[BroadcastDate]
	   END as STDate
      ,CASE
	   WHEN a.[BroadcastDate]>='2007-04-30' and a.[BroadcastDate]<='2007-09-30' THEN 0607
	   WHEN a.[BroadcastDate]>='2007-10-01' and a.[BroadcastDate]<='2008-09-28' THEN 0708
	   WHEN a.[BroadcastDate]>='2008-09-29' and a.[BroadcastDate]<='2009-09-27' THEN 0809
	   WHEN a.[BroadcastDate]>='2009-09-28' and a.[BroadcastDate]<='2010-09-26' THEN 0910
	   WHEN a.[BroadcastDate]>='2010-09-27' and a.[BroadcastDate]<='2011-09-25' THEN 1011
	   WHEN a.[BroadcastDate]>='2011-09-26' and a.[BroadcastDate]<='2012-09-30' THEN 1112
	   WHEN a.[BroadcastDate]>='2012-10-01' and a.[BroadcastDate]<='2013-09-29' THEN 1213
	   WHEN a.[BroadcastDate]>='2013-09-30' and a.[BroadcastDate]<='2014-09-28' THEN 1314
	   WHEN a.[BroadcastDate]>='2014-09-29' and a.[BroadcastDate]<='2015-09-27' THEN 1415
	   WHEN a.[BroadcastDate]>='2015-09-28' and a.[BroadcastDate]<='2016-09-25' THEN 1516
	   WHEN a.[BroadcastDate]>='2016-09-26' and a.[BroadcastDate]<='2017-09-24' THEN 1617
	   END
	   as YearInt
      ,a.[MarketBreak]
      ,a.[TCastStartTime]
	  ,DATEPART(HOUR,a.[TCastStartTime]) as HourInt
      ,a.[TCastDaypart]
      ,a.[TCastName]
	  ,b.[show]
      ,a.[ProgramID]
      ,a.[TCastID]
      ,a.[TCastOriginator]
      ,a.[TCastOriginatorID]
      ,a.[TCastOriginatorType]
      ,a.[TCastStandardType]
      ,a.[TCastExpandedType]
      ,a.[TCastSpecialFlag]
      ,a.[TCastBreakoutFlag]
      ,a.[TCastCoverageArea]
      ,a.[TCastTrackageName]
      ,a.[TCastEpisodeTitle]
      ,a.[TCastLiveFlag]
      ,a.[TCastComplexFlag]
      ,a.[TCastGAAFlag]
      ,a.[TCastGappedFlag]
      ,a.[TCastLongTermFlag]
      ,a.[TCastMultiDayFlag]
      ,a.[TCastPremeireFlag]
      ,a.[TCastRepeatsFlag]
      ,a.[TCastLessThan5Flag]
      ,a.[TCastOriginalAcquired]
      ,a.[TCastDuration]
      ,a.[TCastCommercialDuration]
      ,a.[PlayDelayLabel]
	  ,c.[MedianAge]
	  ,c.[MedianIncome]
      ,[HHProjection]
      ,[HHNCCMProjection]
      ,[HHPUT]
      ,[HHUE]
	  ,([F2529Projection]+[F3034Projection]+[F3539Projection]+[F4044Projection]+[F4549Projection]+[F5054Projection]) as F2554
      ,([M2529Projection]+[M3034Projection]+[M3539Projection]+[M4044Projection]+[M4549Projection]+[M5054Projection]) as M2554
	  ,([F2529Projection]+[F3034Projection]+[F3539Projection]+[F4044Projection]+[F4549Projection]+[F5054Projection]
      +[M2529Projection]+[M3034Projection]+[M3539Projection]+[M4044Projection]+[M4549Projection]+[M5054Projection]) as P2554
      ,([F25Projection]+[M25Projection]+[F68Projection]+[M68Projection]+[F911Projection]+[M911Projection]
      +[F1224Projection]+[M1224Projection]+[F1517Projection]+[M1517Projection]+[F1820Projection]+[M1820Projection]
      +[F2124Projection]+[M2124Projection]+[F2529Projection]+[M2529Projection]+[F3034Projection]
      +[M3034Projection]+[F3539Projection]+[M3539Projection]+[F4044Projection]
      +[M4044Projection]+[F4549Projection]+[M4549Projection]+[F5054Projection]
      +[M5054Projection]+[F5559Projection]+[M5559Projection]+[F6064Projection]
      +[M6064Projection]+[F6599Projection]+[M6599Projection]) as P0299
	   from a
	   left join dbo.titles_shows as b
	   on a.TCastName=b.tcast_name and a.TCastOriginator=b.tcast_originator
	   left join dbo.net_median as c
	   on (a.BroadcastDate=c.BroadcastDate and a.TCastOriginator=c.TCastOriginator and a.TCastStartTime=c.TCastStartTime)
where (a.PlayDelayLabel='Live _ TV with Digital _ Linear with VOD|0|0')
	 and (a.[MarketBreak]='Composite' or a.[MarketBreak]='HOH ED = 4+ Years College' or a.[MarketBreak]='HOH Race = Black')
go

/******  remove dup******/
WITH CTE AS(
   SELECT *, RN = ROW_NUMBER()OVER(PARTITION BY [PlayDelayLabel],[TCastOriginator],[MarketBreak],[BroadcastDate],[TCastStartTime],[TCastName] ORDER BY [HHProjection] desc)
   FROM dbo.aquisition
)
DELETE FROM CTE WHERE RN > 1;
go

/****** add quarter and weekday flag******/
Declare @m int;
update dbo.aquisition
set @m=MONTH(BroadcastDate),
    aquisition.quaterint=case when (@m=1 or @m=2 or @m=3) then 1 when (@m=4 or @m=5 or @m=6) then 2 when (@m=7 or @m=8 or @m=9) then 3 else 4 end,
    aquisition.weekdayint=case when (DATEPART(dw,BroadcastDate)=1 or DATEPART(dw,BroadcastDate)=7) then 1 else 0 end
	;

/******  add column about leadin ******/

with cet as (
select [PlayDelayLabel],[TCastOriginator],[MarketBreak],[STDate],[TCastStartTime],
       rn=ROW_NUMBER() OVER(ORDER BY [PlayDelayLabel],[TCastOriginator],[MarketBreak],[STDate],[TCastStartTime])
from dbo.aquisition
)
update dbo.aquisition
set id=cet.rn
from cet
where dbo.aquisition.[PlayDelayLabel]=cet.[PlayDelayLabel]
and aquisition.[TCastOriginator]=cet.[TCastOriginator]
and aquisition.[MarketBreak]=cet.[MarketBreak]
and aquisition.[STDate]=cet.[STDate]
and aquisition.[TCastStartTime]=cet.[TCastStartTime];
go

with shif as(
select id+1 as idnew,STDate,PlayDelayLabel,TCastStartTime,P2554,F2554,M2554,P0299,TCastDuration,show,TCastStandardType
from dbo.aquisition)
update dbo.aquisition
set  dbo.aquisition.LeadinSd=shif.STDate,
	 dbo.aquisition.LeadinSt=shif.TCastStartTime,
	 dbo.aquisition.LeadinDur=shif.TCastDuration,
	 dbo.aquisition.LeadinShow =shif.show,
	 dbo.aquisition.LeadinType=shif.TCastStandardType,
	 dbo.aquisition.LeadinRate_P2554=shif.P2554,
	 dbo.aquisition.LeadinRate_F2554=shif.F2554,
	 dbo.aquisition.LeadinRate_M2554=shif.M2554,
	 dbo.aquisition.LeadinRate_P0299=shif.P0299
from shif
where dbo.aquisition.id=shif.idnew;
go

update dbo.aquisition
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
update dbo.aquisition
set TCastPremeireFlag=1,
    TCastLessThan5Flag=1,
	TCastComplexFlag=-1
;
go

update dbo.aquisition
set TCastComplexFlag=tvmz_eplist.showid
from  tvmz_eplist
where aquisition.BroadcastDate=tvmz_eplist.[date] and aquisition.TCastStartTime=tvmz_eplist.[time]
 and aquisition.TCastOriginatorID=tvmz_eplist.[nlnetid]
 ;
 go

update dbo.aquisition
set TCastPremeireFlag=0
from  tvmz_neilsen_match
where aquisition.[TCastOriginator]=tvmz_neilsen_match.net
and aquisition.[TCastStandardType]=tvmz_neilsen_match.[type]
and aquisition.[show]=tvmz_neilsen_match.[showname]
and aquisition.[TCastComplexFlag]=tvmz_neilsen_match.[mzid]
 ;
 go

--still use repeat flag as premeireflag for braodcast networks(except ion)
update dbo.aquisition
set TCastPremeireFlag=TCastRepeatsFlag
where TCastOriginator='ABC' or TCastOriginator='CBS' or TCastOriginator='FOX' or TCastOriginator='NBC'
 ;
 go

--here need manually check which show matched wrong
 /*IF OBJECT_ID('dbo.temp_error', 'U') IS NOT NULL  DROP TABLE dbo.temp_error;
with a as (
SELECT TCastOriginator,TCastStandardType,TCastComplexFlag,show, count(show) as ct
 from dbo.aquisition
 where PlayDelayLabel='Live _ TV with Digital _ Linear with VOD|0|0' and [MarketBreak]='Composite'
 group by TCastOriginator,TCastStandardType,TCastComplexFlag,show
 )
 SELECT *
 into dbo.tvmz_error
  FROM a
  left join dbo.tvmz_showlist as b
  on a.TCastComplexFlag=b.id
  go
  */

IF OBJECT_ID('dbo.temp_telcount', 'U') IS NOT NULL  DROP TABLE dbo.temp_telcount;
 IF OBJECT_ID('dbo.temp_showcount', 'U') IS NOT NULL  DROP TABLE dbo.temp_showcount;

 select YearInt, quaterint,weekdayint,TCastDaypart,TCastOriginator,show,TCastPremeireFlag,count(show) as telct
 into dbo.temp_telcount
 from dbo.aquisition
 where PlayDelayLabel='Live _ TV with Digital _ Linear with VOD|0|0' and [MarketBreak]='Composite' 
 and ([TCastStandardType]='DAYTIME DRAMA' 
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

update dbo.aquisition
set TCastLessThan5Flag=vflag
from  dbo.temp_showcount
where aquisition.YearInt=temp_showcount.YearInt
and aquisition.quaterint=temp_showcount.quaterint
and aquisition.weekdayint=temp_showcount.weekdayint
and aquisition.TCastDaypart=temp_showcount.TCastDaypart
and aquisition.TCastOriginator=temp_showcount.TCastOriginator
and aquisition.TCastPremeireFlag=temp_showcount.TCastPremeireFlag
 ;
 go



/******  add average as base******/


IF OBJECT_ID('dbo.temp_show_avg', 'U') IS NOT NULL  DROP TABLE dbo.temp_show_avg;
SELECT [PlayDelayLabel],[MarketBreak],[TCastOriginator],[YearInt],[TCastDaypart],quaterint,weekdayint,show,TCastPremeireFlag,
       avg(F2554) as show_avg_F2554,avg(M2554) as show_avg_M2554,avg(P2554) as show_avg_P2554,avg(P0299) as show_avg_P0299
  into dbo.temp_show_avg
  FROM [ion].[dbo].[aquisition] as a
  where TCastLessThan5Flag=0 
  and  ([TCastStandardType]='DAYTIME DRAMA'
       or ([TCastStandardType]='GENERAL DRAMA' and [TCastExpandedType]!='SERIES - REALITY')
		or ([TCastStandardType]='SITUATION COMEDY' and TCastOriginatorType!='BROADCAST'))
  group by [PlayDelayLabel],[MarketBreak],[TCastOriginator],[YearInt],[TCastDaypart],quaterint,weekdayint,show,TCastPremeireFlag
go

update dbo.aquisition
set  dbo.aquisition.F2554Avg=NULL,
	 dbo.aquisition.M2554Avg=NULL,
	 dbo.aquisition.P2554Avg=NULL,
	 dbo.aquisition.P0299Avg=NULL;

with ave as(
select [PlayDelayLabel],[TCastOriginator],[MarketBreak],[YearInt],[TCastDaypart],quaterint,weekdayint,TCastPremeireFlag,AVG(show_avg_F2554) as avgf,
      AVG(show_avg_M2554) as avgm,AVG(show_avg_P2554) as avgp, AVG(show_avg_P0299) as avgpa
from dbo.temp_show_avg
group by [PlayDelayLabel],[TCastOriginator],[MarketBreak],[YearInt],[TCastDaypart],quaterint,weekdayint,TCastPremeireFlag
)
update dbo.aquisition
set  dbo.aquisition.F2554Avg=ave.avgf,
	 dbo.aquisition.M2554Avg=ave.avgm,
	 dbo.aquisition.P2554Avg=ave.avgp,
	 dbo.aquisition.P0299Avg=ave.avgpa
from ave
where dbo.aquisition.[PlayDelayLabel]=ave.[PlayDelayLabel]
  and dbo.aquisition.[YearInt]=ave.[YearInt]
  and dbo.aquisition.[TCastDaypart]=ave.[TCastDaypart]
  and dbo.aquisition.[MarketBreak]=ave.[MarketBreak]
  and dbo.aquisition.[TCastOriginator]=ave.[TCastOriginator]
  and dbo.aquisition.[quaterint]=ave.[quaterint]
  and dbo.aquisition.[weekdayint]=ave.[weekdayint]
  and dbo.aquisition.[TCastPremeireFlag]=ave.[TCastPremeireFlag]
  ;
go


/******  add rating behavior******/
update dbo.aquisition
set  F2554Bev=NULL,
	 M2554Bev=NULL,
	 P2554Bev=NULL,
	 P0299Bev=NULL
	 ;
go

declare @p_P2554 float;
declare @p_F2554 float;
declare @p_M2554 float;
declare @p_P0299 float;
update dbo.aquisition
set  @p_P2554=case when ValLead=1
     then (case when (P2554/cast(LeadinRate_P2554 as float))>1.1 then 1.1 else P2554/cast(LeadinRate_P2554 as float) end)
	 else 1 end,
	 @p_F2554=case when ValLead=1
     then (case when (F2554/cast(LeadinRate_F2554 as float))>1.1 then 1.1 else F2554/cast(LeadinRate_F2554 as float) end)
	 else 1 end,
	 @p_M2554=case when ValLead=1
     then (case when (M2554/cast(LeadinRate_M2554 as float))>1.1 then 1.1 else M2554/cast(LeadinRate_M2554 as float) end)
	 else 1 end,
	 @p_P0299=case when ValLead=1
     then (case when (P0299/cast(LeadinRate_P0299 as float))>1.1 then 1.1 else P0299/cast(LeadinRate_P0299 as float) end)
	 else 1 end,
	 F2554Bev=F2554/cast(F2554Avg as float)*@p_F2554*@p_F2554,
	 M2554Bev=M2554/cast(M2554Avg as float)*@p_M2554*@p_M2554,
	 P2554Bev=P2554/cast(P2554Avg as float)*@p_P2554*@p_P2554,
	 P0299Bev=P0299/cast(P0299Avg as float)*@p_P0299*@p_P0299
where F2554Avg>0 and M2554Avg>0 and P2554Avg>0 and P0299Avg>0 and LeadinRate_P2554>0 and LeadinRate_F2554>0 and LeadinRate_M2554>0 and LeadinRate_P0299>0
;
go

update dbo.aquisition
set  F2554Bev=(case when F2554Bev<10 then F2554Bev else null end),
	 M2554Bev=(case when M2554Bev<10 then M2554Bev else null end),
	 P2554Bev=(case when P2554Bev<10 then P2554Bev else null end),
	 P0299Bev=(case when P0299Bev<10 then P0299Bev else null end)
	 ;
go


/***raw data done**/
IF OBJECT_ID('dbo.temp1', 'U') IS NOT NULL  DROP TABLE dbo.temp1;
Select YearInt, TCastOriginator,quaterint,weekdayint,TCastDaypart,TCastPremeireFlag,show,avg(P2554) as rating,avg(P2554Bev) as bev,count(show) as ct
into dbo.temp1
from dbo.aquisition
where TCastLessThan5Flag=0  and [MarketBreak]='Composite' and
       ([TCastStandardType]='DAYTIME DRAMA'
       or ([TCastStandardType]='GENERAL DRAMA' and [TCastExpandedType]!='SERIES - REALITY')
		or ([TCastStandardType]='SITUATION COMEDY' and TCastOriginatorType!='BROADCAST'))
group by YearInt, TCastOriginator,quaterint,weekdayint,TCastDaypart,TCastPremeireFlag,show
;
go


/**audience profile**/
IF OBJECT_ID('dbo.temp2', 'U') IS NOT NULL  DROP TABLE dbo.temp2;
SELECT MarketBreak,TCastOriginator,TCastPremeireFlag,show, avg(P2554) as ipm, avg(F2554) as f
into dbo.temp2
 FROM [ion].[dbo].[aquisition]
  where TCastPremeireFlag=1  and [MarketBreak]='Composite' and
       ([TCastStandardType]='DAYTIME DRAMA'
       or ([TCastStandardType]='GENERAL DRAMA' and [TCastExpandedType]!='SERIES - REALITY')
		or ([TCastStandardType]='SITUATION COMEDY'))
  group by  MarketBreak,TCastOriginator,TCastPremeireFlag,show

union
 SELECT  MarketBreak,TCastOriginator,TCastPremeireFlag,show, avg(P2554) as ipm, avg(F2554) as f
 FROM [ion].[dbo].[aquisition]
  where TCastPremeireFlag=1  and [MarketBreak]='HOH ED = 4+ Years College' and
       ([TCastStandardType]='DAYTIME DRAMA'
       or ([TCastStandardType]='GENERAL DRAMA' and [TCastExpandedType]!='SERIES - REALITY')
		or ([TCastStandardType]='SITUATION COMEDY'))
  group by  MarketBreak,TCastOriginator,TCastPremeireFlag,show

union
 SELECT  MarketBreak,TCastOriginator,TCastPremeireFlag,show, avg(P2554) as ipm, avg(F2554) as f
 FROM [ion].[dbo].[aquisition]
  where TCastPremeireFlag=1  and [MarketBreak]='HOH Race = Black' and
       ([TCastStandardType]='DAYTIME DRAMA'
       or ([TCastStandardType]='GENERAL DRAMA' and [TCastExpandedType]!='SERIES - REALITY')
		or ([TCastStandardType]='SITUATION COMEDY'))
  group by MarketBreak,TCastOriginator,TCastPremeireFlag,show
;
go
