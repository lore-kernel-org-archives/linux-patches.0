Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038970;
	b=4LcgT5iQuWVbiWaxQlEGuJ/f6m/NwEpxR2vZi0xS/9bJ2BJUfxYd+lqWts8Wr5m9E+z7
	 csaHi0hTsaqOYT1PiGEa2fZpNaedrxQdVy6bngPyNZWj4EOP27GvKwCJf60PcR7nnQoXN
	 ePj4h7LyFVumFQK7w5ppwV9WYy5Q6YjCYyH1pyl41R/TtQH6TDq8v/f0sCzORRVqLE8uP
	 +8GALUmIUnms2lSNtkRA2j/04MnI7zelStPbALTwAoyY3tk9VhaXgQCDkcvRAg0z2byOC
	 Wl4Z/0j7rhryuSuMZJDnSqfsVNVC3ge/PfRa8CHuV+X44u1btTrNbTNPQlFq1eHXJKA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038970;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=AOX3sKSilQQKdvkUwDIjGQ4Bd45eG6Pkln73ss/YrbM=;
	b=RZsNKpvTtc2o9gSGhuP0U7vtSIUqCyykE/AszduOFh4s+VVS2/69jJ7RD+dObPQfPNL6
	 5N88OTZMjN65pMga103c8ttLdfEay/7Sx//Oq3IG8LjAmIwitlJdnEZraop9EyxWG8WWV
	 ClnV3pEg/znkquQFNKo9ohSMYCcd5kCvsGn8/lUSuTyT06g32iYUsaazHR7FIIjcXHQnH
	 zx1EI/jTn+T640mKJBCkHRr1gVtywbjOIpK1VwU9/3NWk/ETaAZ+VeePdjZVpOihsu+xo
	 b3FvBX8WLwKkoLHHQLS9IrBDe8zRlBzmTIE2WQtS0ebO9SH0KWTviO8R1PnrMSwppHw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=umqu0qKC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F58F606A31C;
	Wed, 18 Nov 2026 21:56:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=umqu0qKC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 021E41F000C4;
	Wed, 18 Nov 2026 21:56:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795038970;
	bh=AOX3sKSilQQKdvkUwDIjGQ4Bd45eG6Pkln73ss/YrbM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=umqu0qKCw9HwsFZk5p9QxeWzDphw/Y66bn9op8dtYkVRy3NQJDsGlmNonWMkMpR5k
	 9EkDQHYphEk8lGtPByVpENtyXpf/lfqz0RVuM6rHOmMJ6FwstO6Rxc4/HpCzYDbyGu
	 9cA1aCZv96YPUQOCPns7M7h2eHQ0D1NjBRtKkYno=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Jouni=20H=C3=B6gander?= <jouni.hogander@intel.com>,
	Mika Kahola <mika.kahola@intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1934/3318] drm/i915/psr: Clear selective fetch area when duplicating plane state
Date: Wed, 18 Nov 2026 15:42:36 +0100
Message-ID: <20261118150420.058973734@linuxfoundation.org>
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
[ sashal: Used the existing pipe_clip rectangle instead of crtc_state->psr2_su_area. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/display/intel_atomic_plane.c | 1 +
 drivers/gpu/drm/i915/display/intel_psr.c          | 9 ++++++---
 2 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/i915/display/intel_atomic_plane.c b/drivers/gpu/drm/i915/display/intel_atomic_plane.c
index 60a492e186ab8..2513e2bfe1be4 100644
--- a/drivers/gpu/drm/i915/display/intel_atomic_plane.c
+++ b/drivers/gpu/drm/i915/display/intel_atomic_plane.c
@@ -110,6 +110,7 @@ intel_plane_duplicate_state(struct drm_plane *plane)
 	intel_state->ggtt_vma = NULL;
 	intel_state->dpt_vma = NULL;
 	intel_state->flags = 0;
+	intel_state->psr2_sel_fetch_area = DRM_RECT_INIT(0, 0, 0, 0);
 
 	/* add reference to fb */
 	if (intel_state->hw.fb)
diff --git a/drivers/gpu/drm/i915/display/intel_psr.c b/drivers/gpu/drm/i915/display/intel_psr.c
index 416686a6566ba..107172e630aae 100644
--- a/drivers/gpu/drm/i915/display/intel_psr.c
+++ b/drivers/gpu/drm/i915/display/intel_psr.c
@@ -2050,7 +2050,7 @@ int intel_psr2_sel_fetch_update(struct intel_atomic_state *state,
 
 	if (!psr2_sel_fetch_pipe_state_supported(crtc_state)) {
 		full_update = true;
-		goto skip_sel_fetch_set_loop;
+		goto skip_su_area_calc;
 	}
 
 	/*
@@ -2136,7 +2136,7 @@ int intel_psr2_sel_fetch_update(struct intel_atomic_state *state,
 	}
 
 	if (full_update)
-		goto skip_sel_fetch_set_loop;
+		goto skip_su_area_calc;
 
 	/* Wa_14014971492 */
 	if ((IS_MTL_DISPLAY_STEP(dev_priv, STEP_A0, STEP_B0) ||
@@ -2150,6 +2150,10 @@ int intel_psr2_sel_fetch_update(struct intel_atomic_state *state,
 
 	intel_psr2_sel_fetch_pipe_alignment(crtc_state, &pipe_clip);
 
+skip_su_area_calc:
+	if (full_update)
+		clip_area_update(&pipe_clip, &display_area, &display_area);
+
 	/*
 	 * Now that we have the pipe damaged area check if it intersect with
 	 * every plane, if it does set the plane selective fetch area.
@@ -2196,7 +2200,6 @@ int intel_psr2_sel_fetch_update(struct intel_atomic_state *state,
 		}
 	}
 
-skip_sel_fetch_set_loop:
 	psr2_man_trk_ctl_calc(crtc_state, &pipe_clip, full_update);
 	return 0;
 }
-- 
2.53.0



