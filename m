Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C7F84746AB;
	Mon, 31 Aug 2026 13:51:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184290; cv=none; b=HZQtdQ3MUMPEIvO6ynME22naYX+7utksR5JScAvtvGmqaXC9T7lV/DKdyVKglKBSzEh2FlHjtvCwmI4kiIXyOc1WhS4zB9ARTnfA/FJFcN/7WA6Rq/Fzd4Zy47BNZRVDBIdjg0ZUUk0mo/u7vXbaB2JM83AERW5NMw0heeT+z2M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184290; c=relaxed/simple;
	bh=tv2t9Qi3Md7T4llAZTdrrda9R0abp35jq5QwT9YHbJs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QMb2SWBxgwtTj22pGyzM8k4DKVI/wdzOrMxdVhgGS7n4wdVWqjWKu215U/wyJb9jlYApaLR38Ignu/fgzIIOmjWv6LKFnV1fm2GnlwnyvILJrfSMCjbE9fxDLn5ASaZSsIMuihUFzLNrsbcFzGFTf/m/SsbMCeAfTOj2+ZU7gpM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GnL2iVXJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GnL2iVXJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08FF51F00A3D;
	Mon, 31 Aug 2026 13:51:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788184288;
	bh=mOxVgusYOuBLDF9wnkORRZlaJ14L8gZxA3VUemltWLM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GnL2iVXJ96zQT4MzXcLCkxVSdrhV5Ruju1/MyHsHmRxDLHrNw7GCEiNabEUJ88xH6
	 IunTdUjga7GwgjT3VNkmnqxggyyvZyEr0UP7DoB9bISwSvba6Z+ze6BgaZPiNwnVMO
	 vAjIqr4bZGc+O1h2oMp60Ch2McgjMJv4Yf693UzqbDapFqsLeJ7Ij2ABdrjlr/3qhU
	 ml4WPeW7SRfsuA73gj5/zokLBM5M543UnncwG2Ails4jkYXFsN+De2iuctXXFurJyC
	 rx7xosh8isD0K9H4GSHFzbhWpRipCHXbIEQ5oV0eEAukZjo5pRR224eesBji1isHuz
	 LfkiqT3s6nQKg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Evelyn Ali <evelynali99@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>,
	perex@perex.cz,
	tiwai@suse.com,
	linux-sound@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] ALSA: hda/realtek: ALC882: Fixup for Clevo P775TM1
Date: Mon, 31 Aug 2026 09:30:31 -0400
Message-ID: <20260831133314.4125787-603-sashal@kernel.org>
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

From: Evelyn Ali <evelynali99@gmail.com>

[ Upstream commit def5e78a4e003c83adc9a8b4b72534def3a49641 ]

Clevo P775TM1 laptops come with an ESS Sabre HiFi DAC. Setting
0x1b pin VREF to 80% enables said DAC output.

Signed-off-by: Evelyn Ali <evelynali99@gmail.com>
Link: https://patch.msgid.link/20260602214122.78020-1-evelynali99@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: PARSE THE SUBJECT LINE
**Record:** `[ALSA: hda/realtek: ALC882]` `[Fixup]` — Add hardware fixup
quirk for Clevo P775TM1 laptop audio (ALC882/898 codec path).

### Step 1.2: PARSE ALL COMMIT MESSAGE TAGS
**Record:**
- **Signed-off-by:** Evelyn Ali \<evelynali99@gmail.com\> (author)
- **Link:**
  https://patch.msgid.link/20260602214122.78020-1-evelynali99@gmail.com
- **Signed-off-by:** Takashi Iwai \<tiwai@suse.de\> (ALSA/HDA
  maintainer, committer)
- No Fixes:, Reported-by:, Tested-by:, Reviewed-by:, Acked-by:, or Cc:
  stable tags
- Notable: Maintainer commit; v2 patch on lore; no syzbot/fuzzer
  involvement

### Step 1.3: ANALYZE THE COMMIT BODY TEXT
**Record:**
- **Bug:** Clevo P775TM1 uses an ESS Sabre HiFi DAC; pin 0x1b VREF must
  be 80% to enable DAC output
- **Symptom:** No audio output from the external headphone amp / Sabre
  DAC without the VREF setting
- **Version info:** None stated
- **Root cause:** Hardware requires specific pin VREF configuration not
  provided by default or generic Clevo quirk

### Step 1.4: DETECT HIDDEN BUG FIXES
**Record:** Not disguised — explicit hardware fixup/quirk. Fixes broken
audio on a specific laptop model, not a crash or memory bug.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: INVENTORY THE CHANGES
**Record:**
- **File:** `sound/hda/codecs/realtek/alc882.c` (+22 lines, 0 removed)
- **Functions modified/added:** `alc898_fixup_clevo_p775tm1()` (new)
- **Tables modified:** enum fixup IDs, `alc882_fixups[]`,
  `alc882_fixup_tbl[]`, `alc882_fixup_models[]`
- **Scope:** Single-file, surgical hardware quirk addition

### Step 2.2: CODE FLOW CHANGE
**Record:**
- **Hunk 1 (enum):** Adds `ALC898_FIXUP_CLEVO_P775TM1` fixup ID
- **Hunk 2 (new function):** On `HDA_FIXUP_ACT_PRE_PROBE`, sets pin 0x1b
  to `PIN_VREF80` via `snd_hda_set_pin_ctl_cache()` and sets
  `spec->gen.keep_vref_in_automute = 1` so automute does not clear VREF
- **Hunk 3 (fixups table):** Registers fixup function, chained to
  `ALC882_FIXUP_EAPD`
- **Hunk 4 (quirk table):** `SND_PCI_QUIRK(0x1558, 0x7709, "Clevo
  P775TM1", ...)` — PCI SSID match
- **Hunk 5 (model table):** Adds model name `clevo-p775tm1` for manual
  override

### Step 2.3: IDENTIFY THE BUG MECHANISM
**Record:** **Category (h): Hardware workaround / audio codec quirk.**
Pin 0x1b VREF at 80% gates the ESS Sabre HiFi DAC; without it the
external amp stays disabled. `keep_vref_in_automute` prevents the
generic automute path from stripping VREF during jack events.

### Step 2.4: ASSESS THE FIX QUALITY
**Record:** Fix is minimal and follows established patterns in the same
file (`alc889_fixup_mbp_vref`, other Clevo fixups). Chaining to
`ALC882_FIXUP_EAPD` matches other Clevo entries. Low regression risk —
only affects PCI SSID `0x1558:0x7709`. No lock or API changes.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: BLAME THE CHANGED LINES
**Record:** Insertion point (between `0x70d1` and `0x7714` Clevo quirks)
dates to `aeeb85f26c3bb` (2025-07-09, Realtek driver split). No pre-
existing bug — this is missing hardware support, not a regression from
prior code.

### Step 3.2: FOLLOW THE FIXES: TAG
**Record:** N/A — no Fixes: tag present.

### Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES
**Record:** Local tree at `v6.18.44` has only two commits touching
`alc882.c`: `e1d695b45fd11` (probe rewrite) and `aeeb85f26c3bb` (driver
split). Commit `def5e78a4e003` is on `master` but not in
`stable/linux-6.18.y`. Standalone single-patch fix, not part of a
series.

### Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS
**Record:** Evelyn Ali has no other commits in this tree. Takashi Iwai
is the ALSA/HDA maintainer and authored the surrounding Clevo quirk
infrastructure.

### Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS
**Record:** No dependencies. Required symbols (`PIN_VREF80`,
`snd_hda_set_pin_ctl_cache`, `keep_vref_in_automute`,
`ALC882_FIXUP_EAPD`) all exist in this tree. `git apply --check` on the
patch succeeds cleanly.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION
**Record:** `b4 dig -c def5e78a4e003` → [v2] thread at
https://patch.msgid.link/20260602214122.78020-1-evelynali99@gmail.com.
Only v2 found (no v1 in series list). Maintainer merged without
objections in thread.

### Step 4.2: CHECK WHO REVIEWED THE PATCH
**Record:** `b4 dig -w`: To linux-sound@vger.kernel.org, Evelyn Ali,
Takashi Iwai. Appropriate subsystem list and maintainer CC'd.

### Step 4.3: SEARCH FOR THE BUG REPORT
**Record:** No external bug report or syzbot link. Hardware issue
reported by patch author on their own hardware.

### Step 4.4: CHECK FOR RELATED PATCHES AND SERIES
**Record:** Standalone 1-patch series. No prerequisites.

### Step 4.5: CHECK STABLE MAILING LIST HISTORY
**Record:** Not searched on lore stable list; no stable nomination found
in patch thread. Absence of Cc: stable is expected per review
instructions.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF
**Record:** `alc898_fixup_clevo_p775tm1()` (new fixup callback)

### Step 5.2: TRACE CALLERS
**Record:** Invoked by HDA fixup framework during codec probe for
matching PCI quirk `0x1558:0x7709`. Called from device enumeration when
the Realtek codec driver loads — standard driver probe path for affected
hardware.

### Step 5.3: TRACE CALLEES
**Record:** `snd_hda_set_pin_ctl_cache(codec, 0x1b, PIN_VREF80)` —
caches pin control for node 0x1b with 80% VREF. Sets
`spec->gen.keep_vref_in_automute` read later in
`sound/hda/codecs/generic.c` automute path.

### Step 5.4: FOLLOW THE CALL CHAIN
**Record:** PCI device probe → HDA codec driver → quirk table lookup by
SSID → fixup chain (`ALC898_FIXUP_CLEVO_P775TM1` → `ALC882_FIXUP_EAPD`)
→ pin configuration at probe. Reachable on boot for matching hardware;
not userspace-triggerable but affects all audio on that machine.

### Step 5.5: SEARCH FOR SIMILAR PATTERNS
**Record:** Same `keep_vref_in_automute` + VREF pattern in
`alc889_fixup_mbp_vref()` and `alc889_fixup_mac_pins()` in the same file
(lines 109–144). Multiple Clevo-specific fixups already present
(`ALC1220_FIXUP_CLEVO_P950`, `ALC1220_FIXUP_CLEVO_PB51ED`, etc.).

---

## PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE

### Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?
**Record:** Local tree is **v6.18.44** (`stable/linux-6.18.y`). The fix
is **absent** — grep finds no `P775TM1`, `0x7709`, or
`ALC898_FIXUP_CLEVO_P775TM1`. Without the quirk, `0x1558:0x7709` matches
only the generic `SND_PCI_QUIRK_VENDOR(0x1558, "Clevo laptop",
ALC882_FIXUP_EAPD)` at line 682, which does not set pin 0x1b VREF. The
broken behavior (no Sabre DAC output) is present for P775TM1 owners on
this tree.

### Step 6.2: CHECK FOR BACKPORT COMPLICATIONS
**Record:** **Clean apply** — `git apply --check` passes with no
conflicts. File structure matches mainline commit base.

### Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE
**Record:** No duplicate or alternative fix for P775TM1 found. Clevo
VREF/quirk infrastructure is present from the 2025 driver split.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY
**Record:** **sound/ALSA HDA Realtek codec driver** — IMPORTANT (affects
audio on specific laptop hardware, not core kernel paths).

### Step 7.2: ASSESS SUBSYSTEM ACTIVITY
**Record:** Actively maintained; frequent laptop quirk additions on
stable (e.g., `04dd210180575` Clevo mic fix in this tree).

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: DETERMINE WHO IS AFFECTED
**Record:** **Driver-specific / hardware-specific** — Clevo P775TM1
laptops with PCI SSID `0x1558:0x7709` and Realtek ALC898-class codec.

### Step 8.2: DETERMINE THE TRIGGER CONDITIONS
**Record:** Triggers at every boot/probe on matching hardware. Not
timing-dependent. Unprivileged users cannot trigger it arbitrarily, but
all users on that laptop are affected.

### Step 8.3: DETERMINE THE FAILURE MODE SEVERITY
**Record:** **No audio output** from the ESS Sabre HiFi DAC / external
headphone amp. **Severity: MEDIUM** — serious functional impairment for
affected users, but no crash, corruption, deadlock, or security impact.

### Step 8.4: CALCULATE RISK-BENEFIT RATIO
**Record:**
- **Benefit:** Enables working audio on Clevo P775TM1 — real hardware
  fix for real users
- **Risk:** Very low — 22 lines, SSID-gated, established pattern
- **Ratio:** Strong benefit, minimal risk — standard stable quirk
  material

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: COMPILE THE EVIDENCE

**FOR backporting:**
- Hardware codec quirk — explicit stable exception category
- Fixes real user-visible bug (no audio) on Clevo P775TM1
- Small (22 lines), single file, applies cleanly to v6.18.44
- Follows established patterns in same file (VREF +
  `keep_vref_in_automute`, Clevo quirk table)
- Merged by subsystem maintainer (Takashi Iwai)
- All prerequisites present in this tree
- Fix not yet in `stable/linux-6.18.y`

**AGAINST backporting:**
- Not a crash/security/corruption issue
- Affects narrow hardware population
- No Tested-by: tag beyond author/maintainer
- New laptop model — limited user base on 6.18.y today

**Unresolved:** None material to the decision.

### Step 9.2: STABLE RULES CHECKLIST
1. Obviously correct and tested? **PASS** — standard HDA quirk pattern;
   maintainer-merged v2
2. Fixes a real bug affecting users? **PASS** — broken audio on P775TM1
3. Important issue? **PASS** (functional/hardware) — no audio is a
   significant usability failure for affected hardware, though not
   CRITICAL severity
4. Small and contained? **PASS** — 22 lines, one file
5. No new features or APIs? **PASS** — hardware quirk exception applies
6. Can apply to the local tree? **PASS** — clean apply verified

### Step 9.3: CHECK FOR EXCEPTION CATEGORIES
**Record:** **Hardware quirk / audio codec quirk** — automatic stable
YES category per stable rules.

### Step 9.4: DECISION RATIONALE

For **linux-6.18.y (v6.18.44)**, this commit should be backported. It is
a textbook HDA Realtek laptop quirk: PCI SSID-specific pin VREF
configuration enabling an external DAC. The same file already contains
numerous Clevo fixups using identical infrastructure. The patch is
absent from this stable tree, applies without modification, and fixes a
real hardware issue with negligible regression risk.

---

## Verification

- [Phase 1] `git show def5e78a4e003`: parsed tags (SOB Evelyn Ali, Link,
  SOB Takashi Iwai); no Fixes/Reported-by/Tested-by
- [Phase 1] Subject parsed: ALSA hda/realtek ALC882 fixup for Clevo
  P775TM1
- [Phase 2] Diff: +22 lines in `alc882.c`; new
  `alc898_fixup_clevo_p775tm1()`, quirk `0x1558:0x7709`
- [Phase 3] `git describe HEAD`: v6.18.44; tree is `stable/linux-6.18.y`
- [Phase 3] `git log HEAD..master --grep P775TM1`: commit only on
  master, not in stable branch
- [Phase 3] `git apply --check` on patch from `def5e78a4e003`: applies
  cleanly
- [Phase 3] `git blame` lines 666–668: surrounding Clevo quirks from
  `aeeb85f26c3bb` (2025-07-09)
- [Phase 4] `b4 dig -c def5e78a4e003`: lore URL
  https://patch.msgid.link/20260602214122.78020-1-evelynali99@gmail.com
- [Phase 4] `b4 dig -a`: v2 only, standalone patch
- [Phase 4] `b4 dig -w`: CC'd linux-sound@vger.kernel.org and Takashi
  Iwai
- [Phase 4] `b4 dig -m /tmp/p775tm1.mbox`: thread saved; maintainer
  merge reply, no stable nomination or NAK
- [Phase 5] `grep keep_vref_in_automute`: used in `alc882.c` lines
  126/143 and `generic.c` line 4412
- [Phase 5] `grep PIN_VREF80`: defined in `hda_local.h`, used across HDA
  codecs
- [Phase 6] `grep P775TM1|0x7709|ALC898_FIXUP`: no matches — fix absent
  from local tree
- [Phase 6] Read `alc882.c` line 682: generic Clevo EAPD quirk exists
  but lacks VREF fix
- [Phase 6] Read `alc882.c` lines 666–668: gap where `0x7709` quirk
  should be inserted
- [Phase 8] Failure mode: no audio from Sabre DAC; severity MEDIUM
  (functional, not crash)

**YES**

 sound/hda/codecs/realtek/alc882.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/sound/hda/codecs/realtek/alc882.c b/sound/hda/codecs/realtek/alc882.c
index 529fecd5baa0a..fd466b6985f05 100644
--- a/sound/hda/codecs/realtek/alc882.c
+++ b/sound/hda/codecs/realtek/alc882.c
@@ -61,6 +61,7 @@ enum {
 	ALC887_FIXUP_ASUS_HMIC,
 	ALCS1200A_FIXUP_MIC_VREF,
 	ALC888VD_FIXUP_MIC_100VREF,
+	ALC898_FIXUP_CLEVO_P775TM1,
 };
 
 static void alc889_fixup_coef(struct hda_codec *codec,
@@ -236,6 +237,19 @@ static void alc1220_fixup_clevo_pb51ed(struct hda_codec *codec,
 	alc_fixup_headset_mode_no_hp_mic(codec, fix, action);
 }
 
+/* On Clevo P775TM1, VREF of pin 0x1b enables the external headphone amp */
+static void alc898_fixup_clevo_p775tm1(struct hda_codec *codec,
+				       const struct hda_fixup *fix, int action)
+{
+	struct alc_spec *spec = codec->spec;
+
+	if (action != HDA_FIXUP_ACT_PRE_PROBE)
+		return;
+
+	snd_hda_set_pin_ctl_cache(codec, 0x1b, PIN_VREF80);
+	spec->gen.keep_vref_in_automute = 1;
+}
+
 static void alc887_asus_hp_automute_hook(struct hda_codec *codec,
 					 struct hda_jack_callback *jack)
 {
@@ -560,6 +574,12 @@ static const struct hda_fixup alc882_fixups[] = {
 			{}
 		}
 	},
+	[ALC898_FIXUP_CLEVO_P775TM1] = {
+		.type = HDA_FIXUP_FUNC,
+		.v.func = alc898_fixup_clevo_p775tm1,
+		.chained = true,
+		.chain_id = ALC882_FIXUP_EAPD,
+	},
 };
 
 static const struct hda_quirk alc882_fixup_tbl[] = {
@@ -664,6 +684,7 @@ static const struct hda_quirk alc882_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1558, 0x67f1, "Clevo PC70H[PRS]", ALC1220_FIXUP_CLEVO_PB51ED_PINS),
 	SND_PCI_QUIRK(0x1558, 0x67f5, "Clevo PD70PN[NRT]", ALC1220_FIXUP_CLEVO_PB51ED_PINS),
 	SND_PCI_QUIRK(0x1558, 0x70d1, "Clevo PC70[ER][CDF]", ALC1220_FIXUP_CLEVO_PB51ED_PINS),
+	SND_PCI_QUIRK(0x1558, 0x7709, "Clevo P775TM1", ALC898_FIXUP_CLEVO_P775TM1),
 	SND_PCI_QUIRK(0x1558, 0x7714, "Clevo X170SM", ALC1220_FIXUP_CLEVO_PB51ED_PINS),
 	SND_PCI_QUIRK(0x1558, 0x7715, "Clevo X170KM-G", ALC1220_FIXUP_CLEVO_PB51ED),
 	SND_PCI_QUIRK(0x1558, 0x9501, "Clevo P950HR", ALC1220_FIXUP_CLEVO_P950),
@@ -719,6 +740,7 @@ static const struct hda_model_fixup alc882_fixup_models[] = {
 	{.id = ALC1220_FIXUP_GB_DUAL_CODECS, .name = "dual-codecs"},
 	{.id = ALC1220_FIXUP_GB_X570, .name = "gb-x570"},
 	{.id = ALC1220_FIXUP_CLEVO_P950, .name = "clevo-p950"},
+	{.id = ALC898_FIXUP_CLEVO_P775TM1, .name = "clevo-p775tm1"},
 	{}
 };
 
-- 
2.53.0

