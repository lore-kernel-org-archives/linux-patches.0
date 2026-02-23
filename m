Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB53136656F;
	Mon, 23 Feb 2026 12:37:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771850272; cv=none; b=QYb/1PJhpUpMeRNGtQpHKdTegmv7LMRbPF3WkSrJZvStwNnItTtds8ar9BdKsOqafIskI7qCenbcbDCUMAhV0e8LNkr/PXA6H9K03Kbg8DXtOLZ1BF/P1QZdeytaZ3B0Q35kHRulfEB0sesX1A+kCB/z+RWOb8HkDeCzZEl9fTE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771850272; c=relaxed/simple;
	bh=3uVzNyyLTtIloKiEc4ytCPRgNK6+M5PvDJ/8z1pKvxc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UCpQ8curF9/dn0++r1CcMsLiKH9iJWveNWu/iouSLDxsEkcMVsc5BRWo3ohqOdZoOof8ntgE8eOjEufhg0IQnNziyiiCJDfMt+7q5qerG1ngp817NMg2g4nK8AuvbVI5/Ffgd8GepX1SxjdLUVlug9omVN9+8cQfFJgdb+yV8Ok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gWlAZf+u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gWlAZf+u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66BAEC116D0;
	Mon, 23 Feb 2026 12:37:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771850271;
	bh=3uVzNyyLTtIloKiEc4ytCPRgNK6+M5PvDJ/8z1pKvxc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gWlAZf+ulTI40ttJmtbdOg9btbL4m31ERKZOmc00s1dBeHPu83ut3GbsvxGbpFax+
	 8cn6wFi2Mq4FyhL++DFt1iMPZgqkhBTNKgbpJUOAwmF1X1huTGaDthfb/bRZ2azHak
	 iRqbYL6oVcD/ezNnQ6TVUMeuUEr4fhKfTLIfOsWIU2QSAq4ELbAJjfzvOKNQzzMXBa
	 CtDf/fWwZHrfmh0O0v3nXZbHgPeome+jxlbffEH/EOGSbiKBoYgLi1zVBbOr0EceBB
	 X3Wqwxreb8AnZ6wmOmj160x98N6b0NZYufLU6tNZ5EkuljciKw10U2E9xCOoQIdynX
	 A2TfISHiriT4Q==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Alex Hung <alex.hung@amd.com>,
	Harry Wentland <harry.wentland@amd.com>,
	Wayne Lin <wayne.lin@amd.com>,
	Dan Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	sunpeng.li@amd.com,
	christian.koenig@amd.com,
	airlied@gmail.com,
	simona@ffwll.ch,
	amd-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.19-6.12] drm/amd/display: Fix writeback on DCN 3.2+
Date: Mon, 23 Feb 2026 07:37:13 -0500
Message-ID: <20260223123738.1532940-8-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260223123738.1532940-1-sashal@kernel.org>
References: <20260223123738.1532940-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19.3
Content-Transfer-Encoding: 8bit

From: Alex Hung <alex.hung@amd.com>

[ Upstream commit 9ef84a307582a92ef055ef0bd3db10fd8ac75960 ]

[WHAT]
1. Set no scaling for writeback as they are hardcoded in DCN3.2+.
2. Set no fast plane update for writeback commits.

Reviewed-by: Harry Wentland <harry.wentland@amd.com>
Signed-off-by: Alex Hung <alex.hung@amd.com>
Signed-off-by: Wayne Lin <wayne.lin@amd.com>
Tested-by: Dan Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have all the information needed for a comprehensive analysis.

## Analysis

### 1. Commit Message Analysis

The commit title "Fix writeback on DCN 3.2+" clearly indicates a bug
fix. The `[WHAT]` section describes two fixes:
1. Setting no scaling (taps=1) for writeback since scaling is hardcoded
   in DCN 3.2+
2. Disabling fast plane updates for writeback commits

The commit has strong trust indicators: Reviewed-by (Harry Wentland, a
senior AMD display developer), Tested-by (Dan Wheeler, AMD's display
testing lead), and sign-offs from multiple AMD developers.

### 2. Code Change Analysis

**Change 1 - Scaler taps (lines 10651-10654):**
The scaler tap values are changed from `h_taps=4, v_taps=4, h_taps_c=2,
v_taps_c=2` to all `1`. This is because:
- DCN 3.2+ hardware has hardcoded writeback scaling, meaning the
  software-configured scaler taps are not used by the hardware
- Setting taps to 4/2 is incorrect because it tells the DML (Display
  Mode Library) bandwidth calculation code that scaling with 4 taps is
  active, when it's actually not. This is visible in
  `dml2_translation_helper.c:1250-1253` and `dcn30_fpu.c:219-220` where
  these values feed into bandwidth calculations
- Wrong bandwidth estimates could cause writeback to fail validation or
  produce incorrect output

**Change 2 - Writeback check in should_reset_plane (11 new lines):**
A new check is added in `should_reset_plane()` to detect writeback
commits (connectors of type `DRM_MODE_CONNECTOR_WRITEBACK` with an
active `writeback_job`). When detected, the function returns `true`,
forcing a full plane reset instead of a fast update.

This is needed because commit `435f5b369657c` ("Enable fast plane
updates on DCN3.2 and above", v6.7-rc2) changed `should_reset_plane()`
to allow fast updates on DCN 3.2+, skipping the full plane reset for
`allow_modeset` states. However, writeback operations require the full
plane reconfiguration path - the fast update path doesn't properly
handle writeback state changes.

### 3. Bug Classification

This fixes a **functional correctness bug** where writeback (screen
capture/recording via DRM writeback connectors) is broken on DCN 3.2+
hardware (AMD Radeon RX 7000 series and later). Without this fix:
- Writeback uses the fast plane update path, which is insufficient for
  writeback configuration
- Scaler tap parameters are incorrectly set, potentially causing DML
  bandwidth validation issues

### 4. Scope and Risk Assessment

- **Files changed:** 1 (`amdgpu_dm.c`)
- **Lines changed:** ~15 lines modified/added
- **Risk:** Low - the scaler tap change is a simple value change; the
  `should_reset_plane` change adds an additional early-return condition
  that is purely additive
- **The writeback check only affects writeback commits** - normal
  display operations are unaffected
- **The scaler tap change only affects writeback parameters** - normal
  display scaling is unaffected

### 5. Dependency Check

- **Prerequisite 1:** Commit `435f5b369657c` ("Enable fast plane updates
  on DCN3.2 and above") - present since v6.7-rc2. Without this commit,
  the `should_reset_plane` change isn't needed (pre-DCN3.2 always does
  full reset).
- **Prerequisite 2:** Writeback support re-added in commit
  `c81e13b929df2` (v6.8-rc1). Without this, the `dm_set_writeback`
  function doesn't exist.
- **Self-contained:** The commit doesn't depend on any other patches in
  its series for correctness. Both changes are independent and additive.
- **Applicable stable versions:** v6.8+ (where both prerequisites exist)

### 6. User Impact

Users with DCN 3.2+ hardware (AMD RDNA3 / RX 7000 series GPUs, and
newer) trying to use DRM writeback (screen capture, recording
functionality) would find it broken without this fix. This affects real
users attempting to use writeback features on modern AMD GPUs.

### Verification

- Verified that commit `435f5b369657c` ("Enable fast plane updates on
  DCN3.2 and above") was introduced in v6.7-rc2 via `git describe
  --contains` - this is the commit that created the bug for writeback by
  allowing fast updates on DCN 3.2+
- Verified that writeback support was re-added in commit `c81e13b929df2`
  in v6.8-rc1 via `git describe --contains` - this means the bug is
  present since v6.8
- Verified that the scaler_taps values are consumed by DML bandwidth
  calculation code in `dml2_translation_helper.c:1250-1253` and
  `dcn30_fpu.c:219-220` via grep
- Verified that DCN 3.0+ (dcn30) DWB funcs do NOT have a `set_scaler`
  function (unlike dcn20), confirming that hardware scaling is handled
  differently on newer DCN
- Verified the `should_reset_plane` function at line 11660 in the
  current codebase - confirmed it does not have the writeback check
- Verified via lore.kernel.org that this is patch 7/21 in a DC patch
  series, reviewed by Harry Wentland, with no explicit dependency notes
- Could NOT verify specific user reports of writeback failures on DCN
  3.2+ (unverified) - the commit doesn't reference bug reports, but the
  code analysis makes the bug mechanism clear

### Conclusion

This is a clear bug fix for broken writeback functionality on DCN 3.2+
hardware. The change is small (15 lines), self-contained, low-risk,
well-reviewed, and tested. It fixes a real functional regression where
writeback was broken by the fast plane update optimization. It meets all
stable kernel criteria: obviously correct, fixes a real bug, small and
contained, no new features. The fix applies to stable trees v6.8+.

**YES**

 .../gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index a8a59126b2d2b..a72394b05ab02 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -10648,10 +10648,10 @@ static void dm_set_writeback(struct amdgpu_display_manager *dm,
 
 	wb_info->dwb_params.capture_rate = dwb_capture_rate_0;
 
-	wb_info->dwb_params.scaler_taps.h_taps = 4;
-	wb_info->dwb_params.scaler_taps.v_taps = 4;
-	wb_info->dwb_params.scaler_taps.h_taps_c = 2;
-	wb_info->dwb_params.scaler_taps.v_taps_c = 2;
+	wb_info->dwb_params.scaler_taps.h_taps = 1;
+	wb_info->dwb_params.scaler_taps.v_taps = 1;
+	wb_info->dwb_params.scaler_taps.h_taps_c = 1;
+	wb_info->dwb_params.scaler_taps.v_taps_c = 1;
 	wb_info->dwb_params.subsample_position = DWB_INTERSTITIAL_SUBSAMPLING;
 
 	wb_info->mcif_buf_params.luma_pitch = afb->base.pitches[0];
@@ -11667,6 +11667,8 @@ static bool should_reset_plane(struct drm_atomic_state *state,
 	struct drm_crtc_state *old_crtc_state, *new_crtc_state;
 	struct dm_crtc_state *old_dm_crtc_state, *new_dm_crtc_state;
 	struct amdgpu_device *adev = drm_to_adev(plane->dev);
+	struct drm_connector_state *new_con_state;
+	struct drm_connector *connector;
 	int i;
 
 	/*
@@ -11677,6 +11679,15 @@ static bool should_reset_plane(struct drm_atomic_state *state,
 	    state->allow_modeset)
 		return true;
 
+	/* Check for writeback commit */
+	for_each_new_connector_in_state(state, connector, new_con_state, i) {
+		if (connector->connector_type != DRM_MODE_CONNECTOR_WRITEBACK)
+			continue;
+
+		if (new_con_state->writeback_job)
+			return true;
+	}
+
 	if (amdgpu_in_reset(adev) && state->allow_modeset)
 		return true;
 
-- 
2.51.0

