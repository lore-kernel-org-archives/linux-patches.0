Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032937;
	b=tpal9p+BYLvsw9Wv4pgJa0xs4lWGMHgTJxVziHw1SesR/yPNbL89Mk58i0k4HZzcoWDF
	 vFcr9qDfZghcefuu8PnurfuLTq3ZCiMWeq2tLn69ETnx6SnWtL7hEiv9ifgoTzBLyiW2u
	 Ml/K59gdzXSkSLEyaVssasYIc03a/XxC8OrRIVFRpKDzsZ56/YDPYVfSAc3+r9kQ/CDJN
	 yx3gUdAvT7SlCU1opFBy8Y9l/5/hBOtmB/dX7zkAC/MUm2V5OrBnoZsacy6eCE7DC2nSx
	 gHjEyAXkBCGFmwzbVV+1FwdzEAmG6pehYxUAF+boiWioHsECtaRtialfnmepN1P6bWw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032937;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=haYTH7RZ6JF7hlwLAjdxfocZvejGAoR0dZJNq+3eqgc=;
	b=E6R4wMAyokG/tuigxsVyKmYb1YJ14WAPnPDoQxX+nKdven5CqGQ02zl9i67caVX+qXjO
	 6AcIU9Hzv3s/GVmxsDdyl3GhffAlMsmxzmqmqESJ3q1nn/kUocJsMN25Vo/iT27KJRE/S
	 ILBNjmioXN8ey2+DNi22PZcgTl7Rg40FFaTQjLK+bCvC8teOK6n5ZTR4ja870zHJFvzPR
	 7U/q+peOh5RC+Lp6Je6q6I/fLuixB48hq7twvnAO6FdaHtnm5YsJVFsmyCXNuyDe9ph+E
	 jDxLhaBj7OStS4BYs5XKCPiDWdH1M91UU5hU0b2yHT5R/w0xbqxa4/VzAshJgBsM/nQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qVAUG7y9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D076606A32C;
	Wed, 18 Nov 2026 20:15:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qVAUG7y9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F56A1F000C4;
	Wed, 18 Nov 2026 20:15:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032937;
	bh=haYTH7RZ6JF7hlwLAjdxfocZvejGAoR0dZJNq+3eqgc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qVAUG7y9YsedXlerLaKBiAj/nQdFoMWbUtoKHB8GSOEBy3ymcsXXZl8yFsL4PEjjn
	 m5inf72BW8E1pTG3NG2C7hQf1dqOgoFx7hhsyy4A+JIHe+JHj0PO8bOaNRs/bbqirL
	 nVebyY+KO+MsrOO8DAS2K8En71K9ByY1dHk0PbeQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@kernel.org>,
	Ido Schimmel <idosch@nvidia.com>,
	Hangbin Liu <liuhangbin@kylinos.cn>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1588/1756] ipmr: clear skb->cb[] in reg_vif_xmit()
Date: Wed, 18 Nov 2026 16:01:55 +0100
Message-ID: <20261118150113.116026634@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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
index f9cec6b2bc1a3..560c4cd60c609 100644
--- a/net/ipv4/ipmr.c
+++ b/net/ipv4/ipmr.c
@@ -530,6 +530,11 @@ static netdev_tx_t reg_vif_xmit(struct sk_buff *skb, struct net_device *dev)
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



