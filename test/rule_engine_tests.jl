using Test
using StaticArrays

# is_point_in_bounds
@test is_point_in_bounds(Int8(-10)) == false
@test is_point_in_bounds(Int8(5)) == true
@test is_point_in_bounds(Int8(10)) == false

# is_position_in_bounds
@test is_position_in_bounds(SVector(Int8(-1), Int8(-1))) == false
@test is_position_in_bounds(SVector(Int8( 3), Int8( 0))) == false
@test is_position_in_bounds(SVector(Int8( 1), Int8( 1))) == true
@test is_position_in_bounds(SVector(Int8(10), Int8(10))) == false

# diagonal_projection
@test diagonal_projection(SVector(Int8( 0), Int8( 0)))  ==  0
@test diagonal_projection(SVector(Int8( 2), Int8( 2)))  ==  4
@test diagonal_projection(SVector(Int8(-2), Int8(-2)))  == -4

# perpendicular_projection
@test perpendicular_projection(SVector(Int8(0),Int8(0))) ==  0
@test perpendicular_projection(SVector(Int8(2),Int8(2))) ==  0
@test perpendicular_projection(SVector(Int8(2),Int8(3))) == -1
@test perpendicular_projection(SVector(Int8(3),Int8(2))) ==  1

# start positions : P₀ = {(p₁, p₂) | pᵢ ∈ [1, 9], p₁ + p₂ ≤ 5}
start_positions =  SVector{10}(map(
    p -> SVector{2}(Int8(p[1]), Int8(p[2])),
    [ 
        [1 1], [1 2], [2 1], [3 1], [2 2],
        [1 3], [4 1], [3 2], [2 3], [1 4]
    ]
))

# target positions : P₁ = {(p₁, p₂) | pᵢ ∈ [1, 9], p₁ + p₂ ≥ 13}
target_positions = map(
    p -> SVector{2}(Int8(10 - p[1]), Int8(10 - p[2])), 
    start_positions
)

# is_position_open
Positions = vcat(start_positions, target_positions)
@test is_position_open(SVector(Int8(1), Int8(1)), Positions) == false
@test is_position_open(SVector(Int8(3), Int8(1)), Positions) == false
@test is_position_open(SVector(Int8(3), Int8(2)), Positions) == false
@test is_position_open(SVector(Int8(4), Int8(4)), Positions) == true
@test is_position_open(SVector(Int8(5), Int8(1)), Positions) == true

# is_move_forward
@test is_move_forward(SVector(Int8( 1), Int8( 1)), Int8(1) ) == true
@test is_move_forward(SVector(Int8(-1), Int8( 1)), Int8(1))  == true
@test is_move_forward(SVector(Int8(-1), Int8(-1)), Int8(1))  == false
@test is_move_forward(SVector(Int8(-1), Int8(-1)), Int8(-1)) == true
@test is_move_forward(SVector(Int8(-1), Int8( 1)), Int8(-1)) == true
@test is_move_forward(SVector(Int8(-1), Int8(-1)), Int8(1))  == false
@test is_move_forward(SVector(Int8(0 ), Int8( 0)), Int8(1))  == true


# is_position_valid
@test is_position_valid(SVector(Int8(4),  Int8(4)), Positions) == true
@test is_position_valid(SVector(Int8(5),  Int8(1)), Positions) == true
@test is_position_valid(SVector(Int8(10), Int8(1)), Positions) == false
@test is_position_valid(SVector(Int8(1),  Int8(1)), Positions) == false

# unit moves : Ω = {(m₁, m₂) | mᵢ ∈ {-1, 0, 1}, m₁ + m₂ ≤ 2}
unit_moves = SVector{6}(map(
    m -> SVector{2}(Int8(m[1]), Int8(m[2])),
    [ 
        [1 0], [-1 0], [0 1], [0 -1], [-1 1], [1 -1]
    ]
))

# get_unit_moves
@test get_unit_moves(SVector(Int8(1), Int8(1)), Positions) == []
@test get_unit_moves(SVector(Int8(4), Int8(1)), Positions) == SVector(
    SVector(Int8(1), Int8(0)),
    SVector(Int8(0), Int8(1))
)
@test get_unit_moves(SVector(Int8(9), Int8(9)), Positions) == []
@test get_unit_moves(SVector(Int8(6), Int8(9)), Positions) == SVector(
    SVector(Int8(-1), Int8(0)),
    SVector(Int8(0), Int8(-1))
)

# is_double_move_open
@test is_double_move_open(SVector(Int8(1), Int8(1)), unit_moves[1], Positions) == false
@test is_double_move_open(SVector(Int8(3), Int8(1)), unit_moves[1], Positions) == true
@test is_double_move_open(SVector(Int8(3), Int8(1)), unit_moves[3], Positions) == true
@test is_double_move_open(SVector(Int8(9), Int8(9)), unit_moves[2], Positions) == false
@test is_double_move_open(SVector(Int8(7), Int8(9)), unit_moves[2], Positions) == true
@test is_double_move_open(SVector(Int8(7), Int8(9)), unit_moves[4], Positions) == true
@test is_double_move_open(SVector(Int8(1), Int8(2)), unit_moves[6], Positions) == false

# get_double_moves
@test get_double_moves(SVector(Int8(2), Int8(2)), Positions) == [
    SVector(Int8(2), Int8(0)),
    SVector(Int8(0), Int8(2))
]

start_positions_2 =  SVector{10}(map(
    p -> SVector{2}(Int8(p[1]), Int8(p[2])),
    [ 
        [1 1], [1 2], [2 1], [3 1], [2 2],
        [1 3], [4 1], [3 3], [2 3], [1 4]
    ]
))
Positions_2 = vcat(start_positions_2,target_positions)

@test get_double_moves(SVector(Int8(1), Int8(2)), Positions_2) == [
    SVector(Int8(2), Int8(0)),
    SVector(Int8(2), Int8(2))
]

# replace_position
@test replace_position(SVector(Int8(3), Int8(3)), Int8(8), start_positions) == start_positions_2
