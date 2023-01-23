######################################################################
# Author: Christian Iliadis (August 2021)
######################################################################
# 
# calculates the quantity:    2*((hbar**2)/(M*R**2))*P
#
######################################################################
# preparation: remove all variables from the work space
rm(list=ls())

require(gsl) 
require(RcppGSL)
library(sfsmisc) 
library(plotrix)
library(emdbook)
library(magicaxis)

######################################################################
# USER INPUT
######################################################################

# charge target
z0 <- 19

# NUCLEAR mass target
m0 <- 38.9533

# charge projectile
z1 <- 1

# NUCLEAR mass projectile 
m1 <- 1.00727646749

# channel radius parameter r_0 (fm)
r0 <- 1.25

# maximum ell value
ellmax <- 3

# center of mass energies (MeV)
#en <- c(10, 100, 200, 300, 400, 500, 600, 700, 800, 900, 1000)
#en <- c(30.5, 96.37, 155.58, 222.7, 336.9, 419.78, 435.74, 522.2, 606.37, 666.06, 763.26, 807.22, 898.99, 1125.51, 1209.4, 1274.6, 1340.27) # NNDC Er's using Richard's Sp = 8328.437(21) keV - Some states Richard does not show in table (maybe b/c they are observed, whereas the table shows unobserved states
#en <- c(29.26, 96.17, 154.40, 221.37, 334.77, 415.42, 439.09, 521.36, 608.15, 664.05, 764.00, 809.61, 899.66, 1125.77, 1210.27, 1276.92, 1345.23) # My Er's (except for Ex = 8425 (Er = 96) and Ex = 9454 (Er = 1126), where these are calibration points, but I have C2S values for them, and I'm using Sp = 8328.18(2) keV from Meng Wang et al. 2021 Chinese Phys. C 45 030003. [Ex = 8484 (Er = 154) was also a calibration point, but it was only used when 8425 was not seen, so it was a test point for the remaining angles]
en <- c(29.1, 96.17, 154.1, 221.3, 334.7, 415.4, 439.1, 521.2, 608.0, 664.0, 763.9, 809.0, 899.6, 1075.5, 1088.5, 1103.5, 1125.77, 1210.2, 1276.6, 1345.2) # My Er's (except for Ex = 8425 (Er = 96) and Ex = 9454 (Er = 1126), where these are calibration points, and I'm using Sp = 8328.18(2) keV from Meng Wang et al. 2021 Chinese Phys. C 45 030003. [Ex = 8484 (Er = 154) was also a calibration point, but it was only used when 8425 was not seen, so it was a test point for the remaining angles]. 9136 keV was used as a calibration point at 20 deg, but it was a test point at 13 and 15 deg.
#en <- c(9.6,30.5,36,45.50,96.37,110.6,155.58,212,222.7,250.36,259,305,336.9,349.85,372.6,389,419.78,435.74,482,522.2,580.6,606.37,607.4,610.0,650,833.7,917.6,1034.10,1171.5,1340.27,1540.9,1625.56,1729.6,1802.26,1990.36)
#en <- c(0.0037, 0.108, 0.1217, 0.1947, 0.2147)
#en <- c( 268, 1962 )
#en <- c( 100, 200, 500 )


######################################################################
# convert keV to MeV
enx <- en/1e3

######################################################################
# FUNCTION TO COMPUTE PENETRATION FACTORS
######################################################################

penetration <- function(z0, z1, mue, ra, en, ell){

  # constants
  pek <- 6.56618216e-1/mue

  ## incoming channel 
 
  eta_a = 0.1574854 * z0 * z1 * sqrt(mue)
  rho_a = 0.218735 * ra * sqrt(mue)      
  eta_i = eta_a / (sqrt(en))
  rho_i = rho_a * (sqrt(en))
  P3 <- coulomb_wave_FG(eta_i, rho_i, ell, k=0)
  # penetration and shift factor 
  pen <- rho_i / (P3$val_F^2 + P3$val_G^2)

  return(Pen = pen)
  
}

######################################################################
# CHANNEL RADIUS
ra <- r0 * ( m0^(1/3) + m1^(1/3) ) 

# REDUCED MASS
mue <- (m0*m1)/(m0+m1)

# WIGNER LIMIT: wl = hbar**2/M*R**2 IN MeV
  wl <- 41.80161396 / (mue * ra^2)

### LOOP
cat("", "\n")
cat("=============================================", "\n")
cat("Ecm (keV)", "Pene. factor", "  2((hbar^2)/(M R^2))P (eV)", "\n")
cat("=============================================", "\n")
cat("Wigner limit = (hbar^2)/(m * R^2) = ", wl*1e6, "eV", "\n")
cat("", "\n")

for(ell in 0:ellmax) {

################################
# CALCULATE PENETRABILITIES

  pen <- penetration(z0, z1, mue, ra, enx, ell)
  #print(pen)

################################
# CALCULATE SINGLE PARTICLE WIDTHS
#
# 2*((hbar**2)/(M*R**2))*P
  #print(wl)

  gamma <- 2 * wl * pen
  #print(gamma)

################################
# OUTPUT

cat("ell =", ell, "\n")
for(i in 1:length(en)){
    cat(en[i], "   ", pen[i], "   ", 1e6 * gamma[i], "\n")
}
cat("", "\n")

}
