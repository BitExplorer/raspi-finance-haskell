all:
	@stack ghc raspi-finance.hs
	@rm -rf *.hi *.o *.dyn_hi *.dyn_o
