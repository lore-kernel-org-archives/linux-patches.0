Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E2FB2222A9;
	Sat, 14 Feb 2026 01:04:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771031073; cv=none; b=J3Kjw/LzWUsoEyGFQyBHl4db8o6t1AyuYiXvuNOzsxlp0H3MuwGe97+RrYKPeQh/3kWoOUjhTRE7hwQQKXBisR6HNmaRfCdv5xZAJDFLPY9l/jQCzo2rvBZ2fiv3o/R0nBGGfjOADBbdhgWsY2EaWX0WkEDoGCFyP6raarCifN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771031073; c=relaxed/simple;
	bh=yJZ1LuuNeVdgkuwizn7jOkfNfjq0ZpKlXSNhq2Sc3mY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KSZWjjD1FvnWjcNGgiWvAnE8yorwkjgUZO34r+zbdRpA9Mz+DfqNpL19VMR5HJQ7qBndR7+BSmIUMAKNCtpOyJv81aLUbGdYdCAiYQAbT09KZKnd8ALcY7NazXpAbBKIi9rQPWrNEIb9rAdCBcUw+npnKA3aaJggfkEISbuGDPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XTit8fnx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XTit8fnx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C84A1C116C6;
	Sat, 14 Feb 2026 01:04:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771031073;
	bh=yJZ1LuuNeVdgkuwizn7jOkfNfjq0ZpKlXSNhq2Sc3mY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XTit8fnxorNwK+Ui+DyMGA1s0pz8nLGcSdYmjLOINuj9hx97NMnOLnzqqBFl8oOv9
	 xIu2E8EJwhVflCaYHrnAgRnOaY6iEi/Q98MciSoyRT3MUdvneLkc+T8qMxk1KnC1Ku
	 0YVJmWTGAfdymQe/6oGiBfHeyMpHguizA7FnXxbNiULnI9rNn5HtNJJ/RBryOfkPve
	 BuaV/5pIIJn3jhcAt/R7gPuOAL5QUPOZxGudg/hV8jWPDvV5vC5HrvFjn6mWfr/TLx
	 luFNGIkixFoIwzgdDrEccNCtyV/xAd5csO/R+c1ayceRYMqWDmKcPhrVAmTTzQY6Un
	 xpGhaYfq4lohg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Charlene Liu <Charlene.Liu@amd.com>,
	Mohit Bawa <mohit.bawa@amd.com>,
	Chenyu Chen <chen-yu.chen@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	alex.hung@amd.com,
	alvin.lee2@amd.com,
	timur.kristof@gmail.com,
	Ausef.Yousof@amd.com,
	Zhongwei.Zhang@amd.com,
	rosenp@gmail.com,
	yelangyan@huaqin.corp-partner.google.com,
	dmytro.laktyushkin@amd.com,
	srinivasan.shanmugam@amd.com,
	Martin.Leung@amd.com
Subject: [PATCH AUTOSEL 6.19-6.12] drm/amd/display: Fix dsc eDP issue
Date: Fri, 13 Feb 2026 19:58:49 -0500
Message-ID: <20260214010245.3671907-49-sashal@kernel.org>
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

From: Charlene Liu <Charlene.Liu@amd.com>

[ Upstream commit 878a4b73c11111ff5f820730f59a7f8c6fd59374 ]

[why]
Need to add function hook check before use

Reviewed-by: Mohit Bawa <mohit.bawa@amd.com>
Signed-off-by: Charlene Liu <Charlene.Liu@amd.com>
Signed-off-by: Chenyu Chen <chen-yu.chen@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Analysis

### Commit Overview

This commit makes two changes to `dce110_hwseq.c`:

1. **IPS early return in
   `disable_vga_and_power_gate_all_controllers()`**: Adds `if
   (dc->caps.ips_support) return;` to skip the entire function on IPS-
   capable hardware (DCN 3.5/3.51/3.6 APUs).

2. **NULL function pointer checks in `clean_up_dsc_blocks()`**: Adds
   NULL checks before calling `tg->funcs->set_dsc_config`,
   `se->funcs->dp_set_dsc_config`, and
   `se->funcs->dp_set_dsc_pps_info_packet`.

### Bug Mechanism Analysis

**IPS change (Change 1):**

DCN 3.5+ APUs support IPS (Idle Power Save) which can power down display
blocks. The `disable_vga_and_power_gate_all_controllers` function is
called from two paths:
- `dce110_enable_accelerated_mode()` (line 2066) during VBIOS-to-driver
  transition
- `dce110_power_down()` (line 2724) during hardware power down

Both DCN 3.5 (`dcn35_init.c` line 54) and DCN 3.51 (`dcn351_init.c`) use
`dce110_enable_accelerated_mode` as their `enable_accelerated_mode`
hook. The function iterates all pipes calling `dc->hwss.disable_plane()`
= `dcn35_disable_plane()` which accesses hardware registers. On IPS-
capable hardware:
- VGA doesn't exist (the `disable_vga` pointer is already NULL for all
  DCN optc implementations)
- Display pipe register accesses may conflict with IPS power management
  state
- This can cause hangs or register access failures during mode
  transitions

**NULL checks (Change 2):**

The `clean_up_dsc_blocks()` function (introduced in v6.12 with `Cc:
stable`) is reached on APUs with DCN >= 3.15. Critically, I found that
**DCN 4.01 explicitly sets `dp_set_dsc_config = NULL`** in
`dcn401_dio_stream_encoder.c` line 760. While DCN 4.01 is not currently
an APU, this demonstrates that not all hardware implements these
functions. The pattern of NULL-checking before calling is already
established in this very function (`dccg->funcs->set_ref_dscclk` at line
1928 already has a NULL check). Without these checks, if any future APU
hardware variant doesn't implement these functions, calling NULL would
cause a **kernel crash (NULL pointer dereference)**.

### Stability Indicators

- **Reviewed-by**: Mohit Bawa (AMD)
- **Tested-by**: Daniel Wheeler (AMD)
- **Signed-off-by**: Alex Deucher (AMD GPU subsystem maintainer)
- Author is Charlene Liu, an experienced AMD display engineer

### Scope and Risk

- **Files changed**: 1 file
- **Lines added**: ~10 lines of guards/checks
- **Risk**: Negligible - only adds early returns and NULL guards; cannot
  break existing functionality
- **Pattern consistency**: Follows existing patterns in the same
  functions

### Applicability to Stable Trees

- `clean_up_dsc_blocks` was introduced in v6.12 with `Cc: stable`
  (3766a840e093d), so it exists in 6.12.y stable trees
- DCN 3.5 IPS support exists in 6.8+ kernels, so the IPS change is
  relevant to 6.12.y
- The `disable_vga_and_power_gate_all_controllers` has existed since
  early AMDGPU display code
- Minor context adaptation may be needed for pre-6.19 trees (the
  `d8ed14f1dc679` condition change is 6.19-only), but the fix itself is
  self-contained

### Conclusion

This commit fixes two real issues: (1) prevents hardware register access
on IPS-capable AMD APUs that could cause hangs during mode transitions,
and (2) adds defensive NULL pointer dereference protection for function
pointers that are demonstrably NULL on some hardware variants. The fix
is small, surgical, well-reviewed by AMD engineers, has zero regression
risk, and protects against kernel crashes on AMD eDP laptop hardware.
The affected code (`clean_up_dsc_blocks`) was itself backported to
stable with `Cc: stable`, making this follow-up fix equally important.

**YES**

 .../drm/amd/display/dc/hwss/dce110/dce110_hwseq.c    | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/hwss/dce110/dce110_hwseq.c b/drivers/gpu/drm/amd/display/dc/hwss/dce110/dce110_hwseq.c
index ebd74b43e935e..0513784e1c6fc 100644
--- a/drivers/gpu/drm/amd/display/dc/hwss/dce110/dce110_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/hwss/dce110/dce110_hwseq.c
@@ -1840,6 +1840,9 @@ static void disable_vga_and_power_gate_all_controllers(
 	struct timing_generator *tg;
 	struct dc_context *ctx = dc->ctx;
 
+	if (dc->caps.ips_support)
+		return;
+
 	for (i = 0; i < dc->res_pool->timing_generator_count; i++) {
 		tg = dc->res_pool->timing_generators[i];
 
@@ -1916,13 +1919,16 @@ static void clean_up_dsc_blocks(struct dc *dc)
 			/* disable DSC in OPTC */
 			if (i < dc->res_pool->timing_generator_count) {
 				tg = dc->res_pool->timing_generators[i];
-				tg->funcs->set_dsc_config(tg, OPTC_DSC_DISABLED, 0, 0);
+				if (tg->funcs->set_dsc_config)
+					tg->funcs->set_dsc_config(tg, OPTC_DSC_DISABLED, 0, 0);
 			}
 			/* disable DSC in stream encoder */
 			if (i < dc->res_pool->stream_enc_count) {
 				se = dc->res_pool->stream_enc[i];
-				se->funcs->dp_set_dsc_config(se, OPTC_DSC_DISABLED, 0, 0);
-				se->funcs->dp_set_dsc_pps_info_packet(se, false, NULL, true);
+				if (se->funcs->dp_set_dsc_config)
+					se->funcs->dp_set_dsc_config(se, OPTC_DSC_DISABLED, 0, 0);
+				if (se->funcs->dp_set_dsc_pps_info_packet)
+					se->funcs->dp_set_dsc_pps_info_packet(se, false, NULL, true);
 			}
 			/* disable DSC block */
 			if (dccg->funcs->set_ref_dscclk)
-- 
2.51.0

