run-iex:
	iex -S mix

run:
	mix run --no-halt

get-deps:
	mix deps.get

clean-deps:
	mix deps.clean --all

compile-deps: clean-deps get-deps
	mix deps.compile

compile:
	mix compile

build-and-run: compile-deps compile run