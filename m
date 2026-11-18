Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019274;
	b=v+deOIMeAStLos86ooZkHJzBcY3LvHzQCn3MS+/vw2+15P+RH2ZE4bO4eMFXzm4BjeOz
	 Fn7ZHU3zq4Kx8PdFJStHU31dMoz1n5Fa8lAYbSRN6LrnOQpWTktSL+NTD2lkIykWdDKiS
	 BTIwVQhWpQCUcwGzoe2laS0HxF/T4wUE1b9+gGxvLqRKGxApxiLwN533ETCNzryB2rCGA
	 0mTEXpfYd15XQxxCfcHFX9IKGgLkrIaopE2FQQT5ui4233RWoSv9hc7jiUaM4EMy4oolX
	 uktpWSIUkEXPli0iLu2/K0gsw3pwky4/r3vp1YjirUQBjSvV1XvCMO7hry8yVugt1pA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019274;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=n4IAcfpR3ljrnDUj/PFuxLqnQgTRm6uVi1NzgeVelSo=;
	b=NCHjCMY0ETe4wbsGRbeUabwNRpKQaWVZnpO8Qc+e+pDlNjxXCJfwt5NANPIGN9sCUIS5
	 6ijqEK5sK4ODzMA60xqaDRLafOckgHhjt2Y8iyGTlncghGBwQUOjoHV01MTCs7pFVoOM4
	 JrTNQ1Gd5pV0DToAQqqQF9O3KiVzri3bj/651aiUbD/4y2m7ITMYUynii23fnguSbSnH1
	 vxMNnE8wwGThwRntfUN+T2nXUK0HFqk/bsXbmdneodxI/tAzOmJsXsdB6yFQfO5vOpIiL
	 scElRP1NA/IVKR7WBE/cSnoTTK1pGQMVXGyiGff1bzDRm20N/SSYwTOMj6E2JWttd3w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2gV0ExvU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F54660A2600;
	Wed, 18 Nov 2026 16:27:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2gV0ExvU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4008C1F000C4;
	Wed, 18 Nov 2026 16:27:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019273;
	bh=n4IAcfpR3ljrnDUj/PFuxLqnQgTRm6uVi1NzgeVelSo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2gV0ExvUOUsJ9h7YPZZkTYHfMh9JkGaHcSXQKoFFNXdNnoy6mQi9dKp1zjWDwkzRG
	 FmsUqMvLgqxB0JmFrn7cA0F6YVVCwhzeQ2OaZZnJbpybaGYXX2kbtG2o7Ez3LChwSJ
	 6wVkLL/jaL5IryZiryATZ5qIYPcNQpgEH8kuYJnQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@kernel.org>,
	Vikas Gupta <vikas.gupta@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1538/2651] bng_en: pad short frames before sampling nr_frags
Date: Wed, 18 Nov 2026 15:46:18 +0100
Message-ID: <20261118150343.341652839@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

From: Eric Dumazet <edumazet@kernel.org>

[ Upstream commit 056d046bf530d44bff5ce13a0addbc50c14ac95f ]

bnge_start_xmit() samples skb_shinfo(skb)->nr_frags into last_frag,
and stores it in tx_buf->nr_frags, before calling eth_skb_pad().

If a nonlinear skb is shorter than ETH_ZLEN, __skb_pad() calls
skb_linearize(), which pulls the frags into the linear part,
releases the frag pages and sets nr_frags to zero.

bnge_start_xmit() then uses the stale last_frag to fill TX_BD_CNT()
and to walk skb_shinfo(skb)->frags[], DMA-mapping pages the skb
no longer holds a reference on, and sending their content twice.

Fix this by calling eth_skb_pad() before nr_frags is sampled.

Found by Sashiko while reviewing the similar bnxt_en fix.

Fixes: bd5ad9c052c8 ("bng_en: Add TX support")
Link: https://lore.kernel.org/netdev/179134695789.434549.53526916334276884@kernel.org/
Signed-off-by: Eric Dumazet <edumazet@kernel.org>
Reviewed-by: Vikas Gupta <vikas.gupta@broadcom.com>
Link: https://patch.msgid.link/20261007075649.468033-1-edumazet@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnge/bnge_txrx.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnge/bnge_txrx.c b/drivers/net/ethernet/broadcom/bnge/bnge_txrx.c
index 7d45e057f2e82..472b02cc43b3c 100644
--- a/drivers/net/ethernet/broadcom/bnge/bnge_txrx.c
+++ b/drivers/net/ethernet/broadcom/bnge/bnge_txrx.c
@@ -1490,6 +1490,9 @@ netdev_tx_t bnge_start_xmit(struct sk_buff *skb, struct net_device *dev)
 			return NETDEV_TX_BUSY;
 	}
 
+	if (eth_skb_pad(skb))
+		goto tx_kick_pending;
+
 	last_frag = skb_shinfo(skb)->nr_frags;
 
 	txbd = &txr->tx_desc_ring[TX_RING(bn, prod)][TX_IDX(prod)];
@@ -1513,9 +1516,6 @@ netdev_tx_t bnge_start_xmit(struct sk_buff *skb, struct net_device *dev)
 	if (unlikely(skb->no_fcs))
 		lflags |= cpu_to_le32(TX_BD_FLAGS_NO_CRC);
 
-	if (eth_skb_pad(skb))
-		goto tx_kick_pending;
-
 	len = skb_headlen(skb);
 
 	mapping = dma_map_single(bd->dev, skb->data, len, DMA_TO_DEVICE);
-- 
2.53.0



