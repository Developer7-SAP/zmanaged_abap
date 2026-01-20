@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'projection view of contact'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define root view entity ZC_MANAGED_CONTACT
  provider contract transactional_query
  as projection on zi_managed_contact

{
  key ContactId,
      Firstname,
      Middlename,
      Lastname,
      @ObjectModel.text.element: [ 'genderText' ]
      Gender,
      genderText,
      Dob,
      Age,
      Telephone,
      Email,
      Active,
      Createdby,
      Createdat,
      Lastchangedby,
      Lastchangedat
}
