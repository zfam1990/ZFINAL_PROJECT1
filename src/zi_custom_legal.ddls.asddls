@AbapCatalog.sqlViewName: 'ZICUSTOM_LEGAL'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Legal customer view - CDS Data Model'

@UI: {
  headerInfo: { typeName: 'Legal customer', typeNamePlural: 'Legal customers', 
                title: { type: #STANDARD, value: 'customer_id_l' } } }
//@UI.presentationVariant: [{sortOrder: [{by: 'CustomerID', direction: #ASC }]}]

@Search.searchable: true

define view ZI_CUSTOM_LEGAL as 
select from zcustom_legal as Legal_customer

{
    //Legal_customer
     @Search.defaultSearchElement: true
     @ObjectModel.text.element: ['Name']
    key Legal_customer.customer_id_l,
    @UI: {
              lineItem:       [ { position: 10, label: 'Customer Name', importance: #HIGH } ],
              identification: [ { position: 10, label: 'Customer Name' } ],
              selectionField: [ { position: 10 } ] }
    @Search.defaultSearchElement: true
    @Search.fuzzinessThreshold: 0.7
    @Semantics.text: true
    Legal_customer.name as Name,
    Legal_customer.address as Address,
    Legal_customer.phone_number as PhoneNumber,
    Legal_customer.responsible_person as ReapPeraon
}
