Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625351;
	b=XtdqckAdpeVXPrQw0wUG41vzunwWUfitVi0YCkUrNnKjuTS4m6S2JdfDht9wxAsyhuZX
	 bwwic7aK4OZmQEurHvoFfMKs2iiZqYn/55BmEoGH5vKKOJHIy4gEtLjnx99Ao06J+sFc2
	 s9XQ4NaLTmEEvMilAxE7ChfMaYAa/6wqprbxza/CSaqFY90sE1/U4z+dwAdLN4h4TbFkA
	 6P8Yp4ytHM0/yOFyKW/nsuzVfTEpUe9+hPJpVE6J/9m6P0/FtkfAmOs19nYRsrgI0Ry5s
	 2u4h0z/NGg3LaMCoG3ltIB3K5lTfBSMBZyp3Gp6LN2ajGW2WvTr16GITtTK26ztpZtA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625351;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=w8kLf1rEmTRCOD/OFBjFogFknDH0ow5xEQi0Ss+dUjU=;
	b=X8LSgRpitriO5Qf9iBkMxvG4NmwZWyZZ10SkSPvf1pfVhB+uszyVyhWRyu7f6xtRBgLD
	 Z/nWcgLQ4dgXbUMab8FydCuo9A5oAgsGyXJFJloCQe6+RvoyGLdk4eV9GDFEfdWY/5JKj
	 XPnq+hMY7ckiMsPr+Tz47JFQnEn5nOEou3XFfjFMi9Ylx+9OmBURO33oDFqsXs8GURVCQ
	 t0bVVey2CxzC0ekLgVMQomtM8YgLaBzRTyEc+o6I2d96Key4ZR1Ng0vLfCJD2b8Sn+WOQ
	 212alp5L3r3MjWUy2mHRXCr1vcvpngBLsX3mHM0XPEQ5mK5TK8SorheqVuYAysGz0yw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Q6M3A68W;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6469606A31E;
	Wed, 25 Nov 2026 16:49:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Q6M3A68W
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 990801F000C4;
	Wed, 25 Nov 2026 16:49:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625351;
	bh=w8kLf1rEmTRCOD/OFBjFogFknDH0ow5xEQi0Ss+dUjU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Q6M3A68W5gQgoL3J72CN604ihxtENaWeuz2fiWDZPGT5/kQqHOXrBh1LRgRnSEUMp
	 1GF2xBZ3b8RPhunlc292LzUltrlzlc13UVDTgUHPhHZ5k/bC/2257wcG1EVdqDEqfc
	 k5IaFgPGKpohqw3MO3gSa0GGlGgqqiuG8UX5nIRs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>,
	Daniel Thompson <daniel@riscstar.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 488/816] net: stmmac: align real_num_tx_queues to mqprio configuration
Date: Wed, 25 Nov 2026 15:33:56 +0100
Message-ID: <20261125143900.490119277@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

From: Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>

[ Upstream commit ac1ca0c3e139a2ebef2fc6c570af6647329726f1 ]

stmmac_hw_setup() unconditionally sets the number of real TX queues to
plat->tx_queues_to_use on every device open. When a tc-mqprio qdisc is
offloaded the driver reduces netif_set_real_num_tx_queues() to the number
of queues enabled by the offload, but the next device open reverts it to
plat->tx_queues_to_use while the netdev TC map is still the one programmed
by the qdisc, leaving the two inconsistent.

Track the number of TX queues enabled by the current qdisc configuration
in the per-qdisc state (priv->xmit_qdisc.num_tx_queues) and use it in
stmmac_hw_setup(). The field defaults to plat->tx_queues_to_use at probe
time and when the mqprio qdisc is destroyed, meaning no offload is active
and the number of real TX queues must match the number of queues the
driver allocated, and it is updated to the offloaded queue count on a
successful mqprio setup.

mqprio only validates the requested queue ranges against
dev->real_num_tx_queues, which can be larger than plat->tx_queues_to_use
while the interface has not been opened yet. Reject a qopt whose highest
referenced queue (offset + count) exceeds plat->tx_queues_to_use, so
xmit_qdisc.num_tx_queues can never be larger than the number of TX queues
the driver provisions. Otherwise stmmac_hw_setup() would expose TX queues
without an allocated DMA ring.

Refuse to lower the number of TX queues below the count required by the
active mqprio offload in stmmac_reinit_queues(), otherwise
netif_set_real_num_tx_queues() would leave real_num_tx_queues
inconsistent with the netdev TC map.

The issue has been reported by sashiko and the patch has been tested on
a Qualcomm RB3-Gen2 board.

Fixes: 195e4f409a40 ("net: stmmac: support fp parameter of tc-mqprio")
Tested-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
Link: https://patch.msgid.link/20261006-stmmac-mqprio-prio-offload-v5-2-d7da93419784@oss.qualcomm.com
Tested-by: Daniel Thompson <daniel@riscstar.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
[ sashal: Adapted the simplified mqprio setup function by adding a pre-validation loop that rejects out-of-range queue configs before any state changes, since upstream's rollback machinery is absent. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac.h      |  6 ++++++
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 12 +++++++++++-
 drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c   | 15 +++++++++++++++
 3 files changed, 32 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac.h b/drivers/net/ethernet/stmicro/stmmac/stmmac.h
index dcdc4e24002ed..2bb4517b42c1b 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac.h
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac.h
@@ -302,6 +302,12 @@ struct stmmac_priv {
 	/* Protect est parameters */
 	struct mutex est_lock;
 	struct stmmac_est *est;
+
+	struct {
+		bool enabled;
+		u32 num_tx_queues;
+	} xmit_qdisc;
+
 	struct dma_features dma_cap;
 	struct stmmac_counters mmc;
 	int hw_cap_support;
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 81e97ab3178b4..c47114ccf7c45 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -3548,7 +3548,7 @@ static int stmmac_hw_setup(struct net_device *dev, bool ptp_register)
 
 	/* Configure real RX and TX queues */
 	netif_set_real_num_rx_queues(dev, priv->plat->rx_queues_to_use);
-	netif_set_real_num_tx_queues(dev, priv->plat->tx_queues_to_use);
+	netif_set_real_num_tx_queues(dev, priv->xmit_qdisc.num_tx_queues);
 
 	/* Start the ball rolling... */
 	stmmac_start_all_dma(priv);
@@ -7465,6 +7465,10 @@ int stmmac_reinit_queues(struct net_device *dev, u32 rx_cnt, u32 tx_cnt)
 	struct stmmac_priv *priv = netdev_priv(dev);
 	int ret = 0, i;
 
+	if (priv->xmit_qdisc.enabled &&
+	    tx_cnt < priv->xmit_qdisc.num_tx_queues)
+		return -EINVAL;
+
 	if (netif_running(dev))
 		stmmac_release(dev);
 
@@ -7472,6 +7476,9 @@ int stmmac_reinit_queues(struct net_device *dev, u32 rx_cnt, u32 tx_cnt)
 
 	priv->plat->rx_queues_to_use = rx_cnt;
 	priv->plat->tx_queues_to_use = tx_cnt;
+	if (!priv->xmit_qdisc.enabled)
+		priv->xmit_qdisc.num_tx_queues = tx_cnt;
+
 	if (!netif_is_rxfh_configured(dev))
 		for (i = 0; i < ARRAY_SIZE(priv->rss.table); i++)
 			priv->rss.table[i] = ethtool_rxfh_indir_default(i,
@@ -7745,6 +7752,9 @@ int stmmac_dvr_probe(struct device *device,
 	ndev->xdp_features = NETDEV_XDP_ACT_BASIC | NETDEV_XDP_ACT_REDIRECT |
 			     NETDEV_XDP_ACT_XSK_ZEROCOPY;
 
+	/* Default qdisc num_tx_queues */
+	priv->xmit_qdisc.num_tx_queues = priv->plat->tx_queues_to_use;
+
 	ret = stmmac_tc_init(priv, priv);
 	if (!ret) {
 		ndev->hw_features |= NETIF_F_HW_TC;
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c
index f29fa17584788..1bedea21194fa 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c
@@ -1239,6 +1239,9 @@ static int stmmac_reset_tc_mqprio(struct net_device *ndev,
 {
 	struct stmmac_priv *priv = netdev_priv(ndev);
 
+	priv->xmit_qdisc.num_tx_queues = priv->plat->tx_queues_to_use;
+	priv->xmit_qdisc.enabled = false;
+
 	netdev_reset_tc(ndev);
 	netif_set_real_num_tx_queues(ndev, priv->plat->tx_queues_to_use);
 
@@ -1258,6 +1261,15 @@ static int tc_setup_dwmac510_mqprio(struct stmmac_priv *priv,
 	if (!num_tc)
 		return stmmac_reset_tc_mqprio(ndev, extack);
 
+	for (u32 tc = 0; tc < num_tc; tc++) {
+		if (qopt->offset[tc] + qopt->count[tc] >
+		    priv->plat->tx_queues_to_use) {
+			NL_SET_ERR_MSG_MOD(extack,
+					   "Queues exceed hw TX queues");
+			return -EINVAL;
+		}
+	}
+
 	err = netdev_set_num_tc(ndev, num_tc);
 	if (err)
 		return err;
@@ -1282,6 +1294,9 @@ static int tc_setup_dwmac510_mqprio(struct stmmac_priv *priv,
 	if (err)
 		goto err_reset_tc;
 
+	priv->xmit_qdisc.num_tx_queues = num_stack_tx_queues;
+	priv->xmit_qdisc.enabled = true;
+
 	return 0;
 
 err_reset_tc:
-- 
2.53.0



