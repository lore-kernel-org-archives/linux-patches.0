Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211655;
	b=kxuuSzlcxixuzMKUUhy5c/kQt6Qsvl/E93jBrTzDnHhd+rGcwPCK4jvKB0dyxK+k6+Kd
	 iVpnp35b84I5U3VDsiMgVX6wfJ+dlSDZNpIyHY93KNjQbIhEBSneNVGffg75RdYOLOEcA
	 +WNuGL55mtrO+m55VK8V9tUE6WPpNTOxcedNzIKgKyvcUlA753pie/PbMoi2CE1pPAntP
	 HWTFOO1l9SbrYzhXQVDCyr4jXo0ZazrayzIstvgARaeqpSMxLau5SyslJuEIeoceRCVyY
	 kCv/zEPF+dSe39fIUzc+DhRvFlm/uPD/3XPopvSvuhEQ7X1nFGWunuw6OosZUuj3MiA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211655;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1R2Bu7mQcOiHovj/jiNrx8QTaOSwwTifHhoo9d5rILY=;
	b=Tx9a3h3AIjID952iKdLo8I+8lHBi/DePQURS0kTO+20fpcwaRB8frsseQ0ihfUMLp+im
	 mu6HPCb46C+gOigbVXFn1F+MUKOkGD2jYzt0jL4o5GtzKdubjUWEqscQKeo6o7LT3DF+M
	 OdRsHkALGNSO48FuKegtHddglAz7t9MnH9DeWKlmfO/oA/CLCS1k5ZrM5Z6g9wrznH6q9
	 NwqlwlKTOcLDjWbsP7GfDRKcV8rDBbH69oTj4SCnNolBAVI9na63fHXBSbI8AMvuwPFgM
	 RTOryzeiI/ybSwzGhKtKjw3QjpCV2oB8y6Rdjilg43A3NBowCd66CQnPzZSd6wGjJRA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=C1V8UV2i;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56C68606A31A;
	Wed, 28 Oct 2026 18:20:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=C1V8UV2i
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9A161F01825;
	Wed, 28 Oct 2026 18:20:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211655;
	bh=1R2Bu7mQcOiHovj/jiNrx8QTaOSwwTifHhoo9d5rILY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=C1V8UV2iUMkzr7uhpLsS36xoAQsi0YXRIBpxOOxRyNKqLK5ZasH27faYPvhNTWIFi
	 PYHgYNMeFv9wNDLDmawjgWefFDrYYStJGMczh+M/DkasuG27Np6114X9IgFA7X5gfl
	 cfsJGYdZmGgUk8SP0LF6Y81jJUlTMgOAeFhHTMP4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Betschart <adrian.betschart@cinemaone.ch>,
	Dan Wheeler <daniel.wheeler@amd.com>,
	Roman Li <roman.li@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 417/571] drm/amd/display: Dont replace a sink mode that shares the native totals
Date: Wed, 28 Oct 2026 17:59:24 +0100
Message-ID: <20261028170017.905634422@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Adrian Betschart <adrian.betschart@cinemaone.ch>

commit 54c998c55fc9cbc391b350d67b86e0c2a0748f1a upstream.

decide_crtc_timing_for_drm_display_mode() copies the native mode's CRTC
timing into the requested mode when clock, htotal and vtotal match.
That is meant for the modes amdgpu inserts itself:
amdgpu_dm_create_common_mode() duplicates the native mode and changes
only hdisplay and vdisplay, so those are sent with the native timing
and scaled.

A sink can also offer a real mode with the same clock and totals as
its native mode. CTA-861 VIC 102 (4096x2160@60) and VIC 97
(3840x2160@60) both use 594 MHz and 4400x2250. With 3840x2160@60 as
the preferred mode, a 4096x2160@60 request goes out with the 3840x2160
timing and the framebuffer scaled into it (dst 3840x2025 at y=67),
while the AVI InfoFrame still carries VIC 102. A JVC projector then
reports 3840x2160 and shows a corrupted right edge. 4096x2160@24,
whose totals differ, is sent and displayed correctly.

Inserted modes keep the native sync positions; a real mode with its
own active width does not. Compare those too, so only inserted modes
are patched.

Fixes: 4562236b3bc0 ("drm/amd/dc: Add dc display driver (v2)")
Signed-off-by: Adrian Betschart <adrian.betschart@cinemaone.ch>
Assisted-by: Claude-Code:claude-opus-5-5
Tested-by: Dan Wheeler <daniel.wheeler@amd.com>
Reviewed-by: Roman Li <roman.li@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 22f9a2da101c37f821cd00954f81dc598754f4d5)
Cc: stable@vger.kernel.org
(cherry picked from commit 54c998c55fc9cbc391b350d67b86e0c2a0748f1a)
[ Adrian: this tree keeps the function in amdgpu_dm.c, with the equal-totals
  case as its own else-if; added the sync checks there. Dropped the KUnit
  test, its file does not exist here. ]
Signed-off-by: Adrian Betschart <adrian.betschart@cinemaone.ch>
Assisted-by: Claude-Code:claude-opus-5-5
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index 288ef18e70d05..d22c05f68f876 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -6029,11 +6029,16 @@ decide_crtc_timing_for_drm_display_mode(struct drm_display_mode *drm_mode,
 					const struct drm_display_mode *native_mode,
 					bool scale_enabled)
 {
+	/* Inserted modes copy the native sync; a sink mode with equal totals may not */
 	if (scale_enabled) {
 		copy_crtc_timing_for_drm_display_mode(native_mode, drm_mode);
 	} else if (native_mode->clock == drm_mode->clock &&
 			native_mode->htotal == drm_mode->htotal &&
-			native_mode->vtotal == drm_mode->vtotal) {
+			native_mode->vtotal == drm_mode->vtotal &&
+			native_mode->hsync_start == drm_mode->hsync_start &&
+			native_mode->hsync_end == drm_mode->hsync_end &&
+			native_mode->vsync_start == drm_mode->vsync_start &&
+			native_mode->vsync_end == drm_mode->vsync_end) {
 		copy_crtc_timing_for_drm_display_mode(native_mode, drm_mode);
 	} else {
 		/* no scaling nor amdgpu inserted, no need to patch */
-- 
2.53.0



