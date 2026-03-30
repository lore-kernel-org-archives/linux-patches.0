Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8CD33D3314;
	Mon, 30 Mar 2026 12:39:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774874348; cv=none; b=N7PfWgznCoszbz1U1bfyyeXk8HASV+yOdON7AtUtxJ0YWwpaIj51G5jyvnYq9UVXlt8TwrfagvT3C9ehIXIeHzKaf3AICQSYQfXoybfoHnWdZs9f6N0PMx/Ayeb5htMhBTbkmJpaCHZMcQAxaLk6kGfZZQSQRhKy+ZY6MQr2asU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774874348; c=relaxed/simple;
	bh=5wSSKEMIzIul31wUqPnRKJrbRSOh/Pgt2eb8JsZVyxo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gbfOoHq9w/3iFLby8WRY8cdOZu9ZUs0P53EGX4IRroxPmYYRzQdEEUuqR4ru8XIcGXDCQ7Iu+IHroHv2WlBbDeyFKNN+jszo6wjiJ3ghZnWMpH+Zua72ly8mqtysHS3akDygQyXH+cxU+imzQ+djQtSSpNPiesZXUTm724W5jmw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ma14zB0s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ma14zB0s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA66FC2BCB0;
	Mon, 30 Mar 2026 12:39:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774874348;
	bh=5wSSKEMIzIul31wUqPnRKJrbRSOh/Pgt2eb8JsZVyxo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ma14zB0s7+jkqnU5ccykj/BIbsauhPl0s00HGHBA9M7tvVepS8ncgKdYIkUI4jj7Y
	 vlutPU5v26YwFZEMOaDxStgXehcsfr5Qveu8qZZkAYimH3AV67oHDC9MdLI3cnSIKY
	 NnhhjtriuImDhyaZ1R/aTXZ2XJ+ESlrwxDElcJ9p2mcpXuwwpzkOsDGXSzdBKEK4d2
	 mdiWlC4dUxe3zgLlmeA5V7FIoZLcW8ytdcBxXLkpvFeiNBwLnorhgzfXjMJ2d5p0xT
	 sXt0wUChRfNoFXXy79dThjg0h9mQPd5t1BOmfBUpmhPWai7ho8UIWZVlbA6LtvmkVV
	 QDlvOaMxZNE2Q==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: =?UTF-8?q?C=C3=A9sar=20Montoya?= <sprit152009@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>,
	perex@perex.cz,
	tiwai@suse.com,
	linux-sound@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.19-5.10] ALSA: hda/realtek: Add mute LED quirk for HP Pavilion 15-eg0xxx
Date: Mon, 30 Mar 2026 08:38:31 -0400
Message-ID: <20260330123842.756154-18-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260330123842.756154-1-sashal@kernel.org>
References: <20260330123842.756154-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19.10
Content-Transfer-Encoding: 8bit

From: César Montoya <sprit152009@gmail.com>

[ Upstream commit 2f388b4e8fdd6b0f27cafd281658daacfd85807e ]

The HP Pavilion 15-eg0xxx with subsystem ID 0x103c87cb uses a Realtek
ALC287 codec with a mute LED wired to GPIO pin 4 (mask 0x10). The
existing ALC287_FIXUP_HP_GPIO_LED fixup already handles this correctly,
but the subsystem ID was missing from the quirk table.

GPIO pin confirmed via manual hda-verb testing:
  hda-verb SET_GPIO_MASK 0x10
  hda-verb SET_GPIO_DIRECTION 0x10
  hda-verb SET_GPIO_DATA 0x10

Signed-off-by: César Montoya <sprit152009@gmail.com>
Link: https://patch.msgid.link/20260321153603.12771-1-sprit152009@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

All verification is complete. Here is the full analysis.

---

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

**Step 1.1: PARSE THE SUBJECT LINE**
Record: [ALSA: hda/realtek] [Add] [mute LED quirk for HP Pavilion
15-eg0xxx — adds missing PCI subsystem ID to the Realtek ALC287 quirk
table]

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**
Record:
- Signed-off-by: César Montoya `<sprit152009@gmail.com>` — patch author
  / hardware owner
- Link: `https://patch.msgid.link/20260321153603.12771-1-
  sprit152009@gmail.com` — submission link
- Signed-off-by: Takashi Iwai `<tiwai@suse.de>` — ALSA/HDA subsystem
  maintainer (applied the patch)
- No Fixes: tag (expected — quirk additions rarely have one)
- No Reported-by: (author IS the affected user)
- No Cc: stable (absence expected for commits under review)

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**
Record: Bug: HP Pavilion 15-eg0xxx with subsystem ID 0x103c:0x87cb uses
ALC287 codec with mute LED wired to GPIO pin 4 (mask 0x10). The existing
`ALC287_FIXUP_HP_GPIO_LED` fixup already handles this correctly, but the
subsystem ID was missing from the quirk table. Symptom: mute LED does
not function at all. Root cause: missing SSID→fixup mapping. Evidence:
author confirms GPIO pin via manual `hda-verb` testing (SET_GPIO_MASK,
SET_GPIO_DIRECTION, SET_GPIO_DATA with 0x10).

**Step 1.4: DETECT HIDDEN BUG FIXES**
Record: Not a hidden bug fix — this is an explicit hardware quirk
addition (a well-known stable exception category). The "bug" is that
hardware doesn't work without the quirk table entry.

===============================================================
PHASE 2: DIFF ANALYSIS — LINE BY LINE
===============================================================

**Step 2.1: INVENTORY THE CHANGES**
Record: 1 file changed: `sound/hda/codecs/realtek/alc269.c`. +1 line, -0
lines. Function modified: none (data table `alc269_fixup_tbl[]` only).
Scope: single-file, single table row — maximally surgical.

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**
Record: Before: subsystem ID 0x103c:0x87cb is not in
`alc269_fixup_tbl[]`, so the HDA core finds no fixup match during codec
probe, and the mute LED is never configured. After: the new
`SND_PCI_QUIRK(0x103c, 0x87cb, "HP Pavilion 15-eg0xxx",
ALC287_FIXUP_HP_GPIO_LED)` entry causes `snd_hda_pick_fixup()` to match
and apply the GPIO LED fixup during probe.

**Step 2.3: IDENTIFY THE BUG MECHANISM**
Record: Category (h) — hardware workaround / quirk table entry. The
added line is inserted in sorted order between 0x87c8 and 0x87cc (the
latter is the same laptop model name using the same fixup). The fixup
`ALC287_FIXUP_HP_GPIO_LED` is defined at line 5921 and calls
`alc287_fixup_hp_gpio_led()`, which invokes
`alc_fixup_hp_gpio_led(codec, action, 0x10, 0)` — GPIO mask 0x10 exactly
matches the commit message's hda-verb testing.

**Step 2.4: ASSESS THE FIX QUALITY**
Record: Obviously correct — identical pattern to the neighboring 0x87cc
entry for the same laptop model. Regression risk: effectively zero — the
quirk only activates on machines with PCI subsystem ID 0x103c:0x87cb. No
logic, no API, no code flow changes. No red flags.

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

**Step 3.1: BLAME THE CHANGED LINES**
Record: `git blame -L6868,6872` shows:
- Line 6869 (0x87c8): from `aeeb85f26c3bbe` (Takashi Iwai, 2025-07-09) —
  the mass file relocation commit
- Line 6870 (0x87cc): from `7cd3c8cafbc050` (Takashi Iwai, 2025-07-21) —
  merge of `9744ede7099e8` which added the 0x87cc entry
- The 0x87cb line does not exist in this tree (this is the candidate
  commit adding it)

**Step 3.2: FOLLOW THE FIXES: TAG**
Record: N/A — no Fixes: tag. Expected for quirk additions.

**Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**
Record: The related commit `9744ede7099e8` ("ALSA: hda/realtek - Add
mute LED support for HP Pavilion 15-eg0xxx") added the 0x87cc entry for
the same laptop model, was written by a different author (Dawid Rezler),
explicitly carried `Cc: <stable@vger.kernel.org>`, and went into
`sound/pci/hda/patch_realtek.c` (pre-move path). It was tagged
`v6.16~13^2~3`, meaning it entered in v6.16. The current commit adds a
sibling SSID (0x87cb) for the same model. Standalone — no other patches
needed.

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**
Record: César Montoya appears to be an end-user / first-time contributor
fixing their own hardware. Patch was accepted and signed off by Takashi
Iwai (ALSA maintainer), lending strong confidence.

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**
Record: The only prerequisite is `ALC287_FIXUP_HP_GPIO_LED` and its
implementation `alc287_fixup_hp_gpio_led()`. These were introduced long
ago and exist in all active stable trees. No other dependencies. Fully
standalone.

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

**Step 4.1: SEARCH LORE.KERNEL.ORG**
Record: The commit includes a Link to
`patch.msgid.link/20260321153603.12771-1-sprit152009@gmail.com`. The
patch was a single standalone submission (not a series — "12771-1" with
no further parts). Takashi Iwai's Signed-off-by indicates direct
application by the maintainer. No NAKs or objections are evident from
the acceptance.

**Step 4.2: SEARCH FOR BUG REPORT**
Record: No separate bug report — the author is the affected user who
submitted the fix directly, confirmed via hda-verb hardware testing.

**Step 4.3: CHECK FOR RELATED PATCHES AND SERIES**
Record: Standalone single patch. The sibling 0x87cc entry (commit
`9744ede7099e8`) was a separate patch from a different author and
already carried `Cc: stable`.

**Step 4.4: CHECK STABLE MAILING LIST HISTORY**
Record: The sibling commit `9744ede7099e8` for 0x87cc already has `Cc:
stable@vger.kernel.org`, confirming the subsystem maintainer considers
this class of quirk appropriate for stable backporting.

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

**Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF**
Record: No functions modified. Only a data table entry added to
`alc269_fixup_tbl[]`.

**Step 5.2: TRACE CALLERS**
Record: The table is consumed by `snd_hda_pick_fixup()` during Realtek
ALC269-family codec probe. This is a standard, well-tested code path run
once per codec initialization.

**Step 5.3: TRACE CALLEES**
Record: When matched, the fixup definition at line 5921 invokes
`alc287_fixup_hp_gpio_led()` (line 1360), which calls
`alc_fixup_hp_gpio_led(codec, action, 0x10, 0)`. This configures GPIO
pin 4 for the mute LED — a well-tested helper used by many HP models.

**Step 5.4: FOLLOW THE CALL CHAIN**
Record: Codec probe → `snd_hda_pick_fixup()` → table lookup →
`ALC287_FIXUP_HP_GPIO_LED` → `alc287_fixup_hp_gpio_led()` →
`alc_fixup_hp_gpio_led()`. The path is reachable on every boot for users
with this hardware.

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**
Record: `ALC287_FIXUP_HP_GPIO_LED` appears 11 times in the file. At
least 10 other HP models use the identical fixup. This is a massively
replicated, well-tested pattern.

===============================================================
PHASE 6: CROSS-REFERENCING AND STABLE TREE ANALYSIS
===============================================================

**Step 6.1: DOES THE BUGGY CODE EXIST IN STABLE TREES?**
Record: The `ALC287_FIXUP_HP_GPIO_LED` fixup and its implementation have
been in the tree since at least v5.10-era kernels. All active stable
trees (6.1.y, 6.6.y, 6.12.y, etc.) contain the fixup infrastructure. The
only thing missing is this specific SSID table entry.

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**
Record: The file was moved from `sound/pci/hda/patch_realtek.c` to
`sound/hda/codecs/realtek/alc269.c` in commit `6014e9021b28e`
(v6.17-rc1). Stable trees older than 6.17 need the patch applied to the
old path. The table format is identical in both locations. The fix is a
single line addition at a predictable sorted location — trivial to
adjust for either path.

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY IN STABLE**
Record: The 0x87cb SSID does not appear in the current tree (confirmed
by grep), so no related fix for this specific SSID is already present.

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

**Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY**
Record: Subsystem: sound/hda (HD-Audio, Realtek codec). Criticality:
IMPORTANT — audio is critical for laptop users. This specific driver
covers a very large number of consumer laptops.

**Step 7.2: ASSESS SUBSYSTEM ACTIVITY**
Record: Extremely active — `git log` shows continuous stream of quirk
additions. Takashi Iwai actively maintains and applies these patches.
Quirk additions for HP laptops are the most common type of commit in
this file.

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

**Step 8.1: DETERMINE WHO IS AFFECTED**
Record: Users of HP Pavilion 15-eg0xxx laptops with PCI subsystem ID
0x103c:0x87cb and ALC287 codec. Platform-specific / driver-specific.

**Step 8.2: DETERMINE THE TRIGGER CONDITIONS**
Record: Every boot on affected hardware. The mute LED never works
without this quirk — it's not intermittent, it's permanent broken
behavior for these users.

**Step 8.3: DETERMINE THE FAILURE MODE SEVERITY**
Record: Without the fix, the mute LED does not respond. Severity: LOW
for system stability (no crash/corruption), but this is a real hardware
defect that makes the laptop's audio indicator non-functional. This is
exactly the class of hardware enablement quirk that stable trees
routinely accept.

**Step 8.4: CALCULATE RISK-BENEFIT RATIO**
Record: Benefit: enables mute LED for a specific HP laptop variant —
real hardware fix for real users. Risk: essentially zero — the
`SND_PCI_QUIRK` entry only matches on the exact subsystem ID
0x103c:0x87cb, and the underlying fixup is well-tested across 10+ other
HP models. Risk-benefit ratio: very favorable.

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

**Step 9.1: COMPILE THE EVIDENCE**

Evidence FOR backporting:
- Single-line `SND_PCI_QUIRK` table entry addition — textbook stable
  material
- Uses existing, well-tested fixup (`ALC287_FIXUP_HP_GPIO_LED`)
  confirmed in 10+ other entries
- GPIO mask 0x10 in the fixup matches the author's hda-verb hardware
  verification
- Neighboring entry 0x87cc for the same laptop model uses the identical
  fixup
- The sibling 0x87cc commit (`9744ede7099e8`) explicitly carries `Cc:
  stable@vger.kernel.org`
- Accepted by ALSA maintainer Takashi Iwai
- Fixup infrastructure exists in all active stable trees (since
  v5.10-era)
- Zero regression risk (SSID-gated, affects only this specific hardware)
- Matches the "AUDIO CODEC QUIRKS" exception category explicitly listed
  in stable guidelines

Evidence AGAINST backporting:
- None

Unresolved:
- Full mailing list thread content not fetched (but maintainer
  acceptance is confirmed via SOB)

**Step 9.2: APPLY THE STABLE RULES CHECKLIST**
1. Obviously correct and tested? **YES** — identical pattern to dozens
   of entries; hardware-verified by author via hda-verb; accepted by
   subsystem maintainer
2. Fixes a real bug that affects users? **YES** — mute LED non-
   functional on specific HP laptop
3. Important issue? **YES under exception** — hardware quirk for audio
   codec; same class as the explicitly allowed "SND_PCI_QUIRK entries
   for specific laptop models"
4. Small and contained? **YES** — 1 line, single table entry
5. No new features or APIs? **YES** — maps an existing fixup to a new
   SSID
6. Can apply to stable trees? **YES** — trivially, with path adjustment
   for trees < v6.17 (`sound/pci/hda/patch_realtek.c` instead of
   `sound/hda/codecs/realtek/alc269.c`)

**Step 9.3: CHECK FOR EXCEPTION CATEGORIES**
Record: Hardware quirk / audio codec quirk — explicitly listed as
automatic YES in stable guidelines. `SND_PCI_QUIRK` entries for specific
laptop models are called out by name.

**Step 9.4: MAKE YOUR DECISION**
This is a textbook hardware quirk addition — a single-line
`SND_PCI_QUIRK` entry mapping a missing PCI subsystem ID to an existing,
well-tested fixup function. It enables the mute LED on a specific HP
laptop variant. Zero regression risk, accepted by the subsystem
maintainer, underlying fixup exists in all active stable trees.

---

## Verification

- [Phase 1] Parsed tags: Signed-off-by from author (César Montoya) and
  maintainer (Takashi Iwai); Link to patch submission; no
  Fixes:/Reported-by: (expected for quirk)
- [Phase 2] Diff: exactly +1 line `SND_PCI_QUIRK(0x103c, 0x87cb, "HP
  Pavilion 15-eg0xxx", ALC287_FIXUP_HP_GPIO_LED)` in
  `alc269_fixup_tbl[]`
- [Phase 3] git blame -L6868,6872: confirmed 0x87cc at line 6870 from
  `7cd3c8cafbc050`, surrounding lines from `aeeb85f26c3bbe` (file move);
  0x87cb not present in current tree (grep returns no matches)
- [Phase 3] git show `9744ede7099e8`: confirmed this is the sibling
  0x87cc commit for the same laptop model, with `Cc:
  <stable@vger.kernel.org>`, tagged `v6.16~13^2~3`
- [Phase 3] git show `6014e9021b28e`: confirmed file moved from
  `sound/pci/hda/patch_realtek.c` to `sound/hda/codecs/realtek/alc269.c`
  in v6.17-rc1
- [Phase 5] Read lines 1360-1364: `alc287_fixup_hp_gpio_led()` calls
  `alc_fixup_hp_gpio_led(codec, action, 0x10, 0)` — GPIO mask 0x10
  matches commit message
- [Phase 5] Read lines 5921-5924: `ALC287_FIXUP_HP_GPIO_LED` fixup
  definition confirmed, type `HDA_FIXUP_FUNC`
- [Phase 5] Grep: `ALC287_FIXUP_HP_GPIO_LED` appears 11 times in
  alc269.c (10+ other HP models)
- [Phase 6] File path differs between mainline and stable < 6.17; table
  format is identical — trivial backport adjustment
- [Phase 8] Risk: zero (SSID-gated single table entry, well-tested
  existing fixup path)

**YES**

 sound/hda/codecs/realtek/alc269.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/hda/codecs/realtek/alc269.c b/sound/hda/codecs/realtek/alc269.c
index 75f880efdeaf1..5adc5db6fd52b 100644
--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -6868,6 +6868,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x103c, 0x8788, "HP OMEN 15", ALC285_FIXUP_HP_MUTE_LED),
 	SND_PCI_QUIRK(0x103c, 0x87b7, "HP Laptop 14-fq0xxx", ALC236_FIXUP_HP_MUTE_LED_COEFBIT2),
 	SND_PCI_QUIRK(0x103c, 0x87c8, "HP", ALC287_FIXUP_HP_GPIO_LED),
+	SND_PCI_QUIRK(0x103c, 0x87cb, "HP Pavilion 15-eg0xxx", ALC287_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x87cc, "HP Pavilion 15-eg0xxx", ALC287_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x87d3, "HP Laptop 15-gw0xxx", ALC236_FIXUP_HP_MUTE_LED_COEFBIT2),
 	SND_PCI_QUIRK(0x103c, 0x87df, "HP ProBook 430 G8 Notebook PC", ALC236_FIXUP_HP_GPIO_LED),
-- 
2.53.0

