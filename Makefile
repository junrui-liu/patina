.PHONY: deploy
deploy: clean build
	@echo "====> deploying to github"
	git worktree add /tmp/book gh-pages
	cp -rp book/* /tmp/book/
	cd /tmp/book && \
		git add -A && \
		git commit -m "deployed on $(shell date) by ${USER}" && \
		git push origin gh-pages

.PHONY: build
build:
	mdbook build

.PHONY: clean
clean: 
	git worktree remove --force /tmp/book 
	rm -rf /tmp/book/*
