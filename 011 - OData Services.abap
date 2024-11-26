"--------------------------------------------------------------------------------------------------------------------------------

01 - Primeiramente foi criado uma Database Table com os campos requeridos.
A tabela foi preenchida num report no SAP_GUI com uma consulta SQL.

@EndUserText.label : 'Tabela de Compras'
@AbapCatalog.enhancementCategory : #NOT_EXTENSIBLE
@AbapCatalog.tableCategory : #TRANSPARENT
@AbapCatalog.deliveryClass : #A
@AbapCatalog.dataMaintenance : #LIMITED
define table zcockpit_orders {
  key mandt      : mandt not null;
  key ebeln      : ebeln not null;
  ebelp          : ebelp;
  matnr          : matnr;
  maktx          : maktx;
  @Semantics.quantity.unitOfMeasure : 'ekpo.meins'
  menge          : bstmg;
  meins          : meins;
  peinh          : peinh;
  werks          : ewerk;
  lgort          : lgort_d;
  hashcal_exists : ekorg;
  ekgrp          : ekgrp;
  bukrs          : bukrs;

}

02 - Após isso, foi criada uma CDS desta tabela.

@AbapCatalog.sqlViewName: 'ZV_ORDENS_CMPRS'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Dados de Ordens de Compras'
define view ZDD_ORDENS_COMPRAS as select from zcockpit_orders
{
    key mandt as Mandt,
    key ebeln as Ebeln,
    ebelp as Ebelp,
    matnr as Matnr,
    maktx as Maktx,
    menge as Menge,
    meins as Meins,
    peinh as Peinh,
    werks as Werks,
    lgort as Lgort,
    hashcal_exists as HashcalExists,
    ekgrp as Ekgrp,
    bukrs as Bukrs
}

03 - Inserir a Annotation [ @OData.publish: true ] na CDS.

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
    meins as Meins,
    peinh as Peinh,
    werks as Werks,
    lgort as Lgort,
    hashcal_exists as HashcalExists,
    ekgrp as Ekgrp,
    bukrs as Bukrs
}

04 - Um warning aparecerá no CDS dizendo que não há Serviço para CDS.
*Entre no SAP GUI >> /n/IWFND/MAINT_SERVICE
*Clicar em Inserir Serviço
*Preencher o campo Alias do Sistema com  LOCAL
*Procurar em baixo o nome do Serviço que provavelmente começa com Z
*Selecione o nome do serviço e clique no botão Inserir Serviço Selecionado
*Informe o pacote no qual o serviço será criado e aperte ok (pode criar nos arquivos temporários)
*Você pode ver o status do serviço na lista ou pode testá-lo
*Clique no Sap Gateway Client
