Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 250B4324B35;
	Sat, 25 Oct 2025 16:29:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761409753; cv=none; b=WNcuelM0UgODNIhxRdACjx5ig7mB+ULwPsBn8ycHUajo3urApYbyJG5zHofvvSVcNXjnpg5uS7B+oCJsVMcBMsq+j8g5z6dinR1o6X6PU9zSiME9/CMBFkqvX8cfNd2l7kvZQCAghNDD9n+7LEY1I7ChqKTMqb3pdvf6gUkW604=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761409753; c=relaxed/simple;
	bh=wY1Q/ZJPMTtUIlSEH+LYwjixN+Y4GOXQI6AykOM0EOA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NH367trQoIbpW2qXjqCQkKVcT2SQ7yG/X72nWCg38CVnj7kdjLkvgjnX6TcslaKKVktPYYM9zqEXy9gPQ4+SfRzfjQ+fReNEPqEvkZLnKoLVKaMIOrZbNXfbwoc4cdgpbmwWbKu76iJVjHVdkn4xrQV0zAZhgw9R4sEWSiVmtNo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nZwVhVXJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nZwVhVXJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8B3FC4CEFB;
	Sat, 25 Oct 2025 16:29:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761409753;
	bh=wY1Q/ZJPMTtUIlSEH+LYwjixN+Y4GOXQI6AykOM0EOA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nZwVhVXJLHxTC62fZ2qb5rwA6sK5tJti7Vh98jqp6O+36inow2Mi+hxqDUgpkb5f0
	 Pa3AgFPshcz3lta3n51gYRxutWKTG/XhevFXd65H0DmFDMPN4puipbxhnfAiWpClEn
	 SdytR823gF91Uf4izycqMdfyOjhLk5bdYCmUMZMZ0nFfH/VfAnW10Uf7TGsi8MS+df
	 Z1QILH8JrO+gBYItLbO66wHWYVZzYmZDkqlQjtK9mY7Vy94Sc9EuiiHLaWYcMgF3Vm
	 45Uaplr0qMWa4KDKshH7JuXG81CIvymORtc2TGhSry3/Wz00sxQMawzbBsoBDzKN6l
	 1EJzvOAN72ohA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Danny Wang <Danny.Wang@amd.com>,
	Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
	Tom Chung <chiahsuan.chung@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	Wayne.Lin@amd.com,
	roman.li@amd.com,
	alvin.lee2@amd.com,
	alex.hung@amd.com,
	PeiChen.Huang@amd.com,
	Dillon.Varone@amd.com,
	Sung.Lee@amd.com,
	Charlene.Liu@amd.com,
	alexandre.f.demers@gmail.com,
	Richard.Chiang@amd.com,
	ryanseto@amd.com,
	linux@treblig.org,
	mario.limonciello@amd.com
Subject: [PATCH AUTOSEL 6.17-6.12] drm/amd/display: Reset apply_eamless_boot_optimization when dpms_off
Date: Sat, 25 Oct 2025 12:01:20 -0400
Message-ID: <20251025160905.3857885-449-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251025160905.3857885-1-sashal@kernel.org>
References: <20251025160905.3857885-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.5
Content-Transfer-Encoding: 8bit

From: Danny Wang <Danny.Wang@amd.com>

[ Upstream commit ad335b5fc9ed1cdeb33fbe97d2969b3a2eedaf3e ]

[WHY&HOW]
The user closed the lid while the system was powering on and opened it
again before the “apply_seamless_boot_optimization” was set to false,
resulting in the eDP remaining blank.
Reset the “apply_seamless_boot_optimization” to false when dpms off.

Reviewed-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Signed-off-by: Danny Wang <Danny.Wang@amd.com>
Signed-off-by: Tom Chung <chiahsuan.chung@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES

- What it fixes: On some laptops with eDP, closing the lid during boot
  and reopening before the first flip leaves the panel blank. Root
  cause: the per‑stream flag `apply_seamless_boot_optimization` stays
  true if no flip occurs, so on DPMS resume the driver skips
  reprogramming the link and other enablement, leaving the panel dark.
- Current behavior: The seamless-boot flag is only cleared after the
  first flip. In this tree, `update_seamless_boot_flags()` only clears
  it when there is a plane update:
  drivers/gpu/drm/amd/display/dc/core/dc.c:3393. If the only event is
  DPMS off, the flag remains set.
- Why that blanks eDP: On DPMS on, the link enable path explicitly bails
  out early when `apply_seamless_boot_optimization` is true and “does
  not touch link,” only doing limited work for DP external displays. See
  drivers/gpu/drm/amd/display/dc/link/link_dpms.c:2520. For eDP, this
  means re-enabling doesn’t retrain/reprogram the link, so the screen
  can stay blank.
- How the patch fixes it: The change adds `|| stream->dpms_off` to the
  condition in `update_seamless_boot_flags()`, so the flag is cleared
  not only on first flip but also when DPMS is turned off. The stream’s
  DPMS state is already updated earlier in the same commit path
  (drivers/gpu/drm/amd/display/dc/core/dc.c:3279), and the DPMS off/on
  programming is handled shortly after
  (drivers/gpu/drm/amd/display/dc/core/dc.c:3672). With the flag cleared
  on DPMS off, a subsequent DPMS on will no longer hit the early return
  in link_dpms.c, so the link gets fully reprogrammed, avoiding the
  blank screen.
- Containment and risk: The change is a one-line conditional broadening
  in a helper (no API or structural changes) and only affects the
  seamless‑boot window. It is gated by
  `get_seamless_boot_stream_count(context) > 0`, so it only acts when
  seamless‑boot optimization is active. Clearing the optimization when
  the panel is already being powered down is low risk and makes the
  DPMS-on path behave like a normal enable rather than a seamless
  resume.
- Interactions: This aligns with prior fixes that avoid toggling DPMS
  during seamless boot (e.g., “Don’t set dpms_off for seamless boot”);
  it closes a different corner case where DPMS is requested before the
  first flip. It also ensures `dc_post_update_surfaces_to_stream` isn’t
  indefinitely deferred by `get_seamless_boot_stream_count(context) > 0`
  during/after DPMS off (drivers/gpu/drm/amd/display/dc/core/dc.c:2526).
- Stable backport fit:
  - Fixes a real user-visible bug (blank eDP after lid cycle during
    boot).
  - Minimal, self-contained change in AMDGPU DC.
  - No new features or architectural changes.
  - Uses existing fields and code paths present in stable trees.
  - Reviewed/acknowledged/tested in the commit message, increasing
    confidence.

Conclusion: This is a small, targeted bug fix with clear rationale and
minimal regression risk, and should be backported to stable.

 drivers/gpu/drm/amd/display/dc/core/dc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc.c b/drivers/gpu/drm/amd/display/dc/core/dc.c
index bc364792d9d31..2d2f4c4bdc97e 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc.c
@@ -3404,7 +3404,7 @@ static void update_seamless_boot_flags(struct dc *dc,
 		int surface_count,
 		struct dc_stream_state *stream)
 {
-	if (get_seamless_boot_stream_count(context) > 0 && surface_count > 0) {
+	if (get_seamless_boot_stream_count(context) > 0 && (surface_count > 0 || stream->dpms_off)) {
 		/* Optimize seamless boot flag keeps clocks and watermarks high until
 		 * first flip. After first flip, optimization is required to lower
 		 * bandwidth. Important to note that it is expected UEFI will
-- 
2.51.0

