Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705323;
	b=1wKJmUUGdMjLRx/0cw4T9XSBvlISP2/vEASEb0NqpuLDbM/TArx5dj9l7KwyFt8ChFB9
	 Y4PG4/JyOAqDPEE7GjIfssLmdr00pDkLio8zYjQj5YKM803Ft/g8jJRW/Hq1a6O1i3M7u
	 KjU5HbIUnrJkVrJoclLtBe/vFVzOY12mHIWutbPeOsuqc2W81BzJx3d6AE4Zi5IHeQV6i
	 uXEUHJCX6GnRSrFcJZ6fvCnX2/ITWDR+OyKAiQwGtWQacepY+gQDAIUB/aYrpNrbhF/zy
	 oKZFmmgJQMOTOibHhM10GDo1daGh/zus1RUD99Wp9j9YcPCMEkRgHbfccR7vYzwyFIw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705323;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nbCVCMC6jRFym3IvLAKVfAueqVWJD8LnqDQIbXhESMI=;
	b=0W2dAi7VR3gySjrVXe47LygnujsqrZM2pOQ+jJraF4vLaUK8xFdeH1Lz8N/+DliF5uVG
	 RAOv/leV1dyRNAP4kY7S4YdB8qqaoqMD71CW7jx8e9mAMlZnMCkRFAy44makNTZ+KxAJB
	 NeWoyqFiPxdzjwXKZXGBhvPs2z4s6448OCkJjmgpa1RIS+2+bBR/yCrEz7K9dflJkTXWa
	 gpdm6JGJSMULbFw6W3D6U/96zg4YjHZEV/ap7EzkpMg1VnsKc5MAqmnEywHATTGteknKC
	 hngzAp618djZTEBsadGcQo+CLPo+Ni7Qqqvm5lKgNgIhmJZNQs3+ZVIBQ2tfgfaPMRw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=12l9jM8r;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B179606A31C;
	Thu, 26 Nov 2026 15:02:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=12l9jM8r
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21DD71F000C6;
	Thu, 26 Nov 2026 15:02:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795705322;
	bh=nbCVCMC6jRFym3IvLAKVfAueqVWJD8LnqDQIbXhESMI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=12l9jM8r6zAS45nvtFowY0D1IkU2LjSZy9RhswBCjMA8YB8wCQj14yIWUmhjODR4j
	 kl2PnqLwYSeA6c+nxFrMk8mqffxSc7xKPfjhLPOt10vvSU42tsXKNxWRK/qXa6lvRU
	 PyCx9X4eFXNsrI8C/v6aG5HymYAjnHN3psUhpsIk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+9ea34da5ca6100593c90@syzkaller.appspotmail.com,
	Kalpesh Solanki <skalpesh942@gmail.com>,
	Willem de Bruijn <willemb@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 158/319] tun: disallow setting IEEE 802.15.4 and 6LoWPAN link types via TUNSETLINK
Date: Thu, 26 Nov 2026 15:38:46 +0100
Message-ID: <20261126144010.311537252@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126144006.732901931@linuxfoundation.org>
References: <20261126144006.732901931@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kalpesh Solanki <skalpesh942@gmail.com>

[ Upstream commit 968f2b94a5964b75d9c0da84523e42530c1891f0 ]

A userspace application can set the link type of a TUN/TAP interface
to ARPHRD_IEEE802154, ARPHRD_IEEE802154_MONITOR, or ARPHRD_6LOWPAN
via ioctl(fd, TUNSETLINK, arg) because tun_get_addr_len() explicitly
recognized these types.

However, TUN devices cannot function as genuine IEEE 802.15.4 or 6LoWPAN
interfaces:

1. They lack wpan_phy, channels, PAN IDs, and MLME operations, and tun
   never initializes dev->ieee802154_ptr or dev->ml_priv. When an
   unprivileged user creates a TUN interface in a user+net namespace,
   changes its link type to ARPHRD_IEEE802154, and issues a netlink dump
   request (such as IEEE802154_LLSEC_LIST_KEY),
   ieee802154_llsec_dump_table() unconditionally dereferences
   dev->ieee802154_ptr / ieee802154_mlme_ops(dev), triggering a supervisor
   null-pointer dereference / general protection fault. Similar
   dereferences occur across net/ieee802154/nl-phy.c (ieee802154_del_iface)
   and net/ieee802154/socket.c.

2. Similarly, the 6LoWPAN subsystem assumes via lowpan_dev(dev) that
   netdev_priv(dev) is struct lowpan_dev. On a TUN device, netdev_priv(dev)
   is struct tun_struct. On netdev events (such as NETDEV_DOWN in
   net/6lowpan/core.c:lowpan_device_event), it clears bits in
   lowpan_dev(dev)->ctx.table flags, which corrupts private memory inside
   tun_struct.

Rather than scattering checks across subsystems, fix the issue at the
source: disallow setting ARPHRD_IEEE802154, ARPHRD_IEEE802154_MONITOR, and
ARPHRD_6LOWPAN via TUNSETLINK by returning -EINVAL. Cast arg to unsigned
short in the comparison to prevent upper-bit truncation bypasses (e.g.
arg = ARPHRD_IEEE802154 | 0x10000).

Fixes: ff4cc3ac93e1 ("[TUNTAP]: Allow setting the linktype of the tap device from userspace")
Reported-by: syzbot+9ea34da5ca6100593c90@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=9ea34da5ca6100593c90
Signed-off-by: Kalpesh Solanki <skalpesh942@gmail.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Link: https://patch.msgid.link/20261109083037.22337-1-skalpesh942@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/tun.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index bde1063a21913..374ff3c16905e 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -3186,6 +3186,10 @@ static long __tun_chr_ioctl(struct file *file, unsigned int cmd,
 			netif_info(tun, drv, tun->dev,
 				   "Linktype set failed because interface is up\n");
 			ret = -EBUSY;
+		} else if ((unsigned short)arg == ARPHRD_IEEE802154 ||
+			   (unsigned short)arg == ARPHRD_IEEE802154_MONITOR ||
+			   (unsigned short)arg == ARPHRD_6LOWPAN) {
+			ret = -EINVAL;
 		} else {
 			ret = call_netdevice_notifiers(NETDEV_PRE_TYPE_CHANGE,
 						       tun->dev);
-- 
2.53.0



