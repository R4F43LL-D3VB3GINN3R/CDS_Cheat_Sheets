@AbapCatalog.sqlViewName: 'ZV_VOO'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Lista de Voos'
define view ZDD_VOO as select from sflight
{
    key mandt  as Mandt,
    key carrid as Carrid,
    key connid as Connid,
    key fldate as Fldate,
    price      as Price,
    currency   as Currency,
    planetype  as Planetype,
    seatsmax   as Seatsmax,
    seatsocc   as Seatsocc,
    (seatsmax - seatsocc) as disponiveis,
    paymentsum as Paymentsum,
    seatsmax_b as SeatsmaxB,
    seatsocc_b as SeatsoccB,
    seatsmax_f as SeatsmaxF,
    seatsocc_f as SeatsoccF
}
where carrid = 'AA'
