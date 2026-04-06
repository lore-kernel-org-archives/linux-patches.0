Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCAE42F4A0C;
	Mon,  6 Apr 2026 11:05:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775473555; cv=none; b=fAZccmEZsCl7n54C8kdXAdseviv47l5IagVuIS7kP2WLGazlDVBsyX5upUGZmHtb+V4qwA1fPYjKw1IrgleC5cV6Q+HNggOZL7dZwbLmbFrsM30nDgTKgzmIgl5Hfimp1L06143TGPgS/SLXi8DH53j+jvE1+PyvzW7TAGHPgD8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775473555; c=relaxed/simple;
	bh=DI0+2pf03WqTpWqXRGDD2n+M+lPYBV1bo6MusWrHkpA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=DkSjFKpV77LYIs5b+VEEL4ooC8Z+ORWB/P643IYuMzEXLOA7TPMhzqJ4Kcs9R6JAa6O+s+Ja9iJkpXBsPH7cTO5tnngQE26ZlzYzHBpRcMbUF9OYKOy/eOeRrkcYBTfUfHDCQDa2nVhqdTAsTFuXKDOSkzRwUrAJrQinziMiFkw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Kimfpu4q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Kimfpu4q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A52EC4CEF7;
	Mon,  6 Apr 2026 11:05:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775473555;
	bh=DI0+2pf03WqTpWqXRGDD2n+M+lPYBV1bo6MusWrHkpA=;
	h=From:To:Cc:Subject:Date:From;
	b=Kimfpu4qW0rFF7re/YvsScbmAqYShNxVpLk8VhfsQ8NxBvQ+5FQoHXfdAnTXCTFzN
	 cR7nAjtcbJ4nls5jaZEsSeCeJNvjdghGPAutS81wEqi056lC6owfDBtx+IEFMOy6yu
	 Ef5uD7cokDHj8uxTB/30RyFqHUbYG2lFrMPRwAJoFr0bq0kDDVjrFc7OXwVRlk/MZR
	 AJVArXA4WixcAVHyq/fwRXvdw7A9U/iNdHK4pfRRbItI7c8RmLCVPDSMkDx53BmLCU
	 Ja52d2KKhBUnM8X+LD/P31Gf09IDR2/9isVrWkjmo6gZikFnNki0GT7iQmxdg6tX40
	 zwVDqoOjF3x+w==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: =?UTF-8?q?Gilson=20Marquato=20J=C3=BAnior?= <gilsonmandalogo@hotmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	Vijendar.Mukunda@amd.com,
	lgirdwood@gmail.com,
	perex@perex.cz,
	tiwai@suse.com,
	linux-sound@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.19-6.1] ASoC: amd: yc: Add DMI entry for HP Laptop 15-fc0xxx
Date: Mon,  6 Apr 2026 07:05:35 -0400
Message-ID: <20260406110553.3783076-1-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19.11
Content-Transfer-Encoding: 8bit

From: Gilson Marquato Júnior <gilsonmandalogo@hotmail.com>

[ Upstream commit 8ec017cf31299c4b6287ebe27afe81c986aeef88 ]

The HP Laptop 15-fc0xxx (subsystem ID 0x103c8dc9) has an internal
DMIC connected to the AMD ACP6x audio coprocessor. Add a DMI quirk
entry so the internal microphone is properly detected on this model.

Tested on HP Laptop 15-fc0237ns with Fedora 43 (kernel 6.19.9).

Signed-off-by: Gilson Marquato Júnior <gilsonmandalogo@hotmail.com>
Link: https://patch.msgid.link/20260330-hp-15-fc0xxx-dmic-v2-v1-1-6dd6f53a1917@hotmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Record: The file is extremely actively maintained with a steady stream
of DMI quirk additions — this is exactly the pattern. The author appears
to be a first-time contributor for this specific laptop.

**Step 3.3-3.5:** This is a standalone data-only addition with no
dependencies. It doesn't reference other commits and doesn't require any
prerequisites.

Record: [Standalone, no dependencies, applies cleanly to any tree
containing this file]

## PHASE 4: MAILING LIST (abbreviated — clear-cut case)

The patch was accepted by Mark Brown (ASoC maintainer) and merged. The
Link tag confirms it went through normal review.

Record: [Accepted by subsystem maintainer Mark Brown]

## PHASE 5: CODE SEMANTIC ANALYSIS

The change is purely a data table entry addition. No functions are
modified. The DMI matching infrastructure is well-established kernel
code. The `acp6x_card` driver_data is the same used by all other
entries.

Record: [No code logic changes, data-only table entry]

## PHASE 6: STABLE TREE ANALYSIS

**Step 6.1:** The acp6x-mach.c file and the yc_acp_quirk_table have
existed since the AMD Yellow Carp platform support was added. This file
exists in stable trees.

**Step 6.2:** The patch adds an entry at the beginning of the table,
which may cause minor offset conflicts with other quirk additions, but
the resolution would be trivial.

Record: [File exists in stable trees] [Trivial backport, possible minor
context conflict]

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

- Subsystem: ASoC (ALSA SoC) / AMD audio drivers
- Criticality: IMPORTANT (audio is a key user-facing feature on laptops)
- Maintainer: Mark Brown (well-known, prolific ASoC maintainer) accepted
  the patch

Record: [ASoC/AMD audio] [IMPORTANT — affects laptop users] [Accepted by
maintainer]

## PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1:** Affected users: owners of HP Laptop 15-fc0xxx (specific
hardware model)
**Step 8.2:** Trigger: always — internal mic doesn't work at all without
this entry
**Step 8.3:** Failure mode: no internal microphone on this laptop —
functional hardware is unusable. Severity: MEDIUM-HIGH (audio input
completely broken for this model)
**Step 8.4:**
- Benefit: HIGH — makes internal mic work on a specific HP laptop model
- Risk: VERY LOW — 7-line data table addition, affects only this one
  laptop model, cannot cause regression on any other system

Record: [Benefit: HIGH] [Risk: VERY LOW] [Ratio: strongly favors
backporting]

## PHASE 9: FINAL SYNTHESIS

**Step 9.1: Evidence Summary**
FOR backporting:
- Classic DMI quirk addition (exception category: hardware
  quirk/workaround)
- 7 lines, data-only, zero code logic changes
- Tested on real hardware by the author
- Accepted by ASoC maintainer Mark Brown
- Fixes a real user-facing issue (internal mic not working)
- Identical pattern to dozens of other entries in the same file
- Zero regression risk

AGAINST backporting:
- (None)

**Step 9.2: Stable Rules Checklist**
1. Obviously correct and tested? **YES** — tested on hardware, trivial
   data addition
2. Fixes a real bug? **YES** — internal mic not detected
3. Important issue? **YES** — hardware not functional without it
4. Small and contained? **YES** — 7 lines in one file
5. No new features/APIs? **YES** — just enables existing driver for new
   hardware
6. Can apply to stable? **YES** — trivial apply

**Step 9.3: Exception Category**
This is a **hardware quirk/workaround** (DMI match table entry) — an
automatic YES category.

## Verification
- [Phase 1] Parsed commit message: DMI quirk for HP Laptop 15-fc0xxx
  internal DMIC
- [Phase 2] Diff: +7 lines, data-only addition to yc_acp_quirk_table[],
  identical pattern to existing entries
- [Phase 3] git log: file has 15+ recent commits all adding similar DMI
  quirk entries
- [Phase 3] Standalone commit, no dependencies
- [Phase 7] Mark Brown (ASoC maintainer) accepted the patch
- [Phase 8] Risk: zero regression risk, data-only change affecting one
  laptop model
- [Phase 9] Falls into hardware quirk exception category

**YES**

 sound/soc/amd/yc/acp6x-mach.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/sound/soc/amd/yc/acp6x-mach.c b/sound/soc/amd/yc/acp6x-mach.c
index 1324543b42d72..97652ab73ea95 100644
--- a/sound/soc/amd/yc/acp6x-mach.c
+++ b/sound/soc/amd/yc/acp6x-mach.c
@@ -45,6 +45,13 @@ static struct snd_soc_card acp6x_card = {
 };
 
 static const struct dmi_system_id yc_acp_quirk_table[] = {
+	{
+		.driver_data = &acp6x_card,
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "HP"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "HP Laptop 15-fc0xxx"),
+		}
+	},
 	{
 		.driver_data = &acp6x_card,
 		.matches = {
-- 
2.53.0

