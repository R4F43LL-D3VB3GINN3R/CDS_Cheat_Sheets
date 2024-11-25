@AbapCatalog.sqlViewName: 'ZV_RESERVA'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Dados de Reserva'
define view ZDD_RESERVA as select from sbook
inner join stravelag on sbook.agencynum = stravelag.agencynum
{
    key sbook.mandt as Mandt,
    key carrid as Carrid,
    key connid as Connid,
    key fldate as Fldate,
    key bookid as Bookid,
    customid as Customid,
    custtype as Custtype,
    smoker as Smoker,
    luggweight as Luggweight,
    wunit as Wunit,
    invoice as Invoice,
    class as Class,
    forcuram as Forcuram,
    forcurkey as Forcurkey,
    loccuram as Loccuram,
    loccurkey as Loccurkey,
    order_date as OrderDate,
    counter as Counter,
    sbook.agencynum as Agencynum,
    stravelag.name as nome_agencia,
    cancelled as Cancelled,
    reserved as Reserved,
    passname as Passname,
    passform as Passform,
    passbirth as Passbirth
}
