@AbapCatalog.sqlViewName: 'ZISUPPLIER'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@Consumption.valueHelpDefault.fetchValues: #AUTOMATICALLY_WHEN_DISPLAYED
//@ObjectModel: { resultSet.sizeCategory: #XS } 
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Supplier view - CDS Data Model'

@Search.searchable: true

define view ZI_SUPPLIER as 
select from zsupplier as Supplier 

{
 //Supplier
 @Search.defaultSearchElement: true
 @ObjectModel.text.element: ['Name']
 key Supplier.supplier_id,
 @Search.defaultSearchElement: true
 @Search.fuzzinessThreshold: 0.8
@Semantics.text: true
@UI: {
     lineItem:       [ { importance: #HIGH } ]}
 Supplier.name as Name,
 Supplier.phone_number as PhoneNumber  
}
