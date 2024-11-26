
"001 - Aqui podemos criar uma classe que vai interagir com a nossa CDS.
"A annotation em seguida define a classe e o campo que vai receber a lógica do método.

@AbapCatalog.sqlViewName: 'ZV_ORDENS_CMPRS'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Dados de Ordens de Compras'
@OData.publish: true
define view ZDD_ORDENS_COMPRAS as select from zcockpit_orders
{
    key mandt as Mandt,
    key ebeln as Ebeln,
    ebelp as Ebelp,
    matnr as Matnr,
    maktx as Maktx,
    menge as Menge,
    
    @ObjectModel.virtualElement: true
    @ObjectModel.virtualElementCalculatedBy: 'ZCL_CDS'
    cast('' as abap.char(10)) as fieldtest,
    
    meins as Meins,
    peinh as Peinh,
    werks as Werks,
    lgort as Lgort,
    hashcal_exists as HashcalExists,
    ekgrp as Ekgrp,
    bukrs as Bukrs
    
}
