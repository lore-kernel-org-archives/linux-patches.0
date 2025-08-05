Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA2B62472B7;
	Tue,  5 Aug 2025 13:12:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754399527; cv=none; b=QfQwm4TgtMAv3YrAPm228jWeO1IOW0mNC7h655PLfUH1zv+6yZ+LlKBpIaJKo+2nfxGmsPU16kbRETpsVoLOngckdGeub+E2xbFtyPIRUmahGFGrnJjpxTwCwSNaYg3vU3Vj3+QtBu2sMtKklegWIZx5TivBsyvA6Z8GlDXHVtM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754399527; c=relaxed/simple;
	bh=YC+Fd3kvTd5WWP5HdO2ctXRPf5Z79sTkJw+IqsD8cbA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=cJMOQsPpqYCgv1XFhdMOqHD9bvRgcQFlW9Y7yNnuMCmnsw9bcpfchJS6UCyEvf9lvRTLfXeEk3l9InhSHf8rRJYZBs0AiAoiiJkmZ8OcdVV5Icew39EcYyup+veXkHVgY8i9vjgQfRUJGgYoLRgT2SbkgEJgm29x6pV5QSLV4J8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OUVxrHfw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OUVxrHfw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CE68C4CEF4;
	Tue,  5 Aug 2025 13:12:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754399526;
	bh=YC+Fd3kvTd5WWP5HdO2ctXRPf5Z79sTkJw+IqsD8cbA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OUVxrHfwwooA8Q5reB8fWJRvpSwxA819fmMTBHmwLbQeaktfbmVxLc/YAoa/Qa56F
	 U7brLcS1HuZo0+n8sCLxDM9hqNguX0Gd1Q/pGXXGb2hBu+OeXf+3ZW+yd/kFai3MMl
	 4v99tXYwrDY6+TUtp6p/JIZSKuNlneR0EHDwSgMLiyjIT1lbiyXrQudcRcVLfQY3u3
	 mltCOoPw170tNfNk3K/Y6W4CPWAt3jkcluGMw1dcee9JdYIniZCmmybKL6zxyS4d1/
	 dmg9zpHG7tZ/Nzx2Zao8dvMeNmzL71r/BFy2Dy08GuctTDu0KZtiz9yuoVpncjKfaa
	 dk2PrUHbT+Xwg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Roman Li <Roman.Li@amd.com>,
	Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
	Ivan Lipski <ivan.lipski@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	dillon.varone@amd.com,
	alex.hung@amd.com,
	alvin.lee2@amd.com,
	PeiChen.Huang@amd.com,
	michael.strauss@amd.com,
	srinivasan.shanmugam@amd.com,
	ryanseto@amd.com,
	yan.li@amd.com,
	ethan@ethancedwards.com,
	linux@treblig.org
Subject: [PATCH AUTOSEL 6.16-6.12] drm/amd/display: Disable dsc_power_gate for dcn314 by default
Date: Tue,  5 Aug 2025 09:09:36 -0400
Message-Id: <20250805130945.471732-61-sashal@kernel.org>
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

From: Roman Li <Roman.Li@amd.com>

[ Upstream commit 02f3ec53177243d32ee8b6f8ba99136d7887ee3a ]

[Why]
"REG_WAIT timeout 1us * 1000 tries - dcn314_dsc_pg_control line"
warnings seen after resuming from s2idle.
DCN314 has issues with DSC power gating that cause REG_WAIT timeouts
when attempting to power down DSC blocks.

[How]
Disable dsc_power_gate for dcn314 by default.

Reviewed-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Signed-off-by: Roman Li <Roman.Li@amd.com>
Signed-off-by: Ivan Lipski <ivan.lipski@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Based on my analysis of the commit and examination of the Linux kernel
codebase, here is my assessment:

**Backport Status: YES**

This commit should be backported to stable kernel trees for the
following reasons:

1. **Clear Bug Fix**: The commit addresses a specific bug - "REG_WAIT
   timeout 1us * 1000 tries" warnings that occur after resuming from
   s2idle (suspend-to-idle). This is a user-visible issue that affects
   system stability during power management operations.

2. **Small and Contained Change**: The fix is minimal - it only adds a
   single line `disable_dsc_power_gate = true` to the debug_defaults_drv
   structure in
   `/drivers/gpu/drm/amd/display/dc/resource/dcn314/dcn314_resource.c`.
   This is a low-risk configuration change.

3. **Hardware-Specific Workaround**: The change is specifically targeted
   at DCN314 hardware which has known issues with DSC (Display Stream
   Compression) power gating. The commit message clearly states "DCN314
   has issues with DSC power gating that cause REG_WAIT timeouts when
   attempting to power down DSC blocks."

4. **No Feature Addition**: This is purely a bug fix/workaround - it
   disables a problematic power management feature rather than adding
   new functionality.

5. **Power Management Bug**: Issues that affect suspend/resume
   functionality are particularly important for stable kernels as they
   directly impact user experience and system reliability.

6. **Existing Framework**: The `disable_dsc_power_gate` flag already
   exists in the codebase (defined in
   `/drivers/gpu/drm/amd/display/dc/dc.h`) and is checked in multiple
   places like `dcn31_hwseq.c` and `dcn20_hwseq.c`. This commit just
   sets the flag for DCN314 specifically.

7. **Minimal Risk of Regression**: Setting this flag only affects DSC
   power gating behavior on DCN314 hardware. The worst case would be
   slightly higher power consumption when DSC blocks are not in use,
   which is acceptable compared to system instability during resume.

8. **Clear Testing**: The commit has been reviewed by Nicholas
   Kazlauskas and tested by Daniel Wheeler, indicating proper
   validation.

This is exactly the type of hardware-specific bug fix that stable
kernels should include - it fixes a real problem affecting users with
minimal risk and without introducing new features or architectural
changes.

 drivers/gpu/drm/amd/display/dc/resource/dcn314/dcn314_resource.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/amd/display/dc/resource/dcn314/dcn314_resource.c b/drivers/gpu/drm/amd/display/dc/resource/dcn314/dcn314_resource.c
index 8383e2e59be5..eed64b05bc60 100644
--- a/drivers/gpu/drm/amd/display/dc/resource/dcn314/dcn314_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/resource/dcn314/dcn314_resource.c
@@ -926,6 +926,7 @@ static const struct dc_debug_options debug_defaults_drv = {
 	.seamless_boot_odm_combine = true,
 	.enable_legacy_fast_update = true,
 	.using_dml2 = false,
+	.disable_dsc_power_gate = true,
 };
 
 static const struct dc_panel_config panel_config_defaults = {
-- 
2.39.5

