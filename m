Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD3A6242D90;
	Mon, 23 Jun 2025 13:43:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750686223; cv=none; b=uTWnBsHJbfHVI5KMXY2Iym2kcOlZXByxnf9RmiuDROpGqKH+tLCznpl1vi3dgbDHG7zvALjgOrlVlIUpyTrkdL0AEZ+BDyCbiNnG0SDpZPnXnLpDys8U1sPXa3O5ZBU155D1dVA45GuZneIjBoLk71vJbxwITltiHeaQqOKRoP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750686223; c=relaxed/simple;
	bh=Y5HcotSkw7AM11lMpZ0akUOFk9UN1ILNAZj19BbWjNA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OuMdB8bx9+4iLwnasMi8BtCdu+CxWnbU+wAOGL3s/UJrpnO9PRYn6dma59TciYx5szHcCDfhpUXrwZ3/4NZfroeStglAT0fKYjH+kFpw/xC/KcenlHzhTTDeTDCZ48t6KXromotUz4j8gnlMjuIG5kKZmE+39+EXbwZpu7U1x+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wDDhkz7+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wDDhkz7+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CABFC4CEEA;
	Mon, 23 Jun 2025 13:43:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750686223;
	bh=Y5HcotSkw7AM11lMpZ0akUOFk9UN1ILNAZj19BbWjNA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wDDhkz7+i8hVo6gfmVkmPZrUflGtoi42puMTKumJRttPlPo5RTC3ikDJ+BrXj3GRe
	 PSae4SrZV3Ntuo4WHt5AuGNgpM4XH/SuEHuKdRG3n3j10UxS3pFKMLYfHv2KWhr+Sv
	 sHg0ttfsDhYltkfPfUA7zSixzigwugtEaj+kojPw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Antonin Godard <antonin.godard@bootlin.com>,
	Dmitry Baryshkov <lumag@kernel.org>,
	Louis Chauvet <louis.chauvet@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 310/592] drm/panel: simple: Add POWERTIP PH128800T004-ZZA01 panel entry
Date: Mon, 23 Jun 2025 15:04:28 +0200
Message-ID: <20250623130707.785519519@linuxfoundation.org>
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

From: Antonin Godard <antonin.godard@bootlin.com>

[ Upstream commit 6374a1005f20c1c2f7bbcc1bc735c2be4910a685 ]

Add support for the POWERTIP PH128800T004-ZZA01 10.1" (1280x800)
LCD-TFT panel. Its panel description is very much like the POWERTIP
PH128800T006-ZHC01 configured below this one, only its timings are
different.

Signed-off-by: Antonin Godard <antonin.godard@bootlin.com>
Reviewed-by: Dmitry Baryshkov <lumag@kernel.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20250311-add-powertip-ph128800t004-v1-2-7f95e6984cea@bootlin.com
Signed-off-by: Louis Chauvet <louis.chauvet@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panel/panel-simple.c | 29 ++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/drivers/gpu/drm/panel/panel-simple.c b/drivers/gpu/drm/panel/panel-simple.c
index 3aaac96c0bfbf..53211b5eaa09b 100644
--- a/drivers/gpu/drm/panel/panel-simple.c
+++ b/drivers/gpu/drm/panel/panel-simple.c
@@ -3798,6 +3798,32 @@ static const struct panel_desc pda_91_00156_a0  = {
 	.bus_format = MEDIA_BUS_FMT_RGB888_1X24,
 };
 
+static const struct drm_display_mode powertip_ph128800t004_zza01_mode = {
+	.clock = 71150,
+	.hdisplay = 1280,
+	.hsync_start = 1280 + 48,
+	.hsync_end = 1280 + 48 + 32,
+	.htotal = 1280 + 48 + 32 + 80,
+	.vdisplay = 800,
+	.vsync_start = 800 + 9,
+	.vsync_end = 800 + 9 + 8,
+	.vtotal = 800 + 9 + 8 + 6,
+	.flags = DRM_MODE_FLAG_PHSYNC | DRM_MODE_FLAG_PVSYNC,
+};
+
+static const struct panel_desc powertip_ph128800t004_zza01 = {
+	.modes = &powertip_ph128800t004_zza01_mode,
+	.num_modes = 1,
+	.bpc = 8,
+	.size = {
+		.width = 216,
+		.height = 135,
+	},
+	.bus_format = MEDIA_BUS_FMT_RGB888_1X7X4_SPWG,
+	.bus_flags = DRM_BUS_FLAG_DE_HIGH,
+	.connector_type = DRM_MODE_CONNECTOR_LVDS,
+};
+
 static const struct drm_display_mode powertip_ph128800t006_zhc01_mode = {
 	.clock = 66500,
 	.hdisplay = 1280,
@@ -5155,6 +5181,9 @@ static const struct of_device_id platform_of_match[] = {
 	}, {
 		.compatible = "pda,91-00156-a0",
 		.data = &pda_91_00156_a0,
+	}, {
+		.compatible = "powertip,ph128800t004-zza01",
+		.data = &powertip_ph128800t004_zza01,
 	}, {
 		.compatible = "powertip,ph128800t006-zhc01",
 		.data = &powertip_ph128800t006_zhc01,
-- 
2.39.5



