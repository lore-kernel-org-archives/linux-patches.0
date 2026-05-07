Received: from out162-62-57-210.mail.qq.com (out162-62-57-210.mail.qq.com [162.62.57.210])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 715D032779D
	for <patches@lists.linux.dev>; Thu,  7 May 2026 07:07:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=162.62.57.210
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778137673; cv=none; b=I/A3q3nQO4aGd9sb98wqoQtf367q4HpPIV35LlxifNVEjjn2Ttd6rwHpsoIPhSF1RCQkIyzUgAQNWmntZkw5bIrZ+Iht2JvR8QljzpRwExlNnjRxh78Vfnba6Qsm5ezX4gj8HTQXXd7rekAaTU4S3xCdHScTOrDsKFuuEADOY90=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778137673; c=relaxed/simple;
	bh=8FRViC4v3BKLTLc14G0IuejVbnMlw8IZ8RLH1merI0Y=;
	h=Message-ID:From:To:Cc:Subject:Date:MIME-Version; b=k2PgMzxwFRu0ugP3YZqwYz2VKY8pMOYzI8w3iEzw9Car8xJ/hIn842sd0cfyJ7m5UvkJRcmaVj+K6MV0y+GD9ygpbC387saGX4eZUK9bX9/KSjLWgwvXhvSiTy4wEgY9sZDonsUZEozEKlh8Se//J4wgjPwmqmwdAOshExJ9IiM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=SZy4nju/; arc=none smtp.client-ip=162.62.57.210
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="SZy4nju/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1778137659; bh=iskF8EoVx1eo+u9A/G98mixKei1oUBNv8bPdbjEb1eU=;
	h=From:To:Cc:Subject:Date;
	b=SZy4nju/XnCEOmlq2doq5xuLpH53fUDiLkZ2dMy9CSSuxK2d3/smoMY9h7CXShL8c
	 lCbUdhmoYnAiTslQW53mDXy6Ezr5ZFE4+S2itqW29Z9/WCAhXgKkqnqAB5SecfMD07
	 HJQfdaCB61DvtBTrzEyyJPLwUE49hQP6xZxegxxg=
Received: from NTT-kernel-dev ([60.247.85.88])
	by newxmesmtplogicsvrsza53-0.qq.com (NewEsmtp) with SMTP
	id 1E23C653; Thu, 07 May 2026 15:07:34 +0800
X-QQ-mid: xmsmtpt1778137654tvpn0zexu
Message-ID: <tencent_CCDB1B23FED831830856396BB4DF59D1B106@qq.com>
X-QQ-XMAILINFO: M0vdiI0AC4YkCeFnOQd/Eo9/iodKPHs5oU6o8zGDpT0HZp0yiCh3ASQlSn5snD
	 UirnXplLp0LTqU40FyFDOzZAtsponI6rBi3vETFJLH1NoA/iWm5Z5r5A/TleDF6sgd79kmUoGbPs
	 je+3pC7onu1BU5CmTMtNW+ki3do0R1k9OpJds+DJqJkmusGyzNuQ8CxSN+CBhx97DuZIJzdnXf5T
	 9ly/M1ejh8b63lLZL2luTItVsJzSOthOAWe/EM+SYlfkxWVwE9yoyPxfIE9fskYAmErkIf45IATV
	 8tL0Al9f2UFe/njQyc+Wwa0fWlxocUoCwws/sNEKq1iL6yJp2KpHMTOVkYDjfIxM3MrYL+D9e1Jl
	 p9wZWJ27gZTvGjZPOYn1NXC+1wFeymM1+mJ7okODyf5Dr17uuLT/hHHLsExgvD9ySS2p6vSyPq8s
	 4q4TJugTQdxPy5paLe31B7neE3Yl3ZJBmTPacPfN1BgTjTVqK3fnaPMZ/VasKIugwgQwJ0BwITZG
	 2NIFG7ooBRQ5f35l6p7qqbOXgmuAvLpLWxu/bVeTkWAq3VxNsO8tafo3It8SrSSF20EQxMfUjCuF
	 UpnJ3hMrz2mH9mOmTYQeJfBd6sVg09gVQPkBbZRRFDLAFmPpQgVt14c3NUqkpAWhWEaGxqwq0+RX
	 RYcWtyuoyl04mkBv/fPe0MW54eh7nAojRxBfLTOB3WQbnmnj69q9adkx+hbIKbiy2A4ssPpMmAP8
	 nbTNpIjUyxZ4dKvLM0m6NPdgnV5gOoXJ2cdOAS17yvyX5JvDK7yvT65iB4PIlDSOpniwO47QfLUQ
	 qxXF3+bNZXTeqThNGs63LTRNbbSAub9NlOj+nmN7U36gU3juL8AhKM3C2cDiM3jGswzMZxBLrRtS
	 6gBsDg9MYWG+6Qq8gHJBttSMog78M/9m/XUD08Js4aKxQ9GsmxgdY+w4bFrHES1XtosHhAKxpi4Y
	 MYr0bPhc4Ps/KmXG1kgQeLsi1MFW1qkBDaLDavSzFy6GyTkr65iNKrWRWvsWA/td/zp5tOaGR7jI
	 iGfwHyc+iPB+7MroIjrZjPnAYyYRwmrHlfFNbwYg==
X-QQ-XMRINFO: MSVp+SPm3vtSI1QTLgDHQqIV1w2oNKDqfg==
From: Fang Wang <32840572@qq.com>
To: gregkh@linuxfoundation.org,
	stable@vger.kernel.org,
	dev@pp3345.net
Cc: patches@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	harry.wentland@amd.com,
	sunpeng.li@amd.com,
	Rodrigo.Siqueira@amd.com,
	alexander.deucher@amd.com,
	christian.koenig@amd.com,
	Xinhui.Pan@amd.com,
	airlied@gmail.com,
	daniel@ffwll.ch,
	ray.wu@amd.com,
	Wayne.Lin@amd.com,
	sashal@kernel.org,
	mario.limonciello@amd.com,
	aurabindo.pillai@amd.com,
	timur.kristof@gmail.com,
	jdhillon@amd.com,
	hersenwu@amd.com,
	Roman.Li@amd.com,
	amd-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org
Subject: [PATCH 6.6.y] drm/amd/display: Do not skip unrelated mode changes in DSC validation
Date: Thu,  7 May 2026 15:07:29 +0800
X-OQ-MSGID: <20260507070729.2299428-1-32840572@qq.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Yussuf Khalil <dev@pp3345.net>

[ Upstream commit aed3d041ab061ec8a64f50a3edda0f4db7280025 ]

Starting with commit 17ce8a6907f7 ("drm/amd/display: Add dsc pre-validation in
atomic check"), amdgpu resets the CRTC state mode_changed flag to false when
recomputing the DSC configuration results in no timing change for a particular
stream.

However, this is incorrect in scenarios where a change in MST/DSC configuration
happens in the same KMS commit as another (unrelated) mode change. For example,
the integrated panel of a laptop may be configured differently (e.g., HDR
enabled/disabled) depending on whether external screens are attached. In this
case, plugging in external DP-MST screens may result in the mode_changed flag
being dropped incorrectly for the integrated panel if its DSC configuration
did not change during precomputation in pre_validate_dsc().

At this point, however, dm_update_crtc_state() has already created new streams
for CRTCs with DSC-independent mode changes. In turn,
amdgpu_dm_commit_streams() will never release the old stream, resulting in a
memory leak. amdgpu_dm_atomic_commit_tail() will never acquire a reference to
the new stream either, which manifests as a use-after-free when the stream gets
disabled later on:

BUG: KASAN: use-after-free in dc_stream_release+0x25/0x90 [amdgpu]
Write of size 4 at addr ffff88813d836524 by task kworker/9:9/29977

Workqueue: events drm_mode_rmfb_work_fn
Call Trace:
 <TASK>
 dump_stack_lvl+0x6e/0xa0
 print_address_description.constprop.0+0x88/0x320
 ? dc_stream_release+0x25/0x90 [amdgpu]
 print_report+0xfc/0x1ff
 ? srso_alias_return_thunk+0x5/0xfbef5
 ? __virt_addr_valid+0x225/0x4e0
 ? dc_stream_release+0x25/0x90 [amdgpu]
 kasan_report+0xe1/0x180
 ? dc_stream_release+0x25/0x90 [amdgpu]
 kasan_check_range+0x125/0x200
 dc_stream_release+0x25/0x90 [amdgpu]
 dc_state_destruct+0x14d/0x5c0 [amdgpu]
 dc_state_release.part.0+0x4e/0x130 [amdgpu]
 dm_atomic_destroy_state+0x3f/0x70 [amdgpu]
 drm_atomic_state_default_clear+0x8ee/0xf30
 ? drm_mode_object_put.part.0+0xb1/0x130
 __drm_atomic_state_free+0x15c/0x2d0
 atomic_remove_fb+0x67e/0x980

Since there is no reliable way of figuring out whether a CRTC has unrelated
mode changes pending at the time of DSC validation, remember the value of the
mode_changed flag from before the point where a CRTC was marked as potentially
affected by a change in DSC configuration. Reset the mode_changed flag to this
earlier value instead in pre_validate_dsc().

Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/5004
Fixes: 17ce8a6907f7 ("drm/amd/display: Add dsc pre-validation in atomic check")
Signed-off-by: Yussuf Khalil <dev@pp3345.net>
Reviewed-by: Harry Wentland <harry.wentland@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit cc7c7121ae082b7b82891baa7280f1ff2608f22b)
Signed-off-by: Fang Wang <32840572@qq.com>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c          | 5 +++++
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h          | 1 +
 .../gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c    | 7 +++++--
 3 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index f51c3921cbc2..12f75b2ad664 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -10152,6 +10152,11 @@ static int amdgpu_dm_atomic_check(struct drm_device *dev,
 	}
 
 	if (dc_resource_is_dsc_encoding_supported(dc)) {
+		for_each_oldnew_crtc_in_state(state, crtc, old_crtc_state, new_crtc_state, i) {
+			dm_new_crtc_state = to_dm_crtc_state(new_crtc_state);
+			dm_new_crtc_state->mode_changed_independent_from_dsc = new_crtc_state->mode_changed;
+		}
+
 		for_each_oldnew_crtc_in_state(state, crtc, old_crtc_state, new_crtc_state, i) {
 			if (drm_atomic_crtc_needs_modeset(new_crtc_state)) {
 				ret = add_affected_mst_dsc_crtcs(state, crtc);
diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h
index 88606b805330..8d4f2cadb915 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h
@@ -737,6 +737,7 @@ struct dm_crtc_state {
 
 	bool freesync_vrr_info_changed;
 
+	bool mode_changed_independent_from_dsc;
 	bool dsc_force_changed;
 	bool vrr_supported;
 	struct mod_freesync_config freesync_config;
diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
index 2698e5c74ddf..ab6924d3046b 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
@@ -1587,8 +1587,11 @@ int pre_validate_dsc(struct drm_atomic_state *state,
 		} else {
 			int ind = find_crtc_index_in_state_by_stream(state, stream);
 
-			if (ind >= 0)
-				state->crtcs[ind].new_state->mode_changed = 0;
+			if (ind >= 0) {
+				struct dm_crtc_state *dm_new_crtc_state = to_dm_crtc_state(state->crtcs[ind].new_state);
+
+				dm_new_crtc_state->base.mode_changed = dm_new_crtc_state->mode_changed_independent_from_dsc;
+			}
 		}
 	}
 clean_exit:
-- 
2.34.1

