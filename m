Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585464;
	b=t22DFGgjCBEkN+uNd4UVp6s5zVtFtH6pyttyy0iIRz752smHoa+J6Z5bSJK+8cm+dEt3
	 zT/hgkNQIOmF3iM/IkP4JysF6K6maXZraVNKl65H9z0JTaIX14xiUYu+NpfPuNQxnjjtt
	 VP3uE6kIc+Xns3UkakfYs7cvODxU9c1M3jaoN+nk9VoQIOl8hijwRTt70Xdz3HEm6dg5b
	 el/JR51nwqdfun1A3e9r3yp7raSa7Yt7ZVUpPSZlXIhoSPQhaJSbLxcdlW5r27nsGYDHh
	 48WoSODPqWntT/y9RKPtgbgXzgu2LrrPnl2iK6VHfiG0xGsP42mBZk5VGnewPMOcjQg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585464;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=KM6UiaNYFsoUI0GrXB2uVDf2nN9pkciH0KICYEBCe0Q=;
	b=26AMiciyvBxpleTH/ANU/x0bpk/zNWOYu+ILHLinrTntCaTT6H5KiQCX/goJacD6xC0k
	 Dpy+XlP8nSZ6/VO4Y70tn6Rb6VmwOtMJVK5JWiD6Zspb+mqhTVuECHhTR1QwsOJuHkVGh
	 7YS6JfmLYytF23IDFT8mpRkibJD2JD+XKVY8BnbJTBlwos2MiCpMlp3f1EH7GMjtIQMKr
	 nJnqgulYmhZdFd2i97X2e1GyjmR2F9ageAuH1fh5lAAiD04Z6EUQ0FipdDIb4HyOqdw9j
	 2XfkaOpsEB8dB6n/b+hb7g76j9SBI8Q+KiimREpgv4eHQozPLYxNKMR8l8JHucVnL5A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Lj8Ov4yz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 819A9606EB81;
	Fri, 13 Nov 2026 15:57:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Lj8Ov4yz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CC601F000C5;
	Fri, 13 Nov 2026 15:57:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585464;
	bh=KM6UiaNYFsoUI0GrXB2uVDf2nN9pkciH0KICYEBCe0Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Lj8Ov4yzUYWkD1Uc8p8DECD2+XO9Mo/BRMr9/fAaetyXh91xJBmf+Dj1LXCmzmW1r
	 F9sYR+MlzFNUauvkJH4Cxpc4nYGnhPoTElIDgNm4Xycj1AFsQpR3BWDTW+QXKiB1Rt
	 tWTvcR0Fw344bk1lXk9nwmD3kQihIa98cueH63Bk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Jouni=20H=C3=B6gander?= <jouni.hogander@intel.com>,
	Mika Kahola <mika.kahola@intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 120/507] drm/i915/display: Add enabled pipe planes into state for selective fetch
Date: Fri, 13 Nov 2026 10:47:04 -0500
Message-ID: <20261113153758.480661533@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jouni Högander <jouni.hogander@intel.com>

[ Upstream commit 94cb1f08b197d9ae932ff98c741bd0dbc96e17e8 ]

Selective fetch support for biplanar formats relies on linking of UV and
the Y planes. Planes that are not part of the atomic state are pulled in by
the drm_atomic_add_affected_planes. If the UV plane is added into the state
by drm_atomic_add_affected_planes in the selective fetch calculation, the
linking isn't done anymore and the Y plane is left disabled.

Fix this by adding affected planes already in intel_add_affected_planes if
selective fetch is enabled.

Remove redundant drm_atomic_add_affected_planes from
intel_psr2_sel_fetch_update and redundant check for plane selective fetch
support that is not needed as all planes are already in atomic state on
first loop iterating them. Also switch to intel_atomic_get_new_plane_state
for linked plane new plane state.

Fixes: 3809991ff5f4 ("drm/i915/display: Add initial selective fetch support for biplanar formats")
Cc: <stable@vger.kernel.org> # v5.17+
Signed-off-by: Jouni Högander <jouni.hogander@intel.com>
Reviewed-by: Mika Kahola <mika.kahola@intel.com>
Link: https://patch.msgid.link/20260929094434.77129-3-jouni.hogander@intel.com
(cherry picked from commit 0d173898b11157d37de3e5f01ef28a48582167d8)
Signed-off-by: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/display/intel_plane.c | 10 +++++++++
 drivers/gpu/drm/i915/display/intel_psr.c   | 25 +++++++---------------
 2 files changed, 18 insertions(+), 17 deletions(-)

diff --git a/drivers/gpu/drm/i915/display/intel_plane.c b/drivers/gpu/drm/i915/display/intel_plane.c
index d0e7309483234..c1c5a6128614f 100644
--- a/drivers/gpu/drm/i915/display/intel_plane.c
+++ b/drivers/gpu/drm/i915/display/intel_plane.c
@@ -1931,6 +1931,16 @@ static int intel_add_affected_planes(struct intel_atomic_state *state)
 		ret = intel_joiner_add_affected_planes(state, intel_crtc_joined_pipe_mask(crtc_state));
 		if (ret)
 			return ret;
+
+		/*
+		 * Add affected plane here to ensure UV and Y plane linking is
+		 * in place if UV plane is added as a part of selective update.
+		 */
+		if (crtc_state->enable_psr2_sel_fetch) {
+			ret = intel_plane_add_affected(state, crtc);
+			if (ret)
+				return ret;
+		}
 	}
 
 	return 0;
diff --git a/drivers/gpu/drm/i915/display/intel_psr.c b/drivers/gpu/drm/i915/display/intel_psr.c
index 15421b0a3bb0d..5522d1e0cbcc5 100644
--- a/drivers/gpu/drm/i915/display/intel_psr.c
+++ b/drivers/gpu/drm/i915/display/intel_psr.c
@@ -2895,7 +2895,7 @@ int intel_psr2_sel_fetch_update(struct intel_atomic_state *state,
 		.y2 = crtc_state->hw.adjusted_mode.crtc_vdisplay,
 	};
 	bool full_update = false, su_area_changed;
-	int i, ret;
+	int i;
 
 	/*
 	 * Selective fetch is not always usable, for instance it is dropped
@@ -3010,19 +3010,15 @@ int intel_psr2_sel_fetch_update(struct intel_atomic_state *state,
 
 	intel_psr_apply_su_area_workarounds(crtc_state);
 
-	ret = drm_atomic_add_affected_planes(&state->base, &crtc->base);
-	if (ret)
-		return ret;
-
 	do {
 		bool cursor_in_su_area = false;
 
 		/*
 		 * Adjust su area to cover cursor fully as necessary
-		 * (early transport). This needs to be done after
-		 * drm_atomic_add_affected_planes to ensure visible
-		 * cursor is added into affected planes even when
-		 * cursor is not updated by itself.
+		 * (early transport). A visible cursor is in the state
+		 * even when it is not updated by itself as all planes
+		 * of the pipe are added into the state before the plane
+		 * checks when selective fetch is enabled.
 		 */
 		intel_psr2_sel_fetch_et_alignment(state, crtc, &display_area,
 						  &cursor_in_su_area);
@@ -3073,11 +3069,6 @@ int intel_psr2_sel_fetch_update(struct intel_atomic_state *state,
 			continue;
 		}
 
-		if (!psr2_sel_fetch_plane_state_supported(new_plane_state)) {
-			full_update = true;
-			break;
-		}
-
 		sel_fetch_area = &new_plane_state->psr2_sel_fetch_area;
 		sel_fetch_area->y1 = inter.y1 - new_plane_state->uapi.dst.y1;
 		sel_fetch_area->y2 = inter.y2 - new_plane_state->uapi.dst.y1;
@@ -3091,9 +3082,9 @@ int intel_psr2_sel_fetch_update(struct intel_atomic_state *state,
 			struct intel_plane_state *linked_new_plane_state;
 			struct drm_rect *linked_sel_fetch_area;
 
-			linked_new_plane_state = intel_atomic_get_plane_state(state, linked);
-			if (IS_ERR(linked_new_plane_state))
-				return PTR_ERR(linked_new_plane_state);
+			linked_new_plane_state = intel_atomic_get_new_plane_state(state, linked);
+			if (!linked_new_plane_state)
+				return -EINVAL;
 
 			linked_sel_fetch_area = &linked_new_plane_state->psr2_sel_fetch_area;
 			linked_sel_fetch_area->y1 = sel_fetch_area->y1;
-- 
2.53.0



