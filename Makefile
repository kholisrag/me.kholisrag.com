# by default: get the base url from the cname file with prefix https:// and suffix /
BASE_URL = $(shell cat CNAME | sed 's/^/https:\/\//' | sed 's/$$/\//')

.PHONY: decrypt local render

check:
	@echo "Checking for sops command"
	@command -v sops >/dev/null 2>&1 || (echo "sops not found" && exit 1)
	@echo "Checking for hugo command"
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

watch-latest-actions:
	@echo "Checking for gh command"
	@command -v gh >/dev/null 2>&1 || (echo "gh not found" && exit 1)
	@echo "Watching latest actions"
	@gh run watch

act:
	@echo "Checking for act command"
	@command -v act >/dev/null 2>&1 || (echo "act not found" && exit 1)
	@echo "Checking for .actrc file"
	@ [ -f .actrc ] && (echo ".actrc found") || (echo ".actrc not found")
	@echo "Create Local Artifact Directory..."
	@mkdir -p ./temp/artifacts
	@echo "Running act..."
	@act
