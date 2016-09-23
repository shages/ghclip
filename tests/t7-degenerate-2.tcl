#!/usr/bin/env tclsh

package require Tk

set dir [file dirname [info script]]
lappend auto_path [file normalize [file join $dir ..]]
package require ghclip

source [file join $dir testutils.tcl]

set poly1 {50 50 50 150 150 150 150 50}
set poly2 {50 50 40 150 150 150}

_clip_test 0 0 {}       [list $poly1 $poly2]
_clip_test 0 1 {OR}     [list $poly1 $poly2]
_clip_test 0 2 {AND}    [list $poly1 $poly2]
_clip_test 0 3 {XOR}    [list $poly1 $poly2]
_clip_test 0 4 {NOT} [list $poly1 $poly2]

