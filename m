Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590979;
	b=SDgfXpvjZSuuVRD9yO6pJmY+7SGDkpbzQXvxtURpiKKwva0x4afqiiwXgFOmCFB6PW+S
	 D5D3/j6wprCoW02SppVEFH7/qS7VPX7OCiUYnr1OxeacgZhK6VHwJ7HNGXe+ya9iYOHjE
	 oKQeS8qLTMbxaAcnl+CredYdPdMPw2XgTHfFloFmVOKGXNeEbz7H4fP5uOJTkcvfRBHSX
	 0/gCXt8/iJuaGJbMa0Y6pzMI65khXzge8ikPNStrqxa+36uky5W1FNMUMfa3Tc5FKPZKJ
	 yOMhiqJR4PW1idwbAJLUhPH5l1IczB5fMHHsWMOvYp9XnDq9/sL1Srr9PlBy8/3oMKA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590979;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=pMHS05qVVvzdzob7yRKG5zLViaU3ogZutD4mJAkUcvM=;
	b=VIpTkLp645qzul8c3L3LbXdfnLYMTWMGa/DDXhpTu6m2nGiBpZ7KUxjN7zK9DThyjNE+
	 OS5AcNjn4Hz5S7d7FGi1SSyd/Ifcqjjtp0OWTTrTjXo/7/K2pObFcdnVk8kiZV64nkxod
	 oggwZltKPL5G1JhuNg+OKAnMjMiccdsXIqptHn8AmOp9uOwVe3eFXgbqqE5Aj/ee0yHCZ
	 oF64+3MW9ZV9b74Noandx8+DZK2lhxSVz9/ovT+hwe1HZLqw2WRLpLhvFVvfuCMeUU5+6
	 9JdygJO8LxLlrixicbQOAONIKf60Ty4gPAy7MPykI6OdxiOa/IYqBukwzwV05IFIiBw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jhutG6KV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF17E60703CB;
	Fri, 13 Nov 2026 17:29:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jhutG6KV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B6571F000C5;
	Fri, 13 Nov 2026 17:29:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590978;
	bh=pMHS05qVVvzdzob7yRKG5zLViaU3ogZutD4mJAkUcvM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jhutG6KVj7VDySkQACxjfqwweD0p4T+ecckkupJ9WvQ0rapyKBqkZHSWsUWntCIEw
	 cLeOk15tVqUmsJB3Z4lJFT38w6gXZNf+rZsHpUvPZOdQppFqwQ7D3d5b+SFZ1okGRe
	 xmRZUxM4PKPKklWKgDl19/nMtuxTTi507DE3Gbe8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+9bda1b9fbb7fbdf9b62b@syzkaller.appspotmail.com,
	Yun Zhou <yun.zhou@windriver.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 156/670] net: erspan: set lltx to avoid sch_direct_xmit deadlock
Date: Fri, 13 Nov 2026 10:45:20 -0500
Message-ID: <20261113153817.428085998@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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
index 5bf6c6777c348..f4a269938340a 100644
--- a/net/ipv4/ip_gre.c
+++ b/net/ipv4/ip_gre.c
@@ -1362,6 +1362,7 @@ static int erspan_tunnel_init(struct net_device *dev)
 	dev->features		|= GRE_FEATURES;
 	dev->hw_features	|= GRE_FEATURES;
 	dev->priv_flags		|= IFF_LIVE_ADDR_CHANGE;
+	dev->lltx = true;
 	netif_keep_dst(dev);
 
 	return ip_tunnel_init(dev);
diff --git a/net/ipv6/ip6_gre.c b/net/ipv6/ip6_gre.c
index 7cf429f11a1d0..9cb3c1fea4c91 100644
--- a/net/ipv6/ip6_gre.c
+++ b/net/ipv6/ip6_gre.c
@@ -1902,6 +1902,7 @@ static int ip6erspan_tap_init(struct net_device *dev)
 		dev->mtu -= 8;
 
 	dev->priv_flags |= IFF_LIVE_ADDR_CHANGE;
+	dev->lltx = true;
 	ip6erspan_tnl_link_config(tunnel, 1);
 
 	netdev_hold(dev, &tunnel->dev_tracker, GFP_KERNEL);
-- 
2.53.0



