library(data.table)
library(EpiNow2)

# define generation time scenarios
gt <- data.table(
  length = c("short", "medium", "long"),
  mean = c(3, 6, 18),
  sd = list(c(1, 3, 9))
)
gt <- gt[, .(sd = unlist(sd)), by = c("length", "mean")]

# define uncertainty
gt <- gt[, `:=`(mean_sd_list = list(c(1, 3, 6)),
                        sd_sd_list = list(c(0.1, 1, 2)))]
gt <- gt[, .(as.data.table(.SD), mean_sd = unlist(mean_sd_list)), by = .N]
gt <- gt[, .(as.data.table(.SD), sd_sd = unlist(sd_sd_list)), by = .N]
gt <- gt[, c("mean_sd_list", "sd_sd_list") := NULL]

# add max delay allowed (based on mean and 3 * sd)
gt <- gt[, max := mean + 3 * sd]

# set up id and add as data
gt <- gt[, id := 1:.N]
setcolorder(gt, c("id", "length"))
generation_time_scenarios <- gt
usethis::use_data(generation_time_scenarios, overwrite = TRUE)

