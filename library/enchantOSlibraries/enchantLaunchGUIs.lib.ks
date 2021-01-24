//enchantLaunchGUIs.lib.ks
//this will hold the functions which draw guis in the Launch automation
//stack box inside EnchantOS

function createApoapsisSelectWidgets {
  local promptApoapsis is 
  consoleGUI:
  WIDGETS[5]:
  WIDGETS[1]:
  WIDGETS[2]:
  WIDGETS[0]:ADDLABEL("Apoapsis of Ascent:").
  local apoapsisLayout is
  consoleGUI:
  WIDGETS[5]:
  WIDGETS[1]:
  WIDGETS[2]:
  WIDGETS[0]:ADDHLAYOUT().
  local apoapsisField is apoapsisLayout:ADDTEXTFIELD(launchDefaults:defApoapsis).
  set apoapsisField:STYLE:WIDTH to 69.
  set apoapsisField:ONCONFIRM to apoapsisConfirmed@:BIND(
    apoapsisField
  ).
  local apoapsisUpInc is apoapsisLayout:ADDBUTTON("/\").
  set apoapsisUpInc:STYLE:WIDTH to 25.
  set apoapsisUpInc:ONCLICK to apoapsisUp@:BIND(apoapsisUpInc).
  local apoapsisDownInc is apoapsisLayout:ADDBUTTON("\/").
  set apoapsisDownInc:STYLE:WIDTH to 25.
  set apoapsisDownInc:ONCLICK to apoapsisDown@:BIND(apoapsisDownInc).
  local apoapsisTargetSet is apoapsisLayout:ADDBUTTON("Set").
  set apoapsisTargetSet:STYLE:WIDTH to 45.
  set apoapsisTargetSet:ONCLICK to targetApoapsisSet@:BIND(apoapsisTargetSet).
}

function createAscentHeadingSelectWidgets {
  local promptHeading is
  consoleGUI:
  WIDGETS[5]:
  WIDGETS[1]:
  WIDGETS[2]:
  WIDGETS[0]:ADDLABEL("Ascent Heading:").
  local headingLayout is
  consoleGUI:
  WIDGETS[5]:
  WIDGETS[1]:
  WIDGETS[2]:
  WIDGETS[0]:ADDHLAYOUT().
  local headingDropdown is headingLayout:ADDPOPUPMENU().
  set headingDropdown:TEXT to launchDefaults:defaultHeading.
  set headingDropdown:OPTIONS to headingOptions:KEYS.
  set headingDropdown:ONCHANGE to headingChosen@.
  local headingTargetSet is headingLayout:ADDBUTTON("Set").
  set headingTargetSet:STYLE:WIDTH to 45.
  set headingTargetSet:ONCLICK to targetHeadingSet@:BIND(headingTargetSet).
}

function createGLoadLimitSelectWidgets {
  local promptGLoad is
  consoleGUI:
  WIDGETS[5]:
  WIDGETS[1]:
  WIDGETS[2]:
  WIDGETS[0]:ADDLABEL("G-Load limit:").
  local gLimitLayout is
  consoleGUI:
  WIDGETS[5]:
  WIDGETS[1]:
  WIDGETS[2]:
  WIDGETS[0]:ADDHLAYOUT().
  local gLimitField is gLimitLayout:ADDLABEL(launchDefaults:defaultGLoad).
  set gLimitField:STYLE:TEXTCOLOR to RGBA(0.9921569, 0.8117647, 0, 1).
  set gLimitField:STYLE:FONTSIZE to 18.
  set gLimitField:STYLE:ALIGN to "CENTER".
  local gLimitUpInc is gLimitLayout:ADDBUTTON("/\").
  set gLimitUpInc:STYLE:WIDTH to 25.
  set gLimitUpInc:ONCLICK to gLimitUp@:BIND(gLimitUpInc).
  local gLimitDownInc is gLimitLayout:ADDBUTTON("\/").
  set gLimitDownInc:STYLE:WIDTH to 25.
  set gLimitDownInc:ONCLICK to gLimitDown@:BIND(gLimitDownInc).
  local gLimitSet is gLimitLayout:ADDBUTTON("Set").
  set gLimitSet:STYLE:WIDTH to 45.
  set gLimitSet:ONCLICK to gLimitSetClicked@:BIND(gLimitSet).
}

function createResetConfirmCloseButtons {
  local resetLaunchParameters is 
  consoleGUI:
  WIDGETS[5]:
  WIDGETS[1]:
  WIDGETS[2]:
  WIDGETS[0]:ADDBUTTON("Reset All").
  set resetLaunchParameters:ONCLICK to launchParametersReset@:BIND(
    resetLaunchParameters
  ).
  local confirmAndLaunchButton is
  consoleGUI:
  WIDGETS[5]:
  WIDGETS[1]:
  WIDGETS[2]:
  WIDGETS[0]:ADDBUTTON("Confirm and Launch").
  set confirmAndLaunchButton:STYLE:VSTRETCH to true.
  set confirmAndLaunchButton:STYLE:FONTSIZE to 17.
  set confirmAndLaunchButton:ONCLICK to confirmAndLaunchClicked@:BIND(
    confirmAndLaunchButton
  ).
  local closeLnchAuto is
  consoleGUI:
  WIDGETS[5]:
  WIDGETS[1]:
  WIDGETS[2]:
  WIDGETS[0]:ADDBUTTON("Close").
  set closeLnchAuto:ONCLICK to closeAutomationClicked@:BIND(closeLnchAuto).
}

function createPostLiftoffReadouts {
  local trgtApReadout is
  consoleGUI:
  WIDGETS[5]:
  WIDGETS[1]:
  WIDGETS[2]:
  WIDGETS[0]:ADDLABEL("Target Apoapsis: ~").
  set trgtApReadout:TEXT to trgtApReadout:TEXT + launchDefaults:defApoapsis.
  set trgtApReadout:TEXT to trgtApReadout:TEXT:REMOVE(20,3).
  set trgtApReadout:TEXT to trgtApReadout:TEXT + " km".
  local trgtHdingReadout is
  consoleGUI:
  WIDGETS[5]:
  WIDGETS[1]:
  WIDGETS[2]:
  WIDGETS[0]:ADDLABEL("Launch Heading: ").
  local defHeadingString is headingOptions:Equatorial:TOSTRING.
  set trgtHdingReadout:TEXT to trgtHdingReadout:TEXT + defHeadingString.
  set trgtHdingReadout:TEXT to trgtHdingReadout:TEXT + " deg".
  local trgtPitchReadout is
  consoleGUI:
  WIDGETS[5]:
  WIDGETS[1]:
  WIDGETS[2]:
  WIDGETS[0]:ADDLABEL("Target Pitch: 90 deg").
  local currentGsReadout is
  consoleGUI:
  WIDGETS[5]:
  WIDGETS[1]:
  WIDGETS[2]:
  WIDGETS[0]:ADDLABEL("Current G-Force: ").
  local statusReadout is
  consoleGUI:
  WIDGETS[5]:
  WIDGETS[1]:
  WIDGETS[2]:
  WIDGETS[0]:ADDLABEL("Standing by to Launch...").
  set statusReadout:STYLE:TEXTCOLOR to YELLOW.
}

function createPostLiftoffButtons {
  local editorRevert is
  consoleGUI:
  WIDGETS[5]:
  WIDGETS[1]:
  WIDGETS[2]:
  WIDGETS[0]:ADDBUTTON("Revert to Editor").
  set editorRevert:ONCLICK to revertToEditorClicked@.
  local launchRevert is
  consoleGUI:
  WIDGETS[5]:
  WIDGETS[1]:
  WIDGETS[2]:
  WIDGETS[0]:ADDBUTTON("Revert to Launch").
  set launchRevert:ONCLICK to revertToLaunchClicked@.
  local throttOverride is
  consoleGUI:
  WIDGETS[5]:
  WIDGETS[1]:
  WIDGETS[2]:
  WIDGETS[0]:ADDBUTTON("Override Throttle").
  set throttOverride:ONCLICK to throttleOverrideClicked@:BIND(throttOverride).
  local launchAbortButton is
  consoleGUI:
  WIDGETS[5]:
  WIDGETS[1]:
  WIDGETS[2]:
  WIDGETS[0]:ADDBUTTON("Abort Launch").
  set launchAbortButton:STYLE:TEXTCOLOR to RGBA(1, 0, 0, 0.6).
  set launchAbortButton:STYLE:FONTSIZE to 30.
  set launchAbortButton:STYLE:WORDWRAP to true.
  set launchAbortButton:STYLE:HEIGHT to 80.
  set launchAbortButton:ONCLICK to abortLaunch@.
  local launchConcludeButton is
  consoleGUI:
  WIDGETS[5]:
  WIDGETS[1]:
  WIDGETS[2]:
  WIDGETS[0]:ADDBUTTON("Conclude Launch").
  set launchConcludeButton:STYLE:FONTSIZE to 30.
  set launchConcludeButton:STYLE:WORDWRAP to true.
  set launchConcludeButton:STYLE:HEIGHT to 80.
  set launchConcludeButton:ONCLICK to switchToPrelaunch@:BIND(
    launchConcludeButton:PARENT
  ).
}
