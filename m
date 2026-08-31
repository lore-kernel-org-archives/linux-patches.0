Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96FDF480359;
	Mon, 31 Aug 2026 13:37:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183470; cv=none; b=NVCWUpcqY7ISQqk72BG29KeacDhBRiqBxrG/BHwF5ftXwa84Kjhelqr90HYIxFY9cw8pvjfaIrrhmuFpjSBf7ECJXwgEru5/h/a6LdLA9ipz4AfwIVZcDwhdkTzY0BJFEXJDRAP9nlt5t+f0sL7brfiasdoQ+C2Bt/hmsNyzh7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183470; c=relaxed/simple;
	bh=bDBlH4a1MmBHE6DnLnnlFkOzoAzhFqgb/g0Bcjkpe78=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dmKlGkLGTZ2jR1vFlWzhlywbYBgIbdmtSmkLKI8iq1zgALM9Phs3fMPowuyl+pVGJar3FUpOerfMpPZbbI0tcirwUOkq/RZd3ew5DdoCtquOytbr/zymgOCHfNiS4Pyhft8TERdaUNMovYPWtayz8DKqv8DgbwyRboabcXiaktI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JDyzOd+g; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JDyzOd+g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64D871F000E9;
	Mon, 31 Aug 2026 13:37:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183468;
	bh=sFui/+YKCz/Qv7T6diOuZfT5MJowzo1RedWUcQ8wh0o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JDyzOd+gr4wlrBTWEwSFX+duQzbiIItKuXCOmGCOZqqNxRLvkLx/5nxmtExYX5Dhl
	 SzlfPsH0/8moipLuH0MRqZT5sTpSHsKexcjdZRLq94VoAaAM3MpU6hI1B2/2cWgZ3e
	 d/1XnF8npkU8O1dflgEAos0sWC19Squ/qs3g/mN5oR3ybOjHmnQtE+j1zi09DwJwBo
	 Dhcv2PfXrc89bY2I8sLBPG5byiowfysvPrFDeRqWSkc4/+96t9Vhgoh6lp2kkFTeB9
	 ZwP3VhvUri+QFClPKAEjcnBBMMIOW/H0VjVgRpwo+mODjBiyk9OHFVDYxGiYc1e57k
	 7p5diDVhw13YA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Federico Lombardo <lombardo.federico.lf@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>,
	perex@perex.cz,
	tiwai@suse.com,
	linux-sound@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] ALSA: hda/realtek: Enable mute LED quirk for HP Laptop 15-dw0xxx
Date: Mon, 31 Aug 2026 09:22:22 -0400
Message-ID: <20260831133314.4125787-114-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260831133314.4125787-1-sashal@kernel.org>
References: <20260831133314.4125787-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.48
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Federico Lombardo <lombardo.federico.lf@gmail.com>

[ Upstream commit b28d3d0841a6083f82dfa9fe940afcd748f2a1e2 ]

HP Laptop 15-dw0xxx with subsystem ID 103c:85f0 needs the
ALC236_FIXUP_HP_MUTE_LED_COEFBIT2 quirk to correctly disable and
enable the Audio Mute LED.

Add the missing quirk entry.

Signed-off-by: Federico Lombardo <lombardo.federico.lf@gmail.com>
Link: https://patch.msgid.link/20260702204347.187524-1-lombardo.federico.lf@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit Message Forensics

**Step 1.1 — Subject line**
Record: `[ALSA: hda/realtek] [enable] Enable mute LED quirk for HP
Laptop 15-dw0xxx`

**Step 1.2 — Tags**
Record:
- `Signed-off-by: Federico Lombardo <lombardo.federico.lf@gmail.com>`
  (author)
- `Link: https://patch.msgid.link/20260702204347.187524-1-
  lombardo.federico.lf@gmail.com`
- `Signed-off-by: Takashi Iwai <tiwai@suse.de>` (ALSA/HDA maintainer)
- No `Fixes:`, `Reported-by:`, `Tested-by:`, `Cc:
  stable@vger.kernel.org`

**Step 1.3 — Body analysis**
Record: HP Laptop 15-dw0xxx with subsystem ID `103c:85f0` needs
`ALC236_FIXUP_HP_MUTE_LED_COEFBIT2` so the audio mute LED correctly
tracks mute state. Symptom: mute LED does not correctly enable/disable
with mic mute. Root cause: missing PCI SSID quirk entry in the Realtek
HDA quirk table.

**Step 1.4 — Hidden bug fix?**
Record: Not disguised — this is an explicit hardware quirk for
broken/misconfigured mute-LED behavior on a specific laptop model.

---

## Phase 2: Diff Analysis

**Step 2.1 — Inventory**
Record:
- 1 file: `sound/hda/codecs/realtek/alc269.c` (+1 line)
- Function/table: `alc269_fixup_tbl[]`
- Scope: single-file, surgical, one-line quirk addition

**Step 2.2 — Code flow change**
Record:
- Before: `103c:85f0` not in `alc269_fixup_tbl[]`;
  `snd_hda_pick_fixup()` does not apply
  `ALC236_FIXUP_HP_MUTE_LED_COEFBIT2` for this machine.
- After: SSID `103c:85f0` maps to `ALC236_FIXUP_HP_MUTE_LED_COEFBIT2`,
  which runs `alc236_fixup_hp_mute_led_coefbit2()` at
  `HDA_FIXUP_ACT_PRE_PROBE` and registers mute-LED control via
  `snd_hda_gen_add_mute_led_cdev()`.

**Step 2.3 — Bug mechanism**
Record: Hardware quirk / audio codec quirk. Category (h): missing
`SND_PCI_QUIRK` entry for a laptop whose ALC236 codec needs coefficient-
bit-2 mute-LED handling.

**Step 2.4 — Fix quality**
Record: Obviously correct — identical pattern to many existing entries
(e.g. `0x84ae`, `0x86c1`, `0x8706`). Minimal risk; no new logic, only
table mapping.

---

## Phase 3: Git History Investigation

**Step 3.1 — Blame**
Record: Insertion point lines 6734–6735 (`0x85de` → `0x8603`) date from
merge `5d324e5159d9e` (2025-11-28, Linux 6.18 base). Gap at `0x85f0` is
present in this tree.

**Step 3.2 — Fixes: tag**
Record: N/A — no `Fixes:` tag.

**Step 3.3 — Related changes**
Record: This tree already has many similar backported mute-LED quirks:
- `3210077ed2648` — HP Laptop 15s-eq1xxx
  (`ALC236_FIXUP_HP_MUTE_LED_COEFBIT2`)
- `bee43f7b9bc62` — HP Laptop 14s-dr5xxx
- `7556bd5cd8ef3` — HP Laptop 15-fd0xxx
- `a424946e00f2e` — HP Pavilion Laptop 16-ag0xxx
Standalone one-line quirk; no series dependency.

**Step 3.4 — Author context**
Record: Federico Lombardo (hardware reporter/contributor). Takashi Iwai
(maintainer) signed off. Consistent with normal ALSA quirk workflow.

**Step 3.5 — Prerequisites**
Record: `ALC236_FIXUP_HP_MUTE_LED_COEFBIT2` enum, fixup definition, and
`alc236_fixup_hp_mute_led_coefbit2()` all exist in this tree. Patch
applies standalone.

---

## Phase 4: Mailing List and External Research

**Step 4.1 — Original discussion**
Record: Link in commit message could not be fetched (Anubis bot
protection). `b4 dig -c` unavailable — commit not present in this
checkout. UNVERIFIED: full review thread content.

**Step 4.2 — Reviewers**
Record: Takashi Iwai maintainer sign-off confirmed from commit message.
UNVERIFIED: full recipient list from `b4 dig -w`.

**Step 4.3 — Bug report**
Record: No external bug report or syzbot link. Hardware-specific user
report implied by author.

**Step 4.4 — Related patches**
Record: Part of ongoing HP mute-LED quirk additions; same fixup reused
across multiple HP laptops already in this tree.

**Step 4.5 — Stable list**
Record: UNVERIFIED — could not search lore due to bot protection.
Precedent in this tree: similar quirks (e.g. `a424946e00f2e`) were
explicitly backported with `Cc: stable@vger.kernel.org`.

---

## Phase 5: Code Semantic Analysis

**Step 5.1 — Key functions**
Record: `alc269_fixup_tbl[]`, `alc236_fixup_hp_mute_led_coefbit2()`,
`coef_mute_led_set()`, `snd_hda_pick_fixup()`.

**Step 5.2 — Callers**
Record: `snd_hda_pick_fixup(codec, alc269_fixup_models,
alc269_fixup_tbl, alc269_fixups)` called during Realtek codec
initialization (line 8471 in `alc269.c`), i.e. at HDA codec probe on
affected hardware.

**Step 5.3 — Callees**
Record: Fixup configures `spec->mute_led_coef` (idx `0x07`, mask `1`,
on/off values) and registers LED class device via
`snd_hda_gen_add_mute_led_cdev()`. Runtime updates go through
`coef_mute_led_set()` → `alc_update_coef_led()`.

**Step 5.4 — Reachability**
Record: Triggered on boot/module load when HDA Realtek codec probes on
HP Laptop 15-dw0xxx (`103c:85f0`). Common laptop audio path; not
userspace-triggerable for exploitation, but affects all owners of this
hardware.

**Step 5.5 — Similar patterns**
Record: 18+ existing `ALC236_FIXUP_HP_MUTE_LED_COEFBIT2` entries in this
tree, including nearby `0x84ae`, `0x86c1`, `0x8706`, `0x89a0` (HP Laptop
15-dw4xxx). Same fixup, different SSIDs.

---

## Phase 6: Cross-Reference Against Local Tree

**Step 6.1 — Buggy code present?**
Record: **Yes.** Local tree is **Linux 6.18.44**
(`v6.18.44-1-g2736c32da98b9`). `0x85f0` is absent from
`alc269_fixup_tbl[]`; confirmed gap between `0x85de` and `0x8603`.
Prerequisite fixup infrastructure is present.

**Step 6.2 — Backport complications**
Record: Clean one-line apply between existing sorted entries. No
conflicts expected.

**Step 6.3 — Related fixes already present?**
Record: The fixup type and many sibling quirk entries are already
backported; this specific SSID is the only missing piece.

---

## Phase 7: Subsystem and Maintainer Context

**Step 7.1 — Subsystem**
Record: `sound/hda` — ALSA HDA Realtek codec driver. Criticality:
**IMPORTANT** (peripheral driver, but widely used on consumer laptops).

**Step 7.2 — Activity**
Record: Actively maintained — numerous Realtek quirk commits in this
6.18.y tree in 2026, including multiple HP mute-LED entries.

---

## Phase 8: Impact and Risk Assessment

**Step 8.1 — Who is affected**
Record: Owners of HP Laptop 15-dw0xxx with Realtek ALC236 and SSID
`103c:85f0`. Driver-specific, hardware-specific.

**Step 8.2 — Trigger conditions**
Record: Every boot / audio subsystem init on affected hardware. Common
and deterministic for those machines. Not a security vector.

**Step 8.3 — Failure mode severity**
Record: Mute LED does not correctly reflect mic mute state (UX/hardware-
indicator bug). Severity: **LOW** — no crash, corruption, deadlock, or
security impact. Audio itself may still work; only LED sync is wrong.

**Step 8.4 — Risk vs benefit**
Record:
- Benefit: **MEDIUM** for affected HP users (correct mute-LED behavior)
- Risk: **VERY LOW** (one table line, existing fixup, proven pattern)
- Ratio: Strongly favorable; matches established stable practice for HDA
  quirk additions in this tree

---

## Phase 9: Final Synthesis

**Step 9.1 — Evidence compile**

FOR backport:
- Real hardware bug on a specific HP laptop model
- One-line, obviously correct hardware quirk
- Uses existing `ALC236_FIXUP_HP_MUTE_LED_COEFBIT2` already in 6.18.44
- Maintainer (Takashi Iwai) signed off
- Identical class of fix already backported to this tree (e.g.
  `3210077`, `bee43f7b`, `7556bd5`, `a424946e`)
- Fits stable exception category: audio codec hardware quirk
- Clean apply expected

AGAINST backport:
- Not a crash, security, or data-integrity issue
- Affects only one laptop model/SSID
- No `Tested-by:` or explicit stable nomination in provided message
- Mailing list discussion unverified

**Step 9.2 — Stable rules checklist**
1. Obviously correct and tested? **PASS** (pattern proven; maintainer
   ACK; UNVERIFIED: author hardware test)
2. Fixes a real bug affecting users? **PASS** (mute LED broken on
   specific hardware)
3. Important issue? **PASS** (hardware quirk exception — fixes real-
   world hardware behavior; severity LOW but category is standard stable
   material)
4. Small and contained? **PASS** (+1 line)
5. No new features/APIs? **PASS** (table entry only)
6. Can apply to local tree? **PASS**

**Step 9.3 — Exception category**
Record: **Hardware quirk / audio codec quirk** — explicit stable
exception.

**Step 9.4 — Decision rationale**
For Linux 6.18.44, the missing quirk is present, the required fixup
infrastructure exists, and this tree already routinely backports
identical HP mute-LED quirk entries. This is low-risk, hardware-
specific, and matches established stable practice.

---

## Verification

- [Phase 1] Parsed subject, tags, and body from provided commit message
- [Phase 1] Confirmed maintainer sign-off from Takashi Iwai
- [Phase 2] Diff: +1 line `SND_PCI_QUIRK(0x103c, 0x85f0, ...)` in
  `alc269_fixup_tbl[]`
- [Phase 2] Read `alc236_fixup_hp_mute_led_coefbit2()` at lines
  1551–1563
- [Phase 3] `git blame -L 6734,6736`: gap confirmed at `0x85f0`
- [Phase 3] `git log --grep="mute LED"`: multiple similar quirks already
  in 6.18.y
- [Phase 3] `git show 3210077`, `git show a424946e`: confirmed backport
  pattern for same quirk class
- [Phase 4] WebFetch of patch link: blocked (Anubis) — UNVERIFIED
- [Phase 4] `b4 dig -c`: not usable (commit not in tree) — UNVERIFIED
- [Phase 5] `grep alc236_fixup_hp_mute_led_coefbit2`: function and 18+
  quirk users found
- [Phase 5] Read `snd_hda_pick_fixup()` call site at line 8471
- [Phase 6] `git describe HEAD`: v6.18.44-1-g2736c32da98b9
- [Phase 6] `grep 0x85f0 sound/hda/codecs/realtek/alc269.c`: no match —
  quirk missing
- [Phase 6] `grep ALC236_FIXUP_HP_MUTE_LED_COEFBIT2`: fixup present with
  full implementation
- [Phase 8] Assessed severity as LOW (LED UX), risk as VERY LOW

**YES**

 sound/hda/codecs/realtek/alc269.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/hda/codecs/realtek/alc269.c b/sound/hda/codecs/realtek/alc269.c
index 36d5dfa9e1db8..a07f40e9541ee 100644
--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -6732,6 +6732,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x103c, 0x854a, "HP EliteBook 830 G6", ALC285_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x85c6, "HP Pavilion x360 Convertible 14-dy1xxx", ALC295_FIXUP_HP_MUTE_LED_COEFBIT11),
 	SND_PCI_QUIRK(0x103c, 0x85de, "HP Envy x360 13-ar0xxx", ALC285_FIXUP_HP_ENVY_X360),
+	SND_PCI_QUIRK(0x103c, 0x85f0, "HP Laptop 15-dw0xxx", ALC236_FIXUP_HP_MUTE_LED_COEFBIT2),
 	SND_PCI_QUIRK(0x103c, 0x8603, "HP Omen 17-cb0xxx", ALC285_FIXUP_HP_MUTE_LED),
 	SND_PCI_QUIRK(0x103c, 0x860c, "HP ZBook 17 G6", ALC285_FIXUP_HP_GPIO_AMP_INIT),
 	SND_PCI_QUIRK(0x103c, 0x860f, "HP ZBook 15 G6", ALC285_FIXUP_HP_GPIO_AMP_INIT),
-- 
2.53.0

