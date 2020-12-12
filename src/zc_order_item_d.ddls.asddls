@EndUserText.label: 'Order item projection view'
@AccessControl.authorizationCheck: #NOT_REQUIRED

@UI: {
  headerInfo: { typeName: 'Order item',
                typeNamePlural: 'Order items',
                title: { type: #STANDARD, value: 'ItemId' } } }
@UI.presentationVariant: [{sortOrder: [{by: 'ItemId', direction: #ASC }]}]                

@Search.searchable: true

define view entity ZC_ORDER_ITEM_D
  as projection on ZI_ORDER_ITEM
{
      @UI.facet: [ { id:            'Item',
                     purpose:       #STANDARD,
                     type:          #IDENTIFICATION_REFERENCE,
                     label:         'Booking',
                     position:      10 }]
                 
                     
                     //ZI_ORDER_ITEM
                     @UI.hidden: true
                     key item_uuid,
                     @UI.hidden: true
                     order_uuid,
                     @UI: {
          lineItem:       [ { position: 10, label: 'Item ID', importance: #HIGH } ],
          identification: [ { position: 10, label: 'Item ID' } ]}
         
      @Search.defaultSearchElement: true
                     item_id as ItemId,
                     @UI: {
          lineItem:       [ { position: 20, label: 'Device Imei', importance: #HIGH } ],
          identification: [ { position: 20, label: 'Device Imei' } ]}
       
      @Consumption.valueHelpDefinition: [{ entity : {name: 'ZI_DEVICE', element: 'IMEI'  } }]

      //@ObjectModel.text.element: ['CustomerName'] ----meaning?
      @Search.defaultSearchElement: true
                     device_imei as IMEI,
                     @UI: {
          lineItem:       [ { position: 30, label: 'Private Customer', importance: #HIGH } ],
          identification: [ { position: 30, label: 'Private Customer' } ]}
      
      @Consumption.valueHelpDefinition: [{ entity : {name: 'ZI_CUSTOM_PRIVATE', element: 'CustomerId'  } }]

      @ObjectModel.text.element: ['CustomerName'] ----meaning?
      @Search.defaultSearchElement: true
                     customer_id_p as CustomerId,
                     _Customer_P.LastName as CustomerName,
                     @UI: {
          lineItem:       [ { position: 40, label: 'ServiceType [W(Warranty)|P(Paid)]', importance: #HIGH } ],
          identification: [ { position: 60, label: 'ServiceType [W(Warranty)|P(Paid)]' } ]}
      
                     service_type as ServiceType,
                     @UI: {
          lineItem:       [ { position: 50, criticality: 'criticality', criticalityRepresentation: #WITHOUT_ICON, label: 'Status [1(Repair)|2(Close)|3(Wait)]', importance: #MEDIUM }, 
                            { type: #FOR_ACTION, dataAction: 'CloseItem', label: 'Give Out Item' } ],
          identification: [ { position: 70, label: 'Status [1(Repair)|2(Close)|3(Wait)]' } ]}
          

                     status as Status,
                     @UI: {
          lineItem:       [ { position: 50, label: 'Claims', importance: #HIGH } ],
          identification: [ { position: 80, label: 'Claims' } ]}
        
                     claims as Claims,
                     @UI: {
          lineItem:       [ { position: 60, label: 'BeginDate', importance: #HIGH } ],
          identification: [ { position: 90, label: 'BeginDate' } ]}
       
                     _Order.begin_date as BeginDate,
                     @UI: {
          lineItem:       [ { position: 70, label: 'EndDate', importance: #HIGH } ],
          identification: [ { position: 100, label: 'EndDate' } ]}
          
                     end_date as EndDate,
                     @UI.hidden: true
                     last_changed_at as LastChangedAt,
                     
                     @UI.identification: [ { position: 40, label: 'Device Producer' } ]
                     _Device.Producer,
                     
                     @UI.identification: [ { position: 50, label: 'Device Model' } ]
                     _Device.Model,
                     @UI.hidden: true
                     criticality,
                     
                     
                     /* Associations */
                     //ZI_ORDER_ITEM
                     _Customer_P,
                     _Device
                     
                     ,_Order: redirected to parent ZC_ORDER_D
                
     
     }                
