@AbapCatalog.sqlViewName: 'ZIDEVICE'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Device - CDS Data Model'

@Search.searchable: true

define view ZI_DEVICE as 
select from zdevice as Device

{
 //Device
 @Search.defaultSearchElement: true
 @ObjectModel.text.element: ['IMEI']
 key Device.device_imei as IMEI,
 @Search.defaultSearchElement: true
 @Search.fuzzinessThreshold: 0.8
 @Semantics.text: true
 Device.producer as Producer,
 @Search.defaultSearchElement: true
 @Search.fuzzinessThreshold: 0.8
 @Semantics.text: true
 Device.model   as Model
}
