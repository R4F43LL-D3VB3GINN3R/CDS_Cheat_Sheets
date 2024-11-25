@AbapCatalog.sqlViewName: 'ZV_CLIENTE'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Dados de Cliente'
define view ZDD_CLIENTE as select from scustom
{
    key mandt as Mandt,
    key id as Id,
    name as Name,
    form as Form,
    country as Country,
    concat_with_space(form, name, 1) as nome_completo
}
