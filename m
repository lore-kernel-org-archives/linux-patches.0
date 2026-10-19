Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16709549FE8;
	Mon, 19 Oct 2026 13:56:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418198; cv=none; b=qd0ydzIkviI8GkcUxDeYsqpADttWqADwhfYKojWGdiG8S9DbNGCGT/veU5/SMrg9Ogq3UCdPDsz9zXHtaDxKGGHEuNKGQs+/npMQBiNZMZciiRYbh4IBmDCKr0bm4PEBQ0UKk5Gur0MWg+5snAOg1RzEPkg5nWFLvZdtVx18J/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418198; c=relaxed/simple;
	bh=oo8OmNd7PFkwcBm9mFfdSsWqNFY7K44HIBsli4h8vwE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XXeLOO5R2ZQW267FKZyk0pu3viFunoSnPeKbC/fWvXtgWPOlJwjgYoAKX0z5w3OcKLea9QGbuQx/ylj/hiWPEBc5uwW2b7Sw9G/jhR4kQvRBaI10J3MY5cNz0l5pMd2rwUOGOSZ0tPv/nWIRtGey5JuWqs0eBeO596mN3R/AUU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OMBS8j6C; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OMBS8j6C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14B181F000C5;
	Mon, 19 Oct 2026 13:56:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418196;
	bh=cU4XMLCf+ejcttphqk7t+RlgvoU6IylGaxO6JhCgIaA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OMBS8j6C5rqwdXSuduRYec0+wmo4cDAw9ONdS5AoZ+SdiWi91kQpGpLosNLv+XHtG
	 II1QNXtU5xqUEXEgpEpk2F27/WEi0zxlo2a8WQskTEOD38qs0o9XEKv42PVZIkucxU
	 Aq6wAjNFeh0jhy+Bq37hd82WkXrxg3I6qirlSXakqoQ3WjD9SsbvRo8jvSaN0fXFpK
	 jsp7enxbRPQPmSU9JUftZT6CcFv8tMI6J6LXg+YTAkiatAtuVHLhpijS3aXcwEqvYQ
	 m2HZuo4QGHxiRYlyBjziczeilZwZZBbxYCH3x4Bk2TcAP/OZIQdXIcjKFSFO4I8Yue
	 d1SDhc6ReL5pQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Edson Juliano Drosdeck <edson.drosdeck@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>,
	perex@perex.cz,
	tiwai@suse.com,
	linux-sound@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] ALSA: hda/realtek: Limit mic boost on Positivo N15RPE-S
Date: Mon, 19 Oct 2026 09:46:11 -0400
Message-ID: <20261019135441.1420968-80-sashal@kernel.org>
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

From: Edson Juliano Drosdeck <edson.drosdeck@gmail.com>

[ Upstream commit 253010acfc8ad908446347b30a613032d1517bb5 ]

The internal mic boost on the Positivo N15RPE-S is too high.
Fix this by applying the ALC269_FIXUP_LIMIT_INT_MIC_BOOST fixup to the machine
to limit the gain.

Signed-off-by: Edson Juliano Drosdeck <edson.drosdeck@gmail.com>
Link: https://patch.msgid.link/20260805154518.19093-1-edson.drosdeck@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The local tree is **6.12.111** (`pending-6.12`). This is a one-line
Realtek HDA PCI quirk for a laptop whose driver and existing mic-boost
fixup are already in this tree.

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

Step 1.1: PARSE THE SUBJECT LINE
Record: [ALSA hda/realtek] [Limit] [apply existing
ALC269_FIXUP_LIMIT_INT_MIC_BOOST to Positivo N15RPE-S because internal
mic boost is too high]

Step 1.2: PARSE ALL COMMIT MESSAGE TAGS
Record:
- Signed-off-by: Edson Juliano Drosdeck (author)
- Link: https://patch.msgid.link/20260805154518.19093-1-
  edson.drosdeck@gmail.com
- Signed-off-by: Takashi Iwai (ALSA maintainer)
- No Fixes:, Reported-by:, Tested-by:, Reviewed-by:, Acked-by:, or Cc:
  stable
- Ignore pipeline markers (none present on the upstream commit
  `253010acfc8ad`)

Step 1.3: ANALYZE THE COMMIT BODY TEXT
Record:
- Bug: internal microphone boost on Positivo N15RPE-S is too high
- Symptom: excessive gain / noisy internal mic (the fixup comment says
  levels 2 and 3 are too noisy)
- Failure mode: hardware-specific unusable/noisy capture, not a kernel
  crash
- Root cause: this PCI SSID is not in the quirk table, so the existing
  boost limiter is not applied
- Version info: none stated

Step 1.4: DETECT HIDDEN BUG FIXES
Record: Not a disguised cleanup. It is an explicit hardware quirk: map
SSID `0x2782:0xa128` to an existing fixup.

===============================================================
PHASE 2: DIFF ANALYSIS - LINE BY LINE
===============================================================

Step 2.1: INVENTORY THE CHANGES
Record:
- Files: `sound/hda/codecs/realtek/alc269.c` (+1 / -0)
- Function/table: `alc269_fixup_tbl[]`
- Scope: single-file, one-line surgical quirk addition

Step 2.2: UNDERSTAND THE CODE FLOW CHANGE
Record:
- Before: PCI SSID `0x2782:0xa128` has no match; codec uses default
  auto-config with full internal-mic boost range
- After: that SSID matches `ALC269_FIXUP_LIMIT_INT_MIC_BOOST`, which at
  probe overrides amp caps so internal-mic boost is only steps 0–1
- Path: codec probe (`patch_alc269()` → `snd_hda_pick_fixup(...,
  alc269_fixup_tbl, ...)`)

Step 2.3: IDENTIFY THE BUG MECHANISM
Record: [Hardware workaround] Existing
`alc269_fixup_limit_int_mic_boost()` already limits noisy boost levels 2
and 3. This commit only adds the PCI ID so that function runs on this
laptop.

Verified function in this tree
(`sound/pci/hda/patch_realtek.c:6661-6690`):
- Runs only on `HDA_FIXUP_ACT_PROBE`
- Walks auto-config inputs, keeps only `AUTO_PIN_MIC` with
  `INPUT_PIN_ATTR_INT`
- Calls `snd_hda_override_amp_caps()` with `NUM_STEPS=1`

Step 2.4: ASSESS THE FIX QUALITY
Record:
- Quality: obviously correct; identical pattern already used for
  Positivo ARN50, Positivo N14AP7, VAIO VJFE-CL, several ThinkPads
- Minimal: one `SND_PCI_QUIRK` line, no API/data-structure change
- Regression risk: very low; only SSID `0x2782:0xa128` is affected. The
  chosen fixup is chained to `ALC269_FIXUP_THINKPAD_ACPI`, but that is
  the same chain used by the other Positivo/VAIO limit-boost entries
  already in this tree.

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

Step 3.1: BLAME THE CHANGED LINES
Record:
- Insertion point in this tree is after `SND_PCI_QUIRK(0x2782, 0x4900,
  "MEDION E15443", ...)` (`98b5ade3a44d8f`, 2024)
- The buggy “missing ID” is not old code; the laptop simply was never
  listed
- The fixup itself dates to `3e0d611b2045b` (“ALSA: hda - Limit internal
  mic boost for a few Asus machines”, 2013-04-22, contained in
  v3.10-rc1) and **is an ancestor of HEAD**

Step 3.2: FOLLOW THE FIXES: TAG
Record: No Fixes: tag. Expected for a new device quirk. Not a negative
signal.

Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES
Record:
- Related commits already in this tree:
  - `d44418f5024f6` ALSA: hda/realtek: Limit mic boost on Positivo ARN50
    (same author, same fixup; already backported here)
  - `86a433862912f` ALSA: hda/realtek: Limit mic boost on N14AP7 (same
    author, same fixup; had Cc: stable)
- Standalone: not patch X/Y. No prerequisite series.

Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS
Record: Edson Juliano Drosdeck has 10 commits in
`sound/pci/hda/patch_realtek.c` on this tree, almost all Positivo/VAIO
HDA quirks. Regular hardware-quirk contributor, not a one-off.

Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS
Record:
- Depends only on `ALC269_FIXUP_LIMIT_INT_MIC_BOOST` and
  `alc269_fixup_tbl[]`, both present
- Can apply standalone as a one-line quirk in
  `sound/pci/hda/patch_realtek.c`
- Mainline file path `sound/hda/codecs/realtek/alc269.c` is the
  post-6.12 HDA codec split; that path does **not** exist here.
  Equivalent table is `alc269_fixup_tbl` in `patch_realtek.c`

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION
Record:
- `b4 dig -c 253010acfc8ad` → https://patch.msgid.link/20260805154518.19
  093-1-edson.drosdeck@gmail.com
- `b4 dig -a`: only v1; no later revision
- Thread is two messages: the patch and Takashi Iwai “Applied to for-
  next branch. Thanks.”
- No NAK, no requested changes, no reviewer-flagged risk
- No explicit Cc: stable in the thread (absence expected)

Step 4.2: CHECK WHO REVIEWED THE PATCH
Record (`b4 dig -w`): To Takashi Iwai (`tiwai@suse.com`); Cc Jaroslav
Kysela (`perex@perex.cz`), Realtek (`kailang@realtek.com`), linux-sound,
linux-kernel. Subsystem maintainer received and applied it.

Step 4.3: SEARCH FOR THE BUG REPORT
Record: No syzbot/bugzilla link. Description is a hardware report from
the same author who previously submitted verified Positivo quirks. No
independent public bug count found.

Step 4.4: CHECK FOR RELATED PATCHES AND SERIES
Record: Standalone one-patch series. Same author’s ARN50/N14AP7 limit-
boost quirks are the precedent; those are already in this tree.

Step 4.5: CHECK STABLE MAILING LIST HISTORY
Record: lore.kernel.org/stable search returned HTTP 403. No stable-list
discussion verified. No evidence this was rejected for stable.

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF
Record: Table `alc269_fixup_tbl[]` only. Runtime function used by the
new ID: `alc269_fixup_limit_int_mic_boost()`. Probe picker:
`snd_hda_pick_fixup()` from `patch_alc269()`.

Step 5.2: TRACE CALLERS
Record:
- `patch_alc269()` at `sound/pci/hda/patch_realtek.c:12416` calls
  `snd_hda_pick_fixup(codec, alc269_fixup_models, alc269_fixup_tbl,
  alc269_fixups)` (line 12583)
- That is the ALC269-family codec probe path
  (CONFIG_SND_HDA_CODEC_REALTEK)
- Not IRQ, not syscall hot path; once at device probe

Step 5.3: TRACE CALLEES
Record: `alc269_fixup_limit_int_mic_boost()` →
`snd_hda_codec_get_pincfg()`, `snd_hda_get_input_pin_attr()`,
`snd_hda_override_amp_caps()`. No allocation, no new locks.

Step 5.4: FOLLOW THE CALL CHAIN
Record: Userspace cannot trigger a crash path. The ID is matched when
this laptop’s Realtek HDA codec is probed. Reachable for owners of
Positivo N15RPE-S with SND_HDA_CODEC_REALTEK. Unprivileged users then
get a usable (non-blown-out) internal mic.

Step 5.5: SEARCH FOR SIMILAR PATTERNS
Record: Same `ALC269_FIXUP_LIMIT_INT_MIC_BOOST` already used for many
IDs in this tree, including:
- `0x1c6c:0x122a` Positivo N14AP7
- `0x2014:0x800a` Positivo ARN50
- `0x2782:0x0214` VAIO VJFE-CL
This is a systematic hardware pattern, not a one-off experiment.

===============================================================
PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
===============================================================

Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?
Record:
- `git describe HEAD` = `p-6.12-2-gd38d58a4e0359`; `make kernelversion`
  = 6.12.111
- `git merge-base --is-ancestor 253010acfc8ad HEAD` → **not in this
  tree**
- `0xa128` is absent from `patch_realtek.c` (grep: no matches)
- The missing-ID bug exists here: the laptop would probe without the
  limiter
- Fixup and table exist since well before 6.12 (fixup from v3.10)

Step 6.2: CHECK FOR BACKPORT COMPLICATIONS
Record: Needs a trivial backport, not a clean git-am of the mainline
diff:
1. Path: `sound/hda/codecs/realtek/alc269.c` →
   `sound/pci/hda/patch_realtek.c`
2. Context: mainline next line is Lunnen Ground 14 (`0x2782, 0xa212`),
   which is **not** in 6.12; insert after `0x2782, 0x4900` and before
   `0x7017, 0x2014`
That is the same class of adjustment used for `d44418f5024f6` (ARN50) on
this tree.

Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE
Record: No N15RPE-S entry. Nearby same-class quirks (ARN50, N14AP7) are
present. No alternate fix for `0x2782:0xa128`.

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY
Record: [sound/pci/hda Realtek codec] [IMPORTANT for laptop audio;
PERIPHERAL in that only this PCI ID is affected]

Step 7.2: ASSESS SUBSYSTEM ACTIVITY
Record: Very active: last 20 commits on `patch_realtek.c` are mostly
more `SND_PCI_QUIRK` entries (HP, Lenovo, Samsung, MECHREVO, ASUS).
Mature driver; this is the normal way hardware enablement/workarounds
land.

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

Step 8.1: DETERMINE WHO IS AFFECTED
Record: Driver-specific / PCI-SSID-specific: only Positivo N15RPE-S
(`0x2782:0xa128`) with Realtek ALC269-family HDA.

Step 8.2: DETERMINE THE TRIGGER CONDITIONS
Record:
- Trigger: every boot/probe on that laptop when using the internal mic
  at high boost
- Common for owners of that model; zero impact elsewhere
- Not a security trigger; not unprivileged-crash

Step 8.3: DETERMINE THE FAILURE MODE SEVERITY
Record: [Noisy / overly boosted internal mic, capture quality unusable
at high gain] [MEDIUM for those users; LOW globally]. Not
panic/UAF/corruption, but it is a real hardware defect the existing
quirk is designed to fix.

Step 8.4: CALCULATE RISK-BENEFIT RATIO
Record:
- Benefit: high for N15RPE-S users on 6.12 (mic works as on later
  kernels)
- Risk: very low (one ID, existing fixup, same pattern already
  backported here)
- Ratio: strongly favors backport

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

Step 9.1: COMPILE THE EVIDENCE
FOR:
- Explicit audio-codec hardware quirk (`SND_PCI_QUIRK` + existing fixup)
- Real user-visible bug (internal mic boost too high)
- One line, obviously correct, maintainer-applied
- Same author’s identical Positivo ARN50 quirk already in this 6.12 tree
- Fixup and quirk table already present
- No new API, no new driver, no behavioral change except this SSID

AGAINST:
- Not a crash/security/data-corruption bug
- Mainline path differs; needs 1-line context/path adjustment
- No independent public bugzilla/syzbot report
- Affected population is one laptop model

UNRESOLVED:
- Could not query lore.kernel.org/stable (HTTP 403)
- Could not independently verify the author’s hardware test beyond the
  commit text and maintainer apply

Step 9.2: APPLY THE STABLE RULES CHECKLIST
1. Obviously correct and tested? PASS — one ID, existing fixup, applied
   by Takashi Iwai
2. Fixes a real bug that affects users? PASS — excessive internal mic
   boost on this machine
3. Important issue? PASS under the hardware-quirk exception (audio codec
   quirk); severity MEDIUM for that model
4. Small and contained? PASS — +1 line
5. No new features or APIs? PASS — ID mapped to existing fixup
6. Can apply to the local tree? PASS — equivalent table exists; needs
   trivial path/context backport, same as prior quirks on this tree

Step 9.3: CHECK FOR EXCEPTION CATEGORIES
Record: **Hardware quirk / audio codec quirk** (`SND_PCI_QUIRK` in
Realtek HDA). This is an explicit stable exception.

Step 9.4: MAKE YOUR DECISION
This should be backported to this 6.12 tree. It is the standard Realtek
laptop quirk: add a PCI subsystem ID so an existing limiter runs. The
driver, table, and `ALC269_FIXUP_LIMIT_INT_MIC_BOOST` are all here; only
the N15RPE-S ID is missing. Risk is confined to that SSID.

------------------------------------------------
What problem it solves and why it matters
The Positivo N15RPE-S ships with an internal mic whose boost steps 2–3
are too hot. Without this ID, 6.12 users of that laptop keep the default
full boost range. The commit maps `0x2782:0xa128` onto the long-standing
limiter already used for other Positivo machines in this tree.

Stable-rules fit
It is small, obviously correct, does not add APIs, and is the documented
audio-quirk exception. It is not a crash fix, but stable routinely takes
these ID-only Realtek quirks.

Risk vs benefit
Benefit is a working internal mic for that model. Risk is a single-ID
table entry using a fixup that has been in the kernel since v3.10 and is
already applied to sibling Positivo IDs here.

Concerns
The mainline hunk will not `git am` cleanly because of the later HDA
file split and a neighboring Lunnen Ground 14 entry that 6.12 lacks. The
backport is still a one-line insert into `alc269_fixup_tbl` in
`sound/pci/hda/patch_realtek.c`.

Verification:
- [Phase 1] Parsed tags on `253010acfc8ad`: author SOB, maintainer SOB,
  msgid Link; no Fixes/Reported-by/Cc: stable
- [Phase 2] Diff: +1 `SND_PCI_QUIRK(0x2782, 0xa128, "Positivo N15RPE-S",
  ALC269_FIXUP_LIMIT_INT_MIC_BOOST)`
- [Phase 2] Read `alc269_fixup_limit_int_mic_boost()` at
  `patch_realtek.c:6661-6690`; confirmed it clamps internal-mic amp
  steps to 0–1
- [Phase 2] Confirmed `[ALC269_FIXUP_LIMIT_INT_MIC_BOOST]` exists at
  line 8711 and chains to `ALC269_FIXUP_THINKPAD_ACPI` (same as other
  Positivo limit-boost entries)
- [Phase 3] `git merge-base --is-ancestor 3e0d611b2045b HEAD` — fixup
  present (v3.10)
- [Phase 3] `git merge-base --is-ancestor 253010acfc8ad HEAD` —
  candidate **not** in this tree
- [Phase 3] `git log --grep=N15RPE -- sound/pci/hda/` — empty
- [Phase 3] Grep `0xa128` in `patch_realtek.c` — no match
- [Phase 3] Same-class commits in tree: `d44418f5024f6` (ARN50),
  `86a433862912f` (N14AP7)
- [Phase 3] Author has 10 Realtek HDA quirk commits in this tree
- [Phase 4] `b4 dig -c 253010acfc8ad` → msgid
  20260805154518.19093-1-edson.drosdeck@gmail.com
- [Phase 4] `b4 dig -a`: v1 only
- [Phase 4] `b4 dig -w`: To tiwai, Cc linux-sound / perex / Realtek
- [Phase 4] LKML/Patchew: Takashi “Applied to for-next”; no NAK
- [Phase 4] UNVERIFIED: lore.kernel.org/stable search HTTP 403
- [Phase 5] `patch_alc269()` line 12583 uses `alc269_fixup_tbl`
- [Phase 6] `git describe HEAD` = p-6.12-2-gd38d58a4e0359; kernelversion
  6.12.111
- [Phase 6] Local file is `sound/pci/hda/patch_realtek.c`; `alc269.c`
  does not exist; insert after 0x2782/0x4900 before 0x7017/0x2014
- [Phase 8] Failure mode: noisy/excessive internal mic boost on one
  laptop; not a crash

**YES**

 sound/hda/codecs/realtek/alc269.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/hda/codecs/realtek/alc269.c b/sound/hda/codecs/realtek/alc269.c
index f2b0eb8501a78..5098d3f375316 100644
--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -7646,6 +7646,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x2782, 0x1705, "MEDION E15433", ALC269VC_FIXUP_INFINIX_Y4_MAX),
 	SND_PCI_QUIRK(0x2782, 0x1707, "Vaio VJFE-ADL", ALC298_FIXUP_SPK_VOLUME),
 	SND_PCI_QUIRK(0x2782, 0x4900, "MEDION E15443", ALC233_FIXUP_MEDION_MTL_SPK),
+	SND_PCI_QUIRK(0x2782, 0xa128, "Positivo N15RPE-S", ALC269_FIXUP_LIMIT_INT_MIC_BOOST),
 	SND_PCI_QUIRK(0x2782, 0xa212, "Lunnen Ground 14", ALC269VC_FIXUP_LUNNEN_GROUND_14),
 	SND_PCI_QUIRK(0x7017, 0x2014, "Star Labs StarFighter", ALC233_FIXUP_STARLABS_STARFIGHTER),
 	SND_PCI_QUIRK(0x8086, 0x2074, "Intel NUC 8", ALC233_FIXUP_INTEL_NUC8_DMIC),
-- 
2.53.0

