Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A7672566DD;
	Thu, 17 Apr 2025 18:00:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744912852; cv=none; b=TPsTnJwAPbwCwrRtEd0eiW7XhcYyXwrmD71FybGf00gGffmmktcWXQBeScOSymjoTHNalBfdcZW1tWHAP5rwZSQEizELNSP8mfYZCbgg4tsaSLdu5VyspRg3R0DO23OyK6U+lUm106SL5ql1LaqPHpWrtYpaDzfjTK4U3f+MTQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744912852; c=relaxed/simple;
	bh=SL3Fy6ObZSlRlq7Xq5XNBBHMJS6d9fqHKtZnu2iALtE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z5glMGgsn1wTaLEb+jWd4M2bYwvpLGgdD9uit+EaZoscE5la89mB6Vexr7YOmOrsPnt/ITUy08EKWSyKRbqvi9XeLl62gEqJZLzyDIWKDmUxWQKcyj6VPNTTu/jDksaxldhaycx7t/z8+CLY+h4iba7tfCDUmB+qaytIFod7R60=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NknsHX36; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NknsHX36"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F262C4CEE4;
	Thu, 17 Apr 2025 18:00:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744912851;
	bh=SL3Fy6ObZSlRlq7Xq5XNBBHMJS6d9fqHKtZnu2iALtE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NknsHX36ZMQ33X4rQpxlPsES2WwvCiDk5aicaQf/yJtVkqEkjdLuNSFtyP1DOcItA
	 VWaddHd/9u8exkCQUZZQZ6gp1YTE2KvLGzfMQv2KHHI5oEP/p+txEnqEDXVf0vhV/4
	 iWBp7c4tJxya6HDxEaTjxi/h4JKIrofV3xqKEwRw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Derek Foreman <derek.foreman@collabora.com>,
	Cristian Ciocaltea <cristian.ciocaltea@collabora.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 146/449] drm/rockchip: Dont change hdmi reference clock rate
Date: Thu, 17 Apr 2025 19:47:14 +0200
Message-ID: <20250417175123.849428699@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175117.964400335@linuxfoundation.org>
References: <20250417175117.964400335@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Derek Foreman <derek.foreman@collabora.com>

[ Upstream commit 1854df7087be70ad54e24b2e308d7558ebea9f27 ]

The code that changes hdmi->ref_clk was accidentally copied from
downstream code that sets a different clock. We don't actually
want to set any clock here at all.

Setting this clock incorrectly leads to incorrect timings for
DDC, CEC, and HDCP signal generation.

No Fixes listed, as the theoretical timing error in DDC appears to
still be within tolerances and harmless - and HDCP and CEC are not
yet supported.

Signed-off-by: Derek Foreman <derek.foreman@collabora.com>
Reviewed-by: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Link: https://patchwork.freedesktop.org/patch/msgid/20241217201708.3320673-1-derek.foreman@collabora.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/rockchip/dw_hdmi_qp-rockchip.c | 13 -------------
 1 file changed, 13 deletions(-)

diff --git a/drivers/gpu/drm/rockchip/dw_hdmi_qp-rockchip.c b/drivers/gpu/drm/rockchip/dw_hdmi_qp-rockchip.c
index e498767a0a667..cebd72bf1ef25 100644
--- a/drivers/gpu/drm/rockchip/dw_hdmi_qp-rockchip.c
+++ b/drivers/gpu/drm/rockchip/dw_hdmi_qp-rockchip.c
@@ -54,7 +54,6 @@ struct rockchip_hdmi_qp {
 	struct regmap *regmap;
 	struct regmap *vo_regmap;
 	struct rockchip_encoder encoder;
-	struct clk *ref_clk;
 	struct dw_hdmi_qp *hdmi;
 	struct phy *phy;
 	struct gpio_desc *enable_gpio;
@@ -81,7 +80,6 @@ static void dw_hdmi_qp_rockchip_encoder_enable(struct drm_encoder *encoder)
 	if (crtc && crtc->state) {
 		rate = drm_hdmi_compute_mode_clock(&crtc->state->adjusted_mode,
 						   8, HDMI_COLORSPACE_RGB);
-		clk_set_rate(hdmi->ref_clk, rate);
 		/*
 		 * FIXME: Temporary workaround to pass pixel clock rate
 		 * to the PHY driver until phy_configure_opts_hdmi
@@ -330,17 +328,6 @@ static int dw_hdmi_qp_rockchip_bind(struct device *dev, struct device *master,
 		return ret;
 	}
 
-	for (i = 0; i < ret; i++) {
-		if (!strcmp(clks[i].id, "ref")) {
-			hdmi->ref_clk = clks[1].clk;
-			break;
-		}
-	}
-	if (!hdmi->ref_clk) {
-		drm_err(hdmi, "Missing ref clock\n");
-		return -EINVAL;
-	}
-
 	hdmi->enable_gpio = devm_gpiod_get_optional(hdmi->dev, "enable",
 						    GPIOD_OUT_HIGH);
 	if (IS_ERR(hdmi->enable_gpio)) {
-- 
2.39.5



