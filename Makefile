all:
	@stack ghc raspi-finance-database.hs
	@rm -rf *.hi *.o *.dyn_hi *.dyn_o
