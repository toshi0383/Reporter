.PHONY = update bootstrap sourcery test
SOURCERY ?= ./.build/debug/sourcery
PARAM = REPORTER_SWIFTPM_DEVELOPMENT=YES
SWIFT ?= swift

update:
	$(PARAM) swift package update

bootstrap:
	$(PARAM) swift build
	$(PARAM) swift package generate-xcodeproj
test:
	./scripts/test.sh
sourcery:
	$(SOURCERY) --args testimports='@testable import ReporterTests' --templates Resources/SourceryTemplates/LinuxMain.stencil --sources Tests/ --output Tests/LinuxMain.swift
