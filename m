Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFA3C2AE7F;
	Tue, 26 Aug 2025 14:21:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756218119; cv=none; b=nk2zLGl58kYDSpRapKjC0wiT/41gobXV8syhmWsd95Tb/AbcFbTIbFgz0AJn+EWcL/FXjMVCo2Een3rxSPpovFqgzvVTbungQ4/Ksx8N3u9CfzczoaIulZ7RFTQ4j6EgtQjSWNGNaU+VIPbscklZ43On7oaDLmCUkYdQWPe/fZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756218119; c=relaxed/simple;
	bh=IQifRH4exKKgPcN/xqLTEwxKeE1yPFNyubLLLDKSm40=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lL9mlY1aVurq6bWWJwy+/ewDHQoUMa9m3r5m6xm33HxQfNO5J6d3ZeTruEGrgnMqHZeNI8pIj7UQOgak7dS1SrvUs0Kka1Qww0g7TrniqLJi/HB59VUCRfJD8cN9oggNkj60LRiIhmZhziTs4n12pjW2zurOYwceZEohgcGMrTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q1miksv9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q1miksv9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53604C116B1;
	Tue, 26 Aug 2025 14:21:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756218119;
	bh=IQifRH4exKKgPcN/xqLTEwxKeE1yPFNyubLLLDKSm40=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q1miksv9VdD1/xsenCQ6sH4TluChhR+JUUpVrJfPAfG7Abk92h1XCbanIV+D7DW2B
	 2r8RdPB5TP1UX3vXPSYT87gRrVvUI0sio+fSPTmq2xq0lIdTZ6dvxAhRycmnXU5int
	 PElqkXD06i5ydPlmJcoFXs5WE53kgcjna4OLK9uw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Rodrigo Siqueira <siqueira@igalia.com>,
	Alex Hung <alex.hung@amd.com>
Subject: [PATCH 5.10 399/523] drm/amd/display: Fill display clock and vblank time in dce110_fill_display_configs
Date: Tue, 26 Aug 2025 13:10:09 +0200
Message-ID: <20250826110934.302606723@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Timur Kristóf <timur.kristof@gmail.com>

commit 7d07140d37f792f01cfdb8ca9a6a792ab1d29126 upstream.

Also needed by DCE 6.
This way the code that gathers this info can be shared between
different DCE versions and doesn't have to be repeated.

Signed-off-by: Timur Kristóf <timur.kristof@gmail.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Rodrigo Siqueira <siqueira@igalia.com>
Reviewed-by: Alex Hung <alex.hung@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 8107432dff37db26fcb641b6cebeae8981cd73a0)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/clk_mgr/dce100/dce_clk_mgr.c    |    2 --
 drivers/gpu/drm/amd/display/dc/clk_mgr/dce110/dce110_clk_mgr.c |   10 +++-------
 drivers/gpu/drm/amd/display/dc/clk_mgr/dce60/dce60_clk_mgr.c   |    2 --
 3 files changed, 3 insertions(+), 11 deletions(-)

--- a/drivers/gpu/drm/amd/display/dc/clk_mgr/dce100/dce_clk_mgr.c
+++ b/drivers/gpu/drm/amd/display/dc/clk_mgr/dce100/dce_clk_mgr.c
@@ -384,8 +384,6 @@ static void dce_pplib_apply_display_requ
 {
 	struct dm_pp_display_configuration *pp_display_cfg = &context->pp_display_cfg;
 
-	pp_display_cfg->avail_mclk_switch_time_us = dce110_get_min_vblank_time_us(context);
-
 	dce110_fill_display_configs(context, pp_display_cfg);
 
 	if (memcmp(&dc->current_state->pp_display_cfg, pp_display_cfg, sizeof(*pp_display_cfg)) !=  0)
--- a/drivers/gpu/drm/amd/display/dc/clk_mgr/dce110/dce110_clk_mgr.c
+++ b/drivers/gpu/drm/amd/display/dc/clk_mgr/dce110/dce110_clk_mgr.c
@@ -124,6 +124,9 @@ void dce110_fill_display_configs(
 	int j;
 	int num_cfgs = 0;
 
+	pp_display_cfg->avail_mclk_switch_time_us = dce110_get_min_vblank_time_us(context);
+	pp_display_cfg->disp_clk_khz = dc->clk_mgr->clks.dispclk_khz;
+	pp_display_cfg->avail_mclk_switch_time_in_disp_active_us = 0;
 	pp_display_cfg->crtc_index = dc->res_pool->res_cap->num_timing_generator;
 
 	for (j = 0; j < context->stream_count; j++) {
@@ -242,13 +245,6 @@ void dce11_pplib_apply_display_requireme
 	pp_display_cfg->min_engine_clock_deep_sleep_khz
 			= context->bw_ctx.bw.dce.sclk_deep_sleep_khz;
 
-	pp_display_cfg->avail_mclk_switch_time_us =
-						dce110_get_min_vblank_time_us(context);
-	/* TODO: dce11.2*/
-	pp_display_cfg->avail_mclk_switch_time_in_disp_active_us = 0;
-
-	pp_display_cfg->disp_clk_khz = dc->clk_mgr->clks.dispclk_khz;
-
 	dce110_fill_display_configs(context, pp_display_cfg);
 
 	if (memcmp(&dc->current_state->pp_display_cfg, pp_display_cfg, sizeof(*pp_display_cfg)) !=  0)
--- a/drivers/gpu/drm/amd/display/dc/clk_mgr/dce60/dce60_clk_mgr.c
+++ b/drivers/gpu/drm/amd/display/dc/clk_mgr/dce60/dce60_clk_mgr.c
@@ -100,8 +100,6 @@ static void dce60_pplib_apply_display_re
 {
 	struct dm_pp_display_configuration *pp_display_cfg = &context->pp_display_cfg;
 
-	pp_display_cfg->avail_mclk_switch_time_us = dce110_get_min_vblank_time_us(context);
-
 	dce110_fill_display_configs(context, pp_display_cfg);
 
 	if (memcmp(&dc->current_state->pp_display_cfg, pp_display_cfg, sizeof(*pp_display_cfg)) !=  0)


