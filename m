Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9218295DBC;
	Mon, 12 May 2025 17:55:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747072516; cv=none; b=pr7BBldsP+WlKDg9upBmx2sK20YchG5F7HnO+RUDFQNoDhqur2ISKsZW9biHvO0zZh3Nplt+q6gFYyIAMhp+Bj3h8YFRYnsgKIFdjf9trgFXDvcB9jDBx4/LQ0MZc4yo1ABupVpNHlVufH3E/KHhkXujOQAuHhCOZA/NjLew1eA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747072516; c=relaxed/simple;
	bh=mGElxlQqpr9VLDfc+EoUuH569hSMpYtB0/t9R3WkJP4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KnhrxkD8nkVBRs357dISzXtcu4QZtk72Lf1BDIwGXQ2wrD16vnpZ0Kfl6ntr2fPZhWsM9cPp9FFYgLxumcUoJPUw/G876uvSS6h/8FxkArtYNzQPBjv7ISBkXmymbLt2ndNyEemUuFUG+YATaGZeGolqplyt0bzeCcOkidpduZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xtjYEC45; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xtjYEC45"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B039C4CEE7;
	Mon, 12 May 2025 17:55:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747072516;
	bh=mGElxlQqpr9VLDfc+EoUuH569hSMpYtB0/t9R3WkJP4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xtjYEC459GTbd4ststYnFlqN25DPhVucAn+fOu6yhSQCb4iCUlLoKedBX+laP1RmB
	 HksQ81ViTx9zg5pgOVAsrPMz9MDjAXAxzMIFDpsWgnV4uxGkR3WxaTIziDci8QyLgb
	 XNeTl2Zzppzc1fg0j7y4U6KtC9zDGOjP4VLMp/Ng=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kevin Baker <kevinb@ventureresearch.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 66/92] drm/panel: simple: Update timings for AUO G101EVN010
Date: Mon, 12 May 2025 19:45:41 +0200
Message-ID: <20250512172025.811081861@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172023.126467649@linuxfoundation.org>
References: <20250512172023.126467649@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kevin Baker <kevinb@ventureresearch.com>

[ Upstream commit 7c6fa1797a725732981f2d77711c867166737719 ]

Switch to panel timings based on datasheet for the AUO G101EVN01.0
LVDS panel. Default timings were tested on the panel.

Previous mode-based timings resulted in horizontal display shift.

Signed-off-by: Kevin Baker <kevinb@ventureresearch.com>
Fixes: 4fb86404a977 ("drm/panel: simple: Add AUO G101EVN010 panel support")
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://lore.kernel.org/r/20250505170256.1385113-1-kevinb@ventureresearch.com
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://lore.kernel.org/r/20250505170256.1385113-1-kevinb@ventureresearch.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panel/panel-simple.c | 25 +++++++++++++------------
 1 file changed, 13 insertions(+), 12 deletions(-)

diff --git a/drivers/gpu/drm/panel/panel-simple.c b/drivers/gpu/drm/panel/panel-simple.c
index a35e94e2ffd06..8a86f5d5c708d 100644
--- a/drivers/gpu/drm/panel/panel-simple.c
+++ b/drivers/gpu/drm/panel/panel-simple.c
@@ -921,27 +921,28 @@ static const struct panel_desc auo_g070vvn01 = {
 	},
 };
 
-static const struct drm_display_mode auo_g101evn010_mode = {
-	.clock = 68930,
-	.hdisplay = 1280,
-	.hsync_start = 1280 + 82,
-	.hsync_end = 1280 + 82 + 2,
-	.htotal = 1280 + 82 + 2 + 84,
-	.vdisplay = 800,
-	.vsync_start = 800 + 8,
-	.vsync_end = 800 + 8 + 2,
-	.vtotal = 800 + 8 + 2 + 6,
+static const struct display_timing auo_g101evn010_timing = {
+	.pixelclock = { 64000000, 68930000, 85000000 },
+	.hactive = { 1280, 1280, 1280 },
+	.hfront_porch = { 8, 64, 256 },
+	.hback_porch = { 8, 64, 256 },
+	.hsync_len = { 40, 168, 767 },
+	.vactive = { 800, 800, 800 },
+	.vfront_porch = { 4, 8, 100 },
+	.vback_porch = { 4, 8, 100 },
+	.vsync_len = { 8, 16, 223 },
 };
 
 static const struct panel_desc auo_g101evn010 = {
-	.modes = &auo_g101evn010_mode,
-	.num_modes = 1,
+	.timings = &auo_g101evn010_timing,
+	.num_timings = 1,
 	.bpc = 6,
 	.size = {
 		.width = 216,
 		.height = 135,
 	},
 	.bus_format = MEDIA_BUS_FMT_RGB666_1X7X3_SPWG,
+	.bus_flags = DRM_BUS_FLAG_DE_HIGH,
 	.connector_type = DRM_MODE_CONNECTOR_LVDS,
 };
 
-- 
2.39.5



