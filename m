Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590290;
	b=XXl2SvSWlpk7tDF7bKrjQYYBGMBZDa27t3iDG6W6SeVOz1/0Uk1s1tdTxLC9CUKh2agn
	 j5iRu+6wAZjjgQSozIDVtucxemPXJWU9OLOCA96xRX0dUb0qMp8k9vXRTsyCM8Et9bX6c
	 9wCYJHVXKFxGRh4eEnmGtSqvfjNTLNWG8bJDMQdQy0zH9Z59WKlPhEi4XdzgsXtXUHuYC
	 UzhTM1c9wKA93livZRO7pIdIoLA/MA2VzoVdZWCK0ZJhpiWoX57XylYi7bp2ujFpKa3+W
	 iqnCN4+dWfUJKJWKgh/+cclRAO3gOgReAjn+PxlRPMCzmg1/IcFffXKjO6YCY4ZSerg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590290;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=kyW5H/nn5/X6vlS1ZcW8+mluGZYW60n3WFjIOhDnoYQ=;
	b=fgKDpjAmajZSIiBleFMvNjJ6EgFfwAmu8YQPSZRfkN151Vzeiw6iod1+kDtpLzyFjSV4
	 PSeXofJJoPj9YPLfs0Ud4uuoT3SZsAS/m7MAnW2ztswI9JS91AREwJNxC6QqZyiF5IK5U
	 Bi1lafq2103AcSO9VBP8Z2v/rTVB/55a2McLHTKHDx8pK3rHWQEIAQgWZRy4qLFxEMiL2
	 h+A0TVXSBAnQ8VFobpQ25SQ5/+5ugqAYRkft6JIXTaEOZsa9IyV5G89XU9lfSmZa4EoXC
	 ekpAgbiA9k2W/aXh30PvBdIq2QdZ6urFU+CURgMJAI5RL+7owr1QNDlQ+oQANV04PBA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2AysCXs0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FBCF606B23E;
	Fri, 13 Nov 2026 17:18:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2AysCXs0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF1BE1F000CB;
	Fri, 13 Nov 2026 17:18:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590289;
	bh=kyW5H/nn5/X6vlS1ZcW8+mluGZYW60n3WFjIOhDnoYQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2AysCXs0Q2ETz7LH0//xY2vpowpR/PshinEWiquhxvKm4sutCA+AAwF4nt9yVgspv
	 yI2lIX5kO7CSqCkDGUd1WopKpAOxnaw6U5FcV11E4mDavjxxkwfpFI0ML2BB9n/jcq
	 97LhHqjbKoNBQ8pWhfx0vUpD+UsYszhe3CMAJ5rw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Jouni=20H=C3=B6gander?= <jouni.hogander@intel.com>,
	Mika Kahola <mika.kahola@intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 237/686] drm/i915/psr: Clear selective fetch area when duplicating plane state
Date: Fri, 13 Nov 2026 10:46:10 -0500
Message-ID: <20261113153829.069642432@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jouni Högander <jouni.hogander@intel.com>

[ Upstream commit cbe565475988d3b22dc36f13c14d9f0eec1685cd ]

We are currently not clearing selective fetch area when duplicating plane
state. This is causing problem when plane is re-used for another
purpose. Fix this by clearing selective fetch area when duplicating plane
state.

Now as the state is cleared we need to ensure we have consistent selective
fetch area in plane state on full update. Earlier this was relying on
selective fetch area being copied from old state on state duplicate. Now
this isn't true anymore as we are clearing it. Tackle this by setting full
plane area as selective fetch area for each plane on full update. Rename
the label as skip_su_area_calc as the loop setting the plane selective
fetch area is not skipped anymore.

Move also psr2_sel_fetch_pipe_state_supported check after psr2_su_area
initialization. The loop is run on full update as well now and it needs
initialized psr2_su_area. Clip_area_update is only touching rect height and
x1/x2 are left untouched.

Don't set the area at all for planes not intersecting with the selective
update area. It is already zero sized after plane state duplicate.

Fixes: efab47658a6c ("drm/i915/display/psr: Calculate selective fetch plane registers")
Cc: <stable@vger.kernel.org> # v5.12+
Assisted-by: GitHub-Copilot:claude-opus-5
Signed-off-by: Jouni Högander <jouni.hogander@intel.com>
Reviewed-by: Mika Kahola <mika.kahola@intel.com>
Link: https://patch.msgid.link/20260929094434.77129-2-jouni.hogander@intel.com
(cherry picked from commit bd58f0e221386808cd614bb205112e807dc6b159)
Signed-off-by: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/display/intel_plane.c |  1 +
 drivers/gpu/drm/i915/display/intel_psr.c   | 24 ++++++++++------------
 2 files changed, 12 insertions(+), 13 deletions(-)

diff --git a/drivers/gpu/drm/i915/display/intel_plane.c b/drivers/gpu/drm/i915/display/intel_plane.c
index 91deeaec61100..6f9c22476b14d 100644
--- a/drivers/gpu/drm/i915/display/intel_plane.c
+++ b/drivers/gpu/drm/i915/display/intel_plane.c
@@ -139,6 +139,7 @@ intel_plane_duplicate_state(struct drm_plane *plane)
 	intel_state->dpt_vma = NULL;
 	intel_state->flags = 0;
 	intel_state->damage = DRM_RECT_INIT(0, 0, 0, 0);
+	intel_state->psr2_sel_fetch_area = DRM_RECT_INIT(0, 0, 0, 0);
 
 	/* add reference to fb */
 	if (intel_state->hw.fb)
diff --git a/drivers/gpu/drm/i915/display/intel_psr.c b/drivers/gpu/drm/i915/display/intel_psr.c
index 5f6ccd953c1e3..d41ad77c086f4 100644
--- a/drivers/gpu/drm/i915/display/intel_psr.c
+++ b/drivers/gpu/drm/i915/display/intel_psr.c
@@ -2797,16 +2797,16 @@ int intel_psr2_sel_fetch_update(struct intel_atomic_state *state,
 	if (!crtc_state->enable_psr2_sel_fetch)
 		return 0;
 
-	if (!psr2_sel_fetch_pipe_state_supported(crtc_state)) {
-		full_update = true;
-		goto skip_sel_fetch_set_loop;
-	}
-
 	crtc_state->psr2_su_area.x1 = 0;
 	crtc_state->psr2_su_area.y1 = -1;
 	crtc_state->psr2_su_area.x2 = drm_rect_width(&display_area);
 	crtc_state->psr2_su_area.y2 = -1;
 
+	if (!psr2_sel_fetch_pipe_state_supported(crtc_state)) {
+		full_update = true;
+		goto skip_su_area_calc;
+	}
+
 	/*
 	 * Calculate minimal selective fetch area of each plane and calculate
 	 * the pipe damaged area.
@@ -2890,7 +2890,7 @@ int intel_psr2_sel_fetch_update(struct intel_atomic_state *state,
 	}
 
 	if (full_update)
-		goto skip_sel_fetch_set_loop;
+		goto skip_su_area_calc;
 
 	intel_psr_apply_su_area_workarounds(crtc_state);
 
@@ -2926,6 +2926,11 @@ int intel_psr2_sel_fetch_update(struct intel_atomic_state *state,
 			break;
 	} while (su_area_changed);
 
+skip_su_area_calc:
+	if (full_update)
+		clip_area_update(&crtc_state->psr2_su_area, &display_area,
+				 &display_area);
+
 	/*
 	 * Now that we have the pipe damaged area check if it intersect with
 	 * every plane, if it does set the plane selective fetch area.
@@ -2942,8 +2947,6 @@ int intel_psr2_sel_fetch_update(struct intel_atomic_state *state,
 		inter = crtc_state->psr2_su_area;
 		sel_fetch_area = &new_plane_state->psr2_sel_fetch_area;
 		if (!drm_rect_intersect(&inter, &new_plane_state->uapi.dst)) {
-			sel_fetch_area->y1 = -1;
-			sel_fetch_area->y2 = -1;
 			/*
 			 * if plane sel fetch was previously enabled ->
 			 * disable it
@@ -2983,11 +2986,6 @@ int intel_psr2_sel_fetch_update(struct intel_atomic_state *state,
 		}
 	}
 
-skip_sel_fetch_set_loop:
-	if (full_update)
-		clip_area_update(&crtc_state->psr2_su_area, &display_area,
-				 &display_area);
-
 	psr2_man_trk_ctl_calc(crtc_state, full_update);
 	crtc_state->pipe_srcsz_early_tpt =
 		psr2_pipe_srcsz_early_tpt_calc(crtc_state, full_update);
-- 
2.53.0



