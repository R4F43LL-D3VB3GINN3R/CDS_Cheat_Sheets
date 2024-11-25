"https://help.sap.com/doc/abapdocu_750_index_htm/7.50/en-US/abencds_f1_builtin_functions.htm -- All functions to be used.

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
