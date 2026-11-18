Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042462;
	b=U4zuceRp/1FxQAxCxlN6d8XykYxiSXzVqBc7jT6/aF6GN4HpP1KHBPnQh2ypne7cnWoK
	 S2RetAnD2a/r3au6I7LQd8iWAigkut9SCqXw5VL+sBxkF3mpq9bucoqIx9fDbowS5Pg6/
	 OqM8YFr5yiGu+Ho/dEA+zCtx+TE5RG69OTnF6TD2+v9CV0q5Ec26ODOti52bmYoLRZ5to
	 fkmycvBbDSuaq9dVDSsddcqHwlMHJ3T8RLoX0cXlKqqDxvlwx6AWR133MEVTYjFPtvJrP
	 8LTOUbjxFYrskC2xiWj/NuQjzxD69aQJYSpDOYVj7WzhhLGpswjAcj5MpiKwV4mBVRA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042462;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JXoO23OgfHzAeYVBI4AK0D2vuPorOhR6WQeKIY7znr0=;
	b=kycSkQAZqWYz8IPaFtfzvugl29ZtO656Zt0/m3GMsp/04xB0iAnLTPYhSo5e4ZJ4WTh7
	 pEelloAZ1qCFi2gN+lNogtY8mbEKmhcnH3RZtw0JQHbRTxTwG4eKJLgC3ikn/E+iy39GD
	 PngXmjjZWqSQoUcBKHzk483fsm9VlYlXjvlJk1R/JRMl6I2n1Atb4LYxB5ibKr5aFz1Qs
	 3AUhCUrT/8VkPhAa73m2qWL1gkkoavsDoiDDdO5rbPOtqArEMljuMNarmiaFMRaeNJ/W7
	 2uBdGNimJ4tVTWyIMZlxsF2g4Zm94KSIwJsdZJkZz/QkkAP6ZKI+HIMQU/RRNHSF6rw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=k8MTOJWk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DE0A606A325;
	Wed, 18 Nov 2026 22:54:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=k8MTOJWk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB8521F000C4;
	Wed, 18 Nov 2026 22:54:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042462;
	bh=JXoO23OgfHzAeYVBI4AK0D2vuPorOhR6WQeKIY7znr0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=k8MTOJWkTNEWCHsqUGGszKiKVEjF51i9yyR5S0V+Luk3MjucdBT1BM4X+g0eRUmd5
	 xkZGPOMGOKwq5juMRpsdbHtIz8nmp+2Yfxul0KY/2UYrAJPbjtwf9pV4UcCWQztWiN
	 GdhnVy+9l7CJG7FrCs96JnFg0aZYLE6YoqoDSTL8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@kernel.org>,
	Ido Schimmel <idosch@nvidia.com>,
	Hangbin Liu <liuhangbin@kylinos.cn>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 3179/3318] ipmr: clear skb->cb[] in reg_vif_xmit()
Date: Wed, 18 Nov 2026 16:03:21 +0100
Message-ID: <20261118150455.189923787@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@kernel.org>

[ Upstream commit 389952e8776a4663044df2ae3e8987a9e81964cf ]

reg_vif_xmit() hands the skb to ipmr_cache_report() as an
IGMPMSG_WHOLEPKT report. When the mroute socket has IP_PKTINFO
enabled, ipmr_cache_report() calls ipv4_pktinfo_prepare() on the
original skb, which reads skb->cb[] as IPCB.

By the time the pimreg device transmits the packet, skb->cb[] is not
IPCB anymore: qdisc_pkt_len_init() overwrites IPCB(skb)->iif with
qdisc_skb_cb(skb)->pkt_len, and any qdisc installed on the device or a
tc BPF program writing skb->cb[] fills the area holding the IP options
and IPCB(skb)->flags.

For locally generated packets routed out pimreg (they carry an rtable
dst), the mroute socket can therefore receive a bogus ipi_ifindex
(the packet length), and the l3mdev slave test in
ipv4_pktinfo_prepare() is driven by stale qdisc data.

Clear IPCB before building the report, as done for IPv6 in
commit 238164201431 ("ip6mr: clear skb->cb[] in reg_vif_xmit()").
The skb is freed right after, so nothing else depends on its control
block.

Fixes: bb7403655b3c ("ipmr: support IP_PKTINFO on cache report IGMP msg")
Signed-off-by: Eric Dumazet <edumazet@kernel.org>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Hangbin Liu <liuhangbin@kylinos.cn>
Link: https://patch.msgid.link/20261025111337.142787-1-edumazet@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/ipmr.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/ipv4/ipmr.c b/net/ipv4/ipmr.c
index 3e9c821ba5c5c..f73ff36c6bed1 100644
--- a/net/ipv4/ipmr.c
+++ b/net/ipv4/ipmr.c
@@ -529,6 +529,11 @@ static netdev_tx_t reg_vif_xmit(struct sk_buff *skb, struct net_device *dev)
 	DEV_STATS_ADD(dev, tx_bytes, skb->len);
 	DEV_STATS_INC(dev, tx_packets);
 
+	/* skb->cb[] holds qdisc/tc state at this point, not IPCB.
+	 * ipmr_cache_report() reads it as IPCB to build IP_PKTINFO.
+	 */
+	memset(IPCB(skb), 0, sizeof(*IPCB(skb)));
+
 	/* Pairs with WRITE_ONCE() in vif_add() and vif_delete() */
 	ipmr_cache_report(mrt, skb, READ_ONCE(mrt->mroute_reg_vif_num),
 			  IGMPMSG_WHOLEPKT);
-- 
2.53.0



