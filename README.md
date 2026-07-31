***This is the journal for my internship at DIFFER in summer 2026***

This README file, specially, is used as a summary for the whole project. The detailed updates for the weeks however, for readability, are noted in separated files and named *Week ...*.

The materials provided by my supervisor, **Juan Javier Palacios Roman**, are located in the *materials* folder. 



**Week 1: 22/07 - 28/07**

**Week 2: 29/07 - 04/08**

**Week 3: 05/08 - 11/08**

**Week 4: 12/08 - 18/08**

**Week 5: 19/08 - 25/08**


# I am writing this on my IPad as I am currently on a train with my laptop left at my friend's house, and I am writing the journal for the first week but haven't commited it. So I am writing this as a placeholder until I get my laptop back, then I will paste this into my journal
# continue after the P formula 
We can see that the relation implies that the larger each parameter gets, the more power we can generate. However, as expected, there are ceilings for them.
For *T*, if it is too high, the tokamak would not be able to withstand the heat and be melted down. 
# The exact T to be chosen and how is still unclear
For *n_T* and *n_D*, we have ... (paste in the GW)
We know that the larger *n_T* and *n_D* are, the more gas particles we have to fuse, allowing us to generate more power. Therefore, we would want **n_T + n_D = n_ref (n_ref < n_GW)**, the largest possible.
# The exact way to indicate n_ref is still unclear
However, *P* is dependant on n_T * n_D so we need it to be at its maximum in order for us to generate the most power
We have n_T * n_D = n_T * (n_ref - n_T) = n_D * (n_ ref - n_ D) => (n_T * n_D) max if n_T = n_D = 0.5 * n_ref

So how can we adjust n_T and n_D so that they reach the desired value of 0.5 * n_ ref? By adjusting the amount of gas pumped of course. However, it is a bit more complex as tritium and deuterium decay over time (need confirmation for deuterium). Therefore, we have the equations for the densities:
(n_ D)' = - alpha_1 * n_D + Gamma_D
(n_ T)' = - alpha_2 * n_T + Gamma_T
where alpha_1 and alpha_2 are the loss rate coefficients, Gamma_D and Gamma_T are the flowrates of tritium and deuterium

why is there the fuel ratio?

# stop because of headache