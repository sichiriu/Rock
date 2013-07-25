------------------------------------------------------------------------
-- This script will add data for the attended check-in system 
------------------------------------------------------------------------

------------------------------------------------------------------------
-- Workflow Data
------------------------------------------------------------------------
DECLARE @WorkflowTypeEntityTypeId int
SET @WorkflowTypeEntityTypeId = (SELECT Id FROM EntityType WHERE Name = 'Rock.Model.WorkflowType')

-- Category Type
DECLARE @CategoryId int
IF NOT EXISTS(SELECT [Id] FROM Category WHERE [Name] = 'Checkin')
INSERT INTO Category ([IsSystem], [EntityTypeId], [Name], [Guid])
VALUES (1, @WorkflowTypeEntityTypeId, 'Checkin', '4A769688-2DAA-47DC-BBC7-0A640A5B05FC')
SET @CategoryId = SCOPE_IDENTITY()

-- Data Type
DECLARE @TextFieldTypeId int
SET @TextFieldTypeId = (SELECT Id FROM FieldType WHERE guid = '9C204CD0-1233-41C5-818A-C5DA439445AA')
DECLARE @BooleanFieldTypeId int
SET @BooleanFieldTypeId = (SELECT Id FROM FieldType WHERE guid = '1EDAFDED-DFE6-4334-B019-6EECBA89E05A')
DECLARE @DecimalFieldTypeId int
SET @DecimalFieldTypeId = (SELECT Id FROM FieldType WHERE guid = 'c757a554-3009-4214-b05d-cea2b2ea6b8f')
DECLARE @IntFieldTypeId int 
SET @IntFieldTypeId = (SELECT Id FROM FieldType WHERE guid = 'A75DFC58-7A1B-4799-BF31-451B2BBE38FF')

-- Workflow Type
DECLARE @WorkflowTypeId int
SET @WorkflowTypeId = (SELECT Id FROM [WorkflowType] WHERE Guid = '6E8CD562-A1DA-4E13-A45C-853DB56E0014')
IF @WorkflowTypeId IS NOT NULL
BEGIN
	DELETE [Workflow] WHERE Id = @WorkflowTypeId
	DELETE [WorkflowType] WHERE Id = @WorkflowTypeId
END

INSERT INTO WorkFlowType ([IsSystem], [IsActive], [Name], [Description], [CategoryId], [Order], [WorkTerm], [IsPersisted], [LoggingLevel], [Guid])
VALUES (0, 1, 'Attended Checkin', 'Workflow for managing attended checkin', @CategoryId, 0, 'Checkin', 0, 3, '6E8CD562-A1DA-4E13-A45C-853DB56E0014')
SET @WorkflowTypeId = SCOPE_IDENTITY()

-- Workflow Entity Type
IF NOT EXISTS(SELECT Id FROM EntityType WHERE Name = 'Rock.Model.Workflow')
INSERT INTO EntityType (Name, Guid, IsEntity, IsSecured)
VALUES ('Rock.Model.Workflow', NEWID(), 0, 0)
DECLARE @WorkflowEntityTypeId int
SET @WorkflowEntityTypeId = (SELECT Id FROM EntityType WHERE Name = 'Rock.Model.Workflow')

DECLARE @WorkflowActivity1 int
DECLARE @WorkflowActivity2 int
DECLARE @WorkflowActivity3 int
DECLARE @WorkflowActivity4 int
INSERT WorkflowActivityType ([IsActive], [WorkflowTypeId], [Name], [Description], [IsActivatedWithWorkflow], [Order], [Guid])
VALUES ( 1, @WorkflowTypeId,	'Family Search',	 '', 0, 0, 'B6FC7350-10E0-4255-873D-4B492B7D27FF') 
	, ( 1, @WorkflowTypeId, 'Person Search', '', 0, 1,	 '6D8CC755-0140-439A-B5A3-97D2F7681697')
	, ( 1, @WorkflowTypeId, 'Activity Search', '', 0, 2,	 '77CCAF74-AC78-45DE-8BF9-4C544B54C9DD')
	, ( 	1, @WorkflowTypeId, 'Save Attendance', '', 0, 4,	 'BF4E1CAA-25A3-4676-BCA2-FDE2C07E8210')

SELECT @WorkflowActivity1 = Id FROM WorkflowActivityType 
	WHERE Guid = 'B6FC7350-10E0-4255-873D-4B492B7D27FF'
SELECT @WorkflowActivity2 = Id FROM WorkflowActivityType 
	WHERE Guid = '6D8CC755-0140-439A-B5A3-97D2F7681697'
SELECT @WorkflowActivity3 = Id FROM WorkflowActivityType 
	WHERE Guid = '77CCAF74-AC78-45DE-8BF9-4C544B54C9DD'
SELECT @WorkflowActivity4 = Id FROM WorkflowActivityType 
	WHERE Guid = 'BF4E1CAA-25A3-4676-BCA2-FDE2C07E8210'

-- Workflow Action Entity Types
IF NOT EXISTS(SELECT Id FROM EntityType WHERE Name = 'Rock.Workflow.Action.CheckIn.FilterActiveLocations')
INSERT INTO EntityType (Name, Guid, IsEntity, IsSecured)
VALUES ('Rock.Workflow.Action.CheckIn.FilterActiveLocations', NEWID(), 0, 0)

IF NOT EXISTS(SELECT Id FROM EntityType WHERE Name = 'Rock.Workflow.Action.CheckIn.FilterByAge')
INSERT INTO EntityType (Name, Guid, IsEntity, IsSecured)
VALUES ('Rock.Workflow.Action.CheckIn.FilterByAge', NEWID(), 0, 0)

IF NOT EXISTS(SELECT Id FROM EntityType WHERE Name = 'Rock.Workflow.Action.CheckIn.FindFamilies')
INSERT INTO EntityType (Name, Guid, IsEntity, IsSecured)
VALUES ('Rock.Workflow.Action.CheckIn.FindFamilies', NEWID(), 0, 0)

IF NOT EXISTS(SELECT Id FROM EntityType WHERE Name = 'Rock.Workflow.Action.CheckIn.FindFamilyMembers')
INSERT INTO EntityType (Name, Guid, IsEntity, IsSecured)
VALUES ('Rock.Workflow.Action.CheckIn.FindFamilyMembers', NEWID(), 0, 0)

IF NOT EXISTS(SELECT Id FROM EntityType WHERE Name = 'Rock.Workflow.Action.CheckIn.FindRelationships')
INSERT INTO EntityType (Name, Guid, IsEntity, IsSecured)
VALUES ('Rock.Workflow.Action.CheckIn.FindRelationships', NEWID(), 0, 0)

IF NOT EXISTS(SELECT Id FROM EntityType WHERE Name = 'Rock.Workflow.Action.CheckIn.LoadGroups')
INSERT INTO EntityType (Name, Guid, IsEntity, IsSecured)
VALUES ('Rock.Workflow.Action.CheckIn.LoadGroups', NEWID(), 0, 0)

IF NOT EXISTS(SELECT Id FROM EntityType WHERE Name = 'Rock.Workflow.Action.CheckIn.LoadGroupTypes')
INSERT INTO EntityType (Name, Guid, IsEntity, IsSecured)
VALUES ('Rock.Workflow.Action.CheckIn.LoadGroupTypes', NEWID(), 0, 0)

IF NOT EXISTS(SELECT Id FROM EntityType WHERE Name = 'Rock.Workflow.Action.CheckIn.LoadLocations')
INSERT INTO EntityType (Name, Guid, IsEntity, IsSecured)
VALUES ('Rock.Workflow.Action.CheckIn.LoadLocations', NEWID(), 0, 0)

IF NOT EXISTS(SELECT Id FROM EntityType WHERE Name = 'Rock.Workflow.Action.CheckIn.LoadSchedules')
INSERT INTO EntityType (Name, Guid, IsEntity, IsSecured)
VALUES ('Rock.Workflow.Action.CheckIn.LoadSchedules', NEWID(), 0, 0)

IF NOT EXISTS(SELECT Id FROM EntityType WHERE Name = 'Rock.Workflow.Action.CheckIn.RemoveEmptyGroups')
INSERT INTO EntityType (Name, Guid, IsEntity, IsSecured)
VALUES ('Rock.Workflow.Action.CheckIn.RemoveEmptyGroups', NEWID(), 0, 0)

IF NOT EXISTS(SELECT Id FROM EntityType WHERE Name = 'Rock.Workflow.Action.CheckIn.RemoveEmptyGroupTypes')
INSERT INTO EntityType (Name, Guid, IsEntity, IsSecured)
VALUES ('Rock.Workflow.Action.CheckIn.RemoveEmptyGroupTypes', NEWID(), 0, 0)

IF NOT EXISTS(SELECT Id FROM EntityType WHERE Name = 'Rock.Workflow.Action.CheckIn.RemoveEmptyLocations')
INSERT INTO EntityType (Name, Guid, IsEntity, IsSecured)
VALUES ('Rock.Workflow.Action.CheckIn.RemoveEmptyLocations', NEWID(), 0, 0)

IF NOT EXISTS(SELECT Id FROM EntityType WHERE Name = 'Rock.Workflow.Action.CheckIn.RemoveEmptyPeople')
INSERT INTO EntityType (Name, Guid, IsEntity, IsSecured)
VALUES ('Rock.Workflow.Action.CheckIn.RemoveEmptyPeople', NEWID(), 0, 0)

IF NOT EXISTS(SELECT Id FROM EntityType WHERE Name = 'Rock.Workflow.Action.CheckIn.SaveAttendance')
INSERT INTO EntityType (Name, Guid, IsEntity, IsSecured)
VALUES ('Rock.Workflow.Action.CheckIn.SaveAttendance', NEWID(), 0, 0)

IF NOT EXISTS(SELECT Id FROM EntityType WHERE Name = 'Rock.Workflow.Action.CheckIn.CreateLabels')
INSERT INTO EntityType (Name, Guid, IsEntity, IsSecured)
VALUES ('Rock.Workflow.Action.CheckIn.CreateLabels', NEWID(), 0, 0)

IF NOT EXISTS(SELECT Id FROM EntityType WHERE Name = 'Rock.Workflow.Action.CheckIn.CalculateLastAttended')
INSERT INTO EntityType (Name, Guid, IsEntity, IsSecured)
VALUES ('Rock.Workflow.Action.CheckIn.CalculateLastAttended', NEWID(), 0, 0)

IF NOT EXISTS(SELECT Id FROM EntityType WHERE Name = 'Rock.Workflow.Action.CheckIn.FilterLocationGroupsByAbilityLevel')
INSERT INTO EntityType (Name, Guid, IsEntity, IsSecured)
VALUES ('Rock.Workflow.Action.CheckIn.FilterLocationGroupsByAbilityLevel', NEWID(), 0, 0)

IF NOT EXISTS(SELECT Id FROM EntityType WHERE Name = 'Rock.Workflow.Action.CheckIn.FilterByLastAttended')
INSERT INTO EntityType (Name, Guid, IsEntity, IsSecured)
VALUES ('Rock.Workflow.Action.CheckIn.FilterByLastAttended', NEWID(), 0, 0)

-- Family Search
INSERT INTO [WorkflowActionType] (ActivityTypeId, Name, [Order], [EntityTypeId], IsActionCompletedOnSuccess, IsActivityCompletedOnSuccess, Guid)
SELECT @WorkflowActivity1, 'Find Families', 0, Id, 1, 0, NEWID() FROM EntityType WHERE Name = 'Rock.Workflow.Action.CheckIn.FindFamilies'

-- Person Search
INSERT INTO [WorkflowActionType] (ActivityTypeId, Name, [Order], [EntityTypeId], IsActionCompletedOnSuccess, IsActivityCompletedOnSuccess, Guid)
SELECT @WorkflowActivity2, 'Find Family Members', 0, Id, 1, 0, NEWID() FROM EntityType WHERE Name = 'Rock.Workflow.Action.CheckIn.FindFamilyMembers'
INSERT INTO [WorkflowActionType] (ActivityTypeId, Name, [Order], [EntityTypeId], IsActionCompletedOnSuccess, IsActivityCompletedOnSuccess, Guid)
SELECT @WorkflowActivity2, 'Find Relationships', 1, Id, 1, 0, NEWID() FROM EntityType WHERE Name = 'Rock.Workflow.Action.CheckIn.FindRelationships'
INSERT INTO [WorkflowActionType] (ActivityTypeId, Name, [Order], [EntityTypeId], IsActionCompletedOnSuccess, IsActivityCompletedOnSuccess, Guid)
SELECT @WorkflowActivity2, 'Load Group Types', 2, Id, 1, 0, NEWID() FROM EntityType WHERE Name = 'Rock.Workflow.Action.CheckIn.LoadGroupTypes'
INSERT INTO [WorkflowActionType] (ActivityTypeId, Name, [Order], [EntityTypeId], IsActionCompletedOnSuccess, IsActivityCompletedOnSuccess, Guid)
SELECT @WorkflowActivity2, 'Filter by Age', 3, Id, 1, 0, NEWID() FROM EntityType WHERE Name = 'Rock.Workflow.Action.CheckIn.FilterByAge'
INSERT INTO [WorkflowActionType] (ActivityTypeId, Name, [Order], [EntityTypeId], IsActionCompletedOnSuccess, IsActivityCompletedOnSuccess, Guid)
SELECT @WorkflowActivity2, 'Remove Empty People', 4, Id, 1, 0, NEWID() FROM EntityType WHERE Name = 'Rock.Workflow.Action.CheckIn.RemoveEmptyPeople'

-- Activity
INSERT INTO [WorkflowActionType] (ActivityTypeId, Name, [Order], [EntityTypeId], IsActionCompletedOnSuccess, IsActivityCompletedOnSuccess, Guid)
SELECT @WorkflowActivity3, 'Load Groups', 0, Id, 1, 0, NEWID() FROM EntityType WHERE Name = 'Rock.Workflow.Action.CheckIn.LoadGroups'
INSERT INTO [WorkflowActionType] (ActivityTypeId, Name, [Order], [EntityTypeId], IsActionCompletedOnSuccess, IsActivityCompletedOnSuccess, Guid)
SELECT @WorkflowActivity3, 'Load Schedules', 0, Id, 1, 0, NEWID() FROM EntityType WHERE Name = 'Rock.Workflow.Action.CheckIn.LoadSchedules'
INSERT INTO [WorkflowActionType] (ActivityTypeId, Name, [Order], [EntityTypeId], IsActionCompletedOnSuccess, IsActivityCompletedOnSuccess, Guid)
SELECT @WorkflowActivity3, 'Load Locations', 0, Id, 1, 0, NEWID() FROM EntityType WHERE Name = 'Rock.Workflow.Action.CheckIn.LoadLocations'
INSERT INTO [WorkflowActionType] (ActivityTypeId, Name, [Order], [EntityTypeId], IsActionCompletedOnSuccess, IsActivityCompletedOnSuccess, Guid)
SELECT @WorkflowActivity3, 'Filter Active Locations', 1, Id, 1, 0, NEWID() FROM EntityType WHERE Name = 'Rock.Workflow.Action.CheckIn.FilterActiveLocations'
INSERT INTO [WorkflowActionType] (ActivityTypeId, Name, [Order], [EntityTypeId], IsActionCompletedOnSuccess, IsActivityCompletedOnSuccess, Guid)
SELECT @WorkflowActivity3, 'Filter By Ability', 0, Id, 1, 0, NEWID() FROM EntityType WHERE Name = 'Rock.Workflow.Action.CheckIn.FilterLocationGroupsByAbilityLevel'
INSERT INTO [WorkflowActionType] (ActivityTypeId, Name, [Order], [EntityTypeId], IsActionCompletedOnSuccess, IsActivityCompletedOnSuccess, Guid)
SELECT @WorkflowActivity3, 'Calculate Last Attended', 0, Id, 1, 0, NEWID() FROM EntityType WHERE Name = 'Rock.Workflow.Action.CheckIn.CalculateLastAttended'
INSERT INTO [WorkflowActionType] (ActivityTypeId, Name, [Order], [EntityTypeId], IsActionCompletedOnSuccess, IsActivityCompletedOnSuccess, Guid)
SELECT @WorkflowActivity3, 'Filter By Last Attended', 1, Id, 1, 0, NEWID() FROM EntityType WHERE Name = 'Rock.Workflow.Action.CheckIn.FilterByLastAttended'

-- Confirm 
INSERT INTO [WorkflowActionType] (ActivityTypeId, Name, [Order], [EntityTypeId], IsActionCompletedOnSuccess, IsActivityCompletedOnSuccess, Guid)
SELECT @WorkflowActivity4, 'Save Attendance', 0, Id, 1, 0, NEWID() FROM EntityType WHERE Name = 'Rock.Workflow.Action.CheckIn.SaveAttendance'
INSERT INTO [WorkflowActionType] (ActivityTypeId, Name, [Order], [EntityTypeId], IsActionCompletedOnSuccess, IsActivityCompletedOnSuccess, Guid)
SELECT @WorkflowActivity4, 'Create Labels', 0, Id, 1, 0, NEWID() FROM EntityType WHERE Name = 'Rock.Workflow.Action.CheckIn.CreateLabels'

-- Attended Checkin parameter
DELETE [Attribute] WHERE [Guid] = '9D2BFE8A-41F3-4A02-B3CF-9193F0C8419E'
INSERT INTO [Attribute] ( IsSystem, FieldTypeId, EntityTypeId, EntityTypeQualifierColumn, EntityTypeQualifierValue, [Key], Name, [Order], IsGridColumn, IsMultiValue, IsRequired, Guid)
VALUES ( 0, @TextFieldTypeId, @WorkflowEntityTypeId, 'WorkflowTypeId', CAST(@WorkflowTypeId as varchar), 'CheckInState', 'Check In State', 0, 0, 0, 0, '9D2BFE8A-41F3-4A02-B3CF-9193F0C8419E')

-- Look up BlockAttributes and Blocks for Attended Checkin
DECLARE @AttributeAdmin int
SELECT @AttributeAdmin = [ID] from [Attribute] where [Guid] = '18864DE7-F075-437D-BA72-A6054C209FA5'
DECLARE @AttributeSearch int
SELECT @AttributeSearch = [ID] from [Attribute] where [Guid] = 'C4E992EA-62AE-4211-BE5A-9EEF5131235C'
DECLARE @AttributeFamily int
SELECT @AttributeFamily = [ID] from [Attribute] where [Guid] = '338CAD91-3272-465B-B768-0AC2F07A0B40'
DECLARE @AttributeActivity int
SELECT @AttributeActivity = [ID] from [Attribute] where [Guid] = 'BEC10B87-4B19-4CD5-8952-A4D59DDA3E9C'
DECLARE @AttributeConfirmation int
SELECT @AttributeConfirmation = [ID] from [Attribute] where [Guid] = '2A71729F-E7CA-4ACD-9996-A6A661A069FD'
DECLARE @AttributeGradeTransition int
SELECT @AttributeGradeTransition = [ID] from [Attribute] where [Guid] = '265734A6-C888-45B4-A7A5-9A26478306B8'

DECLARE @EntityIdAdmin int
SELECT @EntityIdAdmin = [ID] from [Block] where [Guid] = '9F8731AB-07DB-406F-A344-45E31D0DE301'
DECLARE @EntityIdSearch int
SELECT @EntityIdSearch = [ID] from [Block] where [Guid] = '182C9AA0-E76F-4AAF-9F61-5418EE5A0CDB'
DECLARE @EntityIdFamily int
SELECT @EntityIdFamily = [ID] from [Block] where [Guid] = '82929409-8551-413C-972A-98EDBC23F420'
DECLARE @EntityIdActivity int
SELECT @EntityIdActivity = [ID] from [Block] where [Guid] = '8C8CBBE9-2502-4FEC-804D-C0DA13C07FA4'
DECLARE @EntityIdConfirmation int
SELECT @EntityIdConfirmation = [ID] from [Block] where [Guid] = '7CC68DD4-A6EF-4B67-9FEA-A144C479E058'

-- Update current checkin blocks with new Workflow id
DELETE AttributeValue WHERE AttributeId = @AttributeAdmin
DELETE AttributeValue WHERE AttributeId = @AttributeSearch
DELETE AttributeValue WHERE AttributeId = @AttributeFamily
DELETE AttributeValue WHERE AttributeId = @AttributeActivity
DELETE AttributeValue WHERE AttributeId = @AttributeConfirmation

INSERT [AttributeValue] ([IsSystem], [AttributeId], [EntityId], [Order], [Value], [Guid])
VALUES (1, @AttributeAdmin, @EntityIdAdmin, 0, @WorkflowTypeId, '6CE9F555-8560-4BF1-951C-8E68ED0D49E9')
, (1, @AttributeSearch, @EntityIdSearch, 0, @WorkflowTypeId, '238A7D9C-C7D0-496E-89C2-1988345A6C60')
, (1, @AttributeFamily, @EntityIdFamily, 0, @WorkflowTypeId, '09688E01-72DB-4B3D-8F73-67898AE8584D')
, (1, @AttributeActivity, @EntityIdActivity, 0, @WorkflowTypeId, '317F06EB-B6E0-4A06-B644-652490D02D63')
, (1, @AttributeConfirmation, @EntityIdConfirmation, 0, @WorkflowTypeId, '17492852-0DF8-4844-9E63-B359B16D9FB6')

/* ---------------------------------------------------------------------- */
------------------------------  TEST DATA ----------------------------------
/* ---------------------------------------------------------------------- */

-- Attribute for GradeTransitionDate
INSERT INTO [AttributeValue] (IsSystem, AttributeId, Value, Guid) VALUES (0, @AttributeGradeTransition, '08/01', newid())

IF NOT EXISTS(SELECT Id FROM EntityType WHERE Name = 'Rock.Model.GroupType')
INSERT INTO EntityType (Name, Guid, IsEntity, IsSecured)
VALUES ('Rock.Model.GroupType', NEWID(), 0, 0)
DECLARE @GroupTypeEntityTypeId int
SET @GroupTypeEntityTypeId = (SELECT Id FROM EntityType WHERE Name = 'Rock.Model.GroupType')
DECLARE @GroupEntityTypeId int
SET @GroupEntityTypeId = (SELECT Id FROM EntityType WHERE Name = 'Rock.Model.Group')
DECLARE @AttributeEntityTypeId INT
SET @AttributeEntityTypeId = (SELECT Id FROM [EntityType] WHERE Name = 'Rock.Model.Attribute')

-- Group Type Check-in Category Id
DECLARE @GroupTypeCheckInCategoryId INT
SET @GroupTypeCheckInCategoryId = (
	SELECT Id FROM Category 
	WHERE EntityTypeId = @AttributeEntityTypeId 
	AND EntityTypeQualifierColumn = 'EntityTypeId' 
	AND EntityTypeQualifierValue = CAST(@GroupTypeEntityTypeId AS varchar)
	AND Name = 'Checkin'
)
IF @GroupTypeCheckInCategoryId IS NULL
BEGIN
	INSERT INTO Category (IsSystem, EntityTypeId, EntityTypeQualifierColumn, EntityTypeQualifierValue, Name, Guid)
	VALUES (0, @AttributeEntityTypeId, 'EntityTypeId', CAST(@GroupTypeEntityTypeId AS varchar), 'Checkin', NEWID())
	SET @GroupTypeCheckInCategoryId = SCOPE_IDENTITY()
END

------------------------------------------------------------------------
-- Reset Groups & GroupTypes
------------------------------------------------------------------------
DELETE GTA FROM [GroupTypeAssociation] GTA INNER JOIN [GroupType] GT ON GT.Id = GTA.GroupTypeId AND GT.Name IN ('Creativity/Technology', 'Next Steps', 'Volunteers', 'KidSpring', 'Fuse')
UPDATE [Group] SET ParentGroupId = null WHERE Name in ('Creativity', 'Stories Team', 'Photo', 'Storytelling', 'Worship', 'Band Green Room', 'Discipleship', 'Attendee', 'Baptism Attendee', 'Volunteer', 'Volunteer', 'Fuse', 'Middle School', '6th Grade Boy', '6th Grade Girl', '7th Grade Boy', '7th Grade Girl', '8th Grade Boy', '8th Grade Girl', 'High School', '9th Grade Boy', '9th Grade Girl', '10th Grade Boy', '10th Grade Girl', '11th Grade Boy', '11th Grade Girl', '12th Grade Boy', '12th Grade Girl', 'KidSpring', 'Nursery', 'Cuddlers', 'Wonder Way 1', 'Wonder Way 2', 'Crawlers', 'Wonder Way 3', 'Wonder Way 4', 'Walkers', 'Wonder Way 5', 'Wonder Way 6', 'Toddlers', 'Wonder Way 7', 'Wonder Way 8', 'Preschool', '2''s', 'Fire Station', 'Lil'' Spring', 'Pop''s Garage', '3''s', 'Spring Fresh', 'SpringTown Police', 'SpringTown Toys', '4''s', 'Treehouse', 'Base Camp (PS)', 'Base Camp Jr.', 'Elementary', 'Base Camp (ES)', 'ImagiNation - K', 'ImagiNation - 1st', 'Jump Street - 2nd', 'Jump Street - 3rd', 'Shockwave - 4th', 'Shockwave - 5th', 'Special Needs', 'Spring Zone', 'Spring Zone Jr.', 'KidSpring Volunteers', 'Elementary Volunteers', 'Base Camp (ES) Volunteer', 'Elementary Service Leader', 'ImagiNation Volunteer', 'Jump Street Volunteer', 'Shockwave Volunteer', 'Nursery Volunteers', 'Nursery Early Bird Volunteer', 'Nursery Service Leader', 'Wonder Way 1 Volunteer', 'Wonder Way 2 Volunteer', 'Wonder Way 3 Volunteer', 'Wonder Way 4 Volunteer', 'Wonder Way 5 Volunteer', 'Wonder Way 6 Volunteer', 'Wonder Way 7 Volunteer', 'Wonder Way 8 Volunteer', 'Preschool Volunteers', 'Base Camp Jr. Volunteer', 'Fire Station Volunteer', 'Lil'' Spring Volunteer', 'Pop''s Garage', 'Preschool Early Bird Volunteer', 'Preschool Service Leader', 'Spring Fresh Volunteer', 'SpringTown Police Volunteer', 'SpringTown Toys Volunteer', 'Treehouse Volunteer', 'Guest Services', 'Advocate', 'Character Team', 'Check-In Volunteer', 'First Time Team', 'Guest Services Service Leader', 'KidSpring Greeter', 'Production Volunteers', 'Elementary Production', 'Preschool Production', 'Special Needs Volunteers', 'Spring Zone Jr. Volunteer', 'Spring Zone Volunteer', 'Support Volunteers', 'KidSpring Office Team', 'KidSpring Trainee', 'Sunday Support Volunteer', 'Volunteer Plug-In Team', 'Volunteers', 'Campus Support', 'Community Outreach', 'Care & Outreach', 'Baptism Team', 'Prayer Team', 'Sunday Care Team', 'Creative & Technology', 'Band Green Room', 'IT Team', 'Production Team', 'Stories Team', 'Finance', 'Finance Team', 'Guest Services', 'Awake Coffee Team', 'Campus Safety', 'Equipping Tour', 'Facility Cleaning Team', 'Fuse Team', 'Green Room', 'Greeting Team', 'Guest Service Desk Team', 'Lobby Team', 'Parking Team', 'Resource Center Team', 'Usher Team', 'Volunteer Coordinator', 'Volunteer Headquarters Team')
DELETE [Group] WHERE Name in ('Creativity', 'Stories Team', 'Photo', 'Storytelling', 'Worship', 'Band Green Room', 'Discipleship', 'Attendee', 'Baptism Attendee', 'Volunteer', 'Volunteer', 'Fuse', 'Middle School', '6th Grade Boy', '6th Grade Girl', '7th Grade Boy', '7th Grade Girl', '8th Grade Boy', '8th Grade Girl', 'High School', '9th Grade Boy', '9th Grade Girl', '10th Grade Boy', '10th Grade Girl', '11th Grade Boy', '11th Grade Girl', '12th Grade Boy', '12th Grade Girl', 'KidSpring', 'Nursery', 'Cuddlers', 'Wonder Way 1', 'Wonder Way 2', 'Crawlers', 'Wonder Way 3', 'Wonder Way 4', 'Walkers', 'Wonder Way 5', 'Wonder Way 6', 'Toddlers', 'Wonder Way 7', 'Wonder Way 8', 'Preschool', '2''s', 'Fire Station', 'Lil'' Spring', 'Pop''s Garage', '3''s', 'Spring Fresh', 'SpringTown Police', 'SpringTown Toys', '4''s', 'Treehouse', 'Base Camp (PS)', 'Base Camp Jr.', 'Elementary', 'Base Camp (ES)', 'ImagiNation - K', 'ImagiNation - 1st', 'Jump Street - 2nd', 'Jump Street - 3rd', 'Shockwave - 4th', 'Shockwave - 5th', 'Special Needs', 'Spring Zone', 'Spring Zone Jr.', 'KidSpring Volunteers', 'Elementary Volunteers', 'Base Camp (ES) Volunteer', 'Elementary Service Leader', 'ImagiNation Volunteer', 'Jump Street Volunteer', 'Shockwave Volunteer', 'Nursery Volunteers', 'Nursery Early Bird Volunteer', 'Nursery Service Leader', 'Wonder Way 1 Volunteer', 'Wonder Way 2 Volunteer', 'Wonder Way 3 Volunteer', 'Wonder Way 4 Volunteer', 'Wonder Way 5 Volunteer', 'Wonder Way 6 Volunteer', 'Wonder Way 7 Volunteer', 'Wonder Way 8 Volunteer', 'Preschool Volunteers', 'Base Camp Jr. Volunteer', 'Fire Station Volunteer', 'Lil'' Spring Volunteer', 'Pop''s Garage', 'Preschool Early Bird Volunteer', 'Preschool Service Leader', 'Spring Fresh Volunteer', 'SpringTown Police Volunteer', 'SpringTown Toys Volunteer', 'Treehouse Volunteer', 'Guest Services', 'Advocate', 'Character Team', 'Check-In Volunteer', 'First Time Team', 'Guest Services Service Leader', 'KidSpring Greeter', 'Production Volunteers', 'Elementary Production', 'Preschool Production', 'Special Needs Volunteers', 'Spring Zone Jr. Volunteer', 'Spring Zone Volunteer', 'Support Volunteers', 'KidSpring Office Team', 'KidSpring Trainee', 'Sunday Support Volunteer', 'Volunteer Plug-In Team', 'Volunteers', 'Campus Support', 'Community Outreach', 'Care & Outreach', 'Baptism Team', 'Prayer Team', 'Sunday Care Team', 'Creative & Technology', 'Band Green Room', 'IT Team', 'Production Team', 'Stories Team', 'Finance', 'Finance Team', 'Guest Services', 'Awake Coffee Team', 'Campus Safety', 'Equipping Tour', 'Facility Cleaning Team', 'Fuse Team', 'Green Room', 'Greeting Team', 'Guest Service Desk Team', 'Lobby Team', 'Parking Team', 'Resource Center Team', 'Usher Team', 'Volunteer Coordinator', 'Volunteer Headquarters Team')
DELETE [GroupType] WHERE Name in ('Creativity/Technology', 'Next Steps', 'Guest Services', 'KidSpring', 'Fuse')

------------------------------------------------------------------------
-- Add GroupTypes
------------------------------------------------------------------------
-- Top level checkin group
--DECLARE @TopLevelGroupTypeId int
DECLARE @ParentGroupTypeId int
DECLARE @AgeTypeId int
DECLARE @GradeTypeId int
DECLARE @AbilityTypeId int
DECLARE @GenderTypeId int
DECLARE @KidSpringTypeId int
DECLARE @NurseryTypeId int
DECLARE @PreschoolTypeId int
DECLARE @ElementaryTypeId int
DECLARE @FuseTypeId int
DECLARE @MSTypeId int
DECLARE @HSTypeId int
DECLARE @GSTypeId int
DECLARE @CTTypeId int

-- Let each ministry be a top level group
--INSERT INTO [GroupType] ( [IsSystem],[Name],[Guid],[AllowMultipleLocations],[TakesAttendance],[AttendanceRule],[AttendancePrintTo]) 
--VALUES (0, 'Checkin Area', NEWID(), 1, 0, 0, 0)
--SET @TopLevelGroupTypeId = SCOPE_IDENTITY()

-- KidSpring
INSERT INTO [GroupType] ( [IsSystem],[Name],[Guid],[AllowMultipleLocations],[TakesAttendance],[AttendanceRule],[AttendancePrintTo]) 
VALUES (0, 'KidSpring', NEWID(), 1, 0, 0, 0)
SET @KidSpringTypeId = SCOPE_IDENTITY()
SET @ParentGroupTypeId = @KidSpringTypeId

-- Age/Grade/Ability
INSERT INTO [GroupType] ( [IsSystem],[Name],[Guid],[AllowMultipleLocations],[TakesAttendance],[AttendanceRule],[AttendancePrintTo])
   VALUES (0, 'Check in by Age', NEWID(), 0, 0, 0, 0)
SET @AgeTypeId = SCOPE_IDENTITY()
INSERT INTO [GroupTypeAssociation] VALUES (@ParentGroupTypeId, @AgeTypeId);

INSERT INTO [GroupType] ( [IsSystem],[Name],[Guid],[AllowMultipleLocations],[TakesAttendance],[AttendanceRule],[AttendancePrintTo],[InheritedGroupTypeId])
   VALUES (0, 'Check in by Grade', NEWID(), 0, 0, 0, 0, @GradeTypeId)
SET @GradeTypeId = SCOPE_IDENTITY()
INSERT INTO [GroupTypeAssociation] VALUES (@ParentGroupTypeId, @GradeTypeId);

INSERT INTO [GroupType] ( [IsSystem],[Name],[Guid],[AllowMultipleLocations],[TakesAttendance],[AttendanceRule],[AttendancePrintTo],[InheritedGroupTypeId])
   VALUES (0, 'Check in by Ability', NEWID(), 0, 0, 0, 0, @AbilityTypeId)
SET @AbilityTypeId = SCOPE_IDENTITY()
INSERT INTO [GroupTypeAssociation] VALUES (@ParentGroupTypeId, @AbilityTypeId);

INSERT INTO [GroupType] ( [IsSystem],[Name],[Guid],[AllowMultipleLocations],[TakesAttendance],[AttendanceRule],[AttendancePrintTo],[InheritedGroupTypeId])
   VALUES (0, 'Check in by Gender', NEWID(), 0, 0, 0, 0, @GenderTypeId)
SET @GenderTypeId = SCOPE_IDENTITY()
INSERT INTO [GroupTypeAssociation] VALUES (@ParentGroupTypeId, @GenderTypeId);


-- Nursery
INSERT INTO [GroupType] ( [IsSystem],[Name],[Guid],[AllowMultipleLocations],[TakesAttendance],[AttendanceRule],[AttendancePrintTo]) 
VALUES (0, 'Nursery', NEWID(), 1, 0, 0, 0)
SET @NurseryTypeId = SCOPE_IDENTITY()
INSERT INTO [GroupTypeAssociation] VALUES (@ParentGroupTypeId, @NurseryTypeId);

-- Preschool
INSERT INTO [GroupType] ( [IsSystem],[Name],[Guid],[AllowMultipleLocations],[TakesAttendance],[AttendanceRule],[AttendancePrintTo]) 
VALUES (0, 'Preschool', NEWID(), 1, 0, 0, 0)
SET @PreschoolTypeId = SCOPE_IDENTITY()
INSERT INTO [GroupTypeAssociation] VALUES (@ParentGroupTypeId, @PreschoolTypeId);

-- Elementary
INSERT INTO [GroupType] ( [IsSystem],[Name],[Guid],[AllowMultipleLocations],[TakesAttendance],[AttendanceRule],[AttendancePrintTo]) 
VALUES (0, 'Elementary', NEWID(), 1, 0, 0, 0)
SET @ElementaryTypeId = SCOPE_IDENTITY()
INSERT INTO [GroupTypeAssociation] VALUES (@ParentGroupTypeId, @ElementaryTypeId);

-- Fuse
INSERT INTO [GroupType] ( [IsSystem],[Name],[Guid],[AllowMultipleLocations],[TakesAttendance],[AttendanceRule],[AttendancePrintTo]) 
VALUES (0, 'Fuse', NEWID(), 1, 0, 0, 0)
SET @FuseTypeId = SCOPE_IDENTITY()
SET @ParentGroupTypeId = @FuseTypeId

-- Middle School
INSERT INTO [GroupType] ( [IsSystem],[Name],[Guid],[AllowMultipleLocations],[TakesAttendance],[AttendanceRule],[AttendancePrintTo]) 
VALUES (0, 'Middle School', NEWID(), 1, 0, 0, 0)
SET @MSTypeId = SCOPE_IDENTITY()
INSERT INTO [GroupTypeAssociation] VALUES (@ParentGroupTypeId, @MSTypeId);

-- High School
INSERT INTO [GroupType] ( [IsSystem],[Name],[Guid],[AllowMultipleLocations],[TakesAttendance],[AttendanceRule],[AttendancePrintTo]) 
VALUES (0, 'High School', NEWID(), 1, 0, 0, 0)
SET @HSTypeId = SCOPE_IDENTITY()
INSERT INTO [GroupTypeAssociation] VALUES (@ParentGroupTypeId, @HSTypeId);

-- Volunteers
INSERT INTO [GroupType] ( [IsSystem],[Name],[Guid],[AllowMultipleLocations],[TakesAttendance],[AttendanceRule],[AttendancePrintTo]) 
VALUES (0, 'Guest Services', NEWID(), 1, 0, 0, 0)
SET @ParentGroupTypeId = SCOPE_IDENTITY()

-- Creativity/Technology
INSERT INTO [GroupType] ( [IsSystem],[Name],[Guid],[AllowMultipleLocations],[TakesAttendance],[AttendanceRule],[AttendancePrintTo]) 
VALUES (0, 'Creativity/Technology', NEWID(), 1, 0, 0, 0)
SET @ParentGroupTypeId = SCOPE_IDENTITY()

-- Discipleship
INSERT INTO [GroupType] ( [IsSystem],[Name],[Guid],[AllowMultipleLocations],[TakesAttendance],[AttendanceRule],[AttendancePrintTo]) 
VALUES (0, 'Next Steps', NEWID(), 1, 0, 0, 0)
SET @ParentGroupTypeId = SCOPE_IDENTITY()


------------------------------------------------------------------------
-- Add Campus & Location
------------------------------------------------------------------------
DELETE [Location]
DECLARE @CampusLocationId int
DECLARE @CampusID int

INSERT INTO [Location] ([Guid], [Name], [IsActive], [Street1], [City], [State], [Zip], [Country])	
VALUES (NEWID(), 'Anderson', 1, '2940 Concord Road', 'Anderson', 'SC', '29621', 'US')
SET @CampusLocationId = SCOPE_IDENTITY()

INSERT INTO [Campus] ( [IsSystem], [Name], [Guid], [LocationId], [ShortCode] )
VALUES (0, 'Anderson', NEWID(), @CampusLocationId, 'AND')
SET @CampusID = SCOPE_IDENTITY()

------------------------------------------------------------------------
-- Add Group Attributes
------------------------------------------------------------------------
DECLARE @MinAgeId int
DECLARE @MaxAgeId int
DECLARE @MinGradeId int
DECLARE @MaxGradeId int
DECLARE @AbilityId int
DECLARE @GenderId int

-- Minimum Age
INSERT INTO [Attribute] ( IsSystem, FieldTypeId, EntityTypeId, EntityTypeQualifierColumn, EntityTypeQualifierValue, [Key], Name, [Order], IsGridColumn, IsMultiValue, IsRequired, [Guid], [Description] )
	VALUES ( 0, @DecimalFieldTypeId, @GroupEntityTypeId, 'GroupTypeId', @AgeTypeId, 'MinAge', 'Minimum Age', 0, 0, 0, 0, NEWID(), 'The minimum age required to check into these group types.' )
SET @MinAgeId = SCOPE_IDENTITY()
INSERT INTO [AttributeCategory] (AttributeId, CategoryId) VALUES (@MinAgeId, @GroupTypeCheckInCategoryId)

-- Maximum Age
INSERT INTO [Attribute] ( IsSystem, FieldTypeId, EntityTypeId, EntityTypeQualifierColumn, EntityTypeQualifierValue, [Key], Name, [Order], IsGridColumn, IsMultiValue, IsRequired, [Guid], [Description] )
	VALUES ( 0, @DecimalFieldTypeId, @GroupEntityTypeId, 'GroupTypeId', @AgeTypeId, 'MaxAge', 'Maximum Age', 1, 0, 0, 0, NEWID(), 'The maximum age allowed to check into these group types.' )
SET @MaxAgeId = SCOPE_IDENTITY()
INSERT INTO [AttributeCategory] (AttributeId, CategoryId) VALUES (@MaxAgeId, @GroupTypeCheckInCategoryId)

-- Minimum Grade
INSERT INTO [Attribute] ( IsSystem, FieldTypeId, EntityTypeId, EntityTypeQualifierColumn, EntityTypeQualifierValue, [Key], Name, [Order], IsGridColumn, IsMultiValue, IsRequired, [Guid], [Description] )
	VALUES ( 0, @IntFieldTypeId, @GroupEntityTypeId, 'GroupTypeId', @GradeTypeId, 'MinGrade', 'Minimum Grade', 0, 0, 0, 0, NEWID(), 'Defines the lower grade level required to check into these group types.' )
SET @MinGradeId = SCOPE_IDENTITY()
INSERT INTO [AttributeCategory] (AttributeId, CategoryId) VALUES (@MinGradeId, @GroupTypeCheckInCategoryId)

-- Maximum Grade		   
INSERT INTO [Attribute] ( IsSystem, FieldTypeId, EntityTypeId, EntityTypeQualifierColumn, EntityTypeQualifierValue, [Key], Name, [Order], IsGridColumn, IsMultiValue, IsRequired, [Guid], [Description] )
	VALUES ( 0, @IntFieldTypeId, @GroupEntityTypeId, 'GroupTypeId', @GradeTypeId, 'MaxGrade', 'Maximum Grade', 1, 0, 0, 0, NEWID(), 'Defines the upper grade level allowed to check into these group types.' )
SET @MaxGradeId = SCOPE_IDENTITY()
INSERT INTO [AttributeCategory] (AttributeId, CategoryId) VALUES (@MaxGradeId, @GroupTypeCheckInCategoryId)

-- Ability Level
INSERT INTO [Attribute] ( IsSystem, FieldTypeId, EntityTypeId, EntityTypeQualifierColumn, EntityTypeQualifierValue, [Key], Name, [Order], IsGridColumn, IsMultiValue, IsRequired, [Guid], [Description] )
	VALUES ( 0, @IntFieldTypeId, @GroupEntityTypeId, 'GroupTypeId', @AbilityTypeId, 'MaxGrade', 'Maximum Grade', 1, 0, 0, 0, NEWID(), 'Defines the ability level required to check into these group types.' )
SET @AbilityId = SCOPE_IDENTITY()
INSERT INTO [AttributeCategory] (AttributeId, CategoryId) VALUES (@AbilityId, @GroupTypeCheckInCategoryId)

-- Gender
INSERT INTO [Attribute] ( IsSystem, FieldTypeId, EntityTypeId, EntityTypeQualifierColumn, EntityTypeQualifierValue, [Key], Name, [Order], IsGridColumn, IsMultiValue, IsRequired, [Guid], [Description] )
	VALUES ( 0, @IntFieldTypeId, @GroupEntityTypeId, 'GroupTypeId', @GenderTypeId, 'Gender', 'Gender', 1, 0, 0, 0, NEWID(), 'Defines the gender required to check into these group types.' )
SET @GenderId = SCOPE_IDENTITY()
INSERT INTO [AttributeCategory] (AttributeId, CategoryId) VALUES (@GenderId, @GroupTypeCheckInCategoryId)


------------------------------------------------------------------------
-- Add Groups
------------------------------------------------------------------------
DECLARE @TopLevelGroupId int
DECLARE @ParentGroupId int
DECLARE @GroupId int

-- Weekend Service Checkin Area
--SELECT @GroupTypeId = [Id] FROM [GroupType] GT WHERE GT.Name = 'Checkin Area'
--INSERT INTO [Group] ( [IsSystem],[GroupTypeId],[Name],[IsSecurityRole],[IsActive],[Guid]) 
--SELECT 0, @GroupTypeId, 'Checkin Area', 0, 1, NEWID() 
--SET @TopLevelGroupId = SCOPE_IDENTITY()

-- KidSpring
INSERT INTO [Group] ( [IsSystem],[ParentGroupId], [GroupTypeId], [CampusId], [Name],[IsSecurityRole],[IsActive],[Guid]) 
SELECT 0, NULL, @KidSpringTypeId, @CampusID, 'KidSpring', 0, 1, NEWID() 
SET @TopLevelGroupId = SCOPE_IDENTITY()

-- Nursery Groups
INSERT INTO [Group] ( [IsSystem],[ParentGroupId], [GroupTypeId], [CampusId], [Name],[IsSecurityRole],[IsActive],[Guid]) 
SELECT 0, @TopLevelGroupId, @NurseryTypeId, @CampusID, 'Nursery', 0, 1, NEWID() 
SET @ParentGroupId = SCOPE_IDENTITY()
INSERT INTO [AttributeValue] (IsSystem, AttributeId, EntityId, [Order], [Value], [Guid]) VALUES (0, @MinAgeId, @ParentGroupId, 0, '0.0', NEWID())
INSERT INTO [AttributeValue] (IsSystem, AttributeId, EntityId, [Order], [Value], [Guid]) VALUES (0, @MaxAgeId, @ParentGroupId, 0, '2.09', NEWID())

INSERT INTO [Group] ( [IsSystem],[ParentGroupId], [GroupTypeId], [CampusId], [Name],[IsSecurityRole],[IsActive],[Guid]) 
SELECT 0, @ParentGroupId, @NurseryTypeId, @CampusID, 'Wonder Way - 1', 0, 1, NEWID() 
SET @GroupId = SCOPE_IDENTITY()
INSERT INTO [AttributeValue] (IsSystem, AttributeId, EntityId, [Order], [Value], [Guid]) VALUES (0, @MinAgeId, @GroupId, 0, '0.0', NEWID())
INSERT INTO [AttributeValue] (IsSystem, AttributeId, EntityId, [Order], [Value], [Guid]) VALUES (0, @MaxAgeId, @GroupId, 0, '0.59', NEWID())
INSERT INTO [AttributeValue] (IsSystem, AttributeId, EntityId, [Order], [Value], [Guid]) VALUES (0, @AbilityId, @GroupId, 0, 'Cuddlers', NEWID())

INSERT INTO [Group] ( [IsSystem],[ParentGroupId], [GroupTypeId], [CampusId], [Name],[IsSecurityRole],[IsActive],[Guid]) 
SELECT 0, @ParentGroupId, @NurseryTypeId, @CampusID, 'Wonder Way - 2', 0, 1, NEWID() 
SET @GroupId = SCOPE_IDENTITY()
INSERT INTO [AttributeValue] (IsSystem, AttributeId, EntityId, [Order], [Value], [Guid]) VALUES (0, @MinAgeId, @GroupId, 0, '0.0', NEWID())
INSERT INTO [AttributeValue] (IsSystem, AttributeId, EntityId, [Order], [Value], [Guid]) VALUES (0, @MaxAgeId, @GroupId, 0, '0.59', NEWID())
INSERT INTO [AttributeValue] (IsSystem, AttributeId, EntityId, [Order], [Value], [Guid]) VALUES (0, @AbilityId, @GroupId, 0, 'Cuddlers', NEWID())

INSERT INTO [Group] ( [IsSystem],[ParentGroupId], [GroupTypeId], [CampusId], [Name],[IsSecurityRole],[IsActive],[Guid]) 
SELECT 0, @ParentGroupId, @NurseryTypeId, @CampusID, 'Wonder Way - 3', 0, 1, NEWID() 
SET @GroupId = SCOPE_IDENTITY()
INSERT INTO [AttributeValue] (IsSystem, AttributeId, EntityId, [Order], [Value], [Guid]) VALUES (0, @MinAgeId, @GroupId, 0, '0.59', NEWID())
INSERT INTO [AttributeValue] (IsSystem, AttributeId, EntityId, [Order], [Value], [Guid]) VALUES (0, @MaxAgeId, @GroupId, 0, '1.09', NEWID())
INSERT INTO [AttributeValue] (IsSystem, AttributeId, EntityId, [Order], [Value], [Guid]) VALUES (0, @AbilityId, @GroupId, 0, 'Crawlers', NEWID())

INSERT INTO [Group] ( [IsSystem],[ParentGroupId], [GroupTypeId], [CampusId], [Name],[IsSecurityRole],[IsActive],[Guid]) 
SELECT 0, @ParentGroupId, @NurseryTypeId, @CampusID, 'Wonder Way - 4', 0, 1, NEWID() 
SET @GroupId = SCOPE_IDENTITY()
INSERT INTO [AttributeValue] (IsSystem, AttributeId, EntityId, [Order], [Value], [Guid]) VALUES (0, @MinAgeId, @GroupId, 0, '0.59', NEWID())
INSERT INTO [AttributeValue] (IsSystem, AttributeId, EntityId, [Order], [Value], [Guid]) VALUES (0, @MaxAgeId, @GroupId, 0, '1.09', NEWID())
INSERT INTO [AttributeValue] (IsSystem, AttributeId, EntityId, [Order], [Value], [Guid]) VALUES (0, @AbilityId, @GroupId, 0, 'Crawlers', NEWID())

INSERT INTO [Group] ( [IsSystem],[ParentGroupId], [GroupTypeId], [CampusId], [Name],[IsSecurityRole],[IsActive],[Guid]) 
SELECT 0, @ParentGroupId, @NurseryTypeId, @CampusID, 'Wonder Way - 5', 0, 1, NEWID() 
SET @GroupId = SCOPE_IDENTITY()
INSERT INTO [AttributeValue] (IsSystem, AttributeId, EntityId, [Order], [Value], [Guid]) VALUES (0, @MinAgeId, @GroupId, 0, '1.09', NEWID())
INSERT INTO [AttributeValue] (IsSystem, AttributeId, EntityId, [Order], [Value], [Guid]) VALUES (0, @MaxAgeId, @GroupId, 0, '1.59', NEWID())
INSERT INTO [AttributeValue] (IsSystem, AttributeId, EntityId, [Order], [Value], [Guid]) VALUES (0, @AbilityId, @GroupId, 0, 'Walkers', NEWID())

INSERT INTO [Group] ( [IsSystem],[ParentGroupId], [GroupTypeId], [CampusId], [Name],[IsSecurityRole],[IsActive],[Guid]) 
SELECT 0, @ParentGroupId, @NurseryTypeId, @CampusID, 'Wonder Way - 6', 0, 1, NEWID() 
SET @GroupId = SCOPE_IDENTITY()
INSERT INTO [AttributeValue] (IsSystem, AttributeId, EntityId, [Order], [Value], [Guid]) VALUES (0, @MinAgeId, @GroupId, 0, '1.09', NEWID())
INSERT INTO [AttributeValue] (IsSystem, AttributeId, EntityId, [Order], [Value], [Guid]) VALUES (0, @MaxAgeId, @GroupId, 0, '1.59', NEWID())
INSERT INTO [AttributeValue] (IsSystem, AttributeId, EntityId, [Order], [Value], [Guid]) VALUES (0, @AbilityId, @GroupId, 0, 'Walkers', NEWID())

INSERT INTO [Group] ( [IsSystem],[ParentGroupId], [GroupTypeId], [CampusId], [Name],[IsSecurityRole],[IsActive],[Guid]) 
SELECT 0, @ParentGroupId, @NurseryTypeId, @CampusID, 'Wonder Way - 7', 0, 1, NEWID() 
SET @GroupId = SCOPE_IDENTITY()
INSERT INTO [AttributeValue] (IsSystem, AttributeId, EntityId, [Order], [Value], [Guid]) VALUES (0, @MinAgeId, @GroupId, 0, '1.59', NEWID())
INSERT INTO [AttributeValue] (IsSystem, AttributeId, EntityId, [Order], [Value], [Guid]) VALUES (0, @MaxAgeId, @GroupId, 0, '2.09', NEWID())
INSERT INTO [AttributeValue] (IsSystem, AttributeId, EntityId, [Order], [Value], [Guid]) VALUES (0, @AbilityId, @GroupId, 0, 'Toddlers', NEWID())

INSERT INTO [Group] ( [IsSystem],[ParentGroupId], [GroupTypeId], [CampusId], [Name],[IsSecurityRole],[IsActive],[Guid]) 
SELECT 0, @ParentGroupId, @NurseryTypeId, @CampusID, 'Wonder Way - 8', 0, 1, NEWID() 
SET @GroupId = SCOPE_IDENTITY()
INSERT INTO [AttributeValue] (IsSystem, AttributeId, EntityId, [Order], [Value], [Guid]) VALUES (0, @MinAgeId, @GroupId, 0, '1.59', NEWID())
INSERT INTO [AttributeValue] (IsSystem, AttributeId, EntityId, [Order], [Value], [Guid]) VALUES (0, @MaxAgeId, @GroupId, 0, '2.09', NEWID())
INSERT INTO [AttributeValue] (IsSystem, AttributeId, EntityId, [Order], [Value], [Guid]) VALUES (0, @AbilityId, @GroupId, 0, 'Toddlers', NEWID())

-- Preschool
INSERT INTO [Group] ( [IsSystem],[ParentGroupId], [GroupTypeId], [CampusId], [Name],[IsSecurityRole],[IsActive],[Guid]) 
SELECT 0, @TopLevelGroupId, @PreschoolTypeId, @CampusID, 'Preschool', 0, 1, NEWID() 
SET @ParentGroupId = SCOPE_IDENTITY()
INSERT INTO [AttributeValue] (IsSystem, AttributeId, EntityId, [Order], [Value], [Guid]) VALUES (0, @MinAgeId, @ParentGroupId, 0, '2.00', NEWID())
INSERT INTO [AttributeValue] (IsSystem, AttributeId, EntityId, [Order], [Value], [Guid]) VALUES (0, @MaxAgeId, @ParentGroupId, 0, '4.99', NEWID())
INSERT INTO [AttributeValue] (IsSystem, AttributeId, EntityId, [Order], [Value], [Guid]) VALUES (0, @AbilityId, @ParentGroupId, 0, 'Toddlers', NEWID())

INSERT INTO [Group] ( [IsSystem],[ParentGroupId], [GroupTypeId], [CampusId], [Name],[IsSecurityRole],[IsActive],[Guid]) 
SELECT 0, @ParentGroupId, @PreschoolTypeId, @CampusID, 'Fire Station', 0, 1, NEWID() 
SET @GroupId = SCOPE_IDENTITY()
INSERT INTO [AttributeValue] (IsSystem, AttributeId, EntityId, [Order], [Value], [Guid]) VALUES (0, @MinAgeId, @GroupId, 0, '2.00', NEWID())
INSERT INTO [AttributeValue] (IsSystem, AttributeId, EntityId, [Order], [Value], [Guid]) VALUES (0, @MaxAgeId, @GroupId, 0, '2.99', NEWID())
INSERT INTO [AttributeValue] (IsSystem, AttributeId, EntityId, [Order], [Value], [Guid]) VALUES (0, @AbilityId, @GroupId, 0, 'Toddlers', NEWID())

INSERT INTO [Group] ( [IsSystem],[ParentGroupId], [GroupTypeId], [CampusId], [Name],[IsSecurityRole],[IsActive],[Guid]) 
SELECT 0, @ParentGroupId, @PreschoolTypeId, @CampusID, 'Lil'' Spring', 0, 1, NEWID() 
SET @GroupId = SCOPE_IDENTITY()
INSERT INTO [AttributeValue] (IsSystem, AttributeId, EntityId, [Order], [Value], [Guid]) VALUES (0, @MinAgeId, @GroupId, 0, '2.00', NEWID())
INSERT INTO [AttributeValue] (IsSystem, AttributeId, EntityId, [Order], [Value], [Guid]) VALUES (0, @MaxAgeId, @GroupId, 0, '2.99', NEWID())
INSERT INTO [AttributeValue] (IsSystem, AttributeId, EntityId, [Order], [Value], [Guid]) VALUES (0, @AbilityId, @GroupId, 0, 'Toddlers', NEWID())

INSERT INTO [Group] ( [IsSystem],[ParentGroupId], [GroupTypeId], [CampusId], [Name],[IsSecurityRole],[IsActive],[Guid]) 
SELECT 0, @ParentGroupId, @PreschoolTypeId, @CampusID, 'Pop''s Garage', 0, 1, NEWID() 
SET @GroupId = SCOPE_IDENTITY()
INSERT INTO [AttributeValue] (IsSystem, AttributeId, EntityId, [Order], [Value], [Guid]) VALUES (0, @MinAgeId, @GroupId, 0, '2.00', NEWID())
INSERT INTO [AttributeValue] (IsSystem, AttributeId, EntityId, [Order], [Value], [Guid]) VALUES (0, @MaxAgeId, @GroupId, 0, '2.99', NEWID())
INSERT INTO [AttributeValue] (IsSystem, AttributeId, EntityId, [Order], [Value], [Guid]) VALUES (0, @AbilityId, @GroupId, 0, 'Toddlers', NEWID())

INSERT INTO [Group] ( [IsSystem],[ParentGroupId], [GroupTypeId], [CampusId], [Name],[IsSecurityRole],[IsActive],[Guid]) 
SELECT 0, @ParentGroupId, @PreschoolTypeId, @CampusID, 'Spring Fresh', 0, 1, NEWID() 
SET @GroupId = SCOPE_IDENTITY()
INSERT INTO [AttributeValue] (IsSystem, AttributeId, EntityId, [Order], [Value], [Guid]) VALUES (0, @MinAgeId, @GroupId, 0, '3.00', NEWID())
INSERT INTO [AttributeValue] (IsSystem, AttributeId, EntityId, [Order], [Value], [Guid]) VALUES (0, @MaxAgeId, @GroupId, 0, '3.99', NEWID())
INSERT INTO [AttributeValue] (IsSystem, AttributeId, EntityId, [Order], [Value], [Guid]) VALUES (0, @AbilityId, @GroupId, 0, 'PottyTrained', NEWID())

INSERT INTO [Group] ( [IsSystem],[ParentGroupId], [GroupTypeId], [CampusId], [Name],[IsSecurityRole],[IsActive],[Guid]) 
SELECT 0, @ParentGroupId, @PreschoolTypeId, @CampusID, 'SpringTown Police', 0, 1, NEWID() 
SET @GroupId = SCOPE_IDENTITY()
INSERT INTO [AttributeValue] (IsSystem, AttributeId, EntityId, [Order], [Value], [Guid]) VALUES (0, @MinAgeId, @GroupId, 0, '3.00', NEWID())
INSERT INTO [AttributeValue] (IsSystem, AttributeId, EntityId, [Order], [Value], [Guid]) VALUES (0, @MaxAgeId, @GroupId, 0, '3.99', NEWID())
INSERT INTO [AttributeValue] (IsSystem, AttributeId, EntityId, [Order], [Value], [Guid]) VALUES (0, @AbilityId, @GroupId, 0, 'PottyTrained', NEWID())

INSERT INTO [Group] ( [IsSystem],[ParentGroupId], [GroupTypeId], [CampusId], [Name],[IsSecurityRole],[IsActive],[Guid]) 
SELECT 0, @ParentGroupId, @PreschoolTypeId, @CampusID, 'SpringTown Toys', 0, 1, NEWID() 
SET @GroupId = SCOPE_IDENTITY()
INSERT INTO [AttributeValue] (IsSystem, AttributeId, EntityId, [Order], [Value], [Guid]) VALUES (0, @MinAgeId, @GroupId, 0, '3.00', NEWID())
INSERT INTO [AttributeValue] (IsSystem, AttributeId, EntityId, [Order], [Value], [Guid]) VALUES (0, @MaxAgeId, @GroupId, 0, '3.99', NEWID())
INSERT INTO [AttributeValue] (IsSystem, AttributeId, EntityId, [Order], [Value], [Guid]) VALUES (0, @AbilityId, @GroupId, 0, 'PottyTrained', NEWID())

INSERT INTO [Group] ( [IsSystem],[ParentGroupId], [GroupTypeId], [CampusId], [Name],[IsSecurityRole],[IsActive],[Guid]) 
SELECT 0, @ParentGroupId, @PreschoolTypeId, @CampusID, 'Treehouse', 0, 1, NEWID() 
SET @GroupId = SCOPE_IDENTITY()
INSERT INTO [AttributeValue] (IsSystem, AttributeId, EntityId, [Order], [Value], [Guid]) VALUES (0, @MinAgeId, @GroupId, 0, '4.00', NEWID())
INSERT INTO [AttributeValue] (IsSystem, AttributeId, EntityId, [Order], [Value], [Guid]) VALUES (0, @MaxAgeId, @GroupId, 0, '4.99', NEWID())
INSERT INTO [AttributeValue] (IsSystem, AttributeId, EntityId, [Order], [Value], [Guid]) VALUES (0, @AbilityId, @GroupId, 0, 'PottyTrained', NEWID())

INSERT INTO [Group] ( [IsSystem],[ParentGroupId], [GroupTypeId], [CampusId], [Name],[IsSecurityRole],[IsActive],[Guid]) 
SELECT 0, @ParentGroupId, @PreschoolTypeId, @CampusID, 'Base Camp Jr.', 0, 1, NEWID() 
SET @GroupId = SCOPE_IDENTITY()
INSERT INTO [AttributeValue] (IsSystem, AttributeId, EntityId, [Order], [Value], [Guid]) VALUES (0, @MinAgeId, @GroupId, 0, '2.00', NEWID())
INSERT INTO [AttributeValue] (IsSystem, AttributeId, EntityId, [Order], [Value], [Guid]) VALUES (0, @MaxAgeId, @GroupId, 0, '4.99', NEWID())

-- Elementary
INSERT INTO [Group] ( [IsSystem],[ParentGroupId], [GroupTypeId], [CampusId], [Name],[IsSecurityRole],[IsActive],[Guid]) 
SELECT 0, @TopLevelGroupId, @ElementaryTypeId, @CampusID, 'Elementary', 0, 1, NEWID() 
SET @ParentGroupId = SCOPE_IDENTITY()
INSERT INTO [AttributeValue] (IsSystem, AttributeId, EntityId, [Order], [Value], [Guid]) VALUES (0, @MinAgeId, @ParentGroupId, 0, '5.00', NEWID())
INSERT INTO [AttributeValue] (IsSystem, AttributeId, EntityId, [Order], [Value], [Guid]) VALUES (0, @MaxAgeId, @ParentGroupId, 0, '12.99', NEWID())

INSERT INTO [Group] ( [IsSystem],[ParentGroupId], [GroupTypeId], [CampusId], [Name],[IsSecurityRole],[IsActive],[Guid]) 
SELECT 0, @ParentGroupId, @ElementaryTypeId, @CampusID, 'Base Camp (ES)', 0, 1, NEWID() 
SET @GroupId = SCOPE_IDENTITY()
INSERT INTO [AttributeValue] (IsSystem, AttributeId, EntityId, [Order], [Value], [Guid]) VALUES (0, @MinAgeId, @GroupId, 0, '5.00', NEWID())
INSERT INTO [AttributeValue] (IsSystem, AttributeId, EntityId, [Order], [Value], [Guid]) VALUES (0, @MaxAgeId, @GroupId, 0, '12.99', NEWID())

INSERT INTO [Group] ( [IsSystem],[ParentGroupId], [GroupTypeId], [CampusId], [Name],[IsSecurityRole],[IsActive],[Guid]) 
SELECT 0, @ParentGroupId, @ElementaryTypeId, @CampusID, 'ImagiNation - K', 0, 1, NEWID() 
SET @GroupId = SCOPE_IDENTITY()
INSERT INTO [AttributeValue] (IsSystem, AttributeId, EntityId, [Order], [Value], [Guid]) VALUES (0, @MinAgeId, @GroupId, 0, '4.00', NEWID())
INSERT INTO [AttributeValue] (IsSystem, AttributeId, EntityId, [Order], [Value], [Guid]) VALUES (0, @MaxAgeId, @GroupId, 0, '5.99', NEWID())
INSERT INTO [AttributeValue] (IsSystem, AttributeId, EntityId, [Order], [Value], [Guid]) VALUES (0, @MinGradeId, @GroupId, 0, '0', NEWID())
INSERT INTO [AttributeValue] (IsSystem, AttributeId, EntityId, [Order], [Value], [Guid]) VALUES (0, @MaxGradeId, @GroupId, 0, '0', NEWID())

INSERT INTO [Group] ( [IsSystem],[ParentGroupId], [GroupTypeId], [CampusId], [Name],[IsSecurityRole],[IsActive],[Guid]) 
SELECT 0, @ParentGroupId, @ElementaryTypeId, @CampusID, 'ImagiNation - 1st', 0, 1, NEWID() 
SET @GroupId = SCOPE_IDENTITY()
INSERT INTO [AttributeValue] (IsSystem, AttributeId, EntityId, [Order], [Value], [Guid]) VALUES (0, @MinAgeId, @GroupId, 0, '6.00', NEWID())
INSERT INTO [AttributeValue] (IsSystem, AttributeId, EntityId, [Order], [Value], [Guid]) VALUES (0, @MaxAgeId, @GroupId, 0, '7.99', NEWID())
INSERT INTO [AttributeValue] (IsSystem, AttributeId, EntityId, [Order], [Value], [Guid]) VALUES (0, @MinGradeId, @GroupId, 0, '1', NEWID())
INSERT INTO [AttributeValue] (IsSystem, AttributeId, EntityId, [Order], [Value], [Guid]) VALUES (0, @MaxGradeId, @GroupId, 0, '1', NEWID())

INSERT INTO [Group] ( [IsSystem],[ParentGroupId], [GroupTypeId], [CampusId], [Name],[IsSecurityRole],[IsActive],[Guid]) 
SELECT 0, @ParentGroupId, @ElementaryTypeId, @CampusID, 'Jump Street - 2nd', 0, 1, NEWID() 
SET @GroupId = SCOPE_IDENTITY()
INSERT INTO [AttributeValue] (IsSystem, AttributeId, EntityId, [Order], [Value], [Guid]) VALUES (0, @MinAgeId, @GroupId, 0, '7.00', NEWID())
INSERT INTO [AttributeValue] (IsSystem, AttributeId, EntityId, [Order], [Value], [Guid]) VALUES (0, @MaxAgeId, @GroupId, 0, '8.99', NEWID())
INSERT INTO [AttributeValue] (IsSystem, AttributeId, EntityId, [Order], [Value], [Guid]) VALUES (0, @MinGradeId, @GroupId, 0, '2', NEWID())
INSERT INTO [AttributeValue] (IsSystem, AttributeId, EntityId, [Order], [Value], [Guid]) VALUES (0, @MaxGradeId, @GroupId, 0, '2', NEWID())

INSERT INTO [Group] ( [IsSystem],[ParentGroupId], [GroupTypeId], [CampusId], [Name],[IsSecurityRole],[IsActive],[Guid]) 
SELECT 0, @ParentGroupId, @ElementaryTypeId, @CampusID, 'Jump Street - 3rd', 0, 1, NEWID() 
SET @GroupId = SCOPE_IDENTITY()
INSERT INTO [AttributeValue] (IsSystem, AttributeId, EntityId, [Order], [Value], [Guid]) VALUES (0, @MinAgeId, @GroupId, 0, '8.00', NEWID())
INSERT INTO [AttributeValue] (IsSystem, AttributeId, EntityId, [Order], [Value], [Guid]) VALUES (0, @MaxAgeId, @GroupId, 0, '9.99', NEWID())
INSERT INTO [AttributeValue] (IsSystem, AttributeId, EntityId, [Order], [Value], [Guid]) VALUES (0, @MinGradeId, @GroupId, 0, '3', NEWID())
INSERT INTO [AttributeValue] (IsSystem, AttributeId, EntityId, [Order], [Value], [Guid]) VALUES (0, @MaxGradeId, @GroupId, 0, '3', NEWID())

INSERT INTO [Group] ( [IsSystem],[ParentGroupId], [GroupTypeId], [CampusId], [Name],[IsSecurityRole],[IsActive],[Guid]) 
SELECT 0, @ParentGroupId, @ElementaryTypeId, @CampusID, 'Shockwave - 4th', 0, 1, NEWID() 
SET @GroupId = SCOPE_IDENTITY()
INSERT INTO [AttributeValue] (IsSystem, AttributeId, EntityId, [Order], [Value], [Guid]) VALUES (0, @MinAgeId, @GroupId, 0, '9.00', NEWID())
INSERT INTO [AttributeValue] (IsSystem, AttributeId, EntityId, [Order], [Value], [Guid]) VALUES (0, @MaxAgeId, @GroupId, 0, '10.99', NEWID())
INSERT INTO [AttributeValue] (IsSystem, AttributeId, EntityId, [Order], [Value], [Guid]) VALUES (0, @MinGradeId, @GroupId, 0, '4', NEWID())
INSERT INTO [AttributeValue] (IsSystem, AttributeId, EntityId, [Order], [Value], [Guid]) VALUES (0, @MaxGradeId, @GroupId, 0, '4', NEWID())

INSERT INTO [Group] ( [IsSystem],[ParentGroupId], [GroupTypeId], [CampusId], [Name],[IsSecurityRole],[IsActive],[Guid]) 
SELECT 0, @ParentGroupId, @ElementaryTypeId, @CampusID, 'Shockwave - 5th', 0, 1, NEWID() 
SET @GroupId = SCOPE_IDENTITY()
INSERT INTO [AttributeValue] (IsSystem, AttributeId, EntityId, [Order], [Value], [Guid]) VALUES (0, @MinAgeId, @GroupId, 0, '10.00', NEWID())
INSERT INTO [AttributeValue] (IsSystem, AttributeId, EntityId, [Order], [Value], [Guid]) VALUES (0, @MaxAgeId, @GroupId, 0, '11.99', NEWID())
INSERT INTO [AttributeValue] (IsSystem, AttributeId, EntityId, [Order], [Value], [Guid]) VALUES (0, @MinGradeId, @GroupId, 0, '5', NEWID())
INSERT INTO [AttributeValue] (IsSystem, AttributeId, EntityId, [Order], [Value], [Guid]) VALUES (0, @MaxGradeId, @GroupId, 0, '5', NEWID())


-- Rich's stuff
--INSERT INTO [Group] ( [IsSystem],[GroupTypeId],[Name],[IsSecurityRole],[IsActive],[Guid]) 
--SELECT 0, GT.Id, 'Discipleship', 0, 1, NEWID() FROM [GroupType] GT WHERE GT.Name = 'Discipleship'
--SET @ParentGroupId = SCOPE_IDENTITY()
--INSERT INTO [Group] ( [IsSystem],[ParentGroupId],[GroupTypeId],[Name],[IsSecurityRole],[IsActive],[Guid]) 
--SELECT 0, @ParentGroupId, GT.Id, 'Attendee', 0, 1, NEWID() FROM [GroupType] GT WHERE GT.Name = 'Attendee'
--SET @GroupId = SCOPE_IDENTITY()
--INSERT INTO [Group] ( [IsSystem],[ParentGroupId],[GroupTypeId],[Name],[IsSecurityRole],[IsActive],[Guid]) 
--SELECT 0, @GroupId, GT.Id, 'Baptism Attendee', 0, 1, NEWID() FROM [GroupType] GT WHERE GT.Name = 'Baptism Attendee'
--INSERT INTO [Group] ( [IsSystem],[ParentGroupId],[GroupTypeId],[Name],[IsSecurityRole],[IsActive],[Guid]) 
--SELECT 0, @ParentGroupId, GT.Id, 'Volunteer', 0, 1, NEWID() FROM [GroupType] GT WHERE GT.Name = 'Volunteer'
--SET @GroupId = SCOPE_IDENTITY()
--INSERT INTO [Group] ( [IsSystem],[ParentGroupId],[GroupTypeId],[Name],[IsSecurityRole],[IsActive],[Guid]) 
--SELECT 0, @GroupId, GT.Id, 'Volunteer', 0, 1, NEWID() FROM [GroupType] GT WHERE GT.Name = 'Volunteer'


-- Fuse
INSERT INTO [Group] ( [IsSystem],[ParentGroupId], [GroupTypeId], [CampusId], [Name],[IsSecurityRole],[IsActive],[Guid]) 
SELECT 0, NULL, @FuseTypeId, @CampusID, 'Fuse', 0, 1, NEWID() 
SET @TopLevelGroupId = SCOPE_IDENTITY()

-- Middle School Groups
INSERT INTO [Group] ( [IsSystem],[ParentGroupId], [GroupTypeId], [CampusId], [Name],[IsSecurityRole],[IsActive],[Guid]) 
SELECT 0, @TopLevelGroupId, @MSTypeId, @CampusID, 'Middle School', 0, 1, NEWID() 
SET @ParentGroupId = SCOPE_IDENTITY()
INSERT INTO [AttributeValue] (IsSystem, AttributeId, EntityId, [Order], [Value], [Guid]) VALUES (0, @MinAgeId, @ParentGroupId, 0, '11.00', NEWID())
INSERT INTO [AttributeValue] (IsSystem, AttributeId, EntityId, [Order], [Value], [Guid]) VALUES (0, @MaxAgeId, @ParentGroupId, 0, '14.99', NEWID())
INSERT INTO [AttributeValue] (IsSystem, AttributeId, EntityId, [Order], [Value], [Guid]) VALUES (0, @MinGradeId, @ParentGroupId, 0, '6', NEWID())
INSERT INTO [AttributeValue] (IsSystem, AttributeId, EntityId, [Order], [Value], [Guid]) VALUES (0, @MaxGradeId, @ParentGroupId, 0, '8', NEWID())

INSERT INTO [Group] ( [IsSystem],[ParentGroupId], [GroupTypeId], [CampusId], [Name],[IsSecurityRole],[IsActive],[Guid]) 
SELECT 0, @ParentGroupId, @MSTypeId, @CampusID, '6th Grade Boy', 0, 1, NEWID() 
SET @GroupId = SCOPE_IDENTITY()
INSERT INTO [AttributeValue] (IsSystem, AttributeId, EntityId, [Order], [Value], [Guid]) VALUES (0, @MinAgeId, @GroupId, 0, '11.00', NEWID())
INSERT INTO [AttributeValue] (IsSystem, AttributeId, EntityId, [Order], [Value], [Guid]) VALUES (0, @MaxAgeId, @GroupId, 0, '12.99', NEWID())
INSERT INTO [AttributeValue] (IsSystem, AttributeId, EntityId, [Order], [Value], [Guid]) VALUES (0, @MinGradeId, @GroupId, 0, '6', NEWID())
INSERT INTO [AttributeValue] (IsSystem, AttributeId, EntityId, [Order], [Value], [Guid]) VALUES (0, @MaxGradeId, @GroupId, 0, '6', NEWID())
INSERT INTO [AttributeValue] (IsSystem, AttributeId, EntityId, [Order], [Value], [Guid]) VALUES (0, @GenderId, @GroupId, 0, '1', NEWID())

INSERT INTO [Group] ( [IsSystem],[ParentGroupId], [GroupTypeId], [CampusId], [Name],[IsSecurityRole],[IsActive],[Guid]) 
SELECT 0, @ParentGroupId, @MSTypeId, @CampusID, '6th Grade Girl', 0, 1, NEWID() 
SET @GroupId = SCOPE_IDENTITY()
INSERT INTO [AttributeValue] (IsSystem, AttributeId, EntityId, [Order], [Value], [Guid]) VALUES (0, @MinAgeId, @GroupId, 0, '11.00', NEWID())
INSERT INTO [AttributeValue] (IsSystem, AttributeId, EntityId, [Order], [Value], [Guid]) VALUES (0, @MaxAgeId, @GroupId, 0, '12.99', NEWID())
INSERT INTO [AttributeValue] (IsSystem, AttributeId, EntityId, [Order], [Value], [Guid]) VALUES (0, @MinGradeId, @GroupId, 0, '6', NEWID())
INSERT INTO [AttributeValue] (IsSystem, AttributeId, EntityId, [Order], [Value], [Guid]) VALUES (0, @MaxGradeId, @GroupId, 0, '6', NEWID())
INSERT INTO [AttributeValue] (IsSystem, AttributeId, EntityId, [Order], [Value], [Guid]) VALUES (0, @GenderId, @GroupId, 0, '2', NEWID())


INSERT INTO [Group] ( [IsSystem],[ParentGroupId], [GroupTypeId], [CampusId], [Name],[IsSecurityRole],[IsActive],[Guid]) 
SELECT 0, @ParentGroupId, @MSTypeId, @CampusID, '7th Grade Boy', 0, 1, NEWID() 
SET @GroupId = SCOPE_IDENTITY()
INSERT INTO [AttributeValue] (IsSystem, AttributeId, EntityId, [Order], [Value], [Guid]) VALUES (0, @MinAgeId, @GroupId, 0, '12.00', NEWID())
INSERT INTO [AttributeValue] (IsSystem, AttributeId, EntityId, [Order], [Value], [Guid]) VALUES (0, @MaxAgeId, @GroupId, 0, '13.99', NEWID())
INSERT INTO [AttributeValue] (IsSystem, AttributeId, EntityId, [Order], [Value], [Guid]) VALUES (0, @MinGradeId, @GroupId, 0, '7', NEWID())
INSERT INTO [AttributeValue] (IsSystem, AttributeId, EntityId, [Order], [Value], [Guid]) VALUES (0, @MaxGradeId, @GroupId, 0, '7', NEWID())
INSERT INTO [AttributeValue] (IsSystem, AttributeId, EntityId, [Order], [Value], [Guid]) VALUES (0, @GenderId, @GroupId, 0, '1', NEWID())

INSERT INTO [Group] ( [IsSystem],[ParentGroupId], [GroupTypeId], [CampusId], [Name],[IsSecurityRole],[IsActive],[Guid]) 
SELECT 0, @ParentGroupId, @MSTypeId, @CampusID, '7th Grade Girl', 0, 1, NEWID() 
SET @GroupId = SCOPE_IDENTITY()
INSERT INTO [AttributeValue] (IsSystem, AttributeId, EntityId, [Order], [Value], [Guid]) VALUES (0, @MinAgeId, @GroupId, 0, '12.00', NEWID())
INSERT INTO [AttributeValue] (IsSystem, AttributeId, EntityId, [Order], [Value], [Guid]) VALUES (0, @MaxAgeId, @GroupId, 0, '13.99', NEWID())
INSERT INTO [AttributeValue] (IsSystem, AttributeId, EntityId, [Order], [Value], [Guid]) VALUES (0, @MinGradeId, @GroupId, 0, '7', NEWID())
INSERT INTO [AttributeValue] (IsSystem, AttributeId, EntityId, [Order], [Value], [Guid]) VALUES (0, @MaxGradeId, @GroupId, 0, '7', NEWID())
INSERT INTO [AttributeValue] (IsSystem, AttributeId, EntityId, [Order], [Value], [Guid]) VALUES (0, @GenderId, @GroupId, 0, '2', NEWID())

INSERT INTO [Group] ( [IsSystem],[ParentGroupId], [GroupTypeId], [CampusId], [Name],[IsSecurityRole],[IsActive],[Guid]) 
SELECT 0, @ParentGroupId, @MSTypeId, @CampusID, '8th Grade Boy', 0, 1, NEWID() 
SET @GroupId = SCOPE_IDENTITY()
INSERT INTO [AttributeValue] (IsSystem, AttributeId, EntityId, [Order], [Value], [Guid]) VALUES (0, @MinAgeId, @GroupId, 0, '13.00', NEWID())
INSERT INTO [AttributeValue] (IsSystem, AttributeId, EntityId, [Order], [Value], [Guid]) VALUES (0, @MaxAgeId, @GroupId, 0, '14.99', NEWID())
INSERT INTO [AttributeValue] (IsSystem, AttributeId, EntityId, [Order], [Value], [Guid]) VALUES (0, @MinGradeId, @GroupId, 0, '8', NEWID())
INSERT INTO [AttributeValue] (IsSystem, AttributeId, EntityId, [Order], [Value], [Guid]) VALUES (0, @MaxGradeId, @GroupId, 0, '8', NEWID())
INSERT INTO [AttributeValue] (IsSystem, AttributeId, EntityId, [Order], [Value], [Guid]) VALUES (0, @GenderId, @GroupId, 0, '1', NEWID())

INSERT INTO [Group] ( [IsSystem],[ParentGroupId], [GroupTypeId], [CampusId], [Name],[IsSecurityRole],[IsActive],[Guid]) 
SELECT 0, @ParentGroupId, @MSTypeId, @CampusID, '8th Grade Girl', 0, 1, NEWID() 
SET @GroupId = SCOPE_IDENTITY()
INSERT INTO [AttributeValue] (IsSystem, AttributeId, EntityId, [Order], [Value], [Guid]) VALUES (0, @MinAgeId, @GroupId, 0, '13.00', NEWID())
INSERT INTO [AttributeValue] (IsSystem, AttributeId, EntityId, [Order], [Value], [Guid]) VALUES (0, @MaxAgeId, @GroupId, 0, '14.99', NEWID())
INSERT INTO [AttributeValue] (IsSystem, AttributeId, EntityId, [Order], [Value], [Guid]) VALUES (0, @MinGradeId, @GroupId, 0, '8', NEWID())
INSERT INTO [AttributeValue] (IsSystem, AttributeId, EntityId, [Order], [Value], [Guid]) VALUES (0, @MaxGradeId, @GroupId, 0, '8', NEWID())
INSERT INTO [AttributeValue] (IsSystem, AttributeId, EntityId, [Order], [Value], [Guid]) VALUES (0, @GenderId, @GroupId, 0, '2', NEWID())


-- High School Groups
INSERT INTO [Group] ( [IsSystem],[ParentGroupId], [GroupTypeId], [CampusId], [Name],[IsSecurityRole],[IsActive],[Guid]) 
SELECT 0, @TopLevelGroupId, @HSTypeId, @CampusID, 'High School', 0, 1, NEWID() 
SET @ParentGroupId = SCOPE_IDENTITY()
INSERT INTO [AttributeValue] (IsSystem, AttributeId, EntityId, [Order], [Value], [Guid]) VALUES (0, @MinAgeId, @ParentGroupId, 0, '14.00', NEWID())
INSERT INTO [AttributeValue] (IsSystem, AttributeId, EntityId, [Order], [Value], [Guid]) VALUES (0, @MaxAgeId, @ParentGroupId, 0, '19.99', NEWID())
INSERT INTO [AttributeValue] (IsSystem, AttributeId, EntityId, [Order], [Value], [Guid]) VALUES (0, @MinGradeId, @ParentGroupId, 0, '9', NEWID())
INSERT INTO [AttributeValue] (IsSystem, AttributeId, EntityId, [Order], [Value], [Guid]) VALUES (0, @MaxGradeId, @ParentGroupId, 0, '12', NEWID())

INSERT INTO [Group] ( [IsSystem],[ParentGroupId], [GroupTypeId], [CampusId], [Name],[IsSecurityRole],[IsActive],[Guid]) 
SELECT 0, @ParentGroupId, @HSTypeId, @CampusID, '9th Grade Boy', 0, 1, NEWID() 
SET @GroupId = SCOPE_IDENTITY()
INSERT INTO [AttributeValue] (IsSystem, AttributeId, EntityId, [Order], [Value], [Guid]) VALUES (0, @MinAgeId, @GroupId, 0, '14.00', NEWID())
INSERT INTO [AttributeValue] (IsSystem, AttributeId, EntityId, [Order], [Value], [Guid]) VALUES (0, @MaxAgeId, @GroupId, 0, '15.99', NEWID())
INSERT INTO [AttributeValue] (IsSystem, AttributeId, EntityId, [Order], [Value], [Guid]) VALUES (0, @MinGradeId, @GroupId, 0, '9', NEWID())
INSERT INTO [AttributeValue] (IsSystem, AttributeId, EntityId, [Order], [Value], [Guid]) VALUES (0, @MaxGradeId, @GroupId, 0, '9', NEWID())
INSERT INTO [AttributeValue] (IsSystem, AttributeId, EntityId, [Order], [Value], [Guid]) VALUES (0, @GenderId, @GroupId, 0, '1', NEWID())

INSERT INTO [Group] ( [IsSystem],[ParentGroupId], [GroupTypeId], [CampusId], [Name],[IsSecurityRole],[IsActive],[Guid]) 
SELECT 0, @ParentGroupId, @HSTypeId, @CampusID, '9th Grade Girl', 0, 1, NEWID() 
SET @GroupId = SCOPE_IDENTITY()
INSERT INTO [AttributeValue] (IsSystem, AttributeId, EntityId, [Order], [Value], [Guid]) VALUES (0, @MinAgeId, @GroupId, 0, '14.00', NEWID())
INSERT INTO [AttributeValue] (IsSystem, AttributeId, EntityId, [Order], [Value], [Guid]) VALUES (0, @MaxAgeId, @GroupId, 0, '15.99', NEWID())
INSERT INTO [AttributeValue] (IsSystem, AttributeId, EntityId, [Order], [Value], [Guid]) VALUES (0, @MinGradeId, @GroupId, 0, '9', NEWID())
INSERT INTO [AttributeValue] (IsSystem, AttributeId, EntityId, [Order], [Value], [Guid]) VALUES (0, @MaxGradeId, @GroupId, 0, '9', NEWID())
INSERT INTO [AttributeValue] (IsSystem, AttributeId, EntityId, [Order], [Value], [Guid]) VALUES (0, @GenderId, @GroupId, 0, '2', NEWID())

INSERT INTO [Group] ( [IsSystem],[ParentGroupId], [GroupTypeId], [CampusId], [Name],[IsSecurityRole],[IsActive],[Guid]) 
SELECT 0, @ParentGroupId, @HSTypeId, @CampusID, '10th Grade Boy', 0, 1, NEWID() 
INSERT INTO [AttributeValue] (IsSystem, AttributeId, EntityId, [Order], [Value], [Guid]) VALUES (0, @MinAgeId, @GroupId, 0, '15.00', NEWID())
INSERT INTO [AttributeValue] (IsSystem, AttributeId, EntityId, [Order], [Value], [Guid]) VALUES (0, @MaxAgeId, @GroupId, 0, '16.99', NEWID())
INSERT INTO [AttributeValue] (IsSystem, AttributeId, EntityId, [Order], [Value], [Guid]) VALUES (0, @MinGradeId, @GroupId, 0, '10', NEWID())
INSERT INTO [AttributeValue] (IsSystem, AttributeId, EntityId, [Order], [Value], [Guid]) VALUES (0, @MaxGradeId, @GroupId, 0, '10', NEWID())
INSERT INTO [AttributeValue] (IsSystem, AttributeId, EntityId, [Order], [Value], [Guid]) VALUES (0, @GenderId, @GroupId, 0, '1', NEWID())

INSERT INTO [Group] ( [IsSystem],[ParentGroupId], [GroupTypeId], [CampusId], [Name],[IsSecurityRole],[IsActive],[Guid]) 
SELECT 0, @ParentGroupId, @HSTypeId, @CampusID, '10th Grade Girl', 0, 1, NEWID() 
INSERT INTO [AttributeValue] (IsSystem, AttributeId, EntityId, [Order], [Value], [Guid]) VALUES (0, @MinAgeId, @GroupId, 0, '15.00', NEWID())
INSERT INTO [AttributeValue] (IsSystem, AttributeId, EntityId, [Order], [Value], [Guid]) VALUES (0, @MaxAgeId, @GroupId, 0, '16.99', NEWID())
INSERT INTO [AttributeValue] (IsSystem, AttributeId, EntityId, [Order], [Value], [Guid]) VALUES (0, @MinGradeId, @GroupId, 0, '10', NEWID())
INSERT INTO [AttributeValue] (IsSystem, AttributeId, EntityId, [Order], [Value], [Guid]) VALUES (0, @MaxGradeId, @GroupId, 0, '10', NEWID())
INSERT INTO [AttributeValue] (IsSystem, AttributeId, EntityId, [Order], [Value], [Guid]) VALUES (0, @GenderId, @GroupId, 0, '2', NEWID())

INSERT INTO [Group] ( [IsSystem],[ParentGroupId], [GroupTypeId], [CampusId], [Name],[IsSecurityRole],[IsActive],[Guid]) 
SELECT 0, @ParentGroupId, @HSTypeId, @CampusID, '11th Grade Boy', 0, 1, NEWID() 
INSERT INTO [AttributeValue] (IsSystem, AttributeId, EntityId, [Order], [Value], [Guid]) VALUES (0, @MinAgeId, @GroupId, 0, '16.00', NEWID())
INSERT INTO [AttributeValue] (IsSystem, AttributeId, EntityId, [Order], [Value], [Guid]) VALUES (0, @MaxAgeId, @GroupId, 0, '17.99', NEWID())
INSERT INTO [AttributeValue] (IsSystem, AttributeId, EntityId, [Order], [Value], [Guid]) VALUES (0, @MinGradeId, @GroupId, 0, '11', NEWID())
INSERT INTO [AttributeValue] (IsSystem, AttributeId, EntityId, [Order], [Value], [Guid]) VALUES (0, @MaxGradeId, @GroupId, 0, '11', NEWID())
INSERT INTO [AttributeValue] (IsSystem, AttributeId, EntityId, [Order], [Value], [Guid]) VALUES (0, @GenderId, @GroupId, 0, '1', NEWID())

INSERT INTO [Group] ( [IsSystem],[ParentGroupId], [GroupTypeId], [CampusId], [Name],[IsSecurityRole],[IsActive],[Guid]) 
SELECT 0, @ParentGroupId, @HSTypeId, @CampusID, '11th Grade Girl', 0, 1, NEWID() 
INSERT INTO [AttributeValue] (IsSystem, AttributeId, EntityId, [Order], [Value], [Guid]) VALUES (0, @MinAgeId, @GroupId, 0, '16.00', NEWID())
INSERT INTO [AttributeValue] (IsSystem, AttributeId, EntityId, [Order], [Value], [Guid]) VALUES (0, @MaxAgeId, @GroupId, 0, '17.99', NEWID())
INSERT INTO [AttributeValue] (IsSystem, AttributeId, EntityId, [Order], [Value], [Guid]) VALUES (0, @MinGradeId, @GroupId, 0, '11', NEWID())
INSERT INTO [AttributeValue] (IsSystem, AttributeId, EntityId, [Order], [Value], [Guid]) VALUES (0, @MaxGradeId, @GroupId, 0, '11', NEWID())
INSERT INTO [AttributeValue] (IsSystem, AttributeId, EntityId, [Order], [Value], [Guid]) VALUES (0, @GenderId, @GroupId, 0, '2', NEWID())

INSERT INTO [Group] ( [IsSystem],[ParentGroupId], [GroupTypeId], [CampusId], [Name],[IsSecurityRole],[IsActive],[Guid]) 
SELECT 0, @ParentGroupId, @HSTypeId, @CampusID, '12th Grade Boy', 0, 1, NEWID() 
INSERT INTO [AttributeValue] (IsSystem, AttributeId, EntityId, [Order], [Value], [Guid]) VALUES (0, @MinAgeId, @GroupId, 0, '17.00', NEWID())
INSERT INTO [AttributeValue] (IsSystem, AttributeId, EntityId, [Order], [Value], [Guid]) VALUES (0, @MaxAgeId, @GroupId, 0, '19.99', NEWID())
INSERT INTO [AttributeValue] (IsSystem, AttributeId, EntityId, [Order], [Value], [Guid]) VALUES (0, @MinGradeId, @GroupId, 0, '12', NEWID())
INSERT INTO [AttributeValue] (IsSystem, AttributeId, EntityId, [Order], [Value], [Guid]) VALUES (0, @MaxGradeId, @GroupId, 0, '12', NEWID())
INSERT INTO [AttributeValue] (IsSystem, AttributeId, EntityId, [Order], [Value], [Guid]) VALUES (0, @GenderId, @GroupId, 0, '1', NEWID())

INSERT INTO [Group] ( [IsSystem],[ParentGroupId], [GroupTypeId], [CampusId], [Name],[IsSecurityRole],[IsActive],[Guid]) 
SELECT 0, @ParentGroupId, @HSTypeId, @CampusID, '12th Grade Girl', 0, 1, NEWID() 
INSERT INTO [AttributeValue] (IsSystem, AttributeId, EntityId, [Order], [Value], [Guid]) VALUES (0, @MinAgeId, @GroupId, 0, '17.00', NEWID())
INSERT INTO [AttributeValue] (IsSystem, AttributeId, EntityId, [Order], [Value], [Guid]) VALUES (0, @MaxAgeId, @GroupId, 0, '19.99', NEWID())
INSERT INTO [AttributeValue] (IsSystem, AttributeId, EntityId, [Order], [Value], [Guid]) VALUES (0, @MinGradeId, @GroupId, 0, '12', NEWID())
INSERT INTO [AttributeValue] (IsSystem, AttributeId, EntityId, [Order], [Value], [Guid]) VALUES (0, @MaxGradeId, @GroupId, 0, '12', NEWID())
INSERT INTO [AttributeValue] (IsSystem, AttributeId, EntityId, [Order], [Value], [Guid]) VALUES (0, @GenderId, @GroupId, 0, '2', NEWID())

-- Guest Services
--INSERT INTO [Group] ( [IsSystem],[ParentGroupId], [GroupTypeId], [CampusId], [Name],[IsSecurityRole],[IsActive],[Guid]) 
--SELECT 0, NULL, @GSTypeId, @CampusID, 'Volunteers', 0, 1, NEWID() 
--SET @TopLevelGroupId = SCOPE_IDENTITY()

-- Creativity/Technology
--INSERT INTO [Group] ( [IsSystem],[ParentGroupId], [GroupTypeId], [CampusId], [Name],[IsSecurityRole],[IsActive],[Guid]) 
--SELECT 0, NULL, @CTTypeId, @CampusID, 'Creativity/Technology', 0, 1, NEWID() 
--SET @TopLevelGroupId = SCOPE_IDENTITY()

------------------------------------------------------------------------
-- Create Schedules
------------------------------------------------------------------------
DELETE [Schedule]
INSERT INTO [Schedule] ([Name],[iCalendarContent],[CheckInStartOffsetMinutes],[CheckInEndOffsetMinutes],[EffectiveStartDate],[Guid]) VALUES 
    ('9:15 AM',
'BEGIN:VCALENDAR
BEGIN:VEVENT
DTEND:20130701T235900
DTSTART:20130625T000000
RRULE:FREQ=DAILY
END:VEVENT
END:VCALENDAR', '0', '1439', '06/01/2013', NEWID() )
INSERT INTO [Schedule] ([Name],[iCalendarContent], [CheckInStartOffsetMinutes],[CheckInEndOffsetMinutes],[EffectiveStartDate],[Guid]) VALUES 
    ('11:15 AM', 
'BEGIN:VCALENDAR
BEGIN:VEVENT
DTEND:20130701T235900
DTSTART:20130625T000000
RRULE:FREQ=DAILY
END:VEVENT
END:VCALENDAR', '0', '1439', '06/01/2013', NEWID() )
INSERT INTO [Schedule] ([Name],[iCalendarContent], [CheckInStartOffsetMinutes],[CheckInEndOffsetMinutes],[EffectiveStartDate],[Guid]) VALUES 
    ('4:00 PM', 
'BEGIN:VCALENDAR
BEGIN:VEVENT
DTEND:20130701T235900
DTSTART:20130625T000000
RRULE:FREQ=DAILY
END:VEVENT
END:VCALENDAR', '0', '1439', '06/01/2013', NEWID() )
INSERT INTO [Schedule] ([Name],[iCalendarContent], [CheckInStartOffsetMinutes],[CheckInEndOffsetMinutes],[EffectiveStartDate],[Guid]) VALUES 
    ('6:00 PM', 
'BEGIN:VCALENDAR
BEGIN:VEVENT
DTEND:20130701T235900
DTSTART:20130625T000000
RRULE:FREQ=DAILY
END:VEVENT
END:VCALENDAR', '0', '1439', '06/01/2013', NEWID() )

------------------------------------------------------------------------
-- Create Locations
------------------------------------------------------------------------
DECLARE @KioskLocationId int
DECLARE @RoomLocationId int

-- Anderson Locations
--INSERT INTO [Location] ([ParentLocationId], [Name], [IsActive], [Guid])	
--VALUES (@CampusLocationId, 'West Building', 1, NEWID())
--SET @KioskLocationId = SCOPE_IDENTITY()

-- Don't make a distinction between buildings, use the campus as a parent
SET @KioskLocationId = @CampusLocationId

-- KidSpring rooms
INSERT INTO [Location] ([ParentLocationId], [Name], [IsActive], [Guid]) VALUES (@KioskLocationId, 'Wonder Way - 1', 1, NEWID())
INSERT INTO [Location] ([ParentLocationId], [Name], [IsActive], [Guid]) VALUES (@KioskLocationId, 'Wonder Way - 2', 1, NEWID())
INSERT INTO [Location] ([ParentLocationId], [Name], [IsActive], [Guid]) VALUES (@KioskLocationId, 'Wonder Way - 3', 1, NEWID())
INSERT INTO [Location] ([ParentLocationId], [Name], [IsActive], [Guid]) VALUES (@KioskLocationId, 'Wonder Way - 4', 1, NEWID())
INSERT INTO [Location] ([ParentLocationId], [Name], [IsActive], [Guid]) VALUES (@KioskLocationId, 'Wonder Way - 5', 1, NEWID())
INSERT INTO [Location] ([ParentLocationId], [Name], [IsActive], [Guid]) VALUES (@KioskLocationId, 'Wonder Way - 6', 1, NEWID())
INSERT INTO [Location] ([ParentLocationId], [Name], [IsActive], [Guid]) VALUES (@KioskLocationId, 'Wonder Way - 7', 1, NEWID())
INSERT INTO [Location] ([ParentLocationId], [Name], [IsActive], [Guid]) VALUES (@KioskLocationId, 'Wonder Way - 8', 1, NEWID())
INSERT INTO [Location] ([ParentLocationId], [Name], [IsActive], [Guid]) VALUES (@KioskLocationId, 'Fire Station', 1, NEWID())
INSERT INTO [Location] ([ParentLocationId], [Name], [IsActive], [Guid]) VALUES (@KioskLocationId, 'Lil'' Spring', 1, NEWID())
INSERT INTO [Location] ([ParentLocationId], [Name], [IsActive], [Guid]) VALUES (@KioskLocationId, 'Pop''s Garage', 1, NEWID())
INSERT INTO [Location] ([ParentLocationId], [Name], [IsActive], [Guid]) VALUES (@KioskLocationId, 'Spring Fresh', 1, NEWID())
INSERT INTO [Location] ([ParentLocationId], [Name], [IsActive], [Guid]) VALUES (@KioskLocationId, 'SpringTown Police', 1, NEWID())
INSERT INTO [Location] ([ParentLocationId], [Name], [IsActive], [Guid]) VALUES (@KioskLocationId, 'SpringTown Toys', 1, NEWID())
INSERT INTO [Location] ([ParentLocationId], [Name], [IsActive], [Guid]) VALUES (@KioskLocationId, 'Treehouse', 1, NEWID())
INSERT INTO [Location] ([ParentLocationId], [Name], [IsActive], [Guid]) VALUES (@KioskLocationId, 'Base Camp Jr.', 1, NEWID())
INSERT INTO [Location] ([ParentLocationId], [Name], [IsActive], [Guid]) VALUES (@KioskLocationId, 'Base Camp (ES)', 1, NEWID())
INSERT INTO [Location] ([ParentLocationId], [Name], [IsActive], [Guid]) VALUES (@KioskLocationId, 'ImagiNation - K', 1, NEWID())
INSERT INTO [Location] ([ParentLocationId], [Name], [IsActive], [Guid]) VALUES (@KioskLocationId, 'ImagiNation - 1st', 1, NEWID())
INSERT INTO [Location] ([ParentLocationId], [Name], [IsActive], [Guid]) VALUES (@KioskLocationId, 'Jump Street - 2nd', 1, NEWID())
INSERT INTO [Location] ([ParentLocationId], [Name], [IsActive], [Guid]) VALUES (@KioskLocationId, 'Jump Street - 3rd', 1, NEWID())
INSERT INTO [Location] ([ParentLocationId], [Name], [IsActive], [Guid]) VALUES (@KioskLocationId, 'Shockwave - 4th', 1, NEWID())
INSERT INTO [Location] ([ParentLocationId], [Name], [IsActive], [Guid]) VALUES (@KioskLocationId, 'Shockwave - 5th', 1, NEWID())

-- Fuse rooms
INSERT INTO [Location] ([ParentLocationId], [Name], [IsActive], [Guid]) VALUES (@KioskLocationId, '6th Grade Boy', 1, NEWID())
INSERT INTO [Location] ([ParentLocationId], [Name], [IsActive], [Guid]) VALUES (@KioskLocationId, '6th Grade Girl', 1, NEWID())
INSERT INTO [Location] ([ParentLocationId], [Name], [IsActive], [Guid]) VALUES (@KioskLocationId, '7th Grade Boy', 1, NEWID())
INSERT INTO [Location] ([ParentLocationId], [Name], [IsActive], [Guid]) VALUES (@KioskLocationId, '7th Grade Girl', 1, NEWID())
INSERT INTO [Location] ([ParentLocationId], [Name], [IsActive], [Guid]) VALUES (@KioskLocationId, '8th Grade Boy', 1, NEWID())
INSERT INTO [Location] ([ParentLocationId], [Name], [IsActive], [Guid]) VALUES (@KioskLocationId, '8th Grade Girl', 1, NEWID())
INSERT INTO [Location] ([ParentLocationId], [Name], [IsActive], [Guid]) VALUES (@KioskLocationId, '9th Grade Boy', 1, NEWID())
INSERT INTO [Location] ([ParentLocationId], [Name], [IsActive], [Guid]) VALUES (@KioskLocationId, '9th Grade Girl', 1, NEWID())
INSERT INTO [Location] ([ParentLocationId], [Name], [IsActive], [Guid]) VALUES (@KioskLocationId, '10th Grade Boy', 1, NEWID())
INSERT INTO [Location] ([ParentLocationId], [Name], [IsActive], [Guid]) VALUES (@KioskLocationId, '10th Grade Girl', 1, NEWID())
INSERT INTO [Location] ([ParentLocationId], [Name], [IsActive], [Guid]) VALUES (@KioskLocationId, '11th Grade Boy', 1, NEWID())
INSERT INTO [Location] ([ParentLocationId], [Name], [IsActive], [Guid]) VALUES (@KioskLocationId, '11th Grade Girl', 1, NEWID())
INSERT INTO [Location] ([ParentLocationId], [Name], [IsActive], [Guid]) VALUES (@KioskLocationId, '12th Grade Boy', 1, NEWID())
INSERT INTO [Location] ([ParentLocationId], [Name], [IsActive], [Guid]) VALUES (@KioskLocationId, '12th Grade Girl', 1, NEWID())

------------------------------------------------------------------------
-- Devices (Kiosks)
------------------------------------------------------------------------
DELETE [DeviceLocation]
DELETE [Device]

-- Device Types

DECLARE @DeviceTypeValueId int
SET @DeviceTypeValueId = (SELECT [Id] FROM [DefinedValue] WHERE [Guid] = 'BC809626-1389-4543-B8BB-6FAC79C27AFD')
DECLARE @PrinterTypevalueId int
SET @PrinterTypevalueId = (SELECT [Id] FROM [DefinedValue] WHERE [Guid] = '8284B128-E73B-4863-9FC2-43E6827B65E6')

DECLARE @PrinterDeviceId int
INSERT INTO [Device] ([Name],[DeviceTypeValueId],[IPAddress],[PrintFrom],[PrintToOverride],[Guid])
VALUES ('Test Printer',@PrinterTypevalueId, '10.1.20.200',0,1,NEWID())
SET @PrinterDeviceId = SCOPE_IDENTITY()

INSERT INTO [Device] ([Name],[DeviceTypeValueId],[PrinterDeviceId],[PrintFrom],[PrintToOverride],[Guid])
SELECT C.ShortCode + '-CHECK01', @DeviceTypeValueId, @PrinterDeviceId, 0, 1, NEWID()
FROM Location L
INNER JOIN Campus C
ON C.LocationId = L.ID
WHERE L.Name = 'Anderson'

INSERT INTO [Device] ([Name],[DeviceTypeValueId],[PrinterDeviceId], [IpAddress],[PrintFrom],[PrintToOverride],[Guid])
SELECT 'CEN-RDUBAY', @DeviceTypeValueId, @PrinterDeviceId, '10.0.20.82', 0, 1, NEWID()
FROM Location L WHERE L.Name = 'Anderson'

INSERT INTO [Device] ([Name],[DeviceTypeValueId],[PrinterDeviceId], [IpAddress],[PrintFrom],[PrintToOverride],[Guid])
SELECT 'CEN-DSTEVENS', @DeviceTypeValueId, @PrinterDeviceId, '10.0.20.94', 0, 1, NEWID()
FROM Location L WHERE L.Name = 'Anderson'

INSERT INTO [DeviceLocation] (DeviceId, LocationId)
SELECT D.Id, B.Id
FROM Location L
INNER JOIN Campus C
on C.LocationId = L.Id
INNER JOIN Location B
	ON B.ParentLocationId = L.Id
INNER JOIN Device D 
	ON D.Name = C.ShortCode + '-CHECK01'
WHERE L.Name = 'Anderson'

INSERT INTO [DeviceLocation] (DeviceId, LocationId)
SELECT D.Id, B.Id
FROM Location L
INNER JOIN Location B
	ON B.ParentLocationId = L.Id
INNER JOIN Device D 
	ON D.Name = 'CEN-RDUBAY'
WHERE L.Name = 'Anderson'

INSERT INTO [DeviceLocation] (DeviceId, LocationId)
SELECT D.Id, B.Id
FROM Location L
INNER JOIN Location B
	ON B.ParentLocationId = L.Id
INNER JOIN Device D 
	ON D.Name = 'CEN-DSTEVENS'
WHERE L.Name = 'Anderson'

------------------------------------------------------------------------
-- Group Locations
------------------------------------------------------------------------
-- Insert a grouplocation for each checkin room
DELETE [GroupLocation]
INSERT INTO [GroupLocation] (GroupId, LocationId, Guid) 
SELECT G.Id, L.Id, NEWID()
FROM Location L
INNER JOIN [Group] G 
ON G.Name = L.Name

------------------------------------------------------------------------
-- Group Location Schedule
------------------------------------------------------------------------
DELETE [GroupLocationSchedule]

INSERT INTO [GroupLocationSchedule] (GroupLocationId, ScheduleId) 
SELECT GL.Id, S.Id
FROM GroupLocation GL
INNER JOIN [Group] G 
ON G.Id = GL.GroupId
INNER JOIN [Group] G2
ON G.ParentGroupId = G2.Id
INNER JOIN Schedule S 
ON S.[Name] LIKE '%M'



/* ---------------------------------------------------------------------- */
------------------------------ END TEST DATA ---------------------------------
/* ---------------------------------------------------------------------- */

