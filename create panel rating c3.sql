 Insert Into dbo.panel_rating_c3 
      ([BroadcastDate]
	  ,[Year]
	  ,[Month]
	  ,[Week]
	  ,[WeekDay]
	  ,[Hour]
      ,[MarketBreak]
      ,[TCastStartTime]
      ,[STDate]
	  ,[TCastDayPart]
      ,[TCastName]
      ,[Show]
      ,[ProgramID]
      ,[TCastID]
      ,[TCastOriginator]
      ,[TCastOriginatorID]
      ,[TCastOriginatorType]
      ,[TCastStandardType]
      ,[TCastExpandedType]
	  ,[TCastSpecialFlag]
	  ,[TCastCoverageArea]
	  ,[TCastTrackageName]
	  ,[TCastEpisodeTitle]
	  ,[TCastLiveFlag]
      ,[TCastRepeatsFlag]
      ,[TCastDuration]
      ,[TCastCommercialDuration]
      ,[PlayDelayLabel]
      ,[HHProjection]
      ,[HHPUT]
      ,[HHUE]
	  ,[P0299]
      ,[P2554]
      ,[F2554]
	  ,[P1849]
	  ,[F1849]
	  ,[MedianAge]
      ,[MedianIncome])
SELECT a.[BroadcastDate]
      ,DATEPART(YEAR,a.[BroadcastDate]) as [Year]
	  ,DATEPART(MONTH,a.[BroadcastDate]) as [Month]
	  ,DATEPART(WEEK,a.[BroadcastDate]) as [Week]
	  ,DATEPART(WEEKDAY,a.[BroadcastDate]) as [WeekDay]
	  ,DATEPART(HOUR,a.[TCastStartTime]) as [Hour]
      ,a.[MarketBreak]
      ,a.[TCastStartTime]
	  ,CASE
	   WHEN (a.[TCastStartTime]>=convert(time,'0:0:0',108) and a.[TCastStartTime]<convert(time,'3:0:0',108))
	   THEN 
	   DATEADD(day,1,a.[BroadcastDate])
	   ELSE
	   a.[BroadcastDate]
	   END as [STDate]
      ,a.[TCastDaypart]
      ,a.[TCastName]
	  ,b.[show] as [Show]
      ,a.[ProgramID]
      ,a.[TCastID]
      ,a.[TCastOriginator]
      ,a.[TCastOriginatorID]
      ,a.[TCastOriginatorType]
      ,a.[TCastStandardType]
      ,a.[TCastExpandedType]
	  ,a.[TCastSpecialFlag]
	  ,a.[TCastCoverageArea]
	  ,a.[TCastTrackageName]
	  ,a.[TCastEpisodeTitle]
	  ,a.[TCastLiveFlag]
      ,a.[TCastRepeatsFlag]
      ,a.[TCastDuration]
      ,a.[TCastCommercialDuration]
      ,a.[PlayDelayLabel]
      ,[HHProjection]
      ,[HHPUT]
      ,[HHUE]
	  ,([F25NCCMProjection]+[M25NCCMProjection]+[F68NCCMProjection]+[M68NCCMProjection]+[F911NCCMProjection]+[M911NCCMProjection]
      +[F1224NCCMProjection]+[M1224NCCMProjection]+[F1517NCCMProjection]+[M1517NCCMProjection]+[F1820NCCMProjection]+[M1820NCCMProjection]
      +[F2124NCCMProjection]+[M2124NCCMProjection]+[F2529NCCMProjection]+[M2529NCCMProjection]+[F3034NCCMProjection]
      +[M3034NCCMProjection]+[F3539NCCMProjection]+[M3539NCCMProjection]+[F4044NCCMProjection]
      +[M4044NCCMProjection]+[F4549NCCMProjection]+[M4549NCCMProjection]+[F5054NCCMProjection]
      +[M5054NCCMProjection]+[F5559NCCMProjection]+[M5559NCCMProjection]+[F6064NCCMProjection]
      +[M6064NCCMProjection]+[F6599NCCMProjection]+[M6599NCCMProjection]) as [P0299]
	  ,([F2529NCCMProjection]+[F3034NCCMProjection]+[F3539NCCMProjection]+[F4044NCCMProjection]+[F4549NCCMProjection]+[F5054NCCMProjection]
	  +[M2529NCCMProjection]+[M3034NCCMProjection]+[M3539NCCMProjection]+[M4044NCCMProjection]+[M4549NCCMProjection]+[M5054NCCMProjection]) as [P2554]
      ,([F2529NCCMProjection]+[F3034NCCMProjection]+[F3539NCCMProjection]+[F4044NCCMProjection]+[F4549NCCMProjection]+[F5054NCCMProjection]) as [F2554]
	  ,([F1820NCCMProjection]+[M1820NCCMProjection]+[F2124NCCMProjection]+[M2124NCCMProjection]+[F2529NCCMProjection]+[M2529NCCMProjection]
	  +[F3034NCCMProjection]+[M3034NCCMProjection]+[F3539NCCMProjection]+[M3539NCCMProjection]+[F4044NCCMProjection]+[M4044NCCMProjection]
	  +[F4549NCCMProjection]+[M4549NCCMProjection]) as [P1849]
	  ,([F1820NCCMProjection]+[F2124NCCMProjection]+[F2529NCCMProjection]+[F3034NCCMProjection]+[F3539NCCMProjection]+[F4044NCCMProjection]+[F4549NCCMProjection])as [F1849]
	  ,c.[MedianAge]
	  ,c.[MedianIncome]
	  from dbo.net_rating_1819 as a 
         left join dbo.titles_shows as b
      on (a.TCastName=b.tcast_name and a.TCastOriginatorID=b.tcast_originator_id and a.ProgramID=b.program_id)
         left join dbo.net_median as c
     on (a.BroadcastDate=c.BroadcastDate and a.TCastOriginator=c.TCastOriginator and a.TCastStartTime=c.TCastStartTime)
where a.PlayDelayLabel='Live+3 Days (+75 Hours) _ TV with Digital _ Linear with VOD|0|4500'
and a.MarketBreak='Composite' 
and a.BroadcastDate>='2019-04-01';
go

 /******  remove dup******/
WITH CTE AS(
   SELECT *, RN = ROW_NUMBER()OVER(PARTITION BY [TCastOriginator],[MarketBreak],[BroadcastDate],[TCastStartTime] ORDER BY [HHProjection] desc)
   FROM dbo.panel_rating_c3
)
DELETE FROM CTE WHERE RN > 1;
go

/****update add marketbreak****/
with edu as (
select [BroadcastDate],[TCastStartTime],[TCastOriginator],
         ([F2529NCCMProjection]+[F3034NCCMProjection]+[F3539NCCMProjection]+[F4044NCCMProjection]+[F4549NCCMProjection]+[F5054NCCMProjection]
	  +[M2529NCCMProjection]+[M3034NCCMProjection]+[M3539NCCMProjection]+[M4044NCCMProjection]+[M4549NCCMProjection]+[M5054NCCMProjection]) as [P2554]
from dbo.net_rating_1819
where MarketBreak='HOH ED = 4+ Years College' and PlayDelayLabel='Live+3 Days (+75 Hours) _ TV with Digital _ Linear with VOD|0|4500'
)
update dbo.[panel_rating_c3]
set dbo.[panel_rating_c3].EduP2554=edu.P2554
from edu
where dbo.[panel_rating_c3].BroadcastDate=edu.BroadcastDate
 and dbo.[panel_rating_c3].TCastStartTime=edu.TCastStartTime
 and dbo.[panel_rating_c3].TCastOriginator=edu.TCastOriginator;
 go

 with his as (
select [BroadcastDate],[TCastStartTime],[TCastOriginator],
         ([F2529NCCMProjection]+[F3034NCCMProjection]+[F3539NCCMProjection]+[F4044NCCMProjection]+[F4549NCCMProjection]+[F5054NCCMProjection]
	  +[M2529NCCMProjection]+[M3034NCCMProjection]+[M3539NCCMProjection]+[M4044NCCMProjection]+[M4549NCCMProjection]+[M5054NCCMProjection]) as [P2554]
from dbo.net_rating_1819
where MarketBreak='HOH Origin = Hispanic' and PlayDelayLabel='Live+3 Days (+75 Hours) _ TV with Digital _ Linear with VOD|0|4500'
)
update dbo.[panel_rating_c3]
set dbo.[panel_rating_c3].HisP2554=his.P2554
from his
where dbo.[panel_rating_c3].BroadcastDate=his.BroadcastDate
 and dbo.[panel_rating_c3].TCastStartTime=his.TCastStartTime
 and dbo.[panel_rating_c3].TCastOriginator=his.TCastOriginator;
 go

  with aa as (
select [BroadcastDate],[TCastStartTime],[TCastOriginator],
         ([F2529NCCMProjection]+[F3034NCCMProjection]+[F3539NCCMProjection]+[F4044NCCMProjection]+[F4549NCCMProjection]+[F5054NCCMProjection]
	  +[M2529NCCMProjection]+[M3034NCCMProjection]+[M3539NCCMProjection]+[M4044NCCMProjection]+[M4549NCCMProjection]+[M5054NCCMProjection]) as [P2554]
from dbo.net_rating_1819
where MarketBreak='HOH Race = Black' and PlayDelayLabel='Live+3 Days (+75 Hours) _ TV with Digital _ Linear with VOD|0|4500'
)
update dbo.[panel_rating_c3]
set dbo.[panel_rating_c3].AaP2554=aa.P2554
from aa
where dbo.[panel_rating_c3].BroadcastDate=aa.BroadcastDate
 and dbo.[panel_rating_c3].TCastStartTime=aa.TCastStartTime
 and dbo.[panel_rating_c3].TCastOriginator=aa.TCastOriginator;
 go

   with ota as (
select [BroadcastDate],[TCastStartTime],[TCastOriginator],
         ([F2529NCCMProjection]+[F3034NCCMProjection]+[F3539NCCMProjection]+[F4044NCCMProjection]+[F4549NCCMProjection]+[F5054NCCMProjection]
	  +[M2529NCCMProjection]+[M3034NCCMProjection]+[M3539NCCMProjection]+[M4044NCCMProjection]+[M4549NCCMProjection]+[M5054NCCMProjection]) as [P2554]
from dbo.net_rating_1819
where MarketBreak='Cable Status Broadcast Only' and PlayDelayLabel='Live+3 Days (+75 Hours) _ TV with Digital _ Linear with VOD|0|4500'
)
update dbo.[panel_rating_c3]
set dbo.[panel_rating_c3].OtaP2554=ota.P2554
from ota
where dbo.[panel_rating_c3].BroadcastDate=ota.BroadcastDate
 and dbo.[panel_rating_c3].TCastStartTime=ota.TCastStartTime
 and dbo.[panel_rating_c3].TCastOriginator=ota.TCastOriginator;
 go


/**creat leadin column, only used first time create table**/
/*
Alter table dbo.panel_rating_ion_c3 add AirOrder bigint NULL, leadin_stddate date NULL,
leadin_stdtime datetime NULL,Leadin_Show varchar(99) NULL,Leadin_Original smallint NULL,
Leadin_HH bigint NULL,Leadin_P2554 bigint NULL,Leadin_MedianAge numeric(10, 2) NULL,
Leadin_MedianIncome numeric(10, 2) NULL,Leadin_Duration bigint NULL
;
go
*/

/******  add lead in ******/
with cet as (
select [TCastOriginator],[MarketBreak],[STDate],[TCastStartTime],
       rn=ROW_NUMBER() OVER(ORDER BY [TCastOriginator],[MarketBreak],[STDate],[TCastStartTime])
from dbo.panel_rating_c3
)
update dbo.panel_rating_c3
set AirOrder=cet.rn
from cet
where dbo.panel_rating_c3.[TCastOriginator]=cet.[TCastOriginator]
and dbo.panel_rating_c3.[MarketBreak]=cet.[MarketBreak]
and dbo.panel_rating_c3.[STDate]=cet.[STDate]
and dbo.panel_rating_c3.[TCastStartTime]=cet.[TCastStartTime];
go

with shif as(
select AirOrder+1 as idnew,[TCastOriginator],[MarketBreak],STDate,TCastStartTime,show,TCastRepeatsFlag,P2554,MedianAge,MedianIncome,TCastDuration
from dbo.panel_rating_c3)
update dbo.panel_rating_c3
set  dbo.panel_rating_c3.leadin_stddate=shif.STDate,
	 dbo.panel_rating_c3.leadin_stdtime=shif.TCastStartTime,
	 dbo.panel_rating_c3.Leadin_Show=shif.show,
	 dbo.panel_rating_c3.leadin_Original=shif.TCastRepeatsFlag,
	 dbo.panel_rating_c3.Leadin_P2554=shif.P2554,
	 dbo.panel_rating_c3.Leadin_MedianAge=shif.MedianAge,
	 dbo.panel_rating_c3.Leadin_MedianIncome=shif.MedianIncome,
	 dbo.panel_rating_c3.Leadin_Duration=shif.TCastDuration
from shif
where dbo.panel_rating_c3.AirOrder=shif.idnew 
and dbo.panel_rating_c3.TCastOriginator=shif.TCastOriginator 
and dbo.panel_rating_c3.MarketBreak=shif.MarketBreak;
go
