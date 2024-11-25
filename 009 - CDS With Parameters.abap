"Com parâmetros obrigatórios

@AbapCatalog.sqlViewName: 'ZV_AGENCIA'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Dados de Agências de Voo'
define view ZDD_AGENCIA 
with parameters 
    p_country  : s_country,
    p_currency : s_curr_ag 
as select from stravelag
{
    key mandt as Mandt,
    key agencynum as Agencynum,
    name as Name,
    street as Street,
    postbox as Postbox,
    postcode as Postcode,
    city as City,
    country as Country,
    region as Region,
    telephone as Telephone,
    url as Url,
    langu as Langu,
    currency as Currency
}
where country = :p_country
and currency = :p_currency

"Parâmetro opcional com annotation que envia a linguagem do sistema caso nao tenha sido enviada pelo utilizador

@AbapCatalog.sqlViewName: 'ZV_AGENCIA'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Dados de Agências de Voo'
define view ZDD_AGENCIA 
with parameters 
   @Environment.systemField: #SYSTEM_LANGUAGE
   p_langu : spras
as select from stravelag
{
    key mandt as Mandt,
    key agencynum as Agencynum,
    name as Name,
    street as Street,
    postbox as Postbox,
    postcode as Postcode,
    city as City,
    country as Country,
    region as Region,
    telephone as Telephone,
    url as Url,
    langu as Langu,
    currency as Currency
}
where langu = :p_langu
