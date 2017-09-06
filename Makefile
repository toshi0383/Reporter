.PHONY = update bootstrap sourcery
SOURCERY ?= ./.build/debug/sourcery
PARAM = SWIFTPM_DEVELOPMENT=YES

update:
	$(PARAM) swift package update

bootstrap:
	$(PARAM) swift build
	$(PARAM) swift package generate-xcodeproj
sourcery:
	$(SOURCERY) --templates Resources/SourceryTemplates/LinuxMain.stencil --sources Tests/ --output Tests/LinuxMain.swift
