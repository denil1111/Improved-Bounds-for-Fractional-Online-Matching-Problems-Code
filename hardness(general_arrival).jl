using Plots
a = []
b = []
for i = 0.4:0.01:1
    push!(a,solve(i,500))
    push!(b,i)
#     println(i,":",solve(i,1000))
end
println(solve(0.584,500))
plot(0.4:0.01:1,a,label="r(x)",linewidth=2,fmt = :png)

plot!(0.4:0.01:1,b,label="y=x",linewidth=2,fmt = :png)
plot!([0.5841],linetype=:vline, linestyle = :dash, xticks=([0.4,0.584,0.8,1.0],[0.4,"0.584",0.8,1.0]),linewidth=2, label = "")