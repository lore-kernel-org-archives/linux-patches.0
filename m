Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B418536A37A;
	Thu, 20 Aug 2026 15:07:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787238461; cv=none; b=CnJSxvlouaIwxV5oKMhjV59ZuqEtiPVrfYkXFDFea/e1xi0y9TEzMK/AQrGPZOeABGUtmMvntetCdBqOaLn1K2u7+DzEUqn5QMt3l46ba4nrRRxOkyH9BY5MP1o6fpGVPYuyhkHquGAbgqHmVxDHmsYyaT286VQjlq6/ILEEPfk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787238461; c=relaxed/simple;
	bh=HH1gEap6kbY+wQGCT/5Mve8aWa131hG2Oh3teOu4aNI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CjOwnlc6VKNW6Wi0xdU3Hx0CGdWHb2wFcs/564H+4PjWSneYUYUWXWAhijGqpgtKZKrybBeoEyE3UyFV8sWFi7AThyn8UZ8On5FUj0yhC7ToS0ZM1HHxzs8uKwGk1gK4O1CFTRlYy8ubyAgD2h9IEI5h1IW0DGltZi4JVUSXBPQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AMCWrIXM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AMCWrIXM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19B261F000E9;
	Thu, 20 Aug 2026 15:07:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787238459;
	bh=wgPW59MJFIp5HFF4gFZk/bM5kLFbG3y7AkcA53pglEs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AMCWrIXMQqY47yx2J0ZINSoatp56Pr641nPVTGEciedvcCc7UyVyUUs0eF5mVJTMF
	 HyTxIZRFjUOfPrn2P1k7MGHHpJjbiMIbgsje5GIUs0CzMgbPoF8xVL1dVAuE903GKJ
	 qId68lT6dO1YxoazvR5k1o+tQ9yGAb7VPIkeS8JI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abhishek Rajput <abhiraj21put@gmail.com>,
	CK Hu <ck.hu@mediatek.com>,
	Chun-Kuang Hu <chunkuang.hu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 156/228] drm/mediatek: Convert legacy DRM logging to drm_* helpers in mtk_dsi.c
Date: Thu, 20 Aug 2026 16:54:58 +0200
Message-ID: <20260820145249.394036019@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145244.450574346@linuxfoundation.org>
References: <20260820145244.450574346@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Abhishek Rajput <abhiraj21put@gmail.com>

[ Upstream commit c319b83e152181cc669a761695a9475510f5d3e5 ]

Replace DRM_INFO(), DRM_WARN() and DRM_ERROR() calls in
drivers/gpu/drm/mediatek/mtk_dsi.c with the corresponding
drm_info(), drm_warn() and drm_err() helpers.

The drm_*() logging helpers take a struct drm_device * argument,
allowing the DRM core to prefix log messages with the correct device
name and instance. This is required to correctly distinguish log
messages on systems with multiple GPUs.

This change aligns the radeon driver with the DRM TODO item:
"Convert logging to drm_* functions with drm_device parameter".

Signed-off-by: Abhishek Rajput <abhiraj21put@gmail.com>
Reviewed-by: CK Hu <ck.hu@mediatek.com>
Link: https://patchwork.kernel.org/project/dri-devel/patch/20260420052008.5417-1-abhiraj21put@gmail.com/
Signed-off-by: Chun-Kuang Hu <chunkuang.hu@kernel.org>
Stable-dep-of: 3e191eddbdcb ("drm/mediatek: mtk_dsi: Enable HS clock only at pre-enable")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/mediatek/mtk_dsi.c |   27 +++++++++++++++++----------
 1 file changed, 17 insertions(+), 10 deletions(-)

--- a/drivers/gpu/drm/mediatek/mtk_dsi.c
+++ b/drivers/gpu/drm/mediatek/mtk_dsi.c
@@ -511,6 +511,7 @@ static void mtk_dsi_config_vdo_timing_pe
 	u32 delta;
 	struct mtk_phy_timing *timing = &dsi->phy_timing;
 	struct videomode *vm = &dsi->vm;
+	struct drm_device *drm = dsi->bridge.dev;
 
 	if (dsi->format == MIPI_DSI_FMT_RGB565)
 		dsi_tmp_buf_bpp = 2;
@@ -544,7 +545,7 @@ static void mtk_dsi_config_vdo_timing_pe
 					     horizontal_backporch_byte /
 					     horizontal_front_back_byte;
 	} else {
-		DRM_WARN("HFP + HBP less than d-phy, FPS will under 60Hz\n");
+		drm_warn(drm, "HFP + HBP less than d-phy, FPS will under 60Hz\n");
 	}
 
 	if ((dsi->mode_flags & MIPI_DSI_HS_PKT_END_ALIGNED) &&
@@ -624,12 +625,13 @@ static s32 mtk_dsi_wait_for_irq_done(str
 {
 	s32 ret = 0;
 	unsigned long jiffies = msecs_to_jiffies(timeout);
+	struct drm_device *drm = dsi->bridge.dev;
 
 	ret = wait_event_interruptible_timeout(dsi->irq_wait_queue,
 					       dsi->irq_data & irq_flag,
 					       jiffies);
 	if (ret == 0) {
-		DRM_WARN("Wait DSI IRQ(0x%08x) Timeout\n", irq_flag);
+		drm_warn(drm, "Wait DSI IRQ(0x%08x) Timeout\n", irq_flag);
 
 		mtk_dsi_enable(dsi);
 		mtk_dsi_reset_engine(dsi);
@@ -664,9 +666,10 @@ static s32 mtk_dsi_switch_to_cmd_mode(st
 {
 	mtk_dsi_irq_data_clear(dsi, irq_flag);
 	mtk_dsi_set_cmd_mode(dsi);
+	struct drm_device *drm = dsi->bridge.dev;
 
 	if (!mtk_dsi_wait_for_irq_done(dsi, irq_flag, t)) {
-		DRM_ERROR("failed to switch cmd mode\n");
+		drm_err(drm, "failed to switch cmd mode\n");
 		return -ETIME;
 	} else {
 		return 0;
@@ -849,11 +852,12 @@ static void mtk_dsi_bridge_atomic_pre_en
 					     struct drm_atomic_state *state)
 {
 	struct mtk_dsi *dsi = bridge_to_dsi(bridge);
+	struct drm_device *drm = bridge->dev;
 	int ret;
 
 	ret = mtk_dsi_poweron(dsi);
 	if (ret < 0)
-		DRM_ERROR("failed to power on dsi\n");
+		drm_err(drm, "failed to power on dsi\n");
 }
 
 static void mtk_dsi_bridge_atomic_post_disable(struct drm_bridge *bridge,
@@ -916,7 +920,7 @@ static int mtk_dsi_encoder_init(struct d
 	ret = drm_simple_encoder_init(drm, &dsi->encoder,
 				      DRM_MODE_ENCODER_DSI);
 	if (ret) {
-		DRM_ERROR("Failed to encoder init to drm\n");
+		drm_err(drm, "Failed to encoder init to drm\n");
 		return ret;
 	}
 
@@ -932,7 +936,7 @@ static int mtk_dsi_encoder_init(struct d
 
 	dsi->connector = drm_bridge_connector_init(drm, &dsi->encoder);
 	if (IS_ERR(dsi->connector)) {
-		DRM_ERROR("Unable to create bridge connector\n");
+		drm_err(drm, "Unable to create bridge connector\n");
 		ret = PTR_ERR(dsi->connector);
 		goto err_cleanup_encoder;
 	}
@@ -985,6 +989,7 @@ static int mtk_dsi_host_attach(struct mi
 {
 	struct mtk_dsi *dsi = host_to_dsi(host);
 	struct device *dev = host->dev;
+	struct drm_device *drm = dsi->bridge.dev;
 	int ret;
 
 	dsi->lanes = device->lanes;
@@ -1006,7 +1011,7 @@ static int mtk_dsi_host_attach(struct mi
 
 	ret = component_add(host->dev, &mtk_dsi_component_ops);
 	if (ret) {
-		DRM_ERROR("failed to add dsi_host component: %d\n", ret);
+		drm_err(drm, "failed to add dsi_host component: %d\n", ret);
 		drm_bridge_remove(&dsi->bridge);
 		return ret;
 	}
@@ -1028,11 +1033,12 @@ static void mtk_dsi_wait_for_idle(struct
 {
 	int ret;
 	u32 val;
+	struct drm_device *drm = dsi->bridge.dev;
 
 	ret = readl_poll_timeout(dsi->regs + DSI_INTSTA, val, !(val & DSI_BUSY),
 				 4, 2000000);
 	if (ret) {
-		DRM_WARN("polling dsi wait not busy timeout!\n");
+		drm_warn(drm, "polling dsi wait not busy timeout!\n");
 
 		mtk_dsi_enable(dsi);
 		mtk_dsi_reset_engine(dsi);
@@ -1120,6 +1126,7 @@ static ssize_t mtk_dsi_host_transfer(str
 				     const struct mipi_dsi_msg *msg)
 {
 	struct mtk_dsi *dsi = host_to_dsi(host);
+	struct drm_device *drm = dsi->bridge.dev;
 	ssize_t recv_cnt;
 	u8 read_data[16];
 	void *src_addr;
@@ -1150,7 +1157,7 @@ static ssize_t mtk_dsi_host_transfer(str
 	}
 
 	if (!msg->rx_buf) {
-		DRM_ERROR("dsi receive buffer size may be NULL\n");
+		drm_err(drm, "dsi receive buffer size may be NULL\n");
 		ret = -EINVAL;
 		goto restore_dsi_mode;
 	}
@@ -1174,7 +1181,7 @@ static ssize_t mtk_dsi_host_transfer(str
 	if (recv_cnt)
 		memcpy(msg->rx_buf, src_addr, recv_cnt);
 
-	DRM_INFO("dsi get %zd byte data from the panel address(0x%x)\n",
+	drm_info(drm, "dsi get %zd byte data from the panel address(0x%x)\n",
 		 recv_cnt, *((u8 *)(msg->tx_buf)));
 
 restore_dsi_mode:


