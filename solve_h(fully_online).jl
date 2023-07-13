#solve h in the fully online model, the optimized ratio is a lower bound for the competitive raito.
using Gurobi
using JuMP
lpRatio = Model(with_optimizer(Gurobi.Optimizer))
n=100
eeps=1//n

@variable(lpRatio, ratio >= 0)
@objective(lpRatio, Max, ratio)

@variable(lpRatio, h[0:eeps:1,0:eeps:1] >= 0)

for y=eeps:eeps:1
    @constraint(lpRatio, h[y,1] == 1) # Constraint (15)
    @constraint(lpRatio, h[y,1] <= 1) # Constraint (15)
    for x=y+eeps:eeps:1
        @constraint(lpRatio, h[y,x] >= h[y,x-eeps]) # Monotonicity
        @constraint(lpRatio, h[y,x] <= h[y,x-eeps] + 4 * eeps) # Lipschitzness
    end
    for x=eeps:eeps:y
        @constraint(lpRatio, h[x-eeps,y] <= h[x,y]) # Monotonicity
        @constraint(lpRatio, h[x-eeps,y] + 4*eeps >= h[x,y]) # Lipschitzness
    end
end

for au=eeps:eeps:1
    for pu=au:eeps:1-eeps
        av=1-pu
        for pv=av:eeps:1
            @constraint(lpRatio, ratio <= pu*h[au,pu] - 1/2*eeps*sum(h[au,z]+h[au,z+eeps] for z=au:eeps:pu-eeps) 
                                        + pv*h[av,pv] - 1/2*eeps*sum(h[av,z]+h[av,z+eeps] for z=av:eeps:pv-eeps)
                                        + (1-pv)*(1-h[au,pu]) - 5 * eeps * eeps) # Constraint (14)
        end
    end
end

for av=eeps:eeps:1
    for pv=av:eeps:1
        @constraint(lpRatio, ratio <= pv*h[av,pv] - 1/2*eeps*sum(h[av,z]+h[av,z+eeps] for z=av:eeps:pv-eeps) + 1-pv - 5/2 * eeps * eeps)  # Constraint (13)
    end
end

status = optimize!(lpRatio)

println("Objective value: ", getobjectivevalue(lpRatio))