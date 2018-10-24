library(BRugs)
# Step 1 check model
modelCheck("backupfiles/gambia-model-res.txt") 
modelCheck("backupfiles/gambia-model-agecen-t.txt")
modelCheck("backupfiles/gambia-model-agesq.txt")
modelCheck("backupfiles/gambia-model-interaction.txt")
modelCheck("backupfiles/cross-sectionalBUGS.txt")
# Load the data 
modelData("backupfiles/gambia-data.txt")     
modelData("backupfiles/cross-sectional-data.txt")
# compile the model with two separate chains
modelCompile(numChains = 2) 
# generate initial values 
# the choice is arbitrary
# initlist <- list(alpha = 0, beta = 1, gamma = 5, logsigma2 = 1)
initlist <- list(alpha = 0, beta = 1, gamma = 5, delta = -5, logsigma2 = 1)
 # initlist <- list(p = c(0.4, 0.4, 0.1, 0.1))
modelInits("backupfiles/cross-sectional-inits1.txt", 1)
# initlist1 <- list(alpha = 10, beta = 0, gamma = -5, logsigma2 = 5)
initlist1 <- list(alpha = 10, beta = 0, gamma = -5, delta = 5, logsigma2 = 5)
modelInits(bugsData(initlist1))
modelGenInits()
# Set monitors on nodes of interest#### SPECIFY, WHICH PARAMETERS TO TRACE:
parameters <- c("alpha", "beta", "delta", "gamma", "sigma2")
# parameters <- c("alpha", "beta", "gamma", "sigma2")
parameters <- c("or", "p", "p.crit", "r0", "r1", "rd", "rr")

samplesSet(parameters)
dicSet()
# Generate 51000 iterations
modelUpdate(26000)
sample.statistics <- samplesStats("*", beg = 1001)
print(sample.statistics)
dicStats()

# postsamples <- buildMCMC("*")

# Use R2Openbugs ----------------------------------------------------------

# Let's use R2OpenBUGS to run the model again
# Call OpenBUGS to run model
dire.dir <- "/home/takeshi/ドキュメント/githubprojects/LSHTMlearningnote/"
output.dir <- "backupfiles/bugsoutput/"
drug.odir <- paste(dire.dir, output.dir, "cross-sectionalmodel/", sep = "")
 # pars <- c("alpha", "beta", "gamma", "sigma2", "res", "wt.pred", "p.pred")
 pars <- c("or", "p", "p.crit", "r0", "r1", "rd", "rr")
 
 initlist <- list(p = c(0.1, 0.2, 0.3, 0.4))
 # modelInits(bugsData(initlist))
 initlist1 <- list(p = c(0.25, 0.25, 0.25, 0.25))
 # modelInits(bugsData(initlist1))
 # modelGenInits()

library(R2OpenBUGS)
 cross_section <- bugs(data = paste(dire.dir, "backupfiles/cross-sectional-data.txt", sep = ""), parameters.to.save = pars,
                      model.file = paste(dire.dir, "backupfiles/cross-sectionalBUGS.txt", sep = ""), inits = list(initlist, initlist1),
                      n.chains = 2, n.iter = 26000,
                      n.burnin = 1000, DIC = T, working.directory = drug.odir,
                      codaPkg = TRUE)
 cross_section
 postsamples_cs <- read.bugs(cross_section)
 summary(postsamples_cs)


drug.log.sim <- bugs(data = paste(dire.dir, "backupfiles/gambia-data.txt", sep = ""), parameters.to.save = pars,
                     model.file = paste(dire.dir, "backupfiles/gambia-model-res.txt", sep = ""), inits = list(initlist, initlist1),
                     n.chains = 2, n.iter = 26000,
                     n.burnin = 1000, DIC = T, working.directory = drug.odir,
                     codaPkg = TRUE)
drug.log.sim

postsamples_N <- read.bugs(drug.log.sim)

Gambia_t.odir <- paste(dire.dir, output.dir, "gambia_t_model/", sep = "")

drug.t.sim <- bugs(data = paste(dire.dir, "backupfiles/gambia-data.txt", sep = ""), parameters.to.save = pars,
                     model.file = paste(dire.dir, "backupfiles/gambia-model-agecen-t.txt", sep = ""), inits = list(initlist, initlist1),
                     n.chains = 2, n.iter = 26000,
                     n.burnin = 1000, DIC = T, working.directory = drug.odir,
                     codaPkg = TRUE)
drug.t.sim
postsamples_t <- read.bugs(drug.t.sim)


effectiveSize(postsamples_N)
effectiveSize(postsamples_t)

summary(postsamples_N)

library(mcmcplots)
denplot(postsamples, "beta")
caterplot(postsamples, "res", labels = FALSE, col = "black",
          reorder = FALSE, style = "plain", horizontal = FALSE)
abline(h = 0, col = "red", lwd = 2)
title("Caterpillar plot: res")



# try to use BOA ----------------------------------------------------------

library(boa)
boa.menu()
