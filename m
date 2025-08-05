Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2C012749E8;
	Tue,  5 Aug 2025 13:11:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754399493; cv=none; b=aIzu2eP4Tz7r90/zbC9ZOWLq8SRTMOyrbGqQhEpoWDTXeSjwIrAGHtnGfEXd+VlK+PuFhK6zbdcY7BeL11u/ns9ttPgz+3aqjpzmpYptTCZlGH9PaI7truAtfP0QzjRygZHhpOixJWdLEjes2679JlzLPoX94IasXLubxGI9EpA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754399493; c=relaxed/simple;
	bh=4z2qpKUdOQ4fdDj9nxJ/UhoEg8OJIDaBILPpKXEc2jY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=iv0QrIK4ZXi5d5oYoYU25t3FWrVS11QEpSVKZECuuExZVMhh68xxZU+YoEqfYchxDKBVqlzDjwhsAU6kqAIzHXwkEbt3p/wSJrq8uOxS7e1o1NXbT/GmGrWlvX2T31fBgBfusqc2CxzDj25NACMLaO/MiQfUeWJELpA4/Tg43BQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Cb6GlrJe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Cb6GlrJe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50783C4CEF0;
	Tue,  5 Aug 2025 13:11:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754399492;
	bh=4z2qpKUdOQ4fdDj9nxJ/UhoEg8OJIDaBILPpKXEc2jY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Cb6GlrJeqMrveHteiL8bzs6sZIvk2NQ9EIBkS6YGRDGz5JACc0kAqMFfVNcmq14Kt
	 0h3NKS8SMkY96kjLu75ijCd1kZ+yCfW8TZb2epUuwuiXoLoHK0eiLzJPlShb6bAEh6
	 vCcskMxe+qVv4v1SvvdM/3cvx4aL5BiDVLaBi8H2/48pvirUPJPhV3xEz4JperucNX
	 Gp7jZ7kHoAhJzOBEBnzzE0LJUXJcomQ8dGd1L6QFTvwDqawwi5dQFeK67Q6B5Dt4Gt
	 0QyqSjQnmxN/A79VioK5Nwk75H7VNJEPCovouytdYQreFcx/6tnBXZK9pbKc1gRmeb
	 w3Az+2iiTQsrQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Mario Limonciello <mario.limonciello@amd.com>,
	Sun peng Li <sunpeng.li@amd.com>,
	Ivan Lipski <ivan.lipski@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	chiahsuan.chung@amd.com,
	roman.li@amd.com
Subject: [PATCH AUTOSEL 6.16-6.6] drm/amd/display: Avoid configuring PSR granularity if PSR-SU not supported
Date: Tue,  5 Aug 2025 09:09:23 -0400
Message-Id: <20250805130945.471732-48-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250805130945.471732-1-sashal@kernel.org>
References: <20250805130945.471732-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.16
Content-Transfer-Encoding: 8bit

From: Mario Limonciello <mario.limonciello@amd.com>

[ Upstream commit a5ce8695d6d1b40d6960d2d298b579042c158f25 ]

[Why]
If PSR-SU is disabled on the link, then configuring su_y granularity in
mod_power_calc_psr_configs() can lead to assertions in
psr_su_set_dsc_slice_height().

[How]
Check the PSR version in amdgpu_dm_link_setup_psr() to determine whether
or not to configure granularity.

Reviewed-by: Sun peng (Leo) Li <sunpeng.li@amd.com>
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Ivan Lipski <ivan.lipski@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have a clear understanding of the issue. Let me analyze the
commit:

## Analysis Summary

**Backport Status: YES**

## Extensive Explanation

This commit fixes a bug that can cause assertions (kernel
warnings/panics) in AMD display driver code when PSR (Panel Self
Refresh) is enabled on systems that don't support PSR-SU (Selective
Update).

### The Bug Being Fixed:

1. **Root Cause**: In `amdgpu_dm_link_setup_psr()`, the function
   `mod_power_calc_psr_configs()` is called for any PSR version (line
   113), which sets `psr_config->su_y_granularity` from DPCD
   capabilities (line 926 in power_helpers.c).

2. **The Problem**: Even when PSR-SU is not supported (PSR version 1),
   `psr_su_set_dsc_slice_height()` was being called unconditionally
   (line 122). This function contains an assertion check at lines
   968-970 that validates:
  ```c
  if (config->su_y_granularity &&
  (slice_height % config->su_y_granularity)) {
  ASSERT(0);
  return false;
  }
  ```

3. **Impact**: When PSR version 1 (non-SU) is active but
   `su_y_granularity` is non-zero from DPCD caps, the assertion
   triggers, potentially causing system instability or crashes.

### The Fix:

The commit adds a simple version check to only call
`psr_su_set_dsc_slice_height()` when PSR-SU (DC_PSR_VERSION_SU_1) is
actually supported:

```c
if (link->psr_settings.psr_version == DC_PSR_VERSION_SU_1) {
    if (!psr_su_set_dsc_slice_height(dc, link, stream, &psr_config))
        return false;
}
```

### Why This Should Be Backported:

1. **Bug Fix**: This fixes a real bug that causes assertions/warnings in
   production systems
2. **Small and Contained**: The fix is minimal - just adding a version
   check around an existing function call
3. **No Architectural Changes**: This doesn't introduce new features or
   change architecture
4. **Prevents System Instability**: Assertions in kernel code can lead
   to panics or unstable behavior
5. **Clear Regression Prevention**: Systems with PSR version 1 that have
   non-zero su_y_granularity values from their panel DPCD would hit this
   assertion
6. **Limited Scope**: Only affects AMD GPU display driver PSR
   functionality
7. **Safe Fix**: The change only adds a guard to prevent calling PSR-SU
   specific code when PSR-SU is not supported - this is clearly the
   correct behavior

The commit follows stable kernel rules perfectly - it's a targeted bug
fix that prevents potential system crashes without introducing new
functionality or risks.

 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_psr.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_psr.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_psr.c
index f984cb0cb889..ff7b867ae98b 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_psr.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_psr.c
@@ -119,8 +119,10 @@ bool amdgpu_dm_link_setup_psr(struct dc_stream_state *stream)
 		psr_config.allow_multi_disp_optimizations =
 			(amdgpu_dc_feature_mask & DC_PSR_ALLOW_MULTI_DISP_OPT);
 
-		if (!psr_su_set_dsc_slice_height(dc, link, stream, &psr_config))
-			return false;
+		if (link->psr_settings.psr_version == DC_PSR_VERSION_SU_1) {
+			if (!psr_su_set_dsc_slice_height(dc, link, stream, &psr_config))
+				return false;
+		}
 
 		ret = dc_link_setup_psr(link, stream, &psr_config, &psr_context);
 
-- 
2.39.5

