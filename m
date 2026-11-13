Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585465;
	b=QEKtprG1QutsEtNJx5SGwKH203YrWd5imogjJi9VmmO8unMC/FcOaeRvESo7tRtApBKE
	 wZT3woNl7gcqzbDpC71NHjGtdaViDUaaXhWMmpGFhsGEPJ64pMzKBaRv6P7ZfBupkpM1t
	 4S9APqjvR8d25/Dra3J/Kafk3XATC2lXnG4FlQtPCshGJxkPjuBY29fIYvm3PA+6hbnsH
	 yfvKwizOmAYQVs5BUradT1WKlIuChz03p3lvy4xHghCZEPvvBqAF2uu3TumRSGNOWjY83
	 FkWIHtCMKQ9C1xL0eAoEgHEfq5MbVNOTlJl83hdk+NDeLqe2/ZG+HoyGDEugTDcC9UQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585465;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=6JJUkYjpFNZJRzqvzFyipjSg8rnBIWHhatDrHu7P5mk=;
	b=mqHiYzVxs+11C1HKjsO7Yype49btkB3GO8xEzUqiAyYPUWqFmS0fJDjesqVArGX1eMSn
	 8KxAKOnJYQF4oVifL4dJqxmp7uwKixkxht1p8YH9719R567pnRxXP8lVbBgJwzp5W/1/p
	 hIPzDp25ZjKHeyJAdFhKr13I/0oFQ5HrSA5pwUqFN/iKW5c+Zv6yi5JFtGVbEQ3tVSLgL
	 7tiW2UqiavD7zm7TcIZ3aGn3Pb+1fKXfoCXU2Cj9ubR214MX2tAE3wCnIKjJ3UAlLJuhQ
	 akXqMirIGM9QfnRdtRnRnhzKlAI4ZpH/zccj2YQIC6YWcFLVBkKeiKHWzd7otiifHkw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=M0WdSNY+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFE01606EB81;
	Fri, 13 Nov 2026 15:57:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=M0WdSNY+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AF4A1F000C5;
	Fri, 13 Nov 2026 15:57:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585465;
	bh=6JJUkYjpFNZJRzqvzFyipjSg8rnBIWHhatDrHu7P5mk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=M0WdSNY+AZp1UN28XAd61gV08pnVRVkPbK4vKEfkGpmOeYfdHYlkQXd+yTrYx0pG8
	 OvJdqoCKpafodTYiLWD9dFnPrktsj1nId5jIrN55oIzStj5SZ6Cb4lLu2tyyDYgkhL
	 NCJRBgH/xa7M40k7YNlDAwdVfvPsBS+sLEGHr1Vc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Jouni=20H=C3=B6gander?= <jouni.hogander@intel.com>,
	Mika Kahola <mika.kahola@intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 121/507] drm/i915/psr: Disable linked plane sel fetch as well
Date: Fri, 13 Nov 2026 10:47:05 -0500
Message-ID: <20261113153758.515549015@linuxfoundation.org>
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
index 5522d1e0cbcc5..1a9706d43b625 100644
--- a/drivers/gpu/drm/i915/display/intel_psr.c
+++ b/drivers/gpu/drm/i915/display/intel_psr.c
@@ -3058,21 +3058,14 @@ int intel_psr2_sel_fetch_update(struct intel_atomic_state *state,
 
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
@@ -3080,16 +3073,22 @@ int intel_psr2_sel_fetch_update(struct intel_atomic_state *state,
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



