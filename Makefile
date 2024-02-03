# by default: get the base url from the cname file with prefix https:// and suffix /
BASE_URL = $(shell cat CNAME | sed 's/^/https:\/\//' | sed 's/$$/\//')

.PHONY: decrypt local render

check:
	@echo "Checking for `sops` command"
	@command -v sops >/dev/null 2>&1 || (echo "sops not found" && exit 1)
	@echo "Checking for `hugo` command"
	@command -v hugo >/dev/null 2>&1 || (echo "hugo not found" && exit 1)

decrypt:
	@echo "Checking for secrets.enc.cfg file"
	@ [ -f secrets.enc.cfg ] || (echo "secrets.enc.cfg not found" && exit 1)
	@echo "Decrypting secrets.enc.cfg"
	@sops -d secrets.enc.cfg > ./secrets.cfg
	@echo "Making secrets.cfg available to the environment variables"
	@. ./secrets.cfg

local: decrypt
	@echo "Starting local server with drafts enabled and fast render disabled"
	hugo serve --disableFastRender --buildDrafts

render: decrypt
	@echo "Rendering..."
	@echo "Base URL: $(BASE_URL)"
	hugo \
		--gc \
		--minify \
		--baseURL "$(BASE_URL)"
