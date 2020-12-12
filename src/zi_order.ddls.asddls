@AbapCatalog.sqlViewName: 'ZIORDER'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Order view - CDS data model'
define root view ZI_ORDER as 
select from zorder as Repair_order

  composition [0..*] of ZI_ORDER_ITEM as _Item

  association [0..1] to ZI_CUSTOM_LEGAL    as _Customer_L   on $projection.customer_id_l     = _Customer_L.customer_id_l
  association [0..1] to ZI_SUPPLIER  as _Supplier on $projection.supplier_id   = _Supplier.supplier_id
 


{//zorder
                                                 key order_uuid,
                                                 order_id,
                                                 customer_id_l,
                                                 delivery_type,
                                                 supplier_id,
                                                 begin_date,
                                                 @Semantics.user.createdBy: true 
    created_by,
    @Semantics.systemDateTime.createdAt: true       
    created_at,
    @Semantics.user.lastChangedBy: true    
    last_changed_by,
    @Semantics.systemDateTime.localInstanceLastChangedAt: true
    local_last_changed_at,
    @Semantics.systemDateTime.lastChangedAt: true
    last_changed_at, 
 
    dats_days_between( begin_date, cast($session.user_date as abap.dats ) ) as term_days,
   
    1 as criticality,
    _Item,
    
    
    _Customer_L
    ,    _Supplier
    
    
    
}
