Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D67273019CB;
	Mon,  9 Feb 2026 12:27:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770640063; cv=none; b=HH6ABLah+BipP113siqEuOTi5/dBgw+FzXWGCTLrgD121pAOPNgFL8YLj47FDI5zlYyU8AGDGwSwvbc4pYWqmnwFZrbo7SUX95XWsp0uHL06j0ApLr4K4PbVl7iYQB2dWU4RW3ck/HpjTNN2lo3IYrM/kQbYjXlQJg9RgHfmVgg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770640063; c=relaxed/simple;
	bh=yjsInlWsYi3VkMVyz/gi+v1jwKCKoWQACBdeqlLvQRI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oFJ3LkKUeWWbzCcq8OD+aOVUD2xoVVWlY6yEZ2kTQa2V7KMH8wHrfZTDaDCvQuAahp7i4af4EAIC8GApKtpnjvhnRh0a78FWBLwcA6QoJsEUQbIJGHPUMwMiqnHpcsdefXmUBOqnFd5qELWHbZYCNwhTzbeIOReLW1clsCdK8fQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mynDKjuX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mynDKjuX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C225C16AAE;
	Mon,  9 Feb 2026 12:27:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770640063;
	bh=yjsInlWsYi3VkMVyz/gi+v1jwKCKoWQACBdeqlLvQRI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mynDKjuXYPqWn0+9IaezlAvsjdOJSDP8zS6Cy6UEBb0WCBDc5arKh3/5ye1uQ3qEz
	 I9XB3UsNBT4Kv5fjyAP8NYdRF1lNd/5Ffmbt0itirH1stIWjdpz5o6oXwshck1LVZM
	 KjxCOGLUEYEleO12WmmnQPk8CfFb4KfXm27dutnl3sqlqXxi8R7hYHNigcjLvi54RN
	 +yR1fyWpgZgiuEV3oaRmGsX6z7CMlKmWDxUUUgd4CMwfulMz5yTn/3GhCWNqUBbViY
	 Hpi5+Ig5ENBEiwc8QKbzDBK9wXWONJHHqsqjxWY69coEmTmB/1jWpgXoGpFqWCp+vv
	 WZByF1G2xJbIA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Melissa Wen <mwen@igalia.com>,
	Alex Hung <alex.hung@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	ray.wu@amd.com,
	wenjing.liu@amd.com,
	rvojvodi@amd.com,
	Wesley.Chalmers@amd.com,
	Ilya.Bakoulin@amd.com,
	aurabindo.pillai@amd.com,
	meenakshikumar.somasundaram@amd.com,
	dmytro.laktyushkin@amd.com
Subject: [PATCH AUTOSEL 6.18-6.12] drm/amd/display: remove assert around dpp_base replacement
Date: Mon,  9 Feb 2026 07:26:54 -0500
Message-ID: <20260209122714.1037915-15-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260209122714.1037915-1-sashal@kernel.org>
References: <20260209122714.1037915-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.9
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Melissa Wen <mwen@igalia.com>

[ Upstream commit 84962445cd8a83dc5bed4c8ad5bbb2c1cdb249a0 ]

There is nothing wrong if in_shaper_func type is DISTRIBUTED POINTS.
Remove the assert placed for a TODO to avoid misinterpretations.

Signed-off-by: Melissa Wen <mwen@igalia.com>
Reviewed-by: Alex Hung <alex.hung@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 1714dcc4c2c53e41190896eba263ed6328bcf415)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

### Critical Finding

`ASSERT(false)` expands to `WARN_ON_ONCE(!(false))` which is
`WARN_ON_ONCE(true)`. This means **every time** this code path is hit on
a production kernel, it will generate a `WARN_ON_ONCE` — producing a
full stack trace in the kernel log and potentially triggering panic-on-
warn configurations.

This is a real bug for users who:
1. Have DCN 3.2 hardware (AMD display controllers)
2. Use color management features where `in_shaper_func.type ==
   TF_TYPE_DISTRIBUTED_POINTS`
3. Run kernels with `panic_on_warn=1` (some hardened configurations) —
   this would **crash** the system

### Classification

This is a **bug fix** — removing a false assertion that incorrectly
triggers a kernel warning on a valid code path. It's not a cleanup or
feature addition.

### Risk Assessment

- **Scope**: One line removal in a single file
- **Risk**: Essentially zero — removing a bogus `ASSERT(false)` cannot
  introduce regressions
- **Benefit**: Prevents spurious WARN_ON_ONCE on valid code paths;
  prevents crashes on panic-on-warn configurations
- **Subsystem**: AMD display driver (DCN 3.2) — widely used on modern
  AMD GPUs

### Stable Criteria Check

1. **Obviously correct and tested**: Yes — removing a known-false assert
   is obviously correct. Reviewed-by and cherry-picked.
2. **Fixes a real bug**: Yes — spurious WARN_ON triggering on a valid
   code path is a real bug.
3. **Important issue**: Moderate — causes kernel warnings and potential
   crashes on panic-on-warn systems.
4. **Small and contained**: Yes — single line removal.
5. **No new features**: Correct — no new functionality added.

**YES**

 drivers/gpu/drm/amd/display/dc/hwss/dcn32/dcn32_hwseq.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/hwss/dcn32/dcn32_hwseq.c b/drivers/gpu/drm/amd/display/dc/hwss/dcn32/dcn32_hwseq.c
index 30bb5d8d85dc2..c6fde355ac823 100644
--- a/drivers/gpu/drm/amd/display/dc/hwss/dcn32/dcn32_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/hwss/dcn32/dcn32_hwseq.c
@@ -502,7 +502,6 @@ bool dcn32_set_mcm_luts(
 		lut_params = &plane_state->in_shaper_func.pwl;
 	else if (plane_state->in_shaper_func.type == TF_TYPE_DISTRIBUTED_POINTS) {
 		// TODO: dpp_base replace
-		ASSERT(false);
 		cm3_helper_translate_curve_to_hw_format(plane_state->ctx,
 							&plane_state->in_shaper_func,
 							&dpp_base->shaper_params, true);
-- 
2.51.0

