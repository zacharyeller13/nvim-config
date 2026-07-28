local function new_jq_buffer()
    local bufnr = vim.api.nvim_create_buf(false, true)
    vim.bo[bufnr].buftype = "prompt"
    vim.bo[bufnr].filetype = "jq"
    vim.api.nvim_open_win(bufnr, true, { split = "right" })
    return bufnr
end
vim.keymap.set("n", "<leader>jq", function()
    local filename = vim.fn.expand("%")

    -- If this is an unnamed buffer then just write to a tempfile
    if filename == "" then
        filename = vim.fn.tempname()
        local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
        vim.uv.fs_open(filename, "w", tonumber("644", 8), function(err, fd)
            if err then
                vim.notify(err, vim.log.levels.ERROR)
                return
            end
            vim.uv.fs_write(fd, lines)
            vim.uv.fs_close(fd)
        end)
    end

    local bufnr = new_jq_buffer()

    local resbufnr = vim.api.nvim_create_buf(false, true)
    local reswin = -1
    vim.bo[resbufnr].filetype = "json"

    vim.fn.prompt_setcallback(bufnr, function(text)
        vim.system(
            { vim.o.shell, vim.o.shellcmdflag, string.format("jq '%s' '%s'", text, filename) },
            { text = true },
            function(out)
                local res_text = ""
                if out.code ~= 0 then
                    res_text = out.stderr or "unknown error"
                else
                    res_text = out.stdout or ""
                end
                local res = vim.split(res_text, "\n", { trimempty = true, plain = true })
                vim.schedule(function()
                    vim.api.nvim_buf_set_lines(resbufnr, 0, -1, false, res)
                    if not vim.api.nvim_win_is_valid(reswin) then
                        reswin = vim.api.nvim_open_win(resbufnr, false, { split = "below" })
                    end
                end)
            end
        )
    end)
end, { buf = 0, noremap = true })
