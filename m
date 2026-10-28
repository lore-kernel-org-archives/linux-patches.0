Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212715;
	b=dRwDovuqPL+hvBpvkwyAKlP+ISG0B+o7ZitiamHoyfyciCrGP+ce2C8rmOfIrLeWGtIc
	 U+QQTkIpHLvdTPjCJmRE+dc1nsy73L1bg6L/nG75E/zHqiHk6yK1EcGSh4BCLY+EaHM60
	 VSBLQzaBEKeQmNgav6GxyCOdQ+CORHqSCe9EsKcJxhhwPvEHMvyvKXVNH4MaviXb8IcY8
	 xBx4xmH/MHXamjl6NYzeqFgm44ulM8O3pcj6GEi26mVgckZ54PVOwYpnluDahCjnfSjIL
	 mIkCNrcZP4Ii0HQeNHsPnw2K/lKUkJXXP1xB7nI4pdxSFC6DVEaDvGBfOk9kC7FnabA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212715;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kgI4u+nS7ibsqeTL/MOVp1KhSYpwXmeksfyHXLxIqxE=;
	b=vd5fcfUuXZLPTVFlclA2YipJJwH4f0XRPsieCIXlW+1BS+DSVUDifB9e9AJ9Eol+I5aG
	 ECQZidZCUBNsr3bHBQWssET13AZFG5nVq7FPNQFswshMCEFDVOWSoFvcy9dnfpuaXGIHA
	 awyFeDExtq9SEhz8OjvtZ4XjaYpBmLLzFbE3w0QfTyJlKCs+LA3Vz1rYIwmQqHp+nN08U
	 2CJS4dg5YQ78V50+ckj90+h/M3XUb2GXl44ziK4SF7ohj6+kWN0lQLNvodmQsHJpwQzqI
	 1GNy4ofavkQirkFDnt2OwGpQWiNQTcSqzaHaNlkcoylgh52FYLs3YJVqQ1o1KwcYWCw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KBWIf5u+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18770606A336;
	Wed, 28 Oct 2026 18:38:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KBWIf5u+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69B7D1F01829;
	Wed, 28 Oct 2026 18:38:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212715;
	bh=kgI4u+nS7ibsqeTL/MOVp1KhSYpwXmeksfyHXLxIqxE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KBWIf5u+zmyJYaGC0mPj8+zFjFRSGX8dKXgOvZxDgbbl+KREBIobydGSgaFN2ysOM
	 a3OJSTgbrCEKBGW+i1iAQGnqZ9zn4aFcFELj/xrbLyY9GvZX8qAJcB/+Ta6o6IKhzQ
	 A0zMvHy5P/Hc9YSxVElFFbZ5NOFNYV4Ld7FHtqqw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+652670cf249077eb498b@syzkaller.appspotmail.com,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0207/1887] hsr: Remove WARN_ONCE() in hsr_addr_is_self().
Date: Wed, 28 Oct 2026 17:38:23 +0100
Message-ID: <20261028170503.943928616@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuniyuki Iwashima <kuniyu@google.com>

[ Upstream commit afd0f17ca46258cec3a5cc48b8df9327fe772490 ]

syzbot reported the warning [0] in hsr_addr_is_self(),
whose assumption is simply wrong.

hsr->self_node is cleared in hsr_del_self_node(), which
is called from hsr_dellink().

Since dev->rtnl_link_ops->dellink() is called before
unregister_netdevice_many(), there is a window when
user can find the device but without hsr->self_node.

Let's remove WARN_ONCE() in hsr_addr_is_self().

[0]:
HSR: No self node
WARNING: net/hsr/hsr_framereg.c:39 at hsr_addr_is_self+0x211/0x3f0 net/hsr/hsr_framereg.c:39, CPU#0: syz.4.16848/17220
Modules linked in:
CPU: 0 UID: 0 PID: 17220 Comm: syz.4.16848 Tainted: G             L      syzkaller #0 PREEMPT_{RT,(full)}
Tainted: [L]=SOFTLOCKUP
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 04/18/2026
RIP: 0010:hsr_addr_is_self+0x211/0x3f0 net/hsr/hsr_framereg.c:39
Code: 33 2f 41 0f b7 dd 89 ee 09 de 31 ff e8 c8 b4 c6 f6 09 dd 74 54 e8 0f b0 c6 f6 31 ed eb 53 e8 06 b0 c6 f6 48 8d 3d 2f 50 9c 04 <67> 48 0f b9 3a 31 ed eb 42 e8 c1 13 1f 00 89 c5 31 ff 89 c6 e8 96
RSP: 0018:ffffc900041c70e0 EFLAGS: 00010283
RAX: ffffffff8afdc6ca RBX: ffffffff8afdc4e6 RCX: 0000000000080000
RDX: ffffc90010493000 RSI: 0000000000000948 RDI: ffffffff8f9a1700
RBP: 0000000000000001 R08: 0000000000000000 R09: 0000000000000000
R10: ffffc900041c71e8 R11: fffff52000838e3f R12: dffffc0000000000
R13: ffff888041f9e3c0 R14: ffff888086ee3802 R15: 0000000000000000
FS:  00007f6fe985d6c0(0000) GS:ffff888126176000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f80bd437dac CR3: 0000000025096000 CR4: 00000000003526f0
DR0: ffffffffffffffff DR1: 00000000000001f8 DR2: 0000000000000002
DR3: ffffffffefffff15 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 check_local_dest net/hsr/hsr_forward.c:592 [inline]
 fill_frame_info net/hsr/hsr_forward.c:728 [inline]
 hsr_forward_skb+0xa11/0x2a80 net/hsr/hsr_forward.c:739
 hsr_dev_xmit+0x253/0x370 net/hsr/hsr_device.c:236
 __netdev_start_xmit include/linux/netdevice.h:5368 [inline]
 netdev_start_xmit include/linux/netdevice.h:5377 [inline]
 xmit_one net/core/dev.c:3888 [inline]
 dev_hard_start_xmit+0x2df/0x860 net/core/dev.c:3904
 __dev_queue_xmit+0x1428/0x3900 net/core/dev.c:4870
 neigh_output include/net/neighbour.h:556 [inline]
 ip_finish_output2+0xcec/0x10b0 net/ipv4/ip_output.c:237
 ip_send_skb net/ipv4/ip_output.c:1510 [inline]
 ip_push_pending_frames+0x8b/0x110 net/ipv4/ip_output.c:1530
 raw_sendmsg+0x1547/0x1a50 net/ipv4/raw.c:659
 sock_sendmsg_nosec net/socket.c:787 [inline]
 __sock_sendmsg net/socket.c:802 [inline]
 ____sys_sendmsg+0x7da/0x9c0 net/socket.c:2698
 ___sys_sendmsg+0x2a5/0x360 net/socket.c:2752
 __sys_sendmsg net/socket.c:2784 [inline]
 __do_sys_sendmsg net/socket.c:2789 [inline]
 __se_sys_sendmsg net/socket.c:2787 [inline]
 __x64_sys_sendmsg+0x1c3/0x2a0 net/socket.c:2787
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x15f/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f6feb62ce59
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f6fe985d028 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00007f6feb8a6090 RCX: 00007f6feb62ce59
RDX: 0000000000000000 RSI: 0000200000000000 RDI: 0000000000000004
RBP: 00007f6feb6c2d6f R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f6feb8a6128 R14: 00007f6feb8a6090 R15: 00007ffcf01cc488
 </TASK>

Fixes: f266a683a480 ("net/hsr: Better frame dispatch")
Reported-by: syzbot+652670cf249077eb498b@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/netdev/6a1a861e.b111c304.35cd64.0016.GAE@google.com/
Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
Reviewed-by: Fernando Fernandez Mancera <fmancera@suse.de>
Link: https://patch.msgid.link/20260530064300.340793-1-kuniyu@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/hsr/hsr_framereg.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/net/hsr/hsr_framereg.c b/net/hsr/hsr_framereg.c
index 60eab82ca5a0a..35c2fae8d1f79 100644
--- a/net/hsr/hsr_framereg.c
+++ b/net/hsr/hsr_framereg.c
@@ -43,10 +43,8 @@ bool hsr_addr_is_self(struct hsr_priv *hsr, unsigned char *addr)
 
 	rcu_read_lock();
 	sn = rcu_dereference(hsr->self_node);
-	if (!sn) {
-		WARN_ONCE(1, "HSR: No self node\n");
+	if (!sn)
 		goto out;
-	}
 
 	if (ether_addr_equal(addr, sn->macaddress_A) ||
 	    ether_addr_equal(addr, sn->macaddress_B))
-- 
2.53.0



