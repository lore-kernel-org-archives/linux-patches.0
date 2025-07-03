Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BD0022069F;
	Thu,  3 Jul 2025 15:09:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751555351; cv=none; b=N8j8njgl69ozbZYtfVbySLfhKTo12yTpSrPxD10L+oVrg7BmjWf53Oc1hS74pAOG3FGJcoHoYrTVXBqvY08ct0g3xjVwXGZRWbx9rvfU1aMzmg1AlYGU0BmqWK7CaI2bKrFZng1lEwNuPrpBjl9G0BkLlhWMZC6Oqe8H/FYGruk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751555351; c=relaxed/simple;
	bh=NV/PU24PJ7db0L6xL8lgrym6HxL7wt7XQ/HX7zh6/w8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mLfrF3frKPR5Fbgbi6smk0KLOR/EdTTMhjQH5a4wmbbeBXgd/RVWy5HB6zmhclXwl6bWuZU7Pt2dey82GUp8sVYXp9GRn4NClh9tNdVVHb19mVCSwQPi8vjfWNSaFbHcwgihb7/V02oG0GYUxbbxPK0ofoxnCW8m8HbQo/RK0AU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Bkbgljln; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Bkbgljln"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82135C4CEF1;
	Thu,  3 Jul 2025 15:09:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751555351;
	bh=NV/PU24PJ7db0L6xL8lgrym6HxL7wt7XQ/HX7zh6/w8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BkbgljlnyqFLGBbb60/MluPAF53jeZZvHxOVVBjwp9gKr7aJy1DFOA2EFBHz5rB0O
	 RmaguLtqmcEpG84dnFr5uybjx2hX6JVgpFCexQxb1ucHjwhQPJ51ELoCF2erl3umFY
	 +iNwhZo9+K+r7Bo2bqO5kmPw/H6oxJjn2WLD9TfQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Roman Li <roman.li@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 251/263] drm/amd/display: Only read ACPI backlight caps once
Date: Thu,  3 Jul 2025 16:42:51 +0200
Message-ID: <20250703144014.476434238@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703144004.276210867@linuxfoundation.org>
References: <20250703144004.276210867@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mario Limonciello <mario.limonciello@amd.com>

[ Upstream commit ffcaed1d7ecef31198000dfbbea791f30f7ca437 ]

[WHY]
Backlight caps are read already in amdgpu_dm_update_backlight_caps().
They may be updated by update_connector_ext_caps(). Reading again when
registering backlight device may cause wrong values to be used.

[HOW]
Use backlight caps already registered to the dm.

Cc: Mario Limonciello <mario.limonciello@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Roman Li <roman.li@amd.com>
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Alex Hung <alex.hung@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 148144f6d2f14b02eaaa39b86bbe023cbff350bd)
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index 389748c420b02..e61166a8230b6 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -4832,7 +4832,7 @@ amdgpu_dm_register_backlight_device(struct amdgpu_dm_connector *aconnector)
 	struct drm_device *drm = aconnector->base.dev;
 	struct amdgpu_display_manager *dm = &drm_to_adev(drm)->dm;
 	struct backlight_properties props = { 0 };
-	struct amdgpu_dm_backlight_caps caps = { 0 };
+	struct amdgpu_dm_backlight_caps *caps;
 	char bl_name[16];
 	int min, max;
 
@@ -4846,20 +4846,20 @@ amdgpu_dm_register_backlight_device(struct amdgpu_dm_connector *aconnector)
 		return;
 	}
 
-	amdgpu_acpi_get_backlight_caps(&caps);
-	if (caps.caps_valid && get_brightness_range(&caps, &min, &max)) {
+	caps = &dm->backlight_caps[aconnector->bl_idx];
+	if (get_brightness_range(caps, &min, &max)) {
 		if (power_supply_is_system_supplied() > 0)
-			props.brightness = (max - min) * DIV_ROUND_CLOSEST(caps.ac_level, 100);
+			props.brightness = (max - min) * DIV_ROUND_CLOSEST(caps->ac_level, 100);
 		else
-			props.brightness = (max - min) * DIV_ROUND_CLOSEST(caps.dc_level, 100);
+			props.brightness = (max - min) * DIV_ROUND_CLOSEST(caps->dc_level, 100);
 		/* min is zero, so max needs to be adjusted */
 		props.max_brightness = max - min;
 		drm_dbg(drm, "Backlight caps: min: %d, max: %d, ac %d, dc %d\n", min, max,
-			caps.ac_level, caps.dc_level);
+			caps->ac_level, caps->dc_level);
 	} else
 		props.brightness = AMDGPU_MAX_BL_LEVEL;
 
-	if (caps.data_points && !(amdgpu_dc_debug_mask & DC_DISABLE_CUSTOM_BRIGHTNESS_CURVE))
+	if (caps->data_points && !(amdgpu_dc_debug_mask & DC_DISABLE_CUSTOM_BRIGHTNESS_CURVE))
 		drm_info(drm, "Using custom brightness curve\n");
 	props.max_brightness = AMDGPU_MAX_BL_LEVEL;
 	props.type = BACKLIGHT_RAW;
-- 
2.39.5



