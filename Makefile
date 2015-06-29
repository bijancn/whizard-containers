USER = thomega

all: whizard trunk tools build_env

trunk: whizard-trunk.stamp
whizard: whizard-2.2.6.stamp
tools: whizard_tools.stamp
build_env: whizard_build_env.stamp

%.stamp: %/Dockerfile
	docker build -t "$(USER)/$*" $*/
	touch $@

%/Dockerfile: %/Dockerfile.m4
	m4 macros.m4 $< > $@

whizard-trunk.stamp: whizard_tools.stamp whizard_build_env.stamp
whizard-2.2.6.stamp: whizard_tools.stamp whizard_build_env.stamp
whizard_tools.stamp: whizard_build_env.stamp

whizard_build_env.stamp: whizard_build_env/wgetx

clean:
	rm -f *.stamp *~ */*~

realclean: clean
	docker rm `docker ps -aq`
	docker rmi `docker images -q`