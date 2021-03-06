module Limon_Parser

import JSON

export
    parse_limon,
    example_limon_file,
    AST

limon_parser_executable = "../limon-parser/limon-parser"
example_limon_file = "../limon-parser/example-program"

struct AST{T}
    branches
end

make_AST(const_node::AbstractString) = 
    const_node

make_AST(node) =
    AST{Val{Symbol(node[1])}}(Dict(map((key, value) ->
                                       (key, make_AST(value)),
                                       keys(node[2]), values(node[2]))))

Base.getindex(node::AST, key) = node.branches[key]


function parse_limon(limon_file::AbstractString; print_json=false)
    program_json_str = read(`$limon_parser_executable $limon_file`,
                            String)
    program_json = JSON.parse(program_json_str)
    if print_json
        JSON.print(program_json)
    end
    ast = make_AST(program_json)
    return ast
end
    
end # module Limon_Parser
