Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039050;
	b=EHpwuKpQYGqrz+R2wynj48L/V56Jjwh+TMfifXcnFFmFmRZGEdST39jz/SW6v9DUiHi9
	 8hMIMQuWZbERR2YH5x2nmunVH6g/0s7pKHk9EOWfAkO7YqGSl6tGW6Oo7lvQqq6tLSo2T
	 5vmXaR827rN9b6dDUBKdwj8KmXxZ32PwxnDPqyw692scvtZ/1zhMNNt46jAB68lcoC0B7
	 drkc6S9MEGpgynt315Ne0V2M5aq/lF0m0tI1eSNPLmZ5Tw2/1/si4I/AsMA9D+elS1qAo
	 ZM2F/qmickQ+RAIaaHnle/QDiAKeRTXxLK4jOXh+q3zSpvvkjvVEYvstpX5fm9nJk5w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039050;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=5O+DVS8OmawV8vYlC3Bu6is3qKyKBz/Og/iUyqy5ARg=;
	b=YsS+YtJTSMCChswQtMQcQKLf3eEB26Em5Ec5XWYVePGg4V/1bYZo6rakjNscDoJuLXlC
	 kU/Copa6GJX4hKulpQa1GYExrijHtmgddIY3+HOyJiIw70O53EMD8nClsAR73uolEYdFo
	 dafLBVVrA1rlPPxCMDcCTsWmvGbxb6FKAImoXa7te0g/XOsueXVnFi/Z+CX+aTGtenYTA
	 xvI+ITv7+Z9b8NcXJSZKp3g3uarSjxAQLAC1m//tiYKP482kuzKzFaO4enQ1kKISLDqXs
	 BK24w4ccOVuT/wwNSro3QcLyAZES0MmQKEol13uJM/GuO5pGc4o9nX0rPqrmuH0NPAA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rnmL5J1+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88575606A32F;
	Wed, 18 Nov 2026 21:57:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rnmL5J1+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DABE31F000CD;
	Wed, 18 Nov 2026 21:57:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039050;
	bh=5O+DVS8OmawV8vYlC3Bu6is3qKyKBz/Og/iUyqy5ARg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rnmL5J1+z9niz74G1JwiynIsu7AFBsl8johCaCs4TkA+ajTtKtZYm6dtJbB+mpoRo
	 GbTNJI/sXFDefB2NpH4qd4qKY2RD7vupuPtPyRzywZeDFnu55RevCV7Ee2J3ajMQMw
	 7v/n6HVTz4LZFSxw27CBjdiCPvLf4LREiAZ7t9f8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Jouni=20H=C3=B6gander?= <jouni.hogander@intel.com>,
	Mika Kahola <mika.kahola@intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1959/3318] drm/i915/display: Add enabled pipe planes into state for selective fetch
Date: Wed, 18 Nov 2026 15:43:01 +0100
Message-ID: <20261118150420.853524133@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: adapted early plane collection to intel_atomic_check_planes() using the existing intel_atomic_add_affected_planes() helper ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/display/intel_display.c | 12 ++++++++++++
 drivers/gpu/drm/i915/display/intel_psr.c     | 17 ++++-------------
 2 files changed, 16 insertions(+), 13 deletions(-)

diff --git a/drivers/gpu/drm/i915/display/intel_display.c b/drivers/gpu/drm/i915/display/intel_display.c
index 28d132c238d19..f8c3cba3ca620 100644
--- a/drivers/gpu/drm/i915/display/intel_display.c
+++ b/drivers/gpu/drm/i915/display/intel_display.c
@@ -5672,6 +5672,18 @@ static int intel_atomic_check_planes(struct intel_atomic_state *state)
 	struct intel_crtc *crtc;
 	int i, ret;
 
+	for_each_new_intel_crtc_in_state(state, crtc, new_crtc_state, i) {
+		/*
+		 * Add affected plane here to ensure UV and Y plane linking is
+		 * in place if UV plane is added as a part of selective update.
+		 */
+		if (new_crtc_state->enable_psr2_sel_fetch) {
+			ret = intel_atomic_add_affected_planes(state, crtc);
+			if (ret)
+				return ret;
+		}
+	}
+
 	ret = icl_add_linked_planes(state);
 	if (ret)
 		return ret;
diff --git a/drivers/gpu/drm/i915/display/intel_psr.c b/drivers/gpu/drm/i915/display/intel_psr.c
index 107172e630aae..3533ef97ce58d 100644
--- a/drivers/gpu/drm/i915/display/intel_psr.c
+++ b/drivers/gpu/drm/i915/display/intel_psr.c
@@ -2043,7 +2043,7 @@ int intel_psr2_sel_fetch_update(struct intel_atomic_state *state,
 		.y2 = crtc_state->hw.adjusted_mode.crtc_vdisplay,
 	};
 	bool full_update = false;
-	int i, ret;
+	int i;
 
 	if (!crtc_state->enable_psr2_sel_fetch)
 		return 0;
@@ -2144,10 +2144,6 @@ int intel_psr2_sel_fetch_update(struct intel_atomic_state *state,
 	    crtc_state->splitter.enable)
 		pipe_clip.y1 = 0;
 
-	ret = drm_atomic_add_affected_planes(&state->base, &crtc->base);
-	if (ret)
-		return ret;
-
 	intel_psr2_sel_fetch_pipe_alignment(crtc_state, &pipe_clip);
 
 skip_su_area_calc:
@@ -2171,11 +2167,6 @@ int intel_psr2_sel_fetch_update(struct intel_atomic_state *state,
 		if (!drm_rect_intersect(&inter, &new_plane_state->uapi.dst))
 			continue;
 
-		if (!psr2_sel_fetch_plane_state_supported(new_plane_state)) {
-			full_update = true;
-			break;
-		}
-
 		sel_fetch_area = &new_plane_state->psr2_sel_fetch_area;
 		sel_fetch_area->y1 = inter.y1 - new_plane_state->uapi.dst.y1;
 		sel_fetch_area->y2 = inter.y2 - new_plane_state->uapi.dst.y1;
@@ -2189,9 +2180,9 @@ int intel_psr2_sel_fetch_update(struct intel_atomic_state *state,
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



