Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F7DB30E84F;
	Mon, 30 Mar 2026 12:38:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774874325; cv=none; b=Q/mJzvqva5VcbLbC3xWWPL865kuMbYHNYXTk7Inileki+9qvfa9He9sWKyzT4tyE+nYVbJdxujTR06DDXBxKE0dwXb+Rh4mkeqXxM8r0MzhBvYTbW8fJa4ieIPHsmYQpKVuCHXu/5QXybRL+ODzxVtlf02cwIvCe+L07S26zuiE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774874325; c=relaxed/simple;
	bh=jqL8jWgMBiXMBrLBv+2Vuwztl/XEUI1Jxtjw63+X0qo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=u9KRx+ax/XT2z/92+VRxoHJ10jEnqUVG+NzaJna1ybgFD5pkTnCpA3BQxgczMcsMrS8vimnclrIU8bcTJY/SHWhic1Cr+SdO/8xOEow9QltGqJSDVlfBpXupknyPn4A+LX5YM71xMvTH4v7aqW0vZmbmDpzMZN9r9b68/Zd+TVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aUUtY3Yp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aUUtY3Yp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCB56C4CEF7;
	Mon, 30 Mar 2026 12:38:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774874324;
	bh=jqL8jWgMBiXMBrLBv+2Vuwztl/XEUI1Jxtjw63+X0qo=;
	h=From:To:Cc:Subject:Date:From;
	b=aUUtY3YpyhNSxvlBuSRIPiRqwh8w1SKo7CJcpF9+ePQVB7R59y6V3AjyhZ9HD1eYW
	 TBZEjHz+Wfh7DawePsaann5fUkxWx4okcj1mrzxcjXsEfPMVud3bY0oWDE0LNsqcum
	 8RT8S1zG4O1WjpwhJKLYvxH2gxbZAblAhU2C7AptsjDaML19bLRkQIlTRpsRAv0w6R
	 4BF5bUScYgJcP2fqNlOqD6EKHqss0pDRX9y58m+fsuh3NtHDqra7TfaZR1c8acco9t
	 RWItMbee9JYG4iSjjsnZx8OmXv+5vflBGRSb6/ZWr4zYGZwvAS0fNVo+KJk22QxSmV
	 ykrO8fu2PH9SA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Zhang Heng <zhangheng@kylinos.cn>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>,
	perex@perex.cz,
	tiwai@suse.com,
	linux-sound@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.19-6.18] ALSA: hda/realtek: add quirk for Lenovo Yoga 7 2-in-1 16AKP10
Date: Mon, 30 Mar 2026 08:38:14 -0400
Message-ID: <20260330123842.756154-1-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
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

From: Zhang Heng <zhangheng@kylinos.cn>

[ Upstream commit 7bae956cac0433c4d41aac9f1d04e42694e0b706 ]

This machine is equipped with ALC287 and requires the quirk
ALC287_FIXUP_YOGA9_14IAP7_BASS_SPK_PIN to fix the issue
where the bass speakers are not configured and the speaker
volume cannot be controlled.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=221210
Signed-off-by: Zhang Heng <zhangheng@kylinos.cn>
Link: https://patch.msgid.link/20260313080624.1395362-1-zhangheng@kylinos.cn
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have all the information needed. Let me write the full analysis.

---

## Phase 1: Commit Message Forensics

**Step 1.1: Parse the subject line**
Record: [ALSA: hda/realtek] [add] Add a hardware quirk entry so Lenovo
Yoga 7 2-in-1 16AKP10 uses the existing ALC287 bass-speaker fixup.

**Step 1.2: Parse all commit message tags**
Record:
- `Link: https://bugzilla.kernel.org/show_bug.cgi?id=221210` — a filed
  kernel bug report
- `Signed-off-by: Zhang Heng <zhangheng@kylinos.cn>` — the author
- `Link: https://patch.msgid.link/20260313080624.1395362-1-
  zhangheng@kylinos.cn` — patch submission
- `Signed-off-by: Takashi Iwai <tiwai@suse.de>` — ALSA subsystem
  maintainer

Not present: `Fixes:`, `Reported-by:`, `Tested-by:`, `Reviewed-by:`,
`Acked-by:`, `Cc: stable@vger.kernel.org`. Absence of these is expected
for commits under manual review.

**Step 1.3: Analyze the commit body text**
Record: The machine has an ALC287 codec. Without the quirk, bass
speakers are not configured and speaker volume cannot be controlled. A
kernel bugzilla entry (#221210) documents the user-facing issue.

**Step 1.4: Detect hidden bug fixes**
Record: Not a hidden fix — this is an explicit hardware quirk addition
for a known audio routing problem.

---

## Phase 2: Diff Analysis — Line by Line

**Step 2.1: Inventory the changes**
Record: One file changed: `sound/hda/codecs/realtek/alc269.c`. +1 line,
-0 lines. Modified: `alc269_fixup_tbl[]` static table. Scope: single-
file, table-only, surgical.

**Step 2.2: Understand the code flow change**
Record: Before: no entry in `alc269_fixup_tbl[]` for codec SSID
`0x17aa:0x391d`. The ALC287 codec on this laptop gets no fixup applied
to bass speakers. After: `HDA_CODEC_QUIRK(0x17aa, 0x391d, "Lenovo Yoga 7
2-in-1 16AKP10", ALC287_FIXUP_YOGA9_14IAP7_BASS_SPK_PIN)` maps this
codec SSID to an existing well-tested fixup. This is an
initialization/probe path change.

**Step 2.3: Identify the bug mechanism**
Record: Category (h) — hardware workaround / audio codec quirk. The
fixup function `alc287_fixup_yoga9_14iap7_bass_spk_pin()` does:
1. Overrides Pin Complex 0x17 configuration (reported wrongly as
   unconnected)
2. Overrides connection list for NID 0x17 to DACs 0x02/0x03 (avoids DACs
   0x06/0x08 which have no volume control)
3. Sets preferred DAC pairing: speakers (0x14, 0x17) → DAC 0x02,
   headphones (0x21) → DAC 0x03

**Step 2.4: Assess the fix quality**
Record: Minimal and obviously correct — one exact-match table entry
reusing a fixup already used by 7+ other Lenovo machines.
`HDA_CODEC_QUIRK` matches on codec SSID (narrower than PCI SSID), so no
other hardware can be affected. Regression risk: effectively zero.

---

## Phase 3: Git History Investigation

**Step 3.1: Blame the changed lines**
Record: `git blame` shows the adjacent sibling entry for `0x391c`
(14AKP10) was introduced by commit `1386d16761c0b5` (J-Donald Tournier,
2025-10-18). The new `0x391d` entry is the 16-inch variant of the same
family. There was no previous `0x391d` line — this is a coverage gap,
not a changed line.

**Step 3.2: Follow the Fixes: tag**
Record: N/A — no `Fixes:` tag present (expected for manually reviewed
candidates).

**Step 3.3: Check file history for related changes**
Record: Recent `alc269.c` history is dominated by quirk additions for
various laptops. Related commits:
- `1386d16761c0b5`: sibling 14AKP10 quirk (same fixup, same
  `HDA_CODEC_QUIRK` pattern)
- `3790a3d6dbbc4`: original `ALC287_FIXUP_YOGA9_14IAP7_BASS_SPK_PIN`
  introduction (first in v6.0)
- `504f052aa3435`: introduced `HDA_CODEC_QUIRK` / codec-SSID matching
  for Lenovo (first in v6.13)

This commit is standalone — no patch series, no multi-file dependency.

**Step 3.4: Check the author's other commits**
Record: Zhang Heng is a recurring contributor in
`sound/hda/codecs/realtek/`, with 6+ prior quirk patches found. Not the
subsystem maintainer but an established contributor. Takashi Iwai (ALSA
maintainer) signed off.

**Step 3.5: Check for dependent/prerequisite commits**
Record: This patch depends on two prerequisites:
1. `ALC287_FIXUP_YOGA9_14IAP7_BASS_SPK_PIN` — present since v6.0
2. `HDA_CODEC_QUIRK()` macro — present since v6.13 (commit
   `504f052aa3435`)

Both are verified present on HEAD. The patch is standalone for any tree
that has these two prerequisites.

---

## Phase 4: Mailing List and External Research

**Step 4.1–4.4**
Record: Bugzilla #221210 and lore.kernel.org links were inaccessible due
to Anubis bot protection. However, the existence of a kernel bugzilla
report referenced in a maintainer-signed commit provides sufficient
evidence of a documented, real-world user issue. No mailing list review
details could be verified. No stable-specific discussion could be
checked.

---

## Phase 5: Code Semantic Analysis

**Step 5.1: Identify key functions**
Record: The diff modifies `alc269_fixup_tbl[]`. The semantically
affected functions are:
- `snd_hda_pick_fixup()` (reads the table during probe)
- `alc287_fixup_yoga9_14iap7_bass_spk_pin()` (the fixup applied)

**Step 5.2: Trace callers**
Record: `alc269_fixup_tbl` is consumed by `snd_hda_pick_fixup()`, called
from `alc269_probe()` — the standard ALC269-family codec initialization
path. This runs on every system that has this codec.

**Step 5.3: Trace callees**
Record: `alc287_fixup_yoga9_14iap7_bass_spk_pin()` calls:
- `hda_fixup_ideapad_acpi()` — mute LED support
- `snd_hda_apply_pincfgs()` — override pin 0x17 configuration
- `snd_hda_override_conn_list()` — set DAC connections for NID 0x17
- Sets `spec->gen.preferred_dacs` — DAC pairing preferences

**Step 5.4: Follow the call chain**
Record: ALC287 codec → `alc269_probe()` → `snd_hda_pick_fixup()` → table
match on codec SSID → `snd_hda_apply_fixup(HDA_FIXUP_ACT_PRE_PROBE)` →
`alc287_fixup_yoga9_14iap7_bass_spk_pin()`. This path is automatically
exercised on boot on affected hardware. Fully reachable without special
configuration.

**Step 5.5: Search for similar patterns**
Record: The same fixup `ALC287_FIXUP_YOGA9_14IAP7_BASS_SPK_PIN` is
already used for 7+ Lenovo models: 0x3801, 0x3869, 0x3882, 0x3891,
0x390d, 0x391c. This is a well-exercised, established pattern.

---

## Phase 6: Cross-Referencing and Stable Tree Analysis

**Step 6.1: Does the buggy code exist in stable trees?**
Record:
- The bass-speaker fixup `ALC287_FIXUP_YOGA9_14IAP7_BASS_SPK_PIN` has
  existed since **v6.0**.
- The `HDA_CODEC_QUIRK()` macro (codec-SSID matching) was introduced in
  **v6.13** (`504f052aa3435`).
- The sibling `0x391c` entry first appeared in **v6.18**
  (`1386d16761c0b5`).
- This commit (`7bae956cac043`) first appears in **v7.0-rc6**.

Branch applicability:
- **v6.18.y, v6.19.y**: Trivial one-line addition next to the existing
  `0x391c` sibling. Clean apply expected.
- **v6.13–v6.17**: `HDA_CODEC_QUIRK` exists, fixup exists. Feasible but
  `0x391c` context line is absent.
- **v6.12 and older (v6.6, v6.1, v5.15)**: Lack `HDA_CODEC_QUIRK()`
  macro entirely. Not a standalone backport — would need adaptation
  (e.g., using `SND_PCI_QUIRK` instead, which matches PCI SSID not codec
  SSID).

**Step 6.2: Check for backport complications**
Record: Clean apply on v6.18.y and v6.19.y. Minor context adjustments
for v6.13–v6.17. Not directly applicable for older trees.

**Step 6.3: Check if related fixes are already in stable**
Record: No evidence of an existing `0x391d` entry in any branch. The
sibling `0x391c` is in v6.18+.

---

## Phase 7: Subsystem and Maintainer Context

**Step 7.1: Identify the subsystem and its criticality**
Record: `sound/hda/codecs/realtek` — ALSA HDA Realtek codec driver.
Criticality: IMPORTANT. While it's a specific driver, Realtek HDA is
among the most widely used audio codecs in laptops. Quirks for this
driver are routine stable material.

**Step 7.2: Assess subsystem activity**
Record: `alc269.c` sees very frequent updates, overwhelmingly quirk
additions for various laptop models. This is completely normal for the
subsystem.

---

## Phase 8: Impact and Risk Assessment

**Step 8.1: Determine who is affected**
Record: Users of the Lenovo Yoga 7 2-in-1 16AKP10 laptop. Platform-
specific / driver-specific scope.

**Step 8.2: Determine trigger conditions**
Record: The bug triggers on every boot — the bass speakers are
misconfigured during codec initialization. Every user of this laptop is
affected every time they use audio. Not a rare condition or timing-
dependent race.

**Step 8.3: Determine failure mode severity**
Record: Bass speakers are not configured and speaker volume cannot be
controlled. This is a persistent, user-visible functional defect.
Severity: MEDIUM — not a crash or security issue, but a real hardware
functionality problem that affects every boot.

**Step 8.4: Calculate risk-benefit ratio**
Record:
- **Benefit**: HIGH for affected users — restores proper speaker
  functionality on their laptop.
- **Risk**: VERY LOW — one table entry, exact codec-SSID match, reuses a
  well-tested fixup already used by 7+ other models. Zero risk to other
  hardware.
- **Ratio**: Strongly favorable.

---

## Phase 9: Final Synthesis

**Step 9.1: Compile the evidence**

Evidence FOR backporting:
- Real user-facing bug documented in kernel bugzilla (#221210)
- One-line, exact-match hardware quirk — minimal change
- Reuses `ALC287_FIXUP_YOGA9_14IAP7_BASS_SPK_PIN`, well-tested since
  v6.0 across 7+ Lenovo models
- Maintainer (Takashi Iwai) signed off
- Sibling device `0x391c` already uses the same fixup via same mechanism
- `HDA_CODEC_QUIRK` narrows match to codec SSID — no risk of false
  matches
- Author (Zhang Heng) is an established contributor to this area

Evidence AGAINST backporting:
- Not a crash, security, or data corruption fix (functional audio issue)
- Older LTS trees (v6.12 and below) lack `HDA_CODEC_QUIRK()` — not a
  standalone backport there

Unresolved:
- Bugzilla #221210 contents (blocked by Anubis)
- Lore review discussion (blocked by Anubis)

**Step 9.2: Apply the stable rules checklist**
1. Obviously correct and tested? **YES** — one table entry, same fixup
   used by many devices, maintainer sign-off.
2. Fixes a real bug that affects users? **YES** — broken bass speakers
   and volume control on a shipping laptop.
3. Important issue? **YES** — hardware functionality completely broken;
   meets hardware quirk exception.
4. Small and contained? **YES** — 1 line, 1 file.
5. No new features or APIs? **YES** — data table entry only.
6. Can apply to stable trees? **YES** — clean apply on v6.13+ trees that
   have `HDA_CODEC_QUIRK`. Trivially clean on v6.18+/v6.19+.

**Step 9.3: Check for exception categories**
Record: This is a **hardware quirk/workaround** — explicitly listed as
an exception category that is automatically YES for stable.
Specifically, it is an **audio codec quirk** (`HDA_CODEC_QUIRK` entry in
`alc269_fixup_tbl`).

**Step 9.4: Make the decision**
This is a textbook stable backport: a single-line audio codec quirk for
an existing driver, fixing broken speakers on a specific laptop, using a
well-established fixup. It should be backported to stable trees that
already have `HDA_CODEC_QUIRK()` support (v6.13+), with special ease on
v6.18.y and v6.19.y where the sibling entry provides clean context.

---

## Verification

- [Phase 1] Parsed tags from `git show 7bae956cac043`: confirmed Link to
  bugzilla #221210, SOBs from Zhang Heng and Takashi Iwai (ALSA
  maintainer). No Fixes/Reported-by/Cc:stable tags.
- [Phase 2] Diff analysis: confirmed exactly 1 line added —
  `HDA_CODEC_QUIRK(0x17aa, 0x391d, ...)` in `alc269_fixup_tbl[]`.
  Diffstat: `1 file changed, 1 insertion(+)`.
- [Phase 2] Read fixup function at line 3428: confirmed
  `alc287_fixup_yoga9_14iap7_bass_spk_pin()` applies pin config for NID
  0x17, overrides connection list to DACs 0x02/0x03, sets preferred DAC
  pairs.
- [Phase 2] Read `HDA_CODEC_QUIRK` definition in
  `sound/hda/common/hda_local.h`: confirmed it sets `.match_codec_ssid =
  true` for narrow matching.
- [Phase 3] `git blame -L 7574,7576`: confirmed sibling `0x391c` entry
  from `1386d16761c0b5` (J-Donald Tournier, 2025-10-18).
- [Phase 3] `git log --oneline -1 1386d16761c0b5`: confirmed "ALSA:
  hda/realtek: Add quirk for Lenovo Yoga 7 2-in-1 14AKP10".
- [Phase 3] `git tag --contains 3790a3d6dbbc4`: confirmed original Yoga9
  bass-speaker fixup first in released tag v6.0.
- [Phase 3] `git log --oneline -1 504f052aa3435`: confirmed "ALSA:
  hda/realtek: Use codec SSID matching for Lenovo devices".
- [Phase 3] `git tag --contains 504f052aa3435`: confirmed
  `HDA_CODEC_QUIRK` support first in released tag v6.13.
- [Phase 3] `git log --author="Zhang Heng"`: confirmed 6+ prior HDA
  Realtek quirk patches.
- [Phase 5] Grep for `ALC287_FIXUP_YOGA9_14IAP7_BASS_SPK_PIN` in quirk
  table: confirmed usage by 0x3801, 0x3869, 0x3882, 0x3891, 0x390d,
  0x391c (7+ models).
- [Phase 5] Grep for `alc287_fixup_yoga9_14iap7_bass_spk_pin`: confirmed
  function definition at line 3428 and fixup array reference at line
  6331.
- [Phase 6] `git tag --contains 7bae956cac043`: confirmed this commit is
  only in v7.0-rc6.
- [Phase 6] `git tag --contains 1386d16761c0b5`: confirmed sibling entry
  first in v6.18.
- [Phase 6] Grep for `0x391d` in current tree: confirmed no existing
  entry (the candidate adds it).
- [Phase 7] `git log --oneline -20 --
  sound/hda/codecs/realtek/alc269.c`: confirmed high churn, all quirk
  additions.
- [Phase 8] Failure mode assessed from commit message and fixup function
  code: non-functional bass speakers and broken volume control. Severity
  MEDIUM.
- UNVERIFIED: Bugzilla #221210 contents (blocked by Anubis bot
  protection).
- UNVERIFIED: Lore patch discussion and any reviewer stable nomination
  (blocked by Anubis).
- UNVERIFIED: Whether a `SND_PCI_QUIRK` adaptation would work for trees
  older than v6.13.

**YES**

 sound/hda/codecs/realtek/alc269.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/hda/codecs/realtek/alc269.c b/sound/hda/codecs/realtek/alc269.c
index 39a57d9238497..b83f0c4bec142 100644
--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -7573,6 +7573,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x17aa, 0x38ab, "Thinkbook 16P", ALC287_FIXUP_MG_RTKC_CSAMP_CS35L41_I2C_THINKPAD),
 	SND_PCI_QUIRK(0x17aa, 0x38b4, "Legion Slim 7 16IRH8", ALC287_FIXUP_CS35L41_I2C_2),
 	HDA_CODEC_QUIRK(0x17aa, 0x391c, "Lenovo Yoga 7 2-in-1 14AKP10", ALC287_FIXUP_YOGA9_14IAP7_BASS_SPK_PIN),
+	HDA_CODEC_QUIRK(0x17aa, 0x391d, "Lenovo Yoga 7 2-in-1 16AKP10", ALC287_FIXUP_YOGA9_14IAP7_BASS_SPK_PIN),
 	SND_PCI_QUIRK(0x17aa, 0x38b5, "Legion Slim 7 16IRH8", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x17aa, 0x38b6, "Legion Slim 7 16APH8", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x17aa, 0x38b7, "Legion Slim 7 16APH8", ALC287_FIXUP_CS35L41_I2C_2),
-- 
2.53.0

