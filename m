Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618242;
	b=NHQ25JTa8w1RYGNAPNh9HLAAwKA22aDz+ydOHNV9Gupe22iNf2cmBoKMkBnshPNrAPuL
	 44hJJvM2gYGR25jCVqO7o5W9IECk59R8/mV6rX0+7A2WBViixRomePUvL16a4jr8EE47J
	 PlK+cDfJHNSy4DNwAZ6NrAK1fkdWGqFsGuukztdw0RIpJho3VXWXRXvhbUgBrqZ31Wxtd
	 67DBKAS+afjXBr57lak1JxC72D5nUibHuFkzff7f66PJIuUpB4tJRvUreEzyrZSj3kTrC
	 gMLFc5DHGlmTSVXl+k0sUsX9JHHpGPLAX9GbqOuHQTDMC5Ov2p0DjeMuh5YmqAPfPBQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618242;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rDd4099udCXNM6hhmE0fqq6WpScEJIjKYHyUazi3rWI=;
	b=I28xkrMN16tWdiFeYLU5BN9z3ZVok2Y3o75ZDMxbmJ6Nzj9hbKKBz7lS43WJoP020bHy
	 +eyHg0ZtzzbQwu4VpByhyMCwUiJqBT7cnyt3Q+O/x6mzRjJVIFaD/Mk2858nOz2rAN/F5
	 BV7BxzxTqa2Vz67VwCdcG+CqlxjbMqowFGqyD2+kFK1K8Z66gdpDGsCB0X5VQgNd3asyw
	 kD0yPoh6BP/AFBeGDzmwNLGP80Z/PycfrjiMZ9yxJwfZoOPoqHwVCWscBEP+oAqJkRyJt
	 jzUqp663gERLSUrZ+fm1NK5IwJD9j9HJtYR2nigDD4azfAGu8XE8jLmQgSSwYct6u/A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ax2fHv6g;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D68E5606A31E;
	Wed, 25 Nov 2026 14:50:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ax2fHv6g
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E47101F000C6;
	Wed, 25 Nov 2026 14:50:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618242;
	bh=rDd4099udCXNM6hhmE0fqq6WpScEJIjKYHyUazi3rWI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ax2fHv6g/XVdjLYry40T8HDXzMgfIDnXzJkx4d0gMPTeo/3OfFJZICosFhtbIOGMd
	 ZfcDHSQ60vKvmafDEeSwtuP1blp0+6/m3o+VKaVZa68HlWcml9v4Weo9kp0RLuJuJ6
	 sQsbXUvfXwEEd3DGL2YfG+XXzr90vDRcbgUHqwJA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0172/1005] net: stmmac: propagate PTP init failures in __stmmac_open() and stmmac_resume()
Date: Wed, 25 Nov 2026 15:25:10 +0100
Message-ID: <20261125143825.770831431@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

From: Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>

[ Upstream commit 8181678a92f0143ad3dafcc2e811afa44ecb4fd6 ]

stmmac_setup_ptp() returns void and swallows both PTP setup errors:
the PTP reference clock enable and stmmac_init_timestamping()
failures are logged but never propagated. When they fail, the MAC
system time counter is left in its post-reset, non-running state,
while the driver keeps operating as if timestamping were up.
This matters for TAPRIO/EST qdisc offloading, which derives the EST
base time from the hardware timestamp counter: arming the gate list
against a non-advancing time base would leave the schedule permanently
stuck.

Make stmmac_setup_ptp() return an error code and propagate the
failure in __stmmac_open(), stopping the DMA engines when PTP setup
fails. In stmmac_resume(), re-initialise timestamping only when the
PTP clock was registered before suspend, re-apply the platform clock
rate configuration, and stop the DMA engines if re-initialisation
fails.

While at it, factor the hardware timestamping capability check into a
stmmac_check_timestamp_cap() helper and apply it to the hwtstamp get
path and the ethtool ts_info path. stmmac_setup_ptp() now enables the
PTP reference clock and runs the platform ptp_clk_freq_config()
callback before validating the resulting clock rate; if no valid rate
is available, it disables the clock and returns success without
registering the PTP clock. This keeps the interface operational on
platforms with PTP-capable silicon but an unconfigured PTP clock,
where timestamping cannot be enabled: instead of failing, the driver
proceeds without setting up timestamping. Extend the timestamping gate
on the set path (which keeps testing the core's basic/advanced
timestamping capability) and the devlink registration with the PTP
reference clock rate requirement.

Gate the PTP reference clock enable/disable in the platform noirq
suspend/resume callbacks on priv->ptp_enabled, keeping the clock
reference balanced against the new early return in
stmmac_release_ptp().

Reviewed-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
Link: https://patch.msgid.link/20260914-stmmac-ptp-error-propagate-v5-1-81149897e65d@oss.qualcomm.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 23d96de472f7 ("net: stmmac: re-apply taprio offload in __stmmac_open() and stmmac_resume()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac.h  |   7 ++
 .../ethernet/stmicro/stmmac/stmmac_ethtool.c  |   3 +-
 .../net/ethernet/stmicro/stmmac/stmmac_main.c | 114 +++++++++++++-----
 .../ethernet/stmicro/stmmac/stmmac_platform.c |   6 +-
 4 files changed, 95 insertions(+), 35 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac.h b/drivers/net/ethernet/stmicro/stmmac/stmmac.h
index 9cdad84308568..e782323df61ec 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac.h
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac.h
@@ -336,6 +336,8 @@ struct stmmac_priv {
 	struct kernel_hwtstamp_config tstamp_config;
 	struct ptp_clock *ptp_clock;
 	struct ptp_clock_info ptp_clock_ops;
+	bool ptp_enabled;
+
 	unsigned int default_addend;
 	u32 sub_second_inc;
 	u32 systime_flags;
@@ -426,6 +428,11 @@ int stmmac_set_clk_tx_rate(void *bsp_priv, struct clk *clk_tx_i,
 
 struct plat_stmmacenet_data *stmmac_plat_dat_alloc(struct device *dev);
 
+static inline bool stmmac_check_timestamp_cap(struct stmmac_priv *priv)
+{
+	return priv->dma_cap.time_stamp || priv->dma_cap.atime_stamp;
+}
+
 static inline bool stmmac_xdp_is_enabled(struct stmmac_priv *priv)
 {
 	return !!priv->xdp_prog;
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
index e2c5b69505104..30e0d499326d8 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
@@ -1008,8 +1008,7 @@ static int stmmac_get_ts_info(struct net_device *dev,
 {
 	struct stmmac_priv *priv = netdev_priv(dev);
 
-	if ((priv->dma_cap.time_stamp || priv->dma_cap.atime_stamp)) {
-
+	if (stmmac_check_timestamp_cap(priv)) {
 		info->so_timestamping = SOF_TIMESTAMPING_TX_SOFTWARE |
 					SOF_TIMESTAMPING_TX_HARDWARE |
 					SOF_TIMESTAMPING_RX_HARDWARE |
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 7149b14bdad48..f6400d439b9b1 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -653,7 +653,8 @@ static int stmmac_hwtstamp_set(struct net_device *dev,
 	u32 ts_master_en = 0;
 	u32 ts_event_en = 0;
 
-	if (!(priv->dma_cap.time_stamp || priv->adv_ts)) {
+	if (!priv->plat->clk_ptp_rate ||
+	    !(priv->dma_cap.time_stamp || priv->adv_ts)) {
 		NL_SET_ERR_MSG_MOD(extack, "No support for HW time stamping");
 		priv->hwts_tx_en = 0;
 		priv->hwts_rx_en = 0;
@@ -843,7 +844,7 @@ static int stmmac_hwtstamp_get(struct net_device *dev,
 {
 	struct stmmac_priv *priv = netdev_priv(dev);
 
-	if (!(priv->dma_cap.time_stamp || priv->dma_cap.atime_stamp))
+	if (!stmmac_check_timestamp_cap(priv))
 		return -EOPNOTSUPP;
 
 	*config = priv->tstamp_config;
@@ -866,11 +867,6 @@ static int stmmac_init_tstamp_counter(struct stmmac_priv *priv,
 {
 	struct timespec64 now;
 
-	if (!priv->plat->clk_ptp_rate) {
-		netdev_err(priv->dev, "Invalid PTP clock rate");
-		return -EINVAL;
-	}
-
 	stmmac_config_hw_tstamping(priv, priv->ptpaddr, systime_flags);
 	priv->systime_flags = systime_flags;
 
@@ -885,26 +881,37 @@ static int stmmac_init_tstamp_counter(struct stmmac_priv *priv,
 	return 0;
 }
 
+static int stmmac_init_ptp_clk_freq(struct stmmac_priv *priv)
+{
+	if (priv->plat->ptp_clk_freq_config)
+		priv->plat->ptp_clk_freq_config(priv);
+
+	if (!priv->plat->clk_ptp_rate) {
+		netdev_info(priv->dev, "PTP clock rate not configured\n");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
 /**
  * stmmac_init_timestamping - initialise timestamping
  * @priv: driver private structure
- * Description: this is to verify if the HW supports the PTPv1 or PTPv2.
- * This is done by looking at the HW cap. register.
- * This function also registers the ptp driver.
+ *
+ * Description: initialise the hardware timestamping counter, reset the
+ * timestamping configuration and derive the advanced timestamping flags from
+ * the HW capabilities. The caller must have ensured a valid PTP reference
+ * clock rate (see stmmac_init_ptp_clk_freq()); the configured state is valid
+ * as long as the interface is open and not suspended, and this function is
+ * re-run on resume.
+ *
+ * Return: 0 on success, a negative errno otherwise.
  */
 static int stmmac_init_timestamping(struct stmmac_priv *priv)
 {
 	bool xmac = dwmac_is_xmac(priv->plat->core_type);
 	int ret;
 
-	if (priv->plat->ptp_clk_freq_config)
-		priv->plat->ptp_clk_freq_config(priv);
-
-	if (!(priv->dma_cap.time_stamp || priv->dma_cap.atime_stamp)) {
-		netdev_info(priv->dev, "PTP not supported by HW\n");
-		return -EOPNOTSUPP;
-	}
-
 	ret = stmmac_init_tstamp_counter(priv, STMMAC_HWTS_ACTIVE |
 					       PTP_TCR_TSCFUPDT);
 	if (ret) {
@@ -937,24 +944,48 @@ static int stmmac_init_timestamping(struct stmmac_priv *priv)
 	return 0;
 }
 
-static void stmmac_setup_ptp(struct stmmac_priv *priv)
+static int stmmac_setup_ptp(struct stmmac_priv *priv)
 {
 	int ret;
 
+	if (!stmmac_check_timestamp_cap(priv)) {
+		netdev_info(priv->dev, "PTP not supported\n");
+		return 0;
+	}
+
 	ret = clk_prepare_enable(priv->plat->clk_ptp_ref);
-	if (ret < 0)
+	if (ret < 0) {
 		netdev_warn(priv->dev,
 			    "failed to enable PTP reference clock: %pe\n",
 			    ERR_PTR(ret));
+		return ret;
+	}
 
-	if (stmmac_init_timestamping(priv) == 0)
-		stmmac_ptp_register(priv);
+	if (stmmac_init_ptp_clk_freq(priv)) {
+		clk_disable_unprepare(priv->plat->clk_ptp_ref);
+		return 0;
+	}
+
+	ret = stmmac_init_timestamping(priv);
+	if (ret) {
+		clk_disable_unprepare(priv->plat->clk_ptp_ref);
+		return ret;
+	}
+
+	stmmac_ptp_register(priv);
+	priv->ptp_enabled = true;
+
+	return 0;
 }
 
 static void stmmac_release_ptp(struct stmmac_priv *priv)
 {
+	if (!priv->ptp_enabled)
+		return;
+
 	stmmac_ptp_unregister(priv);
 	clk_disable_unprepare(priv->plat->clk_ptp_ref);
+	priv->ptp_enabled = false;
 }
 
 static void stmmac_legacy_serdes_power_down(struct stmmac_priv *priv)
@@ -4175,10 +4206,12 @@ static int __stmmac_open(struct net_device *dev,
 	ret = stmmac_hw_setup(dev);
 	if (ret < 0) {
 		netdev_err(priv->dev, "%s: Hw setup failed\n", __func__);
-		goto init_error;
+		return ret;
 	}
 
-	stmmac_setup_ptp(priv);
+	ret = stmmac_setup_ptp(priv);
+	if (ret)
+		goto ptp_error;
 
 	stmmac_init_coalesce(priv);
 
@@ -4203,7 +4236,10 @@ static int __stmmac_open(struct net_device *dev,
 		hrtimer_cancel(&priv->dma_conf.tx_queue[chan].txtimer);
 
 	stmmac_release_ptp(priv);
-init_error:
+ptp_error:
+	stmmac_stop_all_dma(priv);
+	stmmac_mac_set(priv, priv->ioaddr, false);
+
 	return ret;
 }
 
@@ -7796,8 +7832,7 @@ static int stmmac_register_devlink(struct stmmac_priv *priv)
 	/* For now, what is exposed over devlink is only relevant when
 	 * timestamping is available and we have a valid ptp clock rate
 	 */
-	if (!(priv->dma_cap.time_stamp || priv->dma_cap.atime_stamp) ||
-	    !priv->plat->clk_ptp_rate)
+	if (!stmmac_check_timestamp_cap(priv) || !priv->plat->clk_ptp_rate)
 		return 0;
 
 	priv->devlink = devlink_alloc(&stmmac_devlink_ops, sizeof(*dl_priv),
@@ -8415,14 +8450,19 @@ int stmmac_resume(struct device *dev)
 	ret = stmmac_hw_setup(ndev);
 	if (ret < 0) {
 		netdev_err(priv->dev, "%s: Hw setup failed\n", __func__);
-		stmmac_legacy_serdes_power_down(priv);
-		mutex_unlock(&priv->lock);
-		rtnl_unlock();
-		return ret;
+		goto error_unlock;
 	}
 
-	stmmac_init_timestamping(priv);
+	if (priv->ptp_enabled) {
+		if (stmmac_init_ptp_clk_freq(priv))
+			goto init_coalesce;
 
+		ret = stmmac_init_timestamping(priv);
+		if (ret)
+			goto error_stop_dma;
+	}
+
+init_coalesce:
 	stmmac_init_coalesce(priv);
 	phylink_rx_clk_stop_block(priv->phylink);
 	stmmac_set_rx_mode(ndev);
@@ -8445,6 +8485,16 @@ int stmmac_resume(struct device *dev)
 	netif_device_attach(ndev);
 
 	return 0;
+
+error_stop_dma:
+	stmmac_stop_all_dma(priv);
+	stmmac_mac_set(priv, priv->ioaddr, false);
+error_unlock:
+	stmmac_legacy_serdes_power_down(priv);
+	mutex_unlock(&priv->lock);
+	rtnl_unlock();
+
+	return ret;
 }
 EXPORT_SYMBOL_GPL(stmmac_resume);
 
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
index 6128ed1bd521a..19d4815544990 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
@@ -959,7 +959,8 @@ static int __maybe_unused stmmac_pltfr_noirq_suspend(struct device *dev)
 
 	if (!priv->wolopts) {
 		/* Disable clock in case of PWM is off */
-		clk_disable_unprepare(priv->plat->clk_ptp_ref);
+		if (priv->ptp_enabled)
+			clk_disable_unprepare(priv->plat->clk_ptp_ref);
 
 		ret = pm_runtime_force_suspend(dev);
 		if (ret)
@@ -984,6 +985,9 @@ static int __maybe_unused stmmac_pltfr_noirq_resume(struct device *dev)
 		if (ret)
 			return ret;
 
+		if (!priv->ptp_enabled)
+			return 0;
+
 		ret = clk_prepare_enable(priv->plat->clk_ptp_ref);
 		if (ret < 0) {
 			netdev_warn(priv->dev,
-- 
2.53.0



