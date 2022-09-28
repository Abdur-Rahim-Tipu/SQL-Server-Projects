--DML
use traveltours
GO
---inset data

INSERT INTO travelagents VALUES
						(1, 'Hanif Travels'),
						(2, 'Greenline Travels'),
						(3, 'Sakura Tours')
SELECT * FROM travelagents
GO

 INSERT INTO tourepackages VALUES
							(1, 'Single packagae', 'Nilachol Tour', 3000.0000, CAST(N'2022-03-01' AS Date)),
							(2, 'Group Package', 'Nilachol Tour', 2100.0000, CAST(N'2022-03-01' AS Date)),
							(3, 'Family', 'Cox''s bazar tour', 4000.0000, CAST(N'2022-03-01' AS DateTime)),
							(4, 'Single packagae', 'Cox''s bazar tour', 3000.0000, CAST(N'2022-03-01' AS Date)),
							(5, 'Single packagae', 'Kuakata tour', 2500.0000, CAST(N'2022-03-01' AS Date)),
							(6, 'Group Package', 'Kuakata tour', 2000.0000, CAST(N'2022-03-01' AS Date))
GO
SELECT * FROM tourepackages


INSERT INTO agent_tourepackages VALUES (1,1)
GO

INSERT INTO package_features VALUES 
							(1, 'Air', 'Janata hotel', 1),
							(2, 'Road', 'Asian hotel', 2),
							(3, 'Bus', 'Redian hotel', 3),
							(4, 'Road', 'Rajmohol', 4)


GO
SELECT * FROM package_features
GO
INSERT INTO tourists VALUES
					(1,'Raihan','single','Bisness man',1),
					(2,'Jamim','married','G Employee',3),
					(3,'Saima jahan','married','service',2),
					(4,'Mukit Ali','single','Student',4)
GO
SELECT *
 FROM tourists
 GO
 USE [traveltours]
GO
INSERT INTO agent_tourepackages VALUES (1, 4),(1, 2),(2, 3),(3, 4),(2, 4)
SELECT * FROM [agent_tourepackages]
GO

--query
SELECT tourepackages.package_cataGOry, tourepackages.package_name, tourepackages.cost_per_person, package_features.transport_mode, package_features.hotel_booking, travelagents.agent_name, tourists.tourist_name
FROM tourists
INNER JOIN tourepackages  ON tourists.package_id = tourepackages.package_id 
INNER JOIN  package_features ON package_features.package_id = tourepackages.package_id
INNER JOIN  agent_tourepackages ON tourepackages.package_id = agent_tourepackages.package_id 
INNER JOIN travelagents ON agent_tourepackages.agent_id = travelagents.agent_id
 --view
 SELECT * FROM v_tour_Info
 --pocedure
exec spINSERT_travelagents @n='Abdull hil kafi'
GO
EXEC spINSERT_tourepackages	'Family', 'Arifull Islam' ,10000.00, '2022-05-01'
GO
EXEC spINSERT_package_features		'Road','Lasia nur 3 star',5
GO
EXEC spINSERT_tourists 'Jashim Ahmed','Single','Student',5
GO
EXEC spUpdate_package_features 5 , 'Air', 'Holet Himalaia ', 5
GO
exec spDelete_package_features 5
GO
SELECT * FROM fnTable(1)
GO

/*
				 Queries, Sub Queries, Join Queries, CTE
 */
 --1 LEFT
SELECT  ta.agent_name, tp.package_name, tp.cost_per_person, t.tourist_name, t.tourist_status, t.tourist_ocupation
FROM travelagents ta
INNER JOIN agent_tourepackages atp ON ta.agent_id = atp.agent_id 
INNER JOIN tourepackages tp ON atp.package_id = tp.package_id 
INNER JOIN tourists t ON atp.package_id = t.package_id
GO
--2 LEFT FILTER
SELECT  ta.agent_name, tp.package_name, tp.cost_per_person, t.tourist_name, t.tourist_status, t.tourist_ocupation
FROM travelagents ta
INNER JOIN agent_tourepackages atp ON ta.agent_id = atp.agent_id 
INNER JOIN tourepackages tp ON atp.package_id = tp.package_id 
INNER JOIN tourists t ON atp.package_id = t.package_id
WHERE ta.agent_name = 'Greenline Travels'
GO
--3 LEFT FILTER
SELECT  ta.agent_name, tp.package_name, tp.cost_per_person, t.tourist_name, t.tourist_status, t.tourist_ocupation
FROM travelagents ta
INNER JOIN agent_tourepackages atp ON ta.agent_id = atp.agent_id 
INNER JOIN tourepackages tp ON atp.package_id = tp.package_id 
INNER JOIN tourists t ON atp.package_id = t.package_id
WHERE tp.cost_per_person > 2000
GO
--4 RIGHT OUTER
SELECT  tp.package_name, tp.cost_per_person, ta.agent_name, t.tourist_name, t.tourist_status, t.tourist_ocupation
FROM  travelagents AS ta 
INNER JOIN agent_tourepackages AS atp ON ta.agent_id = atp.agent_id 
INNER JOIN tourists AS t ON atp.package_id = t.package_id 
RIGHT OUTER JOIN tourepackages AS tp ON atp.package_id = tp.package_id
GO
--5 RIGHT OUTER NON MATCHING
SELECT tp.package_name, tp.cost_per_person, ta.agent_name, t.tourist_name, t.tourist_status, t.tourist_ocupation
FROM   travelagents AS ta 
INNER JOIN agent_tourepackages AS atp ON ta.agent_id = atp.agent_id 
INNER JOIN tourists AS t ON atp.package_id = t.package_id 
RIGHT OUTER JOIN  tourepackages AS tp ON atp.package_id = tp.package_id
WHERE ta.agent_id IS NULL
GO
--6 RIGHT OUTER NON MATCHING SUB-QUERY
SELECT tp.package_name, tp.cost_per_person, ta.agent_name, t.tourist_name, t.tourist_status, t.tourist_ocupation
FROM   travelagents AS ta 
INNER JOIN agent_tourepackages AS atp ON ta.agent_id = atp.agent_id 
INNER JOIN tourists AS t ON atp.package_id = t.package_id 
RIGHT OUTER JOIN  tourepackages AS tp ON atp.package_id = tp.package_id
WHERE NOT (ta.agent_id IS NOT NULL AND ta.agent_id IN (SELECT agent_id FROM travelagents))
GO
--7 CONVERT 4 to CTE
WITH cte AS
(
	SELECT  atp.package_id,  ta.agent_name, t.tourist_name, t.tourist_status, t.tourist_ocupation
	FROM    travelagents AS ta 
	INNER JOIN agent_tourepackages AS atp ON ta.agent_id = atp.agent_id 
	INNER JOIN tourists AS t ON atp.package_id = t.package_id 
)
SELECT   c.agent_name, c.tourist_name, c.tourist_status, c.tourist_ocupation
FROM cte c 
GO
--8 CASE
SELECT   ta.agent_name,  
CASE 
WHEN COUNT(tp.package_id) = 0 THEN 'No package'
ELSE CAST(COUNT(tp.package_id) AS VARCHAR) 
END 'count'
FROM    tourepackages tp
INNER JOIN agent_tourepackages atp ON tp.package_id = atp.package_id 
RIGHT OUTER JOIN travelagents ta ON atp.agent_id = ta.agent_id
GROUP BY ta.agent_id, ta.agent_name
GO
--9 AggreGATE
SELECT  ta.agent_name, tp.package_name, COUNT(t.tourist_id) 'count'
FROM travelagents ta
INNER JOIN agent_tourepackages atp ON ta.agent_id = atp.agent_id 
INNER JOIN tourepackages tp ON atp.package_id = tp.package_id 
INNER JOIN tourists t ON atp.package_id = t.package_id
GROUP BY ta.agent_name, tp.package_name
GO
--10 AggreGATE+having
SELECT  ta.agent_name, tp.package_name, COUNT(t.tourist_id) 'count'
FROM travelagents ta
INNER JOIN agent_tourepackages atp ON ta.agent_id = atp.agent_id 
INNER JOIN tourepackages tp ON atp.package_id = tp.package_id 
INNER JOIN tourists t ON atp.package_id = t.package_id
GROUP BY ta.agent_name, tp.package_name
HAVING ta.agent_name='Space Travels'
GO
--11 WINDOWING
SELECT  ta.agent_name, tp.package_name, 
COUNT(t.tourist_id) OVER(ORDER BY ta.agent_name, tp.package_name) 'count',
ROW_NUMBER() OVER(ORDER BY ta.agent_name, tp.package_name) 'row',
RANK() OVER(ORDER BY ta.agent_name, tp.package_name) 'rank',
DENSE_RANK() OVER(ORDER BY ta.agent_name, tp.package_name) 'dense',
NTILE(2) OVER(ORDER BY ta.agent_name, tp.package_name) 'ntile'

FROM travelagents ta
INNER JOIN agent_tourepackages atp ON ta.agent_id = atp.agent_id 
INNER JOIN tourepackages tp ON atp.package_id = tp.package_id 
INNER JOIN tourists t ON atp.package_id = t.package_id
GO