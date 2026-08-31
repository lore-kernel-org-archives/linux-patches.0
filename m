Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CA3E480DE3;
	Mon, 31 Aug 2026 13:37:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183475; cv=none; b=oJg4ucossgmTIi3SII9ISsQbQUHbqxa9Uoiahxv+ZzjoKE5bxKunPdT8VP/jD65hM2R136XTP1GvhFb7z641QW92wezQJIpj0gKHt3Q5N9XDk+iPewGseTLB41fxEyjxSb5Azk666+dKk+CCBk1eEt9DVsszenXAxI3uvEAHcW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183475; c=relaxed/simple;
	bh=pNubw+5+aSVMFY36eW4w0RpJCAeWJ43LLlapPMcsWEI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GcWX8kmIYZlKXSJcux8w9j/MDiFkWS/AAVDFC+m/sUL6uqvMhrv7/fgER9/ikQrM05sUzeYOMv6dmQREXtuT+2vFjPl21zJxm1xnxVf0pXxteixrFcZeIoiYOlpL4gsG0wJobl5kfR9cL9D/tiyb0HR24a2U8pnJJrW5u2jp+KA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ib22Km/U; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ib22Km/U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED2001F00A3E;
	Mon, 31 Aug 2026 13:37:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183473;
	bh=Pj2FSw1poSAmPV2lX6oQg5rInI7GCnGYK+m0SbnK8VE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ib22Km/UV0YLLgAqWtsKPBt6iMwygk+ZH/9dsdttc64LgOWd8dYEI4A/lVP9ZVvqS
	 g/55t8Aw9/PuZhVRYwwA1o1r4rh6hrIQqqZkPlhd1hXyfjvdX37KrEq5HgJ+IyEjfW
	 99Uy0cBTr7lkFdn391ClBIEEWHMgmBRzzhcI114lTZ80hdlvzGahaRjpex1zTxHHWh
	 1bWr4C9v4lwa6pUuIcV7b9F/NcRRnA0tH1AZhVN8DLX2efgW0XrE4+OV2FMFuIAMNY
	 SKAee4ua+xHTx2fbd3pVQu4QpTyq62Vd3zqiwJobfXdwQI6+9w6alAuJ50V1LjIItF
	 0+5CTB2T+8rjA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Oliver Ohrt <oliver@theohrts.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>,
	perex@perex.cz,
	tiwai@suse.com,
	linux-sound@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] ALSA: hda/realtek: Fix speakers on Alienware x16 R2
Date: Mon, 31 Aug 2026 09:22:25 -0400
Message-ID: <20260831133314.4125787-117-sashal@kernel.org>
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

From: Oliver Ohrt <oliver@theohrts.com>

[ Upstream commit 914c85fad93cd7daad30e5fb2e5bc7132ea25524 ]

The Alienware x16 R2 has two pairs of speakers, but the BIOS
marks pin 0x17 as unused, so only the pin 0x14 pair plays and
audio is very quiet/dull.

Apply ALC289_FIXUP_DUAL_SPK like on other Dell machines to set
up pin 0x17 and route it to DAC1. Tested on my x16 R2 with
kernel 6.18.38, and now all speakers play at full volume.

Signed-off-by: Oliver Ohrt <oliver@theohrts.com>
Link: https://patch.msgid.link/20260715070409.42696-1-oliver@theohrts.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: ALSA: hda/realtek: Fix speakers on Alienware
x16 R2

**Local tree:** `v6.18.44-1-g2736c32da98b9` (kernel 6.18.44)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Parse the subject line
**Record:** `[ALSA: hda/realtek]` `[Fix]` — Add HDA codec quirk so
Alienware x16 R2 internal speakers work at full volume.

### Step 1.2: Parse all commit message tags
**Record:**
- **Fixes:** — not present (expected for manual review)
- **Reported-by:** — not present
- **Tested-by:** — not present (author says "Tested on my x16 R2" in
  body)
- **Reviewed-by:** — not present
- **Acked-by:** — not present
- **Link:**
  `https://patch.msgid.link/20260715070409.42696-1-oliver@theohrts.com`
- **Cc: stable@vger.kernel.org** — not present (not a negative signal)
- **Signed-off-by:** Oliver Ohrt `<oliver@theohrts.com>` (author)
- **Signed-off-by:** Takashi Iwai `<tiwai@suse.de>` (ALSA/HDA
  maintainer)
- **Notable:** Maintainer sign-off; author hardware testing; no
  syzbot/sanitizer signals

### Step 1.3: Analyze commit body
**Record:**
- **Bug:** Alienware x16 R2 has two speaker pairs; BIOS marks pin 0x17
  unused, so only pin 0x14 pair is routed. Audio is very quiet/dull.
- **Symptom:** Half the speakers inactive; poor volume/quality.
- **Root cause:** Incorrect BIOS pin configuration for second speaker
  pair (NID 0x17).
- **Fix approach:** Apply existing `ALC289_FIXUP_DUAL_SPK` (same as
  other Dell machines) to configure pin 0x17 and route to DAC1.
- **Testing:** Author tested on x16 R2 with kernel 6.18.38; all speakers
  play at full volume.
- **Version info:** Tested on 6.18.38; hardware is recent (Alienware x16
  R2).

### Step 1.4: Detect hidden bug fixes
**Record:** Not disguised — explicit hardware/audio functionality fix.
Classic HDA codec quirk, not cleanup or refactor.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory the changes
**Record:**
- **Files:** `sound/hda/codecs/realtek/alc269.c` — 1 line added
- **Functions modified:** None directly; `alc269_fixup_tbl[]` quirk
  table only
- **Scope:** Single-file, one-line surgical quirk addition

### Step 2.2: Code flow change
**Record:**
- **Before:** PCI SSID `0x1028:0x0c90` (Alienware x16 R2) has no quirk →
  default pin config → pin 0x17 unused → only one speaker pair active.
- **After:** Quirk maps `0x1028:0x0c90` → `ALC289_FIXUP_DUAL_SPK` →
  during codec probe (`snd_hda_pick_fixup()`), chained fixups run:
  1. `alc285_fixup_speaker2_to_dac1` — routes NID 0x17 (bass speaker) to
     DAC1 (0x02)
  2. `ALC289_FIXUP_DELL_SPK2` — sets pin 0x17 config to `0x90170130`
- **Path affected:** Codec probe/initialization on matching hardware
  only.

### Step 2.3: Bug mechanism
**Record:**
- **Category:** Hardware quirk / pin-configuration fix
- **Mechanism:** BIOS marks pin 0x17 unused despite hardware being
  connected. Existing Dell dual-speaker fixup reconfigures pin 0x17 and
  routes it to DAC1, enabling the second speaker pair.

### Step 2.4: Fix quality assessment
**Record:**
- **Obviously correct:** Yes — reuses `ALC289_FIXUP_DUAL_SPK` already
  applied to Dell XPS 15 9520, Precision 5570, XPS 15 9510, etc.
- **Minimal/surgical:** One `SND_PCI_QUIRK()` line
- **Regression risk:** Very low — only affects `0x1028:0x0c90`; fixup
  chain is well-tested on similar Dell hardware
- **Red flags:** None

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame changed lines
**Record:** Insertion point is in `alc269_fixup_tbl[]` between `0x0c4d`
and `0x0c94`. Surrounding Dell quirks from merge `5d324e5159d9e`
(v6.18-rc8 era). No “buggy code” introduced by a prior commit — missing
quirk for new hardware.

### Step 3.2: Follow Fixes: tag
**Record:** N/A — no `Fixes:` tag.

### Step 3.3: File history for related changes
**Record:** Recent similar commits in this tree:
- `2ec8f95a08fed` — Fix speakers on Lunnen Ground 14 (pin quirk, `Cc:
  stable`, backported)
- `6b2c0cd5f9689` — Fix speakers on Legion Pro 7 (codec SSID quirk, `Cc:
  stable`, backported)
- Multiple Dell `ALC289_FIXUP_DUAL_SPK` entries at lines 6618–6623

Standalone one-line quirk; no series dependency.

### Step 3.4: Author's other commits
**Record:** No other commits from Oliver Ohrt in this tree. Takashi Iwai
is ALSA maintainer.

### Step 3.5: Prerequisites
**Record:**
- **Required:** `ALC289_FIXUP_DUAL_SPK`,
  `alc285_fixup_speaker2_to_dac1`, `ALC289_FIXUP_DELL_SPK2` — all
  present in 6.18.44
- **Can apply standalone:** Yes — single quirk line, no dependencies
- **Commit not yet in tree:** `0x0c90` quirk absent; patch applies
  cleanly at line 6640

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Original patch discussion
**Record:** `b4 dig -c` not run — commit hash not in local tree. Link
points to `20260715070409.42696-1-oliver@theohrts.com`. Lore fetch
blocked by Anubis bot protection. **UNVERIFIED:** full review thread
content.

### Step 4.2: Reviewers
**Record:** **UNVERIFIED** via b4 dig -w. Takashi Iwai maintainer sign-
off confirms acceptance.

### Step 4.3: Bug report
**Record:** No external bug report; author-reported hardware issue with
on-device testing.

### Step 4.4: Related patches/series
**Record:** Standalone patch; pattern matches other Dell dual-speaker
quirks and recent stable-bound speaker fixes.

### Step 4.5: Stable mailing list history
**Record:** **UNVERIFIED** — lore blocked. Comparable fixes
(`2ec8f95a08fed`, `6b2c0cd5f9689`) include `Cc: stable@vger.kernel.org`
and were backported.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key functions
**Record:** Indirectly affects probe path via `snd_hda_pick_fixup()` →
matched quirk chain. Direct code touch: `alc269_fixup_tbl[]` only.

### Step 5.2: Callers
**Record:** `snd_hda_pick_fixup(codec, alc269_fixup_models,
alc269_fixup_tbl, alc269_fixups)` at line 8471, called from Realtek
codec init during HDA driver probe (module load / device enumeration).

### Step 5.3: Callees (fixup chain)
**Record:**
- `alc285_fixup_speaker2_to_dac1` — `snd_hda_override_conn_list(codec,
  0x17, ...)` at PRE_PROBE
- `ALC289_FIXUP_DELL_SPK2` — pin table `{ 0x17, 0x90170130 }`

### Step 5.4: Call chain / reachability
**Record:** Triggered at boot when HDA codec probes on Alienware x16 R2
(`0x1028:0x0c90`). Not userspace-triggerable; affects all users of that
hardware on every boot.

### Step 5.5: Similar patterns
**Record:** `ALC289_FIXUP_DUAL_SPK` used for at least 6 other Dell PCI
IDs (0x097d, 0x097e, 0x0a61, 0x0a62, 0x0b19, 0x0b1a). Same pin 0x17 /
dual-speaker pattern.

---

## PHASE 6: CROSS-REFERENCING AGAINST LOCAL TREE

### Step 6.1: Does the buggy situation exist?
**Record:** Yes. `0x0c90` quirk missing in 6.18.44 (`grep` found no
match). Without it, x16 R2 gets default handling and second speaker pair
stays disabled. Not a regression from a specific commit — omission for
new hardware.

### Step 6.2: Backport complications
**Record:** **Clean apply** — insertion between existing `0x0c4d` and
`0x0c94` entries matches upstream diff exactly.

### Step 6.3: Related fixes already present?
**Record:** No existing fix for `0x0c90`. Underlying
`ALC289_FIXUP_DUAL_SPK` infrastructure is present.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: Subsystem criticality
**Record:** `sound/hda/codecs/realtek` — IMPORTANT (audio driver
quirks). Affects Alienware x16 R2 owners only.

### Step 7.2: Subsystem activity
**Record:** Active — frequent quirk additions in 6.18.y (TongFang, HP,
Lunnen, Legion, ASUS, etc.).

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Who is affected
**Record:** Alienware x16 R2 users (Dell/Alienware PCI vendor `0x1028`,
subsystem `0x0c90`) on kernels without this quirk.

### Step 8.2: Trigger conditions
**Record:** Every boot with internal speakers on matching hardware.
Common path for affected users; not timing-dependent.

### Step 8.3: Failure mode severity
**Record:** Quiet/dull audio with only half the speakers active.
**Severity: MEDIUM** — functional degradation, not
crash/corruption/security. Matches stable rules’ “hardware quirk” and
“real bug that bothers people.”

### Step 8.4: Risk-benefit
**Record:**
- **Benefit:** Restores full speaker output on affected laptops; same
  proven fixup as other Dell models
- **Risk:** Very low — one quirk entry, hardware-specific SSID match
- **Ratio:** Strong benefit, minimal risk for affected hardware

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence compile

**FOR backporting:**
- Fixes real user-visible hardware bug (impaired speaker output)
- One-line, contained hardware quirk using existing fixup
- Author tested on target hardware; maintainer (Iwai) signed off
- `ALC289_FIXUP_DUAL_SPK` and full fixup chain exist in 6.18.44
- Applies cleanly to this tree
- Explicit stable-rules exception: hardware quirk
- Precedent: similar speaker quirk fixes backported with `Cc: stable`

**AGAINST backporting:**
- Not crash/security/data corruption (lower urgency than KASAN fixes)
- Affects narrow hardware population
- No `Cc: stable` tag (not disqualifying)
- Lore review thread not accessible

**UNRESOLVED:**
- Full mailing list review discussion
- Whether reviewers explicitly nominated for stable

### Step 9.2: Stable rules checklist
1. Obviously correct and tested? **PASS** — reuses proven Dell fixup;
   author hardware test; maintainer SOB
2. Fixes real bug affecting users? **PASS** — half speakers inactive,
   quiet/dull audio
3. Important issue? **PASS** — hardware quirk / functional audio bug
   (stable-rules category)
4. Small and contained? **PASS** — 1 line
5. No new features/APIs? **PASS** — quirk table entry only
6. Can apply to local tree? **PASS** — prerequisites present; clean
   apply

### Step 9.3: Exception categories
**Record:** Hardware quirk/workaround for HDA codec pin configuration —
automatic stable candidate per `stable-kernel-rules.rst` and analysis
guidelines.

### Step 9.4: Decision rationale
For **6.18.y**, this is a textbook stable backport: a one-line PCI quirk
mapping a new Dell/Alienware SSID to an existing, well-tested dual-
speaker fixup. The infrastructure exists in this tree, the patch applies
cleanly, and users of Alienware x16 R2 on 6.18.y currently get degraded
speaker output without it.

---

## Verification

- **[Phase 1]** Parsed subject, tags, body from user-provided commit
  message
- **[Phase 2]** Diff: 1 line `SND_PCI_QUIRK(0x1028, 0x0c90, ...)` in
  `alc269.c`
- **[Phase 2]** Read `alc285_fixup_speaker2_to_dac1` at lines 2532–2540
- **[Phase 2]** Read `ALC289_FIXUP_DUAL_SPK` chain at lines 5346–5350,
  `ALC289_FIXUP_DELL_SPK2` at 5337–5344
- **[Phase 3]** `git describe HEAD`: v6.18.44
- **[Phase 3]** `grep 0x0c90`: no matches — quirk absent
- **[Phase 3]** `git blame` lines 6620–6630: surrounding quirks from
  5d324e5159d9e
- **[Phase 3]** `git log -S ALC289_FIXUP_DUAL_SPK`: present since
  5d324e5159d9e merge
- **[Phase 3]** `git show 2ec8f95a08fed`, `6b2c0cd5f9689`: comparable
  stable-bound speaker fixes
- **[Phase 4]** WebFetch lore URL: blocked (Anubis)
- **[Phase 4]** `b4 dig -c`: not run — commit not in tree
- **[Phase 5]** `grep snd_hda_pick_fixup`: line 8471 in codec init
- **[Phase 5]** `grep ALC289_FIXUP_DUAL_SPK`: 6+ existing Dell entries
- **[Phase 6]** Read lines 6639–6641: exact insertion point matches
  patch
- **[Phase 6]** `grep Alienware x16`: only in `alienware-wmi-wmax.c`,
  not audio quirk
- **[Phase 7]** `git log --oneline -20 -- sound/hda/codecs/realtek/`:
  active quirk development
- **[Phase 8]** Read `Documentation/process/stable-kernel-rules.rst`:
  hardware quirks explicitly accepted

**YES**The backport analysis is done for **ALSA: hda/realtek: Fix
speakers on Alienware x16 R2** on your **6.18.44** tree.

**Verdict: YES** — backport it.

It’s a one-line PCI quirk (`0x1028:0x0c90` → `ALC289_FIXUP_DUAL_SPK`)
that enables the second speaker pair on Alienware x16 R2. The fixup
chain already exists in this tree, the patch applies cleanly between the
`0x0c4d` and `0x0c94` entries, and it matches the usual stable pattern
for HDA hardware quirks (same approach as other Dell dual-speaker
fixes).

 sound/hda/codecs/realtek/alc269.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/hda/codecs/realtek/alc269.c b/sound/hda/codecs/realtek/alc269.c
index 7f3e1c47729a1..b7dad90ac9cd4 100644
--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -6660,6 +6660,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1028, 0x0c1e, "Dell Precision 3540", ALC236_FIXUP_DELL_DUAL_CODECS),
 	SND_PCI_QUIRK(0x1028, 0x0c28, "Dell Inspiron 16 Plus 7630", ALC295_FIXUP_DELL_INSPIRON_TOP_SPEAKERS),
 	SND_PCI_QUIRK(0x1028, 0x0c4d, "Dell", ALC287_FIXUP_CS35L41_I2C_4),
+	SND_PCI_QUIRK(0x1028, 0x0c90, "Alienware x16 R2", ALC289_FIXUP_DUAL_SPK),
 	SND_PCI_QUIRK(0x1028, 0x0c94, "Dell Polaris 3 metal", ALC295_FIXUP_DELL_TAS2781_I2C),
 	SND_PCI_QUIRK(0x1028, 0x0c96, "Dell Polaris 2in1", ALC295_FIXUP_DELL_TAS2781_I2C),
 	SND_PCI_QUIRK(0x1028, 0x0cbd, "Dell Oasis 13 CS MTL-U", ALC289_FIXUP_DELL_CS35L41_SPI_2),
-- 
2.53.0

