######################################################################
# Author: Christian Iliadis (July 2022)
######################################################################
# 
# *theta_sp^2.R
#
# calculates the dimensionless single-particle reduced width: 
#
# theta_sp^2
#
# results are based on Iliadis (1997), but for the more common 
# parameters: a=1.25 fm, r0=1.25 fm, a=0.65 fm, rc=1.25 fm
# [in the paper, the parameters were sligthtly different, but those
# are rarely used in papers reporting experimental spectroscopic
# factors
#
# USER INPUT
#
# - vector with cm-energies (in keV) and one value of the target
#   mass number
#
# OUTPUT
#
# - screen: values for user energies for all ell 
#
# - graph: values for all ell versus cm energy between zero and 
#          1000 keV 
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

# target mass
at <- 39

# center of mass energies (keV)

### NOTE: Since this is using interpolation, it does not work for energies > 1,000 keV. For now, take the theta_sp^2's to be at 1,000 keV for these
#en <- c(10,100,200,300,400,500,600,700,800,900,1000)
#en <- c(30.5, 96.37, 155.58, 222.7, 336.9, 419.78, 435.74, 522.2, 606.37, 666.06, 763.26, 807.22, 898.99, 1000, 1000, 1000, 1000) #1125.51, 1209.4, 1274.6, 1340.27) # NNDC Er's using Richard's Sp = 8328.437(21) keV - Some states Richard does not show in table (maybe b/c they are observed, whereas the table shows unobserved states
#en <- c(29.26, 96.17, 154.40, 221.37, 334.77, 415.42, 439.09, 521.36, 608.15, 664.05, 764.00, 809.61, 899.66, 1000, 1000, 1000, 1000) #1125.77, 1210.27, 1276.92, 1345.23) # My Er's (except for Ex = 8425 (Er = 96) and Ex = 9454 (Er = 1126), where these are calibration points, but I have C2S values for them, and I'm using Sp = 8328.18(2) keV from Meng Wang et al. 2021 Chinese Phys. C 45 030003. [Ex = 8484 (Er = 154) was also a calibration point, but it was only used when 8425 was not seen, so it was a test point for the remaining angles]
en <- c(29.1, 96.17, 154.1, 221.3, 334.7, 415.4, 439.1, 521.2, 608.0, 664.0, 763.9, 809.0, 899.6, 1000, 1000, 1000, 1000, 1000, 1000, 1000) # 1075.5, 1088.5, 1103.5, 1125.77, 1210.2, 1276.6, 1345.2 # # My Er's (except for Ex = 8425 (Er = 96) and Ex = 9454 (Er = 1126), where these are calibration points, and I'm using Sp = 8328.18(2) keV from Meng Wang et al. 2021 Chinese Phys. C 45 030003. [Ex = 8484 (Er = 154) was also a calibration point, but it was only used when 8425 was not seen, so it was a test point for the remaining angles]. 9136 keV was used as a calibration point at 20 deg, but it was a test point at 13 and 15 deg.
# -4344,-3946,-3335,-3254,-3256,-3039,-2829,-2690,-2547,-2392,-2235,-2177,-1865,-1634,-1634,-1532,-1360,-1332,-962,-872,-776,-379,-303,-240,-240,-175,-175,2,240
 
######################################################################
# NUMERICAL DATA FOR INTERPOLATION
######################################################################

# target mass grid
massgrid <- c( 16, 22, 31, 40, 50 )

# center-of mass energy grid, units keV

engrid <-   c(0,100,200,300,400,500,600,700,800,900,1000)

a16_ell0 <- c( 0.61, 0.59, 0.58, 0.55, 0.53, 0.50, 0.45, 0.42, 0.41, 0.40, 0.40 )
a16_ell1 <- c( 0.81, 0.78, 0.77, 0.75, 0.74, 0.73, 0.72, 0.71, 0.71, 0.71, 0.71 )
a16_ell2 <- c( 0.46, 0.46, 0.46, 0.47, 0.47, 0.47, 0.47, 0.47, 0.48, 0.48, 0.48 )
a16_ell3 <- c( 0.47, 0.47, 0.47, 0.47, 0.48, 0.48, 0.48, 0.48, 0.49, 0.49, 0.49 )

a22_ell0 <- c( 0.62, 0.61, 0.61, 0.60, 0.59, 0.58, 0.56, 0.55, 0.52, 0.50, 0.48 )
a22_ell1 <- c( 0.77, 0.77, 0.76, 0.76, 0.75, 0.75, 0.74, 0.73, 0.72, 0.71, 0.70 )
a22_ell2 <- c( 0.42, 0.42, 0.42, 0.42, 0.43, 0.43, 0.43, 0.44, 0.44, 0.44, 0.44 )
a22_ell3 <- c( 0.42, 0.42, 0.42, 0.42, 0.43, 0.43, 0.43, 0.44, 0.44, 0.44, 0.44 )

a31_ell0 <- c( 0.58, 0.58, 0.58, 0.58, 0.58, 0.57, 0.57, 0.57, 0.57, 0.57, 0.57 )
a31_ell1 <- c( 0.71, 0.71, 0.71, 0.71, 0.71, 0.71, 0.71, 0.71, 0.71, 0.70, 0.70 )
a31_ell2 <- c( 0.37, 0.37, 0.37, 0.38, 0.38, 0.38, 0.38, 0.39, 0.39, 0.40, 0.40 )
a31_ell3 <- c( 0.37, 0.37, 0.37, 0.38, 0.38, 0.38, 0.38, 0.39, 0.39, 0.40, 0.40 )

a40_ell0 <- c( 0.52, 0.52, 0.52, 0.53, 0.53, 0.53, 0.54, 0.54, 0.54, 0.54, 0.55 )
a40_ell1 <- c( 0.65, 0.65, 0.65, 0.66, 0.66, 0.66, 0.67, 0.67, 0.67, 0.68, 0.68 )
a40_ell2 <- c( 0.31, 0.31, 0.32, 0.32, 0.32, 0.33, 0.33, 0.34, 0.34, 0.35, 0.35 )
a40_ell3 <- c( 0.31, 0.31, 0.32, 0.32, 0.32, 0.33, 0.33, 0.34, 0.34, 0.35, 0.35 )

a50_ell0 <- c( 0.48, 0.49, 0.49, 0.49, 0.49, 0.50, 0.50, 0.50, 0.51, 0.51, 0.51 )
a50_ell1 <- c( 0.58, 0.58, 0.58, 0.59, 0.59, 0.59, 0.60, 0.60, 0.61, 0.61, 0.62 )
a50_ell2 <- c( 0.28, 0.28, 0.28, 0.29, 0.29, 0.29, 0.29, 0.30, 0.30, 0.30, 0.31 )
a50_ell3 <- c( 0.28, 0.28, 0.28, 0.29, 0.29, 0.29, 0.29, 0.30, 0.30, 0.30, 0.31 )

# read data into matices:
## rows: energies; columns: target mass

## ell=0
matrix_ell0 <- cbind ( a16_ell0, a22_ell0, a31_ell0, a40_ell0, a50_ell0 )
## ell=1
matrix_ell1 <- cbind ( a16_ell1, a22_ell1, a31_ell1, a40_ell1, a50_ell1 )
## ell=2
matrix_ell2 <- cbind ( a16_ell2, a22_ell2, a31_ell2, a40_ell2, a50_ell2 )
## ell=3
matrix_ell3 <- cbind ( a16_ell3, a22_ell3, a31_ell3, a40_ell3, a50_ell3 )

######################################################################
# FUNCTION FOR 2D INTERPOLATION
######################################################################
# k: labels mass grid

value <- function(at, energy, matrix_ell){

  rw_a <- vector()

  # interpolation in energy for all masses
  for ( k in 1:5 ) {
     rw_a[k] <- approx( engrid, matrix_ell[ , k], energy )$y
  }
  # interpolation in mass
  rw_e <- approx( massgrid, rw_a, at )$y

  return(rw_e)
  
}

######################################################################
# OUTPUT
######################################################################

cat("\n")
cat("CAREFUL: ", "\n")
cat("these values are for channel radius 1.25 fm, and optical ", "\n")
cat("model parameters r0=1.25 fm, a=0.65 fm, rc=1.25 fm ", "\n")

cat("\n")
cat("=============================================", "\n")
cat("Target mass number: A =", at, "\n")
cat("\n")
cat("Ecm (keV) ", "   theta_sp^2", "\n")
cat("=============================================", "\n")

################################
# CALCULATE dimensionless single-particle reduced widths

cat("ell=0", "\n")
for(i in 1:length(en)){
    cat( format( en[i], width = 6), "      ", format( value( at, en[i], matrix_ell0 ), 
    digits = 3 ), "\n" )
}
cat("\n")

cat("ell=1", "\n")
for(i in 1:length(en)){
    cat( format( en[i], width = 6), "      ", format( value( at, en[i], matrix_ell1 ), 
    digits = 3 ), "\n" )
}
cat("\n")

cat("ell=2", "\n")
for(i in 1:length(en)){
    cat( format( en[i], width = 6), "      ", format( value( at, en[i], matrix_ell2 ), 
    digits = 3 ), "\n" )
}
cat("\n")

cat("ell=3", "\n")
for(i in 1:length(en)){
    cat( format( en[i], width = 6), "      ", format( value( at, en[i], matrix_ell3 ), 
    digits = 3 ), "\n" )
}
cat("\n")

######################################################################
# PLOT CURVES FOR USER TARGET MASS NUMBER INPUT
######################################################################

theta_ell0 <- vector()
for(j in 1:length(engrid)){
   theta_ell0[j] <- value( at, engrid[j], matrix_ell0 )
}

theta_ell1 <- vector()
for(j in 1:length(engrid)){
   theta_ell1[j] <- value( at, engrid[j], matrix_ell1 )
}

theta_ell2 <- vector()
for(j in 1:length(engrid)){
   theta_ell2[j] <- value( at, engrid[j], matrix_ell2 )
}

theta_ell3 <- vector()
for(j in 1:length(engrid)){
   theta_ell3[j] <- value( at, engrid[j], matrix_ell3 )
}

pdf("theta_sp^2.pdf",width=6,height=5,onefile=F)
par(mfcol=c(1,1), mar=c(4.0,4.5,4.0,3.0), oma=c(0.5,1.5,0.5,0.0), tck=0.02, 
     las=1)

# plot axes only...add lines...then data
plot( 1, type="n", lwd=2 , col="black" , xlim=c(0, 1100), ylim=c( 0, 1), 
       axes=FALSE, main="", xlab = "", ylab = "", log="", yaxs='i', xaxs='i' )
# control distance between axis and label [line=...]
title(xlab = expression(paste(E [cm], " (keV)")), line=2.5, cex.lab=1.5)
title(ylab = expression(paste(theta[sp]^2)), line=2.0, cex.lab=1.5)

grid(nx = 22, ny = 20,
     lty = 2,      # Grid line type
     col = "gray", # Grid line color
     lwd = 1)
     
# control distance tick mark labels and axis
# don't touch first number
# second number controls distance tick mark labels and axis
# don't touch third number
magaxis(mgp=c(0,0.4,0), cex.axis=1.1)
box()

# plot legend
legend(900, 0.35, 
      legend=c("2s", "2p" ,"1d", "1f"),
	  pch=c("-", "-", "-", "-"), 
	  col=c("red","blue", "darkgreen", "black")
	        )

#text(500, 0.9, labels=expression(paste("A = ", at)), cex=1.2)
mtext(paste("A = ", at), side = 3, line = 0.5, at = 500, cex = 1.2)

# add lines
lines( engrid, theta_ell0, col="red", lt=1, lw=1.5 )
lines( engrid, theta_ell1, col="blue", lt=1, lw=1.5 )
lines( engrid, theta_ell2, col="darkgreen", lt=1, lw=1.5 )
lines( engrid, theta_ell3, col="black", lt=1, lw=1.5 )

dev.off()


