# Geo2Org: Geographical to Organisation (and the reverse) Mapping using Weighting Variable

<table>
  <tr>
    <td style="padding-right: 15px; font-size: 16px">Author:</td><td style="padding-right: 15px; font-size: 16px">Richard Blackwell</td>
  </tr>
  <tr>
    <td style="padding-right: 15px; font-size: 16px">Email:</td><td style="padding-right: 15px; font-size: 16px">richard.blackwell@healthinnovationsouthwest.com</td>
  </tr>
  <tr>
    <td style="padding-right: 15px; font-size: 16px">Date:</td><td style="padding-right: 15px; font-size: 16px">2023-08-15</td>
  </tr>
</table>
----

### <strong>Functions</strong>

#### <strong>`fnGeo2Org(df_geo, df_weighting)`</strong>

<h5><strong>Description</strong></h5>
<p>This function takes two data frames, the first of which `df_geo` consists of a geographical variable `geo_code`, for example Lower-layer Super Output Area (LSOA) code, and attribute variable(s) for that geographical unit, for example IMD score for that LSOA and a boolean (0|1) indicating whether the LSOA is rural or urban. The second data frame `df_weighting` consists of an organisational variable `org_code`, for example the practice code, the geographical variable `geo_code` which should match that in the `df_geo` data frame, for example LSOA code, and the variable to weight the attribute variable by `weighting`, for example the number of patients registered to that practice in that LSOA.</p>
<p>The weighting calculation is as follows, that attribute variable for the geographical unit is multipled by the weighting variable for that organisation and 
geographical unit. The sum of these weighted variables are calculated for that organisation and then divided by the sum of the weighting for that organisation. A step by step calculation is shown below</p>

<h4><strong>`df_geo`</strong></h4>
| geo_code | attr_a | attr_b |
|:---------|-------:|-------:|
| Area_001 | 10.1 | 1 |
| Area_002 | 5.5 | 0 |
| Area_003 | 50.7 | 1 |
| ... | ... | ... |

<h4><strong>`df_org`</strong></h4>
| org_code | geo_code | weighting |
|:---------|---------:|----------:|
| Org_A | Area_001 | 100 |
| Org_A | Area_002 | 500 |
| Org_A | Area_003 | 400 |
| Org_B | Area_002 | 900 |
| Org_B | Area_003 | 100 |
| ... | ... | ... |

<strong>Organisation A</strong>
<br><br>
The weighted value for `attr_a` for organisation <strong>Org_A</strong> is calculated as 
$$\frac{(10.1 * 100) + (5.5 * 500) + (50.7 * 400)}{100 + 500 + 400} = \frac{1010 + 2750 + 20280}{1000} = 24.04$$
and weighted value for `attr_b` for organisation <strong>Org_A</strong> is calculated as 
$$\frac{(1 * 100) + (0 * 500) + (1 * 400)}{100 + 500 + 400} = \frac{100 + 0 + 400}{1000} = 0.5$$
(if this were a boolean variable for rurality then it would indicate that half of organisation A's population live in a rural area)
<br><br>
<strong>Organisation B</strong>
<br><br>
The weighted value for `attr_a` for organisation <strong>Org_B</strong> is calculated as 
$$\frac{(10.1 * 0) + (5.5 * 900) + (50.7 * 100)}{0 + 900 + 100} = \frac{0 + 4950 + 5070}{1000} = 10.02$$
and weighted value for `attr_b` for organisation <strong>Org_B</strong> is calculated as 
$$\frac{(1 * 0) + (0 * 900) + (1 * 100)}{0 + 900 + 100} = \frac{0 + 0 + 100}{1000} = 0.1$$
(if this were a boolean variable for rurality then it would indicate that 10 percentage of organisation B's population live in a rural area)

<h4><strong>`result`</strong></h4>
| org_code | attr_a | attr_b |
|:---------|-------:|-------:|
| Org_A | 24.04 | 0.5 |
| Org_B | 10.02 | 0.1 |
| ... | ... | ... |

----

#### <strong>`fnOrg2Geo <- function(df_org, df_weighting)`</strong>

<h5><strong>Description</strong></h5>
<p>This function takes two data frames, the first of which `df_org` consists of a organisational variable `org_code`, for example practice code, and attribute variable(s) for that geographical unit, for example prevalence of Chronic Obstructive Pulmonary Disease (COPD) for that practice and number of GPs (Whole Time Equivalents WTE). The second data frame `df_weighting` consists of a geographical variable `geo_code`, for example the LSOA code, the organisational variable `org_code` which should match that in the `df_geo` data frame, for example practice code, and the variable to weight the attribute variable by `weighting`, for example the number of patients registered to that practice in that LSOA.</p>
<p>The weighting calculation is as follows, that attribute variable for the organisational unit is multipled by the weighting variable for that organisation and 
geographical unit. The sum of these weighted variables are calculated for that geography and then divided by the sum of the weighting for that geography. A step by step calculation is shown below</p>

<h4><strong>`df_geo`</strong></h4>
| org_code | attr_a | attr_b |
|:---------|-------:|-------:|
| Org_A | 10.1 | 3 |
| Org_B | 2.5 | 4 |
| ... | ... | ... |

<h4><strong>`df_org`</strong></h4>
| geo_code | org_code | weighting |
|:---------|---------:|----------:|
| Area_001 | Org_A | 100 |
| Area_002 | Org_A | 500 |
| Area_003 | Org_A | 400 |
| Area_002 | Org_B | 900 |
| Area_003 | Org_B | 100 |
| ... | ... | ... |

<strong>Area 001</strong>
<br><br>
The weighted value for `attr_a` for area <strong>Area_001</strong> is calculated as 
$$\frac{(10.1 * 100) + (2.5 * 0)}{100 + 0} = \frac{1010 + 0}{100} = 10.1$$
and weighted value for `attr_b` for area <strong>Area_001</strong> is calculated as 
$$\frac{(3 * 100) + (4 * 0)}{100 + 0} = \frac{300 + 0}{100} = 3$$
<br><br>
<strong>Area 002</strong>
<br><br>
The weighted value for `attr_a` for area <strong>Area_002</strong> is calculated as 
$$\frac{(10.1 * 500) + (2.5 * 900)}{500 + 900} = \frac{5050 + 2250}{1400} = 5.21$$
and weighted value for `attr_b` for area <strong>Area_002</strong> is calculated as 
$$\frac{(3 * 500) + (4 * 900)}{500 + 900} = \frac{1500 + 3600}{1400} = 3.64$$
<br><br>
<strong>Area 003</strong>
<br><br>
The weighted value for `attr_a` for area <strong>Area_003</strong> is calculated as 
$$\frac{(10.1 * 400) + (2.5 * 100)}{400 + 100} = \frac{4040 + 250}{500} = 8.58$$
and weighted value for `attr_b` for area <strong>Area_003</strong> is calculated as 
$$\frac{(3 * 400) + (4 * 100)}{400 + 100} = \frac{1200 + 400}{500} = 3.2$$
<br><br>

<h4><strong>`result`</strong></h4>
| geo_code | attr_a | attr_b |
|:---------|-------:|-------:|
| Area_001 | 10.1 | 3.0 |
| Area_002 | 5.21 | 3.64 |
| Area_003 | 8.58 | 3.2 |
| ... | ... | ... |
