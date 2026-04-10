```text
                       ┌──────────────────────────────┐
                       │      1. SOURCE setup.R       │
                       │  (helpers.R, fiscal_dates.R  │
                       │       and cartography.R)     │
                       └───────────────┬──────────────┘
                                       │
                                       ▼
                       ┌──────────────────────────────┐
                       │      2. SOURCE epicc.R       │
                       └───────────────┬──────────────┘
                                       │
                                       ▼
                        ┌─────────────────────────────┐
                        │ INGEST Raw FAMCare Extracts │
                        │   (event forms + SCD +      │
                        │     pathclient raw +        │
                        │    standalone tables)       │
                        └──────────────┬──────────────┘
                                       │
                                       ▼
                     ┌───────────────────────────────────┐
                     │ A. Load Raw Source Tables         │
                     │    - epicc_ref                    │
                     │    - epicc_ic                     │
                     │    - epicc_two_week               │
                     │    - epicc_thirty_day             │
                     │    - epicc_three_month            │
                     │    - epicc_six_month              │
                     │    - epicc_reengagement           │
                     │    - epicc_active_intake          │
                     │    - epicc_all_intake             │
                     │    - epicc_active_payor_source    │
                     │    - epicc_all_payor_source       │
                     │    - epicc_active_housing         │
                     │    - epicc_all_housing            │
                     │    - epicc_pathclient             │
                     │    - epicc_client                 │
                     │    - epicc_providerplacement      │
                     │    - epicc_pathway_docsernos      │
                     └────────────────┬──────────────────┘
                                      │
                                      ▼
                   ┌─────────────────────────────────────────┐
                   │ B. BUILD Authoritative Pathclient       │
                   │    - joins epicc_client                 │
                   │    - pivot_wider() by event type        │
                   │    - one row per enrollment             │
                   │    - produces:                          │
                   │        ref_docserno                     │
                   │        ic_docserno                      │
                   │        twow_docserno                    │
                   │        thirtyd_docserno                 │
                   │        threem_docserno                  │
                   │        sixm_docserno                    │
                   └──────────────────────┬──────────────────┘
                                          │
                                          ▼
              ┌────────────────────────────────────────────────────┐
              │ C. CLEAN Event Forms (ref_, ic_, twow_, …)         │
              │    - drop notes fields                             │
              │    - drop *_code fields                            │
              │    - prefix all columns with form name             │
              │    - preserve only: client_number, tiedenrollment  │
              │    - drop docserno columns (pathclient is source)  │
              └──────────────────────────┬─────────────────────────┘
                                         │
                                         ▼
              ┌────────────────────────────────────────────────────┐
              │ D. CLEAN SCD Tables (intake_, payor_, housing_)    │
              │    - rename parent_docserno to prevent duplicates  │
              │    - prefix all columns                            │
              │    - drop client_number                            │
              │    - keep only SCD data columns                    │
              └──────────────────────────┬─────────────────────────┘
                                         │
                                         ▼
                 ┌──────────────────────────────────────────────┐
                 │ E. BUILD parent_docserno Map from pivoted    │
                 │     pathclient:                              │
                 │     - (client_number, tiedenrollment,        │
                 │         parent_docserno)                     │
                 │     - long form of all six docserno columns  │
                 └──────────────────────┬───────────────────────┘
                                        │
                                        ▼
         ┌────────────────────────────────────────────────────────────────┐
         │ F. COLLAPSE SCD Tables to One Row per Enrollment               │
         │    parent_map                                                  │
         │       → left_join(SCD by parent_docserno)                      │
         │       → group_by(client_number, tiedenrollment)                │
         │       → summarise(across(all SCD cols), first non-NA)          │
         │                                                                │
         │    Produces:                                                   │
         │       intake_one   (one intake column per enrollment)          │
         │       payor_one    (one payor column per enrollment)           │
         │       housing_one  (one housing column per enrollment)         │
         └──────────────────────────────┬─────────────────────────────────┘
                                        │
                                        ▼
         ┌────────────────────────────────────────────────────────────────┐
         │ G. JOIN Everything Into Final Referral Flow Table              │
         │                                                                │
         │   pathclient                                                   │
         │      → left_join(intake_one)                                   │
         │      → left_join(payor_one)                                    │
         │      → left_join(housing_one)                                  │
         │      → left_join(ref)                                          │
         │      → left_join(ic)                                           │
         │      → left_join(twow)                                         │
         │      → left_join(thirtyd)                                      │
         │      → left_join(threem)                                       │
         │      → left_join(sixm)                                         │
         │      → left_join(reeng)                                        │
         │                                                                │
         │   Result:                                                      │
         │     - one row per enrollment                                   │
         │     - authoritative docserno columns                           │
         │     - one intake/payor/housing set                             │
         │     - one set of event-form columns                            │
         │     - no suffix collisions                                     │
         └─────────────────────────────┬──────────────────────────────────┘
                                       │
                                       ▼
                       ┌──────────────────────────────┐
                       │  H. EXTRACT epicc_full_data  │
                       └───────────────┬──────────────┘
                                       │
                                       ▼
                  ┌─────────────────────────────────────────┐
                  │  3. RUN `epicc <- run_epicc_etl(paths)` │
                  └─────────────────────────────────────────┘
```
