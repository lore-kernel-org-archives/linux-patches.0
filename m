Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 805303090D2;
	Tue,  2 Sep 2025 13:37:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756820255; cv=none; b=C9Lsg5a9mxHBbc2sMa0LZqEZ2O7BgH2byZHwKYnKm9lrjbQnFdE9l46nCMXGQnPoUWzEerdjJY7DO4seZVpBS1Abjjtz52tXeSjMMW4z+TEKAP9oO59sRGvaBGpF1sOlbxPR+Y5uit2ZnWvUJOJZcad3x833cVRiOxXL5Od2Za8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756820255; c=relaxed/simple;
	bh=d/iPGeXMJrJkG+V0baybBWzUx25xi09KzCIiUj1fQxs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZfQb0cq7ribMY5oJd/WQP7HXLuWjCTpq/P2NY5cCoHEiuepycZqHl/sPZjqbqQg2IbY3M1hKIoZo2t8c2FNBHhF62yBbzJ6hEwGjU/bxHKgvqvoBxAV14FZCyq42wzQls2KBfAOGQPBxVsXRCf2P3XxVC5bVqwjLIZkplCAPdDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fCefJ+T+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fCefJ+T+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEFB6C4CEED;
	Tue,  2 Sep 2025 13:37:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756820255;
	bh=d/iPGeXMJrJkG+V0baybBWzUx25xi09KzCIiUj1fQxs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fCefJ+T+cZf5Z6cUexWjwZywS/qkRd/vu7uvNXNLJoKCZRGHULC8dHR0+tIvGUXiv
	 4RMrfOJDsip4HYMHeX70r3fUUU5a7iVOrPR5U6T9ny1EuuVYObGJM5674lgywz0v7s
	 6rvBYLlybV4OAyL/Obtl3fhwblYajlLQhsAgu3ZY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Serge Semin <fancer.lancer@gmail.com>,
	Romain Gantois <romain.gantois@bootlin.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 48/75] net: stmmac: Rename phylink_get_caps() callback to update_caps()
Date: Tue,  2 Sep 2025 15:21:00 +0200
Message-ID: <20250902131937.007031896@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131935.107897242@linuxfoundation.org>
References: <20250902131935.107897242@linuxfoundation.org>
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

From: Serge Semin <fancer.lancer@gmail.com>

[ Upstream commit dc144baeb4fbfa0d91ce9c3875307566f58704ec ]

Since recent commits the stmmac_ops::phylink_get_caps() callback has no
longer been responsible for the phylink MAC capabilities getting, but
merely updates the MAC capabilities in the mac_device_info::link::caps
field. Rename the callback to comply with the what the method does now.

Signed-off-by: Serge Semin <fancer.lancer@gmail.com>
Reviewed-by: Romain Gantois <romain.gantois@bootlin.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Stable-dep-of: 42ef11b2bff5 ("net: stmmac: xgmac: Correct supported speed modes")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c | 8 ++++----
 drivers/net/ethernet/stmicro/stmmac/hwif.h        | 8 ++++----
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 6 +++---
 3 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c b/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
index a9837985a483d..bdb4f527289d2 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
@@ -69,7 +69,7 @@ static void dwmac4_core_init(struct mac_device_info *hw,
 		init_waitqueue_head(&priv->tstamp_busy_wait);
 }
 
-static void dwmac4_phylink_get_caps(struct stmmac_priv *priv)
+static void dwmac4_update_caps(struct stmmac_priv *priv)
 {
 	if (priv->plat->tx_queues_to_use > 1)
 		priv->hw->link.caps &= ~(MAC_10HD | MAC_100HD | MAC_1000HD);
@@ -1161,7 +1161,7 @@ static int dwmac4_config_l4_filter(struct mac_device_info *hw, u32 filter_no,
 
 const struct stmmac_ops dwmac4_ops = {
 	.core_init = dwmac4_core_init,
-	.phylink_get_caps = dwmac4_phylink_get_caps,
+	.update_caps = dwmac4_update_caps,
 	.set_mac = stmmac_set_mac,
 	.rx_ipc = dwmac4_rx_ipc_enable,
 	.rx_queue_enable = dwmac4_rx_queue_enable,
@@ -1204,7 +1204,7 @@ const struct stmmac_ops dwmac4_ops = {
 
 const struct stmmac_ops dwmac410_ops = {
 	.core_init = dwmac4_core_init,
-	.phylink_get_caps = dwmac4_phylink_get_caps,
+	.update_caps = dwmac4_update_caps,
 	.set_mac = stmmac_dwmac4_set_mac,
 	.rx_ipc = dwmac4_rx_ipc_enable,
 	.rx_queue_enable = dwmac4_rx_queue_enable,
@@ -1253,7 +1253,7 @@ const struct stmmac_ops dwmac410_ops = {
 
 const struct stmmac_ops dwmac510_ops = {
 	.core_init = dwmac4_core_init,
-	.phylink_get_caps = dwmac4_phylink_get_caps,
+	.update_caps = dwmac4_update_caps,
 	.set_mac = stmmac_dwmac4_set_mac,
 	.rx_ipc = dwmac4_rx_ipc_enable,
 	.rx_queue_enable = dwmac4_rx_queue_enable,
diff --git a/drivers/net/ethernet/stmicro/stmmac/hwif.h b/drivers/net/ethernet/stmicro/stmmac/hwif.h
index 47fb8e1646c2e..ee9a7d98648b0 100644
--- a/drivers/net/ethernet/stmicro/stmmac/hwif.h
+++ b/drivers/net/ethernet/stmicro/stmmac/hwif.h
@@ -300,8 +300,8 @@ struct stmmac_est;
 struct stmmac_ops {
 	/* MAC core initialization */
 	void (*core_init)(struct mac_device_info *hw, struct net_device *dev);
-	/* Get phylink capabilities */
-	void (*phylink_get_caps)(struct stmmac_priv *priv);
+	/* Update MAC capabilities */
+	void (*update_caps)(struct stmmac_priv *priv);
 	/* Enable the MAC RX/TX */
 	void (*set_mac)(void __iomem *ioaddr, bool enable);
 	/* Enable and verify that the IPC module is supported */
@@ -423,8 +423,8 @@ struct stmmac_ops {
 
 #define stmmac_core_init(__priv, __args...) \
 	stmmac_do_void_callback(__priv, mac, core_init, __args)
-#define stmmac_mac_phylink_get_caps(__priv) \
-	stmmac_do_void_callback(__priv, mac, phylink_get_caps, __priv)
+#define stmmac_mac_update_caps(__priv) \
+	stmmac_do_void_callback(__priv, mac, update_caps, __priv)
 #define stmmac_mac_set(__priv, __args...) \
 	stmmac_do_void_callback(__priv, mac, set_mac, __args)
 #define stmmac_rx_ipc(__priv, __args...) \
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 615d25a0e46be..fa8ee0624f2f2 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -1230,8 +1230,8 @@ static int stmmac_phy_setup(struct stmmac_priv *priv)
 		xpcs_get_interfaces(priv->hw->xpcs,
 				    priv->phylink_config.supported_interfaces);
 
-	/* Get the MAC specific capabilities */
-	stmmac_mac_phylink_get_caps(priv);
+	/* Refresh the MAC-specific capabilities */
+	stmmac_mac_update_caps(priv);
 
 	priv->phylink_config.mac_capabilities = priv->hw->link.caps;
 
@@ -7232,7 +7232,7 @@ int stmmac_reinit_queues(struct net_device *dev, u32 rx_cnt, u32 tx_cnt)
 			priv->rss.table[i] = ethtool_rxfh_indir_default(i,
 									rx_cnt);
 
-	stmmac_mac_phylink_get_caps(priv);
+	stmmac_mac_update_caps(priv);
 
 	priv->phylink_config.mac_capabilities = priv->hw->link.caps;
 
-- 
2.50.1



