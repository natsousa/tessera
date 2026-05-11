# Regenerate the cohort dataset that ships with the package.
# Run with: Rscript data-raw/generate_cohort.R
library(tessera)
crc_cohort <- simulate_crc_cohort(n = 5000, seed = 42)
usethis::use_data(crc_cohort, overwrite = TRUE)
