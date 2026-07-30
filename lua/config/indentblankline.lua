require("ibl").setup({

    indent = {
        char = "▏", -- slightly thinner
        smart_indent_cap = true,     },
    
    -- highlights the block of code you are currently in
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
