Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 298991DE4E3;
	Mon, 12 May 2025 17:32:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747071126; cv=none; b=W0HYk/ufZafEleLMVt8sbM08/jWfD4WbUWKwcY+7i788Wp76iWZ8IuT7cRRtjD5kjwOW1D6Rvjwk9QdyDp0WI19jD/FfDr1a6ajJFkVBW+MFRdt5JiGC0xDVE6/YFndaRLYvKiNJj6cgEzRqbMecw3lg/bKGgjPhkRyLboPTm68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747071126; c=relaxed/simple;
	bh=lNSWamxQmmOTqM0ex135U/XDmZCACMvC/eLPStqrfMY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bqz28yLi+SXyOi06CqyR6s4IaGxNTmqxi1Ejp7x+mgfcfrDaKr9WbscoBAnyf2QABiogCpP4sDzpV6QROH8rVJsH9JSTIFSXPgDZ0K/sLpyTJmS/jXzs2d9/Phu3JVGT+Lwqk0Mr+Xw0xJMLdmgwDB1p+K2NyfK85FbtF+EagiY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yTX7Rz7y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yTX7Rz7y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43B5FC4CEE7;
	Mon, 12 May 2025 17:32:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747071125;
	bh=lNSWamxQmmOTqM0ex135U/XDmZCACMvC/eLPStqrfMY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yTX7Rz7y/X63fC5TndXctl39YTDiL3lqYKC6T4SHttOB7QO5FQq/ahKd9TiYIziAa
	 /XLeA5WW8GeeAfbx/h8/7bSxc1vNmfFndChvfRzsX/wRgiZIanLMeK9kxH3Ua44JAg
	 9rPOexBFRbdjzK1Rtm9evBXyXpDmeHdyP/N7rnWI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kevin Baker <kevinb@ventureresearch.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 48/54] drm/panel: simple: Update timings for AUO G101EVN010
Date: Mon, 12 May 2025 19:30:00 +0200
Message-ID: <20250512172017.575911374@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172015.643809034@linuxfoundation.org>
References: <20250512172015.643809034@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 67412115b4b30..ecea88d63f0d8 100644
--- a/drivers/gpu/drm/panel/panel-simple.c
+++ b/drivers/gpu/drm/panel/panel-simple.c
@@ -1210,27 +1210,28 @@ static const struct panel_desc auo_g070vvn01 = {
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



