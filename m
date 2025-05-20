Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EBA92500D0;
	Tue, 20 May 2025 14:15:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747750504; cv=none; b=lyo6pJMRLOk4zAFQ9Q+w94Ytt1Nih9oC8ZmpVLzb1POYeY7lPR2a2AHVJ/EshviLekW1U3U9Dowr1/nml1c1GDI1pIsE+vmnZwx1KCuwMv6IXMUCIgLg6HDKWOwv9hJ3pKuDdqkM2RCPV/U4lGF10s+XfCx3FzgyG7fD9qv8mG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747750504; c=relaxed/simple;
	bh=7fh5f0DFLr9MwQi3YepixT1thoOmLv8KDYdBC6s+vGI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BHnTcoacMjx3DAp45LlmVeX8MFEhPVgg5GVGWllzhah6I5YIS/xctpf4o4V+eR16GD7I70SQR4g2Qjv1wNosXDOUcbxVu7AYkynvG+6wBVbWmx7Ri122GNW5qW/NUACst1Nblyb+zz8Xf74aBb2wSbBbDyQG/bJr5ppkkQAU+/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wS/xSSBv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wS/xSSBv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23B30C4CEE9;
	Tue, 20 May 2025 14:15:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747750504;
	bh=7fh5f0DFLr9MwQi3YepixT1thoOmLv8KDYdBC6s+vGI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wS/xSSBvulz+LETiuD+2w3pQyjJmq0bYXKZZdo+kh/meLibyBJGGpp57Z55JJbO3I
	 uXDbbSLHKT2V3I2e1yyt1z+EXMJVDle3XUJTsoCX27oLJAu49nSSjtsccYh8WmyCUx
	 LOWbj/43teYXdpl3HhbTvlCa9RQ3CmNlZsSc5bjU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	I Hsin Cheng <richard120310@gmail.com>,
	Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 029/145] drm/meson: Use 1000ULL when operating with mode->clock
Date: Tue, 20 May 2025 15:49:59 +0200
Message-ID: <20250520125811.700103060@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125810.535475500@linuxfoundation.org>
References: <20250520125810.535475500@linuxfoundation.org>
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

From: I Hsin Cheng <richard120310@gmail.com>

[ Upstream commit eb0851e14432f3b87c77b704c835ac376deda03a ]

Coverity scan reported the usage of "mode->clock * 1000" may lead to
integer overflow. Use "1000ULL" instead of "1000"
when utilizing it to avoid potential integer overflow issue.

Link: https://scan5.scan.coverity.com/#/project-view/10074/10063?selectedIssue=1646759
Signed-off-by: I Hsin Cheng <richard120310@gmail.com>
Reviewed-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Fixes: 1017560164b6 ("drm/meson: use unsigned long long / Hz for frequency types")
Link: https://lore.kernel.org/r/20250505184338.678540-1-richard120310@gmail.com
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/meson/meson_encoder_hdmi.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/meson/meson_encoder_hdmi.c b/drivers/gpu/drm/meson/meson_encoder_hdmi.c
index ce8cea5d3a56b..c61e6026adfae 100644
--- a/drivers/gpu/drm/meson/meson_encoder_hdmi.c
+++ b/drivers/gpu/drm/meson/meson_encoder_hdmi.c
@@ -75,7 +75,7 @@ static void meson_encoder_hdmi_set_vclk(struct meson_encoder_hdmi *encoder_hdmi,
 	unsigned long long venc_freq;
 	unsigned long long hdmi_freq;
 
-	vclk_freq = mode->clock * 1000;
+	vclk_freq = mode->clock * 1000ULL;
 
 	/* For 420, pixel clock is half unlike venc clock */
 	if (encoder_hdmi->output_bus_fmt == MEDIA_BUS_FMT_UYYVYY8_0_5X24)
@@ -123,7 +123,7 @@ static enum drm_mode_status meson_encoder_hdmi_mode_valid(struct drm_bridge *bri
 	struct meson_encoder_hdmi *encoder_hdmi = bridge_to_meson_encoder_hdmi(bridge);
 	struct meson_drm *priv = encoder_hdmi->priv;
 	bool is_hdmi2_sink = display_info->hdmi.scdc.supported;
-	unsigned long long clock = mode->clock * 1000;
+	unsigned long long clock = mode->clock * 1000ULL;
 	unsigned long long phy_freq;
 	unsigned long long vclk_freq;
 	unsigned long long venc_freq;
-- 
2.39.5



