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

"CRIANDO VALIDACOES

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

    "carrega as informacoes do chamado
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

"CRIANDO DETERMINACOES - AUTO INCREMENTOS

"023 - Novamente na BOBX >> Node Elements >> ZDD_CHAMADO >> Determinations
"024 - Ignorar a Determination criada e criar uma nova clicando com o botão direito
"025 - Preencha nome e descrição EX: Nome->SET_CHAMADOID Descricao->Seta o ID do chamado
"026 - No campo da Classe não use a mesma e preencha com uma diferente ZCL_CHAMADO_SETID
"027 - Vá na aba de Trigger Conditions e expanda o node e marque a checkbox ZDD_CHAMADO e marque também a checkbox CREATE
"028 - Expanda ainda mais o node até aparecer os atributos do Objeto (Campos da CDS) e marque o ID >> CHAMADOID
"029 - Depois vá para a própxima aba chamada Evaluation Timepoints e expanda o node e marque a checkbox During Save
"030 - Dê duplo clique no nome da classe para criar

"031 - Entre no Método /BOBF/IF_FRW_DETERMINATION~EXECUTE para implementá-lo.

"------------------------------------------------------------------------------------------------------------------------"

"PARAMETROS

IS_CTX	TYPE /BOBF/S_FRW_CTX_DET	Context Information for Determinations
IT_KEY	TYPE /BOBF/T_FRW_KEY	Key Table
IO_READ	TYPE REF TO /BOBF/IF_FRW_READ	Interface to Reading Data
IO_MODIFY	TYPE REF TO /BOBF/IF_FRW_MODIFY	Interface to Change Data
EO_MESSAGE	TYPE REF TO /BOBF/IF_FRW_MESSAGE	Message Object
ET_FAILED_KEY	TYPE /BOBF/T_FRW_KEY	Key Table
/BOBF/CX_FRW		Exception class

  method /BOBF/IF_FRW_DETERMINATION~EXECUTE.

    "PS: USAR ESSE METODO COMO EXEMPLO PARA REALIZAR OUTRAS VALIDACOES!

    "limpeza dos dados de saída
    clear eo_message.
    clear et_failed_key.

    data: lt_data type ztddchamado.           "tipo tabela criado pelo objeto de negocio serve como referencia para CDS
    data: ld_id   type zsddchamado-chamadoid. "chave da CDS

    "carrega as informacoes do chamado
    io_read->retrieve(
      exporting
        iv_node                 = is_ctx-node_key                                                        " Node Name
        it_key                  = it_key                                                                 " Key Table
      importing
        et_data                 = lt_data ).                                                             " Data Return Structure

    "seleciona a maior chave do chamado
    select  max( chamadoid )
      from zchamado
      into ld_id.

    "incrementa se encontrar chave e seta como 1 caso nao encontre
    if sy-subrc eq 0.
      add 1 to ld_id.
    else.
      ld_id = 1.
    endif.

    "atribuindo auto incremento para cada linha de chave que nao possua uma
    loop at lt_data reference into data(lr_data) where chamadoid = 0.
      lr_data->chamadoid = ld_id. "recebe o id da consulta

      "modifica a tabela conforme o id passado
      try.
        call method io_modify->update
          exporting
            iv_node           = is_ctx-node_key                                                          " Node
            iv_key            = lr_data->key                                                             " Key
            is_data           = lr_data                                                                  " Data
            it_changed_fields = value #( ( zif_dd_chamado_c=>sc_node_attribute-zdd_chamado-chamadoid ) ) " List of Names (e.g. Fieldnames)
          .
      catch /bobf/cx_frw.
      endtry.

      add 1 to ld_id. "incrementa a chave

    endloop.

  endmethod.

"------------------------------------------------------------------------------------------------------------------------"

"032 - Ativando Objetos do BOPF >> Transação BOBX
"033 - Na Aba de cima ative o modo edição e vá na primeira opção Business  Object >> Check...Depois Check and Generate e Depois Check novamente e depois Check and Generate mais uuma vez...kkkk
"034 - Depois dos objetos gerados e sem erros podemos usar os objetos do BOPF
"035 - Vá na Transação SE16 para criar entradas para a sua Tabela caso necessite.

"036 - Agora teste o seu serviço no sap gateway client.
"037 - Para criar um novo dado a partir da Request, clique na aba Use as Request e você notará que os dados serão replicados como um requisição do lado esquerdo
"038 - Mude para POST e não passe nenhum id na URL e remova as referências dos dados de referência do lado esquerda removendo ids ou dados similares.

EX: --------------------------------------------------

<?xml version="1.0" encoding="utf-8"?>
<entry xml:base="http://sbxsappsrv.sbx.local:8031/sap/opu/odata/sap/ZDD_CHAMADO_CDS/" xmlns="http://www.w3.org/2005/Atom" xmlns:m="http://schemas.microsoft.com/ado/2007/08/dataservices/metadata" xmlns:d="http://schemas.microsoft.com/ado/2007/08/dataservices">
 <id>http://sbxsappsrv.sbx.local:8031/sap/opu/odata/sap/ZDD_CHAMADO_CDS/ZDD_CHAMADO</id>
 <title type="text">ZDD_CHAMADO</title>
 <updated>2024-11-26T19:40:26Z</updated>
 <category term="ZDD_CHAMADO_CDS.ZDD_CHAMADOType" scheme="http://schemas.microsoft.com/ado/2007/08/dataservices/scheme"/>
 <link href="ZDD_CHAMADO" rel="edit" title="ZDD_CHAMADOType"/>
 <content type="application/xml">
  <m:properties>
   <d:Chamadoid>0</d:Chamadoid>
   <d:Assunto>TESTE</d:Assunto>
   <d:Descricao>TESTE2</d:Descricao>
   <d:Solicitanteid>2</d:Solicitanteid>
   <d:Status>A</d:Status>
  </m:properties>
 </content>
</entry>

EX: --------------------------------------------------

"039 - Você fazer o mesmo processo com o Método PUT para dar update nos dados e deve se deixar o parametro de referencia na URL e na Request se houver.
"040 - Para Delete, faça a mesma coisa que o Update, mas não precisa do Use as Request







