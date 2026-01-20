@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'gender value help'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.resultSet.sizeCategory: #XS
define view entity zgender_cds
 as select from DDCDS_CUSTOMER_DOMAIN_VALUE_T( p_domain_name : 'ZGENDER_DOMAIN' )
{
    key domain_name, 
    key value_position,
    @Semantics.language: true
    key language,
    @ObjectModel.text.element: [ 'genderText' ]
    value_low as genderCode,
    text as genderText
}
