Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAB5C30C368;
	Sat, 25 Oct 2025 16:18:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761409125; cv=none; b=Kywe8XvL7aWExdcvGEtSH0RzNBZD//S8SZSFNMSjnPDBQUrXSK1LZq6IzdXaFMgfzKZHbMCqSt3rNJRAo+oIWU/Us5sSie3V6E30MC2jtIv39DELUzT14YdTCUIzxGzZ4uKTKQ566+eLj96caJgCMMUSZtG2/hSmG33IliEYA+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761409125; c=relaxed/simple;
	bh=jjD1PPvWPe3Vv0Xp6VI8aKAVwDabIOOJKED3onR5kdA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fHWxFiWPKvtuY31bOQKgfHIxWh7apFD62byeENCgxDv89JC9Az2eURusyI28VNDVEJxGOxxmPNy3OVhUpZSUVyZ++hf2zMMwboYCLW4oTxs/Yqioj/RUYLvp4abk8S5OmmGPv5Uf77wLvjgPc6bCLBQ6YFdzzN4Z3buj5J64oE4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HULn7hNq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HULn7hNq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A10D1C4CEFB;
	Sat, 25 Oct 2025 16:18:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761409125;
	bh=jjD1PPvWPe3Vv0Xp6VI8aKAVwDabIOOJKED3onR5kdA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HULn7hNqNhjx8QADCBfF/R6dweCyh1ylt7B4XEAwD8rgTgECZdFAV4SUxa9WULJvj
	 kj3yV3BETAZKkZFmFU+LHus6BoDaKzT58vJVT1jjXuJHbpq7hLldYQ0RGNjy4C+Lit
	 oxc/ieQt6mb77pE4A4kMIjfTNBwFT0bV/pJt5mfnAN3qfWw5CJu88tJ4P+1EOJARyR
	 g1LvlcnvuLre8XCJOsPmUAMkvYebARMo9W6sDVxC/QJepPvdGutfUOyoFL3yTSg8oz
	 6nr4WzdySW3ofcLjvAz1chjJxFlYd7ZR3Ax79s9bi5kmCcViMizKh77BWZgkbwDAbh
	 eHK8pflO/QXnw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Chaitanya Kumar Borah <chaitanya.kumar.borah@intel.com>,
	Dnyaneshwar Bhadane <dnyaneshwar.bhadane@intel.com>,
	Gustavo Sousa <gustavo.sousa@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	lucas.demarchi@intel.com,
	thomas.hellstrom@linux.intel.com,
	rodrigo.vivi@intel.com,
	intel-xe@lists.freedesktop.org
Subject: [PATCH AUTOSEL 6.17] drm/xe/wcl: Extend L3bank mask workaround
Date: Sat, 25 Oct 2025 11:57:20 -0400
Message-ID: <20251025160905.3857885-209-sashal@kernel.org>
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

From: Chaitanya Kumar Borah <chaitanya.kumar.borah@intel.com>

[ Upstream commit d738e1be2b2b4364403babc43ae7343d45e99d41 ]

The commit 9ab440a9d042 ("drm/xe/ptl: L3bank mask is not
available on the media GT") added a workaround to ignore
the fuse register that L3 bank availability as it did not
contain valid values. Same is true for WCL therefore extend
the workaround to cover it.

Signed-off-by: Chaitanya Kumar Borah <chaitanya.kumar.borah@intel.com>
Reviewed-by: Dnyaneshwar Bhadane <dnyaneshwar.bhadane@intel.com>
Link: https://lore.kernel.org/r/20250822002512.1129144-1-chaitanya.kumar.borah@intel.com
Signed-off-by: Gustavo Sousa <gustavo.sousa@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES

- What changed
  - The single-line rule in `drivers/gpu/drm/xe/xe_wa_oob.rules` is
    widened from `MEDIA_VERSION(3000)` to `MEDIA_VERSION_RANGE(3000,
    3002)` for the `no_media_l3` workaround. This extends the existing
    workaround to WCL media GT variants in the same Xe3 generation, not
    just the initial 3000 stepping.

- What it fixes
  - Prior work (commit 9ab440a9d042 cited in the message) established
    that the L3 bank-availability fuse register on the media GT can
    return invalid data; the fix was to ignore/suppress using that
    information on the affected platform. The new change says WCL shares
    the same problem and applies the same workaround there.
  - The Xe driver already treats L3 bank mask reporting on media GT as
    optional when it cannot be trusted: see the guard used in topology
    reporting (“L3bank mask may not be available for some GTs”) in
    `drivers/gpu/drm/xe/xe_query.c:480`, and the policy to omit media GT
    L3 mask on Xe3+ in `drivers/gpu/drm/xe/xe_gt_topology.c:126`
    (function comments explaining no known userspace needs the media L3
    mask and that hardware reports bogus values on some platforms) and
    the early return gating in the L3 loader path at
    `drivers/gpu/drm/xe/xe_gt_topology.c:148`. Extending the rule
    ensures the workaround applies consistently across all relevant Xe3
    media GT steppings (3000–3002), eliminating cases where bogus L3
    bank masks could leak to userspace or influence internal logic.

- Risk assessment
  - Scope: One rule-file condition change; no code paths, interfaces, or
    architectures are altered. Constrained to the Xe DRM driver’s WA
    matching.
  - Behavior: Only broadens an existing workaround to additional but
    closely-related hardware versions. On those versions, it suppresses
    using a known-bogus register; otherwise behavior is unchanged.
  - Userspace compatibility: Comments explicitly note no known userspace
    depends on media GT L3 bank mask being present on these platforms
    (`drivers/gpu/drm/xe/xe_gt_topology.c:126`). Hiding it avoids
    reporting incorrect data and is preferable to exposing a wrong mask
    (`drivers/gpu/drm/xe/xe_query.c:480`).

- Stable backport criteria
  - Bug fix that affects users: Yes—prevents invalid L3 bank mask data
    on additional media GT steppings.
  - Small and contained: Yes—one-line rule adjustment in
    `drivers/gpu/drm/xe/xe_wa_oob.rules`.
  - Architectural change: No.
  - Critical subsystem risk: Low; isolated to the Xe driver’s WA
    selection.
  - Side effects: Minimal; only suppresses untrustworthy data reporting
    on the affected versions.
  - Commit message clarity: References the prior fix and clearly states
    extension to WCL.

Given the minimal, targeted nature of the change and its role in
preventing incorrect hardware information from being used/reported, this
is a strong candidate for stable backport.

 drivers/gpu/drm/xe/xe_wa_oob.rules | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/xe/xe_wa_oob.rules b/drivers/gpu/drm/xe/xe_wa_oob.rules
index 48c7a42e2fcad..382719ac4a779 100644
--- a/drivers/gpu/drm/xe/xe_wa_oob.rules
+++ b/drivers/gpu/drm/xe/xe_wa_oob.rules
@@ -47,7 +47,7 @@
 16023588340	GRAPHICS_VERSION(2001), FUNC(xe_rtp_match_not_sriov_vf)
 14019789679	GRAPHICS_VERSION(1255)
 		GRAPHICS_VERSION_RANGE(1270, 2004)
-no_media_l3	MEDIA_VERSION(3000)
+no_media_l3	MEDIA_VERSION_RANGE(3000, 3002)
 14022866841	GRAPHICS_VERSION(3000), GRAPHICS_STEP(A0, B0)
 		MEDIA_VERSION(3000), MEDIA_STEP(A0, B0)
 16021333562	GRAPHICS_VERSION_RANGE(1200, 1274)
-- 
2.51.0

