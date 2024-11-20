Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 779B91AA793;
	Wed, 20 Nov 2024 12:58:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732107531; cv=none; b=oXR0iZjGV2hiiOlYcKJHlugHxHDth2+Ts5iYyzMA69QNtAQ7FyjQTi20nG9vQZCfob8PVT8sSVe17g+Nn/pnFEe9HRi3LfSzokjaaPnPjRW7wh7scU/zFAtNNsVk027NceXAxgtL8FFJwkDtzJLRQ1awTGKhv6IK9YpQBBu3u2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732107531; c=relaxed/simple;
	bh=jCx0CR9Oxx9MQmsiJKa2WJFlo4l4eGSlPZNXFXNAAxY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J1Yysrd4T5DvNzZVx3gGlTZKJh7FUj4xzPK7MOgguymoi5MoEcGmrQBcbnoD797gdTdNiOIFXMKALJHJDgPmn9xXFd6ztqUE2FOw12Qfu6hPoJwvIaLSeBX/vyfWjjI7FyBOf4MAlIiPArwM0BfwaYKSNBscgmvNNLC71J66P0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JB2F7Mde; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JB2F7Mde"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47F01C4CED2;
	Wed, 20 Nov 2024 12:58:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1732107531;
	bh=jCx0CR9Oxx9MQmsiJKa2WJFlo4l4eGSlPZNXFXNAAxY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JB2F7Mde+rguPrD4DRoUyE9qVrTQqldHKVLfSWTlEjH0AhmAghYcS3FraeJg+maBG
	 /jYZjQhsP7aHPqH3l/Y4kVCeBcDbMCSdlWzk/bbQ2b9EGXqZCYXhsRxlUeJCEqUMFA
	 /lk2zG0kDAv2nG1mlE662VYAgOYBj/m2v6gUB2uE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leo Li <sunpeng.li@amd.com>,
	Tom Chung <chiahsuan.chung@amd.com>,
	Hamza Mahfooz <hamza.mahfooz@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.11 037/107] drm/amd/display: Change some variable name of psr
Date: Wed, 20 Nov 2024 13:56:12 +0100
Message-ID: <20241120125630.515933572@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241120125629.681745345@linuxfoundation.org>
References: <20241120125629.681745345@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tom Chung <chiahsuan.chung@amd.com>

commit b8d9d5fef4915a383b4ce4d0f418352aa4701a87 upstream.

Panel Replay feature may also use the same variable with PSR.
Change the variable name and make it not specify for PSR.

Reviewed-by: Leo Li <sunpeng.li@amd.com>
Signed-off-by: Tom Chung <chiahsuan.chung@amd.com>
Signed-off-by: Hamza Mahfooz <hamza.mahfooz@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit c7fafb7a46b38a11a19342d153f505749bf56f3e)
Cc: stable@vger.kernel.org # 6.11+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c            |   22 +++++------
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h            |    2 -
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_crtc.c       |    2 -
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_irq_params.h |    2 -
 4 files changed, 14 insertions(+), 14 deletions(-)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -6740,7 +6740,7 @@ create_stream_for_sink(struct drm_connec
 		if (stream->out_transfer_func.tf == TRANSFER_FUNCTION_GAMMA22)
 			tf = TRANSFER_FUNC_GAMMA_22;
 		mod_build_vsc_infopacket(stream, &stream->vsc_infopacket, stream->output_color_space, tf);
-		aconnector->psr_skip_count = AMDGPU_DM_PSR_ENTRY_DELAY;
+		aconnector->sr_skip_count = AMDGPU_DM_PSR_ENTRY_DELAY;
 
 	}
 finish:
@@ -8983,7 +8983,7 @@ static void amdgpu_dm_commit_planes(stru
 			 * during the PSR-SU was disabled.
 			 */
 			if (acrtc_state->stream->link->psr_settings.psr_version >= DC_PSR_VERSION_SU_1 &&
-			    acrtc_attach->dm_irq_params.allow_psr_entry &&
+			    acrtc_attach->dm_irq_params.allow_sr_entry &&
 #ifdef CONFIG_DRM_AMD_SECURE_DISPLAY
 			    !amdgpu_dm_crc_window_is_activated(acrtc_state->base.crtc) &&
 #endif
@@ -9218,27 +9218,27 @@ static void amdgpu_dm_commit_planes(stru
 			}
 		}
 
-		/* Decrement skip count when PSR is enabled and we're doing fast updates. */
+		/* Decrement skip count when SR is enabled and we're doing fast updates. */
 		if (acrtc_state->update_type == UPDATE_TYPE_FAST &&
 		    acrtc_state->stream->link->psr_settings.psr_feature_enabled) {
 			struct amdgpu_dm_connector *aconn =
 				(struct amdgpu_dm_connector *)acrtc_state->stream->dm_stream_context;
 
-			if (aconn->psr_skip_count > 0)
-				aconn->psr_skip_count--;
+			if (aconn->sr_skip_count > 0)
+				aconn->sr_skip_count--;
 
-			/* Allow PSR when skip count is 0. */
-			acrtc_attach->dm_irq_params.allow_psr_entry = !aconn->psr_skip_count;
+			/* Allow SR when skip count is 0. */
+			acrtc_attach->dm_irq_params.allow_sr_entry = !aconn->sr_skip_count;
 
 			/*
-			 * If sink supports PSR SU, there is no need to rely on
-			 * a vblank event disable request to enable PSR. PSR SU
+			 * If sink supports PSR SU/Panel Replay, there is no need to rely on
+			 * a vblank event disable request to enable PSR/RP. PSR SU/RP
 			 * can be enabled immediately once OS demonstrates an
 			 * adequate number of fast atomic commits to notify KMD
 			 * of update events. See `vblank_control_worker()`.
 			 */
 			if (acrtc_state->stream->link->psr_settings.psr_version >= DC_PSR_VERSION_SU_1 &&
-			    acrtc_attach->dm_irq_params.allow_psr_entry &&
+			    acrtc_attach->dm_irq_params.allow_sr_entry &&
 #ifdef CONFIG_DRM_AMD_SECURE_DISPLAY
 			    !amdgpu_dm_crc_window_is_activated(acrtc_state->base.crtc) &&
 #endif
@@ -9249,7 +9249,7 @@ static void amdgpu_dm_commit_planes(stru
 			    500000000)
 				amdgpu_dm_psr_enable(acrtc_state->stream);
 		} else {
-			acrtc_attach->dm_irq_params.allow_psr_entry = false;
+			acrtc_attach->dm_irq_params.allow_sr_entry = false;
 		}
 
 		mutex_unlock(&dm->dc_lock);
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h
@@ -727,7 +727,7 @@ struct amdgpu_dm_connector {
 	/* Cached display modes */
 	struct drm_display_mode freesync_vid_base;
 
-	int psr_skip_count;
+	int sr_skip_count;
 	bool disallow_edp_enter_psr;
 
 	/* Record progress status of mst*/
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_crtc.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_crtc.c
@@ -269,7 +269,7 @@ static void amdgpu_dm_crtc_vblank_contro
 	if (vblank_work->stream && vblank_work->stream->link) {
 		amdgpu_dm_crtc_set_panel_sr_feature(
 			vblank_work, vblank_work->enable,
-			vblank_work->acrtc->dm_irq_params.allow_psr_entry ||
+			vblank_work->acrtc->dm_irq_params.allow_sr_entry ||
 			vblank_work->stream->link->replay_settings.replay_feature_enabled);
 	}
 
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_irq_params.h
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_irq_params.h
@@ -33,7 +33,7 @@ struct dm_irq_params {
 	struct mod_vrr_params vrr_params;
 	struct dc_stream_state *stream;
 	int active_planes;
-	bool allow_psr_entry;
+	bool allow_sr_entry;
 	struct mod_freesync_config freesync_config;
 
 #ifdef CONFIG_DEBUG_FS


