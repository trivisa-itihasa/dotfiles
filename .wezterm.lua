local wezterm = require("wezterm")
local act = wezterm.action

-- 設定ビルダーを作成（エラーハンドリング等が向上するため推奨）
local config = {}
if wezterm.config_builder then
	config = wezterm.config_builder()
end

-- ============================================================
-- OSごとの設定分岐
-- ============================================================
local target = wezterm.target_triple
local is_windows = target:find("windows") ~= nil
local is_mac = target:find("apple") ~= nil

if is_windows then
	-- 【Windows設定】
	config.default_domain = "WSL:Ubuntu-24.04"
	config.win32_system_backdrop = "Acrylic"

	-- Windowsはフォント描画が異なるため、サイズを微調整しても良い
	config.font_size = 12.0
elseif is_mac then
	-- 【Mac設定】
	config.font_size = 12.0
	config.default_prog = { "/bin/zsh", "-l" }
	config.macos_window_background_blur = 20

	-- Mac特有のキーバインディング（OptionキーをMetaとして扱うなど）が必要ならここへ
	config.send_composed_key_when_left_alt_is_pressed = true
	config.send_composed_key_when_right_alt_is_pressed = true
else
	-- 【Linux設定】
	config.font_size = 12.0
	config.default_prog = { "/bin/zsh" }
	config.kde_window_background_blur = true
end

-- ============================================================
-- 共通設定
-- ============================================================

config.initial_cols = 100
config.initial_rows = 40
config.cell_width = 1.0
config.line_height = 1.0
config.color_scheme = "iceberg-dark"

config.font = wezterm.font_with_fallback({
	{ family = "MonoLisa Nerd Font", weight = "Regular" },
	{ family = "Line Seed JP", weight = "Regular" },
	{ family = "BIZ UDGothic", weight = "Regular" },
})

config.use_fancy_tab_bar = false
config.hide_tab_bar_if_only_one_tab = true
config.window_background_opacity = 0.85
config.text_background_opacity = 1.0

-- 閉じる際の確認をスキップするプロセス
config.skip_close_confirmation_for_processes_named =
	{ "bash", "sh", "zsh", "fish", "tmux", "nu", "cmd.exe", "pwsh.exe", "powershell.exe" }

config.window_padding = {
	left = 0,
	right = 0,
	top = 0,
	bottom = 0,
}

-- リーダーキー設定
config.leader = { key = "q", mods = "CTRL", timeout_milliseconds = 1000 }

-- キーバインディング
config.keys = {
	{ key = "c", mods = "LEADER", action = act.SpawnTab("CurrentPaneDomain") },
	{ key = "q", mods = "LEADER", action = act.CloseCurrentTab({ confirm = true }) },
	{ key = "n", mods = "LEADER", action = act.ActivateTabRelative(1) },
	{ key = "p", mods = "LEADER", action = act.ActivateTabRelative(-1) },
	{ key = "w", mods = "LEADER", action = act.ShowTabNavigator },

	{ key = "v", mods = "LEADER", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
	{ key = "s", mods = "LEADER", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
	{ key = "x", mods = "LEADER", action = act.CloseCurrentPane({ confirm = true }) },
	{ key = "z", mods = "LEADER", action = act.TogglePaneZoomState },

	{ key = "h", mods = "LEADER", action = act.ActivatePaneDirection("Left") },
	{ key = "l", mods = "LEADER", action = act.ActivatePaneDirection("Right") },
	{ key = "k", mods = "LEADER", action = act.ActivatePaneDirection("Up") },
	{ key = "j", mods = "LEADER", action = act.ActivatePaneDirection("Down") },
	{ key = "H", mods = "LEADER", action = act.AdjustPaneSize({ "Left", 10 }) },
	{ key = "L", mods = "LEADER", action = act.AdjustPaneSize({ "Right", 10 }) },
	{ key = "K", mods = "LEADER", action = act.AdjustPaneSize({ "Up", 5 }) },
	{ key = "J", mods = "LEADER", action = act.AdjustPaneSize({ "Down", 5 }) },

	{ key = "v", mods = "CTRL|SHIFT", action = act.PasteFrom("Clipboard") },

	{ key = "Enter", mods = "ALT", action = "DisableDefaultAssignment" },
}
-- ============================================================
-- イベントハンドラ (returnの外に出す必要があります)
-- ============================================================
wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
	-- タイトル取得のロジックを少し強化（もしタイトルが空ならプログレス名を表示など）
	local title = tab.active_pane.title
	if title == "" then
		title = "Default"
	end
	return {
		{ Text = " " .. title .. " " },
	}
end)

return config
