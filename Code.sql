{\rtf1\ansi\ansicpg1252\cocoartf1671\cocoasubrtf200
{\fonttbl\f0\fswiss\fcharset0 Helvetica;}
{\colortbl;\red255\green255\blue255;}
{\*\expandedcolortbl;;}
\margl1440\margr1440\vieww12180\viewh16000\viewkind0
\pard\tx720\tx1440\tx2160\tx2880\tx3600\tx4320\tx5040\tx5760\tx6480\tx7200\tx7920\tx8640\pardirnatural\partightenfactor0

\f0\fs24 \cf0 --1.How many campaigns and sources does CoolTShirts use, and which source is used for each campaign?\
\
--Count of distint campaigns\
SELECT COUNT(DISTINCT utm_campaign) AS 'Distinct Campaigns'\
FROM page_visits;\
\
--Count of distinct sources\
SELECT COUNT(DISTINCT utm_source) AS 'Distinct Sources'\
FROM page_visits;\
\
--Source used for each campaign\
SELECT DISTINCT utm_campaign AS 'Campaign',\
		utm_source AS 'Source'\
FROM page_visits;\
\
--2.What pages are on the CTS website?\
\
--Query for distinct website pages\
SELECT DISTINCT page_name AS 'CTS Website Pages'\
FROM page_visits;\
\
---3.How many first touches attributed to each campaign?\
--a.Temp table of first touches by user_id\
WITH first_touch AS (\
    SELECT user_id,\
       		 MIN(timestamp) AS first_touch_at\
    FROM page_visits\
    GROUP BY user_id),\
--b.Temp table joining first_touch with page_visits\
ft_attr AS (\
		SELECT ft.user_id,\
   				 ft.first_touch_at,\
  				 pv.utm_source,\
   		 		 pv.utm_campaign    \
		FROM first_touch ft\
		JOIN page_visits pv\
    	ON ft.user_id = pv.user_id\
    	AND ft.first_touch_at = pv.timestamp\
)\
--c.Count of first touches by campaign\
SELECT ft_attr.utm_source AS 'Source',\
			 ft_attr.utm_campaign AS 'Campaign',\
    	 COUNT(*) AS 'Count'\
FROM ft_attr\
GROUP BY 1, 2\
ORDER BY 3 DESC;\
\
---4.How many last touches attributed to each campaign?\
--a.Temp table of last touches by user_id\
WITH last_touch AS (\
    SELECT user_id,\
       		 MAX(timestamp) AS last_touch_at\
    FROM page_visits\
    GROUP BY user_id),\
--b.Temp table joining last_touch with page_visits\
lt_attr AS (\
		SELECT lt.user_id,\
   				 lt.last_touch_at,\
  				 pv.utm_source,\
   		 		 pv.utm_campaign    \
		FROM last_touch lt\
		JOIN page_visits pv\
    	ON lt.user_id = pv.user_id\
    	AND lt.last_touch_at = pv.timestamp\
)\
--c.Count of last touches by campaign\
SELECT lt_attr.utm_source AS 'Source',\
			 lt_attr.utm_campaign AS 'Campaign',\
    	 COUNT(*) AS 'Count'\
FROM lt_attr\
GROUP BY 1, 2\
ORDER BY 3 DESC;\
\
--5.How many visitors make a purchase?\
\
--Count of distinct users who visited the purchase page\
SELECT COUNT(DISTINCT user_id) AS "Purchasing Customers"\
FROM page_visits\
WHERE page_name = '4 - purchase';\
\
---6.How many purchase page last touches is each campaign responsible for?\
--a.Temp table of last touches by user_id\
WITH last_touch AS (\
    SELECT user_id,\
       		 MAX(timestamp) AS last_touch_at\
    FROM page_visits\
  	WHERE page_name = '4 - purchase'\
    GROUP BY user_id),\
--b.Temp table joining last_touch with page_visits\
lt_attr AS (\
		SELECT lt.user_id,\
   				 lt.last_touch_at,\
  				 pv.utm_source,\
   		 		 pv.utm_campaign    \
		FROM last_touch lt\
		JOIN page_visits pv\
    	ON lt.user_id = pv.user_id\
    	AND lt.last_touch_at = pv.timestamp\
)\
--c.Count of last touches by campaign\
SELECT lt_attr.utm_source AS 'Source',\
			 lt_attr.utm_campaign AS 'Campaign',\
    	 COUNT(*) AS 'Count'\
FROM lt_attr\
GROUP BY 1, 2\
ORDER BY 3 DESC;\
\
\'97EXTRAS\
\
--Count distinct users that went to each of the 4 site pages in the data set\
SELECT COUNT(DISTINCT user_id) AS '# of Users', page_name\
FROM page_visits\
GROUP BY page_name\
ORDER by 2 ASC;}