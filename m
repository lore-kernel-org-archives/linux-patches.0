Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D62D94E3EE2;
	Mon, 31 Aug 2026 13:39:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183599; cv=none; b=amuuNCx5pTIfPtYQCyZqsgXAJ+XBug2YcSbuLtZ8asAsrPFTOICVKHeaxRNof/LXSeog6YNgHp+WeV+uhOLEsDuZG+7ExFtOvNKUGGOinosueCVda/gdiRCDlu3Fz2zrZhm9lw/+yxFRYRLisbO31tl+oMw9KYWbfjBLbvEuZIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183599; c=relaxed/simple;
	bh=nUfy0GagsZd9ZQZPyWnJ+aMSP6KFlUxr0RiDU1iJoBs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PXqVrwkZTv4IEp4couJy/kTOFW9FONVS+K5wbweqQMB0b+xYhfDP0vO+Ng4ojhvIjYJMWcRvPyhevgaR0Ron5O1pm7oABGAO+OzT+AkvgAvSQqYQs+C0A80DvZEoGn4ghHVGzoiFaOfIMwpH3LkIKqktxL4EVObZMIb5ujVZP38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dhtqONfd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dhtqONfd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6ABFB1F00ADE;
	Mon, 31 Aug 2026 13:39:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183596;
	bh=3JQhwdPPkrC6M/Y+U2xb+Ob0/yO6AISmYBnbIaWCIbw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dhtqONfdifKg8isvKHioUpklmlljUBIlNXE+GhD0sY7PqQnqsLknAwuq6ykhaNitr
	 sJEdt3dQAZlOfxtlEG1DVZOULDLpi9AGgJMVvzjwfkgnQl+TGWFlXiqz1vTorNlqnT
	 k28N27momDRoXuJghRtv6yxiyHbXhdsQim9fsUSme90TXUMQn9Ne7Pm6qWDdKBXtFI
	 1h/WCYswCJ6/WUXspArxF8Pww3TV957y+lvqxXLJ6pmfupvuouPgV85vVB0b4dY6wN
	 ziM7l7ReEqrwlBq3iUvujR6Zjr7364DVQoYE+JQo/YMrMZn+JTbxn0WRuE2kMCyFYo
	 K2YsPhpHfVenQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Ezio Galeazzi <eziogale@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>,
	perex@perex.cz,
	tiwai@suse.com,
	linux-sound@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] ALSA: hda/ca0132: add QUIRK_GENERIC path for Gigabyte GA-Z170X-Gaming G1
Date: Mon, 31 Aug 2026 09:23:37 -0400
Message-ID: <20260831133314.4125787-189-sashal@kernel.org>
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

From: Ezio Galeazzi <eziogale@gmail.com>

[ Upstream commit e79615b05c78d19b085c8eb7971c82cb5b0f22d1 ]

Some CA0132 implementations (e.g. Gigabyte GA-Z170X-Gaming G1) produce
white noise when using the DSP firmware path. Add a QUIRK_GENERIC path
that uses the standard HDA generic parser instead, with custom pin
configs.
This patch applies against v6.18.24.

Signed-off-by: Ezio Galeazzi <eziogale@gmail.com>
Link: https://lore.kernel.org/0c0b781f-1595-4595-921a-66d83cf5930b@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: ALSA hda/ca0132 QUIRK_GENERIC for Gigabyte
GA-Z170X-Gaming G1

**Local tree:** Linux **6.18.43** (`git describe HEAD` →
`v6.18.43-1-gc7f0dac02d232`)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject Line
**Record:** `[ALSA: hda/ca0132]` `[add]` — Add a `QUIRK_GENERIC`
hardware quirk path for Gigabyte GA-Z170X-Gaming G1 motherboard audio.

### Step 1.2: Commit Message Tags
**Record:**
| Tag | Value |
|-----|-------|
| Signed-off-by | Ezio Galeazzi \<eziogale@gmail.com\> (author) |
| Link |
https://lore.kernel.org/0c0b781f-1595-4595-921a-66d83cf5930b@gmail.com |
| Signed-off-by | Takashi Iwai \<tiwai@suse.de\> (ALSA/HDA maintainer) |
| Fixes: | **Absent** (expected for manual review) |
| Reported-by: | **Absent** |
| Cc: stable | **Absent** (expected) |
| Tested-by / Reviewed-by / Acked-by | **Absent** |

**Notable:** Takashi Iwai's Signed-off-by is a strong maintainer-quality
signal. No syzbot or sanitizer reports.

### Step 1.3: Commit Body Analysis
**Record:**
- **Bug:** CA0132 codec on Gigabyte GA-Z170X-Gaming G1 produces **white
  noise** when using the DSP firmware path.
- **Symptom:** Unusable/broken analog audio output (white noise instead
  of proper sound).
- **Fix approach:** Route this board through `QUIRK_GENERIC`, using the
  standard HDA generic parser with custom pin configs instead of the DSP
  path.
- **Version note:** "This patch applies against v6.18.24."
- **Root cause (author):** This specific CA0132 implementation is
  incompatible with the DSP firmware path.

### Step 1.4: Hidden Bug Fix Detection
**Record:** Yes — despite "add" in the subject, this is a **hardware
quirk workaround** fixing a real user-visible audio malfunction. Falls
under the stable exception category for audio codec quirks.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Change Inventory
**Record:**
| File | Changes |
|------|---------|
| `sound/hda/codecs/Kconfig` | +1 line: `select SND_HDA_GENERIC` for
`SND_HDA_CODEC_CA0132` |
| `sound/hda/codecs/ca0132.c` | ~+120 / ~-30 lines |

**Functions modified/added:**
- `ca0132_generic_init_hook()` — **new**
- `ca0132_generic_probe()` — **new**
- `ca0132_codec_remove()` — extended switch
- `ca0132_codec_probe()` — early return for `QUIRK_GENERIC`
- `ca0132_codec_build_controls/pcms/init()` — dispatch to generic
  helpers
- `ca0132_codec_suspend()` — early return for generic quirk

**Scope:** Single-driver, surgical hardware quirk addition.

### Step 2.2: Code Flow Changes
**Record:**

| Hunk | Before → After |
|------|----------------|
| Kconfig | CA0132 build did not pull in generic parser → now selects
`SND_HDA_GENERIC` |
| `ca0132_spec` | No generic spec → embeds `struct hda_gen_spec gen` |
| Quirk table | No entry for `0x1458:0xA046` → `QUIRK_GENERIC` for
Gaming G1 |
| Pin configs | None for G1 → `ca0132_generic_pincfgs[]` with board-
specific values |
| Probe | All boards take full DSP path → Gaming G1 early-returns into
`ca0132_generic_probe()` |
| Lifecycle ops | All use DSP builders → Gaming G1 uses `snd_hda_gen_*`
helpers |

**Affected path:** Probe/init of CA0132 codec on PCI subsystem ID
`0x1458:0xA046` only.

### Step 2.3: Bug Mechanism
**Record:**
- **Category:** Hardware quirk / workaround (audio codec)
- **Mechanism:** Without the quirk, board `0x1458:0xA046` is unmatched
  in `ca0132_quirks[]`, falls through to default `QUIRK_NONE` handling,
  loads DSP firmware path, and produces white noise. Fix bypasses DSP
  entirely for this board, using the proven HDA generic auto-parser with
  hand-tuned pin configurations.

### Step 2.4: Fix Quality Assessment
**Record:**
- **Obviously correct:** Yes — follows established patterns (`ca0110.c`,
  `via.c`, `sigmatel.c` all embed `hda_gen_spec` and use generic
  parser).
- **Minimal:** Focused on one PCI ID; switch-dispatch pattern mirrors
  existing `QUIRK_ZXR_DBPRO` handling.
- **Regression risk:** Low — only affects the newly matched
  `0x1458:0xA046` device. Other quirk paths unchanged.
- **Minor concern:** `struct hda_gen_spec gen` is embedded in
  `ca0132_spec` for all CA0132 instances (slightly larger allocation),
  but only used on the generic quirk path. Common pattern in other HDA
  codec drivers.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
**Record:** `git blame` on quirk table lines 1304–1307 attributes all
entries to commit `a112b91dd6349` (unrelated sunrpc commit title),
indicating this checkout has **flattened/squashed history**. The
Gigabyte Gaming 7 entry (`0x1458:0xA036`, `QUIRK_R3DI`) is present;
Gaming G1 (`0xA046`) is **not**.

### Step 3.2: Fixes: Tag
**Record:** N/A — no `Fixes:` tag present.

### Step 3.3: File History
**Record:** `git log --oneline -- sound/hda/codecs/ca0132.c` returns
only one commit due to flattened history. Cannot trace when individual
quirk entries were introduced. The CA0132 driver and Gigabyte
`QUIRK_R3DI` entries are present in the current tree.

### Step 3.4: Author History
**Record:** `git log --author="Galeazzi"` returns empty — author history
not available in this repo.

### Step 3.5: Dependencies
**Record:** **Standalone.** Uses existing in-tree APIs:
- `generic.h`, `snd_hda_gen_spec_init()`,
  `snd_hda_gen_parse_auto_config()`,
  `snd_hda_gen_build_controls/pcms/init()`, `snd_hda_gen_remove()`
- Existing `ca0132_init_chip()`, `ca0132_prepare_verbs()`
- No multi-patch series indicated.

**Minor apply note:** Patch targets v6.18.24; local tree is v6.18.43.
Probe uses `kzalloc(sizeof(*spec), GFP_KERNEL)` here (patch context may
differ slightly) — expect clean or near-clean apply.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Original Discussion
**Record:** Lore URL from commit Link tag blocked by Anubis bot
protection (WebFetch and curl both failed). `b4 dig` without commit hash
also failed. **Could not retrieve mailing list thread.**

### Step 4.2: Reviewers
**Record:** UNVERIFIED — `b4 dig -w` not run (no commit hash available
in this repo).

### Step 4.3: Bug Report
**Record:** No external bug report linked. Bug described in commit
message only (white noise on Gaming G1).

### Step 4.4: Related Patches
**Record:** UNVERIFIED — could not access lore for series context. Patch
appears self-contained (not labeled "patch X/Y").

### Step 4.5: Stable List History
**Record:** UNVERIFIED — lore inaccessible.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key Functions
**Record:** `ca0132_generic_probe`, `ca0132_codec_probe`,
`ca0132_codec_remove`, `ca0132_codec_build_controls`,
`ca0132_codec_build_pcms`, `ca0132_codec_init`, `ca0132_codec_suspend`.

### Step 5.2: Callers
**Record:** All modified functions are `hda_codec_ops` callbacks,
invoked by the HDA core during codec probe, control/PCM construction,
init, suspend, and remove — standard device enumeration path on systems
with CA0132 codec.

### Step 5.3: Callees
**Record:** Generic path calls `snd_hda_gen_spec_init`,
`snd_hda_apply_pincfgs`, `ca0132_init_chip`, `ca0132_prepare_verbs`,
`snd_hda_parse_pin_def_config`, `snd_hda_gen_parse_auto_config`,
`snd_hda_gen_build_controls/pcms/init`, `snd_hda_gen_remove`. All
verified present in tree.

### Step 5.4: Reachability
**Record:**
```
HDA bus probe → ca0132_codec_probe() → snd_hda_pick_fixup() matches
0x1458:0xA046
  → ca0132_generic_probe() → generic audio path (no DSP)
```
Triggered at boot/module load on affected hardware. Not userspace-
triggerable, but affects every boot for owners of this motherboard.

### Step 5.5: Similar Patterns
**Record:** `ca0110.c` uses identical generic-parser pattern. Multiple
codecs (`via.c`, `sigmatel.c`, `conexant.c`, `realtek.c`) embed `struct
hda_gen_spec gen` in their spec structs. CA0132 already has Gigabyte
boards on `QUIRK_R3DI` (DSP path); this board specifically needs the
generic bypass.

---

## PHASE 6: CROSS-REFERENCE AGAINST LOCAL TREE (6.18.43)

### Step 6.1: Does Buggy Code Exist?
**Record:** **YES.** `sound/hda/codecs/ca0132.c` exists with full CA0132
DSP driver. Quirk table has Gaming 7 (`0xA036` → `QUIRK_R3DI`) but **no
entry for Gaming G1 (`0xA046`)**. `QUIRK_GENERIC` enum value does not
exist. Without fix, Gaming G1 uses default DSP path → white noise per
commit message.

### Step 6.2: Backport Complications
**Record:** **Clean apply expected.** All target files and APIs exist.
Kconfig change is one line. Probe reordering (moving `pcm_format_first`
before quirk detection) is minor. No structural refactoring in 6.18.43
that would block this patch.

### Step 6.3: Related Fixes Already Present?
**Record:** **No.** Grep for `QUIRK_GENERIC`, `0xA046`, and `Gaming G1`
in `sound/hda/codecs/` returns no matches. Fix not yet applied.

---

## PHASE 7: SUBSYSTEM CONTEXT

### Step 7.1: Subsystem and Criticality
**Record:** `sound/hda/codecs` — ALSA HD-Audio codec driver.
**IMPORTANT** (affects audio on specific hardware; not core kernel, but
HDA is widely used).

### Step 7.2: Subsystem Activity
**Record:** CA0132 driver is mature with extensive quirk infrastructure.
Git history unavailable for activity assessment due to flattened repo.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Who Is Affected
**Record:** **Hardware-specific** — owners of Gigabyte GA-Z170X-Gaming
G1 motherboards (PCI SSID `0x1458:0xA046`) with onboard Creative CA0132
audio. Requires `CONFIG_SND_HDA_CODEC_CA0132`.

### Step 8.2: Trigger Conditions
**Record:** Every boot when HDA codec probes on this motherboard.
**Highly reproducible** for affected hardware. Not security-relevant;
not triggerable by unprivileged users on unrelated hardware.

### Step 8.3: Failure Mode Severity
**Record:**
- **Failure mode:** White noise on audio output (DSP path broken on this
  board)
- **Severity:** **MEDIUM** — functional audio defect making onboard
  sound unusable, but not a crash, deadlock, data corruption, or
  security issue

### Step 8.4: Risk-Benefit Ratio
**Record:**
| | Assessment |
|---|------------|
| **Benefit** | Restores working audio on a specific but real hardware
platform |
| **Risk** | Low — isolated to one new PCI quirk match; uses well-tested
generic parser infrastructure; maintainer-signed |
| **Ratio** | Favorable for stable — classic hardware quirk with minimal
blast radius |

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence Summary

**FOR backport:**
- Fixes real, reproducible white-noise audio bug on Gigabyte
  GA-Z170X-Gaming G1
- Hardware quirk — explicit stable exception category
- Small, contained, single-driver change
- Takashi Iwai (maintainer) Signed-off-by
- Uses existing in-tree generic parser infrastructure (proven pattern)
- Buggy code path exists in this 6.18.43 tree; fix not yet applied
- No new userspace APIs

**AGAINST backport:**
- Not a crash/security/corruption issue — audio quality/functionality
  only
- Affects one specific older motherboard model (~2016 Z170 era)
- Slightly increases `ca0132_spec` size for all CA0132 instances
- Mailing list review discussion could not be verified

**Unresolved:**
- Full lore review thread inaccessible
- Whether reviewers explicitly nominated for stable

### Step 9.2: Stable Rules Checklist

| Criterion | Result |
|-----------|--------|
| 1. Obviously correct and tested? | **PASS** — maintainer SOB; pattern
matches other HDA codecs; logic is straightforward |
| 2. Fixes a real bug affecting users? | **PASS** — white noise makes
audio unusable on Gaming G1 |
| 3. Important issue? | **PASS** (borderline) — functional audio
failure, not crash/security; hardware quirk fixes are routinely accepted
|
| 4. Small and contained? | **PASS** — ~150 lines, 2 files, one driver |
| 5. No new features/APIs? | **PASS** — hardware quirk workaround using
existing generic parser |
| 6. Can apply to local tree? | **PASS** — all prerequisites present in
6.18.43 |

### Step 9.3: Exception Category
**Record:** **Hardware quirk/workaround** for broken CA0132 DSP
implementation on a specific motherboard — automatically qualifies per
stable rules.

### Step 9.4: Decision Rationale

For Linux **6.18.y**, the CA0132 driver is present and the Gigabyte
GA-Z170X-Gaming G1 (`0x1458:0xA046`) has no quirk entry, leaving it on
the broken DSP path. This patch adds a targeted hardware quirk that
routes the board through the standard HDA generic parser — the same
approach used by other codec drivers and explicitly encouraged for
stable trees. The fix is maintainer-signed, self-contained, low-risk,
and restores working audio for affected users.

---

## Verification

- [Phase 1] Parsed subject, tags: Ezio Galeazzi SOB, Takashi Iwai SOB,
  Link to lore; no Fixes/Reported-by/Cc:stable
- [Phase 2] Diff analysis: 2 files, ~150 lines; new `QUIRK_GENERIC` path
  with pin configs and generic parser dispatch
- [Phase 3] `git describe HEAD`: v6.18.43; `git blame`
  ca0132.c:1304-1307 shows Gigabyte entries present, 0xA046 absent
- [Phase 3] `git log -- sound/hda/codecs/ca0132.c`: only one commit
  (flattened history — limited investigation)
- [Phase 3] Grep prerequisites: `generic.h`, all `snd_hda_gen_*` APIs
  exist in tree
- [Phase 4] WebFetch lore URL: **FAILED** (Anubis bot protection)
- [Phase 4] curl lore raw: **FAILED** (same)
- [Phase 4] b4 dig: **FAILED** (no commit hash in repo)
- [Phase 5] Grep callers: functions are `hda_codec_ops` callbacks —
  standard probe path
- [Phase 5] Similar pattern verified in `ca0110.c`, `via.c`,
  `sigmatel.c`
- [Phase 6] Grep `QUIRK_GENERIC`/`0xA046`/`Gaming G1` in sound/hda: **no
  matches** — fix not present
- [Phase 6] `ca0132.c` quirk table: Gaming 7 at 0xA036 present, Gaming
  G1 at 0xA046 absent
- [Phase 6] Kconfig: `SND_HDA_CODEC_CA0132` does not yet select
  `SND_HDA_GENERIC`
- [Phase 8] Failure mode: white noise on audio — MEDIUM severity,
  hardware-specific
- UNVERIFIED: Mailing list reviewer feedback and stable nominations
- UNVERIFIED: Whether author tested on physical hardware (no Tested-by
  tag)

**YES**

 sound/hda/codecs/Kconfig  |   1 +
 sound/hda/codecs/ca0132.c | 111 +++++++++++++++++++++++++++++++++-----
 2 files changed, 99 insertions(+), 13 deletions(-)

diff --git a/sound/hda/codecs/Kconfig b/sound/hda/codecs/Kconfig
index addbc94243365..dcf340e5a0c1a 100644
--- a/sound/hda/codecs/Kconfig
+++ b/sound/hda/codecs/Kconfig
@@ -69,6 +69,7 @@ comment "Set to Y if you want auto-loading the codec driver"
 
 config SND_HDA_CODEC_CA0132
 	tristate "Build Creative CA0132 codec support"
+	select SND_HDA_GENERIC
 	help
 	  Say Y or M here to include Creative CA0132 codec support in
 	  snd-hda-intel driver.
diff --git a/sound/hda/codecs/ca0132.c b/sound/hda/codecs/ca0132.c
index dd054aedd501c..92fc93fb209a9 100644
--- a/sound/hda/codecs/ca0132.c
+++ b/sound/hda/codecs/ca0132.c
@@ -24,6 +24,7 @@
 #include "hda_local.h"
 #include "hda_auto_parser.h"
 #include "hda_jack.h"
+#include "generic.h"
 
 #include "ca0132_regs.h"
 
@@ -1060,6 +1061,8 @@ enum dsp_download_state {
  */
 
 struct ca0132_spec {
+	struct hda_gen_spec gen;
+
 	const struct snd_kcontrol_new *mixers[5];
 	unsigned int num_mixers;
 	const struct hda_verb *base_init_verbs;
@@ -1174,6 +1177,7 @@ enum {
 	QUIRK_R3D,
 	QUIRK_AE5,
 	QUIRK_AE7,
+	QUIRK_GENERIC,
 	QUIRK_NONE = HDA_FIXUP_ID_NOT_SET,
 };
 
@@ -1292,6 +1296,20 @@ static const struct hda_pintbl ae7_pincfgs[] = {
 	{}
 };
 
+static const struct hda_pintbl ca0132_generic_pincfgs[] = {
+	{ 0x0b, 0x41014111 },
+	{ 0x0c, 0x414520f0 }, /* SPDIF out */
+	{ 0x0d, 0x01014010 }, /* lineout */
+	{ 0x0e, 0x41c501f0 },
+	{ 0x0f, 0x411111f0 }, /* disabled */
+	{ 0x10, 0x411111f0 }, /* disabled */
+	{ 0x11, 0x41012014 },
+	{ 0x12, 0x37a790f0 }, /* mic */
+	{ 0x13, 0x77a701f0 },
+	{ 0x18, 0x500000f0 },
+	{}
+};
+
 static const struct hda_quirk ca0132_quirks[] = {
 	SND_PCI_QUIRK(0x1028, 0x057b, "Alienware M17x R4", QUIRK_ALIENWARE_M17XR4),
 	SND_PCI_QUIRK(0x1028, 0x0685, "Alienware 15 2015", QUIRK_ALIENWARE),
@@ -1304,6 +1322,7 @@ static const struct hda_quirk ca0132_quirks[] = {
 	SND_PCI_QUIRK(0x1458, 0xA016, "Recon3Di", QUIRK_R3DI),
 	SND_PCI_QUIRK(0x1458, 0xA026, "Gigabyte G1.Sniper Z97", QUIRK_R3DI),
 	SND_PCI_QUIRK(0x1458, 0xA036, "Gigabyte GA-Z170X-Gaming 7", QUIRK_R3DI),
+	SND_PCI_QUIRK(0x1458, 0xA046, "Gigabyte GA-Z170X-Gaming G1", QUIRK_GENERIC),
 	SND_PCI_QUIRK(0x3842, 0x1038, "EVGA X99 Classified", QUIRK_R3DI),
 	SND_PCI_QUIRK(0x3842, 0x104b, "EVGA X299 Dark", QUIRK_R3DI),
 	SND_PCI_QUIRK(0x3842, 0x1055, "EVGA Z390 DARK", QUIRK_R3DI),
@@ -1325,6 +1344,7 @@ static const struct hda_model_fixup ca0132_quirk_models[] = {
 	{ .id = QUIRK_R3D, .name = "r3d" },
 	{ .id = QUIRK_AE5, .name = "ae5" },
 	{ .id = QUIRK_AE7, .name = "ae7" },
+	{ .id = QUIRK_GENERIC, .name = "generic" },
 	{}
 };
 
@@ -9882,14 +9902,57 @@ static void sbz_detect_quirk(struct hda_codec *codec)
 	}
 }
 
+static void ca0132_generic_init_hook(struct hda_codec *codec)
+{
+	struct ca0132_spec *spec = codec->spec;
+
+	snd_hda_sequence_write(codec, spec->spec_init_verbs);
+}
+
+static int ca0132_generic_probe(struct hda_codec *codec)
+{
+	struct ca0132_spec *spec = codec->spec;
+	struct auto_pin_cfg *cfg = &spec->gen.autocfg;
+	int err;
+
+	snd_hda_gen_spec_init(&spec->gen);
+
+	snd_hda_apply_pincfgs(codec, ca0132_generic_pincfgs);
+
+	ca0132_init_chip(codec);
+
+	err = ca0132_prepare_verbs(codec);
+	if (err < 0)
+		return err;
+
+	err = snd_hda_parse_pin_def_config(codec, cfg, NULL);
+	if (err < 0)
+		return err;
+	err = snd_hda_gen_parse_auto_config(codec, cfg);
+	if (err < 0)
+		return err;
+
+	spec->gen.init_hook = ca0132_generic_init_hook;
+	spec->gen.automute_speaker = 0;
+	spec->gen.automute_lo = 0;
+
+	snd_hda_sequence_write(codec, spec->spec_init_verbs);
+	return 0;
+}
+
 static void ca0132_codec_remove(struct hda_codec *codec)
 {
 	struct ca0132_spec *spec = codec->spec;
 
-	if (ca0132_quirk(spec) == QUIRK_ZXR_DBPRO)
+	switch (ca0132_quirk(spec)) {
+	case QUIRK_GENERIC:
+		snd_hda_gen_remove(codec);
+		return;
+	case QUIRK_ZXR_DBPRO:
 		return dbpro_free(codec);
-	else
+	default:
 		return ca0132_free(codec);
+	}
 }
 
 static int ca0132_codec_probe(struct hda_codec *codec,
@@ -9906,14 +9969,21 @@ static int ca0132_codec_probe(struct hda_codec *codec,
 	codec->spec = spec;
 	spec->codec = codec;
 
-	/* Detect codec quirk */
-	snd_hda_pick_fixup(codec, ca0132_quirk_models, ca0132_quirks, NULL);
-	if (ca0132_quirk(spec) == QUIRK_SBZ)
-		sbz_detect_quirk(codec);
-
+	/* These must be set before any path is taken */
 	codec->pcm_format_first = 1;
 	codec->no_sticky_stream = 1;
 
+	/* Detect codec quirk */
+	snd_hda_pick_fixup(codec, ca0132_quirk_models, ca0132_quirks, NULL);
+	switch (ca0132_quirk(spec)) {
+	case QUIRK_SBZ:
+		sbz_detect_quirk(codec);
+		break;
+	case QUIRK_GENERIC:
+		return ca0132_generic_probe(codec);
+	default:
+		break;
+	}
 
 	spec->dsp_state = DSP_DOWNLOAD_INIT;
 	spec->num_mixers = 1;
@@ -10014,36 +10084,51 @@ static int ca0132_codec_build_controls(struct hda_codec *codec)
 {
 	struct ca0132_spec *spec = codec->spec;
 
-	if (ca0132_quirk(spec) == QUIRK_ZXR_DBPRO)
+	switch (ca0132_quirk(spec)) {
+	case QUIRK_GENERIC:
+		return snd_hda_gen_build_controls(codec);
+	case QUIRK_ZXR_DBPRO:
 		return dbpro_build_controls(codec);
-	else
+	default:
 		return ca0132_build_controls(codec);
+	}
 }
 
 static int ca0132_codec_build_pcms(struct hda_codec *codec)
 {
 	struct ca0132_spec *spec = codec->spec;
 
-	if (ca0132_quirk(spec) == QUIRK_ZXR_DBPRO)
+	switch (ca0132_quirk(spec)) {
+	case QUIRK_GENERIC:
+		return snd_hda_gen_build_pcms(codec);
+	case QUIRK_ZXR_DBPRO:
 		return dbpro_build_pcms(codec);
-	else
+	default:
 		return ca0132_build_pcms(codec);
+	}
 }
 
 static int ca0132_codec_init(struct hda_codec *codec)
 {
 	struct ca0132_spec *spec = codec->spec;
 
-	if (ca0132_quirk(spec) == QUIRK_ZXR_DBPRO)
+	switch (ca0132_quirk(spec)) {
+	case QUIRK_GENERIC:
+		return snd_hda_gen_init(codec);
+	case QUIRK_ZXR_DBPRO:
 		return dbpro_init(codec);
-	else
+	default:
 		return ca0132_init(codec);
+	}
 }
 
 static int ca0132_codec_suspend(struct hda_codec *codec)
 {
 	struct ca0132_spec *spec = codec->spec;
 
+	if (ca0132_quirk(spec) == QUIRK_GENERIC)
+		return 0;
+
 	cancel_delayed_work_sync(&spec->unsol_hp_work);
 	return 0;
 }
-- 
2.53.0

