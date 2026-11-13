Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590153;
	b=2criDcudmXI9lp3UfVq32Yn5s9I1B25AGwOv01ItT0AoWWn7ZEwr/O2SyK4vs35lLOJ/
	 ovMh3eLPd7E7fgKv/r8GuVFqDVvRGAcwrxJKwTPrCZN9FOayJnt3C2FGY5mJKnhLp1NC+
	 Iji6NxKdNtKjTiUbPTmAfXLh6eAPbL+gTxQIf2KxK5VOhhPtzzQXvKK1lUX6lKGsrx0AU
	 GK2f7/aTYMkTyj2s5EEV1hCEodxF6yrBlZxKQ0wyoAE1T6KmrPCPvtp7nX3CluD1EeiEW
	 /aMzfJHBkvdX3rUpxNWcmR/uZcpGc9Y9w+ozzQrsK1ZGEvecfofUdkMZxoLoma/bx7w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590153;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BPSCdA6tdUqkXxuzcZ452slkOA7Zj0ffriTE9EzLZ50=;
	b=bjf5JtLMFsV5VGPg+Uaf83kxJeXMuQEXuBGm3gNArmLxDsbKTmVZHRiW5bW9bzaHL4Dz
	 ROuBFOUfsGrqfVhVw7vG7NW/v9Bj/PREktyK/U2Ly9bAphtAdAZuJqBBmrnqqDP7FBONc
	 DnR2QVGYv3GD8ESQsQDveg9fMdCm/FYpHrq2HRi+NUzTW7oMXs1H+I0JsKSPtUCwFm9Vx
	 jhcoTyuuJW4bT0iLF+qPQKyl3bUTh+OEByLs3RXv7BEKfNTfQRcdtpdxFB1fIu94vaTmZ
	 oU835relvmYuOr+VF4PJi/0i7Vqpf07iOqyaKQ/ASbwUnl0PWFX4hC0uvelI4PT3mgQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wnNNKS+e;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA48D606D4A1;
	Fri, 13 Nov 2026 17:15:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wnNNKS+e
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 963AD1F000C4;
	Fri, 13 Nov 2026 17:15:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590152;
	bh=BPSCdA6tdUqkXxuzcZ452slkOA7Zj0ffriTE9EzLZ50=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wnNNKS+evuA0dQmsopqLcuSLlbyba7dAYysT98BskkFKVRRQLB2eP79xXQFZVXewG
	 V0LGPKbjHOcVOp+i6k44BzKpause7dzqXIV9YtuaeDcL89GW+HUdQ0dWskVHNa4Jn6
	 os778JWlK2MyYGk1YjEq5sbZIcWW+O/d2/E6nea8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+9bda1b9fbb7fbdf9b62b@syzkaller.appspotmail.com,
	Yun Zhou <yun.zhou@windriver.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 166/686] net: erspan: set lltx to avoid sch_direct_xmit deadlock
Date: Fri, 13 Nov 2026 10:44:59 -0500
Message-ID: <20261113153826.431439980@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index b1ec4f92d3462..7df1ada13c2a1 100644
--- a/net/ipv4/ip_gre.c
+++ b/net/ipv4/ip_gre.c
@@ -1366,6 +1366,7 @@ static int erspan_tunnel_init(struct net_device *dev)
 	dev->features		|= GRE_FEATURES;
 	dev->hw_features	|= GRE_FEATURES;
 	dev->priv_flags		|= IFF_LIVE_ADDR_CHANGE;
+	dev->lltx = true;
 	netif_keep_dst(dev);
 
 	return ip_tunnel_init(dev);
diff --git a/net/ipv6/ip6_gre.c b/net/ipv6/ip6_gre.c
index c14c76b78b984..17c5e9440bfa3 100644
--- a/net/ipv6/ip6_gre.c
+++ b/net/ipv6/ip6_gre.c
@@ -1863,6 +1863,7 @@ static int ip6erspan_tap_init(struct net_device *dev)
 		dev->mtu -= 8;
 
 	dev->priv_flags |= IFF_LIVE_ADDR_CHANGE;
+	dev->lltx = true;
 	ip6erspan_tnl_link_config(tunnel, 1);
 
 	netdev_hold(dev, &tunnel->dev_tracker, GFP_KERNEL);
-- 
2.53.0



