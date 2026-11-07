Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064111;
	b=uHsu46kcv0q9O+LTujXD5/dx0NHFqb5wGgWRDceFUuJg5GZzeLqFRrZoHYyp8FOaeYEw
	 3d51TakwvjmedRC9bEBZzPuxqDSKYN8u1OMUc6W6+oySYoK5+3Ut4P0p0qvsskosx5iFM
	 pFs7RuQkJgI2IITxm4PO/yDWu+GfVKtu+luPkuqzkUHCT0qME8og0IFd9g4XaIOHDXlZb
	 iJxiDnpR05jMLFhV/InywNx3GiHW3bkXvIM22G5ADLkoTc2XPKTiEoRpcO+HKXX7yTWdz
	 z2qCu21vmrEqqGWqrz14bl6INtlP3eU7ud1gIsHuUJF6B180ELmA7S09gBuOXdxQMxQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064111;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hWjyYic46JiLX/B5L5+ZBgYz18D5/f1Ibqjy5cRc4FY=;
	b=n3/Id7VAeXNiZ6raqGOw5OHuR/9XNKYPO1EE7BjfzNvqcstwxFSf9Y5ryrWZt8AcrS8y
	 Ccp4dYjVIfNSWwApy7MMPvb4Ua7LxAlKHbpTtR8XTImw1zXFI+nUqgiwGDfK9aZs+A3Y6
	 rj/obo14Ro5XG4uPmIlHp8aD1ceH/Z9HrghfBc8BDqqsy/ikL/cjsfQ0iDwyNuaIvJkRB
	 lx6O6Bmf/nJZtP+euKomO8ZrKzlc7BwB/u5kv9Ikgew9KwjGf9V7HRGdRBrLJv6T6tBK7
	 gJb7xzHv0JKcYIOjLQ0oaJP4x1Wq1D7xRrhqlqqHNOyvp3DBdb0FytCZ734Vqe3lffA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UvEABPJH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56764606B882;
	Sat,  7 Nov 2026 15:08:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UvEABPJH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 029661F0089F;
	Sat,  7 Nov 2026 15:08:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064111;
	bh=hWjyYic46JiLX/B5L5+ZBgYz18D5/f1Ibqjy5cRc4FY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UvEABPJHeU3R7LFI9UtDd/MMlnNtVmvCOXsnp4xJD7o9pQS9fnmDiJci3rTAAoVH7
	 9/8j+Ckd5aZOPhVRE6jDF2TvcEb+MUNTTBzHigtMkerZj3V309BzGM/CWuo0Lc9WGk
	 MflMRqXMd0V1eqtYjDJ7yZXFWwOIWN7nFUHNxjQg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lucas Sinn <lucas.sinn@wolfvision.net>,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Dmitry Osipenko <dmitry.osipenko@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0269/1257] media: synopsys: hdmirx: fetch colordepth before calculating pixelclock
Date: Sat,  7 Nov 2026 08:42:45 -0500
Message-ID: <20261107134946.919169187@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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
index e84d4418c530e..3b9d78e69aac3 100644
--- a/drivers/media/platform/synopsys/hdmirx/snps_hdmirx.c
+++ b/drivers/media/platform/synopsys/hdmirx/snps_hdmirx.c
@@ -156,7 +156,6 @@ struct snps_hdmirx_dev {
 	int num_clks;
 	u32 edid_blocks_written;
 	u32 cur_fmt_fourcc;
-	u32 color_depth;
 	spinlock_t rst_lock; /* to lock register access */
 	u8 edid[EDID_NUM_BLOCKS_MAX * EDID_BLOCK_SIZE];
 };
@@ -380,6 +379,38 @@ static void hdmirx_toggle_polarity(struct snps_hdmirx_dev *hdmirx_dev)
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
@@ -393,7 +424,7 @@ static int hdmirx_get_detected_timings(struct snps_hdmirx_dev *hdmirx_dev,
 	struct v4l2_bt_timings *bt = &timings->bt;
 	u32 val, tmdsqpclk_freq, pix_clk;
 	unsigned int num_retries = 0;
-	u32 field_type, deframer_st;
+	u32 field_type, deframer_st, color_depth;
 	u64 tmp_data, tmds_clk;
 	bool is_dvi_mode;
 	int ret;
@@ -414,10 +445,11 @@ static int hdmirx_get_detected_timings(struct snps_hdmirx_dev *hdmirx_dev,
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
 
@@ -429,7 +461,7 @@ static int hdmirx_get_detected_timings(struct snps_hdmirx_dev *hdmirx_dev,
 	v4l2_dbg(2, debug, v4l2_dev, "tmds_clk:%llu, pix_clk:%d\n", tmds_clk, pix_clk);
 	v4l2_dbg(1, debug, v4l2_dev, "interlace:%d, fmt:%d, color:%d, mode:%s\n",
 		 bt->interlaced, hdmirx_dev->pix_fmt,
-		 hdmirx_dev->color_depth,
+		 color_depth,
 		 is_dvi_mode ? "dvi" : "hdmi");
 	v4l2_dbg(2, debug, v4l2_dev, "deframer_st:%#x\n", deframer_st);
 
@@ -988,36 +1020,6 @@ static void hdmirx_controller_init(struct snps_hdmirx_dev *hdmirx_dev)
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
@@ -1128,7 +1130,6 @@ static void hdmirx_format_change(struct snps_hdmirx_dev *hdmirx_dev)
 	};
 
 	hdmirx_get_pix_fmt(hdmirx_dev);
-	hdmirx_get_colordepth(hdmirx_dev);
 	hdmirx_get_avi_infoframe(hdmirx_dev);
 
 	v4l2_dbg(1, debug, v4l2_dev, "%s: queue res_chg_event\n", __func__);
-- 
2.53.0



