Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FC0630CD86;
	Sat, 25 Oct 2025 16:29:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761409785; cv=none; b=g90j3wkeeZIwaSJrA8lbmpwqVHAdAS9V74ipEMyYZd9EW7MifpBqmxfLN0glRlSU/FcgG++IOcXm3FqCSdZMn9PjjToK+OYmpomOrEnBZzQI83ONEfOCVlaAltpdpUHF9LJ3g2JGEg1/Tu0Qe0X4VGTqlPobP1jpLEmmn3/MafI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761409785; c=relaxed/simple;
	bh=UYLaXgxBZuixrGorznAnJsn1dLXnLo7841ii6Fv8oO4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=X9keUk2e0Aqxk1PNxZzWjAIf+fX1iHw+sYP47IyyneqVS471CvQYmoyOtJN2zO9JRuJR2ZMdbBj8VNnAQJGIejuqRSD2v25L4RnQPK8C+AqpfOVW3Hwr0X6wg9TqabWQ+kzgIyH0gpla21Ucz/7JhIfcmkDNYBBgp2xdxzxVVzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pqQ3e9fu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pqQ3e9fu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 342B8C4CEF5;
	Sat, 25 Oct 2025 16:29:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761409785;
	bh=UYLaXgxBZuixrGorznAnJsn1dLXnLo7841ii6Fv8oO4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pqQ3e9fuaMjT6aud62z1DhMbcXilTaXLQZuogGcUcmo9TEob1Uu31uOfVdB9RU5kp
	 8PSI/2UMzbw5fIBhAMM+pHqpY4ddt4YeSH495V2U0qL/NMDrlE2TgXW1V2esfD3rsO
	 Z/gBufgo7ey/8duGYcbJyQoOcne/o4un5pyaHFaa9pxpZ3QZg0f9b/4udKqN7p2X3/
	 krHvgRZTqeP6oTdBlvu1Nx+D3n8u0p9/LLtnQNmaXNDJzTBIxrZzz22Vk+j4LIJQ+L
	 859o8I9rHaeJz8y8LGQNORjf6iwRIbYmt7/8g+CSwYWtSaiOWPaSQP+0xJR9364LfT
	 IgFixCfZxShUQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Michael Strauss <michael.strauss@amd.com>,
	"Ovidiu (Ovi) Bunea" <ovidiu.bunea@amd.com>,
	Ivan Lipski <ivan.lipski@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	Charlene.Liu@amd.com,
	alex.hung@amd.com,
	aurabindo.pillai@amd.com,
	alvin.lee2@amd.com,
	Ausef.Yousof@amd.com,
	Ovidiu.Bunea@amd.com,
	alexandre.f.demers@gmail.com,
	srinivasan.shanmugam@amd.com,
	Martin.Leung@amd.com,
	danny.wang@amd.com,
	Dillon.Varone@amd.com,
	ray.wu@amd.com,
	mwen@igalia.com,
	rostrows@amd.com,
	chiahsuan.chung@amd.com,
	yihan.zhu@amd.com,
	karthi.kandasamy@amd.com,
	ryanseto@amd.com,
	peterson.guo@amd.com,
	wenjing.liu@amd.com,
	meenakshikumar.somasundaram@amd.com,
	Cruise.Hung@amd.com,
	PeiChen.Huang@amd.com,
	george.shen@amd.com,
	chris.park@amd.com
Subject: [PATCH AUTOSEL 6.17-6.12] drm/amd/display: Move setup_stream_attribute
Date: Sat, 25 Oct 2025 12:01:33 -0400
Message-ID: <20251025160905.3857885-462-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251025160905.3857885-1-sashal@kernel.org>
References: <20251025160905.3857885-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Michael Strauss <michael.strauss@amd.com>

[ Upstream commit 2681bf4ae8d24df950138b8c9ea9c271cd62e414 ]

[WHY]
If symclk RCO is enabled, stream encoder may not be receiving an ungated
clock by the time we attempt to set stream attributes when setting dpms
on. Since the clock is gated, register writes to the stream encoder fail.

[HOW]
Move set_stream_attribute call into enable_stream, just after the point
where symclk32_se is ungated.
Logically there is no need to set stream attributes as early as is
currently done in link_set_dpms_on, so this should have no impact beyond
the RCO fix.

Reviewed-by: Ovidiu (Ovi) Bunea <ovidiu.bunea@amd.com>
Signed-off-by: Michael Strauss <michael.strauss@amd.com>
Signed-off-by: Ivan Lipski <ivan.lipski@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES

- Problem addressed: On some AMD DCN platforms with root clock
  optimization (RCO) for symclk enabled, the stream encoder can still be
  clock-gated when DPMS is turned on. Programming stream attributes at
  that point silently fails because the encoder’s registers are not
  clocked.

- What changed
  - Moved programming of stream attributes from the DPMS-on path to the
    “enable stream” path after clocks are ungated:
    - Removed early call in
      `drivers/gpu/drm/amd/display/dc/link/link_dpms.c:2493` where
      `link_hwss->setup_stream_attribute(pipe_ctx);` is invoked before
      the encoder clocks are guaranteed to be ungated.
    - Added `link_hwss->setup_stream_attribute(pipe_ctx);` into the
      hardware-specific enable paths:
      - `drivers/gpu/drm/amd/display/dc/hwss/dce110/dce110_hwseq.c:661`
        (within `dce110_enable_stream`) before encoder setup.
      - `drivers/gpu/drm/amd/display/dc/hwss/dcn20/dcn20_hwseq.c:2969`
        (within `dcn20_enable_stream`) immediately after
        `dccg->funcs->enable_symclk32_se(...)` or
        `enable_symclk_se(...)` so the writes occur with an ungated
        clock.
      - `drivers/gpu/drm/amd/display/dc/hwss/dcn401/dcn401_hwseq.c:987`
        (within `dcn401_enable_stream`) likewise after the corresponding
        clock enable (`enable_symclk32_se`/`enable_symclk_se`).
  - Completed the virtual encoder vtable by adding a no-op LVDS
    attribute setter so that all attribute paths are consistently
    defined:
    - `drivers/gpu/drm/amd/display/dc/virtual/virtual_stream_encoder.c`
      adds `lvds_set_stream_attribute` and wires it into
      `virtual_str_enc_funcs`. This aligns with how
      `setup_dio_stream_attribute` routes LVDS to
      `stream_encoder->funcs->lvds_set_stream_attribute` (see
      `drivers/gpu/drm/amd/display/dc/link/hwss/link_hwss_dio.c:98`).

- Why this fixes the bug
  - In the old flow, `link_set_dpms_on` programmed attributes too early
    (before `dc->hwss.enable_stream` and before symclk ungating for
    DCN). If the encoder clock was gated due to RCO, attribute register
    writes were dropped.
  - The new flow defers `setup_stream_attribute` until
    `dcn20_enable_stream`/`dcn401_enable_stream` have called
    `dccg->funcs->enable_symclk32_se` (or `enable_symclk_se` for non-
    HPO), guaranteeing an ungated clock. For DCE110, placing it at the
    start of `dce110_enable_stream` ensures the attribute programming is
    still done during enable, not during DPMS-on.

- Ordering and side-effects
  - InfoFrames are still updated after attributes are set, consistent
    with prior behavior:
    - Before: attributes set in `link_dpms.c`, then
      `resource_build_info_frame` + `update_info_frame`, then later
      `dc->hwss.enable_stream`.
    - After: attributes set in `*_enable_stream`, and in those functions
      `dc->hwss.update_info_frame(pipe_ctx)` still occurs after
      attribute programming (e.g., `dcn20_hwseq.c:2969+`,
      `dcn401_hwseq.c:987+`, `dce110_hwseq.c:661+`), preserving logical
      order.
  - Pixel-rate divider setup remains the same or occurs adjacent; moving
    attributes just past clock ungating makes register programming
    reliable without altering the broader sequence (e.g.,
    `dcn20_hwseq.c` sets DTO/clock, then attributes, then pixel rate
    div, then stream encoder setup).
  - Seamless boot/eDP fast boot paths in `link_set_dpms_on` still early-
    return before `dc->hwss.enable_stream(pipe_ctx)`. Previously, those
    paths benefitted from early attribute programming in `link_dpms.c`;
    this change stops reprogramming attributes on those fast/avoid-
    flicker paths. That matches the intent of “seamless” (avoid re-
    touching the running stream), and InfoFrames are still
    rebuilt/updated before those returns. AMD’s rationale states “no
    impact beyond the RCO fix,” which is consistent with seamless/fast-
    boot flows not re-writing SE attributes while avoiding re-enables.

- Scope and risk assessment
  - Bug fix, no new features; localized to AMD DC link/hw sequence code
    paths and the virtual encoder stub.
  - No architectural changes; only call-site reordering and one no-op
    stub addition.
  - Interactions with other subsystems are minimal; the change is
    contained to display bring-up order.
  - Security impact: none (timing/order-of-programming fix).
  - Regression risk: low. The programming window was only moved to a
    safer point (after clock ungating). Virtual encoder LVDS stub
    eliminates any possibility of null callbacks where LVDS is
    referenced.

- Stable backport criteria
  - Fixes a real, user-visible issue (attribute programming failing
    under symclk RCO gating → potential blank/corruption or wrong video
    parameters).
  - Small, self-contained change with clear rationale and tested-
    by/reviewed-by tags.
  - No API/ABI churn; fits stable rules.

Conclusion: Backporting is advisable to affected stable trees so stream
attribute programming reliably occurs with an ungated encoder clock.

 drivers/gpu/drm/amd/display/dc/hwss/dce110/dce110_hwseq.c  | 1 +
 drivers/gpu/drm/amd/display/dc/hwss/dcn20/dcn20_hwseq.c    | 2 ++
 drivers/gpu/drm/amd/display/dc/hwss/dcn401/dcn401_hwseq.c  | 2 ++
 drivers/gpu/drm/amd/display/dc/link/link_dpms.c            | 3 ---
 .../drm/amd/display/dc/virtual/virtual_stream_encoder.c    | 7 +++++++
 5 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/hwss/dce110/dce110_hwseq.c b/drivers/gpu/drm/amd/display/dc/hwss/dce110/dce110_hwseq.c
index c69194e04ff93..32fd6bdc18d73 100644
--- a/drivers/gpu/drm/amd/display/dc/hwss/dce110/dce110_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/hwss/dce110/dce110_hwseq.c
@@ -671,6 +671,7 @@ void dce110_enable_stream(struct pipe_ctx *pipe_ctx)
 	uint32_t early_control = 0;
 	struct timing_generator *tg = pipe_ctx->stream_res.tg;
 
+	link_hwss->setup_stream_attribute(pipe_ctx);
 	link_hwss->setup_stream_encoder(pipe_ctx);
 
 	dc->hwss.update_info_frame(pipe_ctx);
diff --git a/drivers/gpu/drm/amd/display/dc/hwss/dcn20/dcn20_hwseq.c b/drivers/gpu/drm/amd/display/dc/hwss/dcn20/dcn20_hwseq.c
index 5e57bd1a08e73..9d3946065620a 100644
--- a/drivers/gpu/drm/amd/display/dc/hwss/dcn20/dcn20_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/hwss/dcn20/dcn20_hwseq.c
@@ -3052,6 +3052,8 @@ void dcn20_enable_stream(struct pipe_ctx *pipe_ctx)
 						      link_enc->transmitter - TRANSMITTER_UNIPHY_A);
 	}
 
+	link_hwss->setup_stream_attribute(pipe_ctx);
+
 	if (dc->res_pool->dccg->funcs->set_pixel_rate_div)
 		dc->res_pool->dccg->funcs->set_pixel_rate_div(
 			dc->res_pool->dccg,
diff --git a/drivers/gpu/drm/amd/display/dc/hwss/dcn401/dcn401_hwseq.c b/drivers/gpu/drm/amd/display/dc/hwss/dcn401/dcn401_hwseq.c
index 61167c19359d5..e86bb4fb9e952 100644
--- a/drivers/gpu/drm/amd/display/dc/hwss/dcn401/dcn401_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/hwss/dcn401/dcn401_hwseq.c
@@ -965,6 +965,8 @@ void dcn401_enable_stream(struct pipe_ctx *pipe_ctx)
 		}
 	}
 
+	link_hwss->setup_stream_attribute(pipe_ctx);
+
 	if (dc->res_pool->dccg->funcs->set_pixel_rate_div) {
 		dc->res_pool->dccg->funcs->set_pixel_rate_div(
 			dc->res_pool->dccg,
diff --git a/drivers/gpu/drm/amd/display/dc/link/link_dpms.c b/drivers/gpu/drm/amd/display/dc/link/link_dpms.c
index 8c8682f743d6f..cb80b45999360 100644
--- a/drivers/gpu/drm/amd/display/dc/link/link_dpms.c
+++ b/drivers/gpu/drm/amd/display/dc/link/link_dpms.c
@@ -2458,7 +2458,6 @@ void link_set_dpms_on(
 	struct link_encoder *link_enc = pipe_ctx->link_res.dio_link_enc;
 	enum otg_out_mux_dest otg_out_dest = OUT_MUX_DIO;
 	struct vpg *vpg = pipe_ctx->stream_res.stream_enc->vpg;
-	const struct link_hwss *link_hwss = get_link_hwss(link, &pipe_ctx->link_res);
 	bool apply_edp_fast_boot_optimization =
 		pipe_ctx->stream->apply_edp_fast_boot_optimization;
 
@@ -2502,8 +2501,6 @@ void link_set_dpms_on(
 		pipe_ctx->stream_res.tg->funcs->set_out_mux(pipe_ctx->stream_res.tg, otg_out_dest);
 	}
 
-	link_hwss->setup_stream_attribute(pipe_ctx);
-
 	pipe_ctx->stream->apply_edp_fast_boot_optimization = false;
 
 	// Enable VPG before building infoframe
diff --git a/drivers/gpu/drm/amd/display/dc/virtual/virtual_stream_encoder.c b/drivers/gpu/drm/amd/display/dc/virtual/virtual_stream_encoder.c
index ad088d70e1893..6ffc74fc9dcd8 100644
--- a/drivers/gpu/drm/amd/display/dc/virtual/virtual_stream_encoder.c
+++ b/drivers/gpu/drm/amd/display/dc/virtual/virtual_stream_encoder.c
@@ -44,6 +44,11 @@ static void virtual_stream_encoder_dvi_set_stream_attribute(
 	struct dc_crtc_timing *crtc_timing,
 	bool is_dual_link) {}
 
+static void virtual_stream_encoder_lvds_set_stream_attribute(
+	struct stream_encoder *enc,
+	struct dc_crtc_timing *crtc_timing)
+{}
+
 static void virtual_stream_encoder_set_throttled_vcp_size(
 	struct stream_encoder *enc,
 	struct fixed31_32 avg_time_slots_per_mtp)
@@ -115,6 +120,8 @@ static const struct stream_encoder_funcs virtual_str_enc_funcs = {
 		virtual_stream_encoder_hdmi_set_stream_attribute,
 	.dvi_set_stream_attribute =
 		virtual_stream_encoder_dvi_set_stream_attribute,
+	.lvds_set_stream_attribute =
+		virtual_stream_encoder_lvds_set_stream_attribute,
 	.set_throttled_vcp_size =
 		virtual_stream_encoder_set_throttled_vcp_size,
 	.update_hdmi_info_packets =
-- 
2.51.0

