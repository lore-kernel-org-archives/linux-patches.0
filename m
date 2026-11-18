Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032828;
	b=GCX9dRVUDYuru+GZPxF6rEhUciYXqltDfxvrWiOCb5UXv4M4KqPOO0/uX35b0GeVRShH
	 HHvQDmXqJ6ktdr7tPcLxuhRkvEoz8RxPFV/2sKtddAaTLhDO24mUutdET/WlAEdH02gC5
	 XNwCqW1Gc8rUjwE/dTNyliQT8etjh0w0qvKGfQk6qQBTivXSGNyKWIAM56kMOYa3tDMSi
	 SxoCdcH7ZbMAWuedrHtNHl39ZtQY5mAk8aV+SiylCOAQq/kh6zWDf8zIzcQFMyQs2XmRQ
	 OyUqI3rSozJ3oLOwBdrW1sLZCx1EuJC5wlECHkApd1FU6tN7gfLexzuWeXFC8WLL+NQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032828;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jdwRx7ZpV9bGadKlRyaRpLSAnLTcyhFTDkTIGNCLShU=;
	b=vkJN30rl1RMt+sIfHL/8R7NVQBnB8HjnI4Lledgft3vBimd62TJDuwXhgLkAgCbjVF3x
	 1U44UZuezo5mdlnCwU7uB9mFht/hYu78BDGfsRW9K+em8RYvF056L6mDK9lcAumlAM+bh
	 Bl0K2e2BW4OpzrUmODUcDXDUDCLrYsmCsnqJFNpDK4Lex0LakkOXGLIE3/qAg6+702csb
	 zGS7H/5wjwYL3BCuoWz8xo+4qqI8evVU4TmPGOZueCl4WTIQstIXurE0z+JwnrjmlzKpm
	 TuMVDA8xOeF9DRTpuRLT8pkp6OxjtEalcWkPMV4YBobIRSFIK8p3+1Vi19+bnNx8fRg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ljGZhXvD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F5CC606A320;
	Wed, 18 Nov 2026 20:13:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ljGZhXvD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F39B31F000C4;
	Wed, 18 Nov 2026 20:13:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032828;
	bh=jdwRx7ZpV9bGadKlRyaRpLSAnLTcyhFTDkTIGNCLShU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ljGZhXvD4bXUJnGkGh1RcvkPNesLPDf0KMvKyPcIsyVIgQA6JJNuJMvhLK8EpWprr
	 2dGOfSTcUqlrwiDYGMBZWVjEfWDmRoK9vzG1IztK7mmvH/EI3o8GUTeuOoRyCVVNIX
	 SSPWX9HSwxT0zL+CWA7InxPxZJP98O1NOjsExIh4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tianyi Gao <tianyi@cloudflare.com>,
	Mohsin Bashir <hmohsin@meta.com>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1513/1756] veth: schedule the peers NAPI after XDP_TX when only GRO is enabled
Date: Wed, 18 Nov 2026 16:00:40 +0100
Message-ID: <20261118150109.114820150@linuxfoundation.org>
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

From: Tianyi Gao <tianyi@cloudflare.com>

[ Upstream commit f16b8c6a656e62bfa7bb6a3b876f9ccdaf53bd43 ]

veth_xdp_xmit() queues XDP_TX frames on the peer's ring if the peer has
NAPI. A peer with GRO enabled and no XDP program also has NAPI.

veth_xdp_flush() then schedules the peer's NAPI, but only if the peer's
xdp_prog is set, so for such a peer the frames are never processed.
Nothing else schedules that NAPI by default.

Once the ring is full, every XDP_TX frame is dropped, and so are the
skbs that veth_xmit() queues on the same ring.

Commit 0e672f306a28 ("veth: check for NAPI instead of xdp_prog before
xmit of XDP frame") changed the check in veth_xdp_xmit() but not the one
in veth_xdp_flush(). Make veth_xdp_flush() check the napi pointer
instead of xdp_prog, as veth_xdp_xmit() does.

Fixes: 0e672f306a28 ("veth: check for NAPI instead of xdp_prog before xmit of XDP frame")
Signed-off-by: Tianyi Gao <tianyi@cloudflare.com>
Reviewed-by: Mohsin Bashir <hmohsin@meta.com>
Acked-by: Lorenzo Bianconi <lorenzo@kernel.org>
Acked-by: Jesper Dangaard Brouer <hawk@kernel.org>
Link: https://patch.msgid.link/20261016214217.16942-2-tianyi@cloudflare.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/veth.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/veth.c b/drivers/net/veth.c
index 0fc14b73d24a2..6f8de3e775033 100644
--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -615,7 +615,7 @@ static void veth_xdp_flush(struct veth_rq *rq, struct veth_xdp_tx_bq *bq)
 	rcv_priv = netdev_priv(rcv);
 	rcv_rq = &rcv_priv->rq[veth_select_rxq(rcv)];
 	/* xdp_ring is initialized on receive side? */
-	if (unlikely(!rcu_access_pointer(rcv_rq->xdp_prog)))
+	if (unlikely(!rcu_access_pointer(rcv_rq->napi)))
 		goto out;
 
 	__veth_xdp_flush(rcv_rq);
-- 
2.53.0



