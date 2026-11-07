Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062954;
	b=dr7pIFvhylgpwT1wl7xi//vbRipKIGNjSMCU8OMc8nerKwZsOb7Oqq8Be+JcdgT/87C+
	 pJmpCAXoHErMShvgxTr4Ald7HbdjbkGbvUrpOlC3jzpK4aBbvBK2wSisGL/RF2quGpS+l
	 a8EjWyCaoGjQw1SiulMAVmwJsv9MRo9HmwA1bSV1SUX5T3FSPoB9wGoYnByc0E8pwqwEP
	 ofAt8eJQoApDTbrtj84igs6wlDVkU4KeDIjU340vKDLkTQ+TGiYqh9DGreb7LKZW6ytVt
	 gV8jN/9irSBj3P4/Qv4BQDdhtXBwug49YrAkcK07cuYGP0F9FnYQfsIF788Kp6L0ZGg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062954;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=veeYRh/99tbZDOvkJMmD7mZzqDAWgTc9BVLvQ+yFFM0=;
	b=tEpgF23R+G4vSdvEtMl1QjKInTdyPLQUDN5mOEzG9yetDSncy9fiLEkazxxIH4iSPQVn
	 kcep2PJ4YhEe6G0VC3EQCLuvVGATD55djleynMuTlOqhGMpjFTbH0crgFmUIrNh1YMbkE
	 tnMO2vy8D87g6zSv2Hu5202TWz2wpdIxfVWcO5gc8E9rJsGvHX7nx4EgTum4jb1NbRFtP
	 hfkB++Tz8oyiZXPCv8tuU9OAEO3b4YhOKM9F43J+wMWbyUla1idYYQuFvjVVlCmXfhUeG
	 6XAIywSlF+8ZTMA6kQmpxNsaRcZp3W61oe6dqLolhADU2fE01pK/55tjdbjJ9aUt0RA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gOcFbp+4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3875B606A326;
	Sat,  7 Nov 2026 14:49:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gOcFbp+4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D01471F0089F;
	Sat,  7 Nov 2026 14:49:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062954;
	bh=veeYRh/99tbZDOvkJMmD7mZzqDAWgTc9BVLvQ+yFFM0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gOcFbp+4RmBrMcKYLS8FhJqL7oQaQ5cp4EvAOPTSqKTICAKdNTeyHGE8AufNek3dN
	 nXlF0PQKnMigw62wMRhmNxEl2Yp6kaQ1XVXKhfzJNMzo5fW1f8+Qdfy9QU9X0feW+b
	 llCwubWK2+2hJMvLM/4AuHlWJWSVJ1HJlP23RfDk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lucas Sinn <lucas.sinn@wolfvision.net>,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Dmitry Osipenko <dmitry.osipenko@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 218/869] media: synopsys: hdmirx: fetch colordepth before calculating pixelclock
Date: Sat,  7 Nov 2026 08:48:20 -0500
Message-ID: <20261107134859.311056879@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lucas Sinn <lucas.sinn@wolfvision.net>

[ Upstream commit e8554ac860356f1f4cd9bce454271dce1ed35fc1 ]

hdmirx_get_detected_timings() divides the TMDS clock by
hdmirx_dev->color_depth, but nothing on its own path ever sets it. The
only producer is hdmirx_get_colordepth(), reached solely from
hdmirx_format_change() at the tail of hdmirx_wait_signal_lock().

VIDIOC_QUERY_DV_TIMINGS does not come through there. It only refuses to
proceed while signal_not_lock() is true, and that reads the lock state
straight out of the hardware, so it can already be false while the work
ending in hdmirx_format_change() has yet to run. Query the timings in
that window, on the first lock after a boot, and color_depth is still
zero from devm_kzalloc().

The division does not fault. do_div() is plain C on 64 bit and arm64
compiles it to udiv, which returns zero for a zero divisor. What comes
out is a pixelclock of zero, and a stitched output frame.

Read the colordepth where it is used instead.

Assisted-by: Claude:claude-opus-5
Signed-off-by: Lucas Sinn <lucas.sinn@wolfvision.net>
Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
Fixes: 7b59b132ad43 ("media: platform: synopsys: Add support for HDMI input driver")
Cc: stable@vger.kernel.org
Reviewed-by: Dmitry Osipenko <dmitry.osipenko@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../platform/synopsys/hdmirx/snps_hdmirx.c    | 71 ++++++++++---------
 1 file changed, 36 insertions(+), 35 deletions(-)

diff --git a/drivers/media/platform/synopsys/hdmirx/snps_hdmirx.c b/drivers/media/platform/synopsys/hdmirx/snps_hdmirx.c
index dbbd33f5908e5..22a5e137f5b6d 100644
--- a/drivers/media/platform/synopsys/hdmirx/snps_hdmirx.c
+++ b/drivers/media/platform/synopsys/hdmirx/snps_hdmirx.c
@@ -154,7 +154,6 @@ struct snps_hdmirx_dev {
 	int num_clks;
 	u32 edid_blocks_written;
 	u32 cur_fmt_fourcc;
-	u32 color_depth;
 	spinlock_t rst_lock; /* to lock register access */
 	u8 edid[EDID_NUM_BLOCKS_MAX * EDID_BLOCK_SIZE];
 };
@@ -378,6 +377,38 @@ static void hdmirx_toggle_polarity(struct snps_hdmirx_dev *hdmirx_dev)
 			   VPROC_HSYNC_POL_OVR_EN, 0);
 }
 
+static u32 hdmirx_get_colordepth(struct snps_hdmirx_dev *hdmirx_dev)
+{
+	struct v4l2_device *v4l2_dev = &hdmirx_dev->v4l2_dev;
+	u32 val, color_depth_reg, color_depth;
+
+	val = hdmirx_readl(hdmirx_dev, DMA_STATUS11);
+	color_depth_reg = (val & HDMIRX_COLOR_DEPTH_MASK) >> 3;
+
+	switch (color_depth_reg) {
+	case 0x4:
+		color_depth = 24;
+		break;
+	case 0x5:
+		color_depth = 30;
+		break;
+	case 0x6:
+		color_depth = 36;
+		break;
+	case 0x7:
+		color_depth = 48;
+		break;
+	default:
+		color_depth = 24;
+		break;
+	}
+
+	v4l2_dbg(1, debug, v4l2_dev, "%s: color_depth: %d, reg_val:%d\n",
+		 __func__, color_depth, color_depth_reg);
+
+	return color_depth;
+}
+
 /*
  * When querying DV timings during preview, if the DMA's timing is stable,
  * we retrieve the timings directly from the DMA. However, if the current
@@ -391,7 +422,7 @@ static int hdmirx_get_detected_timings(struct snps_hdmirx_dev *hdmirx_dev,
 	struct v4l2_bt_timings *bt = &timings->bt;
 	u32 val, tmdsqpclk_freq, pix_clk;
 	unsigned int num_retries = 0;
-	u32 field_type, deframer_st;
+	u32 field_type, deframer_st, color_depth;
 	u64 tmp_data, tmds_clk;
 	bool is_dvi_mode;
 	int ret;
@@ -412,10 +443,11 @@ static int hdmirx_get_detected_timings(struct snps_hdmirx_dev *hdmirx_dev,
 	deframer_st = hdmirx_readl(hdmirx_dev, DEFRAMER_STATUS);
 	is_dvi_mode = !(deframer_st & OPMODE_STS_MASK);
 
+	color_depth = hdmirx_get_colordepth(hdmirx_dev);
 	tmdsqpclk_freq = hdmirx_readl(hdmirx_dev, CMU_TMDSQPCLK_FREQ);
 	tmds_clk = tmdsqpclk_freq * 4 * 1000;
 	tmp_data = tmds_clk * 24;
-	do_div(tmp_data, hdmirx_dev->color_depth);
+	do_div(tmp_data, color_depth);
 	pix_clk = tmp_data;
 	bt->pixelclock = pix_clk;
 
@@ -427,7 +459,7 @@ static int hdmirx_get_detected_timings(struct snps_hdmirx_dev *hdmirx_dev,
 	v4l2_dbg(2, debug, v4l2_dev, "tmds_clk:%llu, pix_clk:%d\n", tmds_clk, pix_clk);
 	v4l2_dbg(1, debug, v4l2_dev, "interlace:%d, fmt:%d, color:%d, mode:%s\n",
 		 bt->interlaced, hdmirx_dev->pix_fmt,
-		 hdmirx_dev->color_depth,
+		 color_depth,
 		 is_dvi_mode ? "dvi" : "hdmi");
 	v4l2_dbg(2, debug, v4l2_dev, "deframer_st:%#x\n", deframer_st);
 
@@ -947,36 +979,6 @@ static void hdmirx_controller_init(struct snps_hdmirx_dev *hdmirx_dev)
 			   VS_REMAPFILTER_EN_QST | VS_FILTER_ORDER_QST(0x3));
 }
 
-static void hdmirx_get_colordepth(struct snps_hdmirx_dev *hdmirx_dev)
-{
-	struct v4l2_device *v4l2_dev = &hdmirx_dev->v4l2_dev;
-	u32 val, color_depth_reg;
-
-	val = hdmirx_readl(hdmirx_dev, DMA_STATUS11);
-	color_depth_reg = (val & HDMIRX_COLOR_DEPTH_MASK) >> 3;
-
-	switch (color_depth_reg) {
-	case 0x4:
-		hdmirx_dev->color_depth = 24;
-		break;
-	case 0x5:
-		hdmirx_dev->color_depth = 30;
-		break;
-	case 0x6:
-		hdmirx_dev->color_depth = 36;
-		break;
-	case 0x7:
-		hdmirx_dev->color_depth = 48;
-		break;
-	default:
-		hdmirx_dev->color_depth = 24;
-		break;
-	}
-
-	v4l2_dbg(1, debug, v4l2_dev, "%s: color_depth: %d, reg_val:%d\n",
-		 __func__, hdmirx_dev->color_depth, color_depth_reg);
-}
-
 static void hdmirx_get_pix_fmt(struct snps_hdmirx_dev *hdmirx_dev)
 {
 	struct v4l2_device *v4l2_dev = &hdmirx_dev->v4l2_dev;
@@ -1087,7 +1089,6 @@ static void hdmirx_format_change(struct snps_hdmirx_dev *hdmirx_dev)
 	};
 
 	hdmirx_get_pix_fmt(hdmirx_dev);
-	hdmirx_get_colordepth(hdmirx_dev);
 	hdmirx_get_avi_infoframe(hdmirx_dev);
 
 	v4l2_dbg(1, debug, v4l2_dev, "%s: queue res_chg_event\n", __func__);
-- 
2.53.0



