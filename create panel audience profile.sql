Insert Into dbo.panel_audience_profile ([BroadcastDate]
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
      ,[TCastRepeatsFlag]
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
      ,[F1849]
      ,[M1849])
SELECT a.[BroadcastDate]
      ,year(a.[BroadcastDate]) as YearInt
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
      ,a.[TCastRepeatsFlag]
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
	  ,([F1820Projection]+[F2124Projection]+[F2529Projection]+[F3034Projection]+[F3539Projection]+[F4044Projection]+[F4549Projection]) as F1849
      ,([M1820Projection]+[M2124Projection]+[M2529Projection]+[M3034Projection]+[M3539Projection]+[M4044Projection]+[M4549Projection]) as M1849
	  from dbo.net_rating_1819 as a 
         left join dbo.titles_shows as b
      on a.TCastName=b.tcast_name and a.TCastOriginator=b.tcast_originator
         left join dbo.net_median as c
     on (a.BroadcastDate=c.BroadcastDate and a.TCastOriginator=c.TCastOriginator and a.TCastStartTime=c.TCastStartTime)
where a.PlayDelayLabel='Live+3 Days (+75 Hours) _ TV with Digital _ Linear with VOD|0|4500'
and (a.[TCastStandardType]='GENERAL DRAMA' or a.[TCastStandardType]='DAYTIME DRAMA' or a.[TCastStandardType]='GENERAL VARIETY' 
     or a.[TCastStandardType]='FEATURE FILM' or a.[TCastStandardType]='ADVENTURE' or a.[TCastStandardType]='SITUATION COMEDY' )
and (a.[TCastOriginator]='CBS' or a.[TCastOriginator]='NBC' or a.[TCastOriginator]='ABC' or a.[TCastOriginator]='CW' or a.[TCastOriginator]='FOX' or a.[TCastOriginator]='ION')
and (a.MarketBreak!='HOH ED = Some College' and a.MarketBreak!='Households with Cable Services via Telco = Yes' and TCastDaypart='PRIME TIME'); 
go



/*
ALTER TABLE dbo.panel_audience_profile Add CompP2554 Decimal(20,5) null;
ALTER TABLE dbo.panel_audience_profile Add CompP1849 Decimal(20,5) null;
ALTER TABLE dbo.panel_audience_profile Add SkewP2554 Decimal(20,5) null;
ALTER TABLE dbo.panel_audience_profile Add SkewF2554 Decimal(20,5) null;
ALTER TABLE dbo.panel_audience_profile Add SkewP1849 Decimal(20,5) null;
ALTER TABLE dbo.panel_audience_profile Add SkewF1849 Decimal(20,5) null;
go
*/

WITH CTE AS(
   SELECT *,
       RN = ROW_NUMBER()OVER(PARTITION BY [PlayDelayLabel],[TCastOriginator],[MarketBreak],[BroadcastDate],[TCastStartTime],[TCastName]
	   ORDER BY [HHProjection] desc)
   FROM dbo.panel_audience_profile
)
DELETE FROM CTE WHERE RN > 1;
go

with com as(
select BroadcastDate, TCastStartTime,TCastName, ([F2554]+[M2554]) as P2554, ([F1849]+[M1849]) as P1849
from dbo.panel_audience_profile
where MarketBreak='Composite'
)
update a
set a.CompP2554=com.P2554,
    a.CompP1849=com.P1849
from dbo.panel_audience_profile as a
left join com 
on a.BroadcastDate=com.BroadcastDate and a.TCastStartTime=com.TCastStartTime and a.TCastName=com.TCastName;
go

update a
set a.SkewP2554=(a.F2554+a.M2554)/a.CompP2554,
    a.SkewF2554=(a.F2554)/a.CompP2554,
	a.SkewP1849=(a.F1849+a.M1849)/a.CompP1849,
	a.SkewF1849=(a.F1849)/a.CompP1849
from dbo.panel_audience_profile as a;

