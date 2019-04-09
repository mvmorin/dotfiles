atreplinit() do repl
	ENV["JULIA_PKG_DEVDIR"] = joinpath(homedir(), "wrepos")

	ENV["PLOTS*DEFAULT*BACKEND"] = "GR"
	@eval using Plots
	@eval using LinearAlgebra
	@eval using BenchmarkTools

	# Might not be worth the load time for these
	#@eval using Profile
	#@eval using ProfileView
	#@eval using Traceur

	ENV["JULIA_REVISE_INCLUDE"] = "1"
	@eval using Revise
	@async Revise.wait_steal_repl_backend()
end
