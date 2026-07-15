sync:
	rsync -av --delete --exclude='justfile' --exclude='README.md' --exclude='.gitignore' --exclude='.git/' /etc/nixos/ ./
