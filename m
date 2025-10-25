Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 221DD2FF168;
	Sat, 25 Oct 2025 16:12:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761408721; cv=none; b=aU2mWkq2wfXLsQ2EYq4uSjZ11v1KArRtQ9l8wDmU89LPAjYlX5MWppEhNXPB6ZAh/vUpQ4yoeP+dhMTXS2fXQm4Z8uw6dFf3RBrhbP0z1LQPDSVR4jYlibBkNtxw4bqgH3eeC72uFpbc//zLvOdEa+XzcoTK8A1dn7r+8+w2uak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761408721; c=relaxed/simple;
	bh=cw2E9WfvKRErIt2tmUnxebsySKme/KCmOZt2LmsU7Vc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VDv6yJwrM3FtkXHVG8bVLYG+Gex6KxoFTQAwfePMArGcoqEUbgJ/2pHA+BHjT6FmMS1BXiXrQ3k/TgoP45NlbAxZujoYXzgXZruUEYe6iWIqf4QePiBzGbuCqHVPAcDpR/3eViY/kHSkei2DKaLGhHDP92d4NXzqKlkmw1j1x3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=egrus4nY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="egrus4nY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD58EC4CEFB;
	Sat, 25 Oct 2025 16:11:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761408721;
	bh=cw2E9WfvKRErIt2tmUnxebsySKme/KCmOZt2LmsU7Vc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=egrus4nY6soyzjiHlvgiZidRkAk9ECJhFXll+BmBnu7EwYKjtuTAg+oqw9F5fhAw+
	 M1TVe5zqayeSkXJrmEB7OnPh3MIcaG0+9v0Ig9YEZ0cEupo6KoaYNiU4Mu/o6J0/A2
	 fre3NxLkagoWRjluc4S4DBhILuvyXHRLHNVCBiOouWiFdajhUmSwzBu9eHOAJIcIhD
	 uxom2MDSG1+xFsEIMpwYbE5CFHNiYjMcm3aMjnsLVm911D2smtulFLxl0qDrDluTiR
	 ocAQBNf+cJQrB7zTLUoMh5Z6inLCKPYrwlIH1Zc1SWHOn0X16zm3hfj9Pd3Al/1quk
	 1xP2Z0JmSEhdA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Tangudu Tilak Tirumalesh <tilak.tirumalesh.tangudu@intel.com>,
	Jonathan Cavitt <jonathan.cavitt@intel.com>,
	Matt Roper <matthew.d.roper@intel.com>,
	Michal Wajdeczko <michal.wajdeczko@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Gustavo Sousa <gustavo.sousa@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	lucas.demarchi@intel.com,
	thomas.hellstrom@linux.intel.com,
	intel-xe@lists.freedesktop.org
Subject: [PATCH AUTOSEL 6.17] drm/xe: Extend wa_13012615864 to additional Xe2 and Xe3 platforms
Date: Sat, 25 Oct 2025 11:54:44 -0400
Message-ID: <20251025160905.3857885-53-sashal@kernel.org>
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

From: Tangudu Tilak Tirumalesh <tilak.tirumalesh.tangudu@intel.com>

[ Upstream commit bcddb12c027434fdf0491c1a05a3fe4fd2263d71 ]

Extend WA 13012615864 to Graphics Versions 20.01,20.02,20.04
and 30.03.

Signed-off-by: Tangudu Tilak Tirumalesh <tilak.tirumalesh.tangudu@intel.com>
Signed-off-by: Jonathan Cavitt <jonathan.cavitt@intel.com>
Cc: Matt Roper <matthew.d.roper@intel.com>
Cc: Michal Wajdeczko <michal.wajdeczko@intel.com>
Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
Reviewed-by: Gustavo Sousa <gustavo.sousa@intel.com>
Link: https://lore.kernel.org/r/20250731220143.72942-2-jonathan.cavitt@intel.com
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES

- What changed
  - Adds WA 13012615864 (sets `TDL_TSL_CHICKEN` bit `RES_CHK_SPR_DIS`)
    to Xe2 platforms:
    - New entry for `GRAPHICS_VERSION(2004)` with
      `xe_rtp_match_first_render_or_compute` in
      `drivers/gpu/drm/xe/xe_wa.c` (adds a single masked register write
      on first render/compute engine).
    - New entry for `GRAPHICS_VERSION_RANGE(2001, 2002)` with
      `xe_rtp_match_first_render_or_compute` in
      `drivers/gpu/drm/xe/xe_wa.c`.
  - Extends the existing Xe3 entry to also match
    `GRAPHICS_VERSION(3003)` in `drivers/gpu/drm/xe/xe_wa.c` (previously
    limited to `3000–3001`).
  - The bit being set is defined in
    `drivers/gpu/drm/xe/regs/xe_gt_regs.h:494-497` (`TDL_TSL_CHICKEN`
    with `RES_CHK_SPR_DIS`).

- Why this is a bugfix
  - WA 13012615864 disables a TDL/TSL resource check (`RES_CHK_SPR_DIS`)
    known to be problematic; it was already applied to Xe3 LPG
    (`GRAPHICS_VERSION_RANGE(3000, 3001)`) via the earlier upstream
    commit (see existing entry at `drivers/gpu/drm/xe/xe_wa.c:649-653`
    in this tree). This change recognizes the same hardware issue exists
    on additional Xe2/Xe3 SKUs and applies the same single-bit
    mitigation there.
  - This is not a feature; it’s standard errata programming (a hardware
    workaround) that prevents potential functional issues like
    stalls/hangs or incorrect behavior on affected SKUs.

- Scope and risk
  - Minimal, contained change:
    - Only modifies the workaround tables in
      `drivers/gpu/drm/xe/xe_wa.c`.
    - Uses `XE_RTP_RULES(...,
      FUNC(xe_rtp_match_first_render_or_compute))` so it programs once
      per GT via the first render/compute engine, consistent with
      neighboring WAs.
    - The write is masked (`XE_REG_OPTION_MASKED`) to set only the
      intended bit, per `drivers/gpu/drm/xe/regs/xe_gt_regs.h:494-497`.
  - Consistency with existing code:
    - The same register (`TDL_TSL_CHICKEN`) is already used for other
      WAs on Xe2/Xe3 (e.g., `STK_ID_RESTRICT` at
      `drivers/gpu/drm/xe/xe_wa.c:600-604`), so combining bits in that
      register is expected.
    - Extending the existing Xe3 WA to include `GRAPHICS_VERSION(3003)`
      matches how other XE3 WAs are handled (see
      `drivers/gpu/drm/xe/xe_wa.c:660-663` for other 3003-specific
      entries).
  - No architectural changes, no user-visible API changes, and no cross-
    subsystem impact.

- Stable criteria
  - Fixes a hardware erratum affecting real users on supported hardware.
  - Very small and straightforward: a few table entries and one rule
    expansion.
  - Already precedent in stable: the original addition of WA 13012615864
    for Xe3 (`3000–3001`) has been queued and carried in stable (e.g.,
    6.14.5 stable queue), indicating stable acceptability for this WA
    pattern.
  - Harmless on trees lacking those hardware IDs: the rules are version-
    gated and do nothing if the platform doesn’t match.

Given the above, this commit is a low-risk, targeted bugfix that aligns
with stable backport rules and should be backported.

 drivers/gpu/drm/xe/xe_wa.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/xe/xe_wa.c b/drivers/gpu/drm/xe/xe_wa.c
index 22a98600fd8f2..535067e7fb0c9 100644
--- a/drivers/gpu/drm/xe/xe_wa.c
+++ b/drivers/gpu/drm/xe/xe_wa.c
@@ -538,6 +538,11 @@ static const struct xe_rtp_entry_sr engine_was[] = {
 	  XE_RTP_RULES(GRAPHICS_VERSION(2004), ENGINE_CLASS(RENDER)),
 	  XE_RTP_ACTIONS(SET(HALF_SLICE_CHICKEN7, CLEAR_OPTIMIZATION_DISABLE))
 	},
+	{ XE_RTP_NAME("13012615864"),
+	  XE_RTP_RULES(GRAPHICS_VERSION(2004),
+		       FUNC(xe_rtp_match_first_render_or_compute)),
+	  XE_RTP_ACTIONS(SET(TDL_TSL_CHICKEN, RES_CHK_SPR_DIS))
+	},
 
 	/* Xe2_HPG */
 
@@ -602,6 +607,11 @@ static const struct xe_rtp_entry_sr engine_was[] = {
 		       FUNC(xe_rtp_match_first_render_or_compute)),
 	  XE_RTP_ACTIONS(SET(TDL_TSL_CHICKEN, STK_ID_RESTRICT))
 	},
+	{ XE_RTP_NAME("13012615864"),
+	  XE_RTP_RULES(GRAPHICS_VERSION_RANGE(2001, 2002),
+		       FUNC(xe_rtp_match_first_render_or_compute)),
+	  XE_RTP_ACTIONS(SET(TDL_TSL_CHICKEN, RES_CHK_SPR_DIS))
+	},
 
 	/* Xe2_LPM */
 
@@ -647,7 +657,8 @@ static const struct xe_rtp_entry_sr engine_was[] = {
 	  XE_RTP_ACTIONS(SET(TDL_CHICKEN, QID_WAIT_FOR_THREAD_NOT_RUN_DISABLE))
 	},
 	{ XE_RTP_NAME("13012615864"),
-	  XE_RTP_RULES(GRAPHICS_VERSION_RANGE(3000, 3001),
+	  XE_RTP_RULES(GRAPHICS_VERSION_RANGE(3000, 3001), OR,
+		       GRAPHICS_VERSION(3003),
 		       FUNC(xe_rtp_match_first_render_or_compute)),
 	  XE_RTP_ACTIONS(SET(TDL_TSL_CHICKEN, RES_CHK_SPR_DIS))
 	},
-- 
2.51.0

