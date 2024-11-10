return {
  -- If encountering errors, see telescope-fzf-native README for installation instructions
  -- `build` is used to run some command when the plugin is installed/updated.
  -- This is only run then, not every time Neovim starts up.
  -- `cond` is a condition used to determine whether this plugin should be
  -- installed and loaded.
  "nvim-telescope/telescope-fzf-native.nvim",
  build = function(plugin)
    local obj = vim.system({ "cmake", "-S.", "-Bbuild", "-DCMAKE_BUILD_TYPE=Release" }, { cwd = plugin.dir }):wait()
    if obj.code ~= 0 then error(obj.stderr) end
    obj = vim.system({ "cmake", "--build", "build", "--config", "Release" }, { cwd = plugin.dir }):wait()
    if obj.code ~= 0 then error(obj.stderr) end
    obj = vim.system({ "cmake", "--install", "build", "--prefix", "build" }, { cwd = plugin.dir }):wait()
    if obj.code ~= 0 then error(obj.stderr) end
  end,
}
