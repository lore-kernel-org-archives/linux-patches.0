Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91B31255F39;
	Mon, 23 Jun 2025 13:33:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750685595; cv=none; b=hlqsgcDPN2k8hQQFXSZTkMyxCzqddEle1u4b/sbp60fkY3Pbu7L6JCCzwY2qWndgcHlqykB0Rb1th1pdamIxdm31M5g2c4uRBRtTuS7HzwXmJHWHRYPLHZbN9lHfRNEhumKsnUPOE6vRIWZH+bXACLHDlLieeJf4GlfHTIABwQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750685595; c=relaxed/simple;
	bh=ScdX52xqNsqqF4TNrIDaje2WGAl8sCsVPypMA4fJdMY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BPmufer8fNI73snLOQJdUhluhtbaWmuRqr4imNfRERVZhUkcy35wgKni6gpVk2Swie6JMggjdYub4A+QXRM1G5V3Xmce6acEVjlsbh5CO/OdWWBoFdPi57piQkCwxxeW/fktQC2qcxk14PD9QRQplMPwqNcV33SMR5P9lGsWui4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z68ECnCi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z68ECnCi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D710C4CEEA;
	Mon, 23 Jun 2025 13:33:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750685595;
	bh=ScdX52xqNsqqF4TNrIDaje2WGAl8sCsVPypMA4fJdMY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z68ECnCibJja/OZ4ooPlXPQVw9aBtCdbP30oyLWnCp1pE9e1ASFDW38WoTdAm/Q9N
	 hlnPgwSr/Ljy0E/uRydHW3TI6jRT2QONB7lX6fXNWe1UQW94M+jZ91l3Ge9aBz/gIm
	 R4krWstHU9Ftr04MdjZ/wfrDi0BEe7BRxQje3BZM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxime Ripard <mripard@kernel.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Tejas Vipin <tejasvipin76@gmail.com>,
	Doug Anderson <dianders@chromium.org>,
	Anusha Srivatsa <asrivats@redhat.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 246/592] drm/panel/sharp-ls043t1le01: Use _multi variants
Date: Mon, 23 Jun 2025 15:03:24 +0200
Message-ID: <20250623130706.144660247@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anusha Srivatsa <asrivats@redhat.com>

[ Upstream commit 20e8219205145e1af3b98b6a0a3cc59568116a05 ]

Move away from using deprecated API and use _multi variants
if available. Use mipi_dsi_msleep() and mipi_dsi_usleep_range()
instead of msleep() and usleep_range() respectively.

Used Coccinelle to find the _multi variant APIs,replacing
mpi_dsi_msleep() where necessary and for returning
dsi_ctx.accum_err in these functions. mipi_dsi_dcs_write()
does not have a corresponding _multi() variant. Replacing it with
mipi_dsi_dcs_write_seq_multi() instead. This change is manual.

The Coccinelle script is the same as the one in commit c8ba07caaecc
("drm/panel/synaptics-r63353: Use _multi variants")

v2: Use mipi_dsi_write_buffer_multi() in place of
mipi_dsi_dcs_write(). (Dmitry)

v3: add commit details where the same coccinelle script is
used and remove the actual script from commit log.
Use mipi_dsi_dcs_write_seq_multi() for mipi_dsi_dcs_write() (Doug)

Cc: Maxime Ripard <mripard@kernel.org>
Cc: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Cc: Tejas Vipin <tejasvipin76@gmail.com>
Cc: Doug Anderson <dianders@chromium.org>
Signed-off-by: Anusha Srivatsa <asrivats@redhat.com>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Link: https://lore.kernel.org/r/20250326-b4-panel-ls043t1le01-v3-1-96c554c0ea2b@redhat.com
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/panel/panel-sharp-ls043t1le01.c   | 41 +++++++------------
 1 file changed, 15 insertions(+), 26 deletions(-)

diff --git a/drivers/gpu/drm/panel/panel-sharp-ls043t1le01.c b/drivers/gpu/drm/panel/panel-sharp-ls043t1le01.c
index 729cbb0d8403f..36abfa2e65e96 100644
--- a/drivers/gpu/drm/panel/panel-sharp-ls043t1le01.c
+++ b/drivers/gpu/drm/panel/panel-sharp-ls043t1le01.c
@@ -36,60 +36,49 @@ static inline struct sharp_nt_panel *to_sharp_nt_panel(struct drm_panel *panel)
 static int sharp_nt_panel_init(struct sharp_nt_panel *sharp_nt)
 {
 	struct mipi_dsi_device *dsi = sharp_nt->dsi;
-	int ret;
+	struct mipi_dsi_multi_context dsi_ctx = { .dsi = dsi };
 
 	dsi->mode_flags |= MIPI_DSI_MODE_LPM;
 
-	ret = mipi_dsi_dcs_exit_sleep_mode(dsi);
-	if (ret < 0)
-		return ret;
+	mipi_dsi_dcs_exit_sleep_mode_multi(&dsi_ctx);
 
-	msleep(120);
+	mipi_dsi_msleep(&dsi_ctx, 120);
 
 	/* Novatek two-lane operation */
-	ret = mipi_dsi_dcs_write(dsi, 0xae, (u8[]){ 0x03 }, 1);
-	if (ret < 0)
-		return ret;
+	mipi_dsi_dcs_write_seq_multi(&dsi_ctx, 0xae,  0x03);
 
 	/* Set both MCU and RGB I/F to 24bpp */
-	ret = mipi_dsi_dcs_set_pixel_format(dsi, MIPI_DCS_PIXEL_FMT_24BIT |
-					(MIPI_DCS_PIXEL_FMT_24BIT << 4));
-	if (ret < 0)
-		return ret;
+	mipi_dsi_dcs_set_pixel_format_multi(&dsi_ctx,
+					    MIPI_DCS_PIXEL_FMT_24BIT |
+					    (MIPI_DCS_PIXEL_FMT_24BIT << 4));
 
-	return 0;
+	return dsi_ctx.accum_err;
 }
 
 static int sharp_nt_panel_on(struct sharp_nt_panel *sharp_nt)
 {
 	struct mipi_dsi_device *dsi = sharp_nt->dsi;
-	int ret;
+	struct mipi_dsi_multi_context dsi_ctx = { .dsi = dsi };
 
 	dsi->mode_flags |= MIPI_DSI_MODE_LPM;
 
-	ret = mipi_dsi_dcs_set_display_on(dsi);
-	if (ret < 0)
-		return ret;
+	mipi_dsi_dcs_set_display_on_multi(&dsi_ctx);
 
-	return 0;
+	return dsi_ctx.accum_err;
 }
 
 static int sharp_nt_panel_off(struct sharp_nt_panel *sharp_nt)
 {
 	struct mipi_dsi_device *dsi = sharp_nt->dsi;
-	int ret;
+	struct mipi_dsi_multi_context dsi_ctx = { .dsi = dsi };
 
 	dsi->mode_flags &= ~MIPI_DSI_MODE_LPM;
 
-	ret = mipi_dsi_dcs_set_display_off(dsi);
-	if (ret < 0)
-		return ret;
+	mipi_dsi_dcs_set_display_off_multi(&dsi_ctx);
 
-	ret = mipi_dsi_dcs_enter_sleep_mode(dsi);
-	if (ret < 0)
-		return ret;
+	mipi_dsi_dcs_enter_sleep_mode_multi(&dsi_ctx);
 
-	return 0;
+	return dsi_ctx.accum_err;
 }
 
 static int sharp_nt_panel_unprepare(struct drm_panel *panel)
-- 
2.39.5



