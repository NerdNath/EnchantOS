//guiTools.lib.ks
//A collection of functions for abstracting away gui actions

//requires a lexicon with the correct keys.
//I know this may not be ideal because it
//will probably be hard to remember the
//correct keys to use in the future when
//using this thing.
function initGUI {
  parameter valuesLexicon.

  set someGui to gui(valuesLexicon:width, valuesLexicon:height).
  set someGui:X to valuesLexicon:xPos.
  set someGui:Y to valuesLexicon:yPos.
  set someGui:DRAGGABLE to valuesLexicon:isDraggable.
  if not(valuesLexicon:hint = "none") { //this statement is here because
  // the TOOLTIP suffix seems to break things. This needs refactoring probably
    set someGui:TOOLTIP to valuesLexicon:hint.
  }
  return someGui.
}

//work in progress shutdown function for callback method quit buttons

function terminateProgram {
  parameter scriptsGUI. //The main gui of the program, which should be closed
  set terminateCommanded to true.//the program MUST have this variable!
  scriptsGUI:DISPOSE.
  core:DOEVENT("open terminal").
}

//switches to a stack box it is given (theoretically)
function switchStackTo {
  parameter chosenStack.
  parameter exclusionLex is lexicon("none",false).
  parameter doLastStackSet is false.
  chosenStack:PARENT:SHOWONLY(chosenStack).// makes an error if on outer panel
  if exclusionLex:HASKEY("none") {
    reshowGUIsChildren(chosenStack).
  } else {
    reshowGUIsChildren(chosenStack, exclusionLex).
  }
  if doLastStackSet = true { // remembers what the last stack was
    declare global lastStack to chosenStack.
  }
}

//made for using after calling a SHOWONLY() suffix on a box
function reshowGUIsChildren {
  parameter widget.
  parameter excludeLexicon is lexicon("none", false).
  if widget:INHERITANCE:CONTAINS("Box") {
    for childWidget in widget:WIDGETS {
      if childWidget:HASSUFFIX("TEXT") {
        if excludeLexicon:HASKEY(childWidget:TEXT) {
          if excludeLexicon[childWidget:TEXT] = false {
            // print "doing nothing on " + childWidget:TEXT.
          } else {
            // print "doing something on " + childWidget:TEXT.
            childWidget:SHOW.
            //reshowGUIsChildren(childWidget, excludeLexicon).
          }
        }
      } else {
        //widget:SHOW.
        reshowGUIsChildren(childWidget, excludeLexicon).
      }
    }
  }
}

//theoretically should find a gui with TEXT suffix in a tree, and hide it
function findAndHideLabelGUI {
  parameter guiToSearch. //must be a box type widget object
  parameter labelToFind. //must be a string found in the text of target label

  for widget in guiToSearch:WIDGETS {
    if widget:INHERITANCE:CONTAINS("Box") {
      findAndHideLabelGUI(widget,labelToFind).
    } else if widget:HASSUFFIX("TEXT") {
      if widget:TEXT = labelToFind {
        widget:HIDE.
      }
    } else {
      core:DOEVENT("open terminal").
      print "WARNING: error in findAndHideLabelGUI.".
    }
  }
}

//A funtion to simplify alerts output to gui program users
function userAlert {
  parameter alertString.
  HUDTEXT(alertString, 3, 2, 30, RED, true).
}

//hide's every gui in a box
function hideAllChildren {
  parameter boxToSearch.

  for widget in boxToSearch:WIDGETS {
    widget:HIDE.
  }
}