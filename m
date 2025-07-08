Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AF911BC41;
	Tue,  8 Jul 2025 00:02:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751932944; cv=none; b=UHnJsarKEOaeUsv3uC521NzmHtG1rjNqYAtMRvZSsi/dz3kxtSdCIzP+OGzQiUk/9Y7YxmhLjDOZ4i6vlfYfyjNO/wfKpfdlhEUwf+X1q5839IEpbLhljdZ3Hy5zyzzR1yaL3RrcJUZ69GuA2CsiWaHQp4V7ZvwMU+qPFTfdZog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751932944; c=relaxed/simple;
	bh=S9ZIRQwMC2r+29JRA34OsR3pNa5ZIQDPOFqcxT7gEWo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=XdKoRE7vK3O18sALzcRnYYCUieBDdhJbjEPk8kOHcP0qcV76Lpp0S4oaXJ8BSPvVrQMljY9+4S6IJK7A46SUeobpjkLGBzd2TLBhpIkyQWtPpCg8DHAp6QP+yWePPouLwYidnkwTkYlucLC++jDzyxFu4F9u3b+QQ+wIJWCEeE0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DFrmmyq3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DFrmmyq3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2412DC4CEF5;
	Tue,  8 Jul 2025 00:02:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1751932943;
	bh=S9ZIRQwMC2r+29JRA34OsR3pNa5ZIQDPOFqcxT7gEWo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DFrmmyq3z4vGQXueRk6vozyMp2AvnUf7mYkdZ2SWgW/WTniRYksyki7x8dVlA6nT/
	 1Rrc57ssKbIDwgv4vGDaf0+uw2MICo3YhghEMAsMIBYywYLC9vrPOmZCx0irWxA3Oe
	 ATAB19X0mxgANB46UCBOj1JswWqHg856zLfwAqmTaTc080hssZu6lJx7/WJBsmSYjz
	 fp+1j7l+CyvEfvj2sjnB0J4hh5a5QqknmgSeOGe8vmaasBg42UoVr28ZB3BsvctdpI
	 P11nH43QxkpAvAbCr/tO7oakT5YtjLHykFtMA7N9Uvu6gUGupRttYJzBBu740z4q95
	 QfYyl9O2g7Fbw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Mario Limonciello <mario.limonciello@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Ray Wu <ray.wu@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	gregkh@linuxfoundation.org,
	harry.wentland@amd.com,
	Wayne.Lin@amd.com,
	Roman.Li@amd.com,
	hersenxs.wu@amd.com,
	chiahsuan.chung@amd.com
Subject: [PATCH AUTOSEL 6.15 4/8] drm/amd/display: Don't allow OLED to go down to fully off
Date: Mon,  7 Jul 2025 20:02:11 -0400
Message-Id: <20250708000215.793090-4-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250708000215.793090-1-sashal@kernel.org>
References: <20250708000215.793090-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.15.5
Content-Transfer-Encoding: 8bit

From: Mario Limonciello <mario.limonciello@amd.com>

[ Upstream commit 39d81457ad3417a98ac826161f9ca0e642677661 ]

[Why]
OLED panels can be fully off, but this behavior is unexpected.

[How]
Ensure that minimum luminance is at least 1.

Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/4338
Reviewed-by: Alex Hung <alex.hung@amd.com>
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Ray Wu <ray.wu@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 51496c7737d06a74b599d0aa7974c3d5a4b1162e)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

## Analysis: **YES**

This commit should be backported to stable kernel trees. Here's my
extensive analysis:

### 1. **Bug Fix Nature**
This commit fixes an important user-visible bug where OLED panels could
turn completely off (go to 0 luminance) when users adjust backlight to
minimum. The code change shows:

**Before the fix:**
```c
if (luminance_range->max_luminance) {
    caps->aux_min_input_signal = luminance_range->min_luminance;
    caps->aux_max_input_signal = luminance_range->max_luminance;
} else {
    caps->aux_min_input_signal = 0;  // <-- This allowed full off
    caps->aux_max_input_signal = 512;
}
```

**After the fix:**
```c
if (luminance_range->max_luminance)
    caps->aux_max_input_signal = luminance_range->max_luminance;
else
    caps->aux_max_input_signal = 512;

if (luminance_range->min_luminance)
    caps->aux_min_input_signal = luminance_range->min_luminance;
else
    caps->aux_min_input_signal = 1;  // <-- Now minimum is 1, preventing
full off
```

### 2. **User Impact**
- The bug affects all users with OLED panels connected via eDP (laptops
  with OLED displays)
- When adjusting brightness to minimum, the screen would go completely
  black, making the system appear unresponsive
- This is a significant usability issue as users would need to blindly
  increase brightness or reboot

### 3. **Minimal and Contained Fix**
The fix is extremely minimal:
- Only 12 lines changed (7 insertions, 5 deletions)
- Changes are confined to a single function
  `update_connector_ext_caps()`
- The logic change is straightforward: ensuring minimum luminance is at
  least 1 instead of 0
- No architectural changes or new features introduced

### 4. **Low Risk of Regression**
- The change only affects the minimum brightness value for OLED panels
- Setting minimum to 1 instead of 0 is a safe change that maintains
  display visibility
- The code path is specific to eDP OLED panels with aux backlight
  support
- No changes to core display logic or other panel types

### 5. **Similar to Previous Backported Commits**
Looking at the similar commits provided:
- "drm/amd/display: Don't register panel_power_savings on OLED panels"
  (YES) - Also an OLED-specific bug fix
- "drm/amd/display: Allow backlight to go below
  `AMDGPU_DM_DEFAULT_MIN_BACKLIGHT`" (YES) - Similar backlight behavior
  fix

### 6. **Cherry-pick Indication**
The commit message includes "(cherry picked from commit
51496c7737d06a74b599d0aa7974c3d5a4b1162e)", indicating it's already been
cherry-picked to at least one branch, suggesting its importance.

### 7. **Bug Report Reference**
The commit closes a tracked issue
(https://gitlab.freedesktop.org/drm/amd/-/issues/4338), indicating this
was a user-reported problem affecting real users.

This fix meets all the criteria for stable backporting: it's a minimal,
contained bug fix that addresses a significant user-visible issue
without introducing new features or architectural changes.

 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index 87c2bc5f64a6c..f6d71bf7c89c2 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -3548,13 +3548,15 @@ static void update_connector_ext_caps(struct amdgpu_dm_connector *aconnector)
 
 	luminance_range = &conn_base->display_info.luminance_range;
 
-	if (luminance_range->max_luminance) {
-		caps->aux_min_input_signal = luminance_range->min_luminance;
+	if (luminance_range->max_luminance)
 		caps->aux_max_input_signal = luminance_range->max_luminance;
-	} else {
-		caps->aux_min_input_signal = 0;
+	else
 		caps->aux_max_input_signal = 512;
-	}
+
+	if (luminance_range->min_luminance)
+		caps->aux_min_input_signal = luminance_range->min_luminance;
+	else
+		caps->aux_min_input_signal = 1;
 
 	min_input_signal_override = drm_get_panel_min_brightness_quirk(aconnector->drm_edid);
 	if (min_input_signal_override >= 0)
-- 
2.39.5

