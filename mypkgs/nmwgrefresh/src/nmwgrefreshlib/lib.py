import asyncio
import json
import random

import gi
gi.require_version("NM", "1.0")
from gi.events import GLibEventLoopPolicy
from gi.repository import GLib, NM


async def async_main(main_loop):
    try:
        nm_client = NM.Client.new(None)

        conn = nm_client.get_connection_by_id("wg0")
        wg_conn = conn.get_setting(NM.SettingWireGuard)

        device = nm_client.get_device_by_iface("wg0")

        peers_len = wg_conn.get_peers_len()
        assert(peers_len == 1)

        peer = wg_conn.get_peer(0)

        jpeers = None
        with open('/etc/nmwgrefresh/peers.json') as f:
            jpeers = json.load(f)
        jpeer = random.choice(jpeers)

        print(jpeer)

        private_key = None
        with open('/etc/nmwgrefresh/private_key.txt') as f:
            private_key = f.read().strip()

        wg_conn.set_property(NM.SETTING_WIREGUARD_PRIVATE_KEY, private_key)

        new_peer = peer.new_clone(False)
        succ = new_peer.set_public_key(jpeer['pubkey'], False)
        assert(succ == True)
        succ = new_peer.set_endpoint(jpeer['endpoint'], False)
        assert(succ == True)

        wg_conn.set_peer(new_peer, 0)
        succ = await conn.commit_changes_async(True, None)
        assert(succ == True)

        succ = await device.reapply_async(None, 0, 0, None)
        assert(succ == True)
    finally:
        main_loop.quit()


def main():
    main_loop = GLib.MainLoop()

    policy = GLibEventLoopPolicy()
    asyncio.set_event_loop_policy(policy)

    loop = policy.get_event_loop()
    task = loop.create_task(async_main(main_loop))

    main_loop.run()
    task.result()
