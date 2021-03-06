#!/usr/bin/env tclsh

set dir [file dirname [info script]]

lappend auto_path [file normalize [file join $dir ..]]
package require ghclip

source [file join $dir testutils.tcl]

_init

_suite "vertex" {
    {
        set v1 [ghclip::vertex create {40 10}]
        _assert_eq [$v1 getp coord] {40 10}
    }
    {
        set v1 [ghclip::vertex create {20 30}]
        _assert_eq [$v1 getp coord] {20 30}
    }
    {
        set v1 [ghclip::vertex create {10.0 10.0}]
        _assert_eq [$v1 getp coord] {10.0 10.0}
    }
    {
        set v1 [ghclip::vertex create ]
        _assert_eq [$v1 getp coord] {0 0}
    }
    {
        set v1 [ghclip::vertex create {0 0}]
        _assert_eq [$v1 getp next] null
        _assert_eq [$v1 getp prev] null
        _assert_eq [$v1 getp neighbor] null
        _assert_eq [$v1 getp is_intersection] 0
        _assert_eq [$v1 getp entry] -1
    }
}

_suite "poly" {
    {
        set poly {200 200 250 200 250 250 200 250}
        set pobj [ghclip::polygon create $poly]
        _assert_eq [$pobj get_poly] $poly
        _assert_eq [[$pobj get_start] getp coord] {200 200}
        _assert_eq [[[$pobj get_start] getp next] getp coord] {250 200}
        _assert_eq [[[$pobj get_start] getp prev] getp coord] {200 250}
        _assert_eq [llength [$pobj get_vertices]] 4
    }
    {
        # Closed
        set poly {200 200 250 200 250 250 200 250 200 200}
        set pobj [ghclip::polygon create $poly]
        _assert_eq [$pobj get_poly] [lrange $poly 0 end-2]
        _assert_eq [[$pobj get_start] getp coord] {200 200}
        _assert_eq [[[$pobj get_start] getp next] getp coord] {250 200}
        _assert_eq [[[$pobj get_start] getp prev] getp coord] {200 250}
        _assert_eq [llength [$pobj get_vertices]] 4
    }
    {
        # winding number
        set poly {200 200 250 200 250 250 200 250}
        set pobj [ghclip::polygon create $poly]
        _assert_eq [$pobj encloses [ghclip::vertex create {225 225}]] 1
        _assert_eq [$pobj encloses [ghclip::vertex create {100 100}]] 0
    }
    {
        # winding number with self intersection
        set poly {
            100 300
            300 300
            300 150
            150 150
            150 200
            250 200
            250 250
            200 250
            200 100
            100 100
        }
        set pobj [ghclip::polygon create $poly]
        _assert_eq [$pobj encloses [ghclip::vertex create {0 0}]] 0
        _assert_eq [$pobj encloses [ghclip::vertex create {100 100}]] 1
        _assert_eq [$pobj encloses [ghclip::vertex create {175 175}]] 0
        _assert_eq [$pobj encloses [ghclip::vertex create {225 225}]] 0
    }
    {
        # Vertex insertion in between
        set poly [ghclip::polygon create {0 0 10 10}]
        set v1 [$poly get_start]
        set v2 [$v1 getp next]
        set v3 [$poly insert_between 5 5 0.5 $v1 $v2]
        _assert_eq [$v1 getp prev] $v2
        _assert_eq [$v1 getp next] $v3
        _assert_eq [$v2 getp prev] $v3
        _assert_eq [$v2 getp next] $v1
        _assert_eq [$v3 getp prev] $v1
        _assert_eq [$v3 getp next] $v2
        _assert_eq [set ${v3}::alpha] 0.5
        _assert_eq [$v3 getp is_intersection] 0
    }
}

_summarize
