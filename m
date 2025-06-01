Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E0D3257451;
	Sun,  1 Jun 2025 23:25:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748820303; cv=none; b=cNu/0HIoc1loZKZgoR1H9G9oRIGKw+07nDXfi7eGExQNQfeD+IAse20AhwBDcy035oB0i3zy6xE5BuZ+ELXZUdSHQZ9HIXQfSETy7xArHvF4FB4afKQqqkcx7WS0Yd0cvV1giBOV/ZtwoIT/cY/AJCfbrfRAdrdfUZ2o57F/kWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748820303; c=relaxed/simple;
	bh=WyO+M4FyI8ZWPTlyroibRWtNl1gBFKCZ+KTgEpn3XlQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=OVrSuc0u8i7zGtYwt1zb0jj+UU9c2tNImqrvlE2Y85B6LS0GS94Mue6nF3cL5M7ZGPo+8qGD5gOpSxbdYW17hxb2bZjCu4a9lYccjpOEiFf90HVM/5k0HqIqzi0BCJdy0CMz5TE//gmjyEykBEpG+aVfOs8EacDiga/LREfPWGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=G9H2cr0V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="G9H2cr0V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 414EDC4CEE7;
	Sun,  1 Jun 2025 23:25:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748820303;
	bh=WyO+M4FyI8ZWPTlyroibRWtNl1gBFKCZ+KTgEpn3XlQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G9H2cr0Vcik5eStWZRkxobJEpxqm+JJu4qVwRQqg3fXisH1twOaiUlorvIBDFmXdF
	 aK2wtJlCv6B8tNq/KqBOd2WwfrDotj8nzFT/cA8hDOdxPg6PiYMbe8xgm2dR/caE9W
	 HAqBiTIdcbOCpUpBtIO6sBS9gYqCWp8HJZYZABhRzdA3ONB4crhXDfQu9leZ+49ykD
	 +2gruLYOL6AWliTN3aib+GihiIi1Z1rxVjn0jPJk9NuA8ldOoj8zN500VO9OaR6YIs
	 Ohz5LeVZ547Q7Y2xRpKdQobnLjfTcMj16YLjys+oM9UnZDMQsgvPSSHik044CfaWhh
	 mhA2Tjkbz7h1w==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Yihan Zhu <Yihan.Zhu@amd.com>,
	Charlene Liu <charlene.liu@amd.com>,
	Zaeem Mohamed <zaeem.mohamed@amd.com>,
	Mark Broadworth <mark.broadworth@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	harry.wentland@amd.com,
	sunpeng.li@amd.com,
	christian.koenig@amd.com,
	airlied@gmail.com,
	simona@ffwll.ch,
	martin.leung@amd.com,
	moadhuri@amd.com,
	amd-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.15 009/110] drm/amd/display: DCN32 null data check
Date: Sun,  1 Jun 2025 19:22:51 -0400
Message-Id: <20250601232435.3507697-9-sashal@kernel.org>
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

From: Yihan Zhu <Yihan.Zhu@amd.com>

[ Upstream commit c9646e5a7e01c3ede286ec5edd4fcb2e1e80261d ]

[WHY & HOW]
Avoid null curve data structure used in the cm block for the potential issue.

Reviewed-by: Charlene Liu <charlene.liu@amd.com>
Signed-off-by: Yihan Zhu <Yihan.Zhu@amd.com>
Signed-off-by: Zaeem Mohamed <zaeem.mohamed@amd.com>
Tested-by: Mark Broadworth <mark.broadworth@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

I need to analyze the actual Linux kernel commit from the provided
information in the user's message. Let me examine the commit details:
**Commit Analysis:** Subject: `drm/amd/display: DCN32 null data check`
**Commit Message:** - WHY & HOW: Avoid null curve data structure used in
the cm block for the potential issue. **Code Changes:** The commit
modifies `drivers/gpu/drm/amd/display/dc/mpc/dcn32/dcn32_mpc.c` and adds
null checks for the `curve` pointer in two functions: 1.
`mpc32_program_shaper_luta_settings()` 2.
`mpc32_program_shaper_lutb_settings()` Specifically: - It wraps the
existing code that accesses `curve[0].offset`, `curve[0].segments_num`,
etc. with `if (curve)` null checks - Without this check, the code could
dereference a null pointer, leading to kernel crashes **Analysis of
Similar Commits:** Looking at the historical examples provided, this
commit is very similar to commits with "Backport Status: YES": 1.
**Similar Commit #1** - "Add Null check for DPP resource" - marked YES
2. **Similar Commit #2** - "Check null pointers before using them" -
marked YES These commits had similar characteristics: - Small, contained
null pointer checks - Fix potential kernel crashes/undefined behavior -
Minimal risk of regression - Address defensive programming issues
**Evaluation against backporting criteria:** 1. **Does it fix a bug that
affects users?** YES - Null pointer dereferences can cause kernel
crashes 2. **Is the fix relatively small and contained?** YES - Only
adds null checks around existing code 3. **Clear side effects beyond
fixing the issue?** NO - Simple defensive programming 4. **Major
architectural changes?** NO - Just adds safety checks 5. **Critical
kernel subsystems?** YES - Display driver, but the fix is minimal 6.
**Explicit stable tree mention?** NO - No Cc: stable tag 7. **Follows
stable tree rules?** YES - Important bugfix, minimal risk **YES** This
commit should be backported to stable kernel trees. Here's my extensive
analysis: **Reasoning for Backporting:** 1. **Critical Bug Fix**: This
commit addresses a potential null pointer dereference in the AMD display
driver's DCN32 color management code. Null pointer dereferences can
cause immediate kernel crashes (kernel panics), affecting system
stability. 2. **Minimal and Contained Change**: The fix is extremely
focused - it only adds `if (curve)` null checks around existing code
blocks in two functions (`mpc32_program_shaper_luta_settings` and
`mpc32_program_shaper_lutb_settings`). This defensive programming
pattern is a best practice that doesn't change the logic when `curve` is
valid. 3. **Low Regression Risk**: The change preserves existing
behavior when `curve` is non-null (the normal case) and simply skips
potentially dangerous operations when `curve` is null. This cannot
introduce new bugs since it only prevents undefined behavior. 4.
**Similar Pattern Success**: Looking at the historical examples, commits
with nearly identical characteristics have been successfully backported:
- "Add Null check for DPP resource" (YES) - Same subsystem, same type of
null check - "Check null pointers before using them" (YES) - Multiple
null checks in display code 5. **User Impact**: Display driver crashes
can render systems unusable, requiring hard reboots. Users with AMD GPUs
using DCN32 hardware could experience system instability without this
fix. 6. **Code Quality**: The commit follows standard defensive
programming practices. The existing code was accessing `curve[0]`,
`curve[1]`, etc. without verifying `curve` wasn't null, which is a clear
programming error. The only reason this might not have an explicit `Cc:
stable` tag is that it could be a recently discovered issue or the
developers may have overlooked the stable tree importance. However, the
technical characteristics clearly meet stable tree criteria: it's an
important bugfix with minimal regression risk confined to a specific
subsystem.

 .../drm/amd/display/dc/mpc/dcn32/dcn32_mpc.c  | 380 +++++++++---------
 1 file changed, 192 insertions(+), 188 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/mpc/dcn32/dcn32_mpc.c b/drivers/gpu/drm/amd/display/dc/mpc/dcn32/dcn32_mpc.c
index a0e9e9f0441a4..b4cea2b8cb2a8 100644
--- a/drivers/gpu/drm/amd/display/dc/mpc/dcn32/dcn32_mpc.c
+++ b/drivers/gpu/drm/amd/display/dc/mpc/dcn32/dcn32_mpc.c
@@ -370,275 +370,279 @@ void mpc32_program_shaper_luta_settings(
 			MPCC_MCM_SHAPER_RAMA_EXP_REGION_END_BASE_B, params->corner_points[1].red.custom_float_y);
 
 	curve = params->arr_curve_points;
-	REG_SET_4(MPCC_MCM_SHAPER_RAMA_REGION_0_1[mpcc_id], 0,
-		MPCC_MCM_SHAPER_RAMA_EXP_REGION0_LUT_OFFSET, curve[0].offset,
-		MPCC_MCM_SHAPER_RAMA_EXP_REGION0_NUM_SEGMENTS, curve[0].segments_num,
-		MPCC_MCM_SHAPER_RAMA_EXP_REGION1_LUT_OFFSET, curve[1].offset,
-		MPCC_MCM_SHAPER_RAMA_EXP_REGION1_NUM_SEGMENTS, curve[1].segments_num);
-
-	curve += 2;
-	REG_SET_4(MPCC_MCM_SHAPER_RAMA_REGION_2_3[mpcc_id], 0,
-		MPCC_MCM_SHAPER_RAMA_EXP_REGION0_LUT_OFFSET, curve[0].offset,
-		MPCC_MCM_SHAPER_RAMA_EXP_REGION0_NUM_SEGMENTS, curve[0].segments_num,
-		MPCC_MCM_SHAPER_RAMA_EXP_REGION1_LUT_OFFSET, curve[1].offset,
-		MPCC_MCM_SHAPER_RAMA_EXP_REGION1_NUM_SEGMENTS, curve[1].segments_num);
-
-	curve += 2;
-	REG_SET_4(MPCC_MCM_SHAPER_RAMA_REGION_4_5[mpcc_id], 0,
-		MPCC_MCM_SHAPER_RAMA_EXP_REGION0_LUT_OFFSET, curve[0].offset,
-		MPCC_MCM_SHAPER_RAMA_EXP_REGION0_NUM_SEGMENTS, curve[0].segments_num,
-		MPCC_MCM_SHAPER_RAMA_EXP_REGION1_LUT_OFFSET, curve[1].offset,
-		MPCC_MCM_SHAPER_RAMA_EXP_REGION1_NUM_SEGMENTS, curve[1].segments_num);
-
-	curve += 2;
-	REG_SET_4(MPCC_MCM_SHAPER_RAMA_REGION_6_7[mpcc_id], 0,
-		MPCC_MCM_SHAPER_RAMA_EXP_REGION0_LUT_OFFSET, curve[0].offset,
-		MPCC_MCM_SHAPER_RAMA_EXP_REGION0_NUM_SEGMENTS, curve[0].segments_num,
-		MPCC_MCM_SHAPER_RAMA_EXP_REGION1_LUT_OFFSET, curve[1].offset,
-		MPCC_MCM_SHAPER_RAMA_EXP_REGION1_NUM_SEGMENTS, curve[1].segments_num);
-
-	curve += 2;
-	REG_SET_4(MPCC_MCM_SHAPER_RAMA_REGION_8_9[mpcc_id], 0,
-		MPCC_MCM_SHAPER_RAMA_EXP_REGION0_LUT_OFFSET, curve[0].offset,
-		MPCC_MCM_SHAPER_RAMA_EXP_REGION0_NUM_SEGMENTS, curve[0].segments_num,
-		MPCC_MCM_SHAPER_RAMA_EXP_REGION1_LUT_OFFSET, curve[1].offset,
-		MPCC_MCM_SHAPER_RAMA_EXP_REGION1_NUM_SEGMENTS, curve[1].segments_num);
-
-	curve += 2;
-	REG_SET_4(MPCC_MCM_SHAPER_RAMA_REGION_10_11[mpcc_id], 0,
-		MPCC_MCM_SHAPER_RAMA_EXP_REGION0_LUT_OFFSET, curve[0].offset,
-		MPCC_MCM_SHAPER_RAMA_EXP_REGION0_NUM_SEGMENTS, curve[0].segments_num,
-		MPCC_MCM_SHAPER_RAMA_EXP_REGION1_LUT_OFFSET, curve[1].offset,
-		MPCC_MCM_SHAPER_RAMA_EXP_REGION1_NUM_SEGMENTS, curve[1].segments_num);
-
-	curve += 2;
-	REG_SET_4(MPCC_MCM_SHAPER_RAMA_REGION_12_13[mpcc_id], 0,
-		MPCC_MCM_SHAPER_RAMA_EXP_REGION0_LUT_OFFSET, curve[0].offset,
-		MPCC_MCM_SHAPER_RAMA_EXP_REGION0_NUM_SEGMENTS, curve[0].segments_num,
-		MPCC_MCM_SHAPER_RAMA_EXP_REGION1_LUT_OFFSET, curve[1].offset,
-		MPCC_MCM_SHAPER_RAMA_EXP_REGION1_NUM_SEGMENTS, curve[1].segments_num);
-
-	curve += 2;
-	REG_SET_4(MPCC_MCM_SHAPER_RAMA_REGION_14_15[mpcc_id], 0,
-		MPCC_MCM_SHAPER_RAMA_EXP_REGION0_LUT_OFFSET, curve[0].offset,
-		MPCC_MCM_SHAPER_RAMA_EXP_REGION0_NUM_SEGMENTS, curve[0].segments_num,
-		MPCC_MCM_SHAPER_RAMA_EXP_REGION1_LUT_OFFSET, curve[1].offset,
-		MPCC_MCM_SHAPER_RAMA_EXP_REGION1_NUM_SEGMENTS, curve[1].segments_num);
-
-
-	curve += 2;
-	REG_SET_4(MPCC_MCM_SHAPER_RAMA_REGION_16_17[mpcc_id], 0,
-		MPCC_MCM_SHAPER_RAMA_EXP_REGION0_LUT_OFFSET, curve[0].offset,
-		MPCC_MCM_SHAPER_RAMA_EXP_REGION0_NUM_SEGMENTS, curve[0].segments_num,
-		MPCC_MCM_SHAPER_RAMA_EXP_REGION1_LUT_OFFSET, curve[1].offset,
-		MPCC_MCM_SHAPER_RAMA_EXP_REGION1_NUM_SEGMENTS, curve[1].segments_num);
-
-	curve += 2;
-	REG_SET_4(MPCC_MCM_SHAPER_RAMA_REGION_18_19[mpcc_id], 0,
-		MPCC_MCM_SHAPER_RAMA_EXP_REGION0_LUT_OFFSET, curve[0].offset,
-		MPCC_MCM_SHAPER_RAMA_EXP_REGION0_NUM_SEGMENTS, curve[0].segments_num,
-		MPCC_MCM_SHAPER_RAMA_EXP_REGION1_LUT_OFFSET, curve[1].offset,
-		MPCC_MCM_SHAPER_RAMA_EXP_REGION1_NUM_SEGMENTS, curve[1].segments_num);
-
-	curve += 2;
-	REG_SET_4(MPCC_MCM_SHAPER_RAMA_REGION_20_21[mpcc_id], 0,
-		MPCC_MCM_SHAPER_RAMA_EXP_REGION0_LUT_OFFSET, curve[0].offset,
-		MPCC_MCM_SHAPER_RAMA_EXP_REGION0_NUM_SEGMENTS, curve[0].segments_num,
-		MPCC_MCM_SHAPER_RAMA_EXP_REGION1_LUT_OFFSET, curve[1].offset,
-		MPCC_MCM_SHAPER_RAMA_EXP_REGION1_NUM_SEGMENTS, curve[1].segments_num);
-
-	curve += 2;
-	REG_SET_4(MPCC_MCM_SHAPER_RAMA_REGION_22_23[mpcc_id], 0,
-		MPCC_MCM_SHAPER_RAMA_EXP_REGION0_LUT_OFFSET, curve[0].offset,
-		MPCC_MCM_SHAPER_RAMA_EXP_REGION0_NUM_SEGMENTS, curve[0].segments_num,
-		MPCC_MCM_SHAPER_RAMA_EXP_REGION1_LUT_OFFSET, curve[1].offset,
-		MPCC_MCM_SHAPER_RAMA_EXP_REGION1_NUM_SEGMENTS, curve[1].segments_num);
-
-	curve += 2;
-	REG_SET_4(MPCC_MCM_SHAPER_RAMA_REGION_24_25[mpcc_id], 0,
-		MPCC_MCM_SHAPER_RAMA_EXP_REGION0_LUT_OFFSET, curve[0].offset,
-		MPCC_MCM_SHAPER_RAMA_EXP_REGION0_NUM_SEGMENTS, curve[0].segments_num,
-		MPCC_MCM_SHAPER_RAMA_EXP_REGION1_LUT_OFFSET, curve[1].offset,
-		MPCC_MCM_SHAPER_RAMA_EXP_REGION1_NUM_SEGMENTS, curve[1].segments_num);
-
-	curve += 2;
-	REG_SET_4(MPCC_MCM_SHAPER_RAMA_REGION_26_27[mpcc_id], 0,
+	if (curve) {
+		REG_SET_4(MPCC_MCM_SHAPER_RAMA_REGION_0_1[mpcc_id], 0,
 			MPCC_MCM_SHAPER_RAMA_EXP_REGION0_LUT_OFFSET, curve[0].offset,
 			MPCC_MCM_SHAPER_RAMA_EXP_REGION0_NUM_SEGMENTS, curve[0].segments_num,
 			MPCC_MCM_SHAPER_RAMA_EXP_REGION1_LUT_OFFSET, curve[1].offset,
 			MPCC_MCM_SHAPER_RAMA_EXP_REGION1_NUM_SEGMENTS, curve[1].segments_num);
 
-	curve += 2;
-	REG_SET_4(MPCC_MCM_SHAPER_RAMA_REGION_28_29[mpcc_id], 0,
-		MPCC_MCM_SHAPER_RAMA_EXP_REGION0_LUT_OFFSET, curve[0].offset,
-		MPCC_MCM_SHAPER_RAMA_EXP_REGION0_NUM_SEGMENTS, curve[0].segments_num,
-		MPCC_MCM_SHAPER_RAMA_EXP_REGION1_LUT_OFFSET, curve[1].offset,
-		MPCC_MCM_SHAPER_RAMA_EXP_REGION1_NUM_SEGMENTS, curve[1].segments_num);
-
-	curve += 2;
-	REG_SET_4(MPCC_MCM_SHAPER_RAMA_REGION_30_31[mpcc_id], 0,
-		MPCC_MCM_SHAPER_RAMA_EXP_REGION0_LUT_OFFSET, curve[0].offset,
-		MPCC_MCM_SHAPER_RAMA_EXP_REGION0_NUM_SEGMENTS, curve[0].segments_num,
-		MPCC_MCM_SHAPER_RAMA_EXP_REGION1_LUT_OFFSET, curve[1].offset,
-		MPCC_MCM_SHAPER_RAMA_EXP_REGION1_NUM_SEGMENTS, curve[1].segments_num);
-
-	curve += 2;
-	REG_SET_4(MPCC_MCM_SHAPER_RAMA_REGION_32_33[mpcc_id], 0,
-		MPCC_MCM_SHAPER_RAMA_EXP_REGION0_LUT_OFFSET, curve[0].offset,
-		MPCC_MCM_SHAPER_RAMA_EXP_REGION0_NUM_SEGMENTS, curve[0].segments_num,
-		MPCC_MCM_SHAPER_RAMA_EXP_REGION1_LUT_OFFSET, curve[1].offset,
-		MPCC_MCM_SHAPER_RAMA_EXP_REGION1_NUM_SEGMENTS, curve[1].segments_num);
-}
-
-
-void mpc32_program_shaper_lutb_settings(
-		struct mpc *mpc,
-		const struct pwl_params *params,
-		uint32_t mpcc_id)
-{
-	const struct gamma_curve *curve;
-	struct dcn30_mpc *mpc30 = TO_DCN30_MPC(mpc);
-
-	REG_SET_2(MPCC_MCM_SHAPER_RAMB_START_CNTL_B[mpcc_id], 0,
-		MPCC_MCM_SHAPER_RAMA_EXP_REGION_START_B, params->corner_points[0].blue.custom_float_x,
-		MPCC_MCM_SHAPER_RAMA_EXP_REGION_START_SEGMENT_B, 0);
-	REG_SET_2(MPCC_MCM_SHAPER_RAMB_START_CNTL_G[mpcc_id], 0,
-			MPCC_MCM_SHAPER_RAMA_EXP_REGION_START_B, params->corner_points[0].green.custom_float_x,
-			MPCC_MCM_SHAPER_RAMA_EXP_REGION_START_SEGMENT_B, 0);
-	REG_SET_2(MPCC_MCM_SHAPER_RAMB_START_CNTL_R[mpcc_id], 0,
-			MPCC_MCM_SHAPER_RAMA_EXP_REGION_START_B, params->corner_points[0].red.custom_float_x,
-			MPCC_MCM_SHAPER_RAMA_EXP_REGION_START_SEGMENT_B, 0);
-
-	REG_SET_2(MPCC_MCM_SHAPER_RAMB_END_CNTL_B[mpcc_id], 0,
-			MPCC_MCM_SHAPER_RAMA_EXP_REGION_END_B, params->corner_points[1].blue.custom_float_x,
-			MPCC_MCM_SHAPER_RAMA_EXP_REGION_END_BASE_B, params->corner_points[1].blue.custom_float_y);
-	REG_SET_2(MPCC_MCM_SHAPER_RAMB_END_CNTL_G[mpcc_id], 0,
-			MPCC_MCM_SHAPER_RAMA_EXP_REGION_END_B, params->corner_points[1].green.custom_float_x,
-			MPCC_MCM_SHAPER_RAMA_EXP_REGION_END_BASE_B, params->corner_points[1].green.custom_float_y);
-	REG_SET_2(MPCC_MCM_SHAPER_RAMB_END_CNTL_R[mpcc_id], 0,
-			MPCC_MCM_SHAPER_RAMA_EXP_REGION_END_B, params->corner_points[1].red.custom_float_x,
-			MPCC_MCM_SHAPER_RAMA_EXP_REGION_END_BASE_B, params->corner_points[1].red.custom_float_y);
-
-	curve = params->arr_curve_points;
-	REG_SET_4(MPCC_MCM_SHAPER_RAMB_REGION_0_1[mpcc_id], 0,
-		MPCC_MCM_SHAPER_RAMA_EXP_REGION0_LUT_OFFSET, curve[0].offset,
-		MPCC_MCM_SHAPER_RAMA_EXP_REGION0_NUM_SEGMENTS, curve[0].segments_num,
-		MPCC_MCM_SHAPER_RAMA_EXP_REGION1_LUT_OFFSET, curve[1].offset,
-		MPCC_MCM_SHAPER_RAMA_EXP_REGION1_NUM_SEGMENTS, curve[1].segments_num);
-
-	curve += 2;
-	REG_SET_4(MPCC_MCM_SHAPER_RAMB_REGION_2_3[mpcc_id], 0,
+		curve += 2;
+		REG_SET_4(MPCC_MCM_SHAPER_RAMA_REGION_2_3[mpcc_id], 0,
 			MPCC_MCM_SHAPER_RAMA_EXP_REGION0_LUT_OFFSET, curve[0].offset,
 			MPCC_MCM_SHAPER_RAMA_EXP_REGION0_NUM_SEGMENTS, curve[0].segments_num,
 			MPCC_MCM_SHAPER_RAMA_EXP_REGION1_LUT_OFFSET, curve[1].offset,
 			MPCC_MCM_SHAPER_RAMA_EXP_REGION1_NUM_SEGMENTS, curve[1].segments_num);
 
-
-	curve += 2;
-	REG_SET_4(MPCC_MCM_SHAPER_RAMB_REGION_4_5[mpcc_id], 0,
+		curve += 2;
+		REG_SET_4(MPCC_MCM_SHAPER_RAMA_REGION_4_5[mpcc_id], 0,
 			MPCC_MCM_SHAPER_RAMA_EXP_REGION0_LUT_OFFSET, curve[0].offset,
 			MPCC_MCM_SHAPER_RAMA_EXP_REGION0_NUM_SEGMENTS, curve[0].segments_num,
 			MPCC_MCM_SHAPER_RAMA_EXP_REGION1_LUT_OFFSET, curve[1].offset,
 			MPCC_MCM_SHAPER_RAMA_EXP_REGION1_NUM_SEGMENTS, curve[1].segments_num);
 
-	curve += 2;
-	REG_SET_4(MPCC_MCM_SHAPER_RAMB_REGION_6_7[mpcc_id], 0,
+		curve += 2;
+		REG_SET_4(MPCC_MCM_SHAPER_RAMA_REGION_6_7[mpcc_id], 0,
 			MPCC_MCM_SHAPER_RAMA_EXP_REGION0_LUT_OFFSET, curve[0].offset,
 			MPCC_MCM_SHAPER_RAMA_EXP_REGION0_NUM_SEGMENTS, curve[0].segments_num,
 			MPCC_MCM_SHAPER_RAMA_EXP_REGION1_LUT_OFFSET, curve[1].offset,
 			MPCC_MCM_SHAPER_RAMA_EXP_REGION1_NUM_SEGMENTS, curve[1].segments_num);
 
-	curve += 2;
-	REG_SET_4(MPCC_MCM_SHAPER_RAMB_REGION_8_9[mpcc_id], 0,
-		MPCC_MCM_SHAPER_RAMA_EXP_REGION0_LUT_OFFSET, curve[0].offset,
-		MPCC_MCM_SHAPER_RAMA_EXP_REGION0_NUM_SEGMENTS, curve[0].segments_num,
-		MPCC_MCM_SHAPER_RAMA_EXP_REGION1_LUT_OFFSET, curve[1].offset,
-		MPCC_MCM_SHAPER_RAMA_EXP_REGION1_NUM_SEGMENTS, curve[1].segments_num);
+		curve += 2;
+		REG_SET_4(MPCC_MCM_SHAPER_RAMA_REGION_8_9[mpcc_id], 0,
+			MPCC_MCM_SHAPER_RAMA_EXP_REGION0_LUT_OFFSET, curve[0].offset,
+			MPCC_MCM_SHAPER_RAMA_EXP_REGION0_NUM_SEGMENTS, curve[0].segments_num,
+			MPCC_MCM_SHAPER_RAMA_EXP_REGION1_LUT_OFFSET, curve[1].offset,
+			MPCC_MCM_SHAPER_RAMA_EXP_REGION1_NUM_SEGMENTS, curve[1].segments_num);
 
-	curve += 2;
-	REG_SET_4(MPCC_MCM_SHAPER_RAMB_REGION_10_11[mpcc_id], 0,
+		curve += 2;
+		REG_SET_4(MPCC_MCM_SHAPER_RAMA_REGION_10_11[mpcc_id], 0,
 			MPCC_MCM_SHAPER_RAMA_EXP_REGION0_LUT_OFFSET, curve[0].offset,
 			MPCC_MCM_SHAPER_RAMA_EXP_REGION0_NUM_SEGMENTS, curve[0].segments_num,
 			MPCC_MCM_SHAPER_RAMA_EXP_REGION1_LUT_OFFSET, curve[1].offset,
 			MPCC_MCM_SHAPER_RAMA_EXP_REGION1_NUM_SEGMENTS, curve[1].segments_num);
 
-	curve += 2;
-	REG_SET_4(MPCC_MCM_SHAPER_RAMB_REGION_12_13[mpcc_id], 0,
+		curve += 2;
+		REG_SET_4(MPCC_MCM_SHAPER_RAMA_REGION_12_13[mpcc_id], 0,
 			MPCC_MCM_SHAPER_RAMA_EXP_REGION0_LUT_OFFSET, curve[0].offset,
 			MPCC_MCM_SHAPER_RAMA_EXP_REGION0_NUM_SEGMENTS, curve[0].segments_num,
 			MPCC_MCM_SHAPER_RAMA_EXP_REGION1_LUT_OFFSET, curve[1].offset,
 			MPCC_MCM_SHAPER_RAMA_EXP_REGION1_NUM_SEGMENTS, curve[1].segments_num);
 
-	curve += 2;
-	REG_SET_4(MPCC_MCM_SHAPER_RAMB_REGION_14_15[mpcc_id], 0,
+		curve += 2;
+		REG_SET_4(MPCC_MCM_SHAPER_RAMA_REGION_14_15[mpcc_id], 0,
 			MPCC_MCM_SHAPER_RAMA_EXP_REGION0_LUT_OFFSET, curve[0].offset,
 			MPCC_MCM_SHAPER_RAMA_EXP_REGION0_NUM_SEGMENTS, curve[0].segments_num,
 			MPCC_MCM_SHAPER_RAMA_EXP_REGION1_LUT_OFFSET, curve[1].offset,
 			MPCC_MCM_SHAPER_RAMA_EXP_REGION1_NUM_SEGMENTS, curve[1].segments_num);
 
 
-	curve += 2;
-	REG_SET_4(MPCC_MCM_SHAPER_RAMB_REGION_16_17[mpcc_id], 0,
+		curve += 2;
+		REG_SET_4(MPCC_MCM_SHAPER_RAMA_REGION_16_17[mpcc_id], 0,
 			MPCC_MCM_SHAPER_RAMA_EXP_REGION0_LUT_OFFSET, curve[0].offset,
 			MPCC_MCM_SHAPER_RAMA_EXP_REGION0_NUM_SEGMENTS, curve[0].segments_num,
 			MPCC_MCM_SHAPER_RAMA_EXP_REGION1_LUT_OFFSET, curve[1].offset,
 			MPCC_MCM_SHAPER_RAMA_EXP_REGION1_NUM_SEGMENTS, curve[1].segments_num);
 
-	curve += 2;
-	REG_SET_4(MPCC_MCM_SHAPER_RAMB_REGION_18_19[mpcc_id], 0,
+		curve += 2;
+		REG_SET_4(MPCC_MCM_SHAPER_RAMA_REGION_18_19[mpcc_id], 0,
 			MPCC_MCM_SHAPER_RAMA_EXP_REGION0_LUT_OFFSET, curve[0].offset,
 			MPCC_MCM_SHAPER_RAMA_EXP_REGION0_NUM_SEGMENTS, curve[0].segments_num,
 			MPCC_MCM_SHAPER_RAMA_EXP_REGION1_LUT_OFFSET, curve[1].offset,
 			MPCC_MCM_SHAPER_RAMA_EXP_REGION1_NUM_SEGMENTS, curve[1].segments_num);
 
-	curve += 2;
-	REG_SET_4(MPCC_MCM_SHAPER_RAMB_REGION_20_21[mpcc_id], 0,
+		curve += 2;
+		REG_SET_4(MPCC_MCM_SHAPER_RAMA_REGION_20_21[mpcc_id], 0,
 			MPCC_MCM_SHAPER_RAMA_EXP_REGION0_LUT_OFFSET, curve[0].offset,
 			MPCC_MCM_SHAPER_RAMA_EXP_REGION0_NUM_SEGMENTS, curve[0].segments_num,
 			MPCC_MCM_SHAPER_RAMA_EXP_REGION1_LUT_OFFSET, curve[1].offset,
 			MPCC_MCM_SHAPER_RAMA_EXP_REGION1_NUM_SEGMENTS, curve[1].segments_num);
 
-	curve += 2;
-	REG_SET_4(MPCC_MCM_SHAPER_RAMB_REGION_22_23[mpcc_id], 0,
+		curve += 2;
+		REG_SET_4(MPCC_MCM_SHAPER_RAMA_REGION_22_23[mpcc_id], 0,
 			MPCC_MCM_SHAPER_RAMA_EXP_REGION0_LUT_OFFSET, curve[0].offset,
 			MPCC_MCM_SHAPER_RAMA_EXP_REGION0_NUM_SEGMENTS, curve[0].segments_num,
 			MPCC_MCM_SHAPER_RAMA_EXP_REGION1_LUT_OFFSET, curve[1].offset,
 			MPCC_MCM_SHAPER_RAMA_EXP_REGION1_NUM_SEGMENTS, curve[1].segments_num);
 
-	curve += 2;
-	REG_SET_4(MPCC_MCM_SHAPER_RAMB_REGION_24_25[mpcc_id], 0,
+		curve += 2;
+		REG_SET_4(MPCC_MCM_SHAPER_RAMA_REGION_24_25[mpcc_id], 0,
 			MPCC_MCM_SHAPER_RAMA_EXP_REGION0_LUT_OFFSET, curve[0].offset,
 			MPCC_MCM_SHAPER_RAMA_EXP_REGION0_NUM_SEGMENTS, curve[0].segments_num,
 			MPCC_MCM_SHAPER_RAMA_EXP_REGION1_LUT_OFFSET, curve[1].offset,
 			MPCC_MCM_SHAPER_RAMA_EXP_REGION1_NUM_SEGMENTS, curve[1].segments_num);
 
-	curve += 2;
-	REG_SET_4(MPCC_MCM_SHAPER_RAMB_REGION_26_27[mpcc_id], 0,
+		curve += 2;
+		REG_SET_4(MPCC_MCM_SHAPER_RAMA_REGION_26_27[mpcc_id], 0,
+				MPCC_MCM_SHAPER_RAMA_EXP_REGION0_LUT_OFFSET, curve[0].offset,
+				MPCC_MCM_SHAPER_RAMA_EXP_REGION0_NUM_SEGMENTS, curve[0].segments_num,
+				MPCC_MCM_SHAPER_RAMA_EXP_REGION1_LUT_OFFSET, curve[1].offset,
+				MPCC_MCM_SHAPER_RAMA_EXP_REGION1_NUM_SEGMENTS, curve[1].segments_num);
+
+		curve += 2;
+		REG_SET_4(MPCC_MCM_SHAPER_RAMA_REGION_28_29[mpcc_id], 0,
 			MPCC_MCM_SHAPER_RAMA_EXP_REGION0_LUT_OFFSET, curve[0].offset,
 			MPCC_MCM_SHAPER_RAMA_EXP_REGION0_NUM_SEGMENTS, curve[0].segments_num,
 			MPCC_MCM_SHAPER_RAMA_EXP_REGION1_LUT_OFFSET, curve[1].offset,
 			MPCC_MCM_SHAPER_RAMA_EXP_REGION1_NUM_SEGMENTS, curve[1].segments_num);
 
-	curve += 2;
-	REG_SET_4(MPCC_MCM_SHAPER_RAMB_REGION_28_29[mpcc_id], 0,
+		curve += 2;
+		REG_SET_4(MPCC_MCM_SHAPER_RAMA_REGION_30_31[mpcc_id], 0,
 			MPCC_MCM_SHAPER_RAMA_EXP_REGION0_LUT_OFFSET, curve[0].offset,
 			MPCC_MCM_SHAPER_RAMA_EXP_REGION0_NUM_SEGMENTS, curve[0].segments_num,
 			MPCC_MCM_SHAPER_RAMA_EXP_REGION1_LUT_OFFSET, curve[1].offset,
 			MPCC_MCM_SHAPER_RAMA_EXP_REGION1_NUM_SEGMENTS, curve[1].segments_num);
 
-	curve += 2;
-	REG_SET_4(MPCC_MCM_SHAPER_RAMB_REGION_30_31[mpcc_id], 0,
+		curve += 2;
+		REG_SET_4(MPCC_MCM_SHAPER_RAMA_REGION_32_33[mpcc_id], 0,
 			MPCC_MCM_SHAPER_RAMA_EXP_REGION0_LUT_OFFSET, curve[0].offset,
 			MPCC_MCM_SHAPER_RAMA_EXP_REGION0_NUM_SEGMENTS, curve[0].segments_num,
 			MPCC_MCM_SHAPER_RAMA_EXP_REGION1_LUT_OFFSET, curve[1].offset,
 			MPCC_MCM_SHAPER_RAMA_EXP_REGION1_NUM_SEGMENTS, curve[1].segments_num);
+	}
+}
+
+
+void mpc32_program_shaper_lutb_settings(
+		struct mpc *mpc,
+		const struct pwl_params *params,
+		uint32_t mpcc_id)
+{
+	const struct gamma_curve *curve;
+	struct dcn30_mpc *mpc30 = TO_DCN30_MPC(mpc);
+
+	REG_SET_2(MPCC_MCM_SHAPER_RAMB_START_CNTL_B[mpcc_id], 0,
+		MPCC_MCM_SHAPER_RAMA_EXP_REGION_START_B, params->corner_points[0].blue.custom_float_x,
+		MPCC_MCM_SHAPER_RAMA_EXP_REGION_START_SEGMENT_B, 0);
+	REG_SET_2(MPCC_MCM_SHAPER_RAMB_START_CNTL_G[mpcc_id], 0,
+			MPCC_MCM_SHAPER_RAMA_EXP_REGION_START_B, params->corner_points[0].green.custom_float_x,
+			MPCC_MCM_SHAPER_RAMA_EXP_REGION_START_SEGMENT_B, 0);
+	REG_SET_2(MPCC_MCM_SHAPER_RAMB_START_CNTL_R[mpcc_id], 0,
+			MPCC_MCM_SHAPER_RAMA_EXP_REGION_START_B, params->corner_points[0].red.custom_float_x,
+			MPCC_MCM_SHAPER_RAMA_EXP_REGION_START_SEGMENT_B, 0);
 
-	curve += 2;
-	REG_SET_4(MPCC_MCM_SHAPER_RAMB_REGION_32_33[mpcc_id], 0,
+	REG_SET_2(MPCC_MCM_SHAPER_RAMB_END_CNTL_B[mpcc_id], 0,
+			MPCC_MCM_SHAPER_RAMA_EXP_REGION_END_B, params->corner_points[1].blue.custom_float_x,
+			MPCC_MCM_SHAPER_RAMA_EXP_REGION_END_BASE_B, params->corner_points[1].blue.custom_float_y);
+	REG_SET_2(MPCC_MCM_SHAPER_RAMB_END_CNTL_G[mpcc_id], 0,
+			MPCC_MCM_SHAPER_RAMA_EXP_REGION_END_B, params->corner_points[1].green.custom_float_x,
+			MPCC_MCM_SHAPER_RAMA_EXP_REGION_END_BASE_B, params->corner_points[1].green.custom_float_y);
+	REG_SET_2(MPCC_MCM_SHAPER_RAMB_END_CNTL_R[mpcc_id], 0,
+			MPCC_MCM_SHAPER_RAMA_EXP_REGION_END_B, params->corner_points[1].red.custom_float_x,
+			MPCC_MCM_SHAPER_RAMA_EXP_REGION_END_BASE_B, params->corner_points[1].red.custom_float_y);
+
+	curve = params->arr_curve_points;
+	if (curve) {
+		REG_SET_4(MPCC_MCM_SHAPER_RAMB_REGION_0_1[mpcc_id], 0,
 			MPCC_MCM_SHAPER_RAMA_EXP_REGION0_LUT_OFFSET, curve[0].offset,
 			MPCC_MCM_SHAPER_RAMA_EXP_REGION0_NUM_SEGMENTS, curve[0].segments_num,
 			MPCC_MCM_SHAPER_RAMA_EXP_REGION1_LUT_OFFSET, curve[1].offset,
 			MPCC_MCM_SHAPER_RAMA_EXP_REGION1_NUM_SEGMENTS, curve[1].segments_num);
+
+		curve += 2;
+		REG_SET_4(MPCC_MCM_SHAPER_RAMB_REGION_2_3[mpcc_id], 0,
+				MPCC_MCM_SHAPER_RAMA_EXP_REGION0_LUT_OFFSET, curve[0].offset,
+				MPCC_MCM_SHAPER_RAMA_EXP_REGION0_NUM_SEGMENTS, curve[0].segments_num,
+				MPCC_MCM_SHAPER_RAMA_EXP_REGION1_LUT_OFFSET, curve[1].offset,
+				MPCC_MCM_SHAPER_RAMA_EXP_REGION1_NUM_SEGMENTS, curve[1].segments_num);
+
+
+		curve += 2;
+		REG_SET_4(MPCC_MCM_SHAPER_RAMB_REGION_4_5[mpcc_id], 0,
+				MPCC_MCM_SHAPER_RAMA_EXP_REGION0_LUT_OFFSET, curve[0].offset,
+				MPCC_MCM_SHAPER_RAMA_EXP_REGION0_NUM_SEGMENTS, curve[0].segments_num,
+				MPCC_MCM_SHAPER_RAMA_EXP_REGION1_LUT_OFFSET, curve[1].offset,
+				MPCC_MCM_SHAPER_RAMA_EXP_REGION1_NUM_SEGMENTS, curve[1].segments_num);
+
+		curve += 2;
+		REG_SET_4(MPCC_MCM_SHAPER_RAMB_REGION_6_7[mpcc_id], 0,
+				MPCC_MCM_SHAPER_RAMA_EXP_REGION0_LUT_OFFSET, curve[0].offset,
+				MPCC_MCM_SHAPER_RAMA_EXP_REGION0_NUM_SEGMENTS, curve[0].segments_num,
+				MPCC_MCM_SHAPER_RAMA_EXP_REGION1_LUT_OFFSET, curve[1].offset,
+				MPCC_MCM_SHAPER_RAMA_EXP_REGION1_NUM_SEGMENTS, curve[1].segments_num);
+
+		curve += 2;
+		REG_SET_4(MPCC_MCM_SHAPER_RAMB_REGION_8_9[mpcc_id], 0,
+			MPCC_MCM_SHAPER_RAMA_EXP_REGION0_LUT_OFFSET, curve[0].offset,
+			MPCC_MCM_SHAPER_RAMA_EXP_REGION0_NUM_SEGMENTS, curve[0].segments_num,
+			MPCC_MCM_SHAPER_RAMA_EXP_REGION1_LUT_OFFSET, curve[1].offset,
+			MPCC_MCM_SHAPER_RAMA_EXP_REGION1_NUM_SEGMENTS, curve[1].segments_num);
+
+		curve += 2;
+		REG_SET_4(MPCC_MCM_SHAPER_RAMB_REGION_10_11[mpcc_id], 0,
+				MPCC_MCM_SHAPER_RAMA_EXP_REGION0_LUT_OFFSET, curve[0].offset,
+				MPCC_MCM_SHAPER_RAMA_EXP_REGION0_NUM_SEGMENTS, curve[0].segments_num,
+				MPCC_MCM_SHAPER_RAMA_EXP_REGION1_LUT_OFFSET, curve[1].offset,
+				MPCC_MCM_SHAPER_RAMA_EXP_REGION1_NUM_SEGMENTS, curve[1].segments_num);
+
+		curve += 2;
+		REG_SET_4(MPCC_MCM_SHAPER_RAMB_REGION_12_13[mpcc_id], 0,
+				MPCC_MCM_SHAPER_RAMA_EXP_REGION0_LUT_OFFSET, curve[0].offset,
+				MPCC_MCM_SHAPER_RAMA_EXP_REGION0_NUM_SEGMENTS, curve[0].segments_num,
+				MPCC_MCM_SHAPER_RAMA_EXP_REGION1_LUT_OFFSET, curve[1].offset,
+				MPCC_MCM_SHAPER_RAMA_EXP_REGION1_NUM_SEGMENTS, curve[1].segments_num);
+
+		curve += 2;
+		REG_SET_4(MPCC_MCM_SHAPER_RAMB_REGION_14_15[mpcc_id], 0,
+				MPCC_MCM_SHAPER_RAMA_EXP_REGION0_LUT_OFFSET, curve[0].offset,
+				MPCC_MCM_SHAPER_RAMA_EXP_REGION0_NUM_SEGMENTS, curve[0].segments_num,
+				MPCC_MCM_SHAPER_RAMA_EXP_REGION1_LUT_OFFSET, curve[1].offset,
+				MPCC_MCM_SHAPER_RAMA_EXP_REGION1_NUM_SEGMENTS, curve[1].segments_num);
+
+
+		curve += 2;
+		REG_SET_4(MPCC_MCM_SHAPER_RAMB_REGION_16_17[mpcc_id], 0,
+				MPCC_MCM_SHAPER_RAMA_EXP_REGION0_LUT_OFFSET, curve[0].offset,
+				MPCC_MCM_SHAPER_RAMA_EXP_REGION0_NUM_SEGMENTS, curve[0].segments_num,
+				MPCC_MCM_SHAPER_RAMA_EXP_REGION1_LUT_OFFSET, curve[1].offset,
+				MPCC_MCM_SHAPER_RAMA_EXP_REGION1_NUM_SEGMENTS, curve[1].segments_num);
+
+		curve += 2;
+		REG_SET_4(MPCC_MCM_SHAPER_RAMB_REGION_18_19[mpcc_id], 0,
+				MPCC_MCM_SHAPER_RAMA_EXP_REGION0_LUT_OFFSET, curve[0].offset,
+				MPCC_MCM_SHAPER_RAMA_EXP_REGION0_NUM_SEGMENTS, curve[0].segments_num,
+				MPCC_MCM_SHAPER_RAMA_EXP_REGION1_LUT_OFFSET, curve[1].offset,
+				MPCC_MCM_SHAPER_RAMA_EXP_REGION1_NUM_SEGMENTS, curve[1].segments_num);
+
+		curve += 2;
+		REG_SET_4(MPCC_MCM_SHAPER_RAMB_REGION_20_21[mpcc_id], 0,
+				MPCC_MCM_SHAPER_RAMA_EXP_REGION0_LUT_OFFSET, curve[0].offset,
+				MPCC_MCM_SHAPER_RAMA_EXP_REGION0_NUM_SEGMENTS, curve[0].segments_num,
+				MPCC_MCM_SHAPER_RAMA_EXP_REGION1_LUT_OFFSET, curve[1].offset,
+				MPCC_MCM_SHAPER_RAMA_EXP_REGION1_NUM_SEGMENTS, curve[1].segments_num);
+
+		curve += 2;
+		REG_SET_4(MPCC_MCM_SHAPER_RAMB_REGION_22_23[mpcc_id], 0,
+				MPCC_MCM_SHAPER_RAMA_EXP_REGION0_LUT_OFFSET, curve[0].offset,
+				MPCC_MCM_SHAPER_RAMA_EXP_REGION0_NUM_SEGMENTS, curve[0].segments_num,
+				MPCC_MCM_SHAPER_RAMA_EXP_REGION1_LUT_OFFSET, curve[1].offset,
+				MPCC_MCM_SHAPER_RAMA_EXP_REGION1_NUM_SEGMENTS, curve[1].segments_num);
+
+		curve += 2;
+		REG_SET_4(MPCC_MCM_SHAPER_RAMB_REGION_24_25[mpcc_id], 0,
+				MPCC_MCM_SHAPER_RAMA_EXP_REGION0_LUT_OFFSET, curve[0].offset,
+				MPCC_MCM_SHAPER_RAMA_EXP_REGION0_NUM_SEGMENTS, curve[0].segments_num,
+				MPCC_MCM_SHAPER_RAMA_EXP_REGION1_LUT_OFFSET, curve[1].offset,
+				MPCC_MCM_SHAPER_RAMA_EXP_REGION1_NUM_SEGMENTS, curve[1].segments_num);
+
+		curve += 2;
+		REG_SET_4(MPCC_MCM_SHAPER_RAMB_REGION_26_27[mpcc_id], 0,
+				MPCC_MCM_SHAPER_RAMA_EXP_REGION0_LUT_OFFSET, curve[0].offset,
+				MPCC_MCM_SHAPER_RAMA_EXP_REGION0_NUM_SEGMENTS, curve[0].segments_num,
+				MPCC_MCM_SHAPER_RAMA_EXP_REGION1_LUT_OFFSET, curve[1].offset,
+				MPCC_MCM_SHAPER_RAMA_EXP_REGION1_NUM_SEGMENTS, curve[1].segments_num);
+
+		curve += 2;
+		REG_SET_4(MPCC_MCM_SHAPER_RAMB_REGION_28_29[mpcc_id], 0,
+				MPCC_MCM_SHAPER_RAMA_EXP_REGION0_LUT_OFFSET, curve[0].offset,
+				MPCC_MCM_SHAPER_RAMA_EXP_REGION0_NUM_SEGMENTS, curve[0].segments_num,
+				MPCC_MCM_SHAPER_RAMA_EXP_REGION1_LUT_OFFSET, curve[1].offset,
+				MPCC_MCM_SHAPER_RAMA_EXP_REGION1_NUM_SEGMENTS, curve[1].segments_num);
+
+		curve += 2;
+		REG_SET_4(MPCC_MCM_SHAPER_RAMB_REGION_30_31[mpcc_id], 0,
+				MPCC_MCM_SHAPER_RAMA_EXP_REGION0_LUT_OFFSET, curve[0].offset,
+				MPCC_MCM_SHAPER_RAMA_EXP_REGION0_NUM_SEGMENTS, curve[0].segments_num,
+				MPCC_MCM_SHAPER_RAMA_EXP_REGION1_LUT_OFFSET, curve[1].offset,
+				MPCC_MCM_SHAPER_RAMA_EXP_REGION1_NUM_SEGMENTS, curve[1].segments_num);
+
+		curve += 2;
+		REG_SET_4(MPCC_MCM_SHAPER_RAMB_REGION_32_33[mpcc_id], 0,
+				MPCC_MCM_SHAPER_RAMA_EXP_REGION0_LUT_OFFSET, curve[0].offset,
+				MPCC_MCM_SHAPER_RAMA_EXP_REGION0_NUM_SEGMENTS, curve[0].segments_num,
+				MPCC_MCM_SHAPER_RAMA_EXP_REGION1_LUT_OFFSET, curve[1].offset,
+				MPCC_MCM_SHAPER_RAMA_EXP_REGION1_NUM_SEGMENTS, curve[1].segments_num);
+	}
 }
 
 
-- 
2.39.5

