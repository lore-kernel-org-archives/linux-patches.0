Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624919;
	b=v9aGYZvvpHoohGAmc4wv+Ee6H/T5SwQB2LvgbzpYlJfkIpB3JMkST16y0n55A+bJDb14
	 dvL8W/FQyfoEPuUuQ21NvBr0IrzMddQJAkP5oDRDQzVH7blplVfjMmAE6MAT/xwjGA0Lh
	 1LnGn75uNL5x29A3Pu9rEFJpx8g9AbKe6pXwRz2HDRA+4UC/PynXbgyYAI6Ie1qik8puq
	 46pnjBeL1BndYs9SeM4ySQQo5MwAYKn7HW/eEtJMbjHNwwD1b0PU/rJ8xQEeiPTmJqwMa
	 +5OUahj7KS5Rm7l1WZX9Rit8LIAdywS8l7PfwVthdLLvbWc5JPoBKk2bolx+CJXVx0A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624919;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=80zX0SfBoLVNRIU2ymUKV+kZ/sfeT5UaiKcg8wGLhR0=;
	b=sawkxEnRoE5Rhss2pOlMM4V5s57WaeRwgQIF4qFytJw3JFw+Juo01y8t+/oJolR/6geD
	 jO4hRYgZG48GJKens3F/z/BPc2hUZNq6Ih7lyLYrjMeml2fAsGO5ffXBH+sSuT0KlYF0L
	 i9DfjJia+JmydXaLWCW8ndnjO4FxupzEUfL3W9dH8/mMcftvnOXw5WK//2Qpkaeti1NS/
	 vMOe/rMAWEXeulfdEA5T2AnvV03oiieot6aHhU5zb4gq0XnF2yo851AuhVX+YgQSE8pir
	 34g4eEfBRepWUt9DgN4JMVbJBK9tTZZ8dnuAwo3FPin/qkyf7GzmIwd0jB+kQpPjtKQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SqIXRSr+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA5A9606A331;
	Wed, 25 Nov 2026 16:41:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SqIXRSr+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05E921F000D3;
	Wed, 25 Nov 2026 16:41:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624919;
	bh=80zX0SfBoLVNRIU2ymUKV+kZ/sfeT5UaiKcg8wGLhR0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SqIXRSr+Fg/8Ep+lcl/BnNzMfomEqhmQdKzXUxhIbU36WSOQpI8JmZ+J9d3LP+z35
	 VYinna5MTEfjEZn2nVRhptxdpo+nrEjuaka+kXgH2Ha3+1wjCEhkDfLFc8k+yO4ghG
	 GLgmPjQnH3MUOpVvjOmyDcUKFT/NybLOMYnG+qBg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+9ea34da5ca6100593c90@syzkaller.appspotmail.com,
	Kalpesh Solanki <skalpesh942@gmail.com>,
	Willem de Bruijn <willemb@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 348/816] tun: disallow setting IEEE 802.15.4 and 6LoWPAN link types via TUNSETLINK
Date: Wed, 25 Nov 2026 15:31:36 +0100
Message-ID: <20261125143857.252355854@linuxfoundation.org>
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
index 2ae337ff384e8..893746d4c8d0f 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -3264,6 +3264,10 @@ static long __tun_chr_ioctl(struct file *file, unsigned int cmd,
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



