Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 562DD43636C
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:53:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301198; cv=none; b=l4XakrnivAOcjYR8h0a5JxIBBuOKC0DBNW2sersuA7c7zGzttiWgb56OKnhOObQqqJ0oPO/n9f6cY5x7dwWLB1RMOqTF5hnZ+iqbQ0xGtTyOB5OekLOSk6SbsB21YZ9jMJqJwsBuCnq/hOb3LnvTlOKTL7Orkrog7pvzNLbT5M0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301198; c=relaxed/simple;
	bh=df8bzX1dbfP3TkWttONKT85uQ9g+AJYQHqKnR8nUC9M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a6jCj9mlrWSb9wtohhHYEIslrXqWSpiL90Ant4xNyRb+ach37ZbqoABhIm4+fzFRkvfoFcdq1ybfjV+VTDynSfvWZV0KxIj9OFVjwWVMJ9HAb46Uo6XA7odjh7aYujJhV6qdCICmZr9BymGr388izwl0g66ZVm3VDbWxkzSE4lQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=S2/U6W7E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="S2/U6W7E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D110C116D0;
	Sat, 28 Feb 2026 17:53:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301198;
	bh=df8bzX1dbfP3TkWttONKT85uQ9g+AJYQHqKnR8nUC9M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S2/U6W7EBNrB/6ckIURwwaGOStzB5jZexvEYYnRpS7IVvlwosEGZmMmB0gs2uEAci
	 PJlkISM3TNV3N8MZzN930LsHyIQQTfyJ2VMbIg1VcfTxqGBbzWnlJJO/l+vL8BQbix
	 sFuUH6quhEkBzBHJfzrIyzjFADSeZ0vHcAFq7QRHyCgTfoRm8dqcT+C0kM8jtbs/fh
	 FBNUWb2pKd0mICYgrSWQKS8B2LtvYIukL71XAfx7dUnM+JaCY1H+zSrWTNvn3M4Xor
	 KxdV0dd3osH0vzPyAVclUVmO4lsvD8HN5qckDkcT9a0LkcqHyZpmav05qz3F6FayWn
	 LEkMkEI5FzbBQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Alex Hung <alex.hung@amd.com>,
	Harry Wentland <harry.wentland@amd.com>,
	Wayne Lin <wayne.lin@amd.com>,
	Dan Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 370/752] drm/amd/display: Fix writeback on DCN 3.2+
Date: Sat, 28 Feb 2026 12:41:21 -0500
Message-ID: <20260228174750.1542406-370-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
 .../gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index b3cf43eb6e087..b527d5764b76b 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -10411,10 +10411,10 @@ static void dm_set_writeback(struct amdgpu_display_manager *dm,
 
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
@@ -11430,6 +11430,8 @@ static bool should_reset_plane(struct drm_atomic_state *state,
 	struct drm_crtc_state *old_crtc_state, *new_crtc_state;
 	struct dm_crtc_state *old_dm_crtc_state, *new_dm_crtc_state;
 	struct amdgpu_device *adev = drm_to_adev(plane->dev);
+	struct drm_connector_state *new_con_state;
+	struct drm_connector *connector;
 	int i;
 
 	/*
@@ -11440,6 +11442,15 @@ static bool should_reset_plane(struct drm_atomic_state *state,
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

