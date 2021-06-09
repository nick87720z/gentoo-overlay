all:

manifest:
	repoman manifest

repoman:
	repoman -a -x fix

.PHONY: repoman manifest
