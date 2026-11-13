Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590239;
	b=0XQRvRrTxN2ElQycxqUn7W0zRu+jjfVQpflti0pEewRwro9UnJhRjxzETxu8A88VwVcN
	 sMjsJt3qYYqKrdrhwcuiXT/oeiAKDlA52VAxMvv0l3QRTlxUpyoBgeC9UNJ5yiu1YKfov
	 BNaX3fzgHqp7c7SwESLRtSZyRN4t4jTT/9WhW0J6sS9h1LO0c7E6Dr3fvdpwJVhOTap9L
	 rFxh0T9wgcGDd3cAwiz+O8QKZCRj4OJ4ULkVRSd2V4/wLUTVBvfpvjbJ1dSJLfYYTSFEl
	 J5G3QhplQV10T0QuG9UXcTg4/kfrbr+Ml0BshiO5Nupwp1VpIxh0Oaar4iWCgbP2jlQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590239;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=A62fHMndegqrq3h0druzf5eNlYMCNwhGDnkxzEc7l3I=;
	b=nFm11469/UaSHhxrFfsXelv+MafC/nv9XuHf+JuN3hmCiWhn/PIrUt2+6Ib2yiaAhXZN
	 MQkXMGuj9YxQte5vJrqShn/RjaMO0p7IyPqhuIPk0WOHdt61ibaK49RqB3GMF7cMQza6M
	 WD2HIQC3iztKWS0CHl79KCcPKeYulkK7iSPryY/P9KYUM6xtqKE7Au/fg9oHcpUJR2WWs
	 nBnn+cWYK5lGxzQfgDIWtZDaoEKubzlZNxzA7lZ6YbR7okjl2Cj9PFsGgIiSOMuV3gSc8
	 jzOxlffsG0mqUCuRvxVY0to42TRLWR0h2pMr/gBgiF+vW27TzPxsXXHULGvQyzkwFgw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZjqV+O88;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E720606C0BD;
	Fri, 13 Nov 2026 17:17:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZjqV+O88
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DDFE1F000C4;
	Fri, 13 Nov 2026 17:17:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590239;
	bh=A62fHMndegqrq3h0druzf5eNlYMCNwhGDnkxzEc7l3I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZjqV+O88XJKGYC4K/Qeaq6w1MK2zUYW8uTbIbU4GG5MN9V4eTCileI1ZzfW78n+YK
	 +2MRCMGflloqVGfncRPd8swqb/XcVFB1CpXxvBPgyejPoUiBLzOfor1Cj8fIClxd8I
	 ZYrscxA/FYUquUkqhyKPYte27NxfEJm1HBseSwOM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Jouni=20H=C3=B6gander?= <jouni.hogander@intel.com>,
	Mika Kahola <mika.kahola@intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 238/686] drm/i915/display: Add enabled pipe planes into state for selective fetch
Date: Fri, 13 Nov 2026 10:46:11 -0500
Message-ID: <20261113153829.110785512@linuxfoundation.org>
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
index 6f9c22476b14d..bbf85f47a73ff 100644
--- a/drivers/gpu/drm/i915/display/intel_plane.c
+++ b/drivers/gpu/drm/i915/display/intel_plane.c
@@ -1699,6 +1699,16 @@ static int intel_add_affected_planes(struct intel_atomic_state *state)
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
index d41ad77c086f4..253045374a061 100644
--- a/drivers/gpu/drm/i915/display/intel_psr.c
+++ b/drivers/gpu/drm/i915/display/intel_psr.c
@@ -2779,7 +2779,7 @@ int intel_psr2_sel_fetch_update(struct intel_atomic_state *state,
 		.y2 = crtc_state->hw.adjusted_mode.crtc_vdisplay,
 	};
 	bool full_update = false, su_area_changed;
-	int i, ret;
+	int i;
 
 	/*
 	 * Selective fetch is not always usable, for instance it is dropped
@@ -2894,19 +2894,15 @@ int intel_psr2_sel_fetch_update(struct intel_atomic_state *state,
 
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
@@ -2957,11 +2953,6 @@ int intel_psr2_sel_fetch_update(struct intel_atomic_state *state,
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
@@ -2975,9 +2966,9 @@ int intel_psr2_sel_fetch_update(struct intel_atomic_state *state,
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



