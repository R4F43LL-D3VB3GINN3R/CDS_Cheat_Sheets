"primeiramente foram criadas três tabelas.

"CABEÇALHO DE VENDAS

@EndUserText.label : 'Tabela de Ordens de Venda'
@AbapCatalog.enhancementCategory : #NOT_EXTENSIBLE
@AbapCatalog.tableCategory : #TRANSPARENT
@AbapCatalog.deliveryClass : #A
@AbapCatalog.dataMaintenance : #LIMITED
define table zov_cab {
  key mandt    : abap.clnt not null;
  key ovid     : abap.int4 not null;
  clienteid    : abap.int4;
  data_criacao : abap.dats;

}

"TABELA DE CLIENTES

@EndUserText.label : 'Tabela de Clientes'
@AbapCatalog.enhancementCategory : #NOT_EXTENSIBLE
@AbapCatalog.tableCategory : #TRANSPARENT
@AbapCatalog.deliveryClass : #A
@AbapCatalog.dataMaintenance : #LIMITED
define table zcliente {
  key client    : abap.clnt not null;
  key clienteid : abap.int4 not null;
  nome          : abap.char(120);

}

"TABELA DE ITEMS

@EndUserText.label : 'Tabela de Items'
@AbapCatalog.enhancementCategory : #NOT_EXTENSIBLE
@AbapCatalog.tableCategory : #TRANSPARENT
@AbapCatalog.deliveryClass : #A
@AbapCatalog.dataMaintenance : #LIMITED
define table zov_item {
  key mandt  : abap.clnt not null;
  key ovid   : abap.int4 not null;
  key posnr  : abap.numc(6) not null;
  matnr      : abap.char(18);
  maktx      : abap.char(120);
  preco_uni  : abap.dec(18,2);
  quantidade : abap.int4;

}

"CDS VIEW

@AbapCatalog.sqlViewName: 'ZV_PEDIDO'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Dados de Pedidos de Venda Associados'
define view ZDD_PEDIDO  as 
select from zov_cab     as t1
association [1..1] to zcliente as t2 on t1.clienteid = t2.clienteid
association [1..*] to zov_item as t3 on t1.ovid = t3.ovid
{
    key t1.ovid,
    t1.clienteid,
    t1.data_criacao,
    
    t2 as _cliente,
    t3 as _item
}


