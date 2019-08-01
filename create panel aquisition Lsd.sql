/****** Script for SelectTopNRows command from SSMS  ******/
insert into dbo.aquisition_lsd (
       [BroadcastDate]
      ,[Season]
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
      ,[P2554]
	  ,[P1849]
)
SELECT a.[BroadcastDate]
      ,CASE
	   WHEN a.[BroadcastDate]>='2017-09-25' and a.[BroadcastDate]<='2018-09-30' THEN 1718
	   WHEN a.[BroadcastDate]>='2018-10-01' and a.[BroadcastDate]<='2019-09-29' THEN 1819
	   ELSE NULL
	   END
	   as Season
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
	  ,([F2529Projection]+[F3034Projection]+[F3539Projection]+[F4044Projection]+[F4549Projection]+[F5054Projection]
      +[M2529Projection]+[M3034Projection]+[M3539Projection]+[M4044Projection]+[M4549Projection]+[M5054Projection]) as P2554
	  ,([F1820Projection]+[F2124Projection]+[F2529Projection]+[F3034Projection]+[F3539Projection]+[F4044Projection]+[F4549Projection]
      +[M1820Projection]+[M2124Projection]+[M2529Projection]+[M3034Projection]+[M3539Projection]+[M4044Projection]+[M4549Projection]) as P1849
	   from dbo.net_rating_1819 as a
	   left join dbo.titles_shows as b
	   on a.TCastName=b.tcast_name and a.TCastOriginatorID=b.tcast_originator_id
	   left join dbo.net_median as c
	   on (a.BroadcastDate=c.BroadcastDate and a.TCastOriginator=c.TCastOriginator and a.TCastStartTime=c.TCastStartTime)
where (a.PlayDelayLabel='Live+SD _ TV with Digital _ Linear with VOD|0|0')
	 and (a.[MarketBreak]='Composite')
	 and a.BroadcastDate>='2019-04-01'
	 ;
go


with cet as(
select *, rn=ROW_NUMBER()OVER(PARTITION BY PlayDelayLabel,MarketBreak,BroadcastDate,TCastStartTime,TCastOriginator,TCastName ORDER BY HHProjection desc)
from dbo.aquisition_lsd
)
delete from cet where rn>1;
go


/****** add AA rating******/

with aa as(
  select TCastOriginator,BroadcastDate,TCastStartTime,TCastID,([F2529Projection]+[F3034Projection]+[F3539Projection]+[F4044Projection]+[F4549Projection]+[F5054Projection]
      +[M2529Projection]+[M3034Projection]+[M3539Projection]+[M4044Projection]+[M4549Projection]+[M5054Projection]) as P2554
  from dbo.net_rating_1819
  where MarketBreak='HOH Race = Black' and PlayDelayLabel='Live+SD _ TV with Digital _ Linear with VOD|0|0' 
  and BroadcastDate>='2018-12-31'
)
update dbo.aquisition_lsd
set aquisition_lsd.AaP2554=aa.P2554
from aa
where [dbo].[aquisition_lsd].TCastOriginator=aa.TCastOriginator
and [dbo].[aquisition_lsd].BroadcastDate=aa.BroadcastDate
and [dbo].[aquisition_lsd].TCastStartTime=aa.TCastStartTime
and [dbo].[aquisition_lsd].TCastID=aa.TCastID
	;

/****** create original flag  ******/
update dbo.aquisition_lsd
set TCastPremeireFlag=1,
    TCastComplexFlag=0
where aquisition_lsd.BroadcastDate >='2018-10-01'
;
go

update dbo.aquisition_lsd
set TCastComplexFlag=tvmz_eplist.showid
from  tvmz_eplist
where aquisition_lsd.BroadcastDate=cast(tvmz_eplist.[airdate] as date)
 and aquisition_lsd.TCastStartTime=cast(tvmz_eplist.[airtime] as time)
 and aquisition_lsd.TCastOriginatorID=tvmz_eplist.[nlnetid]
 and aquisition_lsd.BroadcastDate >='2018-10-01'
 ;
 go


update dbo.aquisition_lsd
set TCastPremeireFlag=0
from  tvmz_neilsen_match
where aquisition_lsd.[show]=tvmz_neilsen_match.[showname]
and aquisition_lsd.[TCastComplexFlag]=tvmz_neilsen_match.[mzid]
and aquisition_lsd.[TCastComplexFlag]>0
and aquisition_lsd.BroadcastDate >='2018-10-01'
 ;
 go

update dbo.aquisition_lsd
set TCastPremeireFlag=TCastRepeatsFlag
where TCastOriginator='ABC' or TCastOriginator='CBS' or TCastOriginator='FOX' or TCastOriginator='NBC'
and aquisition_lsd.BroadcastDate >='2018-10-01'
 ;
 go

with hourav as(
 select MarketBreak, TCastOriginatorID,HourInt, avg(P2554) as av
 from dbo.aquisition_lsd
 where aquisition_lsd.BroadcastDate >='2018-10-01'
 group by MarketBreak, TCastOriginatorID,HourInt
) 
update dbo.aquisition_lsd
set dbo.aquisition_lsd.hourav=hourav.av
from hourav
where dbo.aquisition_lsd.MarketBreak=hourav.MarketBreak and dbo.aquisition_lsd.TCastOriginatorID=hourav.TCastOriginatorID and dbo.aquisition_lsd.HourInt=hourav.HourInt
;
go
---lsd raw data done

IF OBJECT_ID('dbo.panel_aquisition_Lsd', 'U') IS NOT NULL  DROP TABLE dbo.panel_aquisition_Lsd;
select show,TCastOriginatorID, 0 as org_ct, 0 as median_age, 0 as hh, 0 as P2554,0 as P1849, 0 as F2554, 0 as AA2554, 0 as P2554_PrimAvg,
       0 as org_rep_ct, 0 as org_rep_p2554, 0 as org_rep_hourav
into dbo.panel_aquisition_Lsd
from dbo.aquisition_lsd
where MarketBreak='Composite'
group by show, TCastOriginatorID;
go

Alter table dbo.panel_aquisition_Lsd ALTER COLUMN median_age int null;
Alter table dbo.panel_aquisition_Lsd ADD TCastOriginator nvarchar(45) null;
Alter table dbo.panel_aquisition_Lsd ADD org_firstair date null;
Alter table dbo.panel_aquisition_Lsd ADD org_lastair date null;
go

with org as(
select show,TCastOriginatorID,count(show) as orgct, min(BroadcastDate) as ofd,max(BroadcastDate) as old,avg(MedianAge) as age, avg(HHProjection) as hh, avg(P2554) as P2554,avg(P1849) as P1849, avg(F2554) as F2554
from dbo.aquisition_lsd
where MarketBreak='Composite' and TCastPremeireFlag=0
group by show,TCastOriginatorID
)
update dbo.panel_aquisition_Lsd
set  org_ct=org.orgct,
    org_firstair=org.ofd,
	org_lastair=org.old,
    median_age=org.age,
	hh=org.hh,
	P2554=org.P2554,
	P1849=org.P1849,
	F2554=org.F2554
from org
where dbo.panel_aquisition_Lsd.show=org.show and dbo.panel_aquisition_Lsd.TCastOriginatorID=org.TCastOriginatorID
;
go

WITH CTE AS(
   SELECT *, RN = ROW_NUMBER()OVER(PARTITION BY show ORDER BY org_ct desc)
   FROM dbo.panel_aquisition_Lsd
)
DELETE FROM CTE WHERE RN > 1 and org_ct=0;
go

with pa as(
  select TCastOriginatorID, avg(P2554) as av
  from dbo.aquisition_lsd
  where MarketBreak='Composite' and TCastPremeireFlag=0 and TCastDaypart='PRIME TIME'
  group by TCastOriginatorID
)
update dbo.panel_aquisition_Lsd
set P2554_PrimAvg=pa.av
from pa
where dbo.panel_aquisition_Lsd.TCastOriginatorID=pa.TCastOriginatorID
;
go

with aa as (
  select show,TCastOriginatorID, avg(AaP2554) as av
  from dbo.aquisition_lsd
  where MarketBreak='Composite' and TCastPremeireFlag=0
  group by show,TCastOriginatorID
)
update dbo.panel_aquisition_Lsd
set AA2554=aa.av
from aa
where dbo.panel_aquisition_Lsd.show=aa.show and dbo.panel_aquisition_Lsd.TCastOriginatorID=aa.TCastOriginatorID
;
go

with rep as (
  select show,TCastOriginatorID, count(show) as ct, avg(P2554) as av, avg(hourav) as hourav
  from dbo.aquisition_lsd
  where MarketBreak='Composite' and TCastPremeireFlag=1
  group by show,TCastOriginatorID
)
update dbo.panel_aquisition_Lsd
set  org_rep_ct=rep.ct,
     org_rep_p2554=rep.av,
	 org_rep_hourav=rep.hourav
from rep
where dbo.panel_aquisition_Lsd.show=rep.show and dbo.panel_aquisition_Lsd.TCastOriginatorID=rep.TCastOriginatorID and dbo.panel_aquisition_Lsd.org_ct>0
;
go

IF OBJECT_ID('dbo.temp', 'U') IS NOT NULL  DROP TABLE dbo.temp;
select show, TCastOriginatorID,count(show) as ct, avg(P2554) as P2554, avg(hourav) as hourav, min(BroadcastDate) as fd,max(BroadcastDate) as ld, 0 as flag
into dbo.temp
from aquisition_lsd
where MarketBreak='Composite' and TCastPremeireFlag=1
group by show, TCastOriginatorID
go

update dbo.temp
set flag=panel_aquisition_Lsd.org_rep_ct
from dbo.panel_aquisition_Lsd
where temp.show=panel_aquisition_Lsd.show and temp.TCastOriginatorID=panel_aquisition_Lsd.TCastOriginatorID

delete from dbo.temp
where flag>0;
go

with m as(
 select show,max(ct) as ct
 from dbo.temp
 group by show
)
update dbo.temp
set flag=1
from m
where temp.show=m.show and temp.ct=m.ct and temp.ct>0;
go

delete from dbo.temp
where flag=0;
go



alter table dbo.panel_aquisition_Lsd add rep_net nvarchar(45);
alter table dbo.panel_aquisition_Lsd add rep_netid bigint;
alter table dbo.panel_aquisition_Lsd add rep_count bigint;
alter table dbo.panel_aquisition_Lsd add rep_firstair date;
alter table dbo.panel_aquisition_Lsd add rep_lastair date;
alter table dbo.panel_aquisition_Lsd add rep_p2554 bigint;
alter table dbo.panel_aquisition_Lsd add rep_hourave bigint;

go

update dbo.panel_aquisition_Lsd
set  rep_netid=temp.TCastOriginatorID,
     rep_count=temp.ct,
	 rep_firstair=temp.fd,
	 rep_lastair=temp.ld,
	 rep_p2554=temp.P2554,
	 rep_hourave=temp.hourav
	 
from temp
where dbo.panel_aquisition_Lsd.show=temp.show
;
go

with net as(
 select current_id as id, channel as name
 from dbo.[titles_networks(arj)]
 group by current_id,channel
)
update dbo.panel_aquisition_Lsd
set  TCastOriginator=net.name
from net
where dbo.panel_aquisition_Lsd.TCastOriginatorID=net.id
;
go

with net as(
 select current_id as id, channel as name
 from dbo.[titles_networks(arj)]
 group by current_id,channel
)
update dbo.panel_aquisition_Lsd
set  rep_net=net.name
from net
where dbo.panel_aquisition_Lsd.rep_netid=net.id
;
go

select show,TCastOriginatorID,rep_netid,TCastOriginator,org_firstair,org_lastair,org_ct,median_age,hh/1000 as hh,P2554/1000 p2554,P1849/1000 as p1849,(case when P2554>0 then F2554/cast(P2554 as float) else 0 end) as FePecent,
        (case when P2554>0 then AA2554/cast(P2554 as float) else 0 end) as AaPecent,P2554_PrimAvg/1000 as PrimNetAvg,(case when P2554_PrimAvg>0 then P2554/cast(P2554_PrimAvg as float) else 0 end) as PrgIndex,
       org_rep_ct,org_rep_p2554/1000,(case when P2554>0 then org_rep_p2554/cast(P2554 as float) else 0 end) as repeatfactor,org_rep_hourav/1000 as orgrepave,(case when org_rep_hourav>0 then org_rep_p2554/cast(org_rep_hourav as float) else 0 end) as repeatindex,
	   rep_net,rep_firstair,rep_lastair,rep_count,rep_p2554/1000 as repp2554,rep_hourave/1000 as repave,(case when rep_hourave>0 then rep_p2554/cast(rep_hourave as float) else 0 end) as repeatindex2
from dbo.panel_aquisition_Lsd