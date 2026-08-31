Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD7EB441022;
	Mon, 31 Aug 2026 13:38:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183510; cv=none; b=h0tvy9t1E61qIdZD7dbrsWilCzsomRkoIDfS2MGDeJq8b3j5eBFgTXqgxZYPYPfX5QgGnI33DYYi2+m9fdVW1VQZPJ9K8JNBnCAiHP8o1HF9MzuluYtE5K0fhasONaNvcRSNig3Xs0Htcyiex3wzSX41h7PzH5LEhj51kK3K6E4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183510; c=relaxed/simple;
	bh=H7O8AFWbYds65BUV2OnQXXQQ0uuAGBp7LCP5ruWOFwg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CmFApKmj+XX6R7aeCy3wcmta/v7UOuWkfWY9NH5O4+wSLTNpRD8lld4hFgYk4DoN2rwHt1CFB/t+q0FPghXPI7TLKWPeQTAJxCGaBTWQQX7qdqCFlzd80vkIYxBxVMJyhjaA0alsZvGAkZHn6JC3hbWd7J7sPZTgQk0JrP/jy4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Hz8X1mGD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Hz8X1mGD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 256981F000E9;
	Mon, 31 Aug 2026 13:38:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183508;
	bh=NkLywm18i22I7e1PMw/lz0wtuZKA5IybpuX3jse8cns=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Hz8X1mGD9MWjZ/iwCbdo22E+MzvgfsWp0ffTuvjvycuSbbCl+NC57201P82cB0HOc
	 FhrBOnCZHla6Uy2JMkxfNSLXsE6U70mTF5VG+34wzFJrSG87vpqdJLXdpN5c+lRDVr
	 oJ/CBKyOSRQZVQLfJzkj9ORDr/n4Xek4y/5etgVL72v0jtB/TITNwSpZq6c/OEvBv0
	 WV/PzW07LdAmZxgBa4oFy8/ZikijCazXRUZ9LZmbHt0g+pUIFbBrcNnXmhyJApbo/7
	 Kl4P69uOA+2YI3IvrCW0X0/57/7X5vlgzG7Fp6vE08PLKqO2yuv9OhJyf+0fiu8yeH
	 R9LywGp0mHYAA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Viktor Menshin <ripeeerr@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>,
	perex@perex.cz,
	tiwai@suse.com,
	linux-sound@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.1] ALSA: hda/realtek: Add quirk for Lenovo Xiaoxin 14 GT
Date: Mon, 31 Aug 2026 09:22:46 -0400
Message-ID: <20260831133314.4125787-138-sashal@kernel.org>
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

From: Viktor Menshin <ripeeerr@gmail.com>

[ Upstream commit 3a3e810e91080a5121170ee11554a55ed89a1c8b ]

The Lenovo Xiaoxin 14 GT (Chinese market model, AMD Ryzen AI 9 365)
produces constant electrical hissing and crackling noise from both
internal speakers and 3.5mm headphone jack during audio playback.
Audio works correctly on Windows.

The PCI SSID 17aa:3912 is not present in the quirk list. The device
shares the same AMD platform and ALC287 codec as neighboring Lenovo
14" AMD models (17aa:3911, 17aa:390d), so apply the same fixup.

Note: the fixup selection is based on similarity with neighboring
models and has not been verified by testing a compiled kernel.
Guidance from maintainers on the correct fixup is welcome.

Signed-off-by: Viktor Menshin <ripeeerr@gmail.com>
Link: https://patch.msgid.link/20260615092515.1082-1-ripeeerr@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Connection lost, reconnecting to https://agentn.us.api5.cursor.sh
(attempt 1)...
Retry attempt 1...
Connection lost, reconnecting to https://agentn.us.api5.cursor.sh
(attempt 2)...
Retry attempt 2...
Connection lost, reconnecting to https://agentn.us.api5.cursor.sh
(attempt 3)...
Retry attempt 3...
# Stable Backport Analysis: ALSA: hda/realtek: Add quirk for Lenovo
Xiaoxin 14 GT

**Local tree:** `v6.18.44` (Makefile: VERSION=6, PATCHLEVEL=18,
SUBLEVEL=44)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject Line
**Record:** `[ALSA: hda/realtek]` `[Add]` — Add PCI quirk entry for
Lenovo Xiaoxin 14 GT (SSID `17aa:3912`).

### Step 1.2: Tags
**Record:**
- **Signed-off-by:** Viktor Menshin `<ripeeerr@gmail.com>` (author)
- **Link:**
  `https://patch.msgid.link/20260615092515.1082-1-ripeeerr@gmail.com`
- **Signed-off-by:** Takashi Iwai `<tiwai@suse.de>` (ALSA/HDA
  maintainer)
- **Absent:** Fixes:, Reported-by:, Tested-by:, Reviewed-by:, Acked-by:,
  Cc: stable@vger.kernel.org
- **Notable:** No user bug report ID; maintainer sign-off is the
  strongest quality signal present.

### Step 1.3: Body Analysis
**Record:**
- **Bug:** Lenovo Xiaoxin 14 GT (Chinese-market laptop, AMD Ryzen AI 9
  365, ALC287 codec) produces constant electrical hissing and crackling
  from internal speakers and the 3.5 mm headphone jack during playback.
  Audio works on Windows.
- **Symptom:** Degraded/unusable audio quality (hissing/crackling), not
  a kernel crash.
- **Root cause (author):** PCI SSID `17aa:3912` is missing from the
  Realtek HDA quirk table; device gets generic handling instead of the
  platform-specific fixup.
- **Fix approach:** Apply `ALC287_FIXUP_YOGA9_14IAP7_BASS_SPK_PIN`, same
  as neighboring Lenovo 14" AMD models (`17aa:390d`, `17aa:3911`).
- **Important caveat:** Author explicitly states the fixup choice is
  based on hardware similarity and **"has not been verified by testing a
  compiled kernel."**

### Step 1.4: Hidden Bug Fix Detection
**Record:** Yes — this is a hardware audio quirk fix disguised as a
simple table addition. It corrects incorrect HDA pin/DAC routing for a
specific laptop model.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory
**Record:**
- **Files:** `sound/hda/codecs/realtek/alc269.c` (+1 line)
- **Function/table:** `alc269_fixup_tbl[]`
- **Scope:** Single-file, single-line surgical addition — classic quirk
  patch.

### Step 2.2: Code Flow Change
**Record:**
- **Before:** Device with PCI SSID `0x17aa:0x3912` does not match any
  entry in `alc269_fixup_tbl[]`; `snd_hda_pick_fixup()` assigns no
  model-specific fixup → generic ALC287 handling → hissing/crackling.
- **After:** Same device matches new entry and receives
  `ALC287_FIXUP_YOGA9_14IAP7_BASS_SPK_PIN`, which runs
  `alc287_fixup_yoga9_14iap7_bass_spk_pin()` at probe time to override
  pin configuration and DAC routing.

### Step 2.3: Bug Mechanism
**Record:** **Category (h): Hardware workaround / audio codec quirk.**
- The fixup corrects pin 0x17 (bass speakers) wrongly reported as
  unconnected, sets connection overrides, and configures preferred DAC
  pairs (speakerbar 0x14 + bass 0x17 → DAC 0x02, headphones 0x21 → DAC
  0x03).
- Wrong pin routing can cause noise, missing speakers, or incorrect
  amplifier behavior — consistent with the reported hissing.

### Step 2.4: Fix Quality
**Record:**
- **Minimal and idiomatic** — identical pattern to neighboring entries
  already in this tree.
- **Regression risk to other hardware:** Negligible — `SND_PCI_QUIRK`
  matches only SSID `17aa:3912`.
- **Regression risk on target hardware:** Low-to-medium — author admits
  fixup is untested; wrong fixup could leave audio broken or change
  symptoms, but would not affect any other machine.
- **Concern:** Symptom on Xiaoxin (hissing/crackling on speakers *and*
  headphones) differs from siblings `3911`/`390d` (bass speakers not
  working). Fixup may or may not address hissing specifically.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
**Record:**
- Line 7497 (`0x390d`): present since codec split commit
  `aeeb85f26c3bbe` (Jul 2025, Takashi Iwai).
- Line 7498 (`0x3911`): added by `0fa5713ac7a19` (Apr 2026,
  songxiebing).
- Line 7499 (`0x3913`): present since codec split.
- **Missing:** `0x3912` — the gap this commit fills.
- The fixup infrastructure (`ALC287_FIXUP_YOGA9_14IAP7_BASS_SPK_PIN`,
  `alc287_fixup_yoga9_14iap7_bass_spk_pin()`) has been in this tree
  since at least the Jul 2025 codec split.

### Step 3.2: Fixes: Tag
**Record:** Not applicable — no Fixes: tag present.

### Step 3.3: Related File History
**Record:**
- `8d70503068510` — Add quirk for Lenovo Yoga Pro 7 14ASP10 (`0x390d`,
  same fixup; had `Cc: stable@vger.kernel.org`)
- `0fa5713ac7a19` — Add quirk for Lenovo Yoga Pro 7 14IAH10 (`0x3911`,
  same fixup; backported to this tree with `[Upstream commit ...]`
  marker)
- `fceb2a4691215` — Add quirk for Lenovo Yoga Slim 7 14AKP10 (`0x391a`,
  same fixup)
- **Standalone:** Yes — single-line quirk, no series dependency.

### Step 3.4: Author Context
**Record:** Viktor Menshin appears to be a community contributor (one
unrelated commit found in tree: `drm/panel` driver). Takashi Iwai
(maintainer) signed off, indicating subsystem acceptance.

### Step 3.5: Prerequisites
**Record:** None. `ALC287_FIXUP_YOGA9_14IAP7_BASS_SPK_PIN` and its fixup
function already exist in this tree. Patch inserts cleanly between
existing `0x3911` and `0x3913` entries.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Original Discussion
**Record:** UNVERIFIED — `b4 dig` requires a commit hash (not available
in this tree); lore.kernel.org and patch.msgid.link returned 403/bot-
protection. Could not read review thread.

### Step 4.2: Reviewers
**Record:** UNVERIFIED — `b4 dig -w` not possible without commit hash.
Takashi Iwai maintainer sign-off confirmed from commit message.

### Step 4.3: Bug Report
**Record:** No Reported-by, no bugzilla, no syzbot. Issue described only
in commit message by the patch author (who owns the hardware).

### Step 4.4: Related Patches
**Record:** Direct siblings `0x390d` and `0x3911` use identical fixup;
`0x3911` commit included bugzilla #221317 and confirmed
`hda_model=alc287-yoga9-bass-spk-pin` workaround. Xiaoxin commit lacks
equivalent verification.

### Step 4.5: Stable List History
**Record:** UNVERIFIED — lore stable list inaccessible. Precedent in
*this* tree: `0x3911` quirk (`0fa5713ac7a19`) was backported here.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key Functions
**Record:** `alc269_fixup_tbl[]` (modified),
`alc287_fixup_yoga9_14iap7_bass_spk_pin()` (invoked via fixup chain),
`snd_hda_pick_fixup()` (selector).

### Step 5.2: Callers
**Record:** `snd_hda_pick_fixup(codec, alc269_fixup_models,
alc269_fixup_tbl, alc269_fixups)` called from ALC269 codec probe path
(`alc269.c` ~line 8471), during HDA codec initialization on every
matching Realtek device probe.

### Step 5.3: Callees
**Record:** Fixup calls `snd_hda_apply_pincfgs()`,
`snd_hda_override_conn_list()`, sets `spec->gen.preferred_dacs`, and
chains to `hda_fixup_ideapad_acpi()`.

### Step 5.4: Reachability
**Record:** Triggered automatically at boot/module load when the HDA
codec for SSID `17aa:3912` is probed. No userspace action required.
Affects only owners of this specific laptop model.

### Step 5.5: Similar Patterns
**Record:** At least 6 Lenovo models in this tree already use
`ALC287_FIXUP_YOGA9_14IAP7_BASS_SPK_PIN` for the same AMD 14" platform
family. This is an established pattern, not experimental code.

---

## PHASE 6: CROSS-REFERENCE AGAINST LOCAL TREE

### Step 6.1: Buggy Code Present?
**Record:** **Yes.** `0x3912` entry is absent; neighbors `0x390d` and
`0x3911` are present at lines 7497–7498. The ALC287 fixup infrastructure
is fully present. Hardware is contemporary (2025/2026) and plausible on
6.18.y.

### Step 6.2: Backport Complications
**Record:** **Clean apply expected** — one-line insertion between
existing entries at the same location as upstream diff. No structural
divergence at the insertion point.

### Step 6.3: Related Fixes Already Present?
**Record:** No existing `0x3912` entry or Xiaoxin quirk found. The
identical fixup for siblings `390d`/`3911` is already in tree.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: Subsystem Criticality
**Record:** **sound/ALSA HDA Realtek** — IMPORTANT (affects laptop audio
users) but PERIPHERAL relative to core kernel; config- and hardware-
specific.

### Step 7.2: Subsystem Activity
**Record:** Actively maintained — multiple Lenovo quirk additions in
recent `alc269.c` history on this tree (TongFang, HP, Legion, Yoga Pro
7, etc.).

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Who Is Affected
**Record:** **Hardware-specific** — owners of Lenovo Xiaoxin 14 GT with
PCI SSID `17aa:3912` running Linux with `snd-hda-codec-realtek`
(ALC287).

### Step 8.2: Trigger Conditions
**Record:** Every boot / codec probe on affected hardware. Common for
laptop owners. Not security-relevant; not triggerable by unprivileged
users on other systems.

### Step 8.3: Failure Mode Severity
**Record:** **MEDIUM** — constant audio hissing/crackling makes playback
unpleasant/unusable, but no crash, deadlock, data corruption, or
security impact. Significant quality-of-life issue for affected users.

### Step 8.4: Risk-Benefit
**Record:**
- **Benefit:** HIGH for affected users (potentially restores usable
  audio); ZERO for everyone else.
- **Risk:** VERY LOW for non-target hardware (SSID-gated). LOW for
  target hardware (worst case: fixup doesn't help or changes symptoms;
  author uncertainty noted).
- **Ratio:** Favorable — standard hardware-quirk risk profile.

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence Summary

**FOR backport:**
- Hardware quirk — explicit stable exception category
- Fixes real, user-visible audio defect on specific laptop
- One-line, surgical, no new APIs or features
- Uses existing, proven fixup already applied to sibling SSIDs in this
  tree
- Maintainer (Takashi Iwai) signed off
- Identical pattern to `0x3911` quirk already backported to this 6.18.y
  tree
- Zero impact on any hardware other than `17aa:3912`

**AGAINST backport:**
- Author explicitly states fixup **not kernel-tested**
- No Reported-by, bugzilla, or modprobe-workaround confirmation (unlike
  `0x3911`)
- Symptom (hissing/crackling) differs from siblings (bass speakers not
  working) — fixup match is inferred, not confirmed
- Not a crash/corruption/security issue — importance is moderate
- Mailing list review thread inaccessible — review depth unverified

**Unresolved:**
- Whether the chosen fixup actually resolves hissing (vs. only bass-
  speaker issues)
- Whether reviewers on lore suggested stable nomination

### Step 9.2: Stable Rules Checklist
| Criterion | Result |
|-----------|--------|
| 1. Obviously correct and tested? | **PARTIAL FAIL** — logically sound
and maintainer-reviewed, but author admits no kernel test |
| 2. Fixes real bug affecting users? | **PASS** — documented audio
defect on real hardware |
| 3. Important issue? | **PASS (moderate)** — unusable audio quality,
not crash/corruption |
| 4. Small and contained? | **PASS** — 1 line, 1 file |
| 5. No new features/APIs? | **PASS** — quirk table entry only |
| 6. Can apply to local tree? | **PASS** — fixup infrastructure present,
clean insertion point |

### Step 9.3: Exception Category
**Record:** **Hardware quirk/workaround** — adding PCI SSID to existing
driver's quirk table with an existing fixup. This is one of the most
common and accepted stable backport categories.

### Step 9.4: Decision Rationale

This patch fits the well-established pattern of Lenovo ALC287 quirk
additions already present and backported in this 6.18.y tree. The
missing `17aa:3912` entry is the bug; the one-line addition is the
standard remedy. The author's untested disclaimer is a quality concern,
but it is mitigated by: (1) maintainer acceptance, (2) identical fixup
on immediately adjacent sibling models, (3) SSID-specific scope
eliminating cross-hardware regression risk, and (4) the hardware-quirk
exception that stable trees routinely honor for laptop audio.

The issue is not a kernel crash, but broken audio on a specific shipping
laptop is exactly the kind of real-world hardware problem stable quirk
patches address.

---

## Verification

- **[Phase 1]** Parsed commit message and tags from user-provided commit
  text
- **[Phase 1]** Confirmed maintainer sign-off (Takashi Iwai); no
  Reported-by/Tested-by
- **[Phase 2]** Diff analysis: +1 `SND_PCI_QUIRK` line in
  `alc269_fixup_tbl[]`
- **[Phase 2]** Read `alc287_fixup_yoga9_14iap7_bass_spk_pin()` at lines
  3408–3444 — pin/DAC routing fixup
- **[Phase 3]** `git describe HEAD`: `v6.18.44-1-g2736c32da98b9`
- **[Phase 3]** `git blame -L 7497,7499`: neighbors `390d`/`3911`/`3913`
  confirmed; `3912` absent
- **[Phase 3]** `git show 0fa5713ac7a19`: `3911` quirk uses same fixup,
  was backported to this tree
- **[Phase 3]** `git show 8d70503068510`: `390d` quirk uses same fixup,
  had Cc: stable
- **[Phase 3]** `git log --oneline -20 --
  sound/hda/codecs/realtek/alc269.c`: active quirk maintenance
- **[Phase 4]** `b4 dig`: requires commit hash — not available in tree;
  could not run
- **[Phase 4]** WebFetch lore.kernel.org and patch.msgid.link: blocked
  (403/bot protection)
- **[Phase 4]** `curl` lore raw URL: 403 Forbidden
- **[Phase 5]** `grep snd_hda_pick_fixup`: called at alc269.c:8471
  during codec probe
- **[Phase 5]** `grep ALC287_FIXUP_YOGA9_14IAP7_BASS_SPK_PIN`: enum,
  fixup table entry, and 6+ quirk users confirmed
- **[Phase 6]** `grep 0x3912 sound/hda/codecs/realtek/alc269.c`: no
  match — quirk missing
- **[Phase 6]** Read lines 7497–7500: insertion point between `3911` and
  `3913` confirmed
- **[Phase 8]** Failure mode: audio hissing/crackling — severity MEDIUM
  (not crash/corruption)
- **UNVERIFIED:** Mailing list review content and whether reviewers
  nominated for stable
- **UNVERIFIED:** Whether `ALC287_FIXUP_YOGA9_14IAP7_BASS_SPK_PIN`
  actually fixes hissing on this model

**YES**The stable backport review for **ALSA: hda/realtek: Add quirk for
Lenovo Xiaoxin 14 GT** is done.

**Verdict: YES** for this tree (`v6.18.44`).

It’s a one-line PCI quirk (`17aa:3912`) using the existing
`ALC287_FIXUP_YOGA9_14IAP7_BASS_SPK_PIN` fixup — the same pattern
already used for neighboring Lenovo models (`390d`, `3911`) in
`alc269.c`. That fits the usual stable hardware-quirk case: small, SSID-
specific, and aimed at fixing broken audio on a real laptop.

The main caveat is the author’s note that the fixup wasn’t kernel-
tested; maintainer sign-off and the sibling-model precedent still make
it reasonable for stable.

A follow-up search found no existing `0x3912`/Xiaoxin entry in this tree
(expected — that’s what the patch adds) and no prior commits from Viktor
Menshin in this ALSA area.

 sound/hda/codecs/realtek/alc269.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/hda/codecs/realtek/alc269.c b/sound/hda/codecs/realtek/alc269.c
index 490589c042bd9..ab6fc1fdf3ff2 100644
--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -7503,6 +7503,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x17aa, 0x3902, "Lenovo E50-80", ALC269_FIXUP_DMIC_THINKPAD_ACPI),
 	SND_PCI_QUIRK(0x17aa, 0x390d, "Lenovo Yoga Pro 7 14ASP10", ALC287_FIXUP_YOGA9_14IAP7_BASS_SPK_PIN),
 	SND_PCI_QUIRK(0x17aa, 0x3911, "Lenovo Yoga Pro 7 14IAH10", ALC287_FIXUP_YOGA9_14IAP7_BASS_SPK_PIN),
+	SND_PCI_QUIRK(0x17aa, 0x3912, "Lenovo Xiaoxin 14 GT", ALC287_FIXUP_YOGA9_14IAP7_BASS_SPK_PIN),
 	SND_PCI_QUIRK(0x17aa, 0x3913, "Lenovo 145", ALC236_FIXUP_LENOVO_INV_DMIC),
 	SND_PCI_QUIRK(0x17aa, 0x391a, "Lenovo Yoga Slim 7 14AKP10", ALC287_FIXUP_YOGA9_14IAP7_BASS_SPK_PIN),
 	SND_PCI_QUIRK(0x17aa, 0x391f, "Yoga S990-16 pro Quad YC Quad", ALC287_FIXUP_TXNW2781_I2C),
-- 
2.53.0

