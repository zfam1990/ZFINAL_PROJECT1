@EndUserText.label: 'Custom entity'
@ObjectModel.query.implementedBy: 'ABAP:ZCO_SOAP_API_SOAP'
define custom entity ZCE_TEST_SOAP_ODATA{

  key product_id               : abap.int4;
  name                     : abap.string(0);
  product_number           : abap.string(0);
  make_flag                : xsdboolean;
  finished_goods_flag      : xsdboolean;
  color                    : abap.string(0);
  safety_stock_level       : abap.int2;
  reorder_point            : abap.int2;
  standard_cost            : abap.string(0);
  list_price               : abap.string(0);

  size_unit_measure_code   : abap.string(0);
  weight_unit_measure_code : abap.string(0);
  weight                   : abap.string(0);
  days_to_manufacture      : abap.int4;
  product_line             : abap.string(0);
  class                    : abap.string(0);
  style                    : abap.string(0);
  product_subcategory_id   : abap.int4;
  product_model_id         : abap.int4;
  sell_start_date          : xsddatetime_z;
  sell_end_date            : xsddatetime_z;
  discontinued_date        : xsddatetime_z;
  rowguid                  : zguid;
  modified_date            : xsddatetime_z;
  
}
