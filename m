Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 583DD53C3B9;
	Mon, 19 Oct 2026 13:58:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418325; cv=none; b=Xx885+Rze6TTOF4NtporBcN4kY40tsja08rFXFeRHRCsp3CpDpwfn0Z1SOXLIbJI6qJg76fKMI/F+UtYeq6ayOmP302KoTcEpM7FPxWwezkPWfwzEYY4uEcSBtJiIZQGvnHi5yv8NwnRt5KGQIqt3ng2KtvGXUG5E7wYN61TCmY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418325; c=relaxed/simple;
	bh=/SYBgCJqBvBagZ+NioYtkI/kzqLy9m+SYGNnpRHumRA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cSWY8ci+V1432D7llHw2r0BEdj5IBHUaAP1ibJd4on3l3Wng7Ih85MuCFubBHftn400Ec6lKvjOWo65l5Sj1On2hVaLZ9ieWdBGboIxAq9b31BpgSr+lLJJcxdEwSl/+Eb/2bz78Pqg1GujlFFtLTl8U4Urk6PkrVQTNbYdlHIA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JJnDGT4l; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JJnDGT4l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E898F1F000C9;
	Mon, 19 Oct 2026 13:58:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418320;
	bh=DgotUjiZOJ+1Cyu52JPUIPCK29CV+R0BoFWBs3zRcrg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JJnDGT4lMLJWEhNTqlS24dsKZ8DJ0GLjEH/jmCWRFRxJFFlEVYP6/dlokQR/S8hiY
	 vSRLmU6DmabJnxkYos7Mx3oCb7lK60gcc8vmUu+fR66MwHqCa0LUlFsV23AbmXm6zu
	 GmLL/kv8c5iaXbJqlWnwFCifpxqKF3QIzTN3dfMnEfz6G43ihqVQex1BtA2cuV5icX
	 zRdlz7NvKzOs8r8wa62XRfXcqwzJutOOmbNViejut9fCLY3LLuPCZN0D/GoiNBD/4f
	 BMZmbfaTHFRs/UJNxSgiealyxSodyvFD0EZNDdiTkCmcJnNbatS28H/HnfyHxxOnix
	 Vnb0fpRBtl87Q==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Bob Song <songxiebing@kylinos.cn>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>,
	perex@perex.cz,
	tiwai@suse.com,
	linux-sound@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.15] ALSA: hda/conexant: Always enable the headset-mic pin on plugin
Date: Mon, 19 Oct 2026 09:47:35 -0400
Message-ID: <20261019135441.1420968-164-sashal@kernel.org>
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

From: Bob Song <songxiebing@kylinos.cn>

[ Upstream commit 9642a5e843758686e02a7f0d1df9eb0f7f96603c ]

Rename the function to cx_process_headset_detect_plug_type() to reflect
that it only reports the detected plug type, and move the pin control
write into cx_update_headset_mic_vref() so that node 0x19 is always set
to enable the headset mic with the 80% VREF whenever the mic is
present, regardless of the type detection result.

Signed-off-by: Bob Song <songxiebing@kylinos.cn>
Link: https://patch.msgid.link/20260826115344.2128835-1-songxiebing@kylinos.cn
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Local tree is **6.12.111** (`pending-6.12`). The Conexant headset-mic
VREF logic is present here; the commit is a small hardware fix for
silent 3-pole mics on CX11880/SN6140.

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

**Step 1.1: PARSE THE SUBJECT LINE**
Record: [ALSA: hda/conexant] [Always enable] [Always write
PIN_WIDGET_CONTROL 0x24 on node 0x19 when a headset mic is present, not
only when CTIA/OMTP type-detect succeeds]

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**
Record:
- Link: https://patch.msgid.link/20260826115344.2128835-1-
  songxiebing@kylinos.cn
- Signed-off-by: Bob Song \<songxiebing@kylinos.cn\> (author)
- Signed-off-by: Takashi Iwai \<tiwai@suse.de\> (ALSA maintainer)
- No Fixes:, Reported-by:, Tested-by:, Reviewed-by:, Acked-by:, or Cc:
  stable (absence is expected)
- Ignore pipeline SOBs / Upstream markers

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**
The v3 body is thin: rename `cx_process_headset_plugin()` to
`cx_process_headset_detect_plug_type()`, and move the pin-control write
so node 0x19 is always set to 0x24 when a mic is present.

The v1 body (same series) is the actual bug statement: *“For 3-pole
headset microphones, the mic pin VREF must always be configured to 0x24
regardless of the headset type, otherwise the mic will not be able to
record audio.”*

Record: [Bug: 3-pole mics that assert pin 0x19 presence but are not
classified as CTIA/OMTP never get VREF 80%] [Symptom: headset mic cannot
record] [Root cause: 0x24 write gated on type-detect bits] [No version
info in the message]

**Step 1.4: DETECT HIDDEN BUG FIXES**
Record: [Yes — v3 is written as a rename/move, but it is a functional
fix. Type detection becomes debug-only; the missing 0x24 write for the
3-pole/fallback case is the real change.]

===============================================================
PHASE 2: DIFF ANALYSIS - LINE BY LINE
===============================================================

**Step 2.1: INVENTORY THE CHANGES**
Record: [1 file: `sound/hda/codecs/conexant.c` on mainline (~+6/-4).
Functions: `cx_process_headset_plugin` renamed;
`cx_update_headset_mic_vref` changed. Surgical, single-file.]

In **this** 6.12 tree the same code lives in
`sound/pci/hda/patch_conexant.c` (file not yet moved).

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**
Before (this tree, `cx_update_headset_mic_vref`):
- Pin 0x19 presence clear → write 0x20 (IN_EN, VREF off)
- Presence set → `cx_process_headset_plugin()`:
  - CTIA (`val & 0x800`) or OMTP (`val & 0x400`) → write 0x24
  - else log “headphone plugin” and **do not** write 0x24

After:
- Presence clear → write 0x20 (unchanged)
- Presence set → still wait/log type, **then always write 0x24**

Record: [Plugin path: VREF 80% only for CTIA/OMTP → VREF 80% whenever
pin 0x19 reports presence]

**Step 2.3: IDENTIFY THE BUG MECHANISM**
`0x24` = `AC_PINCTL_IN_EN (0x20) | AC_PINCTL_VREF_80 (0x04)`
(`include/sound/hda_verbs.h`). `0x20` is input enable without bias.

The jack callback only runs after pin 0x19 presence. 4-pole CTIA/OMTP
already got bias. 3-pole mics (and any detect timeout/misclassify into
the else branch) did not, so the mic had no bias.

This is a **hardware workaround / logic correctness** fix, not
UAF/leak/race.

Record: [Category: hardware workaround + logic] [Broken: 3-pole mic
recording] [Fix: always enable VREF 80% when mic present]

**Step 2.4: ASSESS THE FIX QUALITY**
Obviously correct: init already does the same in
`cx_fixup_headset_recog()` (presence → 0x24, else 0x20). The plugin path
is being made consistent with that.

Regression risk is low: headphone-only plugs should not assert nid 0x19
presence (node 19 is mic-only per comments; Takashi raised this, author
confirmed presence is checked first). Inner 0x24 write in the renamed
function remains in v3 (redundant with the caller write); harmless.

Record: [Quality: small, correct, matches init path] [Risk: low;
redundant inner write only]

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

**Step 3.1: BLAME THE CHANGED LINES**
Record: [Introduced by `7aeb2590864874` (“ALSA: hda/conexant: Fix
headset auto detect fail in cx8070 and SN6140”), 2024-01-08. Jack
callback wiring later adjusted by `e60dc981221105` (same author,
2024-07-26). Present since ~v6.8, well before 6.12.]

**Step 3.2: FOLLOW THE FIXES: TAG**
Record: [No Fixes: tag. Introducing commit 7aeb259 is an ancestor of
HEAD. Original intent of 7aeb259 was already “enable VREF when headset
is present”; implementation gated it on CTIA/OMTP.]

**Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**
Record: [Related in this tree: e60dc981 (polling-mode detect),
86c11d5091e11 (remove mic-bias threshold override, Cc:stable, Fixes:
7aeb259), dd110cc00cf85 (jack-detect error check). Standalone fix; not
patch X/Y.]

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**
Record: [Bob Song/songxiebing already authored e60dc981 on this exact
callback. Kylin/Senarytech people maintain this CX11880/SN6140 quirk.
Not the ALSA maintainer; Takashi applied it.]

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**
Record: [No missing helpers. v2 also merged CTIA/OMTP into `val &
0xc00`; that cleanup is **not** in 6.12 (`git log -S 'val & 0xc00' --
sound/pci/hda/patch_conexant.c` empty). Not required: the caller-side
always-write is the fix. Applies standalone with a path/context tweak.]

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**
`b4 mbox` on msgid `20260826115344.2128835-1-songxiebing@kylinos.cn`:
11-message thread.

- v1: “Set mic pin VREF to 0x24 on headset mic plug” — 3-pole mics
  cannot record
- Takashi: fallback was meant to be headphone-only; don’t enable mic
  there
- Author: nid 0x19 is the mic pin; callback already requires presence;
  4-pole = CTIA/OMTP; 3-pole mic was the unhandled case
- Takashi: then type-detect is only debug; move the write to the caller
  and rename
- v2: that refactor + CTIA/OMTP merge; Takashi: doesn’t apply on latest
  (cleanup already landed)
- v3: rebase; Takashi: “Applied now. Thanks.”
- Landed in sound fixes for 7.3-rc1 as “Conexant headset plugin fixes”

Record: [Lore/msgid as above] [v1→v3] [No NAKs after explanation] [No
Cc: stable from reviewers] [Applied by maintainer]

**Step 4.2: CHECK WHO REVIEWED THE PATCH**
Record: [To: tiwai@suse.com, perex@perex.cz; Cc: linux-sound, linux-
kernel. Reviewed in-thread by Takashi Iwai.]

**Step 4.3: SEARCH FOR THE BUG REPORT**
Record: [No syzbot/bugzilla. Author (Kylin) described 3-pole mic
recording failure. Not a fuzzer crash.]

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**
Record: [Single patch, three revisions. v2’s 0xc00 merge is independent
cleanup already on later mainline; 6.12 does not need it.]

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**
Record: [lore.kernel.org/stable fetch returned 403. No stable discussion
in the sound thread. UNVERIFIED whether AUTOSEL already queued it.]

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

**Step 5.1: IDENTIFY KEY FUNCTIONS**
Record: [`cx_process_headset_plugin` / rename;
`cx_update_headset_mic_vref`]

**Step 5.2: TRACE CALLERS**
Record: [`cx_update_headset_mic_vref` registered only in
`patch_conexant_auto()` for vendor IDs `0x14f11f86` (CX11880) and
`0x14f11f87` (SN6140) via `snd_hda_jack_detect_enable_callback()`.
Called from HDA jack unsol/poll (`hda_jack.c` `call_jack_callback`).]

**Step 5.3: TRACE CALLEES**
Record: [`snd_hda_codec_read`/`write`, `msleep` (up to 60 ms wait for
type detect). Process context, already sleeping.]

**Step 5.4: FOLLOW THE CALL CHAIN**
Record: [Reachable from userspace by plugging a headset on those codecs.
Not a syscall crash path; common laptop jack path.]

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**
Record: [`cx_fixup_headset_recog()` already writes 0x24/0x20 from
presence alone at init. Plugin path was the inconsistent copy.]

===============================================================
PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
===============================================================

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**
Record: [Yes. `sound/pci/hda/patch_conexant.c` lines 216–256.
`7aeb2590864874` and `e60dc981221105` are ancestors of HEAD. Rename not
present. Bug introduced 2024-01, in 6.12.]

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**
Record: [Minor: path `sound/pci/hda/patch_conexant.c` vs mainline
`sound/hda/codecs/conexant.c`; 6.12 still has separate CTIA/OMTP
branches instead of `val & 0xc00`. Semantic backport is a few lines in
`cx_update_headset_mic_vref`. No API/struct dependency.]

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**
Record: [86c11d5091e11 and dd110cc00cf85 are related but different bugs.
This always-enable-0x24 change is not in the tree.]

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

**Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY**
Record: [ALSA HD-audio Conexant codec. IMPORTANT for users of those
laptops; PERIPHERAL vs core mm/net. Config: `SND_HDA_CODEC_CONEXANT`.]

**Step 7.2: ASSESS SUBSYSTEM ACTIVITY**
Record: [Active quirk stream on this file (Lenovo pin cfg, mic-bias
override, jack-detect error check). Mature driver, recent hardware-
specific fixes.]

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

**Step 8.1: DETERMINE WHO IS AFFECTED**
Record: [Driver-specific: CX11880/SN6140 (0x14f11f86/0x14f11f87),
typically laptop combo jacks.]

**Step 8.2: DETERMINE THE TRIGGER CONDITIONS**
Record: [Plug a 3-pole mic / headset that is not classified as
CTIA/OMTP, or type-detect timeout (3×20 ms). Unprivileged user, physical
jack. Common for those machines.]

**Step 8.3: DETERMINE THE FAILURE MODE SEVERITY**
Record: [Headset microphone does not record. Not
oops/deadlock/corruption. Severity: MEDIUM, user-visible audio
breakage.]

**Step 8.4: CALCULATE RISK-BENEFIT RATIO**
Record: [Benefit: high for affected hardware (mic works). Risk: very low
(few lines, same verb already used on the CTIA/OMTP path and at init).
Ratio: favorable.]

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

**Step 9.1: COMPILE THE EVIDENCE**

FOR:
- Real bug: 3-pole headset mics get no VREF 80%, so recording fails
- Same intent as 7aeb259, which is already in this tree and was
  AUTOSEL’d historically
- Matches `cx_fixup_headset_recog()` init behavior
- Small, obviously correct; maintainer reviewed and applied
- Hardware quirk class, routinely backported
- Sibling conexant headset fixes already in 6.12 (including Cc:stable
  mic-bias override)

AGAINST:
- Not crash/security/corruption
- Codec-specific
- v3 message dropped the 3-pole explanation; includes a rename
- v3 leaves a redundant inner 0x24 write
- Needs a trivial path/context adjustment

UNRESOLVED:
- Whether stable@ already discussed it (lore/stable 403)
- How many 6.12 systems ship CX11880/SN6140 (not quantified)

**Step 9.2: APPLY THE STABLE RULES CHECKLIST**
1. Obviously correct and tested? **PASS** — maintainer applied; logic
   matches init path
2. Fixes a real bug that affects users? **PASS** — 3-pole mic cannot
   record
3. Important issue? **PASS** — broken recording on combo jack (hardware
   quirk; not a panic)
4. Small and contained? **PASS** — ~one function, few lines
5. No new features or APIs? **PASS** — pin-control write already used
6. Can apply to the local tree? **PASS** — buggy code present; minor
   path/context tweak

**Step 9.3: CHECK FOR EXCEPTION CATEGORIES**
Record: [Hardware quirk/workaround for Conexant combo-jack VREF.
Qualifies.]

**Step 9.4: MAKE YOUR DECISION**
This belongs in 6.12. The bug is in this tree, the fix is surgical, and
stable users with CX11880/SN6140 otherwise keep a dead headset mic on
3-pole plugs.

What it solves: on plugin, pin 0x19 presence no longer depends on
CTIA/OMTP bits to get VREF 80% (`0x24`). That is required for 3-pole
mics to record.

Risk vs benefit: benefit is working capture on those jacks; risk is a
redundant codec verb write already used on the success path.

Concerns: backport to `sound/pci/hda/patch_conexant.c` and leave the
existing CTIA/OMTP inner writes (or drop them; either is equivalent once
the caller always writes 0x24).

Verification:
- [Phase 1] Parsed tags: Link msgid, SOB Bob Song + Takashi Iwai; no
  Fixes/Reported-by/Cc:stable
- [Phase 1] v1 on openwall/lkml: 3-pole mics cannot record without 0x24
- [Phase 2] Diff: rename + always-write 0x24 in
  `cx_update_headset_mic_vref`; inner CTIA/OMTP write kept in v3
- [Phase 2] `0x24`/`0x20` verified as IN_EN|VREF_80 vs IN_EN in
  `include/sound/hda_verbs.h`
- [Phase 3] blame: 7aeb2590864874 (2024-01-08); e60dc981221105 later;
  both ancestors of HEAD
- [Phase 3] `git merge-base --is-ancestor 7aeb2590864874 HEAD` true;
  same for e60dc981
- [Phase 3] `git log -S 'val & 0xc00' -- sound/pci/hda/patch_conexant.c`
  empty (no 0xc00 merge here)
- [Phase 4] `b4 mbox` 11-message thread; Takashi applied v3; no NAK
  after 3-pole explanation
- [Phase 4] lore.kernel.org/stable: 403, UNVERIFIED
- [Phase 5] only callers: `patch_conexant_auto` for
  0x14f11f86/0x14f11f87 → jack callback
- [Phase 5] `cx_fixup_headset_recog` already presence→0x24 at init
  (lines 167–183)
- [Phase 6] `git describe HEAD` → p-6.12-3-gc504cf0baa3d8; `make
  kernelversion` → 6.12.111
- [Phase 6] buggy functions still named `cx_process_headset_plugin` /
  `cx_update_headset_mic_vref` in `sound/pci/hda/patch_conexant.c`
- [Phase 8] Failure mode: silent headset mic, severity MEDIUM, hardware-
  specific

**YES**

 sound/hda/codecs/conexant.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/sound/hda/codecs/conexant.c b/sound/hda/codecs/conexant.c
index 862fcbe74e4f0..faaabc326f560 100644
--- a/sound/hda/codecs/conexant.c
+++ b/sound/hda/codecs/conexant.c
@@ -213,7 +213,7 @@ static void cx_remove(struct hda_codec *codec)
 	snd_hda_gen_remove(codec);
 }
 
-static void cx_process_headset_plugin(struct hda_codec *codec)
+static void cx_process_headset_detect_plug_type(struct hda_codec *codec)
 {
 	unsigned int val;
 	unsigned int count = 0;
@@ -249,10 +249,12 @@ static void cx_update_headset_mic_vref(struct hda_codec *codec, struct hda_jack_
 	 * Check hp&mic tag to process headset plugin & plugout.
 	 */
 	mic_present = snd_hda_codec_read(codec, 0x19, 0, AC_VERB_GET_PIN_SENSE, 0x0);
-	if (!(mic_present & AC_PINSENSE_PRESENCE)) /* mic plugout */
+	if (!(mic_present & AC_PINSENSE_PRESENCE)) { /* mic plugout */
 		snd_hda_codec_write(codec, 0x19, 0, AC_VERB_SET_PIN_WIDGET_CONTROL, 0x20);
-	else
-		cx_process_headset_plugin(codec);
+	} else {
+		cx_process_headset_detect_plug_type(codec);
+		snd_hda_codec_write(codec, 0x19, 0, AC_VERB_SET_PIN_WIDGET_CONTROL, 0x24);
+	}
 }
 
 static int cx_suspend(struct hda_codec *codec)
-- 
2.53.0

