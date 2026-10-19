Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FBFB5172EE;
	Mon, 19 Oct 2026 13:55:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418111; cv=none; b=N1mpOUDpul4bEMQDztboLbk+yk5lBfHLUB71b4RbDJZUHLSvOF/eUt/X/tlAEp+fWRdGku9p0NpfSAXLwBbursHwQpHBLkUiIZ2SVVa0Lrx4hG2aIRwAfy81AJGOkWuCQc9sdRgeQXiwLarlX1VGfc6YzYm4J25XWiIboaelBO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418111; c=relaxed/simple;
	bh=A0NjEg9PM04akK49RXHb9ikpdnYdT1NI2cAjgu+MeV4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nDYjqEM7UkrOTmU4Hhqiz0iq6ch+Sm0MADlYk/aaqEmx82P3BNAclg9FaNQ5OnuqUhxVe1Wj31vmSGwAnmCo444hYrVOKfm4+EALkfEy/DLOlf7jUVr8iO7Dab8BIea4neZkNsKkNirHQPpMGAAuTwCYZ2lVvdUAGSXmpZ5zYOQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kDq3GAs9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kDq3GAs9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 508731F000C4;
	Mon, 19 Oct 2026 13:55:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418109;
	bh=MWIDjHAuNsyfVsNMCC8w5XczBjDeiBQ7zVYCKN4liAk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kDq3GAs92HH8ErKz2mUlw/1KHbTm2TxJy4didgBuXZmcssXdWf2jq26N31PYHUcEG
	 yxjfJx5j6Arr4u//ho7tJanfPHs5P6gwLcvl7220yOmY90vGab7wIlYQgbpnIms/E9
	 ZAGkzIYPSHRVVza/EoH2dccg7sy2uyK34bp+OFmOGCZy69I7LebzSn+TyWkAjzjh7u
	 A0yxu6t1dD59MK1rz23gKI9p+s/Q2AkmU6CgGp4QlXcA4/mvMbX3ESsYv6Imx4Sp0c
	 5JKluaQ5+xxNkbvRBy+m9+eVUwcz/FUKqdxmvX2vKSIqKv1deoqUNMtRk7TDWFjsMD
	 dlTtWE99CWa9Q==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Garrett Blackmon <garrett@blackmon.dev>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>,
	perex@perex.cz,
	tiwai@suse.com,
	linux-sound@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.12] ALSA: hda/realtek: Fix speakers on ASUS ROG Zephyrus G14 GA403UM
Date: Mon, 19 Oct 2026 09:45:09 -0400
Message-ID: <20261019135441.1420968-18-sashal@kernel.org>
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

From: Garrett Blackmon <garrett@blackmon.dev>

[ Upstream commit 140fe610af607fd70da95c447943fc2690855519 ]

The GA403UM (SSID 1043:1044) uses the same ALC285 codec + dual CS35L56
I2C amplifier topology as the GA403U and GA403W variants, which already
have quirk entries (1043:1b13, 1043:1024). Without the quirk, the
woofers sit on a separate DAC from the tweeters, so the hardware volume
control only scales part of the speaker system and the headset
microphone pins are not configured.

Apply the existing ALC285_FIXUP_ASUS_GA403U_HEADSET_MIC fixup to the
GA403UM as well.

Signed-off-by: Garrett Blackmon <garrett@blackmon.dev>
Link: https://patch.msgid.link/20260807150708.33785-1-garrett@blackmon.dev
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

This is a one-line PCI SSID quirk for an existing Realtek fixup. The
local tree is **6.12.111** (`pending-6.12`, `p-6.12-3-g710455e2077bb`).
The GA403U fixup chain is already here; SSID `1043:1044` is not.

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

**Step 1.1: PARSE THE SUBJECT LINE**
Record: `[ALSA: hda/realtek] [Fix] speakers on ASUS ROG Zephyrus G14
GA403UM`

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**
Record:
- `Signed-off-by: Garrett Blackmon <garrett@blackmon.dev>` (author)
- `Link:
  https://patch.msgid.link/20260807150708.33785-1-garrett@blackmon.dev`
- `Signed-off-by: Takashi Iwai <tiwai@suse.de>` (ALSA maintainer)
- No `Fixes:` tag (expected)
- No `Cc: stable` (expected; not a negative)
- No `Reported-by:` / `Tested-by:` / `Reviewed-by:` / `Acked-by:`
- Ignore pipeline `Signed-off-by: Sasha Levin` if present; it is not on
  the mainline commit `140fe610af607`

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**
Record:
- **Bug:** GA403UM (SSID `1043:1044`) has ALC285 + dual CS35L56 I2C
  amps, same topology as GA403U (`1043:1b13`) and GA403W (`1043:1024`).
- **Symptom:** Without the quirk, woofers are on a different DAC from
  tweeters, so hardware volume only scales part of the speaker system;
  headset-mic pins are not configured.
- **Root cause:** Missing `SND_PCI_QUIRK` entry; the machine never gets
  `ALC285_FIXUP_ASUS_GA403U_HEADSET_MIC`.
- **Version info:** None in the message. Commit date is 2026-08-07
  (after v6.12, 2024-11-17).

**Step 1.4: DETECT HIDDEN BUG FIXES**
Record: Not hidden. It is an explicit hardware-quirk fix for broken
speakers/headset mic.

===============================================================
PHASE 2: DIFF ANALYSIS - LINE BY LINE
===============================================================

**Step 2.1: INVENTORY THE CHANGES**
Record:
- Mainline file: `sound/hda/codecs/realtek/alc269.c` (`+1` / `-0`)
- Function/table: `alc269_fixup_tbl[]`
- Scope: single-file, one-line PCI quirk addition

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**
Record:
- **Before:** SSID `1043:1044` does not match; generic auto-parse leaves
  bass speaker NID `0x17` on a separate DAC and does not set headset-mic
  pins `0x19`/`0x1b`.
- **After:** That SSID selects `ALC285_FIXUP_ASUS_GA403U_HEADSET_MIC`,
  which:
  1. Sets pins `{0x19, 0x03a11050}` and `{0x1b, 0x03a11c30}`
  2. Chains to `ALC285_FIXUP_ASUS_GA403U_I2C_SPEAKER2_TO_DAC1`
     (`alc285_fixup_speaker2_to_dac1` forces NID `0x17` onto
     DAC1/`0x02`)
  3. Chains to `ALC285_FIXUP_ASUS_GA403U` (inv-dmic only if codec is not
     ALC285, for SSID reuse)
- Path: HDA probe / `patch_alc269()`, not an error path.

**Step 2.3: IDENTIFY THE BUG MECHANISM**
Record: **Hardware workaround (PCI SSID quirk).** Missing table entry
for a shipped laptop SKU. Not UAF/race/leak.

**Step 2.4: ASSESS THE FIX QUALITY**
Record:
- Obviously correct: reuse of an existing, already-shipped fixup.
- Minimal: one `SND_PCI_QUIRK` line.
- Regression risk: very low; the entry matches only `vendor 0x1043, SSID
  0x1044`. `0x1044` is unused in this tree’s Realtek quirk table.
- SSID-reuse note: `alc285_fixup_asus_ga403u` already guards non-ALC285
  hardware that reused `0x1b13`. This new ID is a distinct SSID, not
  that reuse case.

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

**Step 3.1: BLAME THE CHANGED LINES**
Record:
- Insertion sits between existing ASUS entries `0x103f` (TX300, 2013)
  and `0x1054` (G614, 2025 backport).
- Buggy “code” is absence of `1043:1044`, not a later regression in
  shared logic.
- The fixup being applied was introduced by `0672b017324b1` (“Fixes for
  Asus GU605M and GA403U sound”, 2024-04-18) and is in this tree.
- Earlier `c33f0d4fcfe07` (2024-03-30) added CS35L56 laptop quirks and
  the GA403U SSID-reuse comment; also in this tree.

**Step 3.2: FOLLOW THE FIXES: TAG**
Record: No `Fixes:` tag. The functional prerequisite is `0672b017324b1`,
present here (`git merge-base --is-ancestor` → yes).

**Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**
Record:
- Related in this tree: `c33f0d4fcfe07`, `0672b017324b1`.
- Sibling mainline quirk `cbd46cbc5470f` (GA403W `1043:1024`, 2026-01)
  is **not** in this tree. It is a parallel SKU entry, not a
  prerequisite for `1043:1044`.
- Candidate `140fe610af607` is **not** an ancestor of HEAD.
- This 6.12 tree already backports many similar one-line Realtek quirks
  (recent log is almost entirely `Add quirk for …`).
- Standalone: one table line; no series (`patch X/Y`).

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**
Record: Garrett Blackmon has this single Realtek commit on
`origin/master`. Takashi Iwai applied it the same day. Author is a
hardware user, not the subsystem maintainer; maintainer acked by
applying.

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**
Record:
- Needs `ALC285_FIXUP_ASUS_GA403U_HEADSET_MIC` and
  `alc285_fixup_speaker2_to_dac1` — both exist in
  `sound/pci/hda/patch_realtek.c`.
- Needs CS35L56 HDA I2C sidecar — `sound/pci/hda/cs35l56_hda_i2c.c` is
  present.
- Does **not** need the GA403W `0x1024` entry.
- Cannot apply the mainline diff as-is: mainline file is
  `sound/hda/codecs/realtek/alc269.c` (split ~2025-07). This tree still
  has `sound/pci/hda/patch_realtek.c`. Backport is the same one line at
  the same SSID sort position (after `0x103f`, before `0x1054`).

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**
Record:
- `b4 dig -c 140fe610af607` →
  https://patch.msgid.link/20260807150708.33785-1-garrett@blackmon.dev
- `b4 dig -a`: **v1 only** (2026-08-07), no later revisions.
- Thread: author submission + Takashi Iwai “Applied to for-next branch
  now. Thanks.”
- No NAK, no stable nomination in-thread, no risk discussion.

**Step 4.2: CHECK WHO REVIEWED THE PATCH**
Record (`b4 dig -w`): To/Cc `tiwai@suse.com`, `perex@perex.cz`, `linux-
sound@vger.kernel.org`. ALSA maintainers were on the patch; Iwai applied
it.

**Step 4.3: SEARCH FOR THE BUG REPORT**
Record: No bugzilla/syzbot link. The commit itself is the user report
(author is fixing their GA403UM). Severity from the text: partial
speaker volume + unconfigured headset mic.

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**
Record: Standalone v1. Related sibling is GA403W `cbd46cbc5470f` (not
required). No follow-up on `origin/master` that changes `1043:1044`.

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**
Record: lore.kernel.org/stable search returned HTTP 403. **UNVERIFIED**
whether it was discussed on stable@. Not used for the verdict.

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

**Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF**
Record: No function body change. Adds one entry to `alc269_fixup_tbl[]`.
Consumed fixups: `ALC285_FIXUP_ASUS_GA403U_HEADSET_MIC` →
`alc285_fixup_speaker2_to_dac1` → `alc285_fixup_asus_ga403u`.

**Step 5.2: TRACE CALLERS**
Record:
- `patch_alc269()` calls `snd_hda_pick_fixup(..., alc269_fixup_tbl,
  alc269_fixups)` at probe (`sound/pci/hda/patch_realtek.c`).
- `patch_alc269` covers the ALC269 family, including ALC285
  (`0x10ec0285`).
- Trigger: HD-audio codec probe on this laptop, not interrupt/hot path.

**Step 5.3: TRACE CALLEES**
Record: `snd_hda_pick_fixup` matches PCI SSID, then pin overrides +
`snd_hda_override_conn_list(codec, 0x17, …)` so bass/woofer shares DAC1
with the main speakers.

**Step 5.4: FOLLOW THE CALL CHAIN**
Record: PCI/HDA enumeration → Realtek codec probe → `patch_alc269` →
quirk table. Reachable on every boot of a GA403UM. Not a syscall attack
path; it is the normal audio device path.

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**
Record: Same fixup already used for `0x1043, 0x1b13` (“ASUS
U41SV/GA403U”). This commit extends that pattern to another SKU. This
tree regularly takes the same class of one-line quirk.

===============================================================
PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
===============================================================

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**
Record: Yes, as a missing SSID.
- Tree: 6.12.111 / `pending-6.12`.
- File: `sound/pci/hda/patch_realtek.c`.
- Fixup IDs and implementations are present (lines ~7529, ~6831,
  ~10586–10618).
- `0x1b13` is present (line 11257). `0x1044` is **not**.
- Candidate `140fe610af607` is not an ancestor of HEAD.
- Hardware is a 2026 G14 SKU; 6.12 is LTS, so users can run this kernel
  on that laptop.

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**
Record: Raw mainline patch does not apply (file was split to
`sound/hda/codecs/realtek/alc269.c` after 6.12). Functional backport is
trivial: insert the same `SND_PCI_QUIRK` between `0x103f` and `0x1054`
in `patch_realtek.c` (lines 11185–11186). No data-structure or API gap.

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**
Record: GA403U fixup yes; this SSID no. No alternate GA403UM fix. `git
grep 0x1044` in `patch_realtek.c` is empty.

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

**Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY**
Record: `sound/pci/hda` Realtek HD-audio. **IMPORTANT** (laptop audio),
not core mm/fs. Maintainers: Takashi Iwai, Jaroslav Kysela
(`MAINTAINERS` SOUND). Config: `SND_HDA_CODEC_REALTEK`.

**Step 7.2: ASSESS SUBSYSTEM ACTIVITY**
Record: Very active quirk table; recent 6.12 backports are mostly
device-specific `SND_PCI_QUIRK` additions. Mature pattern, low novelty.

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

**Step 8.1: DETERMINE WHO IS AFFECTED**
Record: Driver/platform-specific: ASUS ROG Zephyrus G14 GA403UM, SSID
`1043:1044`, ALC285 + CS35L56. No effect on other machines.

**Step 8.2: DETERMINE THE TRIGGER CONDITIONS**
Record: Every boot / any speaker volume or headset-mic use on that
model. Unprivileged user using audio. Not a race.

**Step 8.3: DETERMINE THE FAILURE MODE SEVERITY**
Record:
- Failure: woofers do not follow master volume (split DAC); headset mic
  pins unconfigured.
- **Severity: MEDIUM–HIGH** for that hardware (laptop audio effectively
  broken), not a kernel oops. This is the class of “device doesn’t work
  correctly without a quirk.”

**Step 8.4: CALCULATE RISK-BENEFIT RATIO**
Record:
- **Benefit:** High for GA403UM owners on 6.12.y (working speakers +
  headset pins).
- **Risk:** Very low (one SSID line, existing fixup, SSID unused).
- **Ratio:** Strongly favors backport. Matches the documented hardware-
  quirk exception.

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

**Step 9.1: COMPILE THE EVIDENCE**

FOR:
- Real user-visible bug: incomplete speaker volume and unconfigured
  headset mic.
- One-line `SND_PCI_QUIRK` using a fixup already in 6.12.
- Prerequisite `0672b017324b1` is in this tree; CS35L56 HDA I2C is in
  this tree.
- ALSA maintainer applied v1 the same day; no NAK.
- Classic stable exception: PCI ID / hardware quirk for an existing
  driver.
- This tree already carries the same fixup for GA403U (`0x1b13`).
- Insertion point exists; `0x1044` is free.

AGAINST:
- Mainline patch path differs (`alc269.c` vs `patch_realtek.c`); needs a
  one-line backport, not a raw apply.
- No `Reported-by` besides the author; no syzbot/CVE.
- Not a crash/security bug.
- Sibling `0x1024` (GA403W) is absent — irrelevant; that SKU is
  independent.

UNRESOLVED:
- Stable@ lore search (HTTP 403).
- WebFetch of lore also 403; thread recovered via `b4 dig -m`.

**Step 9.2: APPLY THE STABLE RULES CHECKLIST**
1. Obviously correct and tested? **PASS** — reuse of in-tree fixup;
   maintainer applied.
2. Fixes a real bug that affects users? **PASS** — broken volume/headset
   on GA403UM.
3. Important issue? **PASS** — hardware-quirk exception; audio broken on
   that laptop, not a panic.
4. Small and contained? **PASS** — 1 line.
5. No new features or APIs? **PASS** — existing quirk ID only.
6. Can apply to the local tree? **PASS** with trivial path adjustment
   (`patch_realtek.c`, same context).

**Step 9.3: CHECK FOR EXCEPTION CATEGORIES**
Record: **Hardware quirk / PCI SSID addition to an existing driver.**
Automatic YES class.

**Step 9.4: MAKE YOUR DECISION**
The missing SSID is present as a gap in this 6.12 tree, the target fixup
chain is complete, and the change cannot affect any other device.
Backport it.

------------------------------------------------
What the commit solves for this tree
------------------------------------------------
On GA403UM, Linux never applies the GA403U speaker/mic fixup. Master
volume then moves only tweeters (woofers stay on another DAC), and
headset-mic pins stay wrong. Adding `SND_PCI_QUIRK(0x1043, 0x1044, "ASUS
GA403UM", ALC285_FIXUP_ASUS_GA403U_HEADSET_MIC)` to `alc269_fixup_tbl`
in `sound/pci/hda/patch_realtek.c` is the whole fix.

Risk vs benefit: benefit is working audio on that LTS laptop; risk is a
single unused-SSID match. File-split means the mainline diff needs a
one-line rewrite, which is normal for Realtek quirks on 6.12.

Verification:
- [Phase 1] Parsed tags on `140fe610af607`: SOB Blackmon, Link msgid,
  SOB Iwai; no Fixes/stable/Reported-by
- [Phase 2] Diff: +1 line `SND_PCI_QUIRK(0x1043, 0x1044, …
  ALC285_FIXUP_ASUS_GA403U_HEADSET_MIC)`
- [Phase 3] `git describe HEAD` / `make kernelversion`:
  `p-6.12-3-g710455e2077bb`, 6.12.111, branch `pending-6.12`
- [Phase 3] `git merge-base --is-ancestor 140fe610af607 HEAD` → not in
  tree
- [Phase 3] `git merge-base --is-ancestor 0672b017324b1 HEAD` → yes
  (GA403U fixup)
- [Phase 3] `git merge-base --is-ancestor cbd46cbc5470f HEAD` → no
  (GA403W 0x1024; not required)
- [Phase 3] Confirmed fixup chain and `0x1b13` in
  `sound/pci/hda/patch_realtek.c`; `0x1044` absent
- [Phase 4] `b4 dig -c 140fe610af607` / `-a` / `-w` / `-m`: v1 only;
  Iwai applied; To linux-sound + maintainers
- [Phase 4] UNVERIFIED: lore.kernel.org WebFetch and stable@ search
  (HTTP 403)
- [Phase 5] `patch_alc269()` → `snd_hda_pick_fixup(...,
  alc269_fixup_tbl, …)` at codec probe
- [Phase 5] `alc285_fixup_speaker2_to_dac1` overrides NID 0x17 to DAC
  0x02
- [Phase 6] Insertion context `0x103f` then `0x1054` present at lines
  11185–11186
- [Phase 6] `cs35l56_hda_i2c.c` present
- [Phase 8] Failure mode: partial speaker volume + unconfigured headset
  mic on one laptop SSID
- UNVERIFIED: whether this SSID was already requested on stable@

**YES**

 sound/hda/codecs/realtek/alc269.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/hda/codecs/realtek/alc269.c b/sound/hda/codecs/realtek/alc269.c
index 8fdfe1bbe7aff..05e7fcc2f67e6 100644
--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -7094,6 +7094,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1043, 0x1034, "ASUS GU605C", ALC285_FIXUP_ASUS_GU605_SPI_SPEAKER2_TO_DAC1),
 	SND_PCI_QUIRK(0x1043, 0x103e, "ASUS X540SA", ALC256_FIXUP_ASUS_MIC),
 	SND_PCI_QUIRK(0x1043, 0x103f, "ASUS TX300", ALC282_FIXUP_ASUS_TX300),
+	SND_PCI_QUIRK(0x1043, 0x1044, "ASUS GA403UM", ALC285_FIXUP_ASUS_GA403U_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1043, 0x1054, "ASUS G614FH/FM/FP", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x1043, 0x106d, "Asus K53BE", ALC269_FIXUP_LIMIT_INT_MIC_BOOST),
 	SND_PCI_QUIRK(0x1043, 0x106f, "ASUS VivoBook X515UA", ALC256_FIXUP_ASUS_MIC_NO_PRESENCE),
-- 
2.53.0

