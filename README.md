# Transfer Reaction Analysis with the [FRESCO](https://github.com/I-Thompson/fresco) Nuclear Reaction Code

## Using the Distorted-Wave Born Approximation (DWBA) to calculate model-dependent experimental quantities, such as spectroscopic factors C<sup>2</sup>S and proton partial widths &Gamma;<sub>p</sub> for the <sup>39</sup>K(<sup>3</sup>He, d)<sup>40</sup>Ca proton-transfer reaction from spectrum data obtained from the Enge Split-Pole Spectrograph at the Triangle Universities Nuclear Laboratory.

## The analysis is part of my [Ph.D. dissertation](https://github.com/Willcarr99/PhDThesis) and first [Physical Review Letters](https://link.aps.org/doi/10.1103/PhysRevLett.132.062701) paper.

### Both experimental and theoretical (DWBA) cross sections are computed. All theoretically allowed nlj (node, orbital angular momentum, total angular momentum) single-particle configurations are considered for each state based on the assigned spin-parities J<sup>&pi;</sup> from [ENSDF](https://www.nndc.bnl.gov/nudat3/getdataset.jsp?nucleus=40Ca&unc=NDS)<sup>&#10013;</sup>. Each of these DWBA nlj cross sections is normalized to the corresponding experimental cross section, and the models are selected based on a &chi;<sup>2</sup> minimization.

</br>

![7532keV_Norm](https://github.com/Willcarr99/Transfer-Analysis/assets/55559733/40462361-5f53-4bf7-8425-9df8a4775480)
Fig. 1:  Experimental and (normalized) DWBA cross sections of the 7532 keV <sup>40</sup>Ca state. J<sup>&pi;</sup> = 2<sup>-</sup> from ENDSF, so 8 possible nlj combinations. L=1 is the clear match.

</br></br></br>

![mixed-l-6025keV](https://github.com/Willcarr99/Transfer-Analysis/assets/55559733/c954b466-4ddf-48d8-b19c-d8fc6e9844f4)
Fig. 2:  Mixed angular momentum case for the 6025 keV <sup>40</sup>Ca state

### Entrance and exit channels for DWBA are described by Optical Model Potentials (OMPs), where this analysis uses the global <sup>3</sup>He entrance channel (<sup>39</sup>K + <sup>3</sup>He) OMP of [Liang et al. (2009)](https://iopscience.iop.org/article/10.1088/0954-3899/36/8/085104) and the global deuteron exit channel (<sup>40</sup>Ca + d) OMP of [An and Cai (2006)](https://link.aps.org/doi/10.1103/PhysRevC.73.054605). Elastic scattering cross sections from these OMPs are computed with [FRESCO](https://github.com/I-Thompson/fresco).

### Experimental cross sections (both proton-transfer and elastic scattering) from the Enge Split-Pole Spectrograph's [focal plane detector](https://ieeexplore.ieee.org/document/8418462) are normalized to the elastic scattering cross section of a Silicon detector positioned at a constant 45<sup>&deg;</sup> from the beamline inside the target chamber. This is to remove uncertainties from the target properties (thickness, stoichiometry, nonuniformities) and the beam current. An absolute scale is then achieved by normalizing the relative cross sections to the elastic scattering (<sup>39</sup>K + <sup>3</sup>He) cross section of the global <sup>3</sup>He OMP of [Liang et al. (2009)](https://iopscience.iop.org/article/10.1088/0954-3899/36/8/085104).

#### <sup>&#10013;</sup>When no single angular momentum model accounts for the experimental distribution, either 1.) Mixed angular momentum cases are considered, or 2.) New J<sup>&pi;</sup>-values are considered.
