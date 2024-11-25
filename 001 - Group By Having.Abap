@AbapCatalog.sqlViewName: 'ZV_VOO2'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Lista de Voos'
define view ZDD_VOO2 as select from sflight
{
    fldate as Fldate,
    count(*) as contador
}
group by fldate
having count(*) > 3
