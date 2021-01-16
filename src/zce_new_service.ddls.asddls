@EndUserText.label: 'Custom entity for new service'
//@ObjectModel.query.implementedBy: 'ABAP:ZCL_NEW_SERVICE'



//@Search.searchable: true
define custom entity ZCE_NEW_SERVICE
{
  key BusinessPartner              : abap.char( 10 );
      BusinessPartnerName          : abap.char( 81 );
      BusinessPartnerIDByExtSystem : abap.char( 20 );


      name                         : abap.string(0);

}
