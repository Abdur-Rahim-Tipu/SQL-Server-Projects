
/* DDL.SQL
CREATE database
*/
CREATE database traveltours

GO
use traveltours
GO
CREATE Table travelagents
(
agent_id int primary key,
agent_name varchar(40)
)
GO
CREATE Table tourepackages
(
package_id int primary key,
package_catagory varchar(30),
package_name varchar(30),
cost_per_person money,
toure_time datetime
)
GO
CREATE Table package_features
(
feature_id int primary key,
transport_mode varchar(20),
hotel_booking varchar(20),
package_id int References tourepackages(package_id)
)
GO
CREATE Table tourists 
(
tourist_id int primary key,
tourist_name varchar(40),
tourist_status varchar(30),
tourist_ocupation varchar(30),
package_id int References tourepackages(package_id)
)
GO
CREATE Table agent_tourepackages
(
agent_id int References travelagents(agent_id),
package_id int References tourepackages(package_id)
primary key(package_id,agent_id)
)
GO
----Store PROCedure for INSERT

CREATE PROC spINSERT_travelagents @n nvarchar(100)
as
DECLARE @id int
SELECT @id = isnull(max(agent_id), 0)+1 FROM travelagents
BEGIN TRY
	INSERT INTO travelagents(agent_id, agent_name)
	VALUES (@id, @n)
	return @id
END TRY
BEGIN CATCH
		DECLARE @m nvarchar(500) , @EN int 
		SELECT @m=ERROR_MESSAGE (), @en = ERROR_NUMBER ()
	;
	throw @m, @en, 1
	return 0
END CATCH
GO
CREATE PROC spINSERT_tourepackages
									@pc nvarchar(30),
									@pn nvarchar (30),
									@cs money,
									@tt datetime
as
DECLARE @id int
SELECT @id = isnull(max(package_id), 0)+1 FROM tourepackages
BEGIN TRY
	INSERT INTO tourepackages(package_id, package_catagory,package_name,cost_per_person,toure_time)
	VALUES (@id,@pc,@pn,@cs,@tt)
	return @id
END TRY
BEGIN CATCH
		DECLARE @m nvarchar(500) , @EN int 
		SELECT @m=ERROR_MESSAGE (), @en = ERROR_NUMBER ()
	;
	throw @m, @en, 1
	return 0
END CATCH
GO
CREATE PROC spINSERT_package_features
									@t_m nvarchar(30),
									@h_b nvarchar (30),
									@p_id int
as
DECLARE @id int
SELECT @id = isnull(max(feature_id), 0)+1 FROM package_features
BEGIN TRY
	INSERT INTO package_features(feature_id,transport_mode,hotel_booking,package_id)
	VALUES (@id,@t_m,@h_b,@p_id)
	return @id
END TRY
BEGIN CATCH
		DECLARE @m nvarchar(500) , @EN int 
		SELECT @m=ERROR_MESSAGE (), @en = ERROR_NUMBER ()
	;
	throw @m, @en, 1
	return 0
END CATCH
GO
CREATE PROC spINSERT_tourists 
									@t_n nvarchar(30),
									@t_s nvarchar (30),
									@t_oc nvarchar(30),
									@p_id int
as
DECLARE @id int
SELECT @id = isnull(max(tourist_id), 0)+1 FROM tourists
BEGIN TRY
	INSERT INTO tourists(tourist_id,tourist_name,tourist_status,tourist_ocupation,package_id)
	VALUES (@id,@t_n,@t_s,@t_oc,@p_id)
	return @id
END TRY
BEGIN CATCH
		DECLARE @m nvarchar(500) , @EN int 
		SELECT @m=ERROR_MESSAGE (), @en = ERROR_NUMBER ()
	;
	throw @m, @en, 1
	return 0
END CATCH
GO
CREATE PROC spINSERT_agent_tourepackages 
									@p_id int
as
DECLARE @id int
SELECT @id = isnull(max(agent_id), 0)+1 FROM agent_tourepackages
BEGIN TRY
	INSERT INTO agent_tourepackages(agent_id,package_id)
	VALUES (@id,@p_id)
	return @id
END TRY
BEGIN CATCH
		DECLARE @m nvarchar(500) , @EN int 
		SELECT @m=ERROR_MESSAGE (), @en = ERROR_NUMBER ()
	;
	throw @m, @en, 1
	return 0
END CATCH
GO
----Store PROCedure for Update
----Update
CREATE PROC spUpdate_travelagents @id int,@n nvarchar(30)
as
BEGIN TRY
	update travelagents
	set agent_name = @n
	WHERE agent_id = @id
END TRY
BEGIN CATCH
		DECLARE @m nvarchar(500) , @EN int 
		SELECT @m=ERROR_MESSAGE (), @en = ERROR_NUMBER ()
	;
	throw @m, @en, 1
	return 0
END CATCH
GO
CREATE PROC spUpdate_tourepackages @id int,
@p_c nvarchar(30),
@p_n nvarchar(30),
@c_p money,
@t_t datetime
as
BEGIN TRY
	update tourepackages
	set 
	package_catagory =isnull( @p_c,package_catagory),
	package_name = isnull(@p_n,package_name),
	cost_per_person = isnull(@c_p,cost_per_person),
	toure_time = isnull(@t_t,toure_time)
	WHERE package_id = @id
END TRY
BEGIN CATCH
		DECLARE @m nvarchar(500) , @EN int 
		SELECT @m=ERROR_MESSAGE (), @en = ERROR_NUMBER ()
	;
	throw @m, @en, 1
	return 0
END CATCH
GO
CREATE PROC spUpdate_package_features @id int,
@t_m nvarchar(30),
@h_b nvarchar(30),
@p_id int
as
BEGIN TRY
	update package_features
	set 
	transport_mode =isnull( @t_m,transport_mode),
	hotel_booking = isnull(@h_b,hotel_booking),
	package_id = isnull(@p_id,package_id)
	WHERE feature_id = @id
END TRY
BEGIN CATCH
		DECLARE @m nvarchar(500) , @EN int 
		SELECT @m=ERROR_MESSAGE (), @en = ERROR_NUMBER ()
	;
	throw @m, @en, 1
	return 0
END CATCH
GO
CREATE PROC spUpdate_tourists @id int,
@t_n nvarchar(30),
@t_s nvarchar(30),
@t_oc nvarchar(30),
@p_id int
as
BEGIN TRY
	update tourists
	set 
	tourist_name =isnull( @t_n,tourist_name),
	tourist_status = isnull(@t_s,tourist_status),
	tourist_ocupation = isnull(@t_oc,tourist_ocupation),
	package_id = isnull(@p_id,package_id)
	WHERE tourist_id = @id
END TRY
BEGIN CATCH
		DECLARE @m nvarchar(500) , @EN int 
		SELECT @m=ERROR_MESSAGE (), @en = ERROR_NUMBER ()
	;
	throw @m, @en, 1
	return 0
END CATCH
GO
CREATE PROC spUpdate_agent_tourepackages @id int,
@p_id int
as
BEGIN TRY
	update agent_tourepackages
	set 

	package_id = isnull(@p_id,package_id)
	WHERE agent_id = @id
END TRY
BEGIN CATCH
		DECLARE @m nvarchar(500) , @EN int 
		SELECT @m=ERROR_MESSAGE (), @en = ERROR_NUMBER ()
	;
	throw @m, @en, 1
	return 0
END CATCH
GO
--Store PROCedure for DELETE

CREATE PROC spdelete_travelagents @id int
as
BEGIN TRY
	DELETE travelagents
	WHERE agent_id = @id
END TRY
BEGIN CATCH
		DECLARE @m nvarchar(500) , @EN int 
		SELECT @m=ERROR_MESSAGE (), @en = ERROR_NUMBER ()
	;
	throw @m, @en, 1
	return 0
END CATCH
GO
CREATE PROC spdelete_tourepackages @id int
as
BEGIN TRY
	DELETE tourepackages
	WHERE package_id = @id
END TRY
BEGIN CATCH
		DECLARE @m nvarchar(500) , @EN int 
		SELECT @m=ERROR_MESSAGE (), @en = ERROR_NUMBER ()
	;
	throw @m, @en, 1
	return 0
END CATCH
GO
CREATE PROC spdelete_package_features @id int
as
BEGIN TRY
	DELETE package_features	
	WHERE package_id = @id
END TRY
BEGIN CATCH
		DECLARE @m nvarchar(500) , @EN int 
		SELECT @m=ERROR_MESSAGE (), @en = ERROR_NUMBER ()
	;
	throw @m, @en, 1
	return 0
END CATCH
GO
CREATE PROC spdelete_tourists  @id int
as
BEGIN TRY
	DELETE tourists 	
	WHERE tourist_id = @id
END TRY
BEGIN CATCH
		DECLARE @m nvarchar(500) , @EN int 
		SELECT @m=ERROR_MESSAGE (), @en = ERROR_NUMBER ()
	;
	throw @m, @en, 1
	return 0
END CATCH
GO
CREATE PROC spdelete_agent_tourepackages  @id int
as
BEGIN TRY
	DELETE agent_tourepackages 	
	WHERE agent_id = @id
END TRY
BEGIN CATCH
		DECLARE @m nvarchar(500) , @EN int 
		SELECT @m=ERROR_MESSAGE (), @en = ERROR_NUMBER ()
	;
	throw @m, @en, 1
	return 0
END CATCH
GO

----VIEW
CREATE VIEW v_tour_Info
as
SELECT tourist_name, package_catagory ,agent_id, tourist_ocupation
FROM tourists t
inner join tourepackages tp
on t.package_id=tp.package_id
inner join agent_tourepackages atp
on tp.package_id= atp.package_id
GO
--User Define Function
CREATE function fnTable(@agent_id int) returns Table
as
return
(
SELECT tourist_name, package_catagory ,agent_id, tourist_ocupation
FROM tourists t
inner join tourepackages tp
on t.package_id=tp.package_id
inner join agent_tourepackages atp
on tp.package_id= atp.package_id
WHERE agent_id=@agent_id
)
GO
----TRIGGER
CREATE TRIGGER tragent_packages
on agent_tourepackages for INSERT 
as
BEGIN
DECLARE @agentid int
SELECT @agentid=agent_id FROM INSERTed
	if exists
		(
			SELECT count(*) FROM agent_tourepackages
			WHERE agent_id = @agentid
			group by agent_id
			having count(*) >  5
		)
		BEGIN
			rollback transaction 
			Raiserror('Agency has already had five packages',16,1)
		END
END
GO
