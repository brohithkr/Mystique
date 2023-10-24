import { spawn } from "child_process";

interface User {
    username: string;
    uid: string;
    channel: string;
}

var active_uids = new Map<string, User>() // get user data from uid of user
var active_channels = new Map<string, string[]>() // get users of channel based on active channels id
var waiting_uids: string[] = []; // all waiting user ids

function generate_uid(): string {
    let rand_num = Math.random()
    let uid = Math.floor(rand_num * 1e6)
    return uid.toString()
}

function generate_unique_uid<V>(generate_uids: Map<string, V> | Set<string>): string {
    var uid = generate_uid()
    while (generate_uids.has(uid)) {
        uid = generate_uid()
    }
    return uid
}

let app = Bun.serve<User>({
    async fetch(req, server) {
        let url = new URL(req.url)
        let path = url.pathname
        switch (path) {
            case "/connect":
                
                let body = url.searchParams
                let username = body.get("username") ?? "user"
                let uid = "u" + generate_unique_uid(active_uids)
                let user_data: User;
                var channel_id = "";
                console.log(waiting_uids)
                if (waiting_uids.length == 0) {
                    waiting_uids.unshift(uid)
                    channel_id = "c" + generate_unique_uid(active_channels)
                    active_channels.set(channel_id, [uid])
                    user_data = {
                        username: username,
                        uid: uid,
                        channel: channel_id
                    }
                }
                else {
                    let paired_uid = waiting_uids.pop() ?? ""
                    console.log(paired_uid, active_uids)
                    let paired_one = active_uids.get(paired_uid) as User
                    channel_id = paired_one.channel
                    active_channels.get(channel_id)?.push(uid)
                    user_data = {
                        username: username,
                        uid: uid,
                        channel: channel_id
                    }
                }
                active_uids.set(uid, user_data)
                server.upgrade(
                    req, {
                    data: user_data
                }
                )
                return new Response(JSON.stringify(Object.fromEntries(active_uids)))
                break
        }
        return new Response("hello")
    },
    websocket: {
        open(ws) {
            let user_data = ws.data
            let channel_id = user_data.channel
            ws.subscribe(channel_id)
            ws.publish(channel_id, `!-> ${ws.data.username} entered`)
            
        },
        message(ws, message) {
            if((message as string).startsWith('!->')) {
                let data = (message as string).split(' ')
                if(data[3] == 'entered') {
                    ws.publish(ws.data.channel, `!-> ${ws.data.username} here`)
                }
            }
            ws.publish(ws.data.channel, `${ws.data.username}: ${message}`)
        },
        close(ws) {
            ws.publish(ws.data.channel, `!-> ${ws.data.username} left`)
        }
    }
})
