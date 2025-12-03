Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4C47309F01;
	Wed,  3 Dec 2025 15:34:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764776083; cv=none; b=FV83HKGswGJ/XryS0mgpbIewET6avw6yZMDfdplyxCQ5sc4ouw4v9FaXSYBvn14Pdrot8wqKqtnw5xfVSPh8LRAJaGcvCILSJIBe1gQlpsKM0uPohe0QqhOqd4ZuIhOth2i+ve16d4izoyT0HLl1+BTCZC5XH6k2/VwW2Yb5sbA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764776083; c=relaxed/simple;
	bh=p1Kj0v48oBlM6xR2mibYaSu9/i1AaEcnb0rmzU48JD4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RE14dJ4yATrX2am467+N0BSzCaO2MYfWKWdTnayVqpe5cjmGEOQ96PnbU9UlfyWpUIb45HtOuawlov07McEsV/2pXds8nbX0jKSP9t+fhQTbKmobqkdsyprVWrDElqnQeVx29wdN9ifHplEfQQagWHUgHehuIKbInFm2ma2+OPI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e6lO7otF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e6lO7otF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33689C4CEF5;
	Wed,  3 Dec 2025 15:34:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764776083;
	bh=p1Kj0v48oBlM6xR2mibYaSu9/i1AaEcnb0rmzU48JD4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e6lO7otFXhzsKpBlOsZ5zGyvEEOdVsbU60fAZxlxrUMdrTKSTZzgMLi1Im+0JC3Dt
	 Rq8gO/Dt+4R9+0nzP8cgUYxs9c+2vN9+qHFYEvPt1jgRNQDfgHeVk7QbJ6qCZBlaPe
	 gj9LPgHZzYpcnsB5ucb4bjpTsBRY9YCVp6JyrfHY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aradhya Bhatia <aradhya.bhatia@linux.dev>,
	Parth Pancholi <parth.pancholi@toradex.com>,
	Jayesh Choudhary <j-choudhary@ti.com>,
	Devarsh Thakkar <devarsht@ti.com>,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 076/300] drm/tidss: Use the crtc_* timings when programming the HW
Date: Wed,  3 Dec 2025 16:24:40 +0100
Message-ID: <20251203152403.438459971@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152400.447697997@linuxfoundation.org>
References: <20251203152400.447697997@linuxfoundation.org>
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

From: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>

[ Upstream commit 478306edc23eec4f0ec24a46222485910c66212d ]

Use the crtc_* fields from drm_display_mode, instead of the "logical"
fields. This shouldn't change anything in practice, but afaiu the crtc_*
fields are the correct ones to use here.

Reviewed-by: Aradhya Bhatia <aradhya.bhatia@linux.dev>
Tested-by: Parth Pancholi <parth.pancholi@toradex.com>
Tested-by: Jayesh Choudhary <j-choudhary@ti.com>
Reviewed-by: Devarsh Thakkar <devarsht@ti.com>
Link: https://lore.kernel.org/r/20250723-cdns-dsi-impro-v5-3-e61cc06074c2@ideasonboard.com
Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/tidss/tidss_crtc.c  |  2 +-
 drivers/gpu/drm/tidss/tidss_dispc.c | 16 ++++++++--------
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/gpu/drm/tidss/tidss_crtc.c b/drivers/gpu/drm/tidss/tidss_crtc.c
index 26fd2761e80db..d39c865e126bd 100644
--- a/drivers/gpu/drm/tidss/tidss_crtc.c
+++ b/drivers/gpu/drm/tidss/tidss_crtc.c
@@ -226,7 +226,7 @@ static void tidss_crtc_atomic_enable(struct drm_crtc *crtc,
 	tidss_runtime_get(tidss);
 
 	r = dispc_vp_set_clk_rate(tidss->dispc, tcrtc->hw_videoport,
-				  mode->clock * 1000);
+				  mode->crtc_clock * 1000);
 	if (r != 0)
 		return;
 
diff --git a/drivers/gpu/drm/tidss/tidss_dispc.c b/drivers/gpu/drm/tidss/tidss_dispc.c
index b1093dc1b79a2..14bf95d901ada 100644
--- a/drivers/gpu/drm/tidss/tidss_dispc.c
+++ b/drivers/gpu/drm/tidss/tidss_dispc.c
@@ -978,13 +978,13 @@ void dispc_vp_enable(struct dispc_device *dispc, u32 hw_videoport,
 
 	dispc_set_num_datalines(dispc, hw_videoport, fmt->data_width);
 
-	hfp = mode->hsync_start - mode->hdisplay;
-	hsw = mode->hsync_end - mode->hsync_start;
-	hbp = mode->htotal - mode->hsync_end;
+	hfp = mode->crtc_hsync_start - mode->crtc_hdisplay;
+	hsw = mode->crtc_hsync_end - mode->crtc_hsync_start;
+	hbp = mode->crtc_htotal - mode->crtc_hsync_end;
 
-	vfp = mode->vsync_start - mode->vdisplay;
-	vsw = mode->vsync_end - mode->vsync_start;
-	vbp = mode->vtotal - mode->vsync_end;
+	vfp = mode->crtc_vsync_start - mode->crtc_vdisplay;
+	vsw = mode->crtc_vsync_end - mode->crtc_vsync_start;
+	vbp = mode->crtc_vtotal - mode->crtc_vsync_end;
 
 	dispc_vp_write(dispc, hw_videoport, DISPC_VP_TIMING_H,
 		       FLD_VAL(hsw - 1, 7, 0) |
@@ -1026,8 +1026,8 @@ void dispc_vp_enable(struct dispc_device *dispc, u32 hw_videoport,
 		       FLD_VAL(ivs, 12, 12));
 
 	dispc_vp_write(dispc, hw_videoport, DISPC_VP_SIZE_SCREEN,
-		       FLD_VAL(mode->hdisplay - 1, 11, 0) |
-		       FLD_VAL(mode->vdisplay - 1, 27, 16));
+		       FLD_VAL(mode->crtc_hdisplay - 1, 11, 0) |
+		       FLD_VAL(mode->crtc_vdisplay - 1, 27, 16));
 
 	VP_REG_FLD_MOD(dispc, hw_videoport, DISPC_VP_CONTROL, 1, 0, 0);
 }
-- 
2.51.0



