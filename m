Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 994B12FF168;
	Sat, 25 Oct 2025 16:14:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761408891; cv=none; b=d+7jtipir+VqjlZZXROBijfipbFERsZvqDwcRFvrr8Le2K2B0Uoq+Q2TVPaLl49KqHVtYJsdJikZjYxNpLCle1ddl6TyU2wEpdSd5/T2ntULztrxE1axjTv+1dKIDhqV/HMNrY5CYVb6B1MeVoKiiCuJ5BwisjjKetFMQo1pCTY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761408891; c=relaxed/simple;
	bh=o4h+IJZ3yueYChJvQ8+3UTbkMcoXNGMPA4CzIMmhnCA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FhHhWtO8mdtp4Z+vmAxW7H6zrTw7BExQVvEgSBn+wcQNxcHBed9LzoN6Vi4uucS2MjJDcMlzsP5xpoEGqkH8XxdKyx5yLldFSRBo2Lypxp4dqvuHI5j3R55BdGNFjd03wfopC0Wum9JfLoXhDDtAWJH9wv48JIosw5xkRv9o88U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MgCn02ND; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MgCn02ND"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9D48C4CEFB;
	Sat, 25 Oct 2025 16:14:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761408891;
	bh=o4h+IJZ3yueYChJvQ8+3UTbkMcoXNGMPA4CzIMmhnCA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MgCn02NDvpPHGZ3t1zTWPM3VGatilIwdOdAFRQMjjSwWtq+gfe+njG4F8CNlYKibX
	 +eBHyOp3ZznqD6iQj5XW2h41F/Mqilit6np/sOCfLmN3kQVwYkHrxyQWB+n8noIVCf
	 YHbLd5TE/ErD9P3atT0LFDJ4KGtkgnhNrVq0yBidsP2/0u0JfV8iMH9A9ODKKziJyD
	 LYGQUn0JiKDlk+eQvFhKapNVfVN+uknnI1dOCuWih/1ILaneuLMzCV8W2mlvb0/bjm
	 aCgclnXZCWhO2ahUNd97JR9bR48O5KZfRyoaMI5GO71ZxGthGBoMj+36QewoG0xEgf
	 dhcBVcyKe+65w==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Antheas Kapenekakis <lkml@antheas.dev>,
	=?UTF-8?q?Philip=20M=C3=BCller?= <philm@manjaro.org>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	maarten.lankhorst@linux.intel.com,
	mripard@kernel.org,
	tzimmermann@suse.de
Subject: [PATCH AUTOSEL 6.17-6.12] drm: panel-backlight-quirks: Make EDID match optional
Date: Sat, 25 Oct 2025 11:55:47 -0400
Message-ID: <20251025160905.3857885-116-sashal@kernel.org>
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

From: Antheas Kapenekakis <lkml@antheas.dev>

[ Upstream commit 9931e4be11f2129a20ffd908bc364598a63016f8 ]

Currently, having a valid panel_id match is required to use the quirk
system. For certain devices, we know that all SKUs need a certain quirk.
Therefore, allow not specifying ident by only checking for a match
if panel_id is non-zero.

Tested-by: Philip Müller <philm@manjaro.org>
Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Antheas Kapenekakis <lkml@antheas.dev>
Link: https://lore.kernel.org/r/20250829145541.512671-2-lkml@antheas.dev
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Mario Limonciello (AMD) <superm1@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES

- What changed: In drivers/gpu/drm/drm_panel_backlight_quirks.c, the
  match helper was relaxed to make the EDID check optional:
  - Before: drm_panel_min_backlight_quirk_matches() unconditionally
    required an EDID identity match and returned false if
    drm_edid_match() failed.
    - Code: drivers/gpu/drm/drm_panel_backlight_quirks.c, function
      drm_panel_min_backlight_quirk_matches, the line was:
      - if (!drm_edid_match(edid, &quirk->ident)) return false;
  - After: The EDID check is performed only if the quirk’s EDID identity
    contains a non-zero panel_id:
    - Code: drivers/gpu/drm/drm_panel_backlight_quirks.c, function
      drm_panel_min_backlight_quirk_matches:
      - if (quirk->ident.panel_id && !drm_edid_match(edid,
        &quirk->ident)) return false;

- Why this matters (bug it addresses): Previously, even when the
  platform (DMI) uniquely and reliably identifies devices that need a
  backlight quirk “across all SKUs,” the quirk would not apply unless
  the EDID identity also matched. For platforms where the quirk should
  apply regardless of panel EDID (e.g., multiple panel variants shipping
  under the same system SKU, or unreliable EDID), this produced a false
  negative and the quirk was never applied. This can cause user-visible
  issues such as unusable minimum brightness, flicker, or a too-dark
  panel at low settings.

- Scope and risk:
  - Localized change: A single conditional in the matching helper; no
    API/ABI change. All existing quirks that specify a valid EDID
    panel_id keep the same behavior. Only quirks that intentionally set
    ident.panel_id = 0 now match on DMI alone.
  - Dependencies: The helper still requires DMI to match (via
    dmi_match), and only skips the EDID check when ident.panel_id is
    zero, so the chance of accidental overmatching is low. The EDID
    match itself remains strict when requested (drm_edid_match compares
    the computed panel_id and, if provided, the panel name).
  - Callers/usage: The result is consumed to adjust backlight behavior
    (e.g., min_brightness or brightness_mask) by drivers like AMDGPU on
    eDP connectors (see
    drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c:3692 calling
    drm_get_panel_backlight_quirk). The change therefore directly
    impacts user experience in a constrained and intended way.

- Stable policy fit:
  - Fixes a real user-visible problem (quirks not applying where they
    should).
  - Minimal, contained change (one conditional).
  - No architectural changes or new features; it only enables proper use
    of the existing quirk mechanism for platforms known to require it.
  - Low regression risk: Existing EDID-specific quirks remain
    unaffected; only explicitly EDID-agnostic entries (ident.panel_id =
    0) are enabled.

- Practical note: On its own, this change is largely inert unless there
  are DMI-only quirk entries (with ident.panel_id unset) in the stable
  branch’s quirk table. It is best paired with the corresponding quirk
  entries that rely on this behavior. Nonetheless, backporting this
  enabling fix is safe and prepares stable trees to accept those entries
  cleanly.

 drivers/gpu/drm/drm_panel_backlight_quirks.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/drm_panel_backlight_quirks.c b/drivers/gpu/drm/drm_panel_backlight_quirks.c
index 598f812b7cb38..b38b33e26ea5c 100644
--- a/drivers/gpu/drm/drm_panel_backlight_quirks.c
+++ b/drivers/gpu/drm/drm_panel_backlight_quirks.c
@@ -50,7 +50,7 @@ static bool drm_panel_min_backlight_quirk_matches(const struct drm_panel_min_bac
 	if (!dmi_match(quirk->dmi_match.field, quirk->dmi_match.value))
 		return false;
 
-	if (!drm_edid_match(edid, &quirk->ident))
+	if (quirk->ident.panel_id && !drm_edid_match(edid, &quirk->ident))
 		return false;
 
 	return true;
-- 
2.51.0

