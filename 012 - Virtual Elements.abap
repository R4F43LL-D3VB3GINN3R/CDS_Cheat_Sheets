
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

"002 - Agora crie uma classe na se24 ou no Eclipse com o nome ZCL_CDS

"003 - Defina uma Interface na aba de Interfaces 
IF_SADL_EXIT_CALC_ELEMENT_READ que por definição calcula campos no virtual elements

"004 - Na aba de Métodos é hora de implementar o método de Interface: IF_SADL_EXIT_CALC_ELEMENT_READ~CALCULATE.

"--------------------------------------------------------------------------------------------------------------

"005 - O método possui estes parâmetros:

"IT_ORIGINAL_DATA	TYPE STANDARD TABLE       -- Tabela com linhas originais da CDS
"IT_REQUESTED_CALC_ELEMENTS	TYPE TT_ELEMENTS  -- Campos necessários para Cálculo
"CT_CALCULATED_DATA	TYPE STANDARD TABLE       -- Output
"CX_SADL_EXIT	

"Uma implementação lógica.

  method IF_SADL_EXIT_CALC_ELEMENT_READ~CALCULATE.

    data: it_table type table of ZV_ORDENS_CMPRS. "tabela do tipo da view da cds

    move-corresponding it_original_data to it_table. "move os dados da CDS para a tabela interna

    loop at it_table assigning field-symbol(<ls_dados>).
      if <ls_dados>-frgrl = 'X'.
        <ls_dados>-status = 'Pendente'.
      else.
        <ls_dados>-status = 'Liberado'.
      endif.
    endloop.

    "tabela de output recebe os dados atualizados após manipulacao
    move-corresponding it_table to ct_calculated_data.

  endmethod.

"--------------------------------------------------------------------------------------------------------------

"006 - Depois podemos ir a /n/IWFND/MAINT_SERVICE e executar o nosso serviço com um break point remoto e verificar o método sendo aplicado.
"As alterações realizadas no método só podem ser vistas no serviço odata, portanto, se executada diretamente na CDS nenhuma mudança será notada

