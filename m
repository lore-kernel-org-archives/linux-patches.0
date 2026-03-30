Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 520423D330E;
	Mon, 30 Mar 2026 12:39:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774874340; cv=none; b=TlGT7cpA29AF9uw8ZNN65wkgMekVqQlchsh4yFdpKgDSv/Lr6EeMSb5eOBEpHI9VOy8rpCwbGvnctpn/R+531LZq64HPfl+i1wqh9SJssdGf7+J8zykS9GWXqgdHppeGWkBI2h/koQpUPtXfGmH8c2cnBpnzUHmYZGrQMLMlbR8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774874340; c=relaxed/simple;
	bh=mFjDYXZl9BeZFXuOwZWSoXRnp/QSrvsyZ9O2eaEN23A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pl/ZpF645HeEkAzz/BuKTYWPkF1wvlWgupD6hBY6yptAi2gkXST73+pBIoaihRRjxxRZkfgfmTjR6yKSR/IRpu5+o6csIEkVIXVwNrC90mu1JQewBGvzTXV6uyopcn4wIpyqZ2+hZKHz0Fp7TgqHlYloWdoWx2C8ynfnZbmHUYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ha+b4JnG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ha+b4JnG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FD65C2BCB8;
	Mon, 30 Mar 2026 12:38:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774874340;
	bh=mFjDYXZl9BeZFXuOwZWSoXRnp/QSrvsyZ9O2eaEN23A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ha+b4JnGvQh50fhsdNXjDgTKVhAQtotwMSxv+2QI/5q8XSazhN/0n0SOs/2kAOeF1
	 sPdrx6+niqV0B4V7KVMrO8UVTqNmZ5zCNK+CmhXbMBzKMwVjlIb4CWjkMmBoV7rfF8
	 M41m3fiBQHiiEO5YqjVvjRyceGPgTnnwDvMyHi4443pFNcfsSQCaV9hMoPTu4zGRQl
	 a6LSsv+3NFZurDKg7C37MoFJoVO+kSrkDjBpWFFbhfqrdlhpK1EH3w0iuVerR/vQcY
	 RqegiKIMxHWsAxMBhcCw5F4rMgvhcNRas6CQlHsSvXWPn74esxvnmEDEvRj08+yzI+
	 FvZlV7ffThPfA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Andrii Kovalchuk <coderpy4@proton.me>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>,
	perex@perex.cz,
	tiwai@suse.com,
	linux-sound@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.19-6.1] ALSA: hda/realtek: Add HP ENVY Laptop 13-ba0xxx quirk
Date: Mon, 30 Mar 2026 08:38:25 -0400
Message-ID: <20260330123842.756154-12-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260330123842.756154-1-sashal@kernel.org>
References: <20260330123842.756154-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19.10
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Andrii Kovalchuk <coderpy4@proton.me>

[ Upstream commit 793b008cd39516385791a1d1d223d817e947a471 ]

Add a PCI quirk for HP ENVY Laptop 13-ba0xxx (PCI device ID 0x8756)
to enable proper mute LED and mic mute behavior using the
ALC245_FIXUP_HP_X360_MUTE_LEDS fixup.

Signed-off-by: Andrii Kovalchuk <coderpy4@proton.me>
Link: https://patch.msgid.link/u0s-uRVegF9BN0t-4JnOUwsIAR-mVc4U4FJfJHdEHX7ro_laErHD9y35NebWybcN16gVaVHPJo1ap3AoJ1a2gqJImPvThgeNt_SYVY1KaDw=@proton.me
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have all the verified facts I need. Let me compile the final
analysis.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1: Subject Line**
Record: [ALSA: hda/realtek] [Add] [Add HP ENVY Laptop 13-ba0xxx quirk
for mute LED / mic mute behavior]

**Step 1.2: Tags**
Record:
- Signed-off-by: Andrii Kovalchuk `<coderpy4@proton.me>` (author)
- Link: `https://patch.msgid.link/...` (patch submission)
- Signed-off-by: Takashi Iwai `<tiwai@suse.de>` (ALSA subsystem
  maintainer)
- No Fixes: tag (expected for a quirk addition)
- No Reported-by:, Tested-by:, Reviewed-by:, Acked-by:, or Cc: stable

**Step 1.3: Commit Body**
Record: Bug: On HP ENVY Laptop 13-ba0xxx (PCI SSID 0x103c:0x8756), the
mute LED and mic-mute LED do not function correctly because the driver
lacks a quirk entry mapping this SSID to the appropriate fixup. Symptom:
incorrect mute LED and mic-mute behavior. Root cause: missing PCI quirk
table entry. No stack traces, crash descriptions, or version ranges
mentioned.

**Step 1.4: Hidden Bug Fix Detection**
Record: Not a hidden bug fix — this is an explicit hardware quirk
addition. It fixes a real user-visible hardware issue (broken LED
indicators) but is presented straightforwardly as a quirk addition.

---

## PHASE 2: DIFF ANALYSIS

**Step 2.1: Inventory**
Record: `sound/hda/codecs/realtek/alc269.c`: +1 line, -0 lines. Single
`SND_PCI_QUIRK()` entry added to `alc269_fixup_tbl[]`. Scope: single-
file, single-line, table-only surgical addition.

**Step 2.2: Code Flow Change**
Record: Before: PCI SSID 0x103c:0x8756 has no match in
`alc269_fixup_tbl[]`, so `snd_hda_pick_fixup()` does not select any
fixup for this laptop — default generic behavior, LEDs non-functional.
After: SSID matches `ALC245_FIXUP_HP_X360_MUTE_LEDS`, which calls
existing `alc245_fixup_hp_mute_led_coefbit` chained to
`ALC245_FIXUP_HP_GPIO_LED`.

**Step 2.3: Bug Mechanism**
Record: Category: hardware workaround / quirk table entry. Mechanism:
Missing PCI SSID in quirk table prevents selection of already-
implemented fixup for one specific HP laptop model.

**Step 2.4: Fix Quality**
Record: Obviously correct — follows the identical pattern of hundreds of
other entries in the same table. Minimal (1 line). Regression risk is
essentially zero: `snd_hda_pick_fixup()` matches by exact PCI SSID, so
only device 0x103c:0x8756 is affected. No API changes, no locking
changes, no logic changes.

---

## PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1: Blame**
Record: The neighboring quirk lines in `alc269_fixup_tbl[]` trace to the
July 2025 Realtek driver split (file moved from
`sound/pci/hda/patch_realtek.c` to `sound/hda/codecs/realtek/alc269.c`).
The quirk infrastructure and the fixup `ALC245_FIXUP_HP_X360_MUTE_LEDS`
are long-standing.

**Step 3.2: Fixes: tag**
Record: N/A — no Fixes: tag present, which is expected for a quirk
addition.

**Step 3.3: File History**
Record: `git log --oneline -20 -- sound/hda/codecs/realtek/alc269.c`
shows many similar quirk additions (HP, Samsung, Acer, Lenovo, etc.).
This is the standard maintenance pattern for the Realtek HDA driver.
This commit is standalone — not part of a numbered series.

**Step 3.4: Author**
Record: `git log --author='Andrii Kovalchuk' -10 -- sound/` returned no
results — first-time contributor. However, the patch was accepted and
signed off by Takashi Iwai (ALSA subsystem maintainer), which is a
strong quality signal.

**Step 3.5: Dependencies**
Record: The only prerequisite is that `ALC245_FIXUP_HP_X360_MUTE_LEDS`
must exist in the target tree. Verified:
- **v6.6**: Present (3 occurrences in `sound/pci/hda/patch_realtek.c`) ✓
- **v6.12**: Present (6 occurrences) ✓
- **v6.1**: **NOT present** (0 occurrences) ✗
- **v5.15**: **NOT present** (0 occurrences) ✗

This commit is standalone for v6.6+ trees but **cannot** be backported
to v6.1 or v5.15 without first backporting the prerequisite fixup.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

**Step 4.1: Patch Discussion**
Record: Direct lore.kernel.org and patch.msgid.link fetches were blocked
by anti-bot protection. Via an alternative readable mirror, the thread
shows a standalone [PATCH] submission. Takashi Iwai's only feedback was
about email formatting — no technical objections. He manually corrected
and applied the patch. No reviewer suggested Cc: stable. No NAKs.

**Step 4.2: Bug Report**
Record: No separate public bug report found. No Reported-by: tag. The
patch thread itself serves as the primary evidence of the user-visible
issue.

**Step 4.3: Related Patches**
Record: This is a standalone one-line patch, not part of a series.
Similar quirks exist for other HP ENVY models using the same fixup
(0x876e for 13-ay0xxx, 0x888a for 15-eu0xxx, etc.).

**Step 4.4: Stable Discussion**
Record: No stable-specific discussion found for this commit. However,
analogous HP ENVY quirk additions have historically carried `Cc:
stable@vger.kernel.org`, demonstrating this pattern is routinely
considered for stable.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1: Functions Modified**
Record: No functions modified. Only a static data table entry added to
`alc269_fixup_tbl[]`.

**Step 5.2: Callers**
Record: The quirk table is consumed by `snd_hda_pick_fixup(codec,
alc269_fixup_models, alc269_fixup_tbl, alc269_fixups)` called from
`alc269_probe()` at line 8572-8573 of `alc269.c`. The codec driver
registers `.probe = alc269_probe` via
`module_hda_codec_driver(alc269_driver)`.

**Step 5.3: Callees**
Record: The fixup `ALC245_FIXUP_HP_X360_MUTE_LEDS` (line 6401-6406)
calls `.v.func = alc245_fixup_hp_mute_led_coefbit` and chains to
`ALC245_FIXUP_HP_GPIO_LED`. All existing, well-tested code.

**Step 5.4: Reachability**
Record: Call chain: `module_hda_codec_driver` → `alc269_probe` →
`snd_hda_pick_fixup()` → match PCI SSID against table. Triggered during
codec probe on every boot/module-load on the affected laptop. Real and
reachable.

**Step 5.5: Similar Patterns**
Record: Verified 4 other devices already use this exact fixup in the
same table:
- 0x876e (HP ENVY x360 Convertible 13-ay0xxx)
- 0x888a (HP ENVY x360 Convertible 15-eu0xxx)
- 0x8c21 (HP Pavilion Plus Laptop 14-ey0XXX)
- 0x8cbd (HP Pavilion Aero Laptop 13-bg0xxx)

---

## PHASE 6: STABLE TREE ANALYSIS

**Step 6.1: Code Existence in Stable**
Record: Verified via `git show`:
- **v6.6**: `ALC245_FIXUP_HP_X360_MUTE_LEDS` exists in
  `sound/pci/hda/patch_realtek.c` (3 matches). SSID 0x8756 is NOT
  present — the bug exists here. **Applicable.**
- **v6.12**: Fixup present (6 matches). **Applicable.**
- **v6.1**: Fixup does NOT exist. **Not applicable without
  prerequisite.**
- **v5.15**: Fixup does NOT exist. **Not applicable without
  prerequisite.**

**Step 6.2: Backport Complications**
Record: For v6.6.y: trivial backport — the one-line entry goes into
`sound/pci/hda/patch_realtek.c` (pre-split file path) instead of
`sound/hda/codecs/realtek/alc269.c`. Context lines for the adjacent
entries (0x8736, 0x8760) should be present. Minor context adjustment
needed.

**Step 6.3: Related Fixes Already in Stable**
Record: No existing fix for SSID 0x8756 found in v6.6.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

**Step 7.1: Subsystem**
Record: sound/hda (HDA audio, Realtek codec driver). Criticality:
IMPORTANT — laptop audio is user-facing and widely used, though this
specific fix affects one hardware model.

**Step 7.2: Activity**
Record: Very active subsystem — recent history shows continuous stream
of quirk additions for various laptop models. Mature, well-maintained
driver with established patterns.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1: Affected Users**
Record: Hardware-specific: owners of HP ENVY Laptop 13-ba0xxx (PCI SSID
0x103c:0x8756). This is a consumer laptop — potentially many users.

**Step 8.2: Trigger Conditions**
Record: Every boot. The mute/mic-mute LEDs simply don't work correctly
without this quirk. No special configuration needed.

**Step 8.3: Failure Mode Severity**
Record: MEDIUM — Mute/mic-mute LED indicators don't function correctly.
This is a usability and privacy concern (users can't visually confirm
mic state), but not a crash, data corruption, or security vulnerability.

**Step 8.4: Risk-Benefit Ratio**
Record:
- Benefit: Moderate — fixes broken hardware functionality for real
  laptop users
- Risk: Very low — 1 line, device-specific (only SSID 0x103c:0x8756),
  uses proven fixup used by 4+ other devices
- Ratio: Strongly favorable for backporting

---

## PHASE 9: FINAL SYNTHESIS

**Step 9.1: Evidence**

FOR backporting:
- Single-line hardware quirk addition (1 line added)
- Uses existing, well-tested fixup (`ALC245_FIXUP_HP_X360_MUTE_LEDS`)
  already used by 4 other HP devices
- Zero regression risk — only activates on PCI SSID 0x103c:0x8756
- Accepted by ALSA subsystem maintainer Takashi Iwai with no technical
  objections
- Fixes real user-visible hardware issue on a consumer laptop
- Prerequisite fixup verified present in v6.6+
- Falls squarely under the "audio codec quirk" stable exception

AGAINST backporting:
- Not a crash, security issue, or data corruption — "only" a
  usability/hardware fix
- Not applicable to v6.1 or v5.15 without prerequisite backport

UNRESOLVED:
- No independent public bug report found (patch thread is the only
  evidence)
- Did not verify every active stable branch newer than v6.6

**Step 9.2: Stable Rules Checklist**
1. Obviously correct and tested? **YES** — standard `SND_PCI_QUIRK`
   table entry, maintainer-accepted
2. Fixes a real bug? **YES** — mute/mic-mute LEDs non-functional on this
   hardware
3. Important issue? **YES under quirk exception** — hardware enablement
   for a consumer laptop
4. Small and contained? **YES** — 1 line in 1 file
5. No new features or APIs? **YES** — uses existing fixup mechanism
6. Can apply to stable? **YES** for v6.6+ (with file path adjustment);
   NO for v6.1/v5.15 as standalone

**Step 9.3: Exception Categories**
Record: **Audio codec quirk** (`SND_PCI_QUIRK` entry in Realtek HDA
driver) — explicitly listed as a stable-appropriate exception.

**Step 9.4: Decision**
This is a textbook stable-worthy hardware quirk. One line, zero
regression risk, fixes real hardware for real users, uses an existing
well-tested fixup. Good stable material for branches that already
contain `ALC245_FIXUP_HP_X360_MUTE_LEDS` (v6.6+). Should not be taken as
a standalone patch into older trees (v6.1, v5.15) without the
prerequisite fixup.

---

## Verification

- [Phase 1] Parsed commit message: Add quirk for 0x103c:0x8756 using
  `ALC245_FIXUP_HP_X360_MUTE_LEDS`; tags: SOB ×2, Link
- [Phase 2] Diff: +1 `SND_PCI_QUIRK` line in `alc269_fixup_tbl[]` in
  `sound/hda/codecs/realtek/alc269.c`
- [Phase 3] Verified `ALC245_FIXUP_HP_X360_MUTE_LEDS` definition at
  lines 6401-6406: `.v.func = alc245_fixup_hp_mute_led_coefbit`, chained
  to `ALC245_FIXUP_HP_GPIO_LED`
- [Phase 3] Verified `snd_hda_pick_fixup()` call at lines 8572-8573 in
  `alc269_probe()`
- [Phase 3] Verified 4 other SSIDs use the same fixup: 0x876e, 0x888a,
  0x8c21, 0x8cbd
- [Phase 3] `git log --author='Andrii Kovalchuk'`: no prior commits
  found — first-time contributor
- [Phase 4] Lore/patch.msgid blocked by anti-bot; alternative mirror
  confirmed standalone patch, maintainer feedback was formatting-only,
  no technical objections
- [Phase 5] No functions modified — data-only change
- [Phase 6] `git show v6.6:sound/pci/hda/patch_realtek.c | grep -c
  'ALC245_FIXUP_HP_X360_MUTE_LEDS'`: **3** — fixup present in v6.6
- [Phase 6] `git show v6.12:sound/pci/hda/patch_realtek.c | grep -c
  ...`: **6** — fixup present in v6.12
- [Phase 6] `git show v6.1:sound/pci/hda/patch_realtek.c | grep -c ...`:
  **0** — fixup NOT in v6.1
- [Phase 6] `git show v5.15:sound/pci/hda/patch_realtek.c | grep -c
  ...`: **0** — fixup NOT in v5.15
- [Phase 6] `git show v6.6:... | grep '0x8756'`: empty — SSID not
  already in v6.6, confirming the bug exists there
- [Phase 8] Risk: very low (1 line, SSID-specific). Benefit: fixes
  broken mute LEDs on consumer laptop
- UNVERIFIED: No independent public bug report found for this exact
  laptop model
- UNVERIFIED: Did not inspect every active stable branch newer than v6.6

**YES**

 sound/hda/codecs/realtek/alc269.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/hda/codecs/realtek/alc269.c b/sound/hda/codecs/realtek/alc269.c
index 4c49f1195e1bc..39a57d9238497 100644
--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -6854,6 +6854,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x103c, 0x8730, "HP ProBook 445 G7", ALC236_FIXUP_HP_MUTE_LED_MICMUTE_VREF),
 	SND_PCI_QUIRK(0x103c, 0x8735, "HP ProBook 435 G7", ALC236_FIXUP_HP_MUTE_LED_MICMUTE_VREF),
 	SND_PCI_QUIRK(0x103c, 0x8736, "HP", ALC285_FIXUP_HP_GPIO_AMP_INIT),
+	SND_PCI_QUIRK(0x103c, 0x8756, "HP ENVY Laptop 13-ba0xxx", ALC245_FIXUP_HP_X360_MUTE_LEDS),
 	SND_PCI_QUIRK(0x103c, 0x8760, "HP EliteBook 8{4,5}5 G7", ALC285_FIXUP_HP_BEEP_MICMUTE_LED),
 	SND_PCI_QUIRK(0x103c, 0x876e, "HP ENVY x360 Convertible 13-ay0xxx", ALC245_FIXUP_HP_X360_MUTE_LEDS),
 	SND_PCI_QUIRK(0x103c, 0x877a, "HP", ALC285_FIXUP_HP_MUTE_LED),
-- 
2.53.0

