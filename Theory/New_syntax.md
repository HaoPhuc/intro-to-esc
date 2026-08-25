*I am not proficient at MATLAB yet so I am using this internship as a chance to develop my skillset*

# 1. `ss()` — Build a continuous-time state-space model

`ss(A, B, C, D)`

Short for: state-space - a structured way of writing a system of differential equations. For a system with state *x*, input *u*, output *y*

Represents: 
`dx/dt = A*x + B*u`
&
`y = C*x + D*u`

- *A*: state matrix (system dynamics)
- *B*: input matrix (how input drives the state)
- *C*: output matrix (how state maps to output)
- *D*: feedthrough matrix (direct input-to-output coupling, often 0)

Example (first-order decay driven by an input):
sys = ss(-decay_rate, 1, 1, 0);

---
