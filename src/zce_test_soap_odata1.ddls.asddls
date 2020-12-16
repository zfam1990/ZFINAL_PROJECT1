@EndUserText.label: 'Custom CDS'
@ObjectModel.query.implementedBy: 'ABAP:ZCL_PROVIDER_TEST'
define custom entity ZCE_TEST_SOAP_ODATA1 {
  key product    : abap.char(10);
  price      : abap.dec(17,2);
  currency   : abap.char(5);

}
