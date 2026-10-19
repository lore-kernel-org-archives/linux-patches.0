Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB1F55AEC73;
	Mon, 19 Oct 2026 13:55:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418139; cv=none; b=MACvaLFArmlYepnwqQORJ+In4EkBDcWK0OA4cS2y5PfpMFS2x5Z5UZ/StIAr+Ob9evBcqBRLAKlb2DWvAM1IuQsxRpXMZQ77Lxk+vgeKB9UoHqF/fOqc2qpO+Uq/vPtWe4XmQoEdPnLqTjNGn51ilQAg3wjvrPxHFSgJvXo6vb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418139; c=relaxed/simple;
	bh=v4OhAgEDDA8R6LlG2dQP5Nt81LhplBXdxjryogR3DOA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HLGnoGnrQdCDnp5l8Jhdf20s41EKfEd9QIGOIqNXiSwOGmWh/HIvwqlGWBR9A5tVhyC8z/y2H0W74UihBRO2p9EGXTXdAwEo/Pfvl9N06um02gppPrZYx64oOktCByGs7xw+Nah1E6m6xWEpiHLE0uNIXjlXy55DCcs+XXSmdAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oOGhvkX0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oOGhvkX0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2B341F000C5;
	Mon, 19 Oct 2026 13:55:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418136;
	bh=FeGX7r180FDvb3Y2kxslhB62CVPWh4NYp016IICuyxc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oOGhvkX028q6ks1PE8QCGlEvw3CYg3l5eWOHJn0rhiniNCh38WsfEbJkgr4zUPKDw
	 +VEkHOArTELU8Nrja5ocBSS/lQp/QsGEEa6LazNfvJ7ZAfZ4uJBT+0qoP0RWEsW5WU
	 G0L+muPiZXDv2vj6q+vIG5zOEShIF+6AhbNoH1AIrgkDt3DS8+ioAKQzq5RA1nT/pm
	 OCekAnmzoG6i83sN0I50iZyi41hrYAT7/ICvdSs8aJnnMbVg/yQZ4Z0yLcl0TfBBlQ
	 02Np+j+wSC1rRYiSBsfx9bN4Nj5etZGHwY8nQvKCNFPERYOYvCCMdDvy8fNhtDIjTV
	 +bnc7CQ0kiXGA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Zeyu Li <13776528859@163.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>,
	perex@perex.cz,
	tiwai@suse.com,
	linux-sound@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] ALSA: hda/realtek: Add ALC235 support for headset mode
Date: Mon, 19 Oct 2026 09:45:29 -0400
Message-ID: <20261019135441.1420968-38-sashal@kernel.org>
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

From: Zeyu Li <13776528859@163.com>

[ Upstream commit 9ee4266827cfb67b9fbb89136ea6a8f3d7809f5c ]

The ALC235 (0x10ec0235) is registered as the ALC255 codec variant in
patch_alc269(), but the headset mode functions were missing a case
for it, so the CTIA/OMTP jack type detection and routing never ran
on this codec. As a result, a plugged-in headset is detected (jack
presence works) but the microphone signal is never routed, leaving
the capture stream permanently silent.

Verified on an ASUS M5451GA laptop (HDA:10ec0235,10431814): with the
ALC255 coef sequence applied, the headset microphone works correctly.

Signed-off-by: Zeyu Li <13776528859@163.com>
Link: https://patch.msgid.link/20260926140336.27896-1-13776528859@163.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit message forensics

**Step 1.1 — Subject**
Record: **[ALSA/hda/realtek] [Add] Add ALC235 support for headset mode**

The verb is “Add”, but the body is a missing-ID fix: ALC235 is already
treated as an ALC255 variant, and the headset-mode switches never
included it.

**Step 1.2 — Tags**
Record:
- **Fixes:** none (expected for this review)
- **Reported-by:** none
- **Tested-by:** none (author states hardware verification in the body)
- **Reviewed-by / Acked-by:** none on the commit
- **Link:**
  https://patch.msgid.link/20260926140336.27896-1-13776528859@163.com
- **Cc: stable:** none (expected)
- **Signed-off-by:** Zeyu Li (author); Takashi Iwai (ALSA maintainer)
- Pipeline tags ignored: `[Upstream commit ...]`, `Signed-off-by: Sasha
  Levin`

**Step 1.3 — Body**
Record:
- **Bug:** ALC235 (`0x10ec0235`) is classified as `ALC269_TYPE_ALC255`
  in `patch_alc269()`, but the six headset-mode helpers omit that vendor
  ID.
- **Symptom:** combo-jack presence works; headset capture stays silent
  because CTIA/OMTP detection and mic routing never run.
- **Root cause:** `switch (codec->core.vendor_id)` falls through with no
  match, so `alc_process_coef_fw(codec, coef0255)` is never applied.
- **Verification:** ASUS M5451GA (`HDA:10ec0235,10431814`); ALC255 coef
  sequence restores headset mic.
- **Version info:** none in the message. Codec ID has been in-tree since
  2014.

**Step 1.4 — Hidden bug fix?**
Record: Not hidden. This is a hardware-routing bug written as “Add
support”. It does not add a driver or API; it fills in a missing vendor-
ID case in existing tables.

## Phase 2: Diff analysis

**Step 2.1 — Inventory**
Record:
- **File:** `sound/hda/codecs/realtek/realtek.c` — **+6 / −0**
- **Functions:** `alc_headset_mode_unplugged`,
  `alc_headset_mode_mic_in`, `alc_headset_mode_default`,
  `alc_headset_mode_ctia`, `alc_headset_mode_omtp`,
  `alc_determine_headset_type`
- **Scope:** single-file, surgical. One `case 0x10ec0235:` added
  immediately above each existing `case 0x10ec0255:`.

**Step 2.2 — Flow change**
Record: Before, those switches did nothing for vendor `0x10ec0235`.
After, ALC235 uses the same ALC255 coefficient firmware already used for
`0x10ec0255` (unplug, mic-in, default headphone, CTIA, OMTP, and type-
detect).

Author-reported working values `COEF 0x45=0xd489`, `0x1b=0x0c2b` match
`alc_headset_mode_ctia()`’s `coef0255` exactly.

**Step 2.3 — Bug mechanism**
Record: **Hardware workaround / missing codec ID** in existing headset-
mode tables. Without the case, jack detect still works via generic HP
automute, but combo-jack mic routing never happens.

**Step 2.4 — Fix quality**
Record: Minimal and obviously correct given that `patch_alc269()`
already maps ALC235 → ALC255. Regression risk is low: the new cases only
run when headset-mode hooks are installed (`alc_fixup_headset_mode` /
`alc_probe_headset_mode`). Realtek confirmed compatibility (Phase 4).
Residual incompleteness: `alc255_set_default_jack_type()` still has only
`0x10ec0255`; the author still got a working headset mic without that
extra case.

## Phase 3: Git history

**Step 3.1 — Blame**
Record:
- Headset-mode switches (minus the new case) come from the 6.16-era
  Realtek split `aeeb85f26c3bb` (2025-07-11), itself a move of older
  `patch_realtek.c` logic.
- ALC235 vendor ID added in `92f974df34601` (2014-06-06, Kailang Yang):
  “New vendor ID for ALC233 … compatible with ALC255. It is use for
  Lenovo.”
- Variant assignment added in `ea04a1dbf8b1d` (2018-04-25, Kailang Yang,
  already sent to stable). Maintainer note then: *“the chip is 10ec:0235
  bonding for ALC233b, which is equivalent with ALC255. It's only used
  for Lenovo. The chip needs no alc_process_coef_fw() for headset unlike
  ALC255.”*

That 2018 note is why the ID was classified as ALC255 but
**intentionally omitted** from headset coef switches. The 2026 report is
an ASUS machine, not Lenovo, and Realtek later said the ALC255 sequence
is compatible.

**Step 3.2 — Fixes tag**
Record: No `Fixes:` tag. The incomplete classification dates to
`ea04a1dbf8b1d` (2018), which is in this tree.

**Step 3.3 — File history**
Record: Recent `realtek.c` / `alc269.c` history is the usual stream of
laptop quirks. No prerequisite refactor is required. Not a `patch X/Y`
series.

**Step 3.4 — Author**
Record: Zeyu Li has no other Realtek commits in this tree. This is a
user-reported hardware fix reviewed by the ALSA maintainer and a Realtek
engineer, not a maintainer-authored cleanup.

**Step 3.5 — Dependencies**
Record: Standalone. It only adds a `case` next to an existing
`0x10ec0255` arm. Those functions and `coef0255` already exist here. No
new helpers.

## Phase 4: Mailing list / external research

**Step 4.1 — Original discussion**
Record:
- Lore/msgid:
  https://patch.msgid.link/20260926140336.27896-1-13776528859@163.com
- `b4 dig -c 9ee4266827cfb67b9fbb89136ea6a8f3d7809f5c` matched that
  thread.
- Revisions: same patch sent twice (lkml + linux-sound). No v2/v3 code
  change.
- Takashi Iwai (28 Sep 2026): *“I'm not sure whether it's 100% safe…
  Kailang, could you check it? Can ALC235 be fully compatible in this
  manner?”*
- Author follow-up: jack sense and VREF were already correct; capture
  stayed silent until ALC255 CTIA coefs were applied.
- **Kailang Yang, Realtek (1 Oct 2026): “Yes, it's compatible.”**
- Takashi then applied the patch. No NAK.

**Step 4.2 — Recipients (`b4 dig -w`)**
Record: Zeyu Li; linux-sound; Takashi Iwai; Jaroslav Kysela. Realtek
(Kailang) was added during review.

**Step 4.3 — Bug report**
Record: Reporter is the author, on a specific ASUS laptop. One machine,
but a concrete silent-mic failure with before/after coefs. No
syzbot/bugzilla.

**Step 4.4 — Series**
Record: Standalone single patch. No sibling commits required.

**Step 4.5 — Stable list**
Record: **UNVERIFIED** — lore.kernel.org/stable returned HTTP 403. No
other evidence it was rejected for stable.

## Phase 5: Code semantic analysis

**Step 5.1 — Functions**
Record: the six headset-mode helpers listed in 2.1. They are called only
from `alc_update_headset_mode()`.

**Step 5.2 — Callers**
Record:
- `alc_update_headset_mode()` ← `alc_update_headset_mode_hook` (capture
  mux), `alc_update_headset_jack_cb` (HP jack), `alc_fixup_headset_mode`
  INIT, `alc_probe_headset_mode` (installs the hooks).
- Those hooks are installed only when a headset-mode fixup is active
  (`ALC255_FIXUP_HEADSET_MODE`, `model=alc255-asus`, etc.).
- This tree has **no** PCI/pin quirk for ASUS `1043:1814`. Existing
  ALC235 pin quirks are Lenovo-only and do **not** enable headset mode.
  The author’s box therefore needed a headset-mode fixup or `model=` to
  hit this path. The commit still fixes every ALC235 device that already
  uses that path.

**Step 5.3 — Callees**
Record: `alc_process_coef_fw`, `alc_write_coef_idx`,
`alc_read_coef_idx`, `snd_hda_set_pin_ctl_cache`. Codec coefficient
writes plus pin VREF. No locking/alloc/API changes.

**Step 5.4 — Reachability**
Record: Userspace-reachable: plug a headset and select the headset-mic
input on a machine whose quirk/model enables headset mode. Unprivileged
audio use; not a syscall crash path.

**Step 5.5 — Similar patterns**
Record: Same table already groups sibling IDs
(`0x10ec0230`/`0236`/`0256`, `0x10ec0234`/`0274`/`0294`). Adding `0235`
next to `0255` matches that pattern. The only remaining
`0x10ec0255`-only switch is `alc255_set_default_jack_type()` in
`alc269.c`.

## Phase 6: This tree (6.18.y)

**Step 6.1 — Does the bug exist here?**
Record: **Yes.** Local tree is **6.18.57** (`git describe`:
`v6.18.57-155-gcdf239ca885b2`; Makefile `VERSION=6 PATCHLEVEL=18
SUBLEVEL=57`).

Without this change (parent of the candidate):
- `patch_alc269()` already has `case 0x10ec0235:` → `ALC269_TYPE_ALC255`
- Headset-mode switches have only `case 0x10ec0255:`
- File path is already `sound/hda/codecs/realtek/realtek.c` (split
  commit is an ancestor)

The codec has been present since 2014; the ALC255 classification since
2018. This is not post-6.18 hardware enablement of a new driver.

**Step 6.2 — Backport difficulty**
Record: **Clean apply.** Same file, same six switches, same neighboring
`0x10ec0255` cases. No structural conflict.

**Step 6.3 — Related fixes already here?**
Record: No other ALC235 headset-mode fix. No follow-up on `realtek.c`
after this candidate that would supersede it.

## Phase 7: Subsystem context

**Step 7.1**
Record: **ALSA HD-audio / Realtek codec.** Criticality: **IMPORTANT**
(common laptop audio), not core mm/VFS. Realtek HDA is the default codec
path on a large fraction of x86 laptops.

**Step 7.2**
Record: Very active (many recent laptop quirks). That is normal for this
file and is why codec-ID / quirk additions are routinely taken into
stable.

## Phase 8: Impact and risk

**Step 8.1 — Who is affected**
Record: Users of Realtek ALC235 (`CONFIG_SND_HDA_CODEC_REALTEK`) whose
machine enables headset mode (quirk or `model=`). Confirmed hardware:
ASUS M5451GA. Older Lenovo ALC235 boxes use other pin quirks and do not
enter these switches.

**Step 8.2 — Trigger**
Record: Plug a CTIA/OMTP headset and use the headset mic. Common laptop
action. Unprivileged.

**Step 8.3 — Failure mode**
Record: Headset playback/jack detect works; **headset microphone capture
is permanently silent**. Severity: **HIGH** for affected laptops (broken
input device), not a panic/UAF. This is the standard “audio hardware
quirk” class.

**Step 8.4 — Risk vs benefit**
Record:
- **Benefit:** restores headset mic on ALC235 machines that already go
  through headset mode; Realtek-confirmed; hardware-tested.
- **Risk:** very low (6 fallthrough cases, existing coef table).
  Theoretical risk to old Lenovo ALC233b bonding is mitigated by (a)
  those quirks not enabling headset mode, and (b) Kailang’s 2026
  “compatible” ack.
- **Ratio:** favorable.

## Phase 9: Synthesis

**Step 9.1 — Evidence**

For:
- Real user-visible bug (silent headset mic) on identified hardware
- 6-line vendor-ID addition to an existing driver table (hardware-quirk
  exception)
- Codec already present and classified as ALC255 in this 6.18 tree
- Applies cleanly; no new API; standalone
- Tested by the author; ALSA maintainer applied it after Realtek
  confirmation
- Same pattern as other Realtek headset vendor-ID additions that stable
  accepts

Against:
- Subject reads like a feature (“Add support”)
- 2018 Realtek note said this bonding originally needed **no** headset
  `alc_process_coef_fw()` (Lenovo-only)
- No machine-specific quirk for `1043:1814` in this tree, so the ASUS
  laptop may still need `model=alc255-asus` (or a later quirk) for the
  new cases to run
- `alc255_set_default_jack_type()` still omits ALC235

Unresolved:
- Stable-list discussion (lore 403)

The “against” items do not outweigh the fix. The 2018 note is superseded
by the same Realtek engineer in 2026. Missing `model=`/quirk is a
separate enablement issue; this commit is still the required routing fix
once headset mode is on. Incomplete default-jack-type setup did not
prevent the reported fix from working.

**Step 9.2 — Stable rules**
1. Obviously correct and tested? **PASS** — fallthrough onto the
   existing ALC255 path; hardware + Realtek + maintainer.
2. Real bug affecting users? **PASS** — silent headset capture.
3. Important? **PASS** — broken headset mic on laptop HDA; hardware-
   quirk class.
4. Small and contained? **PASS** — +6 lines, one file.
5. No new features/APIs? **PASS** — missing ID in existing tables, not a
   new driver.
6. Applies to this 6.18 tree? **PASS** — same file and switches.

**Step 9.3 — Exception**
Record: **Hardware quirk / missing codec ID** in an existing Realtek HDA
driver. This is an allowed stable exception.

**Step 9.4 — Decision**
This tree is 6.18.y. The buggy omission exists here. The patch is the
standard Realtek headset-ID fix, confirmed by Realtek, and is
appropriate for this stable tree.

## What this means for 6.18 users

ALC235 has been registered for years and is already treated as ALC255,
but the headset-mode coefficient path never ran. On machines that use
that path, a plugged headset is detected and the mic stays silent.
Adding `0x10ec0235` beside `0x10ec0255` is a 6-line, already-tested
hardware quirk with no API change and a clean apply on this tree.

## Verification
- [Phase 1] Parsed tags: Link to msgid `20260926140336.27896-1`; SOBs
  Zeyu Li + Takashi Iwai; no Fixes/Reported-by/Cc-stable
- [Phase 2] Diff: +6 `case 0x10ec0235:` lines in six headset-mode
  functions in `sound/hda/codecs/realtek/realtek.c`
- [Phase 2] `coef0255` in `alc_headset_mode_ctia()` is `WRITE_COEF(0x45,
  0xd489)` + `WRITE_COEF(0x1b, 0x0c2b)`, matching the author’s test
- [Phase 3] `git describe HEAD` / `make kernelversion`: **6.18.57**
- [Phase 3] `git show 92f974df34601`: ALC235 ID added 2014 as
  ALC233/ALC255-compatible
- [Phase 3] `git show ea04a1dbf8b1d`: 2018 variant assignment + note
  that headset coefs were then thought unnecessary
- [Phase 3] Parent of candidate: headset switches have `0x10ec0255`
  only; `patch_alc269()` already has `0x10ec0235` → `ALC269_TYPE_ALC255`
- [Phase 3] `git log --author="Zeyu Li"`: only this commit in-tree
- [Phase 4] `b4 dig -c 9ee4266827cfb…`: thread at
  patch.msgid.link/20260926140336.27896-1
- [Phase 4] `b4 dig -a`: same patch, no later revision
- [Phase 4] `b4 dig -w`: linux-sound, Takashi Iwai, Jaroslav Kysela
- [Phase 4] mbox: Takashi asked Realtek; Kailang: “Yes, it's
  compatible.”; Takashi applied
- [Phase 5] Callers of the six functions are only
  `alc_update_headset_mode()`; that is wired only by headset-mode fixups
- [Phase 5] No `1043:1814` / M5451 quirk in `alc269.c`; ASUS pin quirks
  match `0x10ec0255` only
- [Phase 6] File and buggy switches exist in this 6.18 checkout; Realtek
  split `aeeb85f26c3bb` is an ancestor
- [Phase 6] Expected apply: clean
- [Phase 8] Failure mode: silent headset mic, severity HIGH for affected
  laptops
- UNVERIFIED: lore.kernel.org/stable search (HTTP 403)

The patch is a small, tested hardware-quirk fix for a real silent-mic
bug that exists in this 6.18 tree.

**YES**

 sound/hda/codecs/realtek/realtek.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/sound/hda/codecs/realtek/realtek.c b/sound/hda/codecs/realtek/realtek.c
index ca377a5adadb5..a1529650950d8 100644
--- a/sound/hda/codecs/realtek/realtek.c
+++ b/sound/hda/codecs/realtek/realtek.c
@@ -1305,6 +1305,7 @@ static void alc_headset_mode_unplugged(struct hda_codec *codec)
 	}
 
 	switch (codec->core.vendor_id) {
+	case 0x10ec0235:
 	case 0x10ec0255:
 		alc_process_coef_fw(codec, coef0255);
 		break;
@@ -1420,6 +1421,7 @@ static void alc_headset_mode_mic_in(struct hda_codec *codec, hda_nid_t hp_pin,
 	};
 
 	switch (codec->core.vendor_id) {
+	case 0x10ec0235:
 	case 0x10ec0255:
 		alc_write_coef_idx(codec, 0x45, 0xc489);
 		snd_hda_set_pin_ctl_cache(codec, hp_pin, 0);
@@ -1575,6 +1577,7 @@ static void alc_headset_mode_default(struct hda_codec *codec)
 		alc_process_coef_fw(codec, coef0225);
 		alc_hp_enable_unmute(codec, 75);
 		break;
+	case 0x10ec0235:
 	case 0x10ec0255:
 		alc_process_coef_fw(codec, coef0255);
 		break;
@@ -1676,6 +1679,7 @@ static void alc_headset_mode_ctia(struct hda_codec *codec)
 	};
 
 	switch (codec->core.vendor_id) {
+	case 0x10ec0235:
 	case 0x10ec0255:
 		alc_process_coef_fw(codec, coef0255);
 		break;
@@ -1793,6 +1797,7 @@ static void alc_headset_mode_omtp(struct hda_codec *codec)
 	};
 
 	switch (codec->core.vendor_id) {
+	case 0x10ec0235:
 	case 0x10ec0255:
 		alc_process_coef_fw(codec, coef0255);
 		break;
@@ -1894,6 +1899,7 @@ static void alc_determine_headset_type(struct hda_codec *codec)
 	}
 
 	switch (codec->core.vendor_id) {
+	case 0x10ec0235:
 	case 0x10ec0255:
 		alc_process_coef_fw(codec, coef0255);
 		msleep(300);
-- 
2.53.0

