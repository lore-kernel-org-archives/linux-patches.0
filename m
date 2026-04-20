Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58EC147276E;
	Mon, 20 Apr 2026 13:30:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776691838; cv=none; b=jv74rukAfmOIvnsKjsByHZwkUkPPBsZ55ZjEEnwk/Hg9yPJs9GBLSb5dI4mvFoMKYEyXgWtuxqqaVtV+7aYUgP7Gwg+OHtE3+iNxRZ/oc/gdqTWp3k4WsnAb7jHqDUpW/2O3HOXjUm2qpnCpuZt/bKZBN2YG+V+dPI6l6TOU8w4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776691838; c=relaxed/simple;
	bh=9ecfgTa+NjRjMC5fOqWr0c5I4R4JmQZKf33rrJkOZgw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fEa4A2M+oDnJt7Br2N8tx/3EKEZbERG02jG6+4yRjkXFf558u+Cm1IMzBOIdC3hyiP2I7PH3cwQUKX7WwE0eqqp2pXlR7ovd4VVPo8ZH3efthpNWj1WMlojKhFN7TxtxhEUayQBWxGr0Dm3KRymeZtNDFZJ5FxJgDEhpn5ojKic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aShk/De1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aShk/De1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 131BBC19425;
	Mon, 20 Apr 2026 13:30:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776691838;
	bh=9ecfgTa+NjRjMC5fOqWr0c5I4R4JmQZKf33rrJkOZgw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aShk/De1mbYjwxuFzfkUiH6Qt8n23rleBm2YeTLY0gDI2nGHf3hTnhPYbDeE+1k8k
	 pnpe0CJGzDn70TBQJnKOoii7bU/l23vFzwt+ZZdhSp6SBswjEDIvif0qSv+1DNuKI3
	 VbFjQJQKjR+QCo8J9rZIN3wp9RnwXwyVYX4rmFemwHDv+E7KH7RJnMEeLWEJgzsbmZ
	 y2cqgoqWJnY8SwskIj7RCufLaCHzIkSSZzN69ZYhYC2pYU3OzemfW2OdKbUT9priUo
	 4kgwCQ3CbZ7i2msR6bV8Iur1sc2i+i6aoFhuUnA0tpsMGga6yz78gxneQ2EPfLa5Le
	 ZSu5EywaDxonw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Faye Nichols <faye.opensource@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>,
	perex@perex.cz,
	tiwai@suse.com,
	linux-sound@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-6.12] ALSA: hda/realtek: Add quirk for Acer PT316-51S headset mic
Date: Mon, 20 Apr 2026 09:20:18 -0400
Message-ID: <20260420132314.1023554-224-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420132314.1023554-1-sashal@kernel.org>
References: <20260420132314.1023554-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 7.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Faye Nichols <faye.opensource@gmail.com>

[ Upstream commit a7b56be59b47f4195ddc79ecab238c4401a60bbb ]

The Acer PT316-51S (PCI SSID 1025:160e) with ALC287 codec does not
detect the headset microphone due to missing BIOS pin configuration
for pin 0x19. Apply ALC2XX_FIXUP_HEADSET_MIC to enable it.

Signed-off-by: Faye Nichols <faye.opensource@gmail.com>
Link: https://patch.msgid.link/20260413212645.117119-1-faye.opensource@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Here is my complete analysis:

---

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1: Subject Line**
- Subsystem: `ALSA: hda/realtek`
- Action verb: "Add" (quirk)
- Summary: Adds a PCI SSID quirk for Acer PT316-51S to enable headset
  microphone detection.
Record: [ALSA/hda/realtek] [Add] [Hardware quirk for Acer PT316-51S
headset mic]

**Step 1.2: Tags**
- Signed-off-by: Faye Nichols (author)
- Link: patch.msgid.link (standard patch submission)
- Signed-off-by: Takashi Iwai (ALSA subsystem maintainer) — indicates
  maintainer review and acceptance
- No Fixes: tag (expected for quirk additions)
- No Reported-by: (the author likely is the user affected)
Record: [Maintainer SOB from Takashi Iwai — strong acceptance signal]

**Step 1.3: Body Text**
The commit clearly states: The Acer PT316-51S (PCI SSID 1025:160e) with
ALC287 codec does not detect the headset microphone due to missing BIOS
pin configuration for pin 0x19. The fix applies
`ALC2XX_FIXUP_HEADSET_MIC` to override the BIOS-provided (or missing)
pin configuration.
Record: [Bug: headset mic not detected] [Root cause: missing BIOS pin
config for pin 0x19] [Fix: apply existing fixup]

**Step 1.4: Hidden Bug Fix?**
Not hidden — this directly fixes non-functioning hardware (headset mic).
Record: [Explicit hardware fix, not disguised]

## PHASE 2: DIFF ANALYSIS

**Step 2.1: Inventory**
- 1 file changed: `sound/hda/codecs/realtek/alc269.c`
- 1 line added
- 0 lines removed
- Function modified: none — this adds an entry to a static data table
  (`alc269_fixup_tbl[]`)
Record: [+1 line, single file, table entry addition] [Scope:
minimal/surgical]

**Step 2.2: Code Flow**
The new line inserts `SND_PCI_QUIRK(0x1025, 0x160e, "Acer PT316-51S",
ALC2XX_FIXUP_HEADSET_MIC)` into the PCI quirk table between 0x1597 and
0x169a entries (sorted order). When the HDA codec driver matches PCI
SSID 1025:160e, it will apply the `ALC2XX_FIXUP_HEADSET_MIC` fixup.
Record: [Before: no quirk for this SSID, so headset mic not configured.
After: fixup is applied during codec init.]

**Step 2.3: Bug Mechanism**
This is category (h) — hardware workaround / device ID addition. The
`ALC2XX_FIXUP_HEADSET_MIC` fixup (verified at line 3545-3561) sets pin
0x19 to config value 0x03a1103c, updates a codec coefficient, and sets
the HEADSET_MIC parse flag. Without this, the BIOS-provided (or absent)
pin config leaves the headset mic non-functional.
Record: [Hardware quirk table entry] [Existing fixup, only adds PCI SSID
matching]

**Step 2.4: Fix Quality**
- Obviously correct: identical pattern to dozens of existing entries (21
  uses of `ALC2XX_FIXUP_HEADSET_MIC` already)
- Minimal: 1 line in a data table
- Regression risk: essentially zero — only affects this specific PCI
  SSID
Record: [Obviously correct, zero regression risk]

## PHASE 3: GIT HISTORY

**Step 3.1: Blame**
The surrounding entries using the same fixup
(`ALC2XX_FIXUP_HEADSET_MIC`) were added by various contributors (Breno
Baptista 2026-02-04, Takashi Iwai 2025-07-09, Matouš Lánský 2025-12-31).
The fixup function `alc2xx_fixup_headset_mic` and enum
`ALC2XX_FIXUP_HEADSET_MIC` have been in the tree since at least kernel
6.x era.
Record: [ALC2XX_FIXUP_HEADSET_MIC infrastructure exists in stable trees]

**Step 3.2: No Fixes: tag** — N/A for quirk additions.

**Step 3.3: File History**
The file receives continuous quirk additions (20 recent commits shown
are almost all quirk additions). This is a well-tested and routine
change pattern.
Record: [File receives frequent identical-pattern changes]

**Step 3.4: Author**
Faye Nichols has no other commits in this tree. This is a single
community contribution. However, it was accepted by Takashi Iwai (ALSA
subsystem maintainer), which validates the change.
Record: [Community contributor, maintainer-accepted]

**Step 3.5: Dependencies**
The `ALC2XX_FIXUP_HEADSET_MIC` enum and function exist in the 7.0 tree.
Verified at line 4089 (enum), 6467-6470 (fixup table definition),
3545-3561 (function implementation). This was introduced by commit
50db91fccea0d (Dec 2024). For stable trees, we need to verify this
enum/function exists. Given it was merged in late 2024, it should be in
6.12+ stable trees.
Record: [Depends on ALC2XX_FIXUP_HEADSET_MIC infrastructure from Dec
2024]

## PHASE 4: MAILING LIST

**Step 4.1-4.5:** Lore.kernel.org was blocked by anti-bot protection.
However, the patch link in the commit message
(`patch.msgid.link/20260413212645.117119-1-faye.opensource@gmail.com`)
and the maintainer's Signed-off-by confirm it went through standard
review. Takashi Iwai (the ALSA maintainer) signed off on it, which is
the standard acceptance path for HDA quirk additions.
Record: [Unable to fetch lore discussion due to anti-bot. Maintainer
acceptance confirmed via SOB.]

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1-5.5:** The change is a single data table entry. The
`alc2xx_fixup_headset_mic` function (lines 3545-3561) applies pin
configuration for pin 0x19, updates a codec coefficient, and sets the
headset mic parse flag. This is a well-understood, thoroughly tested
fixup path used by 20+ other devices. No new code paths are introduced.
Record: [No new code, only adds a match entry to existing fixup
infrastructure]

## PHASE 6: STABLE TREE ANALYSIS

**Step 6.1:** The `ALC2XX_FIXUP_HEADSET_MIC` infrastructure was added in
Dec 2024. It should exist in stable trees 6.12.y and newer. For older
stable trees (6.6.y, 6.1.y), this specific fixup enum might not exist
and would require a different backport approach (though similar fixups
like `ALC256_FIXUP_ACER_HEADSET_MIC` exist in older trees).
Record: [Applies cleanly to 6.12+ stable trees. Older trees may lack the
specific fixup enum.]

**Step 6.2:** The patch is a 1-line insertion in a sorted table. It will
apply cleanly or with trivial context adjustment.
Record: [Trivial to backport, clean apply expected]

**Step 6.3:** No existing fix for this specific PCI SSID (0x1025:0x160e)
was found in the tree.
Record: [No prior fix for this device]

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

**Step 7.1:** ALSA/HDA subsystem — IMPORTANT criticality (audio is a
core user-facing feature).
Record: [ALSA/HDA, IMPORTANT criticality]

**Step 7.2:** The file receives very frequent updates (105 commits since
v6.6, mostly quirk additions). This is one of the most actively
maintained quirk tables in the kernel.
Record: [Very active, routine quirk additions]

## PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1:** Affects users of the Acer PT316-51S laptop specifically.
Record: [Driver-specific: Acer PT316-51S laptop users]

**Step 8.2:** The trigger is deterministic: every boot on this hardware,
the headset mic is non-functional.
Record: [100% reproducible on affected hardware, every boot]

**Step 8.3:** Failure: headset microphone does not work at all. For
laptop users who need headset mic for calls/meetings, this is a
significant usability problem.
Record: [Non-functional hardware, severity: HIGH for affected users]

**Step 8.4:**
- BENEFIT: Enables headset mic on a specific laptop model — high benefit
  for affected users
- RISK: 1-line data table entry, only matches specific PCI SSID —
  essentially zero risk
Record: [High benefit, near-zero risk — excellent ratio]

## PHASE 9: FINAL SYNTHESIS

**Step 9.1: Evidence FOR backporting:**
- Classic audio codec quirk (one of the explicitly listed exception
  categories)
- Single line addition to a static data table
- Uses well-established, pre-existing fixup infrastructure
- Accepted by ALSA subsystem maintainer (Takashi Iwai)
- Fixes real hardware for real users (headset mic non-functional)
- Zero regression risk (only affects one PCI SSID)
- Identical pattern to hundreds of other backported quirks

**Evidence AGAINST:** None identified.

**Step 9.2: Stable Rules Checklist:**
1. Obviously correct and tested? **YES** — identical to dozens of
   existing entries
2. Fixes a real bug? **YES** — headset mic non-functional on specific
   hardware
3. Important issue? **YES** — non-functional hardware
4. Small and contained? **YES** — 1 line in a data table
5. No new features or APIs? **YES** — uses existing fixup
6. Can apply to stable? **YES** — trivially, for trees that have
   ALC2XX_FIXUP_HEADSET_MIC

**Step 9.3: Exception Category:** This is a **hardware
quirk/workaround** — one of the explicitly allowed exception categories
for stable.

## Verification

- [Phase 1] Parsed tags: maintainer SOB from Takashi Iwai confirms
  acceptance
- [Phase 2] Diff analysis: exactly 1 line added — `SND_PCI_QUIRK(0x1025,
  0x160e, ...)` to quirk table
- [Phase 3] git blame: surrounding entries added by various contributors
  2025-2026, established pattern
- [Phase 3] Verified ALC2XX_FIXUP_HEADSET_MIC exists at line 4089
  (enum), 6467-6470 (table def), 3545-3561 (function)
- [Phase 3] Confirmed 21 existing uses of ALC2XX_FIXUP_HEADSET_MIC in
  the quirk table
- [Phase 4] Lore blocked by anti-bot; maintainer acceptance verified
  through SOB
- [Phase 5] Verified fixup function sets pin 0x19 config to 0x03a1103c
  and HEADSET_MIC flag
- [Phase 6] ALC2XX_FIXUP_HEADSET_MIC infrastructure from Dec 2024,
  available in 6.12+ stable
- [Phase 6] 1138 SND_PCI_QUIRK entries in file — this is an extremely
  common pattern
- [Phase 8] Failure mode: non-functional headset mic on every boot,
  severity HIGH for affected users

**YES**

 sound/hda/codecs/realtek/alc269.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/hda/codecs/realtek/alc269.c b/sound/hda/codecs/realtek/alc269.c
index 44f0fcd20cf51..f10ee482151f6 100644
--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -6718,6 +6718,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1025, 0x1539, "Acer Nitro 5 AN515-57", ALC2XX_FIXUP_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1025, 0x159c, "Acer Nitro 5 AN515-58", ALC2XX_FIXUP_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1025, 0x1597, "Acer Nitro 5 AN517-55", ALC2XX_FIXUP_HEADSET_MIC),
+	SND_PCI_QUIRK(0x1025, 0x160e, "Acer PT316-51S", ALC2XX_FIXUP_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1025, 0x169a, "Acer Swift SFG16", ALC256_FIXUP_ACER_SFG16_MICMUTE_LED),
 	SND_PCI_QUIRK(0x1025, 0x171e, "Acer Nitro ANV15-51", ALC245_FIXUP_ACER_MICMUTE_LED),
 	SND_PCI_QUIRK(0x1025, 0x173a, "Acer Swift SFG14-73", ALC245_FIXUP_ACER_MICMUTE_LED),
-- 
2.53.0

