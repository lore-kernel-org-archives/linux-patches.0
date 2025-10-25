Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F8A5303A17;
	Sat, 25 Oct 2025 16:09:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761408587; cv=none; b=NBCqcsZ1tIYSjtDFJv+XS5YRiIpxcOTbw6zwp7lX/iLife1fmmZUmQML/I1zg90iOQ4CYI2+NeyLX5hZ2Amarl906jABZ2J2gfjFmsFv5oQ0wk+vlWcCxVH18KgUl7uVv+qABMZ3zX+BqTRf2XSFp/rnuPbUUdToOPuCrYcSPM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761408587; c=relaxed/simple;
	bh=8DHvMHb7qQS78oiCq8rz5nPCXhR/44nGz5pN15os4Ck=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=N87FXiQll+FGcbeJ5wr0AUcC3424dyZ9hsgpqnNOO9SJr3k7Cm4XbtjTq2eBxLWtrOMycmMk08fEWl3dk57wYjUJiwUHws0Sx85DIODxHKdpHiPFkHHVYpxIt5gkXAWa2y0Pe7rghx6RP5uWj35El8ffg8GRoQpA8UorGkXnAbQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Thx3n3GP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Thx3n3GP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16BF9C4CEF5;
	Sat, 25 Oct 2025 16:09:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761408587;
	bh=8DHvMHb7qQS78oiCq8rz5nPCXhR/44nGz5pN15os4Ck=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Thx3n3GPib2758Ueg0YwECPlDG5Zc0Kyg+6QLtnOfOXofj1/dL2oQKgdszT2fc2MY
	 llPVqKXeJMISt9Uc9HJQ29BW/CSJidL2WbHpQhURPh2eV0S87zq98IDXyj1lapDG3W
	 4aGOZFvxs4cQbivkOlwWFwfZ9F5ygf+HbaqSpW6skBIlvmhY9ve9vKAMr9WM6nkrRu
	 CPI//WOofE6BhX/iEFEvHvE1fqM6BOmJhxOPo58MP/NoLCN2xCtJzn1+PRZxLfznIA
	 HchhsALex1PaToEpBnZYe8OHevYXapzqWPBEu00ezF7kzZVwoEQWMoQ0hugsggEzpw
	 38NvfkDtwyk/A==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Yihan Zhu <Yihan.Zhu@amd.com>,
	Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
	Aurabindo Pillai <aurabindo.pillai@amd.com>,
	Dan Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	chiahsuan.chung@amd.com,
	Dillon.Varone@amd.com,
	alvin.lee2@amd.com,
	joshua.aberback@amd.com,
	Leo.Zeng@amd.com,
	Ilya.Bakoulin@amd.com,
	Iswara.Nagulendran@amd.com,
	quzicheng@huawei.com,
	alexandre.f.demers@gmail.com,
	wayne.lin@amd.com,
	haoping.liu@amd.com,
	Josip.Pavic@amd.com,
	christophe.jaillet@wanadoo.fr,
	Ausef.Yousof@amd.com
Subject: [PATCH AUTOSEL 6.17] drm/amd/display: wait for otg update pending latch before clock optimization
Date: Sat, 25 Oct 2025 11:54:04 -0400
Message-ID: <20251025160905.3857885-13-sashal@kernel.org>
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

From: Yihan Zhu <Yihan.Zhu@amd.com>

[ Upstream commit f382e2d0faad0e0d73f626dbd71f2a4fce03975b ]

[WHY & HOW]
OTG pending update unlatched will cause system fail, wait OTG fully disabled to
avoid this error.

Reviewed-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Signed-off-by: Yihan Zhu <Yihan.Zhu@amd.com>
Signed-off-by: Aurabindo Pillai <aurabindo.pillai@amd.com>
Tested-by: Dan Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES

- Fixes a real stability bug: The commit addresses a race where “OTG
  pending update unlatched” during clock optimization can cause a system
  failure. The fix ensures OTG is fully disabled/latches before
  proceeding, avoiding the failure.
- Integrates the wait at the right point in the sequence: After clearing
  ODM double-buffer pending, the update path now also waits for OTG to
  be fully disabled if the hardware supports it.
  - Added call in `hwss_wait_for_odm_update_pending_complete()` to
    `wait_otg_disable()` right after
    `wait_odm_doublebuffer_pending_clear()` so subsequent clock
    optimization/programming occurs only when OTG is fully disabled:
    drivers/gpu/drm/amd/display/dc/core/dc_hw_sequencer.c:1166,
    drivers/gpu/drm/amd/display/dc/core/dc_hw_sequencer.c:1178,
    drivers/gpu/drm/amd/display/dc/core/dc_hw_sequencer.c:1180
  - This function is part of the preamble that runs before full update
    programming (and when `optimized_required` is true), i.e. during
    “clock optimization” transitions:
    drivers/gpu/drm/amd/display/dc/core/dc_hw_sequencer.c:1255,
    drivers/gpu/drm/amd/display/dc/core/dc.c:4084
- Adds a targeted, optional TG callback (no broad API churn): A new
  `timing_generator_funcs` hook `wait_otg_disable` is introduced to
  allow per-generation implementation.
  - New function pointer added at the end of the struct to minimize
    initializer churn and safely default to NULL:
    drivers/gpu/drm/amd/display/dc/inc/hw/timing_generator.h:376
  - Call site is guarded by a NULL check, so platforms without an
    implementation are unaffected:
    drivers/gpu/drm/amd/display/dc/core/dc_hw_sequencer.c:1180
- Supplies a concrete DCN3.5 implementation and enforces a stronger
  disable wait:
  - During disable, explicitly wait for `OTG_CURRENT_MASTER_EN_STATE ==
    0` after disabling OTG and before proceeding, eliminating the latch
    race: drivers/gpu/drm/amd/display/dc/optc/dcn35/dcn35_optc.c:165
  - Adds `optc35_wait_otg_disable()` to check `OTG_MASTER_EN` and then
    wait for the hardware’s disabled state to latch:
    drivers/gpu/drm/amd/display/dc/optc/dcn35/dcn35_optc.c:433
  - Hooks the implementation into the TG function table for DCN3.5:
    drivers/gpu/drm/amd/display/dc/optc/dcn35/dcn35_optc.c:499
- Exposes the needed register field for newer gens via existing common
  macros: Adds `OTG_CURRENT_MASTER_EN_STATE` to the DCN3.2 mask/sh list
  so DCN3.5 (which includes DCN3.2 header) can use it:
  drivers/gpu/drm/amd/display/dc/optc/dcn32/dcn32_optc.h:65
- Scope is narrow and self-contained:
  - Only AMD display DC code touched (no UAPI, no cross-subsystem
    changes).
  - The new TG hook is optional; other gens remain unaffected unless
    they implement it.
  - The behavior change is strictly a bounded wait to ensure a safe
    hardware state.
- Minimal regression risk:
  - Waits are bounded (typical 100 ms cap) and only engaged when
    necessary.
  - The call path checks for hardware support (function pointer),
    limiting scope to DCN3.5 (which provides the implementation).
  - No architectural change; no new features; purely a
    synchronization/latching fix.
- Matches stable rules:
  - Fixes a real, user-visible failure (system fail during clock
    optimization).
  - Small, localized changes across 4 files; no interface or behavioral
    changes outside the AMD DC internals.
  - No side-effects beyond slight additional latency waiting for proper
    hardware state.
- Additional context that supports correctness:
  - Other generations already use the `OTG_CURRENT_MASTER_EN_STATE`
    latch semantics when disabling/enabling OTG, so aligning DCN3.5 to
    explicitly wait for this latch is consistent with established
    patterns.

Given the above, this change is a focused bugfix that reduces system
failure risk during display updates/clock optimization, has minimal
regression risk, and is confined to the AMD display driver. It should be
backported to stable.

 .../drm/amd/display/dc/core/dc_hw_sequencer.c  |  2 ++
 .../amd/display/dc/inc/hw/timing_generator.h   |  1 +
 .../drm/amd/display/dc/optc/dcn32/dcn32_optc.h |  1 +
 .../drm/amd/display/dc/optc/dcn35/dcn35_optc.c | 18 ++++++++++++++++++
 4 files changed, 22 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc_hw_sequencer.c b/drivers/gpu/drm/amd/display/dc/core/dc_hw_sequencer.c
index ec4e80e5b6eb2..d82b1cb467f4b 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc_hw_sequencer.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_hw_sequencer.c
@@ -1177,6 +1177,8 @@ void hwss_wait_for_odm_update_pending_complete(struct dc *dc, struct dc_state *c
 		tg = otg_master->stream_res.tg;
 		if (tg->funcs->wait_odm_doublebuffer_pending_clear)
 			tg->funcs->wait_odm_doublebuffer_pending_clear(tg);
+		if (tg->funcs->wait_otg_disable)
+			tg->funcs->wait_otg_disable(tg);
 	}
 
 	/* ODM update may require to reprogram blank pattern for each OPP */
diff --git a/drivers/gpu/drm/amd/display/dc/inc/hw/timing_generator.h b/drivers/gpu/drm/amd/display/dc/inc/hw/timing_generator.h
index 267ace4eef8a3..f2de2cf23859e 100644
--- a/drivers/gpu/drm/amd/display/dc/inc/hw/timing_generator.h
+++ b/drivers/gpu/drm/amd/display/dc/inc/hw/timing_generator.h
@@ -374,6 +374,7 @@ struct timing_generator_funcs {
 	void (*wait_drr_doublebuffer_pending_clear)(struct timing_generator *tg);
 	void (*set_long_vtotal)(struct timing_generator *optc, const struct long_vtotal_params *params);
 	void (*wait_odm_doublebuffer_pending_clear)(struct timing_generator *tg);
+	void (*wait_otg_disable)(struct timing_generator *optc);
 	bool (*get_optc_double_buffer_pending)(struct timing_generator *tg);
 	bool (*get_otg_double_buffer_pending)(struct timing_generator *tg);
 	bool (*get_pipe_update_pending)(struct timing_generator *tg);
diff --git a/drivers/gpu/drm/amd/display/dc/optc/dcn32/dcn32_optc.h b/drivers/gpu/drm/amd/display/dc/optc/dcn32/dcn32_optc.h
index d159e3ed3bb3c..ead92ad78a234 100644
--- a/drivers/gpu/drm/amd/display/dc/optc/dcn32/dcn32_optc.h
+++ b/drivers/gpu/drm/amd/display/dc/optc/dcn32/dcn32_optc.h
@@ -62,6 +62,7 @@
 	SF(OTG0_OTG_CONTROL, OTG_DISABLE_POINT_CNTL, mask_sh),\
 	SF(OTG0_OTG_CONTROL, OTG_FIELD_NUMBER_CNTL, mask_sh),\
 	SF(OTG0_OTG_CONTROL, OTG_OUT_MUX, mask_sh),\
+	SF(OTG0_OTG_CONTROL, OTG_CURRENT_MASTER_EN_STATE, mask_sh),\
 	SF(OTG0_OTG_STEREO_CONTROL, OTG_STEREO_EN, mask_sh),\
 	SF(OTG0_OTG_STEREO_CONTROL, OTG_STEREO_SYNC_OUTPUT_LINE_NUM, mask_sh),\
 	SF(OTG0_OTG_STEREO_CONTROL, OTG_STEREO_SYNC_OUTPUT_POLARITY, mask_sh),\
diff --git a/drivers/gpu/drm/amd/display/dc/optc/dcn35/dcn35_optc.c b/drivers/gpu/drm/amd/display/dc/optc/dcn35/dcn35_optc.c
index 72bff94cb57da..52d5ea98c86b1 100644
--- a/drivers/gpu/drm/amd/display/dc/optc/dcn35/dcn35_optc.c
+++ b/drivers/gpu/drm/amd/display/dc/optc/dcn35/dcn35_optc.c
@@ -162,6 +162,8 @@ static bool optc35_disable_crtc(struct timing_generator *optc)
 	REG_WAIT(OTG_CLOCK_CONTROL,
 			OTG_BUSY, 0,
 			1, 100000);
+	REG_WAIT(OTG_CONTROL, OTG_CURRENT_MASTER_EN_STATE, 0, 1, 100000);
+
 	optc1_clear_optc_underflow(optc);
 
 	return true;
@@ -428,6 +430,21 @@ static void optc35_set_long_vtotal(
 	}
 }
 
+static void optc35_wait_otg_disable(struct timing_generator *optc)
+{
+	struct optc *optc1;
+	uint32_t is_master_en;
+
+	if (!optc || !optc->ctx)
+		return;
+
+	optc1 = DCN10TG_FROM_TG(optc);
+
+	REG_GET(OTG_CONTROL, OTG_MASTER_EN, &is_master_en);
+	if (!is_master_en)
+		REG_WAIT(OTG_CLOCK_CONTROL, OTG_CURRENT_MASTER_EN_STATE, 0, 1, 100000);
+}
+
 static const struct timing_generator_funcs dcn35_tg_funcs = {
 		.validate_timing = optc1_validate_timing,
 		.program_timing = optc1_program_timing,
@@ -479,6 +496,7 @@ static const struct timing_generator_funcs dcn35_tg_funcs = {
 		.set_odm_bypass = optc32_set_odm_bypass,
 		.set_odm_combine = optc35_set_odm_combine,
 		.get_optc_source = optc2_get_optc_source,
+		.wait_otg_disable = optc35_wait_otg_disable,
 		.set_h_timing_div_manual_mode = optc32_set_h_timing_div_manual_mode,
 		.set_out_mux = optc3_set_out_mux,
 		.set_drr_trigger_window = optc3_set_drr_trigger_window,
-- 
2.51.0

