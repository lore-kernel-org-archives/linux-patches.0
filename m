Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032696;
	b=TawbBK/s/vs6e5h/7hN5lc6Lq4FWwTuekHj735bgr/A6muSbMqFYaLvBrHpXh7owa2zD
	 7jPBzcxbTI629PtZynUw3uqsytdWk6CCWfM2zGSWkUnscpFtRDXHU6XDhModIulRpR83Y
	 se1VFTPx1nBauWx+ivlBXDXvotlplVLa95lOj5jwafIPqXmrA+gfjPXZHIq3wg/nh5Nrg
	 YHKPHuapsVHgrEHucAIkHLiPkXskeiG5VFTBLiOwNfxqX7p3PnX3SiI1yIyJym/jSm/hW
	 Rrg/d6SIecBEI6T5clvQl4KK6tA1DD/Tw7rHKPb82gQn+O1jRD1ckD1qUp1WW8GN8/A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032696;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hecomrR0kQgUz5Kt4dKS8gBEtzwLyHE9B/6Gskddr7Q=;
	b=Pf3mQ/vs/hohJN5yUpQ4161pW0pFi5Si0gxsv+C8xjxykIgp0xOX8555FTSsZXzBjXRl
	 ORHC+OkB6XTi0yybHkBdP47PFm9NcxCQKjOekm0hthnlH97xpF3amNvbHeOWJiFnjBfXt
	 EAzDEn+Zxkdkl+x12EuXeAUh3fz3/2Sd8jslC9yKskSKa6jrlCd2GrtT0kUlAUnHMTWBz
	 VaBOFItDXSVHUricNlHTkchvtZxn+DoRCTpqgz7H560d1Y6kJsbNucm7dBMH9xOkAUF3a
	 QQC2cbvklWyNt6ZOFdRhwlNhjlvYpNFu+9rFD7FBzCU20FbYBcYh8aQptkaqnB7Yo5A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MlrK6Oie;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F065E606A330;
	Wed, 18 Nov 2026 20:11:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MlrK6Oie
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A6081F000C4;
	Wed, 18 Nov 2026 20:11:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032695;
	bh=hecomrR0kQgUz5Kt4dKS8gBEtzwLyHE9B/6Gskddr7Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MlrK6OiekWszlooUzKBWvj3WiQf6qocTb7/TJ17CnhxD0VFBBXORbpNZypHnKTBMH
	 sQQffXyYDOZeUleHdeXpkHoct+Bv6U6iE5uk/rXysXT/Fs//hPTMfvD+7Jw5uoCQ0l
	 rluw50Wng9Ac/92IWYkuw6uGsS8jktYSneKF3wx0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ovidiu Panait <ovidiu.panait.rb@renesas.com>,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1466/1756] net: stmmac: Track the TX DMA threshold per queue
Date: Wed, 18 Nov 2026 15:59:53 +0100
Message-ID: <20261118150107.401376533@linuxfoundation.org>
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

From: Ovidiu Panait <ovidiu.panait.rb@renesas.com>

[ Upstream commit 9dd53418781900f02897c805eed397555cf98417 ]

Commit 3a6c12a0c6c3 ("net: stmmac: bump tc when get underflow error from
DMA descriptor") made dwmac4 raise the DMA threshold of the queues that
report TX underflows. This is done by incrementing a module global
parameter 'tc' by 64 on each underflow.

This leads to inconsistent TX DMA thresholds between queues and causes
issues on platforms with multiple stmmac controllers, as 'tc' is shared
by all of them. Once 'tc' goes over 256 the bumping stops, and queues
that did not underflow before are left at the initial threshold.

On the Renesas RZ/V2H platform, which has two dwmac4 controllers, we
observed sporadic iperf3 TCP TX failures:

  iperf3 -c <server> -t5 --bind-dev end1
  ...
  [  5]   0.00-5.00   sec  1.00 MBytes  1.68 Mbits/sec   87       sender
  [  5]   0.00-5.00   sec   768 KBytes  1.26 Mbits/sec            receiver

This happens because the TX queues of end1 were underflowing on a large
fraction of the packets, but the DMA TX threshold was never raised from
the default of 64 bytes. The threshold was not raised because end0
had underflowed first and had already pushed 'tc' past 256. Which
controller is affected depends on which one underflows first.

To fix this, make the TX DMA threshold per queue instead of global.
Each time an underflow happens on a queue, its TX DMA threshold gets
incremented, without affecting other queues or controllers. With this
change, 'tc' is only used as the initial value, and the RX threshold
is no longer bumped together with the TX one, as TX underflows have
nothing to do with the RX side.

Fixes: 3a6c12a0c6c3 ("net: stmmac: bump tc when get underflow error from DMA descriptor")
Signed-off-by: Ovidiu Panait <ovidiu.panait.rb@renesas.com>
Reviewed-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
Link: https://patch.msgid.link/20261013114503.57487-2-ovidiu.panait.rb@renesas.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac.h  |  1 +
 .../net/ethernet/stmicro/stmmac/stmmac_main.c | 33 +++++++++++--------
 2 files changed, 21 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac.h b/drivers/net/ethernet/stmicro/stmmac/stmmac.h
index db7bea0fcafe4..8d6507cef53a9 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac.h
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac.h
@@ -272,6 +272,7 @@ struct stmmac_priv {
 	int sph_cap;
 	u32 sarc_type;
 	u32 rx_riwt[MTL_MAX_RX_QUEUES];
+	u32 tx_threshold[MTL_MAX_TX_QUEUES];
 	int hwts_rx_en;
 
 	void __iomem *ioaddr;
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index ddaf43cdfc339..adb530635f30b 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -2381,7 +2381,6 @@ static void stmmac_dma_operation_mode(struct stmmac_priv *priv)
 	}
 
 	if (priv->plat->force_thresh_dma_mode) {
-		txmode = tc;
 		rxmode = tc;
 	} else if (priv->plat->force_sf_dma_mode || priv->plat->tx_coe) {
 		/*
@@ -2395,7 +2394,6 @@ static void stmmac_dma_operation_mode(struct stmmac_priv *priv)
 		rxmode = SF_DMA_MODE;
 		priv->xstats.threshold = SF_DMA_MODE;
 	} else {
-		txmode = tc;
 		rxmode = SF_DMA_MODE;
 	}
 
@@ -2424,8 +2422,11 @@ static void stmmac_dma_operation_mode(struct stmmac_priv *priv)
 	for (chan = 0; chan < tx_channels_count; chan++) {
 		qmode = priv->plat->tx_queues_cfg[chan].mode_to_use;
 
-		stmmac_dma_tx_mode(priv, priv->ioaddr, txmode, chan,
-				txfifosz, qmode);
+		if (txmode == SF_DMA_MODE)
+			priv->tx_threshold[chan] = SF_DMA_MODE;
+
+		stmmac_dma_tx_mode(priv, priv->ioaddr, priv->tx_threshold[chan],
+				   chan, txfifosz, qmode);
 	}
 }
 
@@ -2592,17 +2593,20 @@ static bool stmmac_xdp_xmit_zc(struct stmmac_priv *priv, u32 queue, u32 budget)
 
 static void stmmac_bump_dma_threshold(struct stmmac_priv *priv, u32 chan)
 {
-	if (unlikely(priv->xstats.threshold != SF_DMA_MODE) && tc <= 256) {
-		tc += 64;
+	u32 thresh = priv->tx_threshold[chan];
 
-		if (priv->plat->force_thresh_dma_mode)
-			stmmac_set_dma_operation_mode(priv, tc, tc, chan);
-		else
-			stmmac_set_dma_operation_mode(priv, tc, SF_DMA_MODE,
-						      chan);
+	if (unlikely(thresh == SF_DMA_MODE) || thresh > 256)
+		return;
 
-		priv->xstats.threshold = tc;
-	}
+	thresh += 64;
+
+	if (priv->plat->force_thresh_dma_mode)
+		stmmac_set_dma_operation_mode(priv, thresh, tc, chan);
+	else
+		stmmac_set_dma_operation_mode(priv, thresh, SF_DMA_MODE, chan);
+
+	priv->tx_threshold[chan] = thresh;
+	priv->xstats.threshold = thresh;
 }
 
 /**
@@ -7789,6 +7793,9 @@ int stmmac_dvr_probe(struct device *device,
 
 	priv->xstats.threshold = tc;
 
+	for (i = 0; i < MTL_MAX_TX_QUEUES; i++)
+		priv->tx_threshold[i] = tc;
+
 	/* Initialize RSS */
 	rxq = priv->plat->rx_queues_to_use;
 	netdev_rss_key_fill(priv->rss.key, sizeof(priv->rss.key));
-- 
2.53.0



