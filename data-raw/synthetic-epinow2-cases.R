library(EpiNow2)
library(data.table)

options(mc.cores = 4)

# set up example generation time
generation_time <- get_generation_time(disease = "SARS-CoV-2", source = "ganyani")
# set delays between infection and case report
incubation_period <- get_incubation_period(disease = "SARS-CoV-2", source = "lauer")
reporting_delay <- list(mean = convert_to_logmean(3, 1), mean_sd = 0.1,
                        sd = convert_to_logsd(3, 1), sd_sd = 0.1, max = 15)

# fit model to data to recover realistic parameter estimates and define settings
# shared simulation settings
init <- estimate_infections(example_confirmed[1:100],
                            generation_time = generation_time,
                            delays = delay_opts(incubation_period, reporting_delay),
                            rt = rt_opts(prior = list(mean = 2, sd = 0.1), rw = 14),
                            gp = NULL, horizon = 0,
                            obs = obs_opts(scale = list(mean = 0.1, sd = 0.025)))


# update Rt trajectory and simulate new infections using it
sims <- simulate_infections(init, noisy_R, samples = 10)
plot(sims)

usethis::use_data(synthetic-epinow2-cases, overwrite = TRUE)
