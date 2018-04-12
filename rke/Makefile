ANBIN = ansible-playbook
ANSIBLE = $(ANBIN) $(ANFLAGS)
TFBIN = terraform
TERRAFORM = $(TFBIN) $(TFLAGS)
RKEBIN = rke_v0.1.1

.PHONY: all plan apply destroy update deploy

all: init plan apply deploy

init:
	$(TERRAFORM) init

terraform.tfplan: *.tf
	$(TERRAFORM) plan -out $@

update:
	$(TERRAFORM) get -update

plan: update terraform.tfplan

apply:
	terraform apply
	terraform output  workers_ips > workers_ips.json
	terraform output  masters_ips > masters_ips.json

destroy:
	$(TERRAFORM) plan -destroy -out terraform.tfplan
	$(TERRAFORM) apply terraform.tfplan

deploy:
	if [ -f 'gce.tf' ]; then \
		python3 render.py ubuntu; \
	elif [ -f 'digitalocean.tf' ]; then \
	    python3 render.py rancher; \
	fi

	sleep 90

	./bin/$(RKEBIN) up

	# copy the generated kubectl config file to your default ~/.kube/config file
	#cat kube_config_cluster.yml >> ~/.kube/config

	export KUBECONFIG=kube_config_cluster.yml
	
	kubectl create serviceaccount tiller --namespace kube-system
	kubectl create -f k8s-config/tiller-clusterrolebinding.yaml
	helm init --service-account tiller

	sleep 30

	helm install stable/heapster --name heapster --set rbac.create=true --namespace kube-system

	helm install --name wp-meetup \
	--set mariadb.persistence.enabled=false,ingress.enabled=true,persistence.enabled=false \
	stable/wordpress

clean: destroy
	rm -f terraform.tfplan
	rm -f terraform.tfstate
	rm -fR .terraform/
	rm -f terraform.tfstate.backup
	rm workers_ips.json
	rm masters_ips.json
	rm cluster.yml
	rm kube_config_cluster.yml
