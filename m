Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 183985BE67A;
	Mon, 19 Oct 2026 14:01:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418468; cv=none; b=KZJatxGYuXiHBQPxIGLcwxjkT+WYdw/oxn9eGtnuuRW3vELjtZPDz634YSLcp8D5Zpgc35ag3QPR/F13qpNPIxFQKXKFUiCcOISd3u9vlfH5gZRd+dbD9hPUUDXZOWSK5SLcqIS6ubH00muOiTxMqg7yPrWrqm+COdEOG/EjtK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418468; c=relaxed/simple;
	bh=4NjTx8XdW50H5bbuTROplug+5EW0agz+1V/XruY5rec=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VfHj0ixBdGpnnGxuJT6lSnF2GuPhwIxHQkDxgL4Mwt5FoNqTN0CfMy1XKtp3H0khi+rRwINKeaF/EuyQJtf5OnIZDEsaIhcxrX+wTQIVP4AR7nC01BDueBVmD4va1Le48qO0DMsrWyaP25L0P8SUJo3lwzqaE/mashHpjQRtmyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bdgBe6gs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bdgBe6gs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16DDC1F000C8;
	Mon, 19 Oct 2026 14:01:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418466;
	bh=exWpYuFcOfGsyhXx78/xtwD0VeLLPrL+e4s4PSQ6iTs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bdgBe6gsozJC/6PKFM6Zo/meu3g/yXf5r6dMpQaKZAhjqigmCg7RfnMRNhkn/W1v4
	 VoGyrR8h3uzv6GrqplatT4TbHFQwWJN5v51CE3OWOCYkaBvnO3lGMxWzI1UZssfQc2
	 B2DH3FLFosXyU1YLhW5Hdyqfid2BYeZsSlB+qTFbYwxKShTFzQc7fVKXyOTLobIVB+
	 6gQNwufGZlZK+59Mzp7C2HkPbYys60We5MufbNz8nGaL5E0L99EvtUAQyhrsuW7pye
	 CwKeCNi3O17oYalNB6sNJIa0/bxisRKLI5uIE7iuO3VJxTCSElqKQ9YAvaEhSD41jU
	 nz/3lBrOSnFVw==
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
Subject: [PATCH AUTOSEL 6.18-6.12] ALSA: hda/realtek: Add quirk for Lenovo ThinkBook G8+
Date: Mon, 19 Oct 2026 09:49:19 -0400
Message-ID: <20261019135441.1420968-268-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261019135441.1420968-1-sashal@kernel.org>
References: <20261019135441.1420968-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.57
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Zhang Heng <zhangheng@kylinos.cn>

[ Upstream commit 4322ac247f4ce7932edbd46aa37f3dae62cde424 ]

Fix Bass Speaker volume control on Lenovo ThinkBook G8+ by adding
quirk 17aa:38dc with ALC285_FIXUP_SPEAKER2_TO_DAC1.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=221799
Signed-off-by: Zhang Heng <zhangheng@kylinos.cn>
Link: https://patch.msgid.link/20260921124450.639601-1-zhangheng@kylinos.cn
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The local tree is **6.18.57**. The ThinkBook G8+ SSID is not in
`v6.18.57`; the existing `ALC285_FIXUP_SPEAKER2_TO_DAC1` path is, so
this is a one-line hardware quirk that belongs in this series.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1: PARSE THE SUBJECT LINE**

Record: `[ALSA/hda/realtek] [Add] [quirk for Lenovo ThinkBook G8+ to fix
bass speaker volume]`

- Subsystem: `ALSA: hda/realtek`
- Verb: `Add` (hardware quirk, not a new API)
- Intent: enable an existing Realtek fixup for PCI SSID `17aa:38dc`

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**

Record:
- `Link: https://bugzilla.kernel.org/show_bug.cgi?id=221799` — user-
  filed hardware bug
- `Link:
  https://patch.msgid.link/20260921124450.639601-1-zhangheng@kylinos.cn`
  — original submission
- `Signed-off-by: Zhang Heng <zhangheng@kylinos.cn>` — author
- `Signed-off-by: Takashi Iwai <tiwai@suse.de>` — ALSA maintainer
- No `Fixes:` tag (expected; this adds a device match, it does not
  revert an earlier logic bug)
- No `Reported-by:` / `Tested-by:` / `Reviewed-by:` / `Cc: stable`
  (absence is expected)
- Pipeline markers (`[Upstream commit 4322ac247f4ce…]`, `Signed-off-by:
  Sasha Levin`) ignored per instructions

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**

Record:
- Bug: bass speaker volume control is broken on Lenovo ThinkBook G8+
- Symptom: users cannot control bass speaker volume
- Root cause (from the existing fixup, not restated in this commit): NID
  0x17 (bass speaker) is not routed to DAC1 (0x02), so volume amp is
  missing
- Fix: match SSID `17aa:38dc` to `ALC285_FIXUP_SPEAKER2_TO_DAC1`
- Version info: none in the message; patch dated 2026-09-21, applied by
  Takashi Iwai 2026-09-28

**Step 1.4: DETECT HIDDEN BUG FIXES**

Record: Not a disguised cleanup. This is an explicit hardware quirk for
a documented laptop audio defect.

---

## PHASE 2: DIFF ANALYSIS

**Step 2.1: INVENTORY THE CHANGES**

Record:
- File: `sound/hda/codecs/realtek/alc269.c` (`+1 / -0`)
- Function/table: `alc269_fixup_tbl[]`
- Scope: single-file, one-line surgical addition

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**

Record:
- Before: PCI SSID `17aa:38dc` has no quirk; generic Realtek auto-config
  is used
- After: that SSID selects `ALC285_FIXUP_SPEAKER2_TO_DAC1` at codec
  probe
- Path: HDA codec probe / pin-config fixup (init path), not a hot path
  or error path
- Only machines with that SSID are affected

**Step 2.3: IDENTIFY THE BUG MECHANISM**

Record:
- Category: hardware workaround / codec quirk (`SND_PCI_QUIRK`)
- Mechanism: `alc285_fixup_speaker2_to_dac1()` on
  `HDA_FIXUP_ACT_PRE_PROBE` calls `snd_hda_override_conn_list(codec,
  0x17, …, {0x02})`, forcing the bass-speaker pin onto DAC1 so volume
  control works
- The fixup is also chained to `ALC269_FIXUP_THINKPAD_ACPI` (Lenovo ACPI
  hooks), which is the same chain already used for Yoga Pro 7 14ARP8
  (`17aa:386e`)

**Step 2.4: ASSESS THE FIX QUALITY**

Record:
- Obviously correct: one table entry using an existing, long-lived fixup
- Minimal: no unrelated edits
- Regression risk: low and SSID-scoped. Wrong SSID would mis-route audio
  on that ID only; `17aa:38dc` is unused in this tree’s HDA tables
- No public API / data-structure change

---

## PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1: BLAME THE CHANGED LINES**

Record:
- This is a new table row, not a change to old lines
- Neighboring Lenovo SSIDs (`0x38d7`, `0x38df`) already exist in
  `v6.18.57`
- `alc285_fixup_speaker2_to_dac1` / bass-speaker-to-DAC pattern dates to
  `e79c22695abd3` (2019; originally `Cc: stable`)
- Same enum used for Yoga Pro 7 14ARP8 in `1a49509885cd9` (2024-06-16),
  which **is** an ancestor of `v6.18.57`

**Step 3.2: FOLLOW THE FIXES: TAG**

Record: No `Fixes:` tag. Not applicable. The “bug” is missing hardware
enablement for this SSID, not a regression of a prior commit.

**Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**

Record:
- Recent `alc269.c` history is dominated by similar `SND_PCI_QUIRK`
  additions
- Submitted as `[PATCH 1/2]`; 2/2 is an unrelated Acer Nitro headset-mic
  quirk (`1025:151e`). Not a prerequisite
- Standalone

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**

Record:
- Zhang Heng is a regular Realtek quirk contributor (ASUS, Lenovo, HP,
  Samsung entries in this file)
- Not the subsystem maintainer; Takashi Iwai applied the patch

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**

Record:
- Needs `ALC285_FIXUP_SPEAKER2_TO_DAC1`,
  `alc285_fixup_speaker2_to_dac1()`, `ALC269_FIXUP_THINKPAD_ACPI`,
  `snd_hda_override_conn_list()`, and `alc269_fixup_tbl[]`
- All present in `v6.18.57`
- Can apply standalone

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**

Record:
- `b4 dig -c 4322ac247f4ce7932edbd46aa37f3dae62cde424` →
  https://patch.msgid.link/20260921124450.639601-1-zhangheng@kylinos.cn
- Series: **v1 only** (`[PATCH 1/2]`)
- Takashi Iwai reply (`875wzp5yr7.wl-tiwai@suse.de`, 2026-09-28):
  “Applied both patches. Thanks.”
- No NAK, no requested revision, no stable-risk comments

**Step 4.2: CHECK WHO REVIEWED THE PATCH**

Record (`b4 dig -w`):
- To: `tiwai@suse.com` (ALSA maintainer)
- Cc: `linux-sound@vger.kernel.org`, `linux-kernel@vger.kernel.org`
- Maintainer applied it after review

**Step 4.3: SEARCH FOR THE BUG REPORT**

Record:
- Commit cites bugzilla 221799
- Direct fetch of bugzilla/lore HTML was blocked by Anubis/captcha (403
  / bot check)
- UNVERIFIED: bugzilla comment text, number of duplicates, reporter
  hardware dump
- Verified: author and maintainer treated it as a real bass-speaker
  volume bug for SSID `17aa:38dc`

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**

Record:
- 2/2 is an independent Acer quirk, not required here
- Same fixup already used for Lenovo Yoga Pro 7 14ARP8 in this tree

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**

Record: lore.kernel.org/stable search blocked by Anubis. UNVERIFIED
whether anyone already asked for this on stable@. No in-tree evidence of
a prior rejection.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1: IDENTIFY KEY FUNCTIONS**

Record:
- Modified: `alc269_fixup_tbl[]` (data)
- Invoked fixup: `alc285_fixup_speaker2_to_dac1()`
- Lookup at probe: `alc269_fixup_tbl` passed into the generic HDA fixup
  picker (around line 8558 in this checkout / 8528 in `v6.18.57`)

**Step 5.2: TRACE CALLERS**

Record:
- Table is consulted during Realtek ALC269-family codec probe
- Triggered by HDA bus enumeration of matching PCI SSID
- Not IRQ/hot-path; once per codec init

**Step 5.3: TRACE CALLEES**

Record:
- `snd_hda_override_conn_list()` — present in `v6.18.57`
  (`include/sound/hda_codec.h`)
- Chained `ALC269_FIXUP_THINKPAD_ACPI` — present in `v6.18.57`

**Step 5.4: FOLLOW THE CALL CHAIN**

Record:
- Userspace-reachable: yes, by using the laptop’s speakers / mixer
- Unprivileged users cannot attack other machines; they only exercise
  this laptop’s audio path
- Impact is functional (bass volume), not a kernel crash

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**

Record:
- Same fixup already bound to Yoga Pro 7 14ARP8 (`SND_PCI_QUIRK(0x17aa,
  0x386e, …, ALC285_FIXUP_SPEAKER2_TO_DAC1)`)
- Many other `SND_PCI_QUIRK` Lenovo entries in the same table
- Systematic, well-worn pattern

---

## PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**

Record:
- Tree: `git describe HEAD` → `v6.18.57-155-gcdf239ca885b2`; `make
  kernelversion` → `6.18.57`
- `git merge-base --is-ancestor 4322ac247f4ce7932edbd46aa37f3dae62cde424
  v6.18.57` → **NO** (upstream commit not in 6.18.57)
- `git grep 0x38dc v6.18.57 -- sound/hda/codecs/realtek/alc269.c` →
  **absent**
- The missing-quirk bug **does** exist in this series
- Driver, fixup enum, and function **do** exist

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**

Record:
- Dry-run of the upstream hunk onto
  `v6.18.57:sound/hda/codecs/realtek/alc269.c`: **Hunk #1 succeeded at
  7538 (offset -726 lines)**
- Expected difficulty: clean apply (line-offset only)
- Neighboring context (`0x38d7` Yoga 9, then `0x38df` Yoga Y990) matches

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**

Record:
- No other `17aa:38dc` HDA quirk in `v6.18.57`
- No alternate ThinkBook G8+ fix
- (HEAD currently contains the autosel candidate copy; ignored as
  pipeline state)

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

**Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY**

Record:
- Subsystem: ALSA HD-audio Realtek codec (`sound/hda/codecs/realtek/`)
- Criticality: IMPORTANT (very common laptop audio), not core
  mm/scheduler
- Affects only Lenovo ThinkBook G8+ (`17aa:38dc`)

**Step 7.2: ASSESS SUBSYSTEM ACTIVITY**

Record:
- Mature but active: `v6.18.57` already contains many similar quirk
  backports (HP, Lenovo, ASUS)
- Typical stable material for this file

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1: DETERMINE WHO IS AFFECTED**

Record: driver-specific / machine-specific — owners of Lenovo ThinkBook
G8+ with PCI SSID `17aa:38dc`

**Step 8.2: DETERMINE THE TRIGGER CONDITIONS**

Record:
- Trigger: boot / audio init on that laptop, then using speaker volume
- Common for those users (every session)
- Not a security trigger; not a race

**Step 8.3: DETERMINE THE FAILURE MODE SEVERITY**

Record:
- Failure mode: bass speaker volume control does not work (wrong DAC
  routing)
- Severity: MEDIUM functionally, but this is an explicit **hardware
  quirk** exception that stable routinely takes
- Not a panic/UAF/corruption

**Step 8.4: CALCULATE RISK-BENEFIT RATIO**

Record:
- Benefit: high for affected hardware (makes volume control work); zero
  for everyone else
- Risk: very low (1 line, existing fixup, SSID-matched)
- Ratio: strongly favors backport

---

## PHASE 9: FINAL SYNTHESIS

**Step 9.1: COMPILE THE EVIDENCE**

FOR:
- Real hardware bug with bugzilla link
- One-line `SND_PCI_QUIRK` using an existing fixup already in 6.18.57
- ALSA maintainer applied it with no objections
- Same pattern as Yoga Pro 7 14ARP8 in this tree
- Applies cleanly to `v6.18.57`
- Explicit stable exception: audio codec quirks

AGAINST:
- Not a crash/security/data-corruption issue
- Affects one laptop SSID
- Bugzilla body could not be fetched (captcha)

UNRESOLVED:
- Full bugzilla 221799 text
- Whether stable@ already discussed this commit

Those gaps do not outweigh the verified quirk itself.

**Step 9.2: APPLY THE STABLE RULES CHECKLIST**

1. Obviously correct and tested? **PASS** — 1-line table entry;
   maintainer applied; existing fixup
2. Fixes a real bug that affects users? **PASS** — broken bass volume on
   ThinkBook G8+
3. Important issue? **PASS** under the hardware-quirk exception (pin/DAC
   routing so speakers are controllable)
4. Small and contained? **PASS** — +1 line, one file
5. No new features or APIs? **PASS** — no new fixup, no new kAPI; device
   ID/quirk only
6. Can apply to the local tree? **PASS** — dry-run succeeded on
   `v6.18.57`

**Step 9.3: CHECK FOR EXCEPTION CATEGORIES**

Record: **Hardware quirk / workaround** (ALSA Realtek `SND_PCI_QUIRK`
for a specific laptop). This is the documented stable exception for
codec quirks.

**Step 9.4: DECISION**

This should be backported to this 6.18.y tree. The driver and fixup are
already here; only the SSID match is missing. That is exactly the class
of change stable takes for laptop audio.

---

### What the commit solves and why it matters

Without the quirk, ThinkBook G8+ (`17aa:38dc`) leaves the bass speaker
pin on a DAC without volume amp, so bass volume cannot be controlled.
The one-line match sends that SSID through
`alc285_fixup_speaker2_to_dac1()`, which is already used for other
Lenovo dual-speaker machines in this tree.

### Stable rules / risk

It is small, obviously correct, introduces no API, and is SSID-scoped.
Apply risk is an offset-only hunk. Benefit is real for users of that
laptop on 6.18.y; risk to other machines is negligible.

### Concerns

None that block backport. Series 2/2 is unrelated. Bugzilla details were
not readable due to captcha, but the code, existing fixup, and
maintainer accept are sufficient.

Verification:
- [Phase 1] Parsed subject/tags: quirk add; bugzilla 221799; Iwai SOB;
  no Fixes tag
- [Phase 2] Diff: +1 `SND_PCI_QUIRK(0x17aa, 0x38dc, …,
  ALC285_FIXUP_SPEAKER2_TO_DAC1)` in `alc269_fixup_tbl`
- [Phase 2] Read `alc285_fixup_speaker2_to_dac1()` at `alc269.c:2532`:
  overrides NID 0x17 conn list to DAC 0x02; chained to
  `ALC269_FIXUP_THINKPAD_ACPI`
- [Phase 3] `git merge-base --is-ancestor 4322ac247f4ce v6.18.57` → NO
  (not already in 6.18.57)
- [Phase 3] Fixup enum/function present in `v6.18.57` (`alc269.c:3791`,
  `:4907`, Yoga Pro 7 use at `:7492`)
- [Phase 3] Similar Lenovo quirk `1a49509885cd9` is an ancestor of
  `v6.18.57`
- [Phase 3] Series 2/2 is an independent Acer quirk; not a dependency
- [Phase 4] `b4 dig -c 4322ac247f4ce`: lore/msgid
  `20260921124450.639601-1-zhangheng@kylinos.cn`; v1 only
- [Phase 4] `b4 dig -w`: To Iwai, Cc linux-sound
- [Phase 4] mbox: Iwai “Applied both patches. Thanks.”; no NAK
- [Phase 4] UNVERIFIED: bugzilla 221799 body (Anubis/403); stable@
  search (Anubis)
- [Phase 5] Table consumed at Realtek codec probe;
  `snd_hda_override_conn_list` exists in `v6.18.57`
- [Phase 6] `git describe HEAD` / `make kernelversion`: 6.18.57;
  `0x38dc` absent from `v6.18.57` alc269.c
- [Phase 6] `patch --dry-run` of upstream hunk onto `v6.18.57` file:
  succeeded at line 7538
- [Phase 8] Failure mode: bass speaker volume broken on one Lenovo SSID;
  quirk-scoped
- UNVERIFIED: exact bugzilla reporter comments and whether stable@
  already nominated this

**YES**

 sound/hda/codecs/realtek/alc269.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/hda/codecs/realtek/alc269.c b/sound/hda/codecs/realtek/alc269.c
index b1cb93922c3bc..6afb35769f746 100644
--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -7572,6 +7572,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x17aa, 0x38d5, "Yoga S990-16 Pro IMH YC Quad", ALC287_FIXUP_TAS2781_I2C),
 	SND_PCI_QUIRK(0x17aa, 0x38d6, "Yoga S990-16 Pro IMH VECO Quad", ALC287_FIXUP_TAS2781_I2C),
 	SND_PCI_QUIRK(0x17aa, 0x38d7, "Lenovo Yoga 9 14IMH9", ALC287_FIXUP_YOGA9_14IMH9_BASS_SPK_PIN),
+	SND_PCI_QUIRK(0x17aa, 0x38dc, "Lenovo ThinkBook G8", ALC285_FIXUP_SPEAKER2_TO_DAC1),
 	SND_PCI_QUIRK(0x17aa, 0x38df, "Yoga Y990 Intel YC Dual", ALC287_FIXUP_TAS2781_I2C),
 	SND_PCI_QUIRK(0x17aa, 0x38e0, "Yoga Y990 Intel VECO Dual", ALC287_FIXUP_TAS2781_I2C),
 	SND_PCI_QUIRK(0x17aa, 0x38f8, "Yoga Book 9i", ALC287_FIXUP_TAS2781_I2C),
-- 
2.53.0

