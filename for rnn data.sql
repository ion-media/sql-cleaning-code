/****** Script for SelectTopNRows command from SSMS  ******/
SELECT [id]
      ,[BroadcastDate]
      ,[STDate]
      ,[TCastStartTime]
	  ,DATEPART(YEAR,[BroadcastDate]) as YearInt
	  ,DATEPART(MONTH,[BroadcastDate]) as MonthInt
	  ,DATEPART(WEEK,[BroadcastDate]) as WeekInt
	  ,(DATEPART(dw,[BroadcastDate]) + 5) % 7 + 1 as WeekDayInt
	  ,DATEPART(HOUR,[TCastStartTime]) as HourInt
      ,[TCastName]
      ,[show]
      ,[TCastOriginator]
      ,[TCastOriginatorType]
      ,[TCastStandardType]
      ,[TCastExpandedType]
      ,[TCastLessThan5Flag]
      ,[TCastPremeireFlag]
      ,[TCastDuration]
      ,[HH]
      ,[P1849]
      ,[P2554]
  FROM [ion].[dbo].[aquisition_lsd_model]
  where (TCastOriginatorID=77   --abc
  or TCastOriginatorID=32    --amc
  or TCastOriginatorID=78    --cbs
  or TCastOriginatorID=22261  --cw 
  or TCastOriginatorID=81      --fox
  or TCastOriginatorID=10870  --ion
  or TCastOriginatorID=79     --nbc
  or TCastOriginatorID=5      --usa
  or TCastOriginatorID=10557  --we
  or TCastOriginatorID=10)    --wgn