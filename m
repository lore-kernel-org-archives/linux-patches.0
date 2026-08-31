Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7F6F56FA6E;
	Mon, 31 Aug 2026 13:48:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184125; cv=none; b=Te9IPAEnIIZOP230f14ZrmjjO7zsq/t4jRkiuZVGh12gjD/R0oSnZLVNEsudoC9JZqHPCoZFI9b8/3q+MDNBb0ahbg7A35cmObQRUHp6GKvD6ZlifT8JujaOXhgq1cPnuOQabWQeVKTMQSqoK99d7a4oSMXMZ5CNmccG6935XDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184125; c=relaxed/simple;
	bh=MyVGdkapJo7uz38KZUV5Ah+fkh4v+BDrh9wPD97M000=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Dx60pJXHMXmvlsefnp3Gy3iymCAAqSdRhY0zWiF1J4CDxGsWouyTTpcBoJLHDQCgS0eQd7+HbuFPfx+QLZGHweQU4w1XXeWYI4eiqjKXnTclu4WBCv/7CGjMWmAac9bwm7N/1MbNVRE5MHaUC3gtjv0KfYSK3hQqto/Nxl1US4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bGbz/6y6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bGbz/6y6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BA281F00ACF;
	Mon, 31 Aug 2026 13:48:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788184122;
	bh=poYvFVwgRt6ax7yYw0845dAMxDo4gpjAawdVwxTmDEk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bGbz/6y6YwHDmxC6iBUkLQLr8eZPx0JsyoYRpL8isqPLr1Nn7Z99WSVWFPa85DUOZ
	 6j89Q6aKBeJm6SoqjecXPlWgukygj5AdU3Dznd++oS6wgr2hs07rRiqWWGKzFL01Cp
	 OttbbFCccqPSQyUY+pI7LrZ7u/Z2IGQyISaq5MDVjT33r2VqZ0nCzljvFKXlD5UA4V
	 o3/kju/pwKB61jmssvh5F9MhvehFre1o8gNQvYXF9gDiN2eBpA58fq46Qhm/9EY5pL
	 dlV9kSlIBmarujdTwluoKdvOsxyOUiWanOR63aHow9CqooDTh+yilS39vbwD3RZ5xu
	 vS3vQQ1piNEdw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Richard Fitzgerald <rf@opensource.cirrus.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>,
	david.rhodes@cirrus.com,
	perex@perex.cz,
	tiwai@suse.com,
	linux-sound@vger.kernel.org,
	patches@opensource.cirrus.com,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.12] ALSA: hda: cs35l56: Fail if wmfw file is missing
Date: Mon, 31 Aug 2026 09:28:53 -0400
Message-ID: <20260831133314.4125787-505-sashal@kernel.org>
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

From: Richard Fitzgerald <rf@opensource.cirrus.com>

[ Upstream commit 07ae060d35900977a93d4a05ec995b06c85c2552 ]

Fail cs35l56_hda_fw_load() and log an error if it didn't find a wmfw file
and the BIOS didn't patch the firmware already. Also remove a section of
code from cs35l56_hda_request_firmware_files() that attempted to find a
.bin if a .wmfw was not found.

The CS35L56 ROM can only provide default audio in SoundWire mode. A wmfw
is needed to enable I2S audio. Also none of the customer-specific .bin
files are compatible with the ROM firmware. So a .wmfw file is always
required.

Signed-off-by: Richard Fitzgerald <rf@opensource.cirrus.com>
Link: https://patch.msgid.link/20260709161211.686498-1-rf@opensource.cirrus.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit Message Forensics

**Step 1.1 — Subject line**

Record: `[ALSA: hda: cs35l56]` `[Fail]` — Fail firmware load when
required `.wmfw` file is missing for CS35L56 HDA amplifier driver.

**Step 1.2 — Tags**

Record:
- `Signed-off-by: Richard Fitzgerald <rf@opensource.cirrus.com>` —
  Cirrus Logic driver author
- `Link: https://patch.msgid.link/20260709161211.686498-1-
  rf@opensource.cirrus.com` — original submission
- `Signed-off-by: Takashi Iwai <tiwai@suse.de>` — ALSA maintainer merge
- No `Fixes:`, `Reported-by:`, `Tested-by:`, `Reviewed-by:`, `Cc:
  stable@vger.kernel.org`

Notable: no fuzzer or user bug reports; vendor-authored fix merged by
subsystem maintainer.

**Step 1.3 — Body analysis**

Record:
- **Bug:** Driver allowed proceeding with only a `.bin` coefficient file
  when no `.wmfw` was found, even when BIOS had not pre-patched
  firmware.
- **Symptom:** I2S audio cannot work without `.wmfw`; customer `.bin`
  files are incompatible with ROM firmware.
- **Root cause:** Fallback in `cs35l56_hda_request_firmware_files()`
  searched for system-specific `.bin` without `.wmfw`, and
  `cs35l56_hda_fw_load()` only validated `.bin` presence, not `.wmfw`.
- **Version info:** None in message.

**Step 1.4 — Hidden bug fix?**

Record: Yes. Although phrased as validation, this fixes incorrect
firmware-loading logic that could shut down the DSP and attempt to load
incompatible coefficients onto ROM firmware.

---

## Phase 2: Diff Analysis

**Step 2.1 — Inventory**

Record:
- **File:** `sound/hda/codecs/side-codecs/cs35l56_hda.c` (+9 / −21, net
  −12 lines)
- **Functions:** `cs35l56_hda_request_firmware_files()`,
  `cs35l56_hda_fw_load()`
- **Scope:** Single-file surgical fix

**Step 2.2 — Code flow changes**

Record:
- **Hunk 1 (request_firmware_files):** Before → if system-specific
  `.wmfw` missing, try system-specific `.bin` alone and return early if
  found. After → that fallback removed; search continues to generic
  firmware paths.
- **Hunk 2 (fw_load):** Before → when `firmware_missing`, only require
  `.bin`. After → when `firmware_missing`, require both `.wmfw` and
  `.bin`, with explicit error messages for each.

**Step 2.3 — Bug mechanism**

Record:
- **Category:** Logic / correctness fix (firmware validation)
- **Mechanism:** Without `.wmfw`, `cs_dsp_load()` returns 0 for NULL
  firmware (verified in `drivers/firmware/cirrus/cs_dsp.c:1527-1528`),
  so `cs_dsp_power_up()` could proceed to `setup_algs()` and
  `cs_dsp_load_coeff()` with only an incompatible `.bin` on ROM firmware
  — after an unnecessary `cs35l56_firmware_shutdown()`.

**Step 2.4 — Fix quality**

Record:
- Fix is minimal and matches vendor hardware requirements.
- No API changes; only tightens validation on the `firmware_missing`
  path.
- Regression risk: very low — systems with valid `.wmfw`+`.bin` or BIOS-
  patched firmware are unchanged.
- BIOS-patched path (`firmware_missing == false`) is unaffected.

---

## Phase 3: Git History Investigation

**Step 3.1 — Blame**

Record: Buggy fallback and incomplete validation introduced in
`5d324e5159d9e` (2025-11-28, v6.18-rc8 merge window). File did not exist
before that commit in this tree (`git show 5d324e5159d9e^:...` → 0
lines; current tree → 1182 lines).

**Step 3.2 — Fixes: tag**

Record: Not applicable — no `Fixes:` tag present.

**Step 3.3 — Related file history**

Record: Recent non-merge commits on this file in 6.18.y:
- `fecae8b1fb2d3` — ACPI companion ordering
- `7e6f7ac79abe2` — uninitialized value fix
- `f8ad9ef771565` — ASP TX error propagation
- `c18c40e081c19` — signedness fix

Standalone fix; not part of a multi-patch series.

**Step 3.4 — Author context**

Record: Richard Fitzgerald (Cirrus Logic) is the CS35L56 driver author.
Recent HDA cs35l56 commits in this tree are maintenance fixes from the
same vendor ecosystem.

**Step 3.5 — Dependencies**

Record: No prerequisites. Patch applies cleanly (`git apply --check`
succeeded). All referenced symbols exist in this tree.

---

## Phase 4: Mailing List and External Research

**Step 4.1 — Original discussion**

Record: Fetched lore mbox at `https://lore.kernel.org/all/20260709161211
.686498-1-rf@opensource.cirrus.com/t.mbox.gz`. Single v1 submission
(2026-07-09). `b4 dig -c` did not match (commit not in tree); `b4 dig
-a` returned no revisions. No review replies or stable nominations
found.

**Step 4.2 — Reviewers**

Record: Patch sent To: `tiwai@suse.com`, Cc: `linux-
sound@vger.kernel.org`, `linux-kernel@vger.kernel.org`. Merged by
Takashi Iwai.

**Step 4.3 — Bug reports**

Record: None. No syzbot, bugzilla, or user reports.

**Step 4.4 — Related patches**

Record: Standalone; not part of a series.

**Step 4.5 — Stable list history**

Record: No stable-list discussion found for this fix.

---

## Phase 5: Code Semantic Analysis

**Step 5.1 — Key functions**

Record: `cs35l56_hda_request_firmware_files()`, `cs35l56_hda_fw_load()`,
`cs35l56_hda_dsp_work()`, `cs35l56_hda_bind()`.

**Step 5.2 — Callers**

Record:
- `cs35l56_hda_fw_load()` ← `cs35l56_hda_dsp_work()` (workqueue)
- `cs35l56_hda_dsp_work()` queued from `cs35l56_hda_bind()` during HDA
  component binding at audio subsystem init

**Step 5.3 — Callees**

Record: `cs35l56_firmware_shutdown()`, `cs_dsp_power_up()` →
`cs_dsp_load()` / `cs_dsp_load_coeff()`, `cs35l56_system_reset()`,
`cs_dsp_run()`.

**Step 5.4 — Reachability**

Record: Triggered during device bind on laptops with
`CONFIG_SND_HDA_SCODEC_CS35L56_{I2C,SPI}=y/m`. Common boot path for
affected Cirrus CS35L56 HDA hardware; not userspace-syscall reachable,
but runs on every affected machine boot.

**Step 5.5 — Similar patterns**

Record: `cs35l41_hda.c` always loads `.wmfw` before `cs_dsp_power_up()`.
The removed cs35l56 fallback (`.bin` without `.wmfw`) was inconsistent
with CS35L56 hardware requirements described by the vendor.

---

## Phase 6: Cross-Reference Against Local Tree (6.18.44)

**Step 6.1 — Buggy code present?**

Record: **Yes.** Local tree is **v6.18.44** (`git describe HEAD` →
`v6.18.44-1-g2736c32da98b9`). Buggy fallback at lines 520–532 and
incomplete validation at lines 622–625 of `cs35l56_hda.c` are present.
Driver introduced in 6.18; bug present since introduction.

**Step 6.2 — Backport complications**

Record: Clean apply expected — `git apply --check` passed with no
conflicts.

**Step 6.3 — Related fixes already present?**

Record: No equivalent wmfw-validation fix in this tree. Other cs35l56
HDA fixes (uninit value, signedness, error propagation) are separate
issues.

---

## Phase 7: Subsystem and Maintainer Context

**Step 7.1 — Subsystem criticality**

Record: **ALSA / HDA side-codec driver** — IMPORTANT, platform-specific
(CS35L56 laptop amplifiers). Requires `CONFIG_SND_HDA_SCODEC_CS35L56`
and I2C or SPI variant.

**Step 7.2 — Subsystem activity**

Record: Actively maintained in 6.18.y with multiple recent cs35l56 HDA
fixes.

---

## Phase 8: Impact and Risk Assessment

**Step 8.1 — Who is affected**

Record: Users of laptops with CS35L56 HDA amplifiers where BIOS did not
pre-patch firmware and firmware packaging is incomplete (`.bin` present,
`.wmfw` missing). Config-specific, but real hardware on modern laptops.

**Step 8.2 — Trigger conditions**

Record: Boot-time firmware load when `firmware_missing == true` and a
system-specific `.bin` exists without matching `.wmfw`. Unprivileged
users cannot directly trigger it, but it affects every boot on
misconfigured affected systems.

**Step 8.3 — Failure mode severity**

Record:
- **Without fix:** Unnecessary firmware shutdown/reset, then attempt to
  load incompatible `.bin` onto ROM firmware; I2S audio non-functional;
  possible DSP errors logged at debug level only.
- **Severity:** MEDIUM — hardware malfunction (no speakers), not kernel
  oops, but incorrect firmware programming on real hardware.

**Step 8.4 — Risk-benefit**

Record:
- **Benefit:** Prevents invalid firmware path; clear `dev_err()` for
  missing `.wmfw`; avoids pointless shutdown/reset and incompatible
  coefficient loading.
- **Risk:** Very low — small vendor fix, no behavior change for
  correctly configured systems.
- **Ratio:** Favorable for 6.18.y where this driver exists and the bug
  is present.

---

## Phase 9: Final Synthesis

**Evidence FOR:**
- Fixes real incorrect firmware-loading logic confirmed in local tree
- Vendor-authored, maintainer-merged, obviously correct per CS35L56
  hardware requirements
- Small, single-file, applies cleanly to 6.18.44
- Prevents loading customer `.bin` files incompatible with ROM firmware
- Improves diagnostics for broken audio on affected laptops
- Driver and buggy code both exist in this tree since 6.18

**Evidence AGAINST:**
- No user reports, syzbot, or crash reports
- Primary user-visible outcome may still be “no audio” on misconfigured
  systems
- New driver with limited 6.18.y deployment so far
- No explicit stable nomination in review thread

**Unresolved:** Whether loading incompatible `.bin` onto ROM can cause
anything beyond failed audio (vendor states incompatibility; no crash
report verified).

**Stable rules checklist:**
1. Obviously correct and tested? **PASS** — vendor requirement,
   maintainer merged; no Tested-by
2. Fixes real bug? **PASS** — invalid firmware path on real hardware
3. Important issue? **PASS (MEDIUM)** — broken audio / incorrect DSP
   programming on affected laptops
4. Small and contained? **PASS** — 30 lines, one file
5. No new features/APIs? **PASS**
6. Applies to local tree? **PASS** — clean apply to 6.18.44

**Exception category:** Hardware workaround / driver correctness for
existing CS35L56 HDA support.

---

## Problem Summary for Stable Users

On CS35L56 HDA laptops where the BIOS has not pre-loaded firmware, the
driver incorrectly treated a `.bin` coefficient file as sufficient even
when the required `.wmfw` firmware wrapper was missing. Per Cirrus
Logic, ROM firmware only supports SoundWire default audio; `.wmfw` is
mandatory for I2S, and customer `.bin` files are not compatible with
ROM. The old code could shut down the amplifier and attempt an invalid
DSP load. The fix fails early with a clear error and removes the invalid
`.bin`-without-`.wmfw` fallback.

For **Linux 6.18.y** specifically, this driver exists and the bug is
present from its introduction; the fix is low-risk and should be
included.

---

## Verification

- [Phase 1] Parsed commit message and tags from user-provided content
  and lore mbox fetch
- [Phase 2] Diff analysis: 2 functions modified, logic/correctness bug
  in firmware validation
- [Phase 3] `git describe HEAD` / `make kernelversion`: tree is
  **6.18.44**
- [Phase 3] `git blame -L 518,625`: buggy code from `5d324e5159d9e`
  (2025-11-28)
- [Phase 3] `git show 5d324e5159d9e^:...cs35l56_hda.c`: file absent
  before merge (driver new in 6.18)
- [Phase 3] `git log --oneline -20 -- cs35l56_hda.c`: related fixes
  listed; no duplicate wmfw fix
- [Phase 4] Lore mbox fetch: original patch at
  `20260709161211.686498-1-rf@opensource.cirrus.com`
- [Phase 4] `b4 dig`: no commit match (not in tree); no series revisions
  found
- [Phase 4] No stable-list or review-thread stable nominations found
- [Phase 5] `grep cs35l56_hda_fw_load`: call chain bind → workqueue →
  fw_load verified
- [Phase 5] `cs_dsp_load()` at `cs_dsp.c:1527-1528`: NULL wmfw returns
  0, allowing coeff load attempt
- [Phase 6] Buggy fallback at `cs35l56_hda.c:520-532` and validation at
  `:622-625` confirmed present
- [Phase 6] `git apply --check`: patch applies cleanly
- [Phase 7] Kconfig: `SND_HDA_SCODEC_CS35L56_{I2C,SPI}` in
  `sound/hda/codecs/side-codecs/Kconfig`
- [Phase 8] Failure mode: broken audio / invalid DSP load, severity
  MEDIUM (not verified as kernel crash)

**YES**

 sound/hda/codecs/side-codecs/cs35l56_hda.c | 30 +++++++---------------
 1 file changed, 9 insertions(+), 21 deletions(-)

diff --git a/sound/hda/codecs/side-codecs/cs35l56_hda.c b/sound/hda/codecs/side-codecs/cs35l56_hda.c
index 1d25fe01066ee..baf286bf7ec83 100644
--- a/sound/hda/codecs/side-codecs/cs35l56_hda.c
+++ b/sound/hda/codecs/side-codecs/cs35l56_hda.c
@@ -516,20 +516,6 @@ static void cs35l56_hda_request_firmware_files(struct cs35l56_hda *cs35l56,
 								  NULL, "bin");
 			return;
 		}
-
-		/*
-		 * Check for system-specific bin files without wmfw before
-		 * falling back to generic firmware
-		 */
-		if (amp_name)
-			cs35l56_hda_request_firmware_file(cs35l56, coeff_firmware, coeff_filename,
-							  base_name, system_name, amp_name, "bin");
-		if (!*coeff_firmware)
-			cs35l56_hda_request_firmware_file(cs35l56, coeff_firmware, coeff_filename,
-							  base_name, system_name, NULL, "bin");
-
-		if (*coeff_firmware)
-			return;
 	}
 
 	ret = cs35l56_hda_request_firmware_file(cs35l56, wmfw_firmware, wmfw_filename,
@@ -615,13 +601,15 @@ static void cs35l56_hda_fw_load(struct cs35l56_hda *cs35l56)
 					   &wmfw_firmware, &wmfw_filename,
 					   &coeff_firmware, &coeff_filename);
 
-	/*
-	 * If the BIOS didn't patch the firmware a bin file is mandatory to
-	 * enable the ASP·
-	 */
-	if (!coeff_firmware && firmware_missing) {
-		dev_err(cs35l56->base.dev, ".bin file required but not found\n");
-		goto err_fw_release;
+	/* If the BIOS didn't patch the firmware a wmfw and bin file are mandatory */
+	if (firmware_missing) {
+		if (!wmfw_firmware) {
+			dev_err(cs35l56->base.dev, ".%s file required but not found\n", "wmfw");
+			goto err_fw_release;
+		} else if (!coeff_firmware) {
+			dev_err(cs35l56->base.dev, ".%s file required but not found\n", "bin");
+			goto err_fw_release;
+		}
 	}
 
 	mutex_lock(&cs35l56->base.irq_lock);
-- 
2.53.0

