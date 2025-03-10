Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D721022FF40;
	Mon, 10 Mar 2025 17:31:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741627878; cv=none; b=YNQqzdguh4dh6VMbG2KPTUyKY0wDicDXkiOiRSA7RV4Hbx9iOvhZHsRTeDpisAv896tNvpNX+gsCHlmnM9i5h0QMfZBncRZOrJvzLGtOqjiojaFqp4yRugySuNWmQEJ6UMrlish28gVo3EaVfusGZZ9DykKz/ubfe9F/s/57/rU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741627878; c=relaxed/simple;
	bh=iUWnYLr5h4XeDEVOWPYDFMZIuWDG0ZB1J8peLMx4Ukc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=omidq7gl7OAFhWR3sukwFqxSsN5SL+GMIodK2IV9hH6s9bGbT6zFT7nIdZnBFfqqoG2PzBdbUTPSg7ESjA3sGjOcDFhm3FK71gk/G+tzzVcbYyDQuN64VfQzCS6TxAdwYufSq+dHZY6WnkvHhaBbcnOwVWlTLIDnWr0P4Mp+kNo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k13iMEwg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k13iMEwg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BF9AC4CEEC;
	Mon, 10 Mar 2025 17:31:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741627878;
	bh=iUWnYLr5h4XeDEVOWPYDFMZIuWDG0ZB1J8peLMx4Ukc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k13iMEwgo4Wt6YCL+19I2yle53iPs8RPQGCGobVgSADRfPN6v5yornjuRMng0YhRT
	 f179d6dKbvLrfVqIF25gZpz237WYBZhlIzZOOe23jM1vDvJFsJBMPmLHB5sZcM9kaK
	 nC54DFvJFls3tUHs8RxT2kzMY8YTSVVhfmjhKwsA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>,
	Martyn Welch <martyn.welch@collabora.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 012/145] net: enetc: Replace ifdef with IS_ENABLED
Date: Mon, 10 Mar 2025 18:05:06 +0100
Message-ID: <20250310170435.238512982@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170434.733307314@linuxfoundation.org>
References: <20250310170434.733307314@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Martyn Welch <martyn.welch@collabora.com>

[ Upstream commit 9c699a8f3b273c62f7b364ff999e873501a1e834 ]

The enetc driver uses ifdefs when checking whether
CONFIG_FSL_ENETC_PTP_CLOCK is enabled in a number of places. This works
if the driver is built-in but fails if the driver is available as a
kernel module. Replace the instances of ifdef with use of the IS_ENABLED
macro, that will evaluate as true when this feature is built as a kernel
module and follows the kernel's coding style.

Reviewed-by: Vadim Fedorenko <vadim.fedorenko@linux.dev>
Signed-off-by: Martyn Welch <martyn.welch@collabora.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20240912173742.484549-1-martyn.welch@collabora.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: a562d0c4a893 ("net: enetc: VFs do not support HWTSTAMP_TX_ONESTEP_SYNC")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/enetc/enetc.c  | 22 ++++++++-----------
 drivers/net/ethernet/freescale/enetc/enetc.h  |  9 +++-----
 .../ethernet/freescale/enetc/enetc_ethtool.c  | 12 ++++++----
 3 files changed, 20 insertions(+), 23 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net/ethernet/freescale/enetc/enetc.c
index 9aa57134f460c..30653830981d1 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -1023,7 +1023,6 @@ static int enetc_refill_rx_ring(struct enetc_bdr *rx_ring, const int buff_cnt)
 	return j;
 }
 
-#ifdef CONFIG_FSL_ENETC_PTP_CLOCK
 static void enetc_get_rx_tstamp(struct net_device *ndev,
 				union enetc_rx_bd *rxbd,
 				struct sk_buff *skb)
@@ -1047,7 +1046,6 @@ static void enetc_get_rx_tstamp(struct net_device *ndev,
 		shhwtstamps->hwtstamp = ns_to_ktime(tstamp);
 	}
 }
-#endif
 
 static void enetc_get_offloads(struct enetc_bdr *rx_ring,
 			       union enetc_rx_bd *rxbd, struct sk_buff *skb)
@@ -1087,10 +1085,9 @@ static void enetc_get_offloads(struct enetc_bdr *rx_ring,
 		__vlan_hwaccel_put_tag(skb, tpid, le16_to_cpu(rxbd->r.vlan_opt));
 	}
 
-#ifdef CONFIG_FSL_ENETC_PTP_CLOCK
-	if (priv->active_offloads & ENETC_F_RX_TSTAMP)
+	if (IS_ENABLED(CONFIG_FSL_ENETC_PTP_CLOCK) &&
+	    (priv->active_offloads & ENETC_F_RX_TSTAMP))
 		enetc_get_rx_tstamp(rx_ring->ndev, rxbd, skb);
-#endif
 }
 
 /* This gets called during the non-XDP NAPI poll cycle as well as on XDP_PASS,
@@ -2956,7 +2953,6 @@ void enetc_set_features(struct net_device *ndev, netdev_features_t features)
 }
 EXPORT_SYMBOL_GPL(enetc_set_features);
 
-#ifdef CONFIG_FSL_ENETC_PTP_CLOCK
 static int enetc_hwtstamp_set(struct net_device *ndev, struct ifreq *ifr)
 {
 	struct enetc_ndev_priv *priv = netdev_priv(ndev);
@@ -3025,17 +3021,17 @@ static int enetc_hwtstamp_get(struct net_device *ndev, struct ifreq *ifr)
 	return copy_to_user(ifr->ifr_data, &config, sizeof(config)) ?
 	       -EFAULT : 0;
 }
-#endif
 
 int enetc_ioctl(struct net_device *ndev, struct ifreq *rq, int cmd)
 {
 	struct enetc_ndev_priv *priv = netdev_priv(ndev);
-#ifdef CONFIG_FSL_ENETC_PTP_CLOCK
-	if (cmd == SIOCSHWTSTAMP)
-		return enetc_hwtstamp_set(ndev, rq);
-	if (cmd == SIOCGHWTSTAMP)
-		return enetc_hwtstamp_get(ndev, rq);
-#endif
+
+	if (IS_ENABLED(CONFIG_FSL_ENETC_PTP_CLOCK)) {
+		if (cmd == SIOCSHWTSTAMP)
+			return enetc_hwtstamp_set(ndev, rq);
+		if (cmd == SIOCGHWTSTAMP)
+			return enetc_hwtstamp_get(ndev, rq);
+	}
 
 	if (!priv->phylink)
 		return -EOPNOTSUPP;
diff --git a/drivers/net/ethernet/freescale/enetc/enetc.h b/drivers/net/ethernet/freescale/enetc/enetc.h
index fcadb0848d254..860ecee302f1a 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.h
+++ b/drivers/net/ethernet/freescale/enetc/enetc.h
@@ -184,10 +184,9 @@ static inline union enetc_rx_bd *enetc_rxbd(struct enetc_bdr *rx_ring, int i)
 {
 	int hw_idx = i;
 
-#ifdef CONFIG_FSL_ENETC_PTP_CLOCK
-	if (rx_ring->ext_en)
+	if (IS_ENABLED(CONFIG_FSL_ENETC_PTP_CLOCK) && rx_ring->ext_en)
 		hw_idx = 2 * i;
-#endif
+
 	return &(((union enetc_rx_bd *)rx_ring->bd_base)[hw_idx]);
 }
 
@@ -199,10 +198,8 @@ static inline void enetc_rxbd_next(struct enetc_bdr *rx_ring,
 
 	new_rxbd++;
 
-#ifdef CONFIG_FSL_ENETC_PTP_CLOCK
-	if (rx_ring->ext_en)
+	if (IS_ENABLED(CONFIG_FSL_ENETC_PTP_CLOCK) && rx_ring->ext_en)
 		new_rxbd++;
-#endif
 
 	if (unlikely(++new_index == rx_ring->bd_count)) {
 		new_rxbd = rx_ring->bd_base;
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c b/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c
index aa7d427e654ff..39fbc465746f7 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c
@@ -848,7 +848,12 @@ static int enetc_get_ts_info(struct net_device *ndev,
 		symbol_put(enetc_phc_index);
 	}
 
-#ifdef CONFIG_FSL_ENETC_PTP_CLOCK
+	if (!IS_ENABLED(CONFIG_FSL_ENETC_PTP_CLOCK)) {
+		info->so_timestamping = SOF_TIMESTAMPING_TX_SOFTWARE;
+
+		return 0;
+	}
+
 	info->so_timestamping = SOF_TIMESTAMPING_TX_HARDWARE |
 				SOF_TIMESTAMPING_RX_HARDWARE |
 				SOF_TIMESTAMPING_RAW_HARDWARE |
@@ -857,11 +862,10 @@ static int enetc_get_ts_info(struct net_device *ndev,
 	info->tx_types = (1 << HWTSTAMP_TX_OFF) |
 			 (1 << HWTSTAMP_TX_ON) |
 			 (1 << HWTSTAMP_TX_ONESTEP_SYNC);
+
 	info->rx_filters = (1 << HWTSTAMP_FILTER_NONE) |
 			   (1 << HWTSTAMP_FILTER_ALL);
-#else
-	info->so_timestamping = SOF_TIMESTAMPING_TX_SOFTWARE;
-#endif
+
 	return 0;
 }
 
-- 
2.39.5



