Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AECD830BF59;
	Sat, 25 Oct 2025 16:22:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761409323; cv=none; b=UEEEZXM9W2zMunYRobNGfS/APKkvp9tuOUVamDaR9XFJoidgOn0lZkzZTS10sXaWRp4TNgS0UbbOGc0seTozD2zV8cTlEu3bHMeqkXUR59HJbO8KyPregheZdsa6rnLMaqbv81LPKK3g7/VojtPgtBEYPuYmZa8/qkBeq+CYyVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761409323; c=relaxed/simple;
	bh=o2HNRES2Vt0e3qtSh7DFbwHRFuz1FTiaWtNCnqi58JE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qj3ssvVImzbxlNj0HIt5t2gayfq2pkTtF4ar4bmop8o5nhArKE9GSX9BeE1AVVOO1mkhkHfjW8d/RI8+Uoac1M3kOITDghyDZz3gQ+4a0XwVDoPhZbwFnqxC06ZhL9MmN3UPOzL7mMpoU68JIo4l40xeQH7QHyCZLC2sZvG+Wgw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sw8MF0Jp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sw8MF0Jp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 246E4C2BCB5;
	Sat, 25 Oct 2025 16:21:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761409321;
	bh=o2HNRES2Vt0e3qtSh7DFbwHRFuz1FTiaWtNCnqi58JE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sw8MF0JpqSKI0C4Dhbrb51NMvIo9diCn+NoQEPNxwrjdo76YXahsRbvAlf00lGXA6
	 pxuz+v/qJXul22DroN/2OpdKkLuNGaET0Ay9xyUoYCN9qEM/tvdlOfzGRIsCIGjkH5
	 GoQnlsI84wvXADCgr78amZljjwt3hqT7/nkBzrJkVTQfxljyqMPH78sIRRQRoIEaZ2
	 gzpafsemecs4SL3CjQrUdCYG7AHtJNjSjbm6vN3MmcRIs4kBq7r29CJrPWLQVFPaSD
	 Ah01xsnVnMgiNz52P0qrpVfvpwk6Xz+rwEp152YqSHaOt2HvBmZ+gUoRJPMkaE3AzV
	 pCBha9k/PCvWA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Dillon Varone <Dillon.Varone@amd.com>,
	Aurabindo Pillai <aurabindo.pillai@amd.com>,
	Ivan Lipski <ivan.lipski@amd.com>,
	Dan Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	mario.limonciello@amd.com,
	alex.hung@amd.com,
	Wayne.Lin@amd.com,
	chiahsuan.chung@amd.com,
	alexandre.f.demers@gmail.com,
	sunpeng.li@amd.com,
	hamzamahfooz@linux.microsoft.com,
	harry.wentland@amd.com,
	mdaenzer@redhat.com,
	kenneth.feng@amd.com,
	mwen@igalia.com,
	Jerry.Zuo@amd.com,
	timur.kristof@gmail.com
Subject: [PATCH AUTOSEL 6.17] drm/amd/display: Add missing post flip calls
Date: Sat, 25 Oct 2025 11:58:29 -0400
Message-ID: <20251025160905.3857885-278-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251025160905.3857885-1-sashal@kernel.org>
References: <20251025160905.3857885-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Dillon Varone <Dillon.Varone@amd.com>

[ Upstream commit 54980f3c63ed3e5cca3d251416581193c90eae76 ]

[WHY&HOW]
dc_post_update_surfaces_to_stream needs to be called after a full update
completes in order to optimize clocks and watermarks for power. Add
missing calls before idle entry is requested to ensure optimal power.

Reviewed-by: Aurabindo Pillai <aurabindo.pillai@amd.com>
Signed-off-by: Dillon Varone <Dillon.Varone@amd.com>
Signed-off-by: Ivan Lipski <ivan.lipski@amd.com>
Tested-by: Dan Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES — ensures AMD DC runs the pending post-flip optimization step after
full updates so idle power isn’t stuck at high clocks.

- **Bug Fix**: `update_planes_and_stream_adapter()` now always calls
  `dc_post_update_surfaces_to_stream()`
  (`drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c:421`). That helper
  clears `dc->optimized_required`, disables unused pipes, and re-
  optimizes clocks/watermarks
  (`drivers/gpu/drm/amd/display/dc/core/dc.c:2546-2579`), which
  otherwise stay elevated and even block DRR timing adjustments while
  the flag remains set
  (`drivers/gpu/drm/amd/display/dc/core/dc.c:463-468`).
- **Idle Paths**: The idle and vblank workers invoke the same hook
  before allowing idle entry
  (`drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_crtc.c:221-223` and
  `:278-280`), guaranteeing that power-saving transitions don’t occur
  while bandwidth optimizations are still pending.
- **Scope & Risk**: Only adds calls to an existing guard-checked helper;
  when no optimization is required it returns immediately, so the change
  is contained, architecture-neutral, and low risk.
- **Backport Fit**: Fixes a user-visible power regression (excess clocks
  after full flips/PSR), touches only AMD display code, and stays well
  within stable backport guidelines.

Next step: 1) Verify on target hardware that idle clocks drop after
full-screen updates or PSR transitions.

 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c      | 3 +--
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_crtc.c | 8 ++++++--
 2 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index 57b46572fba27..d66c9609efd8d 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -427,8 +427,7 @@ static inline bool update_planes_and_stream_adapter(struct dc *dc,
 	/*
 	 * Previous frame finished and HW is ready for optimization.
 	 */
-	if (update_type == UPDATE_TYPE_FAST)
-		dc_post_update_surfaces_to_stream(dc);
+	dc_post_update_surfaces_to_stream(dc);
 
 	return dc_update_planes_and_stream(dc,
 					   array_of_surface_update,
diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_crtc.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_crtc.c
index 466dccb355d7b..1ec9d03ad7474 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_crtc.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_crtc.c
@@ -218,8 +218,10 @@ static void amdgpu_dm_idle_worker(struct work_struct *work)
 			break;
 		}
 
-		if (idle_work->enable)
+		if (idle_work->enable) {
+			dc_post_update_surfaces_to_stream(idle_work->dm->dc);
 			dc_allow_idle_optimizations(idle_work->dm->dc, true);
+		}
 		mutex_unlock(&idle_work->dm->dc_lock);
 	}
 	idle_work->dm->idle_workqueue->running = false;
@@ -273,8 +275,10 @@ static void amdgpu_dm_crtc_vblank_control_worker(struct work_struct *work)
 			vblank_work->acrtc->dm_irq_params.allow_sr_entry);
 	}
 
-	if (dm->active_vblank_irq_count == 0)
+	if (dm->active_vblank_irq_count == 0) {
+		dc_post_update_surfaces_to_stream(dm->dc);
 		dc_allow_idle_optimizations(dm->dc, true);
+	}
 
 	mutex_unlock(&dm->dc_lock);
 
-- 
2.51.0

