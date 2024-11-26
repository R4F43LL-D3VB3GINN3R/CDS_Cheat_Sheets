"001 - Database Table
"Com mudança no Annotation #ALLOWED para permitir mudanças na SE16

@EndUserText.label : 'Tabela de  Chamados'
@AbapCatalog.enhancementCategory : #NOT_EXTENSIBLE
@AbapCatalog.tableCategory : #TRANSPARENT
@AbapCatalog.deliveryClass : #A
@AbapCatalog.dataMaintenance : #ALLOWED
define table zchamado {
  key mandt     : mandt not null;
  key chamadoid : abap.int4 not null;
  assunto       : abap.char(60);
  descricao     : abap.char(255);
  solicitanteid : abap.int4;
  status        : abap.char(1);

}

"002 - CDS com Annotations para puublicar objeto na BOPF e para publicar o serviço OData
