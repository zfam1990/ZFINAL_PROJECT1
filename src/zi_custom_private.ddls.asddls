@AbapCatalog.sqlViewName: 'ZICUSTOM_PRIVATE'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Private customer - CDS Data Model'

@Search.searchable: true

define view ZI_CUSTOM_PRIVATE as 
select from zcustom_private as Private_Customer

{
 //Private_Customer
 @Search.defaultSearchElement: true
 @ObjectModel.text.element: ['LastName']
 key Private_Customer.customer_id_p as CustomerId,
 Private_Customer.first_name as FirstName,
  @Search.defaultSearchElement: true
  @Search.fuzzinessThreshold: 0.8
  @Semantics.text: true
 Private_Customer.last_name as LastName,
Private_Customer.address as Address,
 Private_Customer.phone_number as PhoneNumber   
}
