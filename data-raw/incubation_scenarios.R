library(data.table)
library(EpiNow2)

# define incubation periods
incubation <- data.table(
  length = c("short", "medium", "long"),
  mean = c(3, 6, 9),
  sd = list(c(1, 3, 9))
)
incubation <- incubation[, .(sd = unlist(sd)), by = c("length", "mean")]

# convert to logmean and logsd for log normal
incubation <- incubation[, `:=`(meanlog = convert_to_logmean(mean, sd),
                                sdlog = convert_to_logsd(mean, sd))]
incubation <- incubation[, lapply(.SD, round, 2), .SDcols = is.numeric, by = "length"]

# define uncertainty
incubation <- incubation <- incubation[, `:=`(mean_sd = 0.1, sd_sd = 0.1)]

# add max delay allowed (based on mean and 3 * sd)
incubation <- incubation[, max := mean + 3 * sd]

# add no incubation period scenario
incubation <- rbindlist(list(data.table(length = "none"), incubation),
                        use.names = TRUE, fill = TRUE)

# set up id and add as data
incubation <- incubation[, id := 1:.N]
setcolorder(incubation, c("id", "length"))
incubation_scenarios <- incubation
usethis::use_data(incubation_scenarios, overwrite = TRUE)
