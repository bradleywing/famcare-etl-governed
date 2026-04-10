# `famcare-etl-governed`
Governed transformation pipeline for FAMCare extracts. Standardizes, cleans, and aligns data across programs to produce reporting‑ready, enrollment‑grain datasets for analytics and QA.

## Overview
`famcare-etl-governed` implements the governed transformation layer of the BHN FAMCare data ecosystem. It operates on flat files exported from FAMCare as .csv and produces consistent, auditable datasets suitable for compiling written reports, infographic briefs, and program analytics. This ETL is intended to be **program-agnostic** with the ability to support multiple FAMCare-based BHN programs with minimal structural changes.

## Key Features
This ETL pipeline is built around:
- Metadata-driven cleaning using the `analytic_fields` table
- Normalization and standardization of FAMCare extracts
- Enrollment grain `q-epicc-pathclient-enrollments` construction
- Latest slowly changing dimension (SCD) records joined to final table
- All SCD rows avaialable in standalone, long-format table
- Wide, reporting-ready full referral flow table
- Transparent, auditable transformations with intermediate diagnostics

## Architecture
This repository represents the **transformation and reporting** layer of the FAMCare ETL pipeline:

```text
FAMCare Extracts (view-based)
        ↓
famcare-etl-governed  ← (this repo)
  - Cleaning
  - Normalization
  - SCD logic
  - Pathway Event alignment and joins to program enrollments
  - Wide table construction
        ↓
Analytics-ready datasets (epicc_full_data, subsets, diagnostics)
```

## Outputs
The ETL produces a variety of objects in a structured list for downstream use. This list includes:
- raw tibbles for each extract
- intermediate tibble `joined_pathclient`: an authoritative enrollment grain table with demographics
- intermediate tibble `joined_referral_flow`: the wide, fully joined Pathway Event table with active SCD records joined
- intermediate tibbles `intake_one`, `payor_one`, `housing_one`: tables of active SCD records for QA
- intermediate tibble `parent_map`: event `docserno` to SCD summation `parent_docserno` mapping for QA
- `epicc_full_data`: the final, wide, enrollment-grained dataset
- optional subsets based on date ranges and fiscal system

## Status
This repository is part of the transition from legacy ETL to a modern, governed pipeline. The legacy workflow will remain active during the transition period.

## Future Work
Anticipated enhancements include:
- Support for additional FAMCare-based programs
- Optional future integration with vendor API (pending feasibility)
- Expanded metadata governance

## Contributing
Analysts are encouraged to contribute improvements, documentation, and program extensions. Please follow the established coding style (a modified version of tidyverse style), naming conventions, and metadata governance standards. All changes must be made in a feature branch and submitted via pull request. Direct commits to the `main` branch are disallowed.
