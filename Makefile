CoverageDir=luacov
CoverageReport=$(CoverageDir)/luacov.report.out
CoverageHtmlDir=$(CoverageDir)/coverage

coverage-setup:
	rm -rf $(CoverageDir)/*.out
	mkdir -p $(CoverageDir)

test:
	busted

test-coverage: coverage-setup
	busted --coverage
	luacov-console
	luacov-console --summary

test-report: coverage-setup
	rm -rf $(CoverageHtmlDir)
	busted --coverage
	luacov -r lcov
	sed -i "s/,[0-9a-f]\+\?$$//g" $(CoverageReport)
	genhtml $(CoverageReport) -o $(CoverageHtmlDir)
	@echo "View your coverage report here: $(CoverageHtmlDir)/index.html"

clean:
	rm -rf $(CoverageDir)
