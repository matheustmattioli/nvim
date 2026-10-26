require("ibl").setup({
    indent = {
        char = "▏",
        smart_indent_cap = true,     },
    
    scope = {
        enabled = true,
        show_start = true,   
        show_end = false,    
        injected_languages = true,
    },
    
    
    exclude = {
        filetypes = {
            "help",
            "alpha",
            "dashboard",
            "neo-tree",
            "NvimTree",
            "Trouble",
            "lazy",
            "mason",
            "lspinfo",
        },
        buftypes = {
            "terminal",
            "nofile",
            "prompt",
            "quickfix",
        },
    },
})
