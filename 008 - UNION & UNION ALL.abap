"Une as duas consultas sem duplicação de linhas

@AbapCatalog.sqlViewName: 'ZV_PARCEIRO'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Dados de Parceiros'
define view ZDD_PARCEIRO as select from zcliente
{
    clienteid as Parceiroid,
    nome as Nome   
}
union 
select from zfornecedor
{
    fornecedorid as Parceiroid,
    nome as Nome   
}

"Une as duas consultas com duplicação de linhas

@AbapCatalog.sqlViewName: 'ZV_PARCEIRO'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Dados de Parceiros'
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
