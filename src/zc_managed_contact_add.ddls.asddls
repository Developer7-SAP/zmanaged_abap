@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'projection view for contact address'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define view entity zc_managed_contact_add as projection on zi_managed_contact_add
{
    key ContactId,
    key AddressId,
    Addr1,
    Addr2,
    City,
    State,
    Pincode,
    Createdby,
    Createdat,
    Lastchangedby,
    Lastchangedat,
    /* Associations */
    _contact :redirected to parent ZC_MANAGED_CONTACT
}
