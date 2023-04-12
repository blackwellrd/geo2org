# =============================================================== #
# Desc: Convert Geographical Dat to Organisational and Vice Versa #
# File: geo2org.R                                                 #
# =============================================================== #

# Load libraries
# ==============

library(tidyverse)

fnGeo2Org <- function(df_geo, df_weighting){
  # The data frame df_geo should contain the geographical based data, and the data frame 
  # df_weighting should contain the weighting value mapped to organisation and geography
  # Fields are as follows; [df_geo] geo_code, data field(s) and [df_weighting] org_code, geo_code, weighting
  df_result <- df_weighting %>% 
    # Join the weighting data frame and geographic based data
    inner_join(df_geo, by = c('geo_code' = 'geo_code')) %>% 
    # Weight the geographical data fields by multiplying by the weighting value
    mutate(across(.cols = !(1:2), .fn = function(x){x * weighting})) %>%
    # Remove the weighting field
    select(-weighting) %>% 
    inner_join(
      # Group the weighting data by the organisation and then join to the data
      df_weighting %>% 
        group_by(org_code) %>% 
        summarise(weighting = sum(weighting), .groups = 'keep') %>%
        ungroup(),
      by = c('org_code' = 'org_code')
    ) %>% 
    # Divide all the columns by the total weighting value for the organisation
    mutate(across(.cols = !c(1:2), .fn = function(x){x / weighting})) %>%
    # remove the total weighting field
    select(-weighting) %>%
    # Group by the organisation and calculate the sum of each of the geographical based data
    group_by(org_code) %>%
    summarise(across(!1, .fn = sum)) %>%
    ungroup()
  return(df_result)
}

fnOrg2Geo <- function(df_org, df_weighting){
  # The data frame df_geo should contain the geographical based data, and the data frame 
  # df_weighting should contain the weighting value mapped to organisation and geography
  # Fields are as follows; [df_org] org_code, data field(s) and [df_weighting] org_code, geo_code, weighting
  df_result <- df_weighting %>% 
    # Join the weighting data frame and organisation based data
    inner_join(df_org, by = c('org_code' = 'org_code')) %>% 
    # Weight the organisational data fields by multiplying by the weighting value
    mutate(across(.cols = !(1:2), .fn = function(x){x * weighting})) %>%
    # Remove the weighting field
    select(-weighting) %>% 
    inner_join(
      # Group the weighting data by the geography and then join to the data
      df_weighting %>% 
        group_by(geo_code) %>% 
        summarise(weighting = sum(weighting), .groups = 'keep') %>%
        ungroup(),
      by = c('geo_code' = 'geo_code')
    ) %>% 
    # Divide all the columns by the total weighting value for the geography
    mutate(across(.cols = !c(1:2), .fn = function(x){x / weighting})) %>%
    # remove the total weighting field
    select(-weighting) %>%
    # Group by the geography and calculate the sum of each of the organisational based data
    group_by(geo_code) %>%
    summarise(across(!1, .fn = sum)) %>%
    ungroup()
  return(df_result)
}
