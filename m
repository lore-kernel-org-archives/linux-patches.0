Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064924;
	b=vN65Cj7HmbS7t6FB4Ihr+MXXTPyj2OBd2Je4U5MybJADm6nCd0XGMxP7AaM279cCpQ+z
	 67y8oprEnoSqny9BK3TqiNZAfX6Jy1fjPjdv2p+JogaTaKiFQXXdiOgyQ0pduCbqRmV9E
	 +OtMp+7KXL3gub0SuUTb2pAxIj6+suVuJ717y3iOU98BMBLjXlWwO/mIh+IQNTd6T+vjD
	 /avH8+ko4p0ZahDP+eq+vrY0Q1jpJAUuCiQ6mzmQQ3IoHWdeqQpzDrYDtEv23qooh9Xsk
	 jbnV7EhG+loNeDDbtBTXjNOXZLETez8VV2yrBz65HE0AyrvA/dt5ugx3RbILEHi4I2A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064924;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lwn2IVJUFg7Itc1QN2xe8R1wRXR83WM2fvSe2+/zRGk=;
	b=bw0Z6nBpBrZr9GQpQUOFyRBKf2/+M4eJbfZ1xQyBx1gnZIaqaGXk+oAGWdYBhgsrQ2Pl
	 eNMs7/O8ZjPHPeqU+/93NOvYCc8cHTPfR8A+DQOl5BkuJa8kTji+etT6S0Y4AgLd9+PqF
	 d62VP24YAzUyzBaU92Qr/iUGMUCEfo+XhaAegSxCQrB9KzU5NwJQl0yM6ticqaAi+aVZr
	 eKo/n1U+IkCtD/EBI8mi/kx+ZbK5AjJV2zTsb/BCh1MvD6ihK0ZATLF2T4ox4vDEjVlXu
	 30PCGFBi3SV5eHzw6aUhPI+1Gr6MTFzFWVMTmoIEEE++hJh2w+MDB13ehuv2FTk8KDQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="RQFoF/46";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4FD1606A33E;
	Sat,  7 Nov 2026 15:22:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RQFoF/46
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67C2B1F0089F;
	Sat,  7 Nov 2026 15:22:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064923;
	bh=lwn2IVJUFg7Itc1QN2xe8R1wRXR83WM2fvSe2+/zRGk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RQFoF/46bY5KE6UkRaJHfGHa4VspjMxV54vgan3pRhJlGFJy4yX5bvEmVH+WSJd65
	 tKAcpxvaP9soAz7L7MFgJWCBoa+WRSyWAgY/QWb144zZEorvH/IMpifCr7jZAnFulk
	 FlPI+5wZ3biJdY2mVWStE0zcimfYiJH2RUTLEBm8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+9bda1b9fbb7fbdf9b62b@syzkaller.appspotmail.com,
	Yun Zhou <yun.zhou@windriver.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0819/1257] net: erspan: set lltx to avoid sch_direct_xmit deadlock
Date: Sat,  7 Nov 2026 08:51:55 -0500
Message-ID: <20261107135001.961800188@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

From: Yun Zhou <yun.zhou@windriver.com>

[ Upstream commit 2d36ec73836e83175deb467fd494c61006107e5d ]

The ERSPAN xmit path re-enters the network stack, causing nested
acquisition of _xmit_lock on the underlay device while already holding
the ERSPAN device's _xmit_lock, creating an ABBA deadlock. This happens
for both IPv4 ERSPAN (erspan_xmit() -> ip_tunnel_xmit()) and IPv6 ERSPAN
(ip6erspan_tunnel_xmit() -> ip6_tnl_xmit()):

  sch_direct_xmit [lock erspan] -> erspan_xmit -> ip_tunnel_xmit ->
  ip_output -> __dev_queue_xmit -> sch_direct_xmit [lock underlay]

  sch_direct_xmit [lock erspan] -> ip6erspan_tunnel_xmit -> ip6_tnl_xmit ->
  ip6_output -> __dev_queue_xmit -> sch_direct_xmit [lock underlay]

Set dev->lltx = true so HARD_TX_LOCK() skips the spinlock for ERSPAN.
This is safe as the ERSPAN xmit path has no shared mutable state: o_seqno
is atomic, TX stats are per-CPU u64_stats, dst_cache is per-CPU, and
o_flags is no longer modified in the xmit path since commit 9958e69b9893
("gre: fix ERSPAN o_flags race/corruption in xmit and fill_info").
GRETAP, the sibling device with identical xmit structure, already sets
lltx.

Reported-by: syzbot+9bda1b9fbb7fbdf9b62b@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=9bda1b9fbb7fbdf9b62b
Fixes: 84e54fe0a5ea ("gre: introduce native tunnel support for ERSPAN")
Fixes: 5a963eb61b7c ("ip6_gre: Add ERSPAN native tunnel support")
Cc: stable@vger.kernel.org # 9958e69b9893 ("gre: fix ERSPAN o_flags race/corruption in xmit and fill_info")
Cc: stable@vger.kernel.org
Signed-off-by: Yun Zhou <yun.zhou@windriver.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Link: https://patch.msgid.link/20261008093824.119453-1-yun.zhou@windriver.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/ip_gre.c  | 1 +
 net/ipv6/ip6_gre.c | 1 +
 2 files changed, 2 insertions(+)

diff --git a/net/ipv4/ip_gre.c b/net/ipv4/ip_gre.c
index e4878e9aa6367..149a4e83b6925 100644
--- a/net/ipv4/ip_gre.c
+++ b/net/ipv4/ip_gre.c
@@ -1367,6 +1367,7 @@ static int erspan_tunnel_init(struct net_device *dev)
 	dev->features		|= GRE_FEATURES;
 	dev->hw_features	|= GRE_FEATURES;
 	dev->priv_flags		|= IFF_LIVE_ADDR_CHANGE;
+	dev->lltx = true;
 	netif_keep_dst(dev);
 
 	return ip_tunnel_init(dev);
diff --git a/net/ipv6/ip6_gre.c b/net/ipv6/ip6_gre.c
index 04f7c70b7320e..3429543ec77e7 100644
--- a/net/ipv6/ip6_gre.c
+++ b/net/ipv6/ip6_gre.c
@@ -1864,6 +1864,7 @@ static int ip6erspan_tap_init(struct net_device *dev)
 		dev->mtu -= 8;
 
 	dev->priv_flags |= IFF_LIVE_ADDR_CHANGE;
+	dev->lltx = true;
 	ip6erspan_tnl_link_config(tunnel, 1);
 
 	netdev_hold(dev, &tunnel->dev_tracker, GFP_KERNEL);
-- 
2.53.0



