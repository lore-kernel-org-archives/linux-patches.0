Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEEC147124F;
	Wed, 30 Sep 2026 15:34:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790782499; cv=none; b=jPWDLVCK3U6TPFF4vO4US4pnbpnpdw2CAtjk4bbEJdjDjFIFrgGBUK1AEweu9oW+s3lEajg7YZEUDZjs784PCLiWI/NGM9dI80woBq1tH7ibQTcFYWSRL4i1LYe8sqn99q+VOKWbKNYPVVS44xLpS8LfbuVFanU9s6Y4HctiqdE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790782499; c=relaxed/simple;
	bh=Y2s4kF9jGrG3YTm3xCZlyURQ76yrnFAVyxqBs4J27Rg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Or8iw9qof50xKGQKTuH03GOf60ikRByPxxHgVSr+BHMPYOclwzcfnIMRrriLSIOqc7Y/BujZdHuKu3r70kMLHrIiYJtRNn8GNRMBcDZWlOmhT58ZpND/GxuPR79FCzETZUSYXRpyoW13BE5PxkKTYVRUC5VF0UPdN2mg7AOgRn0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U4nH+bR+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U4nH+bR+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BD541F00893;
	Wed, 30 Sep 2026 15:34:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790782487;
	bh=lsFSk1Ux4dPpqAaE6kHfFGLQHTyhIEKc4o9FbRerlD4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=U4nH+bR+Th/BQKnHT/JtxVabR7ChE3qV4LzSPcnIorxZdS+GoZgX1O/emaB6FWdXx
	 x89aacDtNnEQEEGJjORjFkIY15Bm9RnPvBARLHh+V2q7aVUTL/eDwW4OCmfuNbpItb
	 Y3MGZ0EVJRNv14f6WrYcDcDrLwOkEJvEL+brTAAo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Trimarchi <michael@amarulasolutions.com>,
	Dario Binacchi <dario.binacchi@amarulasolutions.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 062/595] drm/panel: simple: Add AM-1280800W8TZQW-T00H
Date: Wed, 30 Sep 2026 17:19:15 +0200
Message-ID: <20260930152349.070635877@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dario Binacchi <dario.binacchi@amarulasolutions.com>

[ Upstream commit 6acb810ebc5d8dea5c250326c14dc44e32dc8e92 ]

Add Ampire, AM-1280800W8TZQW-T00H 10.1" TFT LCD panel timings.

Co-developed-by: Michael Trimarchi <michael@amarulasolutions.com>
Signed-off-by: Michael Trimarchi <michael@amarulasolutions.com>
Signed-off-by: Dario Binacchi <dario.binacchi@amarulasolutions.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://patch.msgid.link/20260515082232.1766586-2-dario.binacchi@amarulasolutions.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panel/panel-simple.c | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/drivers/gpu/drm/panel/panel-simple.c b/drivers/gpu/drm/panel/panel-simple.c
index a59adc08267f5..0c18c0cc701c4 100644
--- a/drivers/gpu/drm/panel/panel-simple.c
+++ b/drivers/gpu/drm/panel/panel-simple.c
@@ -686,6 +686,31 @@ static const struct panel_desc ampire_am_1280800n3tzqw_t00h = {
 	.connector_type = DRM_MODE_CONNECTOR_LVDS,
 };
 
+static const struct drm_display_mode ampire_am_1280800w8tzqw_t00h_mode = {
+	.clock = 72400,
+	.hdisplay = 1280,
+	.hsync_start = 1280 + 40,
+	.hsync_end = 1280 + 40 + 80,
+	.htotal = 1280 + 40 + 80 + 40,
+	.vdisplay = 800,
+	.vsync_start = 800 + 10,
+	.vsync_end = 800 + 10 + 18,
+	.vtotal = 800 + 10 + 18 + 10,
+};
+
+static const struct panel_desc ampire_am_1280800w8tzqw_t00h = {
+	.modes = &ampire_am_1280800w8tzqw_t00h_mode,
+	.num_modes = 1,
+	.bpc = 8,
+	.size = {
+		.width = 217,
+		.height = 136,
+	},
+	.bus_flags = DRM_BUS_FLAG_DE_HIGH,
+	.bus_format = MEDIA_BUS_FMT_RGB888_1X7X4_SPWG,
+	.connector_type = DRM_MODE_CONNECTOR_LVDS,
+};
+
 static const struct drm_display_mode ampire_am_480272h3tmqw_t01h_mode = {
 	.clock = 9000,
 	.hdisplay = 480,
@@ -3921,6 +3946,9 @@ static const struct of_device_id platform_of_match[] = {
 	{
 		.compatible = "ampire,am-1280800n3tzqw-t00h",
 		.data = &ampire_am_1280800n3tzqw_t00h,
+	}, {
+		.compatible = "ampire,am-1280800w8tzqw-t00h",
+		.data = &ampire_am_1280800w8tzqw_t00h,
 	}, {
 		.compatible = "ampire,am-480272h3tmqw-t01h",
 		.data = &ampire_am_480272h3tmqw_t01h,
-- 
2.53.0



