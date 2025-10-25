Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6843E2FB99A;
	Sat, 25 Oct 2025 16:27:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761409665; cv=none; b=qEuN8K7RS2rR06L1KKUAbaHqZyEyA1FjpzWD3Y0cdIFHGglgzWu8hAO0+l9LZDD4REuFnwcgO5BnqK8zciuGzwMBjxzWlny7y2Qp0uXInbMMTmlys0owImoJ1wFMrPqqrJmxvkkMKvTZF2MQeUZGeeQeudy6Y4R/PD3s531GUUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761409665; c=relaxed/simple;
	bh=MhmTUBVOkeqE65RFKoWEjw6MXp3B1AgqG0dlS0evLIw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GqrT1IdTBeN5ka9z6d4itlO24sXpKTsR8pjcsy3K7WGnAYWBDHQsfbcJstZ5jF2M38FcpZdk+Emk28rNZVxPJjApVvSL8lWowI4w9udxSSTSOwbKNIN5EU8So0ocOs8U4BjvaltMIftGSrZTWWj8BwCb0ajbuxnvcDTmDMpVsYA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZKBBoLHm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZKBBoLHm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 824A9C4CEFF;
	Sat, 25 Oct 2025 16:27:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761409665;
	bh=MhmTUBVOkeqE65RFKoWEjw6MXp3B1AgqG0dlS0evLIw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZKBBoLHmAnMv7H0e/Yc9AYSDI/QxUanQ4LFAATlFLDclIMKgbxF6PaaYm8GXyAoSH
	 bIomKGpZEEHGMkVPSgWjACPAz5BeptXDPQuxk47m2dc8358B53VWRgBWm14WmHsPq5
	 ojdExHkhyVn3YIctJIL0t4kd2iU0ngRbiaEUhw/syV9EmJQe4VMbCyw1yLyQXrNbZD
	 1UbcHHviJgBl6qWTffvmoR2fVRMxQl7l7QbkxOmCEHoyUKl2WYNKt+0B5hRqOw5Zdp
	 PtY5Ft9KCxoasQruhNPC3taNGhBSyqQUg+vVlR8LY2wrf2oaoY7uygEfMU4a7S3A2t
	 O7bFsURJFTwTg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: =?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>,
	Rodrigo Siqueira <siqueira@igalia.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	mario.limonciello@amd.com,
	Wayne.Lin@amd.com,
	aurabindo.pillai@amd.com,
	chiahsuan.chung@amd.com,
	alexandre.f.demers@gmail.com,
	Dillon.Varone@amd.com,
	ivan.lipski@amd.com,
	alvin.lee2@amd.com,
	Harikrishna.Revalla@amd.com,
	rostrows@amd.com
Subject: [PATCH AUTOSEL 6.17-6.6] drm/amd/display: Disable VRR on DCE 6
Date: Sat, 25 Oct 2025 12:00:42 -0400
Message-ID: <20251025160905.3857885-411-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251025160905.3857885-1-sashal@kernel.org>
References: <20251025160905.3857885-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.5
Content-Transfer-Encoding: 8bit

From: Timur Kristóf <timur.kristof@gmail.com>

[ Upstream commit 043c87d7d56e135393f8aab927148096e2d17589 ]

DCE 6 was not advertised as being able to support VRR,
so let's mark it as unsupported for now.

The VRR implementation in amdgpu_dm depends on the VUPDATE
interrupt which is not registered for DCE 6.

Signed-off-by: Timur Kristóf <timur.kristof@gmail.com>
Reviewed-by: Rodrigo Siqueira <siqueira@igalia.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Alex Hung <alex.hung@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Backport Recommendation: **YES**

After conducting extensive research and analysis, I recommend this
commit **SHOULD be backported** to stable kernel trees.

---

## Comprehensive Analysis

### 1. Hardware Context

**DCE 6 corresponds to AMD Southern Islands GPUs (2012)**:
- DCE_VERSION_6_0: Tahiti (Radeon HD 7900 series)
- DCE_VERSION_6_1: Cape Verde (Radeon HD 7700 series)
- DCE_VERSION_6_4: Oland, Pitcairn (Radeon HD 7800 series)

These are GCN 1.0 GPUs from 2012, over 12 years old.

### 2. What the Commit Does

The commit adds three key changes:

**In `drivers/gpu/drm/amd/display/dc/dc_helper.c` (new function)**:
- Adds `dc_supports_vrr()` function that returns `true` only for
  `DCE_VERSION_8_0` and later
- Line 761: `return v >= DCE_VERSION_8_0;`

**In `drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c`**:
- Line 12738: Adds check `!dc_supports_vrr(sink->ctx->dce_version)` in
  `amdgpu_dm_update_freesync_caps()` to skip freesync capability
  detection for DCE 6
- Line 10838-10840: Sets `config.state = VRR_STATE_UNSUPPORTED` when
  `vrr_supported` is false in `get_freesync_config_for_crtc()`

### 3. Technical Investigation: The VUPDATE Interrupt Claim

The commit message states: *"The VRR implementation in amdgpu_dm depends
on the VUPDATE interrupt which is not registered for DCE 6."*

My investigation reveals a nuanced truth:

**DCE 6
(`drivers/gpu/drm/amd/display/dc/irq/dce60/irq_service_dce60.c`)**:
- Lines 118-132: DOES define `vupdate_int_entry()` macro
- Lines 247-252: DOES register VUPDATE interrupts for all 6 CRTCs
- **BUT**: Line 131 uses `.funcs = &vblank_irq_info_funcs` (borrowed
  from vblank)

**DCE 8
(`drivers/gpu/drm/amd/display/dc/irq/dce80/irq_service_dce80.c`)**:
- Lines 109-123: Defines similar `vupdate_int_entry()` macro
- Lines 239-244: Registers VUPDATE interrupts for all 6 CRTCs
- **Key difference**: Line 122 uses `.funcs = &vupdate_irq_info_funcs`
  (dedicated vupdate funcs)

**Critical Finding**: While DCE 6 has VUPDATE interrupt infrastructure,
it's using the vblank interrupt function pointers
(`&vblank_irq_info_funcs`) instead of dedicated VRR-specific handlers.
This indicates the VUPDATE interrupt exists in hardware but isn't
properly wired up for VRR functionality.

### 4. Why This is a Bug Fix

1. **Incorrect Feature Advertising**: DCE 6 was never officially
   marketed as VRR/FreeSync capable
2. **Missing Proper Support**: VRR/FreeSync was introduced with later
   GPU generations (DCE 8+ / GCN 1.1+)
3. **Interrupt Infrastructure Incomplete**: VUPDATE interrupts exist but
   use wrong function pointers for VRR
4. **Prevents User Confusion**: Users with DCE 6 hardware might waste
   time trying to enable VRR that can't work properly

### 5. Code Change Analysis

**Modified function: `get_freesync_config_for_crtc()`**
(drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c:10698-10738)

```c
if (new_crtc_state->vrr_supported) {
    // ... configure VRR parameters ...
+} else {
+    config.state = VRR_STATE_UNSUPPORTED;
}
```

This ensures when `vrr_supported` is false (which now includes DCE 6),
the config explicitly sets state to `VRR_STATE_UNSUPPORTED`. This is
cleaner than leaving it in an undefined state.

**Modified function: `amdgpu_dm_update_freesync_caps()`**
(drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c:12599-12711)

```c
-if (!adev->dm.freesync_module)
+if (!adev->dm.freesync_module ||
!dc_supports_vrr(sink->ctx->dce_version))
     goto update;
```

This prevents the entire freesync capability detection from running on
DCE 6 hardware, ensuring `freesync_capable` remains `false`.

### 6. Impact Assessment

**Who is affected?**
- Only users with DCE 6 hardware (2012-era Radeon HD 7000 series)
- Very small user base given the age of the hardware

**What changes for users?**
- VRR/FreeSync option will no longer appear as available on DCE 6 GPUs
- Users won't waste time trying to enable a feature that doesn't work
- Prevents potential undefined behavior from incomplete VRR support

**Regression risk?**
- **EXTREMELY LOW**: Only affects DCE 6, and only disables a feature
  that was never officially supported
- No architectural changes
- No changes to DCE 8+ hardware (which properly supports VRR)

### 7. Backporting Criteria Evaluation

✅ **Fixes a bug**: Yes - incorrect feature advertising
✅ **Small and contained**: Yes - only 11 lines across 3 files
✅ **Clear side effects**: Yes - disables VRR on DCE 6 only
✅ **No architectural changes**: Correct - simple feature gate
✅ **Well-reviewed**: Yes - 3 AMD developers (Rodrigo Siqueira, Alex
Deucher, Alex Hung)
✅ **Minimal regression risk**: Yes - isolated to old hardware
✅ **Follows stable rules**: Yes - important bugfix, minimal risk

### 8. Git History Context

From my investigation:
- DCE 6 support added to amdgpu display in 2020 (commit 61bf32937bdd0)
- Recent DCE 6 fixes include scaling issues (2024-2025)
- Author Timur Kristóf has been actively fixing DCE 6 issues
- No prior VRR-specific commits for DCE 6 found

### 9. Similar Patterns in Codebase

The `VRR_STATE_UNSUPPORTED` state is used throughout the codebase to
indicate hardware that doesn't support VRR:
- `drivers/gpu/drm/amd/display/modules/inc/mod_freesync.h:44`: State
  definition
- Multiple uses in `freesync.c` to check for unsupported hardware
- This commit follows established patterns

---

## Final Recommendation: **YES - Backport to Stable**

**Reasoning:**

1. **Correctness Fix**: Prevents advertising VRR capability on hardware
   that cannot properly support it due to incomplete interrupt
   infrastructure

2. **User Experience**: Saves users from attempting to enable VRR on
   incompatible hardware

3. **Low Risk**: Change is minimal, well-isolated to DCE 6 only, and
   extensively reviewed

4. **Stable Tree Appropriate**: Meets all criteria - important bugfix,
   minimal code change, no regressions expected

5. **Clean Implementation**: Uses proper VRR state
   (`VRR_STATE_UNSUPPORTED`) rather than leaving config in undefined
   state

The commit should be backported to all stable trees that include DCE 6
display support to ensure users don't encounter incorrect VRR capability
reporting on this legacy hardware.

 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 4 +++-
 drivers/gpu/drm/amd/display/dc/dc_helper.c        | 5 +++++
 drivers/gpu/drm/amd/display/dc/dm_services.h      | 2 ++
 3 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index f450bcb43c9c1..57b46572fba27 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -10787,6 +10787,8 @@ static void get_freesync_config_for_crtc(
 		} else {
 			config.state = VRR_STATE_INACTIVE;
 		}
+	} else {
+		config.state = VRR_STATE_UNSUPPORTED;
 	}
 out:
 	new_crtc_state->freesync_config = config;
@@ -12688,7 +12690,7 @@ void amdgpu_dm_update_freesync_caps(struct drm_connector *connector,
 
 	dm_con_state = to_dm_connector_state(connector->state);
 
-	if (!adev->dm.freesync_module)
+	if (!adev->dm.freesync_module || !dc_supports_vrr(sink->ctx->dce_version))
 		goto update;
 
 	edid = drm_edid_raw(drm_edid); // FIXME: Get rid of drm_edid_raw()
diff --git a/drivers/gpu/drm/amd/display/dc/dc_helper.c b/drivers/gpu/drm/amd/display/dc/dc_helper.c
index 7217de2588511..4d2e5c89577d0 100644
--- a/drivers/gpu/drm/amd/display/dc/dc_helper.c
+++ b/drivers/gpu/drm/amd/display/dc/dc_helper.c
@@ -755,3 +755,8 @@ char *dce_version_to_string(const int version)
 		return "Unknown";
 	}
 }
+
+bool dc_supports_vrr(const enum dce_version v)
+{
+	return v >= DCE_VERSION_8_0;
+}
diff --git a/drivers/gpu/drm/amd/display/dc/dm_services.h b/drivers/gpu/drm/amd/display/dc/dm_services.h
index 7b9c22c45453d..7b398d4f44398 100644
--- a/drivers/gpu/drm/amd/display/dc/dm_services.h
+++ b/drivers/gpu/drm/amd/display/dc/dm_services.h
@@ -311,4 +311,6 @@ void dm_dtn_log_end(struct dc_context *ctx,
 
 char *dce_version_to_string(const int version);
 
+bool dc_supports_vrr(const enum dce_version v);
+
 #endif /* __DM_SERVICES_H__ */
-- 
2.51.0

