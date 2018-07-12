.PHONY = update bootstrap sourcery test
SOURCERY ?= sourcery
SWIFT ?= swift

update:
	swift package update

bootstrap:
	swift build
	swift package generate-xcodeproj
test:
	./scripts/test.sh
sourcery:
	$(SOURCERY) --args testimports='@testable import ReporterTests' --templates Resources/SourceryTemplates/LinuxMain.stencil --sources Tests/ --output Tests/LinuxMain.swift
