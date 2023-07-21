Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FF561F923
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 18:56:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2C17C433C7;
	Fri, 21 Jul 2023 18:56:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689965783;
	bh=wzWOvDXoVcgwIxVVMEln0iHRIxEkjIzlMvsrjrqld18=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=COI3d+nTmNxdOvbYW1g+yqmxhtv5dEzftDU4MIJq4JlhSXYjqQu/VM6qt90IOsX6m
	 BFDetwzZrGShnC41EOS/kPu/Fha6MhkNGE4Fwqeq7u31h87cxW+cofn1qESIJ+afjP
	 bmX8DY15Bm7XbZ/UNmHnbK6QJZk2lp6QkV4g5KwY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 113/532] drm/panel: sharp-ls043t1le01: adjust mode settings
Date: Fri, 21 Jul 2023 18:00:17 +0200
Message-ID: <20230721160620.683650676@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160614.695323302@linuxfoundation.org>
References: <20230721160614.695323302@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit dee23b2c9e3ff46d59c5d45e1436eceb878e7c9a ]

Using current settings causes panel flickering on APQ8074 dragonboard.
Adjust panel settings to follow the vendor-provided mode. This also
enables MIPI_DSI_MODE_VIDEO_SYNC_PULSE, which is also specified by the
vendor dtsi for the mentioned dragonboard.

Fixes: ee0172383190 ("drm/panel: Add Sharp LS043T1LE01 MIPI DSI panel")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20230507172639.2320934-1-dmitry.baryshkov@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panel/panel-sharp-ls043t1le01.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/panel/panel-sharp-ls043t1le01.c b/drivers/gpu/drm/panel/panel-sharp-ls043t1le01.c
index 25829a0a8e801..e2f1e983ef7eb 100644
--- a/drivers/gpu/drm/panel/panel-sharp-ls043t1le01.c
+++ b/drivers/gpu/drm/panel/panel-sharp-ls043t1le01.c
@@ -192,15 +192,15 @@ static int sharp_nt_panel_enable(struct drm_panel *panel)
 }
 
 static const struct drm_display_mode default_mode = {
-	.clock = 41118,
+	.clock = (540 + 48 + 32 + 80) * (960 + 3 + 10 + 15) * 60 / 1000,
 	.hdisplay = 540,
 	.hsync_start = 540 + 48,
-	.hsync_end = 540 + 48 + 80,
-	.htotal = 540 + 48 + 80 + 32,
+	.hsync_end = 540 + 48 + 32,
+	.htotal = 540 + 48 + 32 + 80,
 	.vdisplay = 960,
 	.vsync_start = 960 + 3,
-	.vsync_end = 960 + 3 + 15,
-	.vtotal = 960 + 3 + 15 + 1,
+	.vsync_end = 960 + 3 + 10,
+	.vtotal = 960 + 3 + 10 + 15,
 };
 
 static int sharp_nt_panel_get_modes(struct drm_panel *panel,
@@ -280,6 +280,7 @@ static int sharp_nt_panel_probe(struct mipi_dsi_device *dsi)
 	dsi->lanes = 2;
 	dsi->format = MIPI_DSI_FMT_RGB888;
 	dsi->mode_flags = MIPI_DSI_MODE_VIDEO |
+			MIPI_DSI_MODE_VIDEO_SYNC_PULSE |
 			MIPI_DSI_MODE_VIDEO_HSE |
 			MIPI_DSI_CLOCK_NON_CONTINUOUS |
 			MIPI_DSI_MODE_NO_EOT_PACKET;
-- 
2.39.2



