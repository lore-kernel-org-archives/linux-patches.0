Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D01FD29D28A;
	Tue, 26 Aug 2025 13:32:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756215146; cv=none; b=sgKecFQT6/eKj+NXapGaXPHTenX5WppEkdkR3a6F1KwbPXZpYDE+TIWW8NUCEPnA8MUJeLdROQ1AqMDPCMZg/X5QdrNGJd9I03XG6WNakLSR3hcTxVyq7W4wmle5sMglHE/cqHl5+TZ1EVO5i8e+VXrBrPNwnpkpUH16kS7cmNw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756215146; c=relaxed/simple;
	bh=iaDzzE/VxwcwhctXqP5aVU/tSZFmurlxKB9lWiwTwLI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GBU6gP/ACiv0YcvfMf4QB4pL+YsZBJD8i/VICBrA7GV9lAFxwqyQl1BmJbzJq7fY2YEHMYASWzUywwM6x4aTU7O4Es6xCPG3a4Om7H2moSk7sjTGlFQytX/PF/R63XykCfQJIKFY7EbYwF9xez+ZRxQ+Pee17a8Ya+DjGp0AZas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FcimXxyL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FcimXxyL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62B14C4CEF1;
	Tue, 26 Aug 2025 13:32:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756215146;
	bh=iaDzzE/VxwcwhctXqP5aVU/tSZFmurlxKB9lWiwTwLI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FcimXxyL+GTRl/vvKn14zxWr6MWJzVhERqgntNpVhX0gftke+xl7tf3vbuo0FXRoH
	 AUNDBhy1cENLRYJkw+0fCVd5YuGjrcf5VZH+kQ8uGOBrCaTi8o3eIJsD5JLhXKWUUP
	 5T1Mh0PTnDPUeFErbxaGAePBB3pyrSzzAT9D9FwU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Rodrigo Siqueira <siqueira@igalia.com>,
	Alex Hung <alex.hung@amd.com>
Subject: [PATCH 6.1 404/482] drm/amd/display: Fill display clock and vblank time in dce110_fill_display_configs
Date: Tue, 26 Aug 2025 13:10:57 +0200
Message-ID: <20250826110940.810529929@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110930.769259449@linuxfoundation.org>
References: <20250826110930.769259449@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -386,8 +386,6 @@ static void dce_pplib_apply_display_requ
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
@@ -243,13 +246,6 @@ void dce11_pplib_apply_display_requireme
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


