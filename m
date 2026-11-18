Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050531;
	b=A8PgZa7siSVQ1WEex8IvEuIK4BV2omaeWPNMrasTQSzS5aXaKhZ7w/6KFvIqZQQuIcIE
	 vIC1Bo0GJHE91QZ2LB4hDPT1g7n5E5YHpKFTCh1H4sA0fMXjl/AZPYrj3ONvzJTWzD3T2
	 DCtRjFJjZcMbggH3Bgu+jaiK1Qin1298Zx2VlNgLT9fPqKZtNdQXPW4Rm3YN/SRsz77g3
	 tN3Tn4iKtBl2cMiTiNrB0b8PDBVDM9svPnbWa1IzWGWsw8q0Vj0LJpp5lkZQvktRWdFGn
	 7HMOk/JSvCUG7ueJ8h8R72Qrn883BKtUpj9M+Io4Ej9vW9Y/xam3RVG/+TjZWFsK5mA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050531;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=M/2hPykOZODtyJsGhnCcLo+VU61j9hvs/7aW0Av2dKY=;
	b=4DV0xbZDhmFXtdYHjIyk4PTEAQOR+vDCIe6ccJb+0JrBsVQNZchbNpa8RWkS73TvyKzE
	 hC8XNLhTX1jtwDHYPPUNf2m1aIMK15OndWj3dhI1I+Ikwikt8CltPmC0+s//TnU/Z/Qtt
	 CoOJeARIplyKccP/XbcNZIJvqN2NKgBD5NZvEj8zG7pPdXs1I1kEP2mupvA1cCajT24e6
	 2LuT7ymsHt99TvHyJAP+o452yWrcWtMNfqyT9LOqhDSy1nkOcro4CV2bl3cuPbjHresGx
	 1RzAPKVhHQXM1jOjydQAM6/HHJ3QKgeUYXw4T7py2r+ZSCUs/g4kPintiz1P1gk0nrQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jqG+0HwV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE7C9606A31C;
	Thu, 19 Nov 2026 01:08:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jqG+0HwV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40D7A1F000C4;
	Thu, 19 Nov 2026 01:08:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050531;
	bh=M/2hPykOZODtyJsGhnCcLo+VU61j9hvs/7aW0Av2dKY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jqG+0HwVGC8IRFz65wCkAdYXH/DdR/lTR4jW+Z8eWbgxx1y0Km4k2AOnUX2TpJekf
	 0wMRXv5+oGaKvIx7+ZjLUh+GuRSG2K9Phd/8lw/Lb7awodUSbLWUzNA5Xc3uX7ZYm0
	 UKSM5zfhNg/94FiPL3nNJij//+slSsFsSSzhbi2E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@kernel.org>,
	Ido Schimmel <idosch@nvidia.com>,
	Hangbin Liu <liuhangbin@kylinos.cn>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2740/2857] ipmr: clear skb->cb[] in reg_vif_xmit()
Date: Wed, 18 Nov 2026 16:02:54 +0100
Message-ID: <20261118150340.272261003@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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
index c79267abadb85..7666bfd8cdd7d 100644
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



