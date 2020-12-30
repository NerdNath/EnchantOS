//enchantLaunchGUIs.lib.ks
//this will hold the functions which draw guis in the Launch automation
//stack box inside EnchantOS

function createApoapsisSelectWidgets {
  set promptApoapsis to launchBox:ADDLABEL("Apoapsis of Ascent:").
  set apoapsisLayout to launchBox:ADDHLAYOUT().
  set apoapsisField to apoapsisLayout:ADDTEXTFIELD(launchDefaults:defApoapsis).
  set apoapsisField:STYLE:WIDTH to 69.
  set apoapsisField:ONCONFIRM to apoapsisConfirmed@.
  set apoapsisUpInc to apoapsisLayout:ADDBUTTON("/\").
  set apoapsisUpInc:STYLE:WIDTH to 25.
  set apoapsisUpInc:ONCLICK to apoapsisUp@.
  set apoapsisDownInc to apoapsisLayout:ADDBUTTON("\/").
  set apoapsisDownInc:STYLE:WIDTH to 25.
  set apoapsisDownInc:ONCLICK to apoapsisDown@.
  set apoapsisTargetSet to apoapsisLayout:ADDBUTTON("Set").
  set apoapsisTargetSet:STYLE:WIDTH to 45.
  set apoapsisTargetSet:ONCLICK to targetApoapsisSet@.
}

function createAscentHeadingSelectWidgets {
  set promptHeading to launchBox:ADDLABEL("Ascent Heading:").
  set headingLayout to launchBox:ADDHLAYOUT().
  set headingDropdown to headingLayout:ADDPOPUPMENU().
  set headingDropdown:TEXT to launchDefaults:defaultHeading.
  set headingDropdown:OPTIONS to headingOptions:KEYS.
  set headingDropdown:ONCHANGE to headingChosen@.
  set headingTargetSet to headingLayout:ADDBUTTON("Set").
  set headingTargetSet:STYLE:WIDTH to 45.
  set headingTargetSet:ONCLICK to targetHeadingSet@.
}

function createGLoadLimitSelectWidgets {
  set promptGLoad to launchBox:ADDLABEL("G-Load limit:").
  set gLimitLayout to launchBox:ADDHLAYOUT().
  set gLimitField to gLimitLayout:ADDLABEL(launchDefaults:defaultGLoad).
  set gLimitField:STYLE:TEXTCOLOR to RGBA(0.9921569, 0.8117647, 0, 1).
  set gLimitField:STYLE:FONTSIZE to 18.
  set gLimitField:STYLE:ALIGN to "CENTER".
  set gLimitUpInc to gLimitLayout:ADDBUTTON("/\").
  set gLimitUpInc:STYLE:WIDTH to 25.
  set gLimitUpInc:ONCLICK to gLimitUp@.
  set gLimitDownInc to gLimitLayout:ADDBUTTON("\/").
  set gLimitDownInc:STYLE:WIDTH to 25.
  set gLimitDownInc:ONCLICK to gLimitDown@.
  set gLimitSet to gLimitLayout:ADDBUTTON("Set").
  set gLimitSet:STYLE:WIDTH to 45.
  set gLimitSet:ONCLICK to gLimitSetClicked@.
}

function createResetConfirmCloseButtons {
  set resetLaunchParameters to launchBox:ADDBUTTON("Reset All").
  set resetLaunchParameters:ONCLICK to launchParametersReset@.
  set confirmAndLaunchButton to launchBox:ADDBUTTON("Confirm and Launch").
  set confirmAndLaunchButton:STYLE:VSTRETCH to true.
  set confirmAndLaunchButton:STYLE:FONTSIZE to 17.
  set confirmAndLaunchButton:ONCLICK to confirmAndLaunchClicked@.
  set closeLaunchAutomation to launchBox:ADDBUTTON("Close").
  set closeLaunchAutomation:ONCLICK to closeAutomationClicked@.
}

function createPostLiftoffReadouts {
  set trgtApReadout to launchBox:ADDLABEL("Target Apoapsis: ~").
  set trgtApReadout:TEXT to trgtApReadout:TEXT + launchDefaults:defApoapsis.
  set trgtApReadout:TEXT to trgtApReadout:TEXT:REMOVE(20,3).
  set trgtApReadout:TEXT to trgtApReadout:TEXT + " km".
  set trgtHdingReadout to launchBox:ADDLABEL("Launch Heading: ").
  set defHeadingString to headingOptions:Equatorial:TOSTRING..
  set trgtHdingReadout:TEXT to trgtHdingReadout:TEXT + defHeadingString.
  set trgtHdingReadout:TEXT to trgtHdingReadout:TEXT + " deg".
  set trgtPitchReadout to launchBox:ADDLABEL("Target Pitch: 90 deg").
  set currentGsReadout to launchBox:ADDLABEL("Current G-Force: ").
  set statusReadout to launchBox:ADDLABEL("Staging!...").
  set statusReadout:STYLE:TEXTCOLOR to YELLOW.
}

function createPostLiftoffButtons {
  set editorRevert to launchBox:ADDBUTTON("Revert to Editor").
  set editorRevert:ONCLICK to revertToEditorClicked@.
  set launchRevert to launchBox:ADDBUTTON("Revert to Launch").
  set launchRevert:ONCLICK to revertToLaunchClicked@.
  set throttOverride to launchBox:ADDBUTTON("Override Throttle").
  set throttOverride:ONCLICK to throttleOverrideClicked@.
  set launchAbortButton to launchBox:ADDBUTTON("Abort Launch").
  set launchAbortButton:STYLE:TEXTCOLOR to RGBA(1, 0, 0, 0.6).
  set launchAbortButton:STYLE:FONTSIZE to 30.
  set launchAbortButton:STYLE:WORDWRAP to true.
  set launchAbortButton:STYLE:HEIGHT to 80.
  set launchAbortButton:ONCLICK to abortLaunch@.
}