Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B41617B506;
	Sat, 14 Feb 2026 01:05:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771031156; cv=none; b=p2ok/xGutjVXN6CAJCzUS4XqNPDPunbwBB3x/KtNguLElcdXJtRRfbtVXkO5FnPdkbr+E66NevpGu8CuTQTt9u1ExXhDPXNDhAqOVaxafhx3CPryT/a+vRsvGFMHViLEjfUM9fi7Cqvd5CJRxmU+ynS0iLxgi+bxBWaQMlA+3a8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771031156; c=relaxed/simple;
	bh=dRWWbo5VlETQnWFFHtIxKeQkAiJbmuuu3MZjF5yVe3U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YME5EqFAI5Qn4HGls95fsogMaSkVUosWadU5GTad4pJweJIRDKtKG3dRNKsxnLDPUChRNsV4zPw+g7IBVDNz4A1Qh08Q8gqTyRvgm8SR8EhQDq/tGbKqrPNL8BqCIg2l7t/1DdCZcT29PGiZFSUrPsuj4F2OhABGv0lqqqj4buA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BDJu9vpa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BDJu9vpa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4DECC116C6;
	Sat, 14 Feb 2026 01:05:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771031156;
	bh=dRWWbo5VlETQnWFFHtIxKeQkAiJbmuuu3MZjF5yVe3U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BDJu9vpaOEwoC54PQ2/Z9/gBCSPPlxj9DXAqJR826tn4msH93q3g+3H5HEL+JRBep
	 h22taW/mWTZRZqLpb0AT0ErT94hTV3WJ/XQCQbfly+2+psxHApydCZAkNXvWB7fTYH
	 mWCrXOhuT2BEvGxM1uEEPI4y7wgw6S2d3nPJ2aSCBtn7v73DE2scXSOGz/rrOEPxjh
	 Eh7Mds/WUgc4T1nAQiGukw2As1c1TX7min9AsgmxiTm6vSpkMy1y5bXcTUr0K456S1
	 +/Ovk1kLwIfySwug2FdOExUcJvRcoEfFhtBsrTlZmo0WVgXet+V6ToIntPOG1Yc+Ys
	 WnZBbIRQsollQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Relja Vojvodic <rvojvodi@amd.com>,
	Chris Park <chris.park@amd.com>,
	Wenjing Liu <wenjing.liu@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Dan Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	ivan.lipski@amd.com,
	sunpeng.li@amd.com,
	Paul.Hsieh@amd.com,
	yelangyan@huaqin.corp-partner.google.com,
	Wesley.Chalmers@amd.com,
	ray.wu@amd.com,
	zaeem.mohamed@amd.com,
	mwen@igalia.com,
	ovidiu.bunea@amd.com,
	Ilya.Bakoulin@amd.com,
	meenakshikumar.somasundaram@amd.com,
	nicholas.kazlauskas@amd.com,
	wayne.lin@amd.com,
	Cruise.Hung@amd.com,
	charlene.liu@amd.com,
	harry.wentland@amd.com,
	PeiChen.Huang@amd.com,
	timur.kristof@gmail.com,
	Derek.Lai@amd.com,
	superm1@kernel.org,
	alvin.lee2@amd.com,
	dillon.varone@amd.com,
	dominik.kaszewski@amd.com,
	aurabindo.pillai@amd.com,
	yan.li@amd.com,
	ryanseto@amd.com
Subject: [PATCH AUTOSEL 6.19] drm/amd/display: Correct DSC padding accounting
Date: Fri, 13 Feb 2026 19:59:23 -0500
Message-ID: <20260214010245.3671907-83-sashal@kernel.org>
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

From: Relja Vojvodic <rvojvodi@amd.com>

[ Upstream commit c7062be3380cb20c8b1c4a935a13f1848ead0719 ]

[WHY]
- After the addition of all OVT patches, DSC padding was being accounted
  for multiple times, effectively doubling the padding
- This caused compliance failures or corruption

[HOW]
- Add padding to DSC pic width when required by HW, and do not re-add
  when calculating reg values
- Do not add padding when computing PPS values, and instead track padding
  separately to add when calculating slice width values

Reviewed-by: Chris Park <chris.park@amd.com>
Reviewed-by: Wenjing Liu <wenjing.liu@amd.com>
Signed-off-by: Relja Vojvodic <rvojvodi@amd.com>
Signed-off-by: Alex Hung <alex.hung@amd.com>
Tested-by: Dan Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have a complete picture. Let me write up the analysis.

---

## Detailed Analysis: "drm/amd/display: Correct DSC padding accounting"

### 1. COMMIT MESSAGE ANALYSIS

The commit message is clear and structured (AMD's [WHY]/[HOW] format):
- **Problem**: After the addition of "all OVT patches," DSC padding was
  being accounted for multiple times, effectively doubling the padding.
- **Symptom**: "compliance failures or corruption" — this means real
  display corruption visible to users and failure of DSC standard
  compliance tests.
- **Fix approach**: Separate where padding is applied. Add it to
  `pic_width` for HW register programming (where needed), set
  `dsc_padding = 0` to avoid double-counting in `dsc_prepare_config()`,
  and keep separate padding tracking for slice width computations in the
  PPS path.

Strong review/testing tags: Reviewed-by (2 AMD engineers), Tested-by
(AMD QA).

### 2. CODE CHANGE ANALYSIS — THE BUG

The bug was introduced by the interaction of two commits:

**Commit 1: `edae98a2bdf25d` (v6.18-rc1)** — "Add DSC padding for OVT
Support"
This added `dsc_padding_params.dsc_hactive_padding` to
`dsc_cfg.pic_width` in the DCN 3.2 and `link_dpms` paths. In v6.18, the
`struct dsc_config` had no `dsc_padding` field. The slice_width in
`dsc_prepare_config()` was calculated as:

```c
slice_width = (pic_width + num_slices_h - 1) / num_slices_h  // ceiling
division
```

Since `pic_width` already included padding, this was correct.

**Commit 2: `81557c96c8a17` (v6.19-rc1)** — "Correct slice width
calculation for YCbCr420"
This added a new `dsc_padding` field to `struct dsc_config` and changed
the slice_width calculation in `dsc_prepare_config()` to:

```c
slice_width = (pic_width + dsc_padding + num_slices_h - 1) /
num_slices_h
```

It also set `dsc_cfg.dsc_padding =
pipe_ctx->dsc_padding_params.dsc_hactive_padding` in ALL hwseq paths
(dcn314, dcn32, dcn35, link_dpms, dcn20_resource). **But it didn't
remove padding from `pic_width` where it was already present.** This
created the double-counting:

- **DCN 3.2 / link_dpms paths**: `pic_width` includes
  `dsc_hactive_padding` (from OVT commit) AND `dsc_padding =
  dsc_hactive_padding` → padding counted **twice** in slice_width.
- **DCN 3.1.4 / DCN 3.5 paths**: `pic_width` does NOT include
  `dsc_hactive_padding`, `dsc_padding = dsc_hactive_padding` → padding
  counted once (correct, but these HW generations don't use OVT padding,
  so `dsc_hactive_padding = 0` anyway).

### 3. HOW THE FIX WORKS

The fix corrects the accounting across 5 files:

1. **`dcn314_hwseq.c`**: Sets `dsc_cfg.dsc_padding = 0` (was
   `dsc_hactive_padding`). DCN 3.1.4 doesn't use OVT padding, so this is
   a no-op safety fix.

2. **`dcn32_hwseq.c`**: Sets `dsc_cfg.dsc_padding = 0` (was
   `dsc_hactive_padding`). `pic_width` already includes padding. **Fixes
   the double-counting.**

3. **`dcn35_hwseq.c`**: Sets `dsc_cfg.dsc_padding = 0` (was
   `dsc_hactive_padding`). DCN 3.5 doesn't use OVT padding, so this is a
   no-op safety fix.

4. **`link_dpms.c` (`link_set_dsc_on_stream`)**: Sets
   `dsc_cfg.dsc_padding = 0` (was `dsc_hactive_padding`). `pic_width`
   already includes padding. Moves the `dsc_cfg.dsc_padding =
   dsc_hactive_padding` assignment to AFTER `dsc_set_config()` is called
   (preserving the value for any later use). **Fixes the double-
   counting.**

5. **`dcn20_resource.c` (`dcn20_validate_dsc`)**: Adds padding to
   `pic_width` AND sets `dsc_padding = 0`. This ensures validation uses
   the same parameters as actual HW programming. Previously, `pic_width`
   was missing padding while `dsc_padding` had it — meaning validation
   computed different parameters than what HW would use.

### 4. THE PPS PATH IS CORRECT

In `link_set_dsc_pps_packet()` (which computes PPS to send to the
display):
- `pic_width` does NOT include padding (correct — PPS tells the display
  the real picture width)
- `dsc_padding` IS set (correct — used for slice_width calculation in
  PPS)
This path was already correct and is NOT changed by this commit.

### 5. CLASSIFICATION

This is a **clear bug fix** — it corrects a display
corruption/compliance failure caused by double-counting padding values
in DSC configuration. This is NOT a feature, cleanup, or optimization.

### 6. SCOPE AND RISK

- **Files changed**: 5 files
- **Lines changed**: ~10 effective lines (same pattern repeated)
- **Change pattern**: Setting a field to 0, and one addition of padding
  to `pic_width` in validation
- **Risk**: Very LOW. The change is mechanical and well-understood.
  Setting `dsc_padding = 0` cannot break anything when `pic_width`
  already includes the padding.

### 7. USER IMPACT

- **Affects**: Users with AMD GPUs (DCN 3.2+) using DSC compression with
  OVT timings
- **Symptom**: Display corruption and/or compliance test failures
- **Severity**: HIGH — display corruption is a user-visible regression

### 8. DEPENDENCY CHECK

The bug was introduced by commit `81557c96c8a17` which went into
v6.19-rc1. It depends on:
- The `dsc_padding` field in `struct dsc_config` (added by
  `81557c96c8a17` in v6.19)
- The `dsc_padding_params` infrastructure (added by `edae98a2bdf25d` in
  v6.18)

For **v6.19.y stable**: Both dependencies exist. The fix should apply
cleanly.
For **v6.18.y and earlier**: The `dsc_padding` field doesn't exist in
`struct dsc_config`, so the bug doesn't exist and the fix is not needed.

### 9. NOTE ON INCOMPLETE FIX

The `dc_hw_sequencer.c` path (`hwss_dsc_calculate_and_set_config`, used
only by DCN 4.01) has the same double-counting pattern but is NOT fixed
by this commit. This may be addressed in a separate patch, or DCN 4.01
may handle this differently.

### 10. CONCLUSION

This commit fixes a clear regression introduced in v6.19 — DSC padding
double-counting that causes display corruption and compliance failures
on AMD hardware. The fix is small, surgical, well-reviewed, and well-
tested. It meets all stable kernel criteria:
- Obviously correct and tested
- Fixes a real bug (display corruption)
- Small and contained
- No new features
- Applies cleanly to v6.19.y

**YES**

 drivers/gpu/drm/amd/display/dc/hwss/dcn314/dcn314_hwseq.c   | 2 +-
 drivers/gpu/drm/amd/display/dc/hwss/dcn32/dcn32_hwseq.c     | 2 +-
 drivers/gpu/drm/amd/display/dc/hwss/dcn35/dcn35_hwseq.c     | 2 +-
 drivers/gpu/drm/amd/display/dc/link/link_dpms.c             | 3 ++-
 .../gpu/drm/amd/display/dc/resource/dcn20/dcn20_resource.c  | 6 +++---
 5 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/hwss/dcn314/dcn314_hwseq.c b/drivers/gpu/drm/amd/display/dc/hwss/dcn314/dcn314_hwseq.c
index 4ee6ed610de0b..3e239124c17d8 100644
--- a/drivers/gpu/drm/amd/display/dc/hwss/dcn314/dcn314_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/hwss/dcn314/dcn314_hwseq.c
@@ -108,7 +108,7 @@ static void update_dsc_on_stream(struct pipe_ctx *pipe_ctx, bool enable)
 		dsc_cfg.dc_dsc_cfg = stream->timing.dsc_cfg;
 		ASSERT(dsc_cfg.dc_dsc_cfg.num_slices_h % opp_cnt == 0);
 		dsc_cfg.dc_dsc_cfg.num_slices_h /= opp_cnt;
-		dsc_cfg.dsc_padding = pipe_ctx->dsc_padding_params.dsc_hactive_padding;
+		dsc_cfg.dsc_padding = 0;
 
 		dsc->funcs->dsc_set_config(dsc, &dsc_cfg, &dsc_optc_cfg);
 		dsc->funcs->dsc_enable(dsc, pipe_ctx->stream_res.opp->inst);
diff --git a/drivers/gpu/drm/amd/display/dc/hwss/dcn32/dcn32_hwseq.c b/drivers/gpu/drm/amd/display/dc/hwss/dcn32/dcn32_hwseq.c
index be1f3caf4096f..24af5e94c7fce 100644
--- a/drivers/gpu/drm/amd/display/dc/hwss/dcn32/dcn32_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/hwss/dcn32/dcn32_hwseq.c
@@ -1063,7 +1063,7 @@ void dcn32_update_dsc_on_stream(struct pipe_ctx *pipe_ctx, bool enable)
 		dsc_cfg.dc_dsc_cfg = stream->timing.dsc_cfg;
 		ASSERT(dsc_cfg.dc_dsc_cfg.num_slices_h % opp_cnt == 0);
 		dsc_cfg.dc_dsc_cfg.num_slices_h /= opp_cnt;
-		dsc_cfg.dsc_padding = pipe_ctx->dsc_padding_params.dsc_hactive_padding;
+		dsc_cfg.dsc_padding = 0;
 
 		if (should_use_dto_dscclk)
 			dccg->funcs->set_dto_dscclk(dccg, dsc->inst, dsc_cfg.dc_dsc_cfg.num_slices_h);
diff --git a/drivers/gpu/drm/amd/display/dc/hwss/dcn35/dcn35_hwseq.c b/drivers/gpu/drm/amd/display/dc/hwss/dcn35/dcn35_hwseq.c
index 7aa0f452e8f7a..cb2dfd34b5e2e 100644
--- a/drivers/gpu/drm/amd/display/dc/hwss/dcn35/dcn35_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/hwss/dcn35/dcn35_hwseq.c
@@ -364,7 +364,7 @@ static void update_dsc_on_stream(struct pipe_ctx *pipe_ctx, bool enable)
 		dsc_cfg.dc_dsc_cfg = stream->timing.dsc_cfg;
 		ASSERT(dsc_cfg.dc_dsc_cfg.num_slices_h % opp_cnt == 0);
 		dsc_cfg.dc_dsc_cfg.num_slices_h /= opp_cnt;
-		dsc_cfg.dsc_padding = pipe_ctx->dsc_padding_params.dsc_hactive_padding;
+		dsc_cfg.dsc_padding = 0;
 
 		dsc->funcs->dsc_set_config(dsc, &dsc_cfg, &dsc_optc_cfg);
 		dsc->funcs->dsc_enable(dsc, pipe_ctx->stream_res.opp->inst);
diff --git a/drivers/gpu/drm/amd/display/dc/link/link_dpms.c b/drivers/gpu/drm/amd/display/dc/link/link_dpms.c
index 6ae1341476171..a6f1b3569f6f5 100644
--- a/drivers/gpu/drm/amd/display/dc/link/link_dpms.c
+++ b/drivers/gpu/drm/amd/display/dc/link/link_dpms.c
@@ -841,7 +841,7 @@ void link_set_dsc_on_stream(struct pipe_ctx *pipe_ctx, bool enable)
 		dsc_cfg.dc_dsc_cfg = stream->timing.dsc_cfg;
 		ASSERT(dsc_cfg.dc_dsc_cfg.num_slices_h % opp_cnt == 0);
 		dsc_cfg.dc_dsc_cfg.num_slices_h /= opp_cnt;
-		dsc_cfg.dsc_padding = pipe_ctx->dsc_padding_params.dsc_hactive_padding;
+		dsc_cfg.dsc_padding = 0;
 
 		if (should_use_dto_dscclk)
 			dccg->funcs->set_dto_dscclk(dccg, dsc->inst, dsc_cfg.dc_dsc_cfg.num_slices_h);
@@ -857,6 +857,7 @@ void link_set_dsc_on_stream(struct pipe_ctx *pipe_ctx, bool enable)
 		}
 		dsc_cfg.dc_dsc_cfg.num_slices_h *= opp_cnt;
 		dsc_cfg.pic_width *= opp_cnt;
+		dsc_cfg.dsc_padding = pipe_ctx->dsc_padding_params.dsc_hactive_padding;
 
 		optc_dsc_mode = dsc_optc_cfg.is_pixel_format_444 ? OPTC_DSC_ENABLED_444 : OPTC_DSC_ENABLED_NATIVE_SUBSAMPLED;
 
diff --git a/drivers/gpu/drm/amd/display/dc/resource/dcn20/dcn20_resource.c b/drivers/gpu/drm/amd/display/dc/resource/dcn20/dcn20_resource.c
index 6679c1a14f2fe..8d10aac9c510c 100644
--- a/drivers/gpu/drm/amd/display/dc/resource/dcn20/dcn20_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/resource/dcn20/dcn20_resource.c
@@ -1660,8 +1660,8 @@ bool dcn20_validate_dsc(struct dc *dc, struct dc_state *new_ctx)
 		if (pipe_ctx->top_pipe || pipe_ctx->prev_odm_pipe || !stream || !stream->timing.flags.DSC)
 			continue;
 
-		dsc_cfg.pic_width = (stream->timing.h_addressable + stream->timing.h_border_left
-				+ stream->timing.h_border_right) / opp_cnt;
+		dsc_cfg.pic_width = (stream->timing.h_addressable + pipe_ctx->dsc_padding_params.dsc_hactive_padding
+				+ stream->timing.h_border_left + stream->timing.h_border_right) / opp_cnt;
 		dsc_cfg.pic_height = stream->timing.v_addressable + stream->timing.v_border_top
 				+ stream->timing.v_border_bottom;
 		dsc_cfg.pixel_encoding = stream->timing.pixel_encoding;
@@ -1669,7 +1669,7 @@ bool dcn20_validate_dsc(struct dc *dc, struct dc_state *new_ctx)
 		dsc_cfg.is_odm = pipe_ctx->next_odm_pipe ? true : false;
 		dsc_cfg.dc_dsc_cfg = stream->timing.dsc_cfg;
 		dsc_cfg.dc_dsc_cfg.num_slices_h /= opp_cnt;
-		dsc_cfg.dsc_padding = pipe_ctx->dsc_padding_params.dsc_hactive_padding;
+		dsc_cfg.dsc_padding = 0;
 
 		if (!pipe_ctx->stream_res.dsc->funcs->dsc_validate_stream(pipe_ctx->stream_res.dsc, &dsc_cfg))
 			return false;
-- 
2.51.0

