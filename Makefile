greeting:
	@echo "=== DEPLOY HUGO WEBSITE ==="
	@read -p "Tekan [Ctrl + C] untuk membatalkan. Tekan tombol apa saja untuk melanjutkan."

build-site:
	@hugo

commit-source-and-push:
	@git -C . add .
	@git -C . commit -m "Rebuilding site"
	@git -C . push origin master

commit-public-and-push:
	@git -C public add .
	@git -C public commit -m "Rebuilding site"
	@git -C public push origin master

deploy: greeting build-site commit-source-and-push commit-public-and-push

deploy-public: greeting build-site commit-public-and-push

serve:
	@hugo serve -D