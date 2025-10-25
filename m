Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5AF4303A19;
	Sat, 25 Oct 2025 16:14:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761408864; cv=none; b=dIkin1WBUIkAzxJ7hSPXcR8j3lNk0ZdOBqYMh0cqX9spKypsFIVQ774/nk9H0gruZZlEew5JmTFHJjREzvWZdXXu71PMWdk0bSJLW+m+neY+Gh3jZ1up9zt9IVJ+F9OYAwnEcggilu6vVSE01V8bKFlYl95cUA9qefo4jAtXRwU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761408864; c=relaxed/simple;
	bh=kOFMVpsowR/kCArB+y6FMOU5wv5DG3tr/rjZFwI4TQY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rX9pelRwrgdW7SUYz6YDl2EaWPW9EqM2V7ui2N1mUG1paYWvbMcxBs6LkLFxonaGGC0CHMviYzd4tlaE6oTuyINxask/E0qx/dZFMFdrbuaBsDVnpIWhx9prSuCY3rOzBrMyIImdYzoo+B0zL3Dttz9ww8rtwy80jNrh7G2Nhzk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rwXgh3yx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rwXgh3yx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82C8EC4CEF5;
	Sat, 25 Oct 2025 16:14:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761408864;
	bh=kOFMVpsowR/kCArB+y6FMOU5wv5DG3tr/rjZFwI4TQY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rwXgh3yxoh6w1GcAI8govkbs6YkpuqjjDf+mPhEfonxvABbbgZqAsGVyDiYkF2DNR
	 vtSptgSVbHBBWjhPyUp9B9xCK+YF8Vp97bmKerzh+qwCdMwT4b8/RXsEUmUCu+JfMB
	 MPwUeYHq8u03UPNu7yticBZdvHaJAsbiSd9q8dosQgUgDtW6+tZwqaWlD8B1vGImuN
	 1lavDxTqd8CFJwnpf5/zYoor/huEhvTfCmynvPfaZs5plZMCqd+DSVGJV33CmLjECz
	 1l9JfuADMlgvcDxpjav/p7+GTtXeWKfYYYcIkEA5yDZyvHGCZc7P2TtiQmfAfRDL0x
	 91ume5lnkELcA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Paul Hsieh <Paul.Hsieh@amd.com>,
	Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
	Roman Li <roman.li@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	alexandre.f.demers@gmail.com,
	alex.hung@amd.com,
	zhao.xichao@vivo.com
Subject: [PATCH AUTOSEL 6.17-6.6] drm/amd/display: update dpp/disp clock from smu clock table
Date: Sat, 25 Oct 2025 11:55:37 -0400
Message-ID: <20251025160905.3857885-106-sashal@kernel.org>
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

From: Paul Hsieh <Paul.Hsieh@amd.com>

[ Upstream commit 2e72fdba8a32ce062a86571edff4592710c26215 ]

[Why]
The reason some high-resolution monitors fail to display properly
is that this platform does not support sufficiently high DPP and
DISP clock frequencies

[How]
Update DISP and DPP clocks from the smu clock table then DML can
filter these mode if not support.

Reviewed-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Signed-off-by: Paul Hsieh <Paul.Hsieh@amd.com>
Signed-off-by: Roman Li <roman.li@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES

Reasoning and evidence
- User-visible bug fixed: The commit addresses blank/failing display on
  some high-resolution monitors by ensuring display mode validation uses
  the platform’s real DISP/DPP clock limits from SMU, preventing modes
  that hardware cannot drive. This is a correctness fix, not a feature.
- Scope and size: Changes are small and contained to DCN301 paths in two
  files, without architectural refactors.
- Precedent and consistency: Newer ASICs already follow this pattern:
  - DCN35:
    `drivers/gpu/drm/amd/display/dc/clk_mgr/dcn35/dcn35_clk_mgr.c:898`
    and `dcn35_fpu.c:235` collect max `dispclk/dppclk` from SMU and
    propagate to DML.
  - DCN351: `drivers/gpu/drm/amd/display/dc/dml/dcn351/dcn351_fpu.c:269`
    uses the same prepass and voltage-independent max logic.
  - DCN30/DCN321 similarly precompute max `dispclk/dppclk` and use them
    for the bounding box.
  This change brings DCN301 in line with those implementations, reducing
risk.

What the patch changes
- Populate bw_params with DISP/DPP clocks from SMU:
  - In `drivers/gpu/drm/amd/display/dc/clk_mgr/dcn301/vg_clk_mgr.c:559`
    (function `vg_clk_mgr_helper_populate_bw_params`), the patch:
    - Computes `max_dispclk`/`max_dppclk` using SMU’s
      `DispClocks`/`DppClocks` and `NumDispClkLevelsEnabled`.
    - Writes these maxima into
      `bw_params->clk_table.entries[i].dispclk_mhz` and `.dppclk_mhz`
      for all entries (voltage-independent), ensuring the clock table
      carries real hardware limits.
  - Current tree shows the function only populates
    `dcfclk/fclk/memclk/voltage` and omits `dispclk/dppclk`, so DML
    falls back to static SoC table values and may overestimate
    capabilities.
- Use these clocks for DML bounding box:
  - In `drivers/gpu/drm/amd/display/dc/dml/dcn301/dcn301_fpu.c:323`
    (function `dcn301_fpu_update_bw_bounding_box`), the patch:
    - Prepasses `clk_table->entries[]` to find max
      `dispclk_mhz/dppclk_mhz`.
    - Sets `s[i].dispclk_mhz` and `s[i].dppclk_mhz` to these maxima for
      all voltage states (treated as voltage-independent), with fallback
      to existing `dcn3_01_soc.clock_limits[closest_clk_lvl]` if the
      maxima are zero.
  - Currently, `s[i].dispclk_mhz/dppclk_mhz` are always taken from the
    static SoC table, ignoring SMU-provided constraints.
- Why this matters: DML consumes
  `soc->clock_limits[VoltageLevel].dispclk_mhz/dppclk_mhz` to gate mode
  support (see
  `drivers/gpu/drm/amd/display/dc/dml/display_mode_vba.c:1098` and
  `.1112`), so bounding these by real SMU limits prevents selecting
  unsupported display modes.

Safety and dependencies
- No new interfaces; uses existing SMU table fields already defined for
  DCN301:
  - `drivers/gpu/drm/amd/display/dc/clk_mgr/dcn301/dcn301_smu.h:98`
    defines `vg_dpm_clocks` with `DispClocks`, `DppClocks`, and
    `NumDispClkLevelsEnabled`.
- Helper exists: `find_max_clk_value` already present via earlier commit
  “Update clock table to include highest clock setting” (commit
  2d99a7ec25cf4).
- Robustness: If SMU entries are zero or not populated, the maxima
  become zero. The FPU change explicitly falls back to the SoC defaults
  per level when maxima are zero, preserving current behavior and
  avoiding regressions.
- Minimal risk of regression: The change only tightens clocks to SMU-
  reported capabilities for DCN301; mode filtering will become stricter
  only where hardware can’t meet the clocks, which is desired to prevent
  blank/unstable displays. Other clocks and watermark logic are
  untouched.

Stable backport criteria
- Important bugfix: Prevents display failures on affected high-
  resolution monitors by aligning clock validation with hardware limits.
- Low risk and localized: Touches DCN301 clock manager and FPU bounding
  box only; no architectural changes; has clear fallback behavior.
- Aligns with existing approach on later ASICs, reducing divergence and
  improving maintainability.

Conclusion
- Backport status: YES. This is a targeted, low-risk bugfix that aligns
  DCN301 behavior with other ASICs and addresses real user-visible
  failures, with safe fallbacks when SMU data is missing.

 .../display/dc/clk_mgr/dcn301/vg_clk_mgr.c    | 16 +++++++++++++++
 .../amd/display/dc/dml/dcn301/dcn301_fpu.c    | 20 ++++++++++++++++---
 2 files changed, 33 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn301/vg_clk_mgr.c b/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn301/vg_clk_mgr.c
index 9e2ef0e724fcf..7aee02d562923 100644
--- a/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn301/vg_clk_mgr.c
+++ b/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn301/vg_clk_mgr.c
@@ -563,6 +563,7 @@ static void vg_clk_mgr_helper_populate_bw_params(
 {
 	int i, j;
 	struct clk_bw_params *bw_params = clk_mgr->base.bw_params;
+	uint32_t max_dispclk = 0, max_dppclk = 0;
 
 	j = -1;
 
@@ -584,6 +585,15 @@ static void vg_clk_mgr_helper_populate_bw_params(
 		return;
 	}
 
+	/* dispclk and dppclk can be max at any voltage, same number of levels for both */
+	if (clock_table->NumDispClkLevelsEnabled <= VG_NUM_DISPCLK_DPM_LEVELS &&
+	    clock_table->NumDispClkLevelsEnabled <= VG_NUM_DPPCLK_DPM_LEVELS) {
+		max_dispclk = find_max_clk_value(clock_table->DispClocks, clock_table->NumDispClkLevelsEnabled);
+		max_dppclk = find_max_clk_value(clock_table->DppClocks, clock_table->NumDispClkLevelsEnabled);
+	} else {
+		ASSERT(0);
+	}
+
 	bw_params->clk_table.num_entries = j + 1;
 
 	for (i = 0; i < bw_params->clk_table.num_entries - 1; i++, j--) {
@@ -591,11 +601,17 @@ static void vg_clk_mgr_helper_populate_bw_params(
 		bw_params->clk_table.entries[i].memclk_mhz = clock_table->DfPstateTable[j].memclk;
 		bw_params->clk_table.entries[i].voltage = clock_table->DfPstateTable[j].voltage;
 		bw_params->clk_table.entries[i].dcfclk_mhz = find_dcfclk_for_voltage(clock_table, clock_table->DfPstateTable[j].voltage);
+
+		/* Now update clocks we do read */
+		bw_params->clk_table.entries[i].dispclk_mhz = max_dispclk;
+		bw_params->clk_table.entries[i].dppclk_mhz = max_dppclk;
 	}
 	bw_params->clk_table.entries[i].fclk_mhz = clock_table->DfPstateTable[j].fclk;
 	bw_params->clk_table.entries[i].memclk_mhz = clock_table->DfPstateTable[j].memclk;
 	bw_params->clk_table.entries[i].voltage = clock_table->DfPstateTable[j].voltage;
 	bw_params->clk_table.entries[i].dcfclk_mhz = find_max_clk_value(clock_table->DcfClocks, VG_NUM_DCFCLK_DPM_LEVELS);
+	bw_params->clk_table.entries[i].dispclk_mhz = find_max_clk_value(clock_table->DispClocks, VG_NUM_DISPCLK_DPM_LEVELS);
+	bw_params->clk_table.entries[i].dppclk_mhz = find_max_clk_value(clock_table->DppClocks, VG_NUM_DPPCLK_DPM_LEVELS);
 
 	bw_params->vram_type = bios_info->memory_type;
 	bw_params->num_channels = bios_info->ma_channel_number;
diff --git a/drivers/gpu/drm/amd/display/dc/dml/dcn301/dcn301_fpu.c b/drivers/gpu/drm/amd/display/dc/dml/dcn301/dcn301_fpu.c
index 0c0b2d67c9cd9..2066a65c69bbc 100644
--- a/drivers/gpu/drm/amd/display/dc/dml/dcn301/dcn301_fpu.c
+++ b/drivers/gpu/drm/amd/display/dc/dml/dcn301/dcn301_fpu.c
@@ -326,7 +326,7 @@ void dcn301_fpu_update_bw_bounding_box(struct dc *dc, struct clk_bw_params *bw_p
 	struct dcn301_resource_pool *pool = TO_DCN301_RES_POOL(dc->res_pool);
 	struct clk_limit_table *clk_table = &bw_params->clk_table;
 	unsigned int i, closest_clk_lvl;
-	int j;
+	int j = 0, max_dispclk_mhz = 0, max_dppclk_mhz = 0;
 
 	dc_assert_fp_enabled();
 
@@ -338,6 +338,15 @@ void dcn301_fpu_update_bw_bounding_box(struct dc *dc, struct clk_bw_params *bw_p
 	dcn3_01_soc.num_chans = bw_params->num_channels;
 
 	ASSERT(clk_table->num_entries);
+
+	/* Prepass to find max clocks independent of voltage level. */
+	for (i = 0; i < clk_table->num_entries; ++i) {
+		if (clk_table->entries[i].dispclk_mhz > max_dispclk_mhz)
+			max_dispclk_mhz = clk_table->entries[i].dispclk_mhz;
+		if (clk_table->entries[i].dppclk_mhz > max_dppclk_mhz)
+			max_dppclk_mhz = clk_table->entries[i].dppclk_mhz;
+	}
+
 	for (i = 0; i < clk_table->num_entries; i++) {
 		/* loop backwards*/
 		for (closest_clk_lvl = 0, j = dcn3_01_soc.num_states - 1; j >= 0; j--) {
@@ -353,8 +362,13 @@ void dcn301_fpu_update_bw_bounding_box(struct dc *dc, struct clk_bw_params *bw_p
 		s[i].socclk_mhz = clk_table->entries[i].socclk_mhz;
 		s[i].dram_speed_mts = clk_table->entries[i].memclk_mhz * 2;
 
-		s[i].dispclk_mhz = dcn3_01_soc.clock_limits[closest_clk_lvl].dispclk_mhz;
-		s[i].dppclk_mhz = dcn3_01_soc.clock_limits[closest_clk_lvl].dppclk_mhz;
+		/* Clocks independent of voltage level. */
+		s[i].dispclk_mhz = max_dispclk_mhz ? max_dispclk_mhz :
+			dcn3_01_soc.clock_limits[closest_clk_lvl].dispclk_mhz;
+
+		s[i].dppclk_mhz = max_dppclk_mhz ? max_dppclk_mhz :
+			dcn3_01_soc.clock_limits[closest_clk_lvl].dppclk_mhz;
+
 		s[i].dram_bw_per_chan_gbps =
 			dcn3_01_soc.clock_limits[closest_clk_lvl].dram_bw_per_chan_gbps;
 		s[i].dscclk_mhz = dcn3_01_soc.clock_limits[closest_clk_lvl].dscclk_mhz;
-- 
2.51.0

