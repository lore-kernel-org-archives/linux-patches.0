Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028914;
	b=T7b6oXPyJahX7IdbUILbRExQSU2k7ml5m7MRdUV2Ee3cxUwF7/lZTHCAYF8+CkyvVJbZ
	 8DdDbwQj7SA2lmI1hJ6esvmHE6i88J7f+In272uaxUkccY57W6nasCV7F4SfTfitKicAU
	 wuxm6ckERRS/kXP82RMKAR62gsJf3vUNFoswQmPdJ0FdovxTYnRBXUf1W5wJF/wnEBZH6
	 9cgxO8OKbTQ1T69smMK8tNFA1KrDIGmKBl4e56u/sAJOqCJsGCW/jFdyAkgwgsWcG2bRY
	 nhVp3Y2OnZKQvXK1XdMccvpIjBHxd5+YoqUccxdhF7KnxRb4Nl+g4/8gCfnU3qIiZ7w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028914;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=FPxIhu2aaeVqu0/8mdQ5VJRPThVPaqX+OL7iSzm20xE=;
	b=yOzZCzHEdsRsZ3W2m8/vztUQ2UDuNLtpeJ32I+5qoOYusd6g4vSGusYCaEYSAHh+ikXa
	 KfRmwsr1rLy/Gy/UkCZwB28AJUQNb0rTnlNnSxvsoJCLTtkOMteBW8b5m7I7xz89sMFhx
	 ceUo3iD0w2sbvhpmoXyE1ErzFxBhPCJgIdl5UNgEZhQkUJkTbAyN0MJVsHxAEZtYTCl3q
	 SSQvqdJHWTlrDFIMlaw+ObYcmg69yaN2YIRn7r7Fzuf73652rkv02VzkdzOl3vuC5RdRw
	 dXfVdsk3wSe0lazq0vBrFbh4eVA+vCjZbgLZb19WiodeXnfd4MnWcUPNSekpjjcCiyw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=L211UbKJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 927CB606A335;
	Wed, 18 Nov 2026 19:08:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=L211UbKJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4EEC1F000C4;
	Wed, 18 Nov 2026 19:08:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028914;
	bh=FPxIhu2aaeVqu0/8mdQ5VJRPThVPaqX+OL7iSzm20xE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L211UbKJ9gJEU05KZKj0n4kjx3/qB9TIKfQK7sESXEVN6zj7SIT5/3Xxw7qu62Zp5
	 hSJKdfXH2bkbJl7niwsCxy02+MEDgZ+OYyXIfSaBBS+3u2YUQG67SiNnMccQb7gXw3
	 4tBoWhzBZFJxdQHp2bofrId2rH6B4Y5RX+8t61RA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Jouni=20H=C3=B6gander?= <jouni.hogander@intel.com>,
	Mika Kahola <mika.kahola@intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0117/1756] drm/i915/display: Add enabled pipe planes into state for selective fetch
Date: Wed, 18 Nov 2026 15:37:24 +0100
Message-ID: <20261118150012.843327346@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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
[ sashal: adapted the collection loop to intel_atomic_check_planes() using the existing intel_atomic_add_affected_planes() helper ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/display/intel_display.c | 12 ++++++++++
 drivers/gpu/drm/i915/display/intel_psr.c     | 25 +++++++-------------
 2 files changed, 20 insertions(+), 17 deletions(-)

diff --git a/drivers/gpu/drm/i915/display/intel_display.c b/drivers/gpu/drm/i915/display/intel_display.c
index 4a3cc3369180b..841a2129bdd3a 100644
--- a/drivers/gpu/drm/i915/display/intel_display.c
+++ b/drivers/gpu/drm/i915/display/intel_display.c
@@ -5879,6 +5879,18 @@ static int intel_atomic_check_planes(struct intel_atomic_state *state)
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
index d59f2131fd996..929113fc12e60 100644
--- a/drivers/gpu/drm/i915/display/intel_psr.c
+++ b/drivers/gpu/drm/i915/display/intel_psr.c
@@ -2561,7 +2561,7 @@ int intel_psr2_sel_fetch_update(struct intel_atomic_state *state,
 		.y2 = crtc_state->hw.adjusted_mode.crtc_vdisplay,
 	};
 	bool full_update = false, su_area_changed;
-	int i, ret;
+	int i;
 
 	/*
 	 * Selective fetch is not always usable, for instance it is dropped
@@ -2676,19 +2676,15 @@ int intel_psr2_sel_fetch_update(struct intel_atomic_state *state,
 
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
@@ -2739,11 +2735,6 @@ int intel_psr2_sel_fetch_update(struct intel_atomic_state *state,
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
@@ -2757,9 +2748,9 @@ int intel_psr2_sel_fetch_update(struct intel_atomic_state *state,
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



