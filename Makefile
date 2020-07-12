all:
	@stack ghc raspi-finance-haskell.hs
	@rm -rf *.hi *.o *.dyn_hi *.dyn_o
