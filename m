Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CDB01E1E12;
	Sat, 14 Feb 2026 01:06:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771031162; cv=none; b=rBFope2Mw0zqjMzY2SCVTK2APQla4IgNnv4q1jDfaQAQiv2NaC7ZIhb2xRnQiK029jSZD1V9As4lcC7z2LW0JIfVN0LlmVfJMoJ0olEKU1wmVp0mtDnL2naZx+cdX1G/d3UcNUAnTtUkytovwFBtz2PdrHJNyW09N1r1AM2JGt8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771031162; c=relaxed/simple;
	bh=sr7Ek9l3sTEl9q/3HTXU++a9IysOXt/7SV6Fxw6QdzM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sMIYy0dzigRwiaogW4E9uNGv3sVhI46K1Ssqy5V0A0HInFxtJK9/OiplIaRcKIcizI0yQ72BlKPpDFLQpfOKo0oNL7bpXSA+qoQ7kTBWIBRKlV3RytRN18IMgAHgT6wnjByZZn9MDFH99GxWZrRcZLOb6FYefu/T649wpxf5bDs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dJy6fB2k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dJy6fB2k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1913C16AAE;
	Sat, 14 Feb 2026 01:06:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771031162;
	bh=sr7Ek9l3sTEl9q/3HTXU++a9IysOXt/7SV6Fxw6QdzM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dJy6fB2kFNFo5MakAElcSNiZZvlHXwEzORoLoIGdD45q7pb7skhhEeM73PVtkg/Bk
	 AS7ydvtWCuqkxb86PURK66X/8ub3CyjwStfCrMPfLAc3FX/9YBwci+djIpMKdH4Vu7
	 QNfAz9DinxBbSZ4QkFb5C8jMwjamhyGVJZyRjgG7TvErFn6+45t69aZXbEersWi5hU
	 mBWewEm7adkWE+e9QBcW3X/ud22ig4rkHgm9xYmh1JhaJL284dwFVrhVrpZ0blUd8t
	 KQuDl6cV46JKslWMexKzZVi/qJ0iqN/kAz2ZXdEssRGJZFrBkkrjfpxuYy9aew1QuD
	 uKmldisHbAwvw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: "Wang, Sung-huai" <Danny.Wang@amd.com>,
	Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
	Matthew Stewart <matthew.stewart2@amd.com>,
	Dan Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	neil.armstrong@linaro.org,
	ivan.lipski@amd.com,
	alex.hung@amd.com,
	lo-an.chen@amd.com,
	yelangyan@huaqin.corp-partner.google.com,
	Wesley.Chalmers@amd.com
Subject: [PATCH AUTOSEL 6.19] drm/amd/display: Revert "init dispclk from bootup clock for DCN314"
Date: Fri, 13 Feb 2026 19:59:24 -0500
Message-ID: <20260214010245.3671907-84-sashal@kernel.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: "Wang, Sung-huai" <Danny.Wang@amd.com>

[ Upstream commit bdc26342c49e1dc1afb48feeb20c9d74d15b784c ]

[Why&How]
This reverts commit f082daf08f2f.
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

The alternative fix `d24203bb629f` is in v6.19-rc1+, but **NOT** in
v6.18.y. So for 6.18.y stable, this revert is essential — the original
broken commit exists there but neither the revert nor the alternative
fix does.

### Assessment

**Bug being fixed**: Display shows garbage on startup for AMD DCN314
hardware. This is a serious user-visible regression — a broken display
at boot is one of the most impactful bugs possible.

**Severity**: HIGH. Display corruption on boot renders the system
effectively unusable for graphical desktop users.

**Scope**: DCN314 hardware only (specific AMD APUs) — well-contained to
one hardware generation.

**Risk**: LOW. This is a revert — it restores the previously working
code. The original commit was the one introducing the regression, and
reverting it returns to known-good behavior.

**Stable tree applicability**: The original broken commit `f082daf08f2f`
is present in the 6.18.y stable tree. The revert is needed there. The
alternative fix (`d24203bb629f`) only landed in 6.19-rc1, so it's NOT
available in 6.18.y — making this revert the only path to fixing the
display corruption for 6.18 stable users.

**Dependencies**: The commit is self-contained — it cleanly reverts the
changes made by `f082daf08f2f`.

**Testing**: Has `Tested-by: Dan Wheeler` and `Reviewed-by: Nicholas
Kazlauskas` (AMD display team lead).

### Conclusion

This is a clear YES for stable backport. It fixes a severe user-visible
regression (display shows garbage on startup) for DCN314 hardware. The
original broken commit is in the 6.18.y stable tree, and neither this
revert nor the alternative fix has been applied there. The change is a
straightforward revert with low risk, has been reviewed and tested by
the AMD display team, and restores known-good behavior.

**YES**

 .../dc/clk_mgr/dcn314/dcn314_clk_mgr.c        | 133 +-----------------
 .../dc/clk_mgr/dcn314/dcn314_clk_mgr.h        |   5 -
 2 files changed, 4 insertions(+), 134 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn314/dcn314_clk_mgr.c b/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn314/dcn314_clk_mgr.c
index db687a13174d5..0cb37827a62b6 100644
--- a/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn314/dcn314_clk_mgr.c
+++ b/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn314/dcn314_clk_mgr.c
@@ -77,7 +77,6 @@ static const struct IP_BASE CLK_BASE = { { { { 0x00016C00, 0x02401800, 0, 0, 0,
 #undef DC_LOGGER
 #define DC_LOGGER \
 	clk_mgr->base.base.ctx->logger
-
 #define regCLK1_CLK_PLL_REQ			0x0237
 #define regCLK1_CLK_PLL_REQ_BASE_IDX		0
 
@@ -88,70 +87,8 @@ static const struct IP_BASE CLK_BASE = { { { { 0x00016C00, 0x02401800, 0, 0, 0,
 #define CLK1_CLK_PLL_REQ__PllSpineDiv_MASK	0x0000F000L
 #define CLK1_CLK_PLL_REQ__FbMult_frac_MASK	0xFFFF0000L
 
-#define regCLK1_CLK0_DFS_CNTL				0x0269
-#define regCLK1_CLK0_DFS_CNTL_BASE_IDX		0
-#define regCLK1_CLK1_DFS_CNTL				0x026c
-#define regCLK1_CLK1_DFS_CNTL_BASE_IDX		0
-#define regCLK1_CLK2_DFS_CNTL				0x026f
-#define regCLK1_CLK2_DFS_CNTL_BASE_IDX		0
-#define regCLK1_CLK3_DFS_CNTL				0x0272
-#define regCLK1_CLK3_DFS_CNTL_BASE_IDX		0
-#define regCLK1_CLK4_DFS_CNTL				0x0275
-#define regCLK1_CLK4_DFS_CNTL_BASE_IDX		0
-#define regCLK1_CLK5_DFS_CNTL				0x0278
-#define regCLK1_CLK5_DFS_CNTL_BASE_IDX		0
-
-#define regCLK1_CLK0_CURRENT_CNT			0x02fb
-#define regCLK1_CLK0_CURRENT_CNT_BASE_IDX	0
-#define regCLK1_CLK1_CURRENT_CNT			0x02fc
-#define regCLK1_CLK1_CURRENT_CNT_BASE_IDX	0
-#define regCLK1_CLK2_CURRENT_CNT			0x02fd
-#define regCLK1_CLK2_CURRENT_CNT_BASE_IDX	0
-#define regCLK1_CLK3_CURRENT_CNT			0x02fe
-#define regCLK1_CLK3_CURRENT_CNT_BASE_IDX	0
-#define regCLK1_CLK4_CURRENT_CNT			0x02ff
-#define regCLK1_CLK4_CURRENT_CNT_BASE_IDX	0
-#define regCLK1_CLK5_CURRENT_CNT			0x0300
-#define regCLK1_CLK5_CURRENT_CNT_BASE_IDX	0
-
-#define regCLK1_CLK0_BYPASS_CNTL			0x028a
-#define regCLK1_CLK0_BYPASS_CNTL_BASE_IDX	0
-#define regCLK1_CLK1_BYPASS_CNTL			0x0293
-#define regCLK1_CLK1_BYPASS_CNTL_BASE_IDX	0
 #define regCLK1_CLK2_BYPASS_CNTL			0x029c
 #define regCLK1_CLK2_BYPASS_CNTL_BASE_IDX	0
-#define regCLK1_CLK3_BYPASS_CNTL			0x02a5
-#define regCLK1_CLK3_BYPASS_CNTL_BASE_IDX	0
-#define regCLK1_CLK4_BYPASS_CNTL			0x02ae
-#define regCLK1_CLK4_BYPASS_CNTL_BASE_IDX	0
-#define regCLK1_CLK5_BYPASS_CNTL			0x02b7
-#define regCLK1_CLK5_BYPASS_CNTL_BASE_IDX	0
-
-#define regCLK1_CLK0_DS_CNTL				0x0283
-#define regCLK1_CLK0_DS_CNTL_BASE_IDX		0
-#define regCLK1_CLK1_DS_CNTL				0x028c
-#define regCLK1_CLK1_DS_CNTL_BASE_IDX		0
-#define regCLK1_CLK2_DS_CNTL				0x0295
-#define regCLK1_CLK2_DS_CNTL_BASE_IDX		0
-#define regCLK1_CLK3_DS_CNTL				0x029e
-#define regCLK1_CLK3_DS_CNTL_BASE_IDX		0
-#define regCLK1_CLK4_DS_CNTL				0x02a7
-#define regCLK1_CLK4_DS_CNTL_BASE_IDX		0
-#define regCLK1_CLK5_DS_CNTL				0x02b0
-#define regCLK1_CLK5_DS_CNTL_BASE_IDX		0
-
-#define regCLK1_CLK0_ALLOW_DS				0x0284
-#define regCLK1_CLK0_ALLOW_DS_BASE_IDX		0
-#define regCLK1_CLK1_ALLOW_DS				0x028d
-#define regCLK1_CLK1_ALLOW_DS_BASE_IDX		0
-#define regCLK1_CLK2_ALLOW_DS				0x0296
-#define regCLK1_CLK2_ALLOW_DS_BASE_IDX		0
-#define regCLK1_CLK3_ALLOW_DS				0x029f
-#define regCLK1_CLK3_ALLOW_DS_BASE_IDX		0
-#define regCLK1_CLK4_ALLOW_DS				0x02a8
-#define regCLK1_CLK4_ALLOW_DS_BASE_IDX		0
-#define regCLK1_CLK5_ALLOW_DS				0x02b1
-#define regCLK1_CLK5_ALLOW_DS_BASE_IDX		0
 
 #define CLK1_CLK2_BYPASS_CNTL__CLK2_BYPASS_SEL__SHIFT	0x0
 #define CLK1_CLK2_BYPASS_CNTL__CLK2_BYPASS_DIV__SHIFT	0x10
@@ -248,8 +185,6 @@ void dcn314_init_clocks(struct clk_mgr *clk_mgr)
 {
 	struct clk_mgr_internal *clk_mgr_int = TO_CLK_MGR_INTERNAL(clk_mgr);
 	uint32_t ref_dtbclk = clk_mgr->clks.ref_dtbclk_khz;
-	struct clk_mgr_dcn314 *clk_mgr_dcn314 = TO_CLK_MGR_DCN314(clk_mgr_int);
-	struct clk_log_info log_info = {0};
 
 	memset(&(clk_mgr->clks), 0, sizeof(struct dc_clocks));
 	// Assumption is that boot state always supports pstate
@@ -265,9 +200,6 @@ void dcn314_init_clocks(struct clk_mgr *clk_mgr)
 			dce_adjust_dp_ref_freq_for_ss(clk_mgr_int, clk_mgr->dprefclk_khz);
 	else
 		clk_mgr->dp_dto_source_clock_in_khz = clk_mgr->dprefclk_khz;
-
-	dcn314_dump_clk_registers(&clk_mgr->boot_snapshot, &clk_mgr_dcn314->base.base, &log_info);
-	clk_mgr->clks.dispclk_khz =  clk_mgr->boot_snapshot.dispclk * 1000;
 }
 
 void dcn314_update_clocks(struct clk_mgr *clk_mgr_base,
@@ -278,7 +210,7 @@ void dcn314_update_clocks(struct clk_mgr *clk_mgr_base,
 	struct clk_mgr_internal *clk_mgr = TO_CLK_MGR_INTERNAL(clk_mgr_base);
 	struct dc_clocks *new_clocks = &context->bw_ctx.bw.dcn.clk;
 	struct dc *dc = clk_mgr_base->ctx->dc;
-	int display_count;
+	int display_count = 0;
 	bool update_dppclk = false;
 	bool update_dispclk = false;
 	bool dpp_clock_lowered = false;
@@ -287,7 +219,6 @@ void dcn314_update_clocks(struct clk_mgr *clk_mgr_base,
 		return;
 
 	display_count = dcn314_get_active_display_cnt_wa(dc, context);
-
 	/*
 	 * if it is safe to lower, but we are already in the lower state, we don't have to do anything
 	 * also if safe to lower is false, we just go in the higher state
@@ -363,7 +294,7 @@ void dcn314_update_clocks(struct clk_mgr *clk_mgr_base,
 	}
 
 	if (should_set_clock(safe_to_lower, new_clocks->dispclk_khz, clk_mgr_base->clks.dispclk_khz) &&
-	    (new_clocks->dispclk_khz > 0 || (safe_to_lower && display_count == 0))) {
+		(new_clocks->dispclk_khz > 0 || (safe_to_lower && display_count == 0))) {
 		int requested_dispclk_khz = new_clocks->dispclk_khz;
 
 		dcn314_disable_otg_wa(clk_mgr_base, context, safe_to_lower, true);
@@ -374,7 +305,6 @@ void dcn314_update_clocks(struct clk_mgr *clk_mgr_base,
 
 		dcn314_smu_set_dispclk(clk_mgr, requested_dispclk_khz);
 		clk_mgr_base->clks.dispclk_khz = new_clocks->dispclk_khz;
-
 		dcn314_disable_otg_wa(clk_mgr_base, context, safe_to_lower, false);
 
 		update_dispclk = true;
@@ -462,65 +392,10 @@ bool dcn314_are_clock_states_equal(struct dc_clocks *a,
 	return true;
 }
 
-
-static void dcn314_dump_clk_registers_internal(struct dcn35_clk_internal *internal, struct clk_mgr *clk_mgr_base)
-{
-	struct clk_mgr_internal *clk_mgr = TO_CLK_MGR_INTERNAL(clk_mgr_base);
-
-	// read dtbclk
-	internal->CLK1_CLK4_CURRENT_CNT = REG_READ(CLK1_CLK4_CURRENT_CNT);
-	internal->CLK1_CLK4_BYPASS_CNTL = REG_READ(CLK1_CLK4_BYPASS_CNTL);
-
-	// read dcfclk
-	internal->CLK1_CLK3_CURRENT_CNT = REG_READ(CLK1_CLK3_CURRENT_CNT);
-	internal->CLK1_CLK3_BYPASS_CNTL = REG_READ(CLK1_CLK3_BYPASS_CNTL);
-
-	// read dcf deep sleep divider
-	internal->CLK1_CLK3_DS_CNTL = REG_READ(CLK1_CLK3_DS_CNTL);
-	internal->CLK1_CLK3_ALLOW_DS = REG_READ(CLK1_CLK3_ALLOW_DS);
-
-	// read dppclk
-	internal->CLK1_CLK1_CURRENT_CNT = REG_READ(CLK1_CLK1_CURRENT_CNT);
-	internal->CLK1_CLK1_BYPASS_CNTL = REG_READ(CLK1_CLK1_BYPASS_CNTL);
-
-	// read dprefclk
-	internal->CLK1_CLK2_CURRENT_CNT = REG_READ(CLK1_CLK2_CURRENT_CNT);
-	internal->CLK1_CLK2_BYPASS_CNTL = REG_READ(CLK1_CLK2_BYPASS_CNTL);
-
-	// read dispclk
-	internal->CLK1_CLK0_CURRENT_CNT = REG_READ(CLK1_CLK0_CURRENT_CNT);
-	internal->CLK1_CLK0_BYPASS_CNTL = REG_READ(CLK1_CLK0_BYPASS_CNTL);
-}
-
-void dcn314_dump_clk_registers(struct clk_state_registers_and_bypass *regs_and_bypass,
+static void dcn314_dump_clk_registers(struct clk_state_registers_and_bypass *regs_and_bypass,
 		struct clk_mgr *clk_mgr_base, struct clk_log_info *log_info)
 {
-
-	struct dcn35_clk_internal internal = {0};
-
-	dcn314_dump_clk_registers_internal(&internal, clk_mgr_base);
-
-	regs_and_bypass->dcfclk = internal.CLK1_CLK3_CURRENT_CNT / 10;
-	regs_and_bypass->dcf_deep_sleep_divider = internal.CLK1_CLK3_DS_CNTL / 10;
-	regs_and_bypass->dcf_deep_sleep_allow = internal.CLK1_CLK3_ALLOW_DS;
-	regs_and_bypass->dprefclk = internal.CLK1_CLK2_CURRENT_CNT / 10;
-	regs_and_bypass->dispclk = internal.CLK1_CLK0_CURRENT_CNT / 10;
-	regs_and_bypass->dppclk = internal.CLK1_CLK1_CURRENT_CNT / 10;
-	regs_and_bypass->dtbclk = internal.CLK1_CLK4_CURRENT_CNT / 10;
-
-	regs_and_bypass->dppclk_bypass = internal.CLK1_CLK1_BYPASS_CNTL & 0x0007;
-	if (regs_and_bypass->dppclk_bypass > 4)
-		regs_and_bypass->dppclk_bypass = 0;
-	regs_and_bypass->dcfclk_bypass = internal.CLK1_CLK3_BYPASS_CNTL & 0x0007;
-	if (regs_and_bypass->dcfclk_bypass > 4)
-		regs_and_bypass->dcfclk_bypass = 0;
-	regs_and_bypass->dispclk_bypass = internal.CLK1_CLK0_BYPASS_CNTL & 0x0007;
-	if (regs_and_bypass->dispclk_bypass > 4)
-		regs_and_bypass->dispclk_bypass = 0;
-	regs_and_bypass->dprefclk_bypass = internal.CLK1_CLK2_BYPASS_CNTL & 0x0007;
-	if (regs_and_bypass->dprefclk_bypass > 4)
-		regs_and_bypass->dprefclk_bypass = 0;
-
+	return;
 }
 
 static struct clk_bw_params dcn314_bw_params = {
diff --git a/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn314/dcn314_clk_mgr.h b/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn314/dcn314_clk_mgr.h
index 0577eb527bc36..002c28e807208 100644
--- a/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn314/dcn314_clk_mgr.h
+++ b/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn314/dcn314_clk_mgr.h
@@ -65,9 +65,4 @@ void dcn314_clk_mgr_construct(struct dc_context *ctx,
 
 void dcn314_clk_mgr_destroy(struct clk_mgr_internal *clk_mgr_int);
 
-
-void dcn314_dump_clk_registers(struct clk_state_registers_and_bypass *regs_and_bypass,
-		struct clk_mgr *clk_mgr_base, struct clk_log_info *log_info);
-
-
 #endif //__DCN314_CLK_MGR_H__
-- 
2.51.0

