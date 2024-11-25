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

"Em caso de uma das tabelas não conter o mesmo número de campos, podemos adicionar este campo na tabela que não o tem
"Também deve ser realizado um casting no campo criado para ele não assumir um char1, este mesmo campo deve de ter o mesmo tipo de dado do campo original.

@AbapCatalog.sqlViewName: 'ZV_PARCEIRO'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Dados de Parceiros'
define view ZDD_PARCEIRO as select from zcliente
{
    clienteid as Parceiroid,
    nome as Nome,
    cast('' as abap.char(255)) as Email,
    'C' as tipo
}
union all
select from zfornecedor
{
    fornecedorid as Parceiroid,
    nome as Nome,
    email as Email,
    'F' as tipo
}

