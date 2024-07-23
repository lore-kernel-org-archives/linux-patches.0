Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6793B49634;
	Tue, 23 Jul 2024 18:45:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721760305; cv=none; b=fSvbGrMy+i840WDcRgqiBR9PrC8hM5WQjOvAx6L3NPorExK7JtuDsLg7pzv8BqVZ/5c6jqCbg/CVmIkfe56EvxryNhztIXMpo00dvE8eskAw41U1taLYHDmx/lfLAKSErTwky4K6HafStaHfrbjH5aRn9EqQ950kntYjwunfFqY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721760305; c=relaxed/simple;
	bh=lOgOjc/UxxLu6aUMefGMRWWnximUpo/wVPU0R0A73Cw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c5ZHzmldIhx9oIU7DySCLHS0T81AnF2Gs2tIKafTjEQGiKWxi2ZbCYBVeQsuR/SNh3tE8opmTWpQwdVTfFF6MVQZUVh1rU61W5cvnp34l5U34QIYgM2BQ7j4GoJNc7wHOvr42iV2baNfEt9le6MGzaQL1nXPwBLeTakl/lcDCSU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XqQ9Iu/i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XqQ9Iu/i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E11A9C4AF0A;
	Tue, 23 Jul 2024 18:45:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721760305;
	bh=lOgOjc/UxxLu6aUMefGMRWWnximUpo/wVPU0R0A73Cw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XqQ9Iu/ifD/IFd7Br4bNcGjPOtDJ1N9tgT6in68PjV4q+01dwDLan7RvbU950eNrk
	 koOSGOUB0IRZ2Z0L+wCBUGSoHh7rpnTD1V+QzUuKRZ0w8xSYMB5sn7K/gXIVMWDdd6
	 uFOJEMIxHCl14rRcuePaptezaNyObpCJybZUPU0Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Rodrigo Siqueira <rodrigo.siqueira@amd.com>,
	Jerry Zuo <jerry.zuo@amd.com>,
	Tom Chung <chiahsuan.chung@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 133/163] drm/amd/display: Add refresh rate range check
Date: Tue, 23 Jul 2024 20:24:22 +0200
Message-ID: <20240723180148.613332848@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240723180143.461739294@linuxfoundation.org>
References: <20240723180143.461739294@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tom Chung <chiahsuan.chung@amd.com>

[ Upstream commit 74ad26b36d303ac233eccadc5c3a8d7ee4709f31 ]

[Why]
We only enable the VRR while monitor usable refresh rate range
is greater than 10 Hz.
But we did not check the range in DRM_EDID_FEATURE_CONTINUOUS_FREQ
case.

[How]
Add a refresh rate range check before set the freesync_capable flag
in DRM_EDID_FEATURE_CONTINUOUS_FREQ case.

Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
Reviewed-by: Rodrigo Siqueira <rodrigo.siqueira@amd.com>
Signed-off-by: Jerry Zuo <jerry.zuo@amd.com>
Signed-off-by: Tom Chung <chiahsuan.chung@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index 2152e40ee1c27..087d7aad8e6b4 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -11289,9 +11289,11 @@ void amdgpu_dm_update_freesync_caps(struct drm_connector *connector,
 		if (is_dp_capable_without_timing_msa(adev->dm.dc,
 						     amdgpu_dm_connector)) {
 			if (edid->features & DRM_EDID_FEATURE_CONTINUOUS_FREQ) {
-				freesync_capable = true;
 				amdgpu_dm_connector->min_vfreq = connector->display_info.monitor_range.min_vfreq;
 				amdgpu_dm_connector->max_vfreq = connector->display_info.monitor_range.max_vfreq;
+				if (amdgpu_dm_connector->max_vfreq -
+				    amdgpu_dm_connector->min_vfreq > 10)
+					freesync_capable = true;
 			} else {
 				edid_check_required = edid->version > 1 ||
 						      (edid->version == 1 &&
-- 
2.43.0



