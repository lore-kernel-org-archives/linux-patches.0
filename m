Received: from xmbghk7.mail.qq.com (xmbghk7.mail.qq.com [43.163.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36A6534D382
	for <patches@lists.linux.dev>; Thu,  7 May 2026 07:08:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=43.163.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778137690; cv=none; b=G12+9aNRDSnqim7KIyqJCsXUuBkbbtXEfA167CZ/LoxT9FTSof3ODxeghGFGlvZQ8PMqWFYVdmYDNMtvH1dJjiLAB+8Sw/rJbYdAxcE5pRVZ/O/X9KMtwHIeGGgJpFfIAGnUMASXAk5XV+AznTMVFu0pIZLf523xY9vV0E4Tme4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778137690; c=relaxed/simple;
	bh=WsYLyzrzblEslodFIMgSCQ+msNQ83hodnOZNDiXCBzc=;
	h=Message-ID:From:To:Cc:Subject:Date:MIME-Version; b=sNpLvDp70/Is6Vz7qt6/9jk05VKXkq6mGBFwznhKsLjiT8P54ZEzBlLOSRIwmn2R8gf4gla1erKX3PhugZu9H0RTCiFddgC8cCQUXhF/Z+zRIDCDZVoLHBBvVkniSMZL6XAx7UQRZiet1T3NwvkpLDJV6mArrGZw70kSTVgDx7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=grJDMG22; arc=none smtp.client-ip=43.163.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="grJDMG22"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1778137673; bh=jhfMdr7ZuzPK+ksWRv7O9E7u4d/Szfr8t5hOhPrLLPQ=;
	h=From:To:Cc:Subject:Date;
	b=grJDMG22MtvdhF1WBJIa2REolhCbgBuU3lBHKdq0/8c7y9Hg5DcePjVKznICgg1NS
	 wVqiI8S7M4fDPgb06Znxd/9eWsA06Nk6vcCnghW2jViQr+LaB1df7l96yT6BQp5Q6u
	 hhz1BmswYb+Pzbzpd49gntxE8N7OAJ0cGaju0SIs=
Received: from NTT-kernel-dev ([60.247.85.88])
	by newxmesmtplogicsvrszc56-0.qq.com (NewEsmtp) with SMTP
	id 1F10E06F; Thu, 07 May 2026 15:07:49 +0800
X-QQ-mid: xmsmtpt1778137669txqd1xqw3
Message-ID: <tencent_7AE3B3373BFCA4633D11AD72CF6897B3EB07@qq.com>
X-QQ-XMAILINFO: NbgegmlEc3JuoJxuK2QvNBHzvgoB2/ycHaXZXV2LHoggvdBcWnfw8r2vTByxaT
	 u+J1DSdyyTyTlM69lYD+epVJHWfpyWLIKJVGkMNYjURg6UmtQ6tdyrQtXA00ktMhWUWSExihz7c7
	 kiLXms1uRWDYPi1Nq0y920MxCy6qE1gy283ORkru/mNySzuEnPRSYBQsrCySCVvRQmEwxrfc02sC
	 vlsAeCLP3kWophnvQ7LaGEIp299Xd+rMPbYNpsTXNBCvU/2pOI3735/2d4kVqu85UnsGxR9t0KZ/
	 ycPljMQUmRAFdpxIO8QYZ0NvGmMIMHYYFwa8bo2yfkEwYLz9NRyRWP6JuX2WKFJWT3n1Og6AOPR1
	 vDWjZBvU02Ipfr5DDiKwP3ti0eVBjiYzMmwqU97m8XULFf3bJHNv5i3pAiv5+UfTM41aCbD9K9fJ
	 LMPUbrF2GCLLA3IblmYJ6h9r8zKH+drOurzLu8X4rwB4Y+/d2q11vf2tWaqkXtF31kuo9ktlImgt
	 xyL6Oatnmh6qU5q/tEG5gj54B4lHKgpbHRb3CFJXmzQeTcq7Cj868LmAUk1i9S64MLcigAhsAwKR
	 KEBSUg1rTePGjo4YOPeirH4xquPMw6URZnc96HdcKHRUXNsirRDqTA6Qe0rwDjeaghWMqI+bFuBA
	 ZnTIow+2krhPToHpdn0yJTSOLnar9Qlbw0Px/7gEw9Qoeh6ndSbvADcEIl7qVrX7osme7kU6Y447
	 omS/AjOoe2yqZEefPndIB/ezyU5RmUTCYdUE80P3S3A1WkJ2wFkHXLFylgCI+xg+tzFCSMaHWu0g
	 ZmQrUwHhGlHj1d5mX2P8Iq7Z9qoTkJTg424uaotirMyzRGSIbABZpDE5L9OLSyJaJ1/G6IMCQ/rK
	 +OsGwiaPGpl+1sxnrzSmmbTFyjVn+Jc1sw583tcpMMOkZfjEY4qT5V5DAiEINoRjpHPnHAsepzHC
	 74aqs3tdHrefmpPL1J7JgjbovlrIg4Yz7XQneqjN5O4IXT4V1TVD7ppwhsvA3dkRXN+wGjXK+Wij
	 Ll6TfY8KlGFQO16gNsbkCSjtDOLUkyCzBDpokxoy1yaRcfAAsCXQdYuVPO2mujFVlRXpa2dYv95F
	 Q20PZ8RVahp75BVjxZHNrKJL98yQ==
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
Subject: [PATCH 6.1.y] drm/amd/display: Do not skip unrelated mode changes in DSC validation
Date: Thu,  7 May 2026 15:07:49 +0800
X-OQ-MSGID: <20260507070749.2299524-1-32840572@qq.com>
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
index 7eff2b94ab66..bb5e3a6086f2 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -9908,6 +9908,11 @@ static int amdgpu_dm_atomic_check(struct drm_device *dev,
 
 #if defined(CONFIG_DRM_AMD_DC_DCN)
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
index df18b4df1f2c..12385b6f8443 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h
@@ -698,6 +698,7 @@ struct dm_crtc_state {
 
 	bool freesync_vrr_info_changed;
 
+	bool mode_changed_independent_from_dsc;
 	bool dsc_force_changed;
 	bool vrr_supported;
 	struct mod_freesync_config freesync_config;
diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
index 495491decec1..94c83a707acc 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
@@ -1564,8 +1564,11 @@ int pre_validate_dsc(struct drm_atomic_state *state,
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

