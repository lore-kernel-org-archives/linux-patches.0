Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591450;
	b=1DJGmpd5hWETu6buZynx/KCpeNRP9WsDQzTUmfpJFH3BfSn7dhOf9D8fkBIlBadNLDXH
	 A5SUEI9J6GT9ycgKcmA6QjNNV7g8i93tKVKUALlOjSHAWOVsA1jEqMuXqXuVnWbk+aCdH
	 9+dGBFC5e37OF0ODWDe7yFyd5q4ItIsl7yGZ7PxEbF9ou3wVEqF/i6kUva2WLq7uJaZmi
	 ydnk7b2mwTj20lyWQTxAqfWcFHC5S5g5Wt5Tec2cxcLNsEvO772DqBfx4NofRuWUd0H2R
	 20khcmH9X0RqPH5g//Ix71SDbU+eZktaxWE0slbuGLVS6F1Y0iO+i6c63Hvkt4ZvyIA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591450;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=ZQ4fxbSdxnuvL8Vx+c1f+45VjbibZhpqfG4VohtcNcE=;
	b=gDDs3MNitWQcHi3GBJQ2yS9jt62DCSD0NsYRMDnhLD8P6DhEcjIyuGBnCqsLjH4pSiEC
	 GKLjHpLGF10nsLrwCK6e5CCG6oRUDa99jVzmTvy/ltoVMUdRrOpzEsuqATqXRdu+GjbEI
	 vxu2+14KRc10SPPNhDXBmMZhg4G+SgDW1RXheGx0ZsMcL7VDyh5UbcVlwTXzhHhvV4BJJ
	 op522asjKAmL0SxVjC9XiQK1C4ENmyciMbjRVfXhcCeUL87BFHaIoikuzWB/Z/1WdrCLz
	 6qBL5C6a8+OlqIgCl+DblPFeBTow83T35ae4MrnHZPjNA2rt6rIeOhgWvLuP+FbzJ3w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lU11gKKJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7B56607C352;
	Fri, 13 Nov 2026 17:37:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lU11gKKJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73D831F000C6;
	Fri, 13 Nov 2026 17:37:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591450;
	bh=ZQ4fxbSdxnuvL8Vx+c1f+45VjbibZhpqfG4VohtcNcE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lU11gKKJsiXfnSvmXhXwj8TMoEnQZc3anMhJbjlmXxuLOYyj0r5oljVbqutX8g7BN
	 k/jMgMcLUcxP1W4NXFSdE5PYf6cp0wJophfpDvEXdUBYPrS7AggxPnFf4/0VHGryYb
	 jGJgvellcv+U5BEO3sL6VR78il7tgx1L9A7GhLjk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	=?UTF-8?q?Sven=20P=C3=BCschel?= <s.pueschel@pengutronix.de>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 539/670] media: rockchip: rga: use clk_bulk api
Date: Fri, 13 Nov 2026 10:51:43 -0500
Message-ID: <20261113153830.162914182@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sven Püschel <s.pueschel@pengutronix.de>

[ Upstream commit a2a4f69fd2e333bacd17d1788eb5211cb6f373cc ]

Use the clk_bulk API to avoid code duplication for each of the three
clocks.

Reviewed-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Sven Püschel <s.pueschel@pengutronix.de>
Signed-off-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Stable-dep-of: a875c43dd95e ("media: rockchip: rga: quiesce IRQ before releasing m2m state")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/rockchip/rga/rga.c | 65 +++--------------------
 drivers/media/platform/rockchip/rga/rga.h |  6 +--
 2 files changed, 11 insertions(+), 60 deletions(-)

diff --git a/drivers/media/platform/rockchip/rga/rga.c b/drivers/media/platform/rockchip/rga/rga.c
index de532b7ecd74c..7b2842d959255 100644
--- a/drivers/media/platform/rockchip/rga/rga.c
+++ b/drivers/media/platform/rockchip/rga/rga.c
@@ -704,48 +704,10 @@ static const struct video_device rga_videodev = {
 	.device_caps = V4L2_CAP_VIDEO_M2M_MPLANE | V4L2_CAP_STREAMING,
 };
 
-static int rga_enable_clocks(struct rockchip_rga *rga)
-{
-	int ret;
-
-	ret = clk_prepare_enable(rga->sclk);
-	if (ret) {
-		dev_err(rga->dev, "Cannot enable rga sclk: %d\n", ret);
-		return ret;
-	}
-
-	ret = clk_prepare_enable(rga->aclk);
-	if (ret) {
-		dev_err(rga->dev, "Cannot enable rga aclk: %d\n", ret);
-		goto err_disable_sclk;
-	}
-
-	ret = clk_prepare_enable(rga->hclk);
-	if (ret) {
-		dev_err(rga->dev, "Cannot enable rga hclk: %d\n", ret);
-		goto err_disable_aclk;
-	}
-
-	return 0;
-
-err_disable_aclk:
-	clk_disable_unprepare(rga->aclk);
-err_disable_sclk:
-	clk_disable_unprepare(rga->sclk);
-
-	return ret;
-}
-
-static void rga_disable_clocks(struct rockchip_rga *rga)
-{
-	clk_disable_unprepare(rga->sclk);
-	clk_disable_unprepare(rga->hclk);
-	clk_disable_unprepare(rga->aclk);
-}
-
 static int rga_parse_dt(struct rockchip_rga *rga)
 {
 	struct reset_control *core_rst, *axi_rst, *ahb_rst;
+	int ret;
 
 	core_rst = devm_reset_control_get(rga->dev, "core");
 	if (IS_ERR(core_rst)) {
@@ -777,23 +739,12 @@ static int rga_parse_dt(struct rockchip_rga *rga)
 	udelay(1);
 	reset_control_deassert(ahb_rst);
 
-	rga->sclk = devm_clk_get(rga->dev, "sclk");
-	if (IS_ERR(rga->sclk)) {
-		dev_err(rga->dev, "failed to get sclk clock\n");
-		return PTR_ERR(rga->sclk);
-	}
-
-	rga->aclk = devm_clk_get(rga->dev, "aclk");
-	if (IS_ERR(rga->aclk)) {
-		dev_err(rga->dev, "failed to get aclk clock\n");
-		return PTR_ERR(rga->aclk);
-	}
-
-	rga->hclk = devm_clk_get(rga->dev, "hclk");
-	if (IS_ERR(rga->hclk)) {
-		dev_err(rga->dev, "failed to get hclk clock\n");
-		return PTR_ERR(rga->hclk);
+	ret = devm_clk_bulk_get_all(rga->dev, &rga->clks);
+	if (ret < 0) {
+		dev_err(rga->dev, "failed to get clocks\n");
+		return ret;
 	}
+	rga->num_clks = ret;
 
 	return 0;
 }
@@ -941,7 +892,7 @@ static int __maybe_unused rga_runtime_suspend(struct device *dev)
 {
 	struct rockchip_rga *rga = dev_get_drvdata(dev);
 
-	rga_disable_clocks(rga);
+	clk_bulk_disable_unprepare(rga->num_clks, rga->clks);
 
 	return 0;
 }
@@ -950,7 +901,7 @@ static int __maybe_unused rga_runtime_resume(struct device *dev)
 {
 	struct rockchip_rga *rga = dev_get_drvdata(dev);
 
-	return rga_enable_clocks(rga);
+	return clk_bulk_prepare_enable(rga->num_clks, rga->clks);
 }
 
 static const struct dev_pm_ops rga_pm = {
diff --git a/drivers/media/platform/rockchip/rga/rga.h b/drivers/media/platform/rockchip/rga/rga.h
index 8105bb2efe570..6c3c9f3f71584 100644
--- a/drivers/media/platform/rockchip/rga/rga.h
+++ b/drivers/media/platform/rockchip/rga/rga.h
@@ -6,6 +6,7 @@
 #ifndef __RGA_H__
 #define __RGA_H__
 
+#include <linux/clk.h>
 #include <linux/platform_device.h>
 #include <media/videobuf2-v4l2.h>
 #include <media/v4l2-ctrls.h>
@@ -76,9 +77,8 @@ struct rockchip_rga {
 	struct device *dev;
 	struct regmap *grf;
 	void __iomem *regs;
-	struct clk *sclk;
-	struct clk *aclk;
-	struct clk *hclk;
+	struct clk_bulk_data *clks;
+	int num_clks;
 	struct rockchip_rga_version version;
 
 	/* vfd lock */
-- 
2.53.0



