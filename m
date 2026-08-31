Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24EF64C9564;
	Mon, 31 Aug 2026 13:39:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183550; cv=none; b=BO+W4JQawt+kPmCHhLFdktvjBVVHpoyd3YhzFApmcd6jgwvzlsBSqTSrggXKUvbcb24CSQUZnLXH6zMx9/N6/8FVguxPQUOZP41ipOtRAqLtp/2V/UIX8d1DzoRIOube0t0WmmgLmI5HelNKyXpPSVS0nSqqo7y6KL0ZIprMBIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183550; c=relaxed/simple;
	bh=ie8al/7mINbMk3ZWHeGqtQLkV6Og7J7PQWacQ5mfMPU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nDtlsvFWxIzgBZdS3d1EgTlHag6Uwn43Mo1GlN3tVBwan7z/FlTjhjEgn6vJYl3Ll4ngfD/5ju6GuZWnyKTUikJ5R09eyH3P5NTyFuEwmWP2GbFr5rjv0zpVMff383WVHEWP622Bwzy9nkaWz9nDv8GTAy+4swOFVLK09eV/1t4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=L3actPbe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="L3actPbe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33C471F00A3E;
	Mon, 31 Aug 2026 13:39:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183547;
	bh=8+edGIJKj0yaz/K1D2wKNEO+Y4qQ65VpvuBinHaH44U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L3actPbe9oQC0Nyii5NbXj8sxTw735P5tHRUE8JG0YyZuKbDk6+l/GZFc794CpoA5
	 /YRbFfmTYogcayATZYLmzLOnpp1S8E/obZAG3TzwDqu6T8+fB05vTpKBI7s/8+BDMJ
	 9ljPi80fsRBNmSb7ZSKB1D1p6KUbl3icAKllMRfWaGJDlwwWfZvrmHPCEWZif7iJio
	 f234lphhBiBR4VQPEKGSbL/U3aWH8w+34wggwBZvmAyycJCeapPle/3+xmTnYtOv22
	 IE1Sl2dMiuASRhAeyqrStrTb+HqLQkYwRi2lCpiIdxiNbeDEX7B/EHCuZHZbKKIj3R
	 wm8nrJXVAqvfw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Ivan Lipski <ivan.lipski@amd.com>,
	Harry Wentland <harry.wentland@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	sunpeng.li@amd.com,
	christian.koenig@amd.com,
	airlied@gmail.com,
	simona@ffwll.ch,
	amd-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.12] drm/amd/display: Initialize dsc_caps to 0
Date: Mon, 31 Aug 2026 09:23:10 -0400
Message-ID: <20260831133314.4125787-162-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260831133314.4125787-1-sashal@kernel.org>
References: <20260831133314.4125787-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.48
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ivan Lipski <ivan.lipski@amd.com>

[ Upstream commit d18ecfee5187e3b2dbff7e67dda8b2f54ff5231c ]

[Why&How]
If we don't do that we make DSC decisions based on random
inputs, which might result in disallowing DSC when the
monitor and HW support it.

Reviewed-by: Harry Wentland <harry.wentland@amd.com>
Signed-off-by: Ivan Lipski <ivan.lipski@amd.com>
Signed-off-by: Harry Wentland <harry.wentland@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The background searches finished and matched the earlier analysis:

- **Fix not in this tree:** `git log` for `Initialize dsc_caps` /
  `dsc_caps = {0}` returned nothing — the patch isn’t in v6.18.44 yet,
  but the bug is still there (`struct dsc_dec_dpcd_caps dsc_caps;` at
  line 7168).
- **b4 dig:** No result, since the commit isn’t present locally to look
  up.

**Verdict stands: YES** for backport to this 6.18.y tree — one-line
zero-init fix for uninitialized DSC caps used during mode setup on
AMDGPU.

 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index 4f53297786623..8445b13549c17 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -7165,7 +7165,7 @@ create_stream_for_sink(struct drm_connector *connector,
 	int preferred_refresh = 0;
 	enum color_transfer_func tf = TRANSFER_FUNC_UNKNOWN;
 #if defined(CONFIG_DRM_AMD_DC_FP)
-	struct dsc_dec_dpcd_caps dsc_caps;
+	struct dsc_dec_dpcd_caps dsc_caps = {0};
 #endif
 	struct dc_link *link = NULL;
 	struct dc_sink *sink = NULL;
-- 
2.53.0

