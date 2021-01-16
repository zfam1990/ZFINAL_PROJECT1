@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Order projection view'
@Metadata.allowExtensions: true

@UI: {
  headerInfo: { typeName: 'Repair Order', typeNamePlural: 'Repair Orders', 
                title: { type: #STANDARD, value: 'OrderID' } } }
@UI.presentationVariant: [{sortOrder: [{by: 'OrderId', direction: #ASC }]}]

@Search.searchable: true

define root view entity ZC_ORDER
  as projection on ZI_ORDER

{

      @UI.facet: [ { id:              'Repair_order',
                           purpose:         #STANDARD,
                           type:            #IDENTIFICATION_REFERENCE,
                           label:           'Repair order',
                           position:        10 },
                         { id:              'Item',
                           purpose:         #STANDARD,
                           type:            #LINEITEM_REFERENCE,
                           label:           'Repair item',
                           position:        20,
                           targetElement:   '_Item'},
                           { id:            'Legal_customer',
                           purpose:         #STANDARD,
                           type:            #LINEITEM_REFERENCE,
                           label:           'Legal customer',
                           position:        30,
                           targetElement:   '_Customer_L'}
]



       //ZI_ORDER
      @UI.hidden: true
  key order_uuid,
      @UI: {
              lineItem:       [ { position: 10, label: 'Order ID', importance: #HIGH } ],
              identification: [ { position: 10, label: 'Order ID' } ],
              selectionField: [ { position: 10 } ] }
      @Search.defaultSearchElement: true
      order_id         as OrderId,
      @UI: {
               lineItem:       [ { position: 20,label: 'Customer', importance: #HIGH } ],
               identification: [ { position: 20, label: 'Customer' } ],
               selectionField: [ { position: 20 } ] }
      @Consumption.valueHelpDefinition: [{ entity : {name: 'ZI_CUSTOM_LEGAL', element: 'customer_id_l'  }}]
                  
      @ObjectModel.text.element: ['CustomerName'] ----meaning?
      @Search.defaultSearchElement: true
      customer_id_l    as CustomerId,
      _Customer_L.Name as CustomerName,
      @UI: {
              lineItem:       [ { position: 30, label: 'Delivery type [S(Self)|O(Other company)]', importance: #HIGH } ],
              identification: [ { position: 30, label: 'Delivery type [S(Self)|O(Other company)]' } ],
              selectionField: [ { position: 30 } ] }
             
      
      delivery_type    as DelivertType,
      @UI: {
              lineItem:       [ { position: 40, label: 'Supplier', importance: #HIGH } ],
              identification: [ { position: 40, label: 'Supplier' } ],
              selectionField: [ { position: 40 } ] }
            
      @Consumption.valueHelpDefinition: [{ entity : {name: 'ZI_SUPPLIER', element: 'supplier_id'  } }]
      
      @ObjectModel.text.element: ['SupplierName'] ----meaning?
      @Search.defaultSearchElement: true
      //@EndUserText.label: 'Supplier'
      @Search.fuzzinessThreshold: 0.7
      supplier_id      as SupplierId,
      _Supplier.Name   as SupplierName,
      @UI: {
              lineItem:       [ { position: 50, label: 'Begin Date', importance: #MEDIUM } ],
              identification: [ { position: 50, label: 'Begin Date' } ],
              selectionField: [ { position: 50 } ] }
              
      begin_date       as BeginDate,
      
      @UI.hidden: true
      local_last_changed_at  as LastChangedAt,
      @UI.hidden: true
                     criticality,
      /* Associations */
      //ZI_ORDER
      _Customer_L,
      @Search.defaultSearchElement: true
      _Item : redirected to composition child ZC_ORDER_ITEM,
      _Supplier


}
