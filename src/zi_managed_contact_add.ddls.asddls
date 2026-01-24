@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface view for contact add managed'
@Metadata.ignorePropagatedAnnotations: true
define view entity zi_managed_contact_add
  as select from zcontact_add
  association to parent zi_managed_contact as _contact on $projection.ContactId = _contact.ContactId
{
  key contact_id    as ContactId,
  key address_id    as AddressId,
      addr1         as Addr1,
      addr2         as Addr2,
      city          as City,
      state         as State,
      pincode       as Pincode,
      createdby     as Createdby,
      createdat     as Createdat,
      lastchangedby as Lastchangedby,
      lastchangedat as Lastchangedat,
      _contact
}
