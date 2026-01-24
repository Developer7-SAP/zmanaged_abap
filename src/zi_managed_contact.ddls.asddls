@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'interface view for contact'
@Metadata.ignorePropagatedAnnotations: true
define root view entity zi_managed_contact as select from zcontact_managed
association[1..*] to zgender_cds as _gender
on _gender.genderCode = $projection.Gender
composition[1..*] of zi_managed_contact_add as _address
{
    
   key contact_id as ContactId,
   firstname as Firstname,
   middlename as Middlename,
   lastname as Lastname,
   gender as Gender,
   _gender.genderText as genderText,
   dob as Dob,
   age as Age,
   telephone as Telephone,
   email as Email,
   active as Active,
   createdby as Createdby,
   createdat as Createdat,
   lastchangedby as Lastchangedby,
   lastchangedat as Lastchangedat,
   _gender,
   _address
}
