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

@AbapCatalog.sqlViewName: 'ZV_CHAMADO'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Dados de Chamado'
@Metadata.allowExtensions: true
@ObjectModel.modelCategory: #BUSINESS_OBJECT
@ObjectModel.compositionRoot: true
@ObjectModel.transactionalProcessingEnabled: true
@ObjectModel.createEnabled: true
@ObjectModel.deleteEnabled: true
@ObjectModel.updateEnabled: true
@ObjectModel.writeActivePersistence: ''
@ObjectModel.semanticKey: [ '' ]
@ObjectModel.alternativeKey: [ '' ]
@OData.publish: true
define view ZDD_CHAMADO as select from zchamado
{
    key chamadoid as Chamadoid,
    assunto as Assunto,
    descricao as Descricao,
    solicitanteid as Solicitanteid,
    status as Status
}

"003 - Preencher esta Annotation com o nome da Tabela --> @ObjectModel.writeActivePersistence: 'ZCHAMADO'

"004 - Preencher as duas Annotations com o nome da chave da Tabela 
--> @ObjectModel.semanticKey: [ 'chamadoid' ]
--> @ObjectModel.alternativeKey: [ 'chamadoid' ]

"005 - Ir a Transação no SAP GUI --> /n/IWFND/MAINT_SERVICE
"006 - Clicar em Inserir Serviço
"007 - No Campo Alias do Sistema, digitar Local
"008 - Procurar na parte de baixo da lista o Serviço
"009 - Clicar em Inserir Serviços Relacionados
"010 - Escolher um pacote e clicar em Ok

