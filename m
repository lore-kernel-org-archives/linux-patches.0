Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619208;
	b=mIgolBh8r1gbgPQPWIwVYmgnw0dJBYUgxCYuxCYClzwUh9QuCQPH1TVSuWHLAkEQZmoQ
	 t5naf/IC2OFmt0IulP2im/0qTUbHeYBqpgQ5HsUn4mocwCqCChoHqSEgqC2rqYlbiScq6
	 ajvQ0ajZD64ru/ugTFqFUm9YByyu/TyHRhgw/ob4RLZBCLGG+eVgLu6mpyVkyODTxBres
	 /OpBUFufyh+vcOdP4RymTOnwaUEYLX1sqrQS3hGd43UxRpFvRIo+3c2CfBU3lmyi572EV
	 ueUIXmi/pwHvcbyJF2gSV9EP6fuUwIa2pBs28r20h2gBA213GUakHWzr+SrSKL0fT0g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619208;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=IJvrsnong0lFAkwmAqtC5opVw6omHQMFWStkLi/08Kk=;
	b=23Rb3/6QoS7KLNdSk0GjQWXUDte57QYheHYhR1o+6WvOOUHXzxiRn7IzUbOTTL/qpMts
	 2TauiQs35FhPUXaSnDf8i8zdxFgY2FuXCDsHtHz1IxtRwQoTFm4cot0kigtEdbmdTjMrJ
	 P/b0aKeBQ5Isw+XtekBeo+I3Bmc4xagGjcZJf7W0Dfl15SM73XSknn6oNS2fbVG8avL8G
	 STcO0jNu9LO3eqt4hPQlhhbDs6u0KfiEFqNSGEWcZcnaxXSLNH/wqnPJ4IW6jP3zZtwIL
	 L+KlqwpbVaDxyLa6FrXY2Eaw7uNGxRXluUR9AR2FUgrJ+cB8rpTL+gQS5OQHpBVksZg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Nf1refR4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7086A606A329;
	Wed, 25 Nov 2026 15:06:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Nf1refR4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EF821F000C0;
	Wed, 25 Nov 2026 15:06:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619207;
	bh=IJvrsnong0lFAkwmAqtC5opVw6omHQMFWStkLi/08Kk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Nf1refR4LRDGQj9iK6I6ZGHENGCoYoWqg984WsON31z0m8zClL7No+NHVXNZl4TaB
	 vIlE8bt9/PRS3CrYsqFLZ+9fzsbyruK7Qb+iz9zr1mN+naVJBlpxDVlRZbnVem1nxC
	 10UdPyOsmDPasrWiuIzGnTujr17J86deJ399zQh8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+9ea34da5ca6100593c90@syzkaller.appspotmail.com,
	Kalpesh Solanki <skalpesh942@gmail.com>,
	Willem de Bruijn <willemb@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0524/1005] tun: disallow setting IEEE 802.15.4 and 6LoWPAN link types via TUNSETLINK
Date: Wed, 25 Nov 2026 15:31:02 +0100
Message-ID: <20261125143834.019232833@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 3cb2c87fa8137..092adb497dc76 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -3371,6 +3371,10 @@ static long __tun_chr_ioctl(struct file *file, unsigned int cmd,
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



