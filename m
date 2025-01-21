Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9D051F3FFE;
	Tue, 21 Jan 2025 18:02:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737482559; cv=none; b=iLX9Gu2jzcWsRzHf3xL2ez1Cnpcfw7cMeKhtGNuFqK3H2dDtC4KcRbSQCsLS4wSpwJrAKaLzvpYJ4uhSMuft3Gj+MrDQnfmnAGLxbmvkeucGHjiOEIZYNast8O/ACzHrMV5Cc1h0OQExyyenniwEopPQQhsHwUIFTPP7VNbaKSA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737482559; c=relaxed/simple;
	bh=CBZ6VDLrRieJFnq+SYzah5QKuOiyzD7y1dUK6Pr0tGc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UG4IGRFd38C+AyIZb/lUfKkQZjd6tPKVj5gi67jdE7492HlVCCPlWRvvOb8ky7jVEZyvZLOFrb2P9qHip37EEoVUYAjZnikN5H/WUC/unNwaqVdHCG+oI39hiYNow2JfkiWEPmmUpEEyyyxZ1/pBgzDN7924mSRGwawT7d/kcpE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cQYE+jQf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cQYE+jQf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35EABC4CEE1;
	Tue, 21 Jan 2025 18:02:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737482559;
	bh=CBZ6VDLrRieJFnq+SYzah5QKuOiyzD7y1dUK6Pr0tGc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cQYE+jQfNb8xOPNhVVwOL8ZuBIqqqtf68PUlSnWDyK1TTJc5x+9gU+PghD0XIhLKS
	 iGlDTCrf1dADmrX050/K7WyFGerVvXBRqWfLdqTCSBIdzxsLz1/WJzCPPIGj7CXq4V
	 teDjaNS1xAn+0bTAr/mB9DqAGZq7g4brSgNitG/E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sun peng Li <sunpeng.li@amd.com>,
	Tom Chung <chiahsuan.chung@amd.com>,
	Roman Li <roman.li@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.12 118/122] drm/amd/display: Disable replay and psr while VRR is enabled
Date: Tue, 21 Jan 2025 18:52:46 +0100
Message-ID: <20250121174537.603358473@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250121174532.991109301@linuxfoundation.org>
References: <20250121174532.991109301@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tom Chung <chiahsuan.chung@amd.com>

commit 67edb81d6e9af43a0d58edf74630f82cfda4155d upstream.

[Why]
Replay and PSR will cause some video corruption while VRR is enabled.

[How]
1. Disable the Replay and PSR while VRR is enabled.
2. Change the amdgpu_dm_crtc_vrr_active() parameter to const.
   Because the function will only read data from dm_crtc_state.

Reviewed-by: Sun peng Li <sunpeng.li@amd.com>
Signed-off-by: Tom Chung <chiahsuan.chung@amd.com>
Signed-off-by: Roman Li <roman.li@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit d7879340e987b3056b8ae39db255b6c19c170a0d)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c      |    6 ++++--
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_crtc.c |    2 +-
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_crtc.h |    2 +-
 3 files changed, 6 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -8889,6 +8889,7 @@ static void amdgpu_dm_enable_self_refres
 	struct replay_settings *pr = &acrtc_state->stream->link->replay_settings;
 	struct amdgpu_dm_connector *aconn =
 		(struct amdgpu_dm_connector *)acrtc_state->stream->dm_stream_context;
+	bool vrr_active = amdgpu_dm_crtc_vrr_active(acrtc_state);
 
 	if (acrtc_state->update_type > UPDATE_TYPE_FAST) {
 		if (pr->config.replay_supported && !pr->replay_feature_enabled)
@@ -8915,7 +8916,8 @@ static void amdgpu_dm_enable_self_refres
 		 * adequate number of fast atomic commits to notify KMD
 		 * of update events. See `vblank_control_worker()`.
 		 */
-		if (acrtc_attach->dm_irq_params.allow_sr_entry &&
+		if (!vrr_active &&
+		    acrtc_attach->dm_irq_params.allow_sr_entry &&
 #ifdef CONFIG_DRM_AMD_SECURE_DISPLAY
 		    !amdgpu_dm_crc_window_is_activated(acrtc_state->base.crtc) &&
 #endif
@@ -9259,7 +9261,7 @@ static void amdgpu_dm_commit_planes(stru
 			bundle->stream_update.abm_level = &acrtc_state->abm_level;
 
 		mutex_lock(&dm->dc_lock);
-		if (acrtc_state->update_type > UPDATE_TYPE_FAST) {
+		if ((acrtc_state->update_type > UPDATE_TYPE_FAST) || vrr_active) {
 			if (acrtc_state->stream->link->replay_settings.replay_allow_active)
 				amdgpu_dm_replay_disable(acrtc_state->stream);
 			if (acrtc_state->stream->link->psr_settings.psr_allow_active)
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_crtc.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_crtc.c
@@ -93,7 +93,7 @@ int amdgpu_dm_crtc_set_vupdate_irq(struc
 	return rc;
 }
 
-bool amdgpu_dm_crtc_vrr_active(struct dm_crtc_state *dm_state)
+bool amdgpu_dm_crtc_vrr_active(const struct dm_crtc_state *dm_state)
 {
 	return dm_state->freesync_config.state == VRR_STATE_ACTIVE_VARIABLE ||
 	       dm_state->freesync_config.state == VRR_STATE_ACTIVE_FIXED;
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_crtc.h
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_crtc.h
@@ -37,7 +37,7 @@ int amdgpu_dm_crtc_set_vupdate_irq(struc
 
 bool amdgpu_dm_crtc_vrr_active_irq(struct amdgpu_crtc *acrtc);
 
-bool amdgpu_dm_crtc_vrr_active(struct dm_crtc_state *dm_state);
+bool amdgpu_dm_crtc_vrr_active(const struct dm_crtc_state *dm_state);
 
 int amdgpu_dm_crtc_enable_vblank(struct drm_crtc *crtc);
 


