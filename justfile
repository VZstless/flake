sync:
	rsync -av --delete --exclude='justfile' --exclude='README.md' --exclude='.git/' /etc/nixos/ ./
