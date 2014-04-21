using BinDeps

@BinDeps.setup

libglut = library_dependency("libglut", aliases = ["libglut", "freeglut"])

@windows_only begin
	using WinRPM
	provides(WinRPM.RPM, "freeglut", libglut, os = :Windows)
end

@linux_only begin
    provides(AptGet, {"freeglut3-dev" => libglut})
    provides(Yum, {"freeglut-devel" => libglut})
end

@BinDeps.install [:libglut => :libglut]
