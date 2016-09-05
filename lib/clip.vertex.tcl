
package provide clip::vertex 1.0

namespace eval clip::vertex {
    namespace export create
    namespace export insert_after

    variable counter 0 
}


proc clip::vertex::create {{x 0} {y 0} {prev null} {next null}} {
    # Create new vertex as a namespace with ensemle sub commands
    # Namespaces are tracked with $clip::vertex::counter
    # 
    # Sub commands:
    #   set -- x y
    #     Sets the coordinate for the vertex. Defaults to (0, 0) if not specified.
    #   get
    #     Returns the coordinate as a 2-item list
    puts "INFO: Creating vertex with coordinates: ($x, $y)"
    variable counter

    set name V_${counter}
    namespace eval $name {
        namespace export setc
        namespace export getc
        namespace export set_prev
        namespace export set_next
        namespace export get_prev
        namespace export get_next
        namespace export set_neighbor
        namespace export get_neighbor
        namespace export set_is_intersection
        namespace export get_is_intersection

        variable x 0
        variable y 0
        variable next "null"
        variable prev "null"
        variable neighbor "null"
        variable is_intersection 0

        proc setc {X Y} {
            variable x
            variable y
            set x $X
            set y $Y
        }

        proc getc {} {
            variable x
            variable y
            return [list $x $y]
        }
        
        proc set_prev {Prev} {
            variable prev
            set prev $Prev
        }

        proc set_next {Next} {
            variable next
            set next $Next
        }

        proc get_prev {} {
            variable prev
            return $prev
        }

        proc get_next {} {
            variable next
            return $next
        }

        proc set_neighbor {Neighbor} {
            variable neighbor
            set neighbor $Neighbor
        }

        proc get_neighbor {} {
            variable neighbor
            return $neighbor
        }

        proc set_is_intersection {I} {
            variable is_intersection
            set is_intersection $I
        }

        proc get_is_intersection {} {
            variable is_intersection
            return $is_intersection
        }
        
        namespace ensemble create
    }

    $name setc $x $y
    $name set_prev $prev
    $name set_next $next
    incr counter
    return "::clip::vertex::$name"
}

# Inserts new vertex after the provided vertex
proc clip::vertex::insert_after {x y first} {
    set second [$first get_next]
    set new [create $x $y $first $second]
    $first set_next $new
    $second set_prev $new
    return $new
}


