Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042127;
	b=OsTMvyvRwdSKmOjSKUetJko93wg8kS3CeKvKZAMmyvqXEKjLmAZxRJXg1/+AyfQAttJx
	 sTjhWVZdnas+/kyL3eCU8vdDMvVHF5OKUzM4+vm+bkqSF9KJHY9jZoRLcHBFXu4z/TKmO
	 kyLAK52okQOSNSZrzcTDHnlag6RTAhQA12SqqYpW6JTS28wJdn7RvQHr6Akc6JV63SyxF
	 wtsHtc7d7g2Ov2wpYvhW7L2hFmArIsvZyvSBT4MkHN6+5nxwZsJ7DZRmJJ/KzElXTvoC7
	 FCE5tsx5P8UzYcs5GK2fjvF2l373ZkRjv0qz9hKErraE16nu5oZAyYxkgmPqHTTUkxA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042127;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=sQo121DW6dpFUOuyl/dUhIYtgMuhZ2ijMCjGvkfwE/g=;
	b=UR2CvBYhKMKE1vuCl3tXY8oe9M/WVSeafVBizqz6dihokmP0BkAlwcjWGqRmic9UvW/S
	 AaYVJt4Get2b7yuejtuxohYe029KqCE1LJe8STfbP92ytKkiVYeFmJwvJZxr0iEHUuRb1
	 6SU0cmTX0qUvDW3nEP71StW8zn5rNscR8cl2ZQ79TlyWBjd35b5H8SlP+UwdCx5jOq0T5
	 DqX/FTOB4GuM50ssKQwgI4qe85Vaij+80eetrmR+KEa34hb166zrge02hZiYW+3HNtyqz
	 0MlUxUnx6F5Bnwo1VxOSBL2MEOKZiD1ZbTk9VRdvdi8ViTvLzn0Zo2r2jqKFcTMNywQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=u1bKtIPB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34D7E606A31C;
	Wed, 18 Nov 2026 22:48:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=u1bKtIPB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87FFD1F000C4;
	Wed, 18 Nov 2026 22:48:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042127;
	bh=sQo121DW6dpFUOuyl/dUhIYtgMuhZ2ijMCjGvkfwE/g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=u1bKtIPBCIRPhwDXj2JGHSrJCGy6s8mA/p7maY4Umzb6VSNL8Ugk9YfAVqTBP0oEg
	 GgTVHTg5dcl9N8IWtrQKlsr4O24+QIkKGLtqJIDi/ZeVFpP61i36bpVYU/mIgASfyl
	 fYskjOd4C3BmZ3CAf26X5JFlb6qF+fCyP/RRIAUc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengfei Zhang <zhangfeionline@gmail.com>,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 3058/3318] net: stmmac: xgmac: do not treat TBU as a TX event
Date: Wed, 18 Nov 2026 16:01:20 +0100
Message-ID: <20261118150451.877374173@linuxfoundation.org>
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

From: Pengfei Zhang <zhangfeionline@gmail.com>

[ Upstream commit 305deb54c6c287e586bed92da2375ae1220e8dde ]

Commit 8d07a7930434 ("net: stmmac: xgmac: Do not enable TBU interrupt")
removed TBUE from the default DMA interrupt mask, but did not remove the
TBU check from dwxgmac2_dma_interrupt().

TBU is set whenever a TX channel runs out of descriptors. Since TBUE is
not enabled and only enabled bits are cleared, the TBU status bit is
never cleared. As a result, TBU stays set on every idle TX channel,
regardless of whether there is any TX traffic.

With a shared interrupt, stmmac_dma_interrupt() checks all channels,
so every interrupt from any source schedules TX NAPI on every idle TX
channel.

Only use TI to trigger TX processing.

Fixes: 8d07a7930434 ("net: stmmac: xgmac: Do not enable TBU interrupt")
Signed-off-by: Pengfei Zhang <zhangfeionline@gmail.com>
Reviewed-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
Link: https://patch.msgid.link/20261013024747.2688984-1-zhangfeionline@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c
index b2c03cb65c7cc..29add2335b80e 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c
@@ -366,7 +366,7 @@ static int dwxgmac2_dma_interrupt(struct stmmac_priv *priv,
 		u64_stats_update_end(&stats->syncp);
 		ret |= handle_rx;
 	}
-	if (likely(intr_status & (XGMAC_TI | XGMAC_TBU))) {
+	if (likely(intr_status & XGMAC_TI)) {
 		u64_stats_update_begin(&stats->syncp);
 		u64_stats_inc(&stats->tx_normal_irq_n[chan]);
 		u64_stats_update_end(&stats->syncp);
-- 
2.53.0



