@AbapCatalog.sqlViewName: 'ZIORDER_ITEM'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Order item - CDS data model'
define view ZI_ORDER_ITEM 


as select 
from zorder_item as Item

  association        to parent ZI_ORDER as _Order     on  $projection.order_uuid = _Order.order_uuid

  association [1..1] to ZI_DEVICE        as _Device   on  $projection.device_imei = _Device.IMEI
  association [1..1] to ZI_CUSTOM_PRIVATE         as _Customer_P    on  $projection.customer_id_p = _Customer_P.CustomerId

{
//zorder_item
key item_uuid,
order_uuid,
item_id,
device_imei,
customer_id_p,
service_type,
status,
claims,
end_date,
@Semantics.systemDateTime.lastChangedAt: true
last_changed_at,

case when status <> '0002' and _Order.term_days > 8 then 1
when status <> '0002' and _Order.term_days > 5  and _Order.term_days < 8 then 2
when status <> '0002' and  _Order.term_days < 5 then 3
else 0 end as criticality,


_Order,
_Device,
_Customer_P
    
}
