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
	   on a.TCastName=b.tcast_name and a.TCastOriginatorID=b.tcast_originator_id
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
	TCastComplexFlag=0
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
and aquisition.[TCastComplexFlag]=tvmz_neilsen_match.[mzshowid]
 ;
 go

--still use repeat flag as premeireflag for braodcast networks(except ion)
update dbo.aquisition
set TCastPremeireFlag=TCastRepeatsFlag
where aquisition.TCastOriginatorType='BROADCAST' and TCastOriginator!='ION'
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
     then (case when (P2554/cast(LeadinRate_P2554 as float))>1.2 then 1.2 else P2554/cast(LeadinRate_P2554 as float) end)*(case when LeadinType=TCastStandardType then 1 else 1.2 end)
	 else 1 end,
	 @p_F2554=case when ValLead=1
     then (case when (F2554/cast(LeadinRate_F2554 as float))>1.2 then 1.2 else F2554/cast(LeadinRate_F2554 as float) end)*(case when LeadinType=TCastStandardType then 1 else 1.2 end)
	 else 1 end,
	 @p_M2554=case when ValLead=1
     then (case when (M2554/cast(LeadinRate_M2554 as float))>1.2 then 1.2 else M2554/cast(LeadinRate_M2554 as float) end)*(case when LeadinType=TCastStandardType then 1 else 1.2 end)
	 else 1 end,
	 @p_P0299=case when ValLead=1
     then (case when (P0299/cast(LeadinRate_P0299 as float))>1.2 then 1.2 else P0299/cast(LeadinRate_P0299 as float) end)*(case when LeadinType=TCastStandardType then 1 else 1.2 end)
	 else 1 end,
	 F2554Bev=F2554/cast(F2554Avg as float)*@p_F2554,
	 M2554Bev=M2554/cast(M2554Avg as float)*@p_M2554,
	 P2554Bev=P2554/cast(P2554Avg as float)*@p_P2554,
	 P0299Bev=P0299/cast(P0299Avg as float)*@p_P0299
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

IF OBJECT_ID('dbo.aquisition_result', 'U') IS NOT NULL  DROP TABLE dbo.aquisition_result;
with allshow as(
  select a.TCastOriginator, a.show, a.TCastStandardType
  from dbo.aquisition as a
  group by a.TCastOriginator, a.show, a.TCastStandardType
), 
org as (
  select a.TCastOriginator,a.show, a.TCastStandardType,avg(P2554) as P2554Org, count(P2554) as TelOrg,
  DATEDIFF(day,min(BroadcastDate),GETDATE()) as sday, DATEDIFF(day,max(BroadcastDate),GETDATE()) as eday
  from dbo.aquisition as a
  where a.TCastPremeireFlag=0 and a.TCastLessThan5Flag=0 and MarketBreak='Composite' and PlayDelayLabel='Live _ TV with Digital _ Linear with VOD|0|0' 
  group by a.TCastOriginator,a.show, a.TCastStandardType
),
rep as(
 select a.show,a.TCastOriginator, a.TCastStandardType,avg(P2554) as P2554Rep, count(P2554) as TelRep,
         avg(P0299) as P0299Rep,avg(F2554) as F2554Rep,avg(M2554) as M2554Rep,
         avg(P0299Bev) as P0299Bev, avg(F2554Bev) as F2554Bev, avg(M2554Bev) as M2554Bev,
		 avg(MedianAge) as MedianAge, avg(MedianIncome) as MedianIncome
  from dbo.aquisition as a
  where a.TCastPremeireFlag=1 and a.TCastLessThan5Flag=0 and MarketBreak='Composite' and PlayDelayLabel='Live _ TV with Digital _ Linear with VOD|0|0' 
  group by a.show,a.TCastOriginator, a.TCastStandardType
),
leadin as(
  select a.TCastOriginator, a.show, a.TCastStandardType, avg(LeadinRate_P2554) as LeadinP2554
  from dbo.aquisition as a
  where a.TCastPremeireFlag=1 and a.TCastLessThan5Flag=0 and a.ValLead=1 and MarketBreak='Composite' and PlayDelayLabel='Live _ TV with Digital _ Linear with VOD|0|0'
  group by a.TCastOriginator, a.show, a.TCastStandardType
),
edu as(
 select a.show,a.TCastOriginator, a.TCastStandardType,avg(F2554Bev) as F2554Bev, avg(M2554Bev) as M2554Bev,avg(F2554) as F2554, avg(M2554) as M2554
 from dbo.aquisition as a
 where a.TCastPremeireFlag=1 and a.TCastLessThan5Flag=0 and MarketBreak='HOH ED = 4+ Years College' and PlayDelayLabel='Live _ TV with Digital _ Linear with VOD|0|0'
 group by a.TCastOriginator, a.show, a.TCastStandardType
),
bla as(
 select a.show,a.TCastOriginator, a.TCastStandardType,avg(F2554Bev) as F2554Bev, avg(M2554Bev) as M2554Bev,avg(F2554) as F2554, avg(M2554) as M2554
 from dbo.aquisition as a
 where a.TCastPremeireFlag=1 and a.TCastLessThan5Flag=0 and MarketBreak='HOH Race = Black' and PlayDelayLabel='Live _ TV with Digital _ Linear with VOD|0|0'
 group by a.TCastOriginator, a.show, a.TCastStandardType
)
select a.show as ShowName, a.TCastOriginator as Net, a.TCastStandardType as ShowType,
       org.P2554Org as P2554Org, org.TelOrg as TelOrg,
	   rep.P2554Rep as P2554Rep, rep.TelRep as TelRep, 
	   org.sday as startday, org.eday as endday,
	   leadin.LeadinP2554 as P2554leadin,rep.P0299Rep as  P0299, rep.F2554Rep as F2554, rep.M2554Rep as M2554,
	   rep.P0299Bev as P0299Bev, rep.F2554Bev as F2554Bev, rep.M2554Bev as M2554Bev,
	  
	   edu.F2554 as F2554Edu, edu.M2554 as M2554Edu,
	   bla.F2554 as F2554Bla, bla.M2554 as M2554Bla,
	   edu.F2554Bev as F2554BevEdu, edu.M2554Bev as M2554BevEdu,
	   bla.F2554Bev as F2554BevBla, bla.M2554Bev as M2554BevBla,

	   rep.MedianAge as MedianAge, rep.MedianIncome as MedianIncome

into dbo.aquisition_result
from allshow as a
left join org
on a.TCastOriginator=org.TCastOriginator and a.show=org.show and a.TCastStandardType=org.TCastStandardType
left join rep
on a.TCastOriginator=rep.TCastOriginator and a.show=rep.show and a.TCastStandardType=rep.TCastStandardType
left join leadin
on a.TCastOriginator=leadin.TCastOriginator and a.show=leadin.show and a.TCastStandardType=leadin.TCastStandardType
left join edu
on a.TCastOriginator=edu.TCastOriginator and a.show=edu.show and a.TCastStandardType=edu.TCastStandardType
left join bla
on a.TCastOriginator=bla.TCastOriginator and a.show=bla.show and a.TCastStandardType=bla.TCastStandardType;
go

ALTER TABLE dbo.aquisition_result Add MarketFactor float null;
ALTER TABLE dbo.aquisition_result Add MarketFactor_ave float null;
ALTER TABLE dbo.aquisition_result Add Net_Count int null;
ALTER TABLE dbo.aquisition_result Add ViewerFactor float null;
ALTER TABLE dbo.aquisition_result Add RepeatFactor float null;
ALTER TABLE dbo.aquisition_result Add ShowageFactor float null;
ALTER TABLE dbo.aquisition_result Add TeleFactor float null;
ALTER TABLE dbo.aquisition_result Add RankIndex float null;
go

update dbo.aquisition_result
/*set MarketFactor=(0.6*(1*F2554Bev+0.0*F2554BevBro-0.4*F2554BevEdu+0*F2554BevHis+1*F2554BevBla)+0.4*(1*M2554Bev+0.0*M2554BevBro-0.4*M2554BevEdu+0*M2554BevHis+1*M2554BevBla)+0.5*P0299Bev) */
set MarketFactor=(0.6*(1*F2554Bev-0.4*F2554BevEdu+0.4*F2554BevBla)+0.4*(1*M2554Bev-0.4*M2554BevEdu+0.4*M2554BevBla)+0.5*P0299Bev)/1.5
;
go

declare @leadave decimal(10,5);
/*set @leadave=(select AVG(P2554Rep/cast(P2554leadin as decimal(25,5))) from dbo.aquisition_result where P2554leadin>0 and TelOrg>5 and TelRep>5);*/
set  @leadave=0.8;
declare @repave decimal(10,5);
/*set @repave=(select AVG(P2554Rep/cast(P2554Org as decimal(25,5))) from dbo.aquisition_result where TelOrg>5 and TelRep>5);*/
set @repave=0.50;
declare @telorgave decimal(10,5);
/*set @telorgave=(select AVG(LOG10(TelOrg)) from dbo.aquisition_result where TelOrg>5 and TelRep>5);*/
set @telorgave=1.6;

--exlcude esquire because its show type wrong, NCLA only compared to house
with mf as (
select ShowName as name, AVG(MarketFactor) as mkf,count(Net) as ncount
from dbo.aquisition_result
where TelRep>10 and Net!='ESQUIRE NETWORK' and P2554Rep>30000
group by ShowName
)
update a
set MarketFactor_ave=mf.mkf,
    Net_Count=mf.ncount,
	--LeadFactor=case when P2554leadin>0 then (P2554RepL3/cast(P2554leadin as decimal(25,5))/@leadave-1)*0.2+1 else 1 end,
	ViewerFactor=(1-(0.5*ABS(MedianAge/54.0-1)+0.5*ABS(MedianIncome/38000.0-1))),
	RepeatFactor=case when (P2554Org>0 and P2554Rep>0) then 0.6+0.4/(1+EXP(-(P2554Rep/cast(P2554Org as decimal(25,5))-@repave)*20)) else 0.8 end,
	ShowageFactor=case when (startday>0 and endday>0) then 1-0.3/(1+EXP(-((startday*0.1+endday*0.9)-1000)*0.0015)) else 0.9 end,
	TeleFactor=case when (TelOrg>5 and TelRep>5) then ((LOG10(TelOrg)/@telorgave-1)*0.1+1)*(0.8+0.2/(1+EXP(-(TelRep/cast(TelOrg as decimal(10,5))-0.6)*5))) else 0.9 end
from dbo.aquisition_result as a
left join mf on a.ShowName=mf.name;


update dbo.aquisition_result
--set RankIndex=(MarketFactor_ave*LeadFactor)*ViewerFactor*RepeatFactor*ShowageFactor*TeleFactor
set RankIndex=(MarketFactor_ave)*ViewerFactor*RepeatFactor*ShowageFactor*TeleFactor
;
go

SELECT *
  FROM [ion].[dbo].[aquisition_result]
  where (Net='ABC' or Net='NBC' or Net='CBS' or Net='FOX' or Net='TURNER NETWORK TELEVISION' or Net='USA NETWORK')
  and ShowType='GENERAL DRAMA' or showtype='DAYTIME DRAMA'
  and TelRep>15 and TelOrg>5
  order by RankIndex desc