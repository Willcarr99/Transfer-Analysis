## Calculate the elastic scattering optical model potentials from
## An, H., Phys. Rev. C 73, 054605 (2006)

#E <- 18.7*22/20    # deuteron energy in MeV
#A <- 20      # Target mass in AMU
#Z <- 10      # Target charge
E <- 21.0-2.8347    # deuteron energy in MeV
A <- 40      # Target mass in AMU
Z <- 20       # Target charge

###############################################
## Real Parts
V <- 91.85-0.249*E+0.000116*E^2+0.642*Z/A^{1/3}
rr <- 1.152-0.00776*A^{-1/3}
ar <- 0.719+0.0126*A^{1/3}

## Imaginary Surface parts
Ws <- 10.83-0.0306*E
rs <- 1.334+0.152*A^{-1/3}
as <- 0.531+0.062*A^{1/3}

## Imaginary Volume parts
Wv <- 1.104+0.0622*E
rv <- 1.305+0.0997*A^{-1/3}
av <- 0.855-0.100*A^{1/3}

## Spin-Orbit parts
Vso <- 3.557
rso <- 0.972
aso <- 1.011

## Coulomb radius
rc <- 1.303

##############################################
cat("\nThe Parameters obtained from")
cat(" An, H., Phys. Rev. C 73, 054605 (2006):\n")

cat("\n--- Coulomb Part ---\n")
cat("rc  =",formatC(rc,digits=3,format="f"),"\n")

cat("\n--- Real Parts ---\n")
cat("V   =",formatC(V,digits=3,format="f"),"\n")
cat("rr  = ",formatC(rr,digits=3,format="f"),"\n")
cat("ar  = ",formatC(ar,digits=3,format="f"),"\n")

cat("\n--- Imaginary Surface Parts ---\n")
cat("Ws  = ",formatC(Ws,digits=3,format="f"),"\n")
cat("rs  = ",formatC(rs,digits=3,format="f"),"\n")
cat("as  = ",formatC(as,digits=3,format="f"),"\n")

cat("\n--- Imaginary Volume Parts ---\n")
cat("Wv  = ",formatC(Wv,digits=3,format="f"),"\n")
cat("rv  = ",formatC(rv,digits=3,format="f"),"\n")
cat("av  = ",formatC(av,digits=3,format="f"),"\n")

cat("\n--- Spin-Orbit Parts ---\n")
cat("Vso = ",formatC(Vso,digits=3,format="f"),"\n")
cat("rso = ",formatC(rso,digits=3,format="f"),"\n")
cat("aso = ",formatC(aso,digits=3,format="f"),"\n")

cat("-------------------------------\n\n")

