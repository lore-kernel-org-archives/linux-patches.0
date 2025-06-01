Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C02F2D3208;
	Sun,  1 Jun 2025 23:35:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748820938; cv=none; b=mcDbdmW8oXGBmP4+xd8E58JtX3idFmcKkjqgZOWVVi+L+NWmfoCytl/leIb0UMDxu5L7qV5enLv2tsfvrLn2xXeymGh7f1hFXMuA/8QsZEH1x7pavyzFrliy968ZpGpyqQZOUiV2Hqq29WywdauE1GGQDfHZzbxWsnEUzoG4UkQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748820938; c=relaxed/simple;
	bh=rs6zMvVHLN8bc5zfPCbkA0UUwGf378gzYnayt6OwLYg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=PKGu2GY9CFSLqb6+E3RN+z81WKRJ22Y/mVXK3w0NUF8dhi8tVv5CF4PxQpwiGpj2jYK7HuLTaa/pCSoMzTpzl+hbBkobwCHs/VtjLElNboXz4OLeAHf+MNfxvJO5Nkspung2zARTIdQeYAMmvkLlwILwFz/G3FPpU4zGJfOU6t4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nXSjp2ss; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nXSjp2ss"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF704C4CEE7;
	Sun,  1 Jun 2025 23:35:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748820937;
	bh=rs6zMvVHLN8bc5zfPCbkA0UUwGf378gzYnayt6OwLYg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nXSjp2ss3YUP2IVwz1n+nqhtJ5w9sPtnGyMjyreXvb3sNISgSOgi0pjM+50ud7Bk/
	 8QORnsCUFXZaWZTNOlpU8kh8WUnEAtE2JDz/ImVGBu67TcbTJIerpuNa1yHY/w3h1R
	 kzxPWjdBg8L/denjzE1gPgVK/bqQWOMy5u053yc8M20EvmoG6yViJVFlLpukUAEA63
	 BLb7tZnNXRhyqVx3e7VEUZNS+w/ODb4ROP/BkxgONccoxyJ1R/9tmIHFO9hkhOo7MY
	 cl4GM43itxK3tiv3Pp7YbY6nwF7RFF5VPXPilc9OAZRoROE9pKfmAidtOZ8Vi3pzF0
	 Y9uiuPqnpcsQg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Charlene Liu <Charlene.Liu@amd.com>,
	Ovidiu Bunea <ovidiu.bunea@amd.com>,
	Aurabindo Pillai <aurabindo.pillai@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	austin.zheng@amd.com,
	jun.lei@amd.com,
	harry.wentland@amd.com,
	sunpeng.li@amd.com,
	christian.koenig@amd.com,
	airlied@gmail.com,
	simona@ffwll.ch,
	amd-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.12 38/93] drm/amd/display: fix zero value for APU watermark_c
Date: Sun,  1 Jun 2025 19:33:05 -0400
Message-Id: <20250601233402.3512823-38-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250601233402.3512823-1-sashal@kernel.org>
References: <20250601233402.3512823-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.12.31
Content-Transfer-Encoding: 8bit

From: Charlene Liu <Charlene.Liu@amd.com>

[ Upstream commit d5a7fdc88a2d64242d959942cbd0e1499ebb9806 ]

[why]
the guard of is_apu not in sync, caused no watermark_c output.

Reviewed-by: Ovidiu Bunea <ovidiu.bunea@amd.com>
Signed-off-by: Charlene Liu <Charlene.Liu@amd.com>
Signed-off-by: Aurabindo Pillai <aurabindo.pillai@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

**YES** This commit should be backported to stable kernel trees. Here's
my extensive analysis: ## Bug Analysis The commit fixes a critical bug
in AMD display driver's watermark handling for APU (Accelerated
Processing Unit) systems. The issue is in the
`dml2_validate_and_build_resource` function where watermark_c was being
incorrectly populated for APU systems. ## Problem Description **Before
the fix:** ```c memcpy(&context->bw_ctx.bw.dcn.watermarks.c,
&dml2->v20.g6_temp_read_watermark_set,
sizeof(context->bw_ctx.bw.dcn.watermarks.c)); ``` **After the fix:**
```c if (context->streams[0]->sink->link->dc->caps.is_apu)
dml2_extract_watermark_set(&context->bw_ctx.bw.dcn.watermarks.c,
&dml2->v20.dml_core_ctx); else
memcpy(&context->bw_ctx.bw.dcn.watermarks.c,
&dml2->v20.g6_temp_read_watermark_set,
sizeof(context->bw_ctx.bw.dcn.watermarks.c)); ``` ## Why This is a Good
Backport Candidate 1. **Clear Bug Fix**: The commit message explicitly
states "the guard of is_apu not in sync, caused no watermark_c output" -
this indicates a bug where APU systems were getting incorrect (likely
zero) watermark values. 2. **Consistent Pattern**: Looking at the same
file (line 546, 561, 569), there are already multiple `is_apu` checks
that differentiate behavior between APU and discrete GPU systems. The
original code at line 666 was inconsistent with this pattern. 3. **Small
and Contained**: The fix is minimal - just adding a conditional check
around an existing operation. It doesn't introduce new functionality or
architectural changes. 4. **Critical Subsystem**: Display watermarks are
critical for preventing display artifacts, screen corruption, underflow
issues, and power management problems. Incorrect watermarks can cause
visible display problems for users. 5. **APU-Specific Impact**: APUs
(integrated GPU+CPU) are very common in laptops and budget systems. A
watermark bug affecting these systems would impact a large user base. 6.
**Comparison with Similar Commits**: Looking at the similar commits
provided: - Commits #2 and #4 with "YES" status fix watermark values to
prevent "flickering and OTC underflow" - This commit follows the same
pattern of fixing watermark-related display issues ## Risk Assessment
**Low Risk:** - The change only affects APU systems (`is_apu` check) -
For non-APU systems, behavior remains exactly the same - The fix aligns
the watermark_c handling with how watermarks a, b, and d are already
handled - Uses existing, well-tested `dml2_extract_watermark_set()`
function instead of raw memcpy ## Context from Kernel Investigation The
git blame shows the original problematic code was introduced in commit
7966f319c66d9 (July 2023) when DML2 was first introduced. This suggests
the bug has existed since DML2 was added, affecting APU users for
potentially over a year. The fix ensures APU systems get proper
watermark calculations via `dml2_extract_watermark_set()` instead of
using potentially incorrect temporary values from
`g6_temp_read_watermark_set`. **Conclusion**: This is a clear, low-risk
bug fix that addresses display functionality issues on a common class of
hardware (APUs) and follows stable tree criteria perfectly.

 drivers/gpu/drm/amd/display/dc/dml2/dml2_wrapper.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dml2/dml2_wrapper.c b/drivers/gpu/drm/amd/display/dc/dml2/dml2_wrapper.c
index 03812f862b3d6..5732f1b5acab8 100644
--- a/drivers/gpu/drm/amd/display/dc/dml2/dml2_wrapper.c
+++ b/drivers/gpu/drm/amd/display/dc/dml2/dml2_wrapper.c
@@ -665,7 +665,10 @@ static bool dml2_validate_and_build_resource(const struct dc *in_dc, struct dc_s
 		dml2_copy_clocks_to_dc_state(&out_clks, context);
 		dml2_extract_watermark_set(&context->bw_ctx.bw.dcn.watermarks.a, &dml2->v20.dml_core_ctx);
 		dml2_extract_watermark_set(&context->bw_ctx.bw.dcn.watermarks.b, &dml2->v20.dml_core_ctx);
-		memcpy(&context->bw_ctx.bw.dcn.watermarks.c, &dml2->v20.g6_temp_read_watermark_set, sizeof(context->bw_ctx.bw.dcn.watermarks.c));
+		if (context->streams[0]->sink->link->dc->caps.is_apu)
+			dml2_extract_watermark_set(&context->bw_ctx.bw.dcn.watermarks.c, &dml2->v20.dml_core_ctx);
+		else
+			memcpy(&context->bw_ctx.bw.dcn.watermarks.c, &dml2->v20.g6_temp_read_watermark_set, sizeof(context->bw_ctx.bw.dcn.watermarks.c));
 		dml2_extract_watermark_set(&context->bw_ctx.bw.dcn.watermarks.d, &dml2->v20.dml_core_ctx);
 		dml2_extract_writeback_wm(context, &dml2->v20.dml_core_ctx);
 		//copy for deciding zstate use
-- 
2.39.5

