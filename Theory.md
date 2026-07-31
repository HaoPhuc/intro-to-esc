***This file is a summary of all the new knowledge I gain during the internship***


# Motivation for the project

The power output *P* of a tokamak is:
**P ~ n_T * n_D * T**
where:
*n_T* : density of tritium in the core
*n_D* : density of deuterium in the core
*T* : temperature in the core

We can see that the relation implies that the larger each parameter gets, the more power we can generate. However, as expected, there are ceilings for them.
For *T*, if it is too high, the tokamak would not be able to withstand the heat and be melted down. 
**NOTE: The exact T to be chosen and how is still unclear**

For *n_T* and *n_D*, we have Greenwald density limit n_GW -- a theoretical hard limit on total density: **n_GW > n_D + **n_T**

We know that the larger *n_T* and *n_D* are, the more gas particles we have to fuse, allowing us to generate more power. Therefore, we would want **n_T + n_D = n_ref (n_ref < n_GW)**, the largest possible.
**NOTE: The exact way to indicate n_ref is still unclear**

However, *P* is dependant on n_T * n_D so we need it to be at its maximum in order for us to generate the most power
We have **n_T * n_D = n_T * (n_ref - n_T) = n_D * (n_ ref - n_ D)** => **(n_T * n_D) max** if **n_T = n_D = 0.5 * n_ref**



# Execution
Our goal for the project has been identified as figuring out how to make **n_T = n_D = 0.5 * n_ref**. So how can we reach the desired value for the densities ? By adjusting the amount of gas pumped of course! 

However, it is a bit more complex as tritium and deuterium decay over time (need confirmation for deuterium). We have the equations for the densities:
**(n_ D)' = - alpha_1 * n_D + Gamma_D**
**(n_ T)' = - alpha_2 * n_T + Gamma_T**
where *alpha_1* and *alpha_2* are the loss rate coefficients, *Gamma_D* and *Gamma_T* are the flowrates of tritium and deuterium

We introduce the fuel ratio *r*. It is defined as:
**r = Gamma_T / (Gamma_T + Gamma_D)**
**Reason: Still not very clear, still need some confirmation.**
**Opinion: I think it shows that we care more about tritium more than deuterium, but I can't actually explain why. Also, this only shows the fraction between the 2 flowrates, so we can have multiple pairs of Gamma_D and Gamma_T for the same r, then how do we know which one to pick? Should we introduce a new parameter?**

Anyways, the goal is now slightly shifts towards trying to achieve the ideal fuel ratio *r_ideal*, at which **n_T = n_D = 0.5 * n_ref** is achieved:
**r_ideal = alpha_2 / (alpha_1 + alpha_2)**
**NOTE: Should write more clearly how can we reach this**
Based on this equation, we can easily adjust the flowrates. However, there is one small problem: we don't know *alpha_1* and *alpha_2* and they may vary over time.