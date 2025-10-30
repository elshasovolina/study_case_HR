-- Match Rate per Employee
WITH TopEmployee AS (
  
  SELECT 
    employee_id, year,
    rating
  FROM hrd.performance_yearly
  WHERE rating = 5

),
employee_detail AS (
  SELECT 
    c.employee_id,
    c.fullname,
    c.education_id, 
    c.years_of_service_months,
    b.pauli, 
    b.faxtor,
    b.disc,
    b.mbti,
    b.iq,
    b.gtq,
    b.tiki
  FROM hrd.employees c
  JOIN hrd.profiles_psych b ON c.employee_id = b.employee_id
),
employee_PAPI AS (
  select employee_id,
  max(Papi_N) as Papi_N,
  max(Papi_G) as Papi_G,
  max(Papi_V) as Papi_V,
  max(Papi_O) as Papi_O,
  max(Papi_B) as Papi_B,
  max(Papi_X) as Papi_X,
  max(Papi_R) as Papi_R,
  max(Papi_K) as Papi_K,
  max(Papi_F) as Papi_F,
  max(Papi_W) as Papi_W
  from
    (SELECT 
        employee_id,
        case when scale_code =  'Papi_N' then score else null end as Papi_N,
        case when scale_code =  'Papi_G' then score else null end as Papi_G,
        case when scale_code =  'Papi_V' then score else null end as Papi_V,
        case when scale_code =  'Papi_O' then score else null end as Papi_O,
        case when scale_code =  'Papi_B' then score else null end as Papi_B,
        case when scale_code =  'Papi_X' then score else null end as Papi_X,
        case when scale_code =  'Papi_R' then score else null end as Papi_R,
        case when scale_code =  'Papi_K' then score else null end as Papi_K,
        case when scale_code =  'Papi_F' then score else null end as Papi_F,
        case when scale_code =  'Papi_W' then score else null end as Papi_W

      FROM hrd.papi_scores
    ) papi_score
  group by employee_id
),
employee_compentency as 
(
 select employee_id,year,
  max(GDR) as GDR,
  max(CEX) as CEX,
  max(IDS) as IDS,
  max(QDD) as QDD,
  max(STO) as STO,
  max(SEA) as SEA,
  max(VCU) as VCU,
  max(LIE) as LIE,
  max(FTC) as FTC,
  max(CSI) as CSI
  from
    (SELECT 
        employee_id,year,
        case when pillar_code =  'GDR' then score else null end as GDR,
        case when pillar_code =  'CEX' then score else null end as CEX,
        case when pillar_code =  'IDS' then score else null end as IDS,
        case when pillar_code =  'QDD' then score else null end as QDD,
        case when pillar_code =  'STO' then score else null end as STO,
        case when pillar_code =  'SEA' then score else null end as SEA,
        case when pillar_code =  'VCU' then score else null end as VCU,
        case when pillar_code =  'LIE' then score else null end as LIE,
        case when pillar_code =  'FTC' then score else null end as FTC,
        case when pillar_code =  'CSI' then score else null end as CSI

      FROM hrd.competencies_yearly
    ) compentency
  group by employee_id, year
)
SELECT 
case when t.employee_id is not null then 'Top 5' else 'Not Top 5' end as Top,
ed.*,
ep.Papi_N,
ep.Papi_G,
ep.Papi_V,
ep.Papi_O,
ep.Papi_B,
ep.Papi_X,
ep.Papi_R,
ep.Papi_K,
ep.Papi_F,
ep.Papi_W,
COALESCE(t.year, ec.year) AS year,
t.rating,
ec.GDR,
ec.CEX,
ec.IDS,
ec.QDD,
ec.STO,
ec.SEA,
ec.VCU,
ec.LIE,
ec.FTC,
ec.CSI

FROM employee_detail ed
left join TopEmployee t on ed.employee_id = t.employee_id
left join employee_papi ep on ed.employee_id = ep.employee_id
left join employee_compentency ec on ed.employee_id = ec.employee_id and t.year = ec.year
;
