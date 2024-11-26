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
"011 - Ir a transação BOBX
"012 - Procurar o nome da CDS e cliquee nela
"013 - Alterne para Modificação / Edição
"014 - Abra a pasta Node Elements >> Nome da CDS >> Validations
"015 - Clicar com o botão direito em Validations >> Create Validation >> Consistense Validation
"016 - Preencha o nome da Validação EX: VALIDACAO e informe a Descrição EX: VALIDACAO
"017 - No Campo Class/Interface, informe a Classe que será responsável pela Validação EX: ZCL_CHAMADO_VALIDACAO
"018 - Clique na aba Trigger Condition e expanda os nodes referentes a Validacao e marque a checkbox relacionada a CDS ZDD_CHAMADO e poderá marcar ou desmarcar as sugestões do crud ao ladoo.
"019 - Salve as Alterações
"020 - Valida o Método entrando nele para cria-lo na parte de Validacoes.
"021 - Indo na BOBX você pode conferir na parte de Nodes a estrutura e tabelas criadas automaticamente como se fosse na SE11 para a sua CDS
"022 - Procure o Método /BOBF/IF_FRW_VALIDATION~EXECUTE na classe ZCL_CHAMADO_VALIDACAO para implementá-lo

"------------------------------------------------------------------------------------------------------------------------"

"PARAMETROS

IS_CTX	        TYPE /BOBF/S_FRW_CTX_VAL	Context Information for Validations
IT_KEY	        TYPE /BOBF/T_FRW_KEY	Key Table
IO_READ	        TYPE REF TO /BOBF/IF_FRW_READ	Interface to Reading Data
EO_MESSAGE	    TYPE REF TO /BOBF/IF_FRW_MESSAGE	Message Object
ET_FAILED_KEY	  TYPE /BOBF/T_FRW_KEY	Node Assignment to Error Flag
/BOBF/CX_FRW		BOPF Exception Class

method /BOBF/IF_FRW_VALIDATION~EXECUTE.


    "PS: USAR ESSE METODO COMO EXEMPLO PARA REALIZAR OUTRAS VALIDACOES!

    "limpeza dos dados de saída
    clear eo_message.
    clear et_failed_key.

    data: lt_data type ztddchamado. "tipo tabela criado pelo objeto de negocio serve como referencia para CDS
    data: ls_message type symsg.    "estrutura do tipo classe de mensagens standard

    "metodo do leitor de dados do objeto de negocio
    "deixar como está e mudar apenas o parametro it_requested_attributes

    "it_requested_attributes --> zif_dd_chamado_c    (interface criada automaticamente)
    "                        --> =>sc_node_attribute (método estático da interface)
    "                        --> zdd_chamado-assunto (campo da estrutura a ser validada) ps -- mais campos podem ser passados

    io_read->retrieve(
      exporting
        iv_node                 = is_ctx-node_key                                                        " Node Name
        it_key                  = it_key                                                                 " Key Table
        iv_fill_data            = abap_true                                                              " Data element for domain BOOLE: TRUE (='X') and FALSE (=' ')
        it_requested_attributes = value #( ( zif_dd_chamado_c=>sc_node_attribute-zdd_chamado-assunto ) ) " List of Names (e.g. Fieldnames)
      importing
        et_data                 = lt_data ).                                                             " Data Return Structure

    eo_message = /bobf/cl_frw_factory=>get_message( ). "objeto recebe retorno de mensagem

    "preenche estrutura de classe de mensagens
    ls_message-msgid  = 'FB'.    "classe da mensagem
    ls_message-msgno = 420 .    "numero da mensagem
    ls_message-msgty = 'E' .    "tipo da mensagem

    "itera sobre a tabela para validar os registos
    loop at lt_data into data(ls_data).
      if ls_data-assunto = ''.
        clear ls_message-msgv1.

        ls_message-msgv1 = 'Nome Vazio'. "mensagem que será apresentada

        "metodo para inserir mensagens de validacao
        eo_message->add_message(
          exporting
            is_msg       =  ls_message                                              " Estrutura preenchida com mensagem
            iv_node      =  is_ctx-node_key                                         " Node to be used in the origin location
            iv_key       =  ls_data-key                                             " Instance key to be used in the origin location
            iv_attribute =  zif_dd_chamado_c=>sc_node_attribute-zdd_chamado-assunto " Attribute to be used in the origin location
        ).

        "preenche a tabela de saída de erro com a chave da  CDS que apresentou erro
        insert value #( key = ls_data-key ) into table et_failed_key.

      endif.

    endloop.

  endmethod.

"------------------------------------------------------------------------------------------------------------------------"



