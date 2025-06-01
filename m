Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33AAC274FEA;
	Sun,  1 Jun 2025 23:28:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748820515; cv=none; b=MOdofbSDlJyDfLYeTqC2y6y3eRg0DHLg/MmK6Ovm66ALS0um/NATfGOjgGQesWcAQhtwKI1xawMkj/XCDEtfUqujcfYi2RF74AaZ35wgQElr7C4zGUOESnAO5d2P0hpbknBPKmXvESgn9r0Wyj749VpbCFTvl1g/1EJ1fvAqazs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748820515; c=relaxed/simple;
	bh=bGg1THfPNAANaIsdBNdyA4CG0dlqECYLlIX9zvYlvUY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=XOxTe3Z2DQcNi81KqNbSd6iueSP7vEHNTFStqOCYrRXES0XccKLEU01JVlc8v/u4wiNISIc0YqWRxskTtmggmqXKKSn0+DX1iQuQcqfF92SnsSsD4J8mkHgbnj8h5867DpmUMVfyKyT78qriCFYKZIb1bYEfNAtWuIf0jCO5Lvw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dHrovzmV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dHrovzmV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3018FC4CEEE;
	Sun,  1 Jun 2025 23:28:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748820513;
	bh=bGg1THfPNAANaIsdBNdyA4CG0dlqECYLlIX9zvYlvUY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dHrovzmVSWF8FM1Iy2O2y4em0+StZwXqzZSGAds9R8espFd9xbB5DItaPOcDxWIGE
	 jjIq0MhDCWJG27RTgHBFlxDoUTRmNtCRNcTiWeFqcM7D61ulkv04MDQ6Zy4eow8yYI
	 3gHfBig0twKtqYbKy4/TU3h/GZ2A+OJmdp7ufoVMuylqX7nJq1VsV67YPzxba5HRS8
	 vYZCir/T2NIGAGJzjuKyhdm6SQan5FEMyP/o842JY7eT7AR+v7aIWhFX4D7wx/U1TF
	 aAxuz5SYOeKSDgg+h6Tk6/1HzzlHkR42Xs4VTAjL4hyX0jt2OQvlgXnCReLI8fSrjn
	 Lt1bXVv3L5BMA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Antonin Godard <antonin.godard@bootlin.com>,
	Dmitry Baryshkov <lumag@kernel.org>,
	Louis Chauvet <louis.chauvet@bootlin.com>,
	Sasha Levin <sashal@kernel.org>,
	neil.armstrong@linaro.org,
	maarten.lankhorst@linux.intel.com,
	mripard@kernel.org,
	tzimmermann@suse.de,
	airlied@gmail.com,
	simona@ffwll.ch,
	dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.15 079/110] drm/panel: simple: Add POWERTIP PH128800T004-ZZA01 panel entry
Date: Sun,  1 Jun 2025 19:24:01 -0400
Message-Id: <20250601232435.3507697-79-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250601232435.3507697-1-sashal@kernel.org>
References: <20250601232435.3507697-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.15
Content-Transfer-Encoding: 8bit

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

NO This commit should NOT be backported to stable kernel trees based on
the following analysis: **Commit Classification**: This is a new
hardware support addition, not a bug fix. **Analysis of the commit**: 1.
**Nature of Change**: The commit adds support for a brand new panel
variant (POWERTIP PH128800T004-ZZA01) to the panel-simple driver. This
is purely additive functionality for new hardware. 2. **Code Changes
Review**: - Adds a new `powertip_ph128800t004_zza01_mode` structure with
display timing parameters - Adds a new `powertip_ph128800t004_zza01`
panel descriptor - Adds a new device tree compatible string entry in the
`platform_of_match` table - The changes are isolated and only add new
entries without modifying existing functionality 3. **Reference to
Similar Commits**: All the provided historical examples of panel
additions (Similar Commits #1, #2, #5) were marked as "Backport Status:
NO", indicating that new panel support commits are typically not
backported. 4. **Stable Tree Criteria Violation**: - This is new feature
addition, not a bug fix - It doesn't address any existing user-affecting
issues - It enables support for hardware that previously wasn't
supported at all - No indication of fixing broken functionality 5.
**Exception Analysis**: The only similar commit marked "YES" (Similar
Commit #4) was specifically fixing missing display mode flags for an
existing panel, which was a clear bug fix with a "Fixes:" tag. This
current commit has no such characteristics. 6. **Risk Assessment**:
While the change is low-risk and isolated, it doesn't meet the
fundamental criteria for stable backporting as it's new hardware
enablement rather than fixing existing functionality. The stable tree
policy specifically excludes new hardware support unless it fixes
existing broken functionality, which this commit does not do.

 drivers/gpu/drm/panel/panel-simple.c | 29 ++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/drivers/gpu/drm/panel/panel-simple.c b/drivers/gpu/drm/panel/panel-simple.c
index 33a37539de574..cbd0423cc64e0 100644
--- a/drivers/gpu/drm/panel/panel-simple.c
+++ b/drivers/gpu/drm/panel/panel-simple.c
@@ -3797,6 +3797,32 @@ static const struct panel_desc pda_91_00156_a0  = {
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
@@ -5154,6 +5180,9 @@ static const struct of_device_id platform_of_match[] = {
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

