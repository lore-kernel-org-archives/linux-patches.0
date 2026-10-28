Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209136;
	b=LHuJpc2tQ+rgT2Kmqlia53Fv7LL1qvUOjmzBL5m9Gyr48jDb8xwA+wkgpmJXZAHPD3jp
	 C6vSFkM5ovVqopoGR/68bw9LVFVQlgZ+Tu3uBCFQHKKp1UAak6CBCohRi9/7vijq1btVc
	 jZZmwVbuYmQuVdooc3EGu7LmuB9wROBzvqYdDt/7YdhnIjv1ST4k2/7gTgkK5JUUmccH6
	 k7ZF8HuFj9sW7qj5RnIWFUy5smz8ttj+6rk9fqMVyTM5yTo+sMNYq1EgzzdUfAzUouQaH
	 wiU5Xj1cZsnVPGxLrdH36kSl1Rd17pfddTBM7kc/laOZ8uSCN6A0PvyCErl9Z/dJkzQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209136;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xxlOI/I9oLxmDNVzLB54NLOBuiDEG63mrDrvwSRNeAQ=;
	b=IDD3QsROD8mjd/ghaDi02hYkhL12BVcnGy3YFm+4rzyoiWhuNocuTz1PgxgMbSDKmmVN
	 jKoQlEgmIO0rMOfKmP5pSqFcYZ/T+UA+ivv1TfPMVZSU2P4dn22EkmcY/wzpLhxkPXnr4
	 81CMNzVXUyNd/AMyeqd4VX1LiMukQe3ONWm7fc1JjouqWxmKcGr2oWCCEoTZSnjgE6c1b
	 39wIYp8R37axRl+Y2ALvcjCyPbQSIXLX6c8e1aZ6jPLPhOJkfl8acW4npflY4i79rnyVK
	 dqLEpGy55bdpdnBT9fN5csast7cvVTQFHuJ9DDiQcqD80rUcqkHsvBtFsP4WjsMc/hQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UdNRHkEw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E6DE606A31C;
	Wed, 28 Oct 2026 17:38:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UdNRHkEw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB4A71F01825;
	Wed, 28 Oct 2026 17:38:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209136;
	bh=xxlOI/I9oLxmDNVzLB54NLOBuiDEG63mrDrvwSRNeAQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UdNRHkEw2tvsOlyKEiHfZEih8mMWhsn20SyDymNhNUhSaEzBBlLW44CdvacANzEVN
	 eztQd7yxN3MQZFz37SXxmASUDrn7mpOcw3c6544e82KFOgUA8JnX49OTMcWIxZVFOg
	 Wsfm1fHN8jsw5kJrlWHXm4yUrWelNHVuN5wWW7ek=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Betschart <adrian.betschart@cinemaone.ch>,
	Dan Wheeler <daniel.wheeler@amd.com>,
	Roman Li <roman.li@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 364/516] drm/amd/display: Dont replace a sink mode that shares the native totals
Date: Wed, 28 Oct 2026 17:58:36 +0100
Message-ID: <20261028170012.109616337@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index b8dc14ea42032..3b37aca3781e4 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -4710,11 +4710,16 @@ decide_crtc_timing_for_drm_display_mode(struct drm_display_mode *drm_mode,
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



