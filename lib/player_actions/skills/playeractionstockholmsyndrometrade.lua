PlayerAction.StockholmSyndromeTrade = {}
PlayerAction.StockholmSyndromeTrade.Priority = 1
function PlayerAction.StockholmSyndromeTrade.Function(pos, peer_id)
	managers.hint:show_hint("skill_stockholm_syndrome_trade")
	local controller = managers.controller:create_controller("player_custody", nil, false)
	controller:enable()
	local quit = false
	local previous_state = game_state_machine:current_state_name()
	local co = coroutine.running()
	while not quit do
		if controller:get_input_pressed("jump") then
			managers.player._has_super_syndrome = false
			if Network:is_server() then
				managers.player:init_auto_respawn_callback(pos, peer_id, true)
				managers.groupai:state():set_super_syndrome(peer_id, false)
			else
				managers.network:session():send_to_host("auto_respawn_player", pos, peer_id)
				managers.network:session():send_to_host("sync_set_super_syndrome", peer_id, false)
			end
			quit = true
		end
		local current_state = game_state_machine:current_state_name()
		if previous_state == "ingame_waiting_for_respawn" and current_state ~= previous_state then
			quit = true
		end
		previous_state = current_state
		coroutine.yield(co)
	end
	controller:destroy()
	controller = nil
end
