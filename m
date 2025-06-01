Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD5382951B3;
	Sun,  1 Jun 2025 23:33:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748820784; cv=none; b=gsEya6JIKfZdquS7/Tku/p0H71+7WriGBeV0kmKJCHrRCMcG6VJWXPLlvQ5vvEgMZsVEsjMCBQRAwRyu6OWqWduWhkQBwRgCN5//TD+x/xgc1Dq/Zp4vmdBUfkittKUn5h0vKSPLrVFDv1ZomaueTRnSXMp7FCW2sMLcbcApx5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748820784; c=relaxed/simple;
	bh=2nRHleqRzl2LUYPthqvJkUKGeYt0sWo8+rtDYATE/kk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=lR94OSNtgpsNyjE7ZNSE3UKEOueCPtjV+E06qEhts7OdBgXTKC1+CjQi2yw3Mp25UDyoIRh6/diDWPExRPD3AVOLdaJi2xSqVrS5oC/xAVtBI0M2P4sdSjdIKlToa1OjvdS9sDsCJA/a5kcc0gTjIT3Jmum7VRwv4qeAwcWuE5Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FZJP8CPl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FZJP8CPl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA750C4CEEE;
	Sun,  1 Jun 2025 23:33:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748820784;
	bh=2nRHleqRzl2LUYPthqvJkUKGeYt0sWo8+rtDYATE/kk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FZJP8CPlR9kRTDtaGycCnteXdhoAabdleGn+4yRK3gzzfyTCEcWhPOouubxGnXajM
	 LMGqZKvaX7YBerWmYVwno8szCe7F/6HNO/W6joi+622iReq3yBqszAGH1EVFE1pyNu
	 6vWlbypYS1qpJmGA9QLU2tGZec5CrWOtrVlaiDMfJ1v4/RxMv+yWZAmwV7uO0/v8kC
	 FJQs6N+w4Py2Wu0iL8u0iSgk/q6GzHHWuVuTUo/4/8igmRAX5vaMvP3yLdMICmR/tL
	 w/HNKJ0haAzBKyUinJLwgBrjtXxsp+BMmdlNRACyI5fIWO9Z8udaZL45vc37tmi2yo
	 Ew/t+0GQ3NaDg==
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
Subject: [PATCH AUTOSEL 6.14 073/102] drm/panel: simple: Add POWERTIP PH128800T004-ZZA01 panel entry
Date: Sun,  1 Jun 2025 19:29:05 -0400
Message-Id: <20250601232937.3510379-73-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250601232937.3510379-1-sashal@kernel.org>
References: <20250601232937.3510379-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.14.9
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
index cf9ab2d1f1d2a..8fdc0aba82081 100644
--- a/drivers/gpu/drm/panel/panel-simple.c
+++ b/drivers/gpu/drm/panel/panel-simple.c
@@ -3739,6 +3739,32 @@ static const struct panel_desc pda_91_00156_a0  = {
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
@@ -5090,6 +5116,9 @@ static const struct of_device_id platform_of_match[] = {
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

