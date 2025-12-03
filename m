Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F63734E768;
	Wed,  3 Dec 2025 16:19:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764778789; cv=none; b=XB/FGCKRgsWT1vDy/+8fW4CZpVka9zWabn+DaGgX1MO3Hrq8qtUX2UfTEmxnwyddOsdA0NkURsRRv/QYU4pntoD8ONPrEThTZWj23LgjLeTqVrszmuhORo2EAnDzsYk+TM95Y0is7LxYFiItg5q0NhNKhOFjmftO37H7vzoz1aU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764778789; c=relaxed/simple;
	bh=H0w2D5rLjiPZj0FocZh8+K245zP+CEuAko7mBKgKFI4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WfIqiQeeYURMhgF48Jencr9CQKrv0fNTfYyRZgwvd7jFcIInQdDWuVITIFnIbS3l2lM+HRm+l48rkB+dQwSFZhlBYqF1OnmgL0L10q7FtglZAr1B8m3/E2U1NQbsO7CVQFDHf+7tVIojKvJlAU0OCLSZ+404QAePTLjKlRA3GKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DgzQlgWl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DgzQlgWl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8957BC116B1;
	Wed,  3 Dec 2025 16:19:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764778789;
	bh=H0w2D5rLjiPZj0FocZh8+K245zP+CEuAko7mBKgKFI4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DgzQlgWlkhjIcobUnFfp7/Ff1/N6i7Me25GIdDoTFO33PO0pV9zWtF3OpzDxN6ORR
	 L3h0rbgBjmW/WKW7MKMhC9XGyy+AC+O5Y4rzeZ2v9qipBIGxuGXOJ89bfhW5pyFPVx
	 7CQwjwVGRkswy5nipUuJ1+3B6nTmcvBZmA+EEX3k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hamza Mahfooz <hamza.mahfooz@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Salvatore Bonaccorso <carnil@debian.org>
Subject: [PATCH 6.1 059/568] Reapply "Revert drm/amd/display: Enable Freesync Video Mode by default"
Date: Wed,  3 Dec 2025 16:21:01 +0100
Message-ID: <20251203152442.859526246@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

This reverts commit 11b92df8a2f7f4605ccc764ce6ae4a72760674df.

This conflicts with how compositors want to handle VRR.  Now
that compositors actually handle VRR, we probably don't need
freesync video.

Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/2985
Acked-by: Hamza Mahfooz <hamza.mahfooz@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
[ Salvatore Bonaccorso: Adjust context due to missing 3e094a287526
  ("drm/amd/display: Use drm_connector in create_stream_for_sink") in
  6.1.y stable series ]
Signed-off-by: Salvatore Bonaccorso <carnil@debian.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -6044,7 +6044,8 @@ create_stream_for_sink(struct amdgpu_dm_
 		 */
 		DRM_DEBUG_DRIVER("No preferred mode found\n");
 	} else {
-		recalculate_timing = is_freesync_video_mode(&mode, aconnector);
+		recalculate_timing = amdgpu_freesync_vid_mode &&
+				 is_freesync_video_mode(&mode, aconnector);
 		if (recalculate_timing) {
 			freesync_mode = get_highest_refresh_rate_mode(aconnector, false);
 			drm_mode_copy(&saved_mode, &mode);
@@ -7147,7 +7148,7 @@ static void amdgpu_dm_connector_add_free
 	struct amdgpu_dm_connector *amdgpu_dm_connector =
 		to_amdgpu_dm_connector(connector);
 
-	if (!edid)
+	if (!(amdgpu_freesync_vid_mode && edid))
 		return;
 
 	if (amdgpu_dm_connector->max_vfreq - amdgpu_dm_connector->min_vfreq > 10)
@@ -9160,7 +9161,8 @@ static int dm_update_crtc_state(struct a
 		 * TODO: Refactor this function to allow this check to work
 		 * in all conditions.
 		 */
-		if (dm_new_crtc_state->stream &&
+		if (amdgpu_freesync_vid_mode &&
+		    dm_new_crtc_state->stream &&
 		    is_timing_unchanged_for_freesync(new_crtc_state, old_crtc_state))
 			goto skip_modeset;
 
@@ -9200,7 +9202,7 @@ static int dm_update_crtc_state(struct a
 		}
 
 		/* Now check if we should set freesync video mode */
-		if (dm_new_crtc_state->stream &&
+		if (amdgpu_freesync_vid_mode && dm_new_crtc_state->stream &&
 		    dc_is_stream_unchanged(new_stream, dm_old_crtc_state->stream) &&
 		    dc_is_stream_scaling_unchanged(new_stream, dm_old_crtc_state->stream) &&
 		    is_timing_unchanged_for_freesync(new_crtc_state,
@@ -9213,7 +9215,7 @@ static int dm_update_crtc_state(struct a
 			set_freesync_fixed_config(dm_new_crtc_state);
 
 			goto skip_modeset;
-		} else if (aconnector &&
+		} else if (amdgpu_freesync_vid_mode && aconnector &&
 			   is_freesync_video_mode(&new_crtc_state->mode,
 						  aconnector)) {
 			struct drm_display_mode *high_mode;


