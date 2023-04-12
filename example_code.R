# Example code
# ============

# Load the functions
source('geo2org.R', local = TRUE)

# df_geo
df_geo <- read.csv('.\\example_data\\imd_2019.csv') %>% 
  select(1, 5, 8, 11, 14, 17, 20, 23, 26) %>%
  rename_with(.fn = function(x){c('geo_code', 'imd_score', 'income_score', 'employment_score', 'education_score', 'health_score', 'crime_score', 'services_score', 'environment_score')})

# df_org
df_org <- read.csv('.\\example_data\\qof_prevalence.csv') %>% 
  mutate(PREV = REGISTER / PRACTICE_LIST_SIZE) %>%
  select(1, 2, 6) %>%
  rename_with(.fn = function(x){c('org_code', 'group_code', 'prevalence')}) %>%
  pivot_wider(names_from = group_code, values_from = prevalence)

# df_weighting
df_weighting <- read.csv('.\\example_data\\gp_prac_lsoa.csv') %>% 
  select(3, 5, 7) %>%
  rename_with(.fn = function(x){c('org_code', 'geo_code', 'weighting')})

write.csv(fnGeo2Org(df_geo, df_weighting), 'geo2org.csv', row.names = FALSE)
write.csv(fnOrg2Geo(df_org, df_weighting), 'org2geo.csv', row.names = FALSE)

