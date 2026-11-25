Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625014;
	b=KTEYGyEhudNgcl3LpVEcY8y1ytjjSxJEDMvjr3axRzqtITulMSffy657rEH3M9GLdewd
	 +8+sIDkmR92FEjc/kdlsnV5yg3fQrE6RqV8xKLJpl1nlo+g3Yfy/4pFyTKJUAmMf2LC4X
	 61s4Hwab7b6OphqbM3dEOKV372VQ8dD1I79smh9uqCe+XqvslJtF6DrK6DNXHyVufxriK
	 tTrAOLstdcAJG/WV6J6ImLmCfVqBtTnSI1WyD5kIuR7Jpj6T7a3hMfNg55v79AP3jJ7j1
	 GywrbQsJ5H5tA5C/GpCh8EJxMyH8xnqUir4zbK/w7SDu1iKu0MXfxeeAUIXFhJnhFhw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625014;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=Opg11w1JOJLGyhpEJOPauRnNuoC0NYC4tDL4FLUCcyc=;
	b=kGvEGRW/TvZgL+q1JGYCU/JolaprNYu5wxidqZ8RAaxBvlcOE7wYcD7o9v5LJwxvTjYH
	 tr2mL5ITyo2E+vV2QhgM3mDjrMThUiZB4PSgjqP3wym5tS0J/+ZFb3fh/Zoz39HEqVn3K
	 Q7C4n4KginNbjir/Kr9BW3XvGb2FIePVt3BBgLSzasg+F2LRJJIIWeF5uN1ckFdrL8YHN
	 AJdnX7xNGMBMIO5zXsUjlx8rBWxHGsPubgMv3EtUi33o2hpDfh2Xka1eJdqkz/9dHhiUx
	 H0Rjtr32E6uwZbN4K8ALCnGUx7MzOsvfALxwMYgWto4vtLX4ecQd8C6SECcwGvcgQww==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NyEwgusm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18C1F606A323;
	Wed, 25 Nov 2026 16:43:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NyEwgusm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E94FD1F000CF;
	Wed, 25 Nov 2026 16:43:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625013;
	bh=Opg11w1JOJLGyhpEJOPauRnNuoC0NYC4tDL4FLUCcyc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NyEwgusm3pgcs4u6Xdn5uf4i+BCJ6bRbYalUr9H+S8++rSafGdbGMfftm+3KnVFd9
	 e4Gj8OifmEYdpMkSMPOeLfUT70Hy2x2S8aTNVk47tDiDBlFDObqWmIUvtcoTEJ4Gbj
	 5HtC4Gn7gzSVwC6Hd0ZoSc75of4kbrE6s6sJt/g0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Jouni=20H=C3=B6gander?= <jouni.hogander@intel.com>,
	Mika Kahola <mika.kahola@intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 379/816] drm/i915/psr: Disable linked plane sel fetch as well
Date: Wed, 25 Nov 2026 15:32:07 +0100
Message-ID: <20261125143857.977430798@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jouni Högander <jouni.hogander@intel.com>

[ Upstream commit b56721c32eb3ad0f086fdc0f33479be395e43bb9 ]

Currently we are not setting linked plane selective area when selective
fetch is about to be disabled for the UV plane. Fix this by simplifying the
loop by just handling plane selective fetch disable and area setting same
way.

Also set the update_planes bit based on comparing old and new plane
selective fetch area. This way both the plane and its linked Y plane are
updated only when their selective fetch area changed.

Fixes: a4f477e6ac17 ("drm/i915/psr: Add proper handling for disabling sel fetch for planes")
Cc: <stable@vger.kernel.org> # v6.8+
Assisted-by: GitHub-Copilot:claude-opus-5
Signed-off-by: Jouni Högander <jouni.hogander@intel.com>
Reviewed-by: Mika Kahola <mika.kahola@intel.com>
Link: https://patch.msgid.link/20260929094434.77129-4-jouni.hogander@intel.com
(cherry picked from commit b10c83af60cbc00ce4112742fd297581233e43cd)
Signed-off-by: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/display/intel_psr.c | 27 ++++++++++++------------
 1 file changed, 13 insertions(+), 14 deletions(-)

diff --git a/drivers/gpu/drm/i915/display/intel_psr.c b/drivers/gpu/drm/i915/display/intel_psr.c
index 929113fc12e60..7a9b1baaa4435 100644
--- a/drivers/gpu/drm/i915/display/intel_psr.c
+++ b/drivers/gpu/drm/i915/display/intel_psr.c
@@ -2724,21 +2724,14 @@ int intel_psr2_sel_fetch_update(struct intel_atomic_state *state,
 
 		inter = crtc_state->psr2_su_area;
 		sel_fetch_area = &new_plane_state->psr2_sel_fetch_area;
-		if (!drm_rect_intersect(&inter, &new_plane_state->uapi.dst)) {
-			/*
-			 * if plane sel fetch was previously enabled ->
-			 * disable it
-			 */
-			if (drm_rect_height(&old_plane_state->psr2_sel_fetch_area) > 0)
-				crtc_state->update_planes |= BIT(plane->id);
-
-			continue;
+		if (drm_rect_intersect(&inter, &new_plane_state->uapi.dst)) {
+			sel_fetch_area->y1 = inter.y1 - new_plane_state->uapi.dst.y1;
+			sel_fetch_area->y2 = inter.y2 - new_plane_state->uapi.dst.y1;
 		}
 
-		sel_fetch_area = &new_plane_state->psr2_sel_fetch_area;
-		sel_fetch_area->y1 = inter.y1 - new_plane_state->uapi.dst.y1;
-		sel_fetch_area->y2 = inter.y2 - new_plane_state->uapi.dst.y1;
-		crtc_state->update_planes |= BIT(plane->id);
+		if (!drm_rect_equals(&old_plane_state->psr2_sel_fetch_area,
+				     sel_fetch_area))
+			crtc_state->update_planes |= BIT(plane->id);
 
 		/*
 		 * Sel_fetch_area is calculated for UV plane. Use
@@ -2746,16 +2739,22 @@ int intel_psr2_sel_fetch_update(struct intel_atomic_state *state,
 		 */
 		if (linked) {
 			struct intel_plane_state *linked_new_plane_state;
+			struct intel_plane_state *linked_old_plane_state;
 			struct drm_rect *linked_sel_fetch_area;
 
 			linked_new_plane_state = intel_atomic_get_new_plane_state(state, linked);
 			if (!linked_new_plane_state)
 				return -EINVAL;
 
+			linked_old_plane_state = intel_atomic_get_old_plane_state(state, linked);
+
 			linked_sel_fetch_area = &linked_new_plane_state->psr2_sel_fetch_area;
 			linked_sel_fetch_area->y1 = sel_fetch_area->y1;
 			linked_sel_fetch_area->y2 = sel_fetch_area->y2;
-			crtc_state->update_planes |= BIT(linked->id);
+
+			if (!drm_rect_equals(&linked_old_plane_state->psr2_sel_fetch_area,
+					     linked_sel_fetch_area))
+				crtc_state->update_planes |= BIT(linked->id);
 		}
 	}
 
-- 
2.53.0



