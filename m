Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2436730ACF8;
	Sat, 25 Oct 2025 16:25:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761409549; cv=none; b=ldIXt9yyrSjrgI4gO7j/Ji2bsQkrCGqtFylhnPTE57WRbYTK8ovsBfTXDOx/cmievIixsgJcym5l5gRQPteYeab4vCNuXafSL+njvsu3sBCWdDz7DKWgytAn2iijlAFP73sdmEzxXfipa6iS13r6d7aDByJdt2zQsq77X+J1Bnc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761409549; c=relaxed/simple;
	bh=X73Lb75M9rk0/VzIfw0SixOYpc/Gf8+wIOhvzWroNXs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lEaZcc0+51ClltTCoBQBvSd/s6moCR4veigyA2kQAg0LRC1nI+Cn/p9vIS4hQOw2RxINODbKIoW8Pr4ODsQxTeQyHTvKrDY4kLV4Ktzo2WbVE160X+jJfS/syhESNiV66G4kkDjO8Junae6KxQwtSsc4acMmAbiBj3YZV2BjSdo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LjHHEYRc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LjHHEYRc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6F6AC116B1;
	Sat, 25 Oct 2025 16:25:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761409547;
	bh=X73Lb75M9rk0/VzIfw0SixOYpc/Gf8+wIOhvzWroNXs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LjHHEYRcBm8btsZqiGaFf4ZdTZMXSiqgzVvXXlHcVRjAC8lvjXHPF5SI6ADW6YUop
	 pW4niNEvDTxuBB48138wMv1NXHyuq4gd9LHa15CsN0h05jo0p9SlL2xemRi2I9DYIg
	 cke54C7QEVNdZaHqoHdghnWRNXHCo4kr+5wi2YoaVchWj+U6RdFoivKqM55iLCncVv
	 2HsdbyHfWZ1XVdAvIcPk2mk2BimRnWCoIuZuXr38YmBP+9RPlvV/mXWS/+IZnK+iK/
	 Xg0OwYswqg4G27KvuXcObhxT3HIhTwS6UIhyphLqfDX5pRORZsYdhlUCLx3Ws+QAUw
	 0Qd/x2/J0WjlQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Jayesh Choudhary <j-choudhary@ti.com>,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
	Sasha Levin <sashal@kernel.org>,
	jyri.sarha@iki.fi,
	dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 6.17-5.15] drm/tidss: Set crtc modesetting parameters with adjusted mode
Date: Sat, 25 Oct 2025 11:59:50 -0400
Message-ID: <20251025160905.3857885-359-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251025160905.3857885-1-sashal@kernel.org>
References: <20251025160905.3857885-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jayesh Choudhary <j-choudhary@ti.com>

[ Upstream commit cfb29225db20c56432a8525366321c0c09edfb2e ]

TIDSS uses crtc_* fields to propagate its registers and set the
clock rates. So set the CRTC modesetting timing parameters with
the adjusted mode when needed, to set correct values.

Cc: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
Signed-off-by: Jayesh Choudhary <j-choudhary@ti.com>
Link: https://lore.kernel.org/r/20250624080402.302526-1-j-choudhary@ti.com
Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES

- What it fixes
  - The patch computes the CRTC timing fields (crtc_clock, crtc_htotal,
    crtc_vtotal, etc.) in the adjusted mode during modesets. Without
    this, those fields remain unset, which breaks consumers that rely on
    them (notably DRM’s vblank timestamping and some bridges that expect
    crtc_* to be valid).
  - In TIDSS today, atomic enable programs the pixel clock from
    mode->clock and programs timings from mode->hsync_start/htotal etc.,
    so hardware programming itself doesn’t use crtc_* directly. However,
    the DRM core expects crtc_* in the adjusted mode to be valid for
    vblank calculations and helpers.

- Changes in this patch
  - Converts the local mode pointer to non-const so it can be passed to
    the mutating helper:
    - drivers/gpu/drm/tidss/tidss_crtc.c:94
  - After validating the adjusted mode, it initializes the crtc_* timing
    members when a modeset is needed:
    - drivers/gpu/drm/tidss/tidss_crtc.c:102
    - drivers/gpu/drm/tidss/tidss_crtc.c:104
    - New: if (drm_atomic_crtc_needs_modeset(crtc_state))
      drm_mode_set_crtcinfo(mode, 0);
  - The rest of the function remains unchanged, returning the existing
    bus check:
    - drivers/gpu/drm/tidss/tidss_crtc.c:111

- Why this matters (core interactions)
  - Atomic helpers compute vblank timestamping constants from the new
    crtc state’s adjusted mode and they explicitly use the crtc_*
    members:
    - drivers/gpu/drm/drm_atomic_helper.c:1437
    - drivers/gpu/drm/drm_vblank.c:651
  - If crtc_clock is 0 (because crtc_* fields weren’t populated), DRM
    reports it can’t calculate constants and bails:
    - drivers/gpu/drm/drm_vblank.c:728
  - By setting crtc_* in adjusted_mode before the commit helpers run,
    vblank timing setup becomes correct and robust.

- Scope and risk
  - Small, contained change in a single driver file (one variable type
    tweak + one call).
  - No architectural changes; no feature additions.
  - Safe for non-interlaced modes (TIDSS rejects interlace already:
    drivers/gpu/drm/tidss/tidss_dispc.c:1377–1380).
  - Doesn’t change how TIDSS programs hardware timings: dispc still uses
    mode->{h*, v*, flags}
    (drivers/gpu/drm/tidss/tidss_dispc.c:1218–1269), and pixel clock
    still comes from mode->clock
    (drivers/gpu/drm/tidss/tidss_crtc.c:227–229).
  - Improves correctness for DRM subsystems that rely on crtc_* (vblank,
    some bridges).

- Stable backport criteria
  - Fixes a real bug that can cause broken/missing vblank timing and
    potentially wrong rates in downstream components that use crtc_*.
  - Minimal and self-contained.
  - No user-visible API/ABI changes and low regression risk.
  - Applies to all stable trees that include TIDSS and the atomic helper
    flow; dependencies (drm_mode_set_crtcinfo and
    drm_atomic_crtc_needs_modeset) are longstanding.

Conclusion: This is a targeted bugfix with low risk and clear benefit
for correctness in the DRM atomic pipeline; it should be backported to
stable.

 drivers/gpu/drm/tidss/tidss_crtc.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/tidss/tidss_crtc.c b/drivers/gpu/drm/tidss/tidss_crtc.c
index 17efd77ce7f23..da89fd01c3376 100644
--- a/drivers/gpu/drm/tidss/tidss_crtc.c
+++ b/drivers/gpu/drm/tidss/tidss_crtc.c
@@ -91,7 +91,7 @@ static int tidss_crtc_atomic_check(struct drm_crtc *crtc,
 	struct dispc_device *dispc = tidss->dispc;
 	struct tidss_crtc *tcrtc = to_tidss_crtc(crtc);
 	u32 hw_videoport = tcrtc->hw_videoport;
-	const struct drm_display_mode *mode;
+	struct drm_display_mode *mode;
 	enum drm_mode_status ok;
 
 	dev_dbg(ddev->dev, "%s\n", __func__);
@@ -108,6 +108,9 @@ static int tidss_crtc_atomic_check(struct drm_crtc *crtc,
 		return -EINVAL;
 	}
 
+	if (drm_atomic_crtc_needs_modeset(crtc_state))
+		drm_mode_set_crtcinfo(mode, 0);
+
 	return dispc_vp_bus_check(dispc, hw_videoport, crtc_state);
 }
 
-- 
2.51.0

