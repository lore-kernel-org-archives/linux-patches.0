Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047539;
	b=KWB2Kav8yMpB+TDOuQYDj6TtL3BfuXwEKe/Q65U3Ftw7RUBd3TGGb6AXTN1uG0dTmI80
	 lkYriINJwDTu5qXUD1VF6umI6C5LLESlkcDpdA3m63Dr/aJnZTXdJFgKSMIvaO39rULOS
	 HTvkJNYIowpHID3qEM4h5bEEw6IEBY0VenZVzO12sWVG/OK9MA23f56WAozz0M0yywgCA
	 0kUtnl1Iz/LceKTtuPtE1LrVfi8vMTPegWUP8EXRTzIbQ9G1mO0GIB/hHCfk5X5EA5yUq
	 Uozo6mKScb79K+AKdBllkFz4EPNJN5ox8LVHOXK6u7d+u8daVNvD3j/2vySLn7CTzww==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047539;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=a2b9UrgRecs6jOEZjaFDUFM4qr5Xc+qV2X6MeZvpR2s=;
	b=a+ki+V27t7iOof/XldjyPAGv9pNpxE9xRA1FN2P2g2fiutnFZtJ1QXNEYIlUBkpfQFmE
	 S1wP9lP5FnyHiJxzPSoJUXhfV+6WDVxptmRawpdJ4VDqFULPkT1i46uYSaeGXB2ehywEo
	 xhQWTrjda5WEiXnta4iBFevGTf6g+NY1arhNTXxbqGi0yEvB1MCgElrNrt/9fA7zxKr+s
	 P2cqGX8lB8PgKnb5ZdBEUf563SXBcjI8gbmXGVDWfLQPp/rtgnuTMHz0LwlMESrt5v8d0
	 1WXUVAAa9VysSvZDMTkPUY7jSXwiol+UDkQaeMkzQxXIM65H58os29dynkCOY6Pyqvw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="hyxM/X1U";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C0B6606A320;
	Thu, 19 Nov 2026 00:18:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hyxM/X1U
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1CF51F000C4;
	Thu, 19 Nov 2026 00:18:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047539;
	bh=a2b9UrgRecs6jOEZjaFDUFM4qr5Xc+qV2X6MeZvpR2s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hyxM/X1UkPi9Cp2Bpe7cwXmJoeGZDhgxVy29l08Ojap1gyJxvT1S2yCTPYvzmHEra
	 LTxd+WXQjM8ZeGgKrNm7I5tSl55yjgT367xi8WPlajTkvd0GdLmdOn27QLKS3nZU2t
	 GTvVlRix1JKZfbWSUSRNL8H0mujdZqa/hltoq6rQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Jouni=20H=C3=B6gander?= <jouni.hogander@intel.com>,
	Mika Kahola <mika.kahola@intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1674/2857] drm/i915/psr: Clear selective fetch area when duplicating plane state
Date: Wed, 18 Nov 2026 15:45:08 +0100
Message-ID: <20261118150301.605268777@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: adapted clip_area_update() to use local pipe_clip instead of crtc_state->psr2_su_area ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/display/intel_atomic_plane.c | 1 +
 drivers/gpu/drm/i915/display/intel_psr.c          | 9 ++++++---
 2 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/i915/display/intel_atomic_plane.c b/drivers/gpu/drm/i915/display/intel_atomic_plane.c
index 82826454b5e83..b54d3d05a787d 100644
--- a/drivers/gpu/drm/i915/display/intel_atomic_plane.c
+++ b/drivers/gpu/drm/i915/display/intel_atomic_plane.c
@@ -109,6 +109,7 @@ intel_plane_duplicate_state(struct drm_plane *plane)
 	intel_state->ggtt_vma = NULL;
 	intel_state->dpt_vma = NULL;
 	intel_state->flags = 0;
+	intel_state->psr2_sel_fetch_area = DRM_RECT_INIT(0, 0, 0, 0);
 
 	/* add reference to fb */
 	if (intel_state->hw.fb)
diff --git a/drivers/gpu/drm/i915/display/intel_psr.c b/drivers/gpu/drm/i915/display/intel_psr.c
index 3c5553b21fa89..6839b8fd61aef 100644
--- a/drivers/gpu/drm/i915/display/intel_psr.c
+++ b/drivers/gpu/drm/i915/display/intel_psr.c
@@ -1807,7 +1807,7 @@ int intel_psr2_sel_fetch_update(struct intel_atomic_state *state,
 
 	if (!psr2_sel_fetch_pipe_state_supported(crtc_state)) {
 		full_update = true;
-		goto skip_sel_fetch_set_loop;
+		goto skip_su_area_calc;
 	}
 
 	/*
@@ -1893,7 +1893,7 @@ int intel_psr2_sel_fetch_update(struct intel_atomic_state *state,
 	}
 
 	if (full_update)
-		goto skip_sel_fetch_set_loop;
+		goto skip_su_area_calc;
 
 	ret = drm_atomic_add_affected_planes(&state->base, &crtc->base);
 	if (ret)
@@ -1901,6 +1901,10 @@ int intel_psr2_sel_fetch_update(struct intel_atomic_state *state,
 
 	intel_psr2_sel_fetch_pipe_alignment(crtc_state, &pipe_clip);
 
+skip_su_area_calc:
+	if (full_update)
+		clip_area_update(&pipe_clip, &display_area, &display_area);
+
 	/*
 	 * Now that we have the pipe damaged area check if it intersect with
 	 * every plane, if it does set the plane selective fetch area.
@@ -1947,7 +1951,6 @@ int intel_psr2_sel_fetch_update(struct intel_atomic_state *state,
 		}
 	}
 
-skip_sel_fetch_set_loop:
 	psr2_man_trk_ctl_calc(crtc_state, &pipe_clip, full_update);
 	return 0;
 }
-- 
2.53.0



