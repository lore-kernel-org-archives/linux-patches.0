Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A646D3EBF2C;
	Sat, 14 Feb 2026 01:03:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771031027; cv=none; b=JfMaAAOP1KT51UtGqxugJe7jqohbIkZ0/QaA6NhEhTOBxmuXwl2QBFu6EcfAZBcueGGbKcXobAE/89hEOSg0dVkd/7A0Ea0RgwvokA8E793oS23U8UL0zrrkF4bJ99/rImzwT1dTGXAMxcHGfZnBH3kKSMkQFx5sxBdvv904STU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771031027; c=relaxed/simple;
	bh=yMAj4Q6U7bOmCP9tvreLiK2cUyGHvdwR0dAJ/lbFHj4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iWhE9Tc14YQARodPcjQ0PH5gV07sXwph2IyJ4YvXCTdn6fUnJz227WmMVqwppTGCfe3G4V+6FFis+3PH2JBrgGjS2bws9n9BHB16ZPlo9EQnDIswdhfhG0pwnorxlJVqkpanP1LSE4o21hGyA+tYBuhaX+MZkkdbKt86kb1XfCk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=i+PYajGc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="i+PYajGc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4659C116C6;
	Sat, 14 Feb 2026 01:03:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771031027;
	bh=yMAj4Q6U7bOmCP9tvreLiK2cUyGHvdwR0dAJ/lbFHj4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i+PYajGcCimHhIGrS2MKuo2FDczgbLoCscmKXrAJHV1sR71AKHjN+j99NeYNhYOno
	 I31F8fatNvVWq6jqAvnS85MSsri2dk/RoL0e0YhVxBvLHI1cFRvSCKlfnRc34fIILl
	 xIVEeKmsKPC8xTUb9H0BKbozmmv/rSl0VScPeeqB4MD/kKJazdpTm3AxqX73MNfVg4
	 gL/iQ4Lt9wvn8HHlbMpIS3Rn/gLX+HfzSRlSPfRHFNPJ0GJVEq6q1gdJzVHypgNNwu
	 2+ZeA6oKwvRhyJ5j/gKPQ/TB8XV2e7XwsYV0Z6uJS0euc/OdfqgvkG80BMrVoYpxLk
	 sjQzWF8VnE+Sg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: "Wang, Sung-huai" <Danny.Wang@amd.com>,
	Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
	Matthew Stewart <matthew.stewart2@amd.com>,
	Dan Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	Charlene.Liu@amd.com,
	neil.armstrong@linaro.org,
	Jing.Zhou@amd.com,
	Zhongwei.Zhang@amd.com,
	Wesley.Chalmers@amd.com,
	yelangyan@huaqin.corp-partner.google.com
Subject: [PATCH AUTOSEL 6.19-6.18] drm/amd/display: Revert "init dispclk from bootup clock for DCN315"
Date: Fri, 13 Feb 2026 19:58:28 -0500
Message-ID: <20260214010245.3671907-28-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260214010245.3671907-1-sashal@kernel.org>
References: <20260214010245.3671907-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19
Content-Transfer-Encoding: 8bit

From: "Wang, Sung-huai" <Danny.Wang@amd.com>

[ Upstream commit a625dc4989a2affb8f06e7b418bf30e1474b99c1 ]

[Why&How]
This reverts commit 14bb17cc37e0.
Due to the change, the display shows garbage on startup.

We have an alternative solution for the original issue:
d24203bb629f ("drm/amd/display: Re-check seamless boot can be enabled or not")

Reviewed-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Signed-off-by: Wang, Sung-huai <Danny.Wang@amd.com>
Signed-off-by: Matthew Stewart <matthew.stewart2@amd.com>
Tested-by: Dan Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Both the broken commit and the alternative fix are in v6.19. So for the
6.19.y stable tree:
- The broken commit IS there (causing display garbage)
- The alternative fix IS there (solving the original problem)
- This revert is needed to fix the regression

### Conclusion

This commit fixes a **display corruption regression** (garbage on
startup) for DCN315 AMD hardware. It's a clean revert of a commit that
exists in v6.19. For the 6.19.y stable tree, this revert is critical
because users with DCN315 hardware would see garbage on their display at
boot. The change is a straightforward revert, well-reviewed (Reviewed-
by, Tested-by), and restores known-good behavior.

The fix is important for the 6.19.y stable tree specifically. For older
stable trees (6.12.y, 6.6.y, etc.), the broken commit was never present,
so this revert isn't needed there.

Given that it fixes a clear, severe regression (display garbage on
startup) in v6.19, is properly reviewed and tested, and is a clean
revert with low risk, this should be backported to the 6.19.y stable
tree.

**YES**

 .../dc/clk_mgr/dcn315/dcn315_clk_mgr.c        | 90 +------------------
 .../dc/clk_mgr/dcn315/dcn315_clk_mgr.h        |  1 -
 2 files changed, 3 insertions(+), 88 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn315/dcn315_clk_mgr.c b/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn315/dcn315_clk_mgr.c
index 3a881451e9da4..c49268db85f68 100644
--- a/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn315/dcn315_clk_mgr.c
+++ b/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn315/dcn315_clk_mgr.c
@@ -40,7 +40,7 @@
 #include "dm_helpers.h"
 
 #include "dc_dmub_srv.h"
-#include "reg_helper.h"
+
 #include "logger_types.h"
 #undef DC_LOGGER
 #define DC_LOGGER \
@@ -48,43 +48,9 @@
 
 #include "link_service.h"
 
-#define MAX_INSTANCE                                        7
-#define MAX_SEGMENT                                         8
-
-struct IP_BASE_INSTANCE {
-	unsigned int segment[MAX_SEGMENT];
-};
-
-struct IP_BASE {
-	struct IP_BASE_INSTANCE instance[MAX_INSTANCE];
-};
-
-static const struct IP_BASE CLK_BASE = { { { { 0x00016C00, 0x02401800, 0, 0, 0, 0, 0, 0 } },
-					{ { 0x00016E00, 0x02401C00, 0, 0, 0, 0, 0, 0 } },
-					{ { 0x00017000, 0x02402000, 0, 0, 0, 0, 0, 0 } },
-					{ { 0x00017200, 0x02402400, 0, 0, 0, 0, 0, 0 } },
-					{ { 0x0001B000, 0x0242D800, 0, 0, 0, 0, 0, 0 } },
-					{ { 0x0001B200, 0x0242DC00, 0, 0, 0, 0, 0, 0 } } } };
-
-#define regCLK1_CLK0_CURRENT_CNT			0x0314
-#define regCLK1_CLK0_CURRENT_CNT_BASE_IDX	0
-#define regCLK1_CLK1_CURRENT_CNT			0x0315
-#define regCLK1_CLK1_CURRENT_CNT_BASE_IDX	0
-#define regCLK1_CLK2_CURRENT_CNT			0x0316
-#define regCLK1_CLK2_CURRENT_CNT_BASE_IDX	0
-#define regCLK1_CLK3_CURRENT_CNT			0x0317
-#define regCLK1_CLK3_CURRENT_CNT_BASE_IDX	0
-#define regCLK1_CLK4_CURRENT_CNT			0x0318
-#define regCLK1_CLK4_CURRENT_CNT_BASE_IDX	0
-#define regCLK1_CLK5_CURRENT_CNT			0x0319
-#define regCLK1_CLK5_CURRENT_CNT_BASE_IDX	0
-
 #define TO_CLK_MGR_DCN315(clk_mgr)\
 	container_of(clk_mgr, struct clk_mgr_dcn315, base)
 
-#define REG(reg_name) \
-	(CLK_BASE.instance[0].segment[reg ## reg_name ## _BASE_IDX] + reg ## reg_name)
-
 #define UNSUPPORTED_DCFCLK 10000000
 #define MIN_DPP_DISP_CLK     100000
 
@@ -172,7 +138,7 @@ static void dcn315_update_clocks(struct clk_mgr *clk_mgr_base,
 	if (dc->work_arounds.skip_clock_update)
 		return;
 
-	clk_mgr_base->clks.zstate_support = new_clocks->zstate_support;
+	display_count = dcn315_get_active_display_cnt_wa(dc, context);
 	/*
 	 * if it is safe to lower, but we are already in the lower state, we don't have to do anything
 	 * also if safe to lower is false, we just go in the higher state
@@ -185,7 +151,6 @@ static void dcn315_update_clocks(struct clk_mgr *clk_mgr_base,
 		}
 		/* check that we're not already in lower */
 		if (clk_mgr_base->clks.pwr_state != DCN_PWR_STATE_LOW_POWER) {
-			display_count = dcn315_get_active_display_cnt_wa(dc, context);
 			/* if we can go lower, go lower */
 			if (display_count == 0) {
 				union display_idle_optimization_u idle_info = { 0 };
@@ -279,38 +244,9 @@ static void dcn315_update_clocks(struct clk_mgr *clk_mgr_base,
 	dc_wake_and_execute_dmub_cmd(dc->ctx, &cmd, DM_DMUB_WAIT_TYPE_WAIT);
 }
 
-static void dcn315_dump_clk_registers_internal(struct dcn35_clk_internal *internal, struct clk_mgr *clk_mgr_base)
-{
-	struct clk_mgr_internal *clk_mgr = TO_CLK_MGR_INTERNAL(clk_mgr_base);
-
-	// read dtbclk
-	internal->CLK1_CLK4_CURRENT_CNT = REG_READ(CLK1_CLK4_CURRENT_CNT);
-
-	// read dcfclk
-	internal->CLK1_CLK3_CURRENT_CNT = REG_READ(CLK1_CLK3_CURRENT_CNT);
-
-	// read dppclk
-	internal->CLK1_CLK1_CURRENT_CNT = REG_READ(CLK1_CLK1_CURRENT_CNT);
-
-	// read dprefclk
-	internal->CLK1_CLK2_CURRENT_CNT = REG_READ(CLK1_CLK2_CURRENT_CNT);
-
-	// read dispclk
-	internal->CLK1_CLK0_CURRENT_CNT = REG_READ(CLK1_CLK0_CURRENT_CNT);
-}
-
 static void dcn315_dump_clk_registers(struct clk_state_registers_and_bypass *regs_and_bypass,
 		struct clk_mgr *clk_mgr_base, struct clk_log_info *log_info)
 {
-	struct dcn35_clk_internal internal = {0};
-
-	dcn315_dump_clk_registers_internal(&internal, clk_mgr_base);
-
-	regs_and_bypass->dcfclk = internal.CLK1_CLK3_CURRENT_CNT / 10;
-	regs_and_bypass->dprefclk = internal.CLK1_CLK2_CURRENT_CNT / 10;
-	regs_and_bypass->dispclk = internal.CLK1_CLK0_CURRENT_CNT / 10;
-	regs_and_bypass->dppclk = internal.CLK1_CLK1_CURRENT_CNT / 10;
-	regs_and_bypass->dtbclk = internal.CLK1_CLK4_CURRENT_CNT / 10;
 	return;
 }
 
@@ -657,32 +593,13 @@ static struct clk_mgr_funcs dcn315_funcs = {
 	.get_dp_ref_clk_frequency = dce12_get_dp_ref_freq_khz,
 	.get_dtb_ref_clk_frequency = dcn31_get_dtb_ref_freq_khz,
 	.update_clocks = dcn315_update_clocks,
-	.init_clocks = dcn315_init_clocks,
+	.init_clocks = dcn31_init_clocks,
 	.enable_pme_wa = dcn315_enable_pme_wa,
 	.are_clock_states_equal = dcn31_are_clock_states_equal,
 	.notify_wm_ranges = dcn315_notify_wm_ranges
 };
 extern struct clk_mgr_funcs dcn3_fpga_funcs;
 
-void dcn315_init_clocks(struct clk_mgr *clk_mgr)
-{
-	struct clk_mgr_internal *clk_mgr_int = TO_CLK_MGR_INTERNAL(clk_mgr);
-	uint32_t ref_dtbclk = clk_mgr->clks.ref_dtbclk_khz;
-	struct clk_mgr_dcn315 *clk_mgr_dcn315 = TO_CLK_MGR_DCN315(clk_mgr_int);
-	struct clk_log_info log_info = {0};
-
-	memset(&(clk_mgr->clks), 0, sizeof(struct dc_clocks));
-	// Assumption is that boot state always supports pstate
-	clk_mgr->clks.ref_dtbclk_khz = ref_dtbclk;	// restore ref_dtbclk
-	clk_mgr->clks.p_state_change_support = true;
-	clk_mgr->clks.prev_p_state_change_support = true;
-	clk_mgr->clks.pwr_state = DCN_PWR_STATE_UNKNOWN;
-	clk_mgr->clks.zstate_support = DCN_ZSTATE_SUPPORT_UNKNOWN;
-
-	dcn315_dump_clk_registers(&clk_mgr->boot_snapshot, &clk_mgr_dcn315->base.base, &log_info);
-	clk_mgr->clks.dispclk_khz =  clk_mgr->boot_snapshot.dispclk * 1000;
-}
-
 void dcn315_clk_mgr_construct(
 		struct dc_context *ctx,
 		struct clk_mgr_dcn315 *clk_mgr,
@@ -743,7 +660,6 @@ void dcn315_clk_mgr_construct(
 	/* Saved clocks configured at boot for debug purposes */
 	dcn315_dump_clk_registers(&clk_mgr->base.base.boot_snapshot,
 				  &clk_mgr->base.base, &log_info);
-	clk_mgr->base.base.clks.dispclk_khz =  clk_mgr->base.base.boot_snapshot.dispclk * 1000;
 
 	clk_mgr->base.base.dprefclk_khz = 600000;
 	clk_mgr->base.base.dprefclk_khz = dcn315_smu_get_dpref_clk(&clk_mgr->base);
diff --git a/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn315/dcn315_clk_mgr.h b/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn315/dcn315_clk_mgr.h
index 642ae3d4a7909..ac36ddf5dd1af 100644
--- a/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn315/dcn315_clk_mgr.h
+++ b/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn315/dcn315_clk_mgr.h
@@ -44,7 +44,6 @@ void dcn315_clk_mgr_construct(struct dc_context *ctx,
 		struct pp_smu_funcs *pp_smu,
 		struct dccg *dccg);
 
-void dcn315_init_clocks(struct clk_mgr *clk_mgr);
 void dcn315_clk_mgr_destroy(struct clk_mgr_internal *clk_mgr_int);
 
 #endif //__DCN315_CLK_MGR_H__
-- 
2.51.0

