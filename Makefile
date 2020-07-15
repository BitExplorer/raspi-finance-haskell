all:
	@stack ghc raspi-finance-data.hs
	@rm -rf *.hi *.o *.dyn_hi *.dyn_o
