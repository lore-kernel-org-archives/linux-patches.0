Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625530;
	b=Z7/zlt2jVUX9bkXXoR5LfdfWu8g7Osz+1SUgacarBrLOIQ3Nf3jHtB7LjLa3GQblUkm5
	 kyzkzicJjIIlQxRxAXc7cXm/QMP5Bbcw2+QqH8Gnlzz/pdNm3SZwLlthVRGMvp+aSrZfA
	 AvLYLd2sSv/vtl0ecV4r6FEfbAVmWdTXuWNXRFcQx4zA06UUhBvaOQ2CVEr3RQCS/IYEW
	 edNzeeDFQ39pJJAYQTWbRKLeLlxBMTkpuIBse0FhLKhQbbnq+wNmCz/AMTvQrLMaPnq1r
	 6oFazyDqKytmFTePIbOgEU9K0RC9y+zkPCzPhpIRL6XAwRmAcoUwyIHOp/hadtDpp2g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625530;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fW0l/Xb4/Pj4Hs9QTEHxqIxAVvr14XFRaLm4q/Rk12w=;
	b=4729PdbJLLquwmubpHOWDnrAQpx+L98vsi5Pq8TmcYy2LWOGTvT3nb6j5K/ApzNc821F
	 5b4R3QAYFIYDske97R9mmYTdTTMaONXxNBN2LwEur6sqzNtMFtApcconcFtGLVMOpNg9v
	 Sia7ftyPtm5v5rvU7fawqPDCFQUxrtQXPEi+uOghtUH0xYJ0cm5KypHQ+WuYelzD1MliL
	 55l4waUzoTKsBEOxmCsSIygRgrbASoI5ORIpTNY8Ds8XZnGPafFdPTfnHMRW+WcwLgfXe
	 jG4aLOCBbBXZs5x7MY8smCzFYP6jct0xcMW02je7D7Yl/orgqKMEuJgmaIKEvoObD3Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DjBHi+E7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E41AC606A321;
	Wed, 25 Nov 2026 16:52:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DjBHi+E7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 206731F000C6;
	Wed, 25 Nov 2026 16:52:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625529;
	bh=fW0l/Xb4/Pj4Hs9QTEHxqIxAVvr14XFRaLm4q/Rk12w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DjBHi+E7asjxh3GPakf2pG/nFzmE4o7rgzwDPdAhwiNsHevmMfaiogoL0VBNItQB3
	 kO6+LcK6HVr8tJWNByTElpM4oyhAuDz2ND4UajpeVmeVFc0GtpAjSqMMSQsMmOIrlm
	 rRMneonExWIukLksdBgXh4+rYK+XNCe5uDioxJRI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+1269fe6cc2016008124e@syzkaller.appspotmail.com,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Naman Gulati <namangulati@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 546/816] netdev-genl: ignore NETDEV_UNREGISTER rebroadcasts
Date: Wed, 25 Nov 2026 15:34:54 +0100
Message-ID: <20261125143901.823820194@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Naman Gulati <namangulati@google.com>

[ Upstream commit fd0909e963ed8f36967bd072ed484be7babe46de ]

netdev_wait_allrefs_any() re-sends NETDEV_UNREGISTER every second while
it waits for the last references on a device to be dropped. By then
netdev_run_todo() has already marked the device NETREG_UNREGISTERED and
RTNL has been dropped at least once since the initial notification sent
by unregister_netdevice_many_notify().

netdev_genl_netdevice_event() does not tell these rebroadcasts apart
from the initial notification and sends a NETDEV_CMD_DEV_DEL_NTF
multicast for each of them. At best this spams NETDEV_NLGRP_MGMT
listeners with duplicate notifications; at worst the pernet state of
the netns the device belongs to is already gone and the handler
dereferences a NULL pointer.

default_device_exit_batch() only unregisters the devices still listed
in the exiting netns; it does not wait for in-flight unregistrations of
devices that were already unlisted (the barrier doing that was removed
by commit 8a4fc54b07d7 ("net: get rid of rtnl_lock_unregistering()")).
So when a device is unregistered by something other than the
cleanup_net() of its own netns while references on it are still held,
e.g. a veth whose peer in another netns gets deleted, and that netns
exits while the device is stuck in netdev_wait_allrefs_any(), the
remaining pernet exit handlers run and genl_pernet_exit() sets
net->genl_sock to NULL. The next rebroadcast then crashes in
genl_has_listeners():

  BUG: KASAN: null-ptr-deref in netlink_has_listeners+0x3d/0x3f0 net/netlink/af_netlink.c:1388
  Read of size 8 at addr 0000000000000578 by task syz.0.0/5325
  Call Trace:
   <TASK>
   netlink_has_listeners+0x3d/0x3f0 net/netlink/af_netlink.c:1388
   genl_has_listeners include/net/genetlink.h:644 [inline]
   netdev_genl_dev_notify+0x161/0x450 net/core/netdev-genl.c:93
   netdev_genl_netdevice_event+0x98/0x3c0 net/core/netdev-genl.c:1491
   notifier_call_chain+0x1a5/0x3d0 kernel/notifier.c:85
   netdev_wait_allrefs_any net/core/dev.c:11690 [inline]
   netdev_run_todo+0x731/0x1060 net/core/dev.c:11808
   rtnl_unlock net/core/rtnetlink.c:157 [inline]
   rtnl_dellink+0x68f/0x810 net/core/rtnetlink.c:3707

syzbot hit this by moving one end of a veth pair into a short-lived
netns while netdevsim's deferred FIB event processing still held a
reference on it, and then deleting the other end (repro [1]). While the
source of this bug is netdevsim deferring FIB processing for and holding
onto the device reference for O(seconds) which is being fixed
separately [2], any driver may introduce such a delay and trigger the
null-ptr-deref.

Skip the rebroadcasts, which are the only NETDEV_UNREGISTER events
delivered with reg_state == NETREG_UNREGISTERED. The notifications sent
by unregister_netdevice_many_notify() and, for a device leaving a netns,
by __dev_change_net_namespace() are issued under RTNL in the same
critical section that unlists the device, before its netns can be torn
down, and keep being handled. This mirrors what ip6_route_dev_notify()
already does to cope with the rebroadcasts.

This change should not break the UAPI spec as it defines dev-del-ntf as
a "Notification about device disappearing." which is a single event. The
rebroadcast in netdev_wait_allrefs_any() exists to re-kick in-kernel
subsystems holding references; netdev-genl happens to be on the notifier
chain and forwards it.

[1] https://gist.github.com/NamanGulati/2d1b49b8757f9a88b0bd6e55018c02ae
[2] https://lore.kernel.org/r/20261023191517.607834-1-kuniyu@google.com

Fixes: d3d854fd6a1d ("netdev-genl: create a simple family for netdev stuff")
Reported-by: syzbot+1269fe6cc2016008124e@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/netdev/6adf9f64.6200f071.51519.0ed1.GAE@google.com/
Reviewed-by: Kuniyuki Iwashima <kuniyu@google.com>
Signed-off-by: Naman Gulati <namangulati@google.com>
Link: https://patch.msgid.link/20261026221306.3151025-1-namangulati@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
[ sashal: Added the upstream guard and comment to the NETDEV_UNREGISTER case, but without the netdev_lock()/netdev_unlock() context lines, which this tree lacks. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/netdev-genl.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/core/netdev-genl.c b/net/core/netdev-genl.c
index 12c6f7d5add09..7578686165515 100644
--- a/net/core/netdev-genl.c
+++ b/net/core/netdev-genl.c
@@ -897,6 +897,12 @@ static int netdev_genl_netdevice_event(struct notifier_block *nb,
 		netdev_genl_dev_notify(netdev, NETDEV_CMD_DEV_ADD_NTF);
 		break;
 	case NETDEV_UNREGISTER:
+		/* netdev_wait_allrefs_any() rebroadcasts NETDEV_UNREGISTER
+		 * while waiting for the last references to be dropped; the
+		 * netns may already be torn down by then. Notify only once.
+		 */
+		if (READ_ONCE(netdev->reg_state) == NETREG_UNREGISTERED)
+			break;
 		netdev_genl_dev_notify(netdev, NETDEV_CMD_DEV_DEL_NTF);
 		break;
 	case NETDEV_XDP_FEAT_CHANGE:
-- 
2.53.0



