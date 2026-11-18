Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027967;
	b=K8ZXetq411/EFyqhD4zMY7403hYQ5EV72UZWMiSVi6CYU2RSA3s4wWn7nvSu0cpnyLUm
	 ZfQbhfCbdtBWaNd8CSuFpSzDsOOaVXOVAaPLliTVu+FzvzfmjK1BZY/GGoH0PXh241Cju
	 eCinFi7U0QsB2Hpa/7xfN2Usc2KHj2epKKNnPAxt1OnbmtOZWr+lAyYPsqg8q5b6yNL/h
	 uMiYL0UApGdXh32YlUiCnQBHIX8BtezhhKLzHvnfsznn5KZ5ER+kZvBgkfBIrZN6qpvTp
	 Js/ALuX7oXA1zlsZUs+LFkwah1y59csAHwSoTDE7McHsweYIAra4rjYeBjkJlSDlEjw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027967;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ybo7bZTMbNTpxYc68u5/1alhbBEus2oqFc+qMu+F5dY=;
	b=SimEV4FDc4U2jyvcnbx/9Spqez50QMN0P0RjelkFHabc/qAjvRJJX+Y+qKJsqUNi8Ddx
	 5JLqHMBk2CxQZK3vGjGcsspXtJaALPrAOBq0PLYXZd5KlFOTrntouXh8xyIkKMRn2lIKX
	 QOLTVdiMsU8+JPKkNtiMCjdVRhXp5ciofwL0NEd++k1SloIvx/9qKpdqm/Tf7eGOm6yrc
	 qox0sMszyd/r8RVUuvblYhvD+2b6TB4YReCBOafuXPcTPicq8dGv/Oa3e6E2MA90RcUp6
	 QDnGabvMIeISHV9QO+Yu8Tcfisp/z2ELdxaVTT6BMvAkhXckNPOaliAFxq1bgTRARPQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=M6xTmduQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0637606A31C;
	Wed, 18 Nov 2026 18:52:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=M6xTmduQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3BC61F000C4;
	Wed, 18 Nov 2026 18:52:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027967;
	bh=ybo7bZTMbNTpxYc68u5/1alhbBEus2oqFc+qMu+F5dY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=M6xTmduQrBGt2kS32quzAr2Xi53Ayr3nICibtJ/r72PlCLYDqSk8dXT3d5U49bdDc
	 9Ff0/RrqJFQPdiB9aMOFN+HmqttazHKpd0NRiUXTJWt1JxeAh+GbvFfcCftdTorlNy
	 qB1eTCxgJ5vluXh4Pp5irA8ZPYlP3cFcPb2Qdir0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@kernel.org>,
	Ido Schimmel <idosch@nvidia.com>,
	Hangbin Liu <liuhangbin@kylinos.cn>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1977/2151] ipmr: clear skb->cb[] in reg_vif_xmit()
Date: Wed, 18 Nov 2026 16:01:52 +0100
Message-ID: <20261118150233.758736585@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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
index 5133fd14029e2..06c981accf3ca 100644
--- a/net/ipv4/ipmr.c
+++ b/net/ipv4/ipmr.c
@@ -547,6 +547,11 @@ static netdev_tx_t reg_vif_xmit(struct sk_buff *skb, struct net_device *dev)
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



