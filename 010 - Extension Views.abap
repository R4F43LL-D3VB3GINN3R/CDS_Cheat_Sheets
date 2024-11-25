
"--------------------------------------------------------------------------

"001 - EXTENSÃO SIMPLES COM ACRÉSCIMO DE CAMPOS.

"View a ser extendida

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

"Primeira Extensão

@AbapCatalog.sqlViewAppendName: 'ZV_PEDIDO_EXT1'
@EndUserText.label: 'Extensão dos dados do pedido'
extend view ZDD_PEDIDO with ZDD_PEDIDO_EXT1
{
    t1.cond_pgto
    
}

"Segunda Extensão

@AbapCatalog.sqlViewAppendName: 'ZV_PEDIDO_EXT2'
@EndUserText.label: 'Extensão dos dados do pedido'
extend view ZDD_PEDIDO with ZDD_PEDIDO_EXT2
{
    t1.data_alteracao,
    'A' as status
}

"---------------------------------------------------------------------------------------

"002 - EXTENSÃO COM GROUP BY

"View a ser extendida

@AbapCatalog.sqlViewName: 'ZV_PEDIDO2'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Dados de Pedidos'
@AbapCatalog.viewEnhancementCategory: [#PROJECTION_LIST,#GROUP_BY]             "Annotation necessária para que a extensão suporte o group by
define view ZDD_PEDIDO2 
as select from zov_cab as t1
inner join ZDD_OVITEM  as t2 on t1.ovid = t2.ovid
{
    key t1.ovid,
    sum( t2.preco_uni ) as total_ordem
}
group by t1.ovid

"Extensão da View

@AbapCatalog.sqlViewAppendName: 'ZV_PEDIDO2_EXT1'
@EndUserText.label: 'Extensão dos dados do pedido'
extend view ZDD_PEDIDO2 with ZDD_PEDIDO2_EXT1
{
    min(t2.preco_uni) as preco_minimo
}
group by t1.ovid

"---------------------------------------------------------------------------------------

"003 - EXTENSÃO COM UNION

"View a ser extendida

@AbapCatalog.sqlViewName: 'ZV_PARCEIRO'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Dados de Parceiros'
@AbapCatalog.viewEnhancementCategory: [#PROJECTION_LIST,#UNION]                  "Annotation que permite extensões com Union
define view ZDD_PARCEIRO as select from zcliente
{
    clienteid as Parceiroid,
    nome as Nome
    
}
union all
select from zfornecedor
{
    fornecedorid as Parceiroid,
    nome as Nome
}

"Extensão da View

@AbapCatalog.sqlViewAppendName: 'ZV_PARCEIRO_EXT1'
@EndUserText.label: 'Dados de Parceiros'
extend view ZDD_PARCEIRO with ZDD_PARCEIRO_EXT1
{
    cast('Não Possui' as abap.char(255)) as Email
}
union
{
    email
}

"---------------------------------------------------------------------------------------




