# cleanOrgs

**cleanOrgs** is a lightweight package for cleaning and validating NHS organisation data in the South East region.

It provides a simple, reliable workflow for:
 - replacing superseded organisation codes to align data with the current organisation structure
 - adding official organisation names aligned to the Organisation Data Service (ODS)
 - adding ICB codes and names
 - generating short names suitable for charts and slides

The goal is to make it easy to bring historic data into line with current structures before analysis or reporting, using a single reproducible pipeline.

## Installation

Install the development version from GitHub:
```r
# install.packages("devtools")
devtools::install_github("johndcusack/cleanOrgs")
```

## Example workflow
Below is a minimal end-to-end example showing the core workflow:
```r
library(cleanOrgs)
library(tidyverse)

example_df <- tibble(org_code = c("RTH","RXQ","RVV","R1C"),
                     activity = c(10,10,10,10))

output_df <- example_df |> 
  cleanOrgs_replace_succeeded(code_column = "org_code") |> 
  cleanOrgs_update_names(code_column = "org_code", 
                         name_column = "org_name_full") |> 
  cleanOrgs_add_shortname(code_column = "org_code",
                          new_col_name = "org_short_name")
  
output_with_icb <- example_df |> 
  cleanOrgs_replace_succeeded(code_column = "org_code") |> 
  cleanOrgs_add_icb_code(code_column = "org_code") |> 
  cleanOrgs_update_names(code_column = "org_code",
                         name_column = "org_name_full") |> 
  cleanOrgs_update_names(code_column = "icb_code",
                         name_column = "icb_name_full") |> 
  cleanOrgs_add_shortname(code_column = "org_code",
                          new_col_name = "org_short_name") |> 
  cleanOrgs_add_shortname(code_column = "icb_code",
                          new_col_name = "icb_short_name")
```
-------------------------------------------------------------------

## Key functions
|Function            |Description                             |
|--------------------|----------------------------------------|
|`cleanOrgs_replace_succeeded()`| Uses data available from the ODS API to identify organisation codes that have been superseded and replaces them with successor codes. |
|`cleanOrgs_update_names()`| Adds official organisation names (Trust or ICB). |
|`cleanOrgs_add_shortname()`| Adds a short, readable name suitable for use in charts or tables. |
|`cleanOrgs_add_icb_code()`| Adds the ICB code associated with the relevant Trust. |
|`cleanOrgs_json_extraction()`| Extracts and formats ODS API responses into a list of JSON objects. |
|`cleanOrgs_get_json()`| A wrapper function to `cleanOrgs_json_extraction` that caches ODS API results locally. |
|`cleanOrgs_create_ods_table()`| Takes a list of JSON objects and builds the internal reference table used across the package. |

## Why this package?
Trend analysis within the NHS often requires evaluating data over multiple financial years. This becomes challenging when the period under review coincides with a time when organisations merged or simply changed their names. 

Manually maintaining lookup tables is error-prone, and sometimes requires time-consuming research into an organisation's history to determine whether reconciliation is necessary across the period under review. These issues are often only discovered during quality assurance, leading to rework and delays.

Additionally, the full names of NHS organisations are often long, creating layout challenges when presenting information in charts and tables.

**cleanOrgs** solves these problems by:
- automating code replacement via official ODS metadata
- providing a consistent set of helper functions
- reducing prep time for reporting and dashboards
- ensuring reproducibility across analysis and datasets

## Project status
This package is fully functional.
Core workflows are stable and tested using real NHS metadata.

## Contributing 
Feel free to open an issue or submit a pull request with suggestions or improvements.

## License
MIT License. See `LICENSE` for details
