CHAPTERS := */

.PHONY: clean
clean:
	rm -f *~ \#*
	for chapter in $(CHAPTERS); do \
		$(MAKE) clean -C $$chapter; \
	done
