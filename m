Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E57C3D7D6E;
	Mon, 30 Mar 2026 12:39:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774874359; cv=none; b=S0Sf5r+v91WGaHIbnidtvnowGPS3q889eeTq3rzwgsrIh8pQQ+TDmogwPLmUDF7k90fUzvoYoCwba2a4hvvE41T583PqsxUulDtE3O6PB5bGjpngX+sHbiOBzkkpuqDclHgnW+KLRoJykSmMdeBlY6m+66Zv6Fdaui0W6UUE2p4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774874359; c=relaxed/simple;
	bh=dKuRGZG4/lteZTFXeqThLHmrHOH19quRHWpiId7Gqnk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=By3cCT+M2aSioH1yKUbo3XAk/jiX0gOtMiTkGr7udEJGAFAd+vAlW0yTjCRM7C++wRFvVP058Szgwwc1zSKTmQjceKKS1a/nz5EErLnpNa446bR4yMF5TT4d2hz4xlH1vY4l+XS33l2txnBazD8qyXwicd1Se8KED6Q5lqjkLDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IUlnilnb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IUlnilnb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D634C4CEF7;
	Mon, 30 Mar 2026 12:39:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774874359;
	bh=dKuRGZG4/lteZTFXeqThLHmrHOH19quRHWpiId7Gqnk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IUlnilnbfiMymkgk47ZgCJRTKTLqkffjGbZYZ5SvvMlfyTvsrkv4T/J4ML65dy6B8
	 XNPpFeY1iizWCEoqofgvQbBY4Amk+nHnnmUl/b+ZRSRYnKGKoMk28VrXtEQbpKsneE
	 R/BUaFMDP6+CT+62eJrcZH51OLvI+5w9vFrzH62/YuZLNoY2rZyzubuiKAR2AAZGDh
	 umRlYcwMLbXlGqqIpRnF0eto7uzX6rp7qLzC9P8+BhaFRlmTyewdg8rmKJLf+sAlc2
	 PCMb6GCgasjgBeXvSieRqZBypV6biDP1FhRVBtSZibK/kNWvTfPFrAdKEnGgCaUrEJ
	 4+q80tCCYeTuw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Kshamendra Kumar Mishra <kshamendrakumarmishra@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>,
	perex@perex.cz,
	tiwai@suse.com,
	linux-sound@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.19-6.18] ALSA: hda/realtek: add HP Laptop 15-fd0xxx mute LED quirk
Date: Mon, 30 Mar 2026 08:38:38 -0400
Message-ID: <20260330123842.756154-25-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260330123842.756154-1-sashal@kernel.org>
References: <20260330123842.756154-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19.10
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Kshamendra Kumar Mishra <kshamendrakumarmishra@gmail.com>

[ Upstream commit faceb5cf5d7a08f4a40335d22d833bb75f05d99e ]

HP Laptop 15-fd0xxx with ALC236 codec does not handle the toggling of
the mute LED.
This patch adds a quirk entry for subsystem ID 0x8dd7 using
ALC236_FIXUP_HP_MUTE_LED_COEFBIT2 fixup, enabling correct mute LED
behavior.

Signed-off-by: Kshamendra Kumar Mishra <kshamendrakumarmishra@gmail.com>
Link: https://patch.msgid.link/DHAB51ISUM96.2K9SZIABIDEQ0@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have all the facts needed. Here is my comprehensive answer:

---

## Phase 1: Commit Message Forensics

**Step 1.1: Parse the Subject Line**
Record: [ALSA: hda/realtek] [add] [HP Laptop 15-fd0xxx mute LED quirk —
adds SND_PCI_QUIRK entry for subsystem ID 0x103c:0x8dd7 using existing
ALC236_FIXUP_HP_MUTE_LED_COEFBIT2 fixup]

**Step 1.2: Parse All Commit Message Tags**
Record:
- `Signed-off-by: Kshamendra Kumar Mishra
  <kshamendrakumarmishra@gmail.com>` — author
- `Link: https://patch.msgid.link/DHAB51ISUM96.2K9SZIABIDEQ0@gmail.com`
  — patch submission reference
- `Signed-off-by: Takashi Iwai <tiwai@suse.de>` — ALSA subsystem
  maintainer
- No `Fixes:`, `Reported-by:`, `Tested-by:`, `Reviewed-by:`, `Acked-
  by:`, or `Cc: stable@vger.kernel.org` (expected for manual review
  candidates)

**Step 1.3: Analyze the Commit Body Text**
Record: Bug: HP Laptop 15-fd0xxx with ALC236 codec does not handle mute
LED toggling. Symptom: Mute LED does not reflect mute state. Root cause:
Missing SSID-to-fixup mapping in the quirk table. Fix: Add entry for
subsystem ID 0x8dd7 pointing to existing
`ALC236_FIXUP_HP_MUTE_LED_COEFBIT2`.

**Step 1.4: Detect Hidden Bug Fixes**
Record: Not a hidden bug fix — this is an explicit hardware quirk
addition. The message directly describes a non-working mute LED and the
fixup that corrects it.

## Phase 2: Diff Analysis

**Step 2.1: Inventory the Changes**
Record: `sound/hda/codecs/realtek/alc269.c`: +1 line, -0 lines. Single
`SND_PCI_QUIRK` entry added to `alc269_fixup_tbl[]` between existing
entries 0x8dd4 and 0x8de8. Scope: single-file, single-line, table-data-
only.

**Step 2.2: Understand the Code Flow Change**
Record: Before: No quirk entry for 0x103c:0x8dd7; `snd_hda_pick_fixup()`
cannot select `ALC236_FIXUP_HP_MUTE_LED_COEFBIT2` for this machine, so
the mute LED is not properly controlled. After: The SSID match triggers
the existing fixup during codec probe, enabling correct mute LED
behavior.

**Step 2.3: Identify the Bug Mechanism**
Record: Bug category: Hardware workaround / missing quirk entry. The
`alc236_fixup_hp_mute_led_coefbit2()` helper programs
`spec->mute_led_coef.idx = 0x07`, `mask = 1`, `on = 1`, `off = 0` and
registers `coef_mute_led_set` via `snd_hda_gen_add_mute_led_cdev()`.
This is an existing, well-tested code path used by 17 other entries in
this file.

**Step 2.4: Assess the Fix Quality**
Record: Obviously correct — identical pattern to many existing HP ALC236
quirk entries. Minimal and surgical. Regression risk is effectively zero
since the new entry only matches one specific subsystem ID and uses an
existing, well-exercised fixup chain.

## Phase 3: Git History Investigation

**Step 3.1: Blame the Changed Lines**
Record: The neighboring entries (0x8dd4 at line 7099, 0x8de8 at line
7100) confirm the correct insertion point. The new 0x8dd7 entry is not
present in the current tree (verified by grep).

**Step 3.2: Follow the Fixes Tag**
Record: N/A — no `Fixes:` tag present.

**Step 3.3: Check File History for Related Changes**
Record: Recent `alc269.c` history shows a steady stream of similar
Realtek quirk additions (Acer, Samsung, HP models). This is a standalone
one-line addition — no patch series marker found.

**Step 3.4: Check the Author's Other Commits**
Record: The accepting maintainer is Takashi Iwai (`tiwai@suse.de`), the
long-standing ALSA maintainer, providing strong endorsement of this
quirk.

**Step 3.5: Check for Dependent/Prerequisite Commits**
Record: The prerequisite helper `ALC236_FIXUP_HP_MUTE_LED_COEFBIT2` was
introduced by commit `0659400f18c0e6` ("ALSA: hda/realtek: Enable Mute
LED on HP Laptop 15s-eq2xxx") which first appeared in `v6.5`. That
commit itself had `Cc: stable@vger.kernel.org`. The helper exists in
v6.5+, v6.6, and v6.19. It does **not** exist in v6.1 or v5.15.

## Phase 4: Mailing List and External Research

**Step 4.1: Search Lore**
Record: The `patch.msgid.link` URL returned an anti-bot page. Could not
retrieve the actual patch discussion thread. UNVERIFIED: exact reviewer
comments or stable nominations.

**Step 4.2: Search for Bug Report**
Record: No `Reported-by:` or bugzilla link. The only bug description is
in the commit message itself.

**Step 4.3: Check for Related Patches**
Record: This is a standalone single-line quirk addition, not part of a
multi-patch series.

**Step 4.4: Check Stable Mailing List**
Record: Similar HP Realtek mute LED quirks have been backported to
stable before (e.g., the original `0659400f18c0e6` helper commit had
`Cc: stable`). No specific stable discussion found for this exact patch.

## Phase 5: Code Semantic Analysis

**Step 5.1: Key Functions**
Record: No function body is modified. The change is data-only in
`alc269_fixup_tbl[]`. The affected runtime function is the existing
`alc236_fixup_hp_mute_led_coefbit2()`.

**Step 5.2: Trace Callers**
Record: `alc269_fixup_tbl[]` → consumed by `snd_hda_pick_fixup()` called
from `alc269_probe()` → registered as `.probe` in `alc269_codec_ops` /
`alc269_driver` via `module_hda_codec_driver()`. The fixup runs at codec
probe time on matching hardware.

**Step 5.3: Trace Callees**
Record: `alc236_fixup_hp_mute_led_coefbit2()` sets `spec->mute_led_coef`
fields and calls `snd_hda_gen_add_mute_led_cdev(codec,
coef_mute_led_set)`. `coef_mute_led_set()` calls
`alc_update_coef_led()`. This only affects LED control, not audio
routing or codec initialization logic.

**Step 5.4: Call Chain Reachability**
Record: HDA codec probe → `alc269_probe()` → `snd_hda_pick_fixup(...
alc269_fixup_tbl ...)` → `snd_hda_apply_fixup(HDA_FIXUP_ACT_PRE_PROBE)`
→ `alc236_fixup_hp_mute_led_coefbit2()`. Reachable only on systems with
the exact matching subsystem ID.

**Step 5.5: Similar Patterns**
Record: `ALC236_FIXUP_HP_MUTE_LED_COEFBIT2` appears 17 times in
`alc269.c`, confirming it is a well-established fixup used by many HP
devices. Related one-line commits include `d510acb610e6aa`,
`d33c3471047fc`, `9ed7a28225af0`.

## Phase 6: Stable Tree Analysis

**Step 6.1: Does the Buggy Code Exist in Stable Trees?**
Record: The missing quirk (0x8dd7 absent) affects any stable tree that
carries the `ALC236_FIXUP_HP_MUTE_LED_COEFBIT2` helper. Verified:
- **v6.19**: helper present in `sound/hda/codecs/realtek/alc269.c` —
  **applicable**
- **v6.6**: helper present in `sound/pci/hda/patch_realtek.c` (5
  occurrences) — **applicable** (minor path adjustment needed)
- **v6.1**: helper **absent** (0 occurrences) — **not standalone
  applicable**
- **v5.15**: helper **absent** (0 occurrences) — **not standalone
  applicable**

**Step 6.2: Backport Complications**
Record: For v6.19.y: clean apply expected (same file layout). For
v6.6.y: needs minor mechanical adjustment (file is
`sound/pci/hda/patch_realtek.c` instead of the new split path, and
different surrounding context lines). For v6.1.y and v5.15.y: not a
standalone backport — prerequisite infrastructure absent.

**Step 6.3: Related Fixes Already in Stable**
Record: The original helper commit `0659400f18c0e6` had `Cc:
stable@vger.kernel.org` and is present from v6.5 onward. The exact
0x8dd7 entry is not yet present anywhere (verified by grep).

## Phase 7: Subsystem and Maintainer Context

**Step 7.1: Subsystem Criticality**
Record: ALSA HDA Realtek codec driver — IMPORTANT level for affected
laptop users. Not core kernel, but real user-visible hardware
functionality.

**Step 7.2: Subsystem Activity**
Record: Highly active — frequent quirk additions and fixes to
`alc269.c`, typical for ongoing hardware enablement.

## Phase 8: Impact and Risk Assessment

**Step 8.1: Who Is Affected**
Record: Users of HP Laptop 15-fd0xxx with ALC236 codec and subsystem ID
0x103c:0x8dd7. Driver-specific, hardware-specific.

**Step 8.2: Trigger Conditions**
Record: Every time the user mutes/unmutes audio, the LED does not
correctly reflect the mute state. Affects normal daily use of the
laptop.

**Step 8.3: Failure Mode Severity**
Record: Mute LED does not toggle — user cannot visually confirm mute
state. Severity: LOW-MEDIUM (hardware not working as designed, but no
crash/corruption/security issue).

**Step 8.4: Risk-Benefit Ratio**
Record: Benefit: Restores expected mute LED behavior for a specific HP
laptop model. Risk: Effectively zero — one table entry matching a single
subsystem ID, using an existing well-tested fixup chain. Ratio: Very
favorable.

## Phase 9: Final Synthesis

**Step 9.1: Compile the Evidence**

Evidence FOR backporting:
- Single-line hardware quirk addition — explicit exception category for
  stable
- Uses existing, well-tested fixup (`ALC236_FIXUP_HP_MUTE_LED_COEFBIT2`,
  used by 17 other entries)
- Zero regression risk (only matches one specific hardware subsystem ID)
- Accepted by ALSA maintainer Takashi Iwai
- Fixes real, user-visible hardware behavior for a shipping laptop model
- The original helper commit had `Cc: stable@vger.kernel.org` — the
  infrastructure was intended for stable

Evidence AGAINST backporting:
- Low severity (LED behavior only, not crash/security/corruption)
- Not standalone for v6.1.y and v5.15.y (helper absent)

Unresolved:
- Exact mailing list review discussion (blocked by Anubis)
- Independent testing beyond author and maintainer signoff

**Step 9.2: Stable Rules Checklist**
1. Obviously correct and tested? **YES** — identical pattern to 17
   existing entries using the same fixup
2. Fixes a real bug? **YES** — mute LED non-functional on specific
   hardware
3. Important issue? **MEDIUM** — hardware not working as expected; fits
   the quirk exception
4. Small and contained? **YES** — 1 line in 1 file
5. No new features or APIs? **YES** — uses existing fixup
6. Can apply to stable? **YES** for v6.6.y and v6.19.y; **NO** as
   standalone for v6.1.y/v5.15.y

**Step 9.3: Exception Category**
Record: **Audio codec quirk** (`SND_PCI_QUIRK` entry for existing fixup)
— explicitly listed as an allowed exception for stable backporting.

**Step 9.4: Decision**
This is a textbook hardware quirk addition: one line, zero regression
risk, existing infrastructure, maintainer-accepted. It should be
backported to stable trees that already contain the
`ALC236_FIXUP_HP_MUTE_LED_COEFBIT2` helper (v6.6.y and newer).

## Verification

- [Phase 1] Parsed tags: `Signed-off-by` from author and ALSA maintainer
  Takashi Iwai; `Link:` to patch submission; no `Fixes:`, `Reported-
  by:`, or `Cc: stable`
- [Phase 2] Diff analysis: +1 line `SND_PCI_QUIRK(0x103c, 0x8dd7, ...)`
  in `alc269_fixup_tbl[]`; verified 0x8dd7 not present in current tree
  (grep returned no matches)
- [Phase 2] Read `alc236_fixup_hp_mute_led_coefbit2()` at lines
  1525-1538: confirmed it sets `mute_led_coef.idx = 0x07`, `mask = 1`,
  `on = 1`, `off = 0` and calls `snd_hda_gen_add_mute_led_cdev()`
- [Phase 2] Verified 17 occurrences of
  `ALC236_FIXUP_HP_MUTE_LED_COEFBIT2` in `alc269.c` — well-established
  fixup
- [Phase 3] `git log -S'ALC236_FIXUP_HP_MUTE_LED_COEFBIT2'` confirmed
  introduction by `0659400f18c0e6` and subsequent quirk additions
- [Phase 3] `git show 0659400f18c0e6`: confirmed helper introduction
  with `Cc: <stable@vger.kernel.org>`
- [Phase 3] `git tag --contains 0659400f18c0e6`: helper first appeared
  in v6.5 lineage
- [Phase 3] Verified insertion point: 0x8dd4 at line 7099, 0x8de8 at
  line 7100 — correct sorted position
- [Phase 4] `patch.msgid.link` URL blocked by anti-bot protection —
  UNVERIFIED: reviewer comments
- [Phase 5] Traced call chain: `alc269_probe()` → `snd_hda_pick_fixup()`
  → `snd_hda_apply_fixup()` → helper. Probe-time only.
- [Phase 6] **v6.6**: `ALC236_FIXUP_HP_MUTE_LED_COEFBIT2` present (5
  occurrences in `patch_realtek.c`) — applicable
- [Phase 6] **v6.1**: helper absent (0 occurrences) — NOT standalone
  applicable
- [Phase 6] **v5.15**: helper absent (0 occurrences) — NOT standalone
  applicable
- [Phase 8] Failure mode: non-functional mute LED only; severity LOW-
  MEDIUM; no crash/security/data path
- UNVERIFIED: exact mailing list discussion content and any external
  test reports for this specific model

**YES**

 sound/hda/codecs/realtek/alc269.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/hda/codecs/realtek/alc269.c b/sound/hda/codecs/realtek/alc269.c
index 5adc5db6fd52b..1054191d56fa1 100644
--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -7099,6 +7099,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x103c, 0x8da7, "HP 14 Enstrom OmniBook X", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x103c, 0x8da8, "HP 16 Piston OmniBook X", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x103c, 0x8dd4, "HP EliteStudio 8 AIO", ALC274_FIXUP_HP_AIO_BIND_DACS),
+	SND_PCI_QUIRK(0x103c, 0x8dd7, "HP Laptop 15-fd0xxx", ALC236_FIXUP_HP_MUTE_LED_COEFBIT2),
 	SND_PCI_QUIRK(0x103c, 0x8de8, "HP Gemtree", ALC245_FIXUP_TAS2781_SPI_2),
 	SND_PCI_QUIRK(0x103c, 0x8de9, "HP Gemtree", ALC245_FIXUP_TAS2781_SPI_2),
 	SND_PCI_QUIRK(0x103c, 0x8dec, "HP EliteBook 640 G12", ALC236_FIXUP_HP_GPIO_LED),
-- 
2.53.0

