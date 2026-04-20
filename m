Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D41C3A9632;
	Mon, 20 Apr 2026 13:16:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776690986; cv=none; b=i9szW8E/o+VhtBXaVM7lhSASSHMtXuAJxiddvKcqnN1209poTIryBE4qbJinaB9M0/xKNMNBURSS/9YuAPs4xFon6T0g2a7/NqkvCXILZ8GMuuKCHZBYSdnKAjLENB+1zyPTavlrgJ/MhCksEuKbTxXhdAeUGmz+cYVlen2GnO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776690986; c=relaxed/simple;
	bh=DVU6sSQpDMKb7gtxs0qNmAm09iL05HHL/I4CIuRAQgo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jImd5PYk4+FtWCauvGeykSE300WFZq2qUougMBKgF7V7wvbcDCf9ameg373ajlH0UktOv2SjHUD860YAWWl0yAXpbsV7Nx4oeF70zlwgYGXh/UR0mKz0ctIivrYfLcTSGK5Zk8O+ccipYjJZXxZSEla1CqZAz6MdHF95f1U07RM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Cr7UtpmH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Cr7UtpmH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F602C2BCB6;
	Mon, 20 Apr 2026 13:16:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776690985;
	bh=DVU6sSQpDMKb7gtxs0qNmAm09iL05HHL/I4CIuRAQgo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Cr7UtpmH3De6MI1Mu7O887JwmzdJN8wPtoV0hUSdbkxLKvLoLnMHLuhPyYrBLm+PR
	 +c+y3SGrslKYKZGTopC47tgCFVic0GjB8wnWZ3IaignUBbkDTjfWa2dEiYInaPi62o
	 45b/XV4cfvwfcG3QnoJt1jqCee05//28eKPk7eIZyShe7KXhXiim5F+CQm/MqLkkjS
	 iiGEd+exfg9va0CSdP03dtk3lT9VceJeYDcRz8tIqM7OKOrsU4CFOcN5ju9AWoYMk1
	 6ElVn20iM0pP2syQhctJi/oMf+NV4/b1v8B+MW7xeErepyl7PqMAl8Ss5pI0+1uUTp
	 zjFa7Q92+Nbyw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Richard Fitzgerald <rf@opensource.cirrus.com>,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.dev>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	lgirdwood@gmail.com,
	perex@perex.cz,
	tiwai@suse.com,
	alsa-devel@alsa-project.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-6.19] ASoC: SDCA: Add CS47L47 to class driver
Date: Mon, 20 Apr 2026 09:08:13 -0400
Message-ID: <20260420131539.986432-27-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420131539.986432-1-sashal@kernel.org>
References: <20260420131539.986432-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 7.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Richard Fitzgerald <rf@opensource.cirrus.com>

[ Upstream commit ada32396f90951e12465224c04742607ca56a982 ]

Add the SoundWire ID for CS47L47 to the class driver.

Signed-off-by: Richard Fitzgerald <rf@opensource.cirrus.com>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.dev>
Link: https://patch.msgid.link/20260223150256.326143-4-rf@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have all the information needed. Let me compile my analysis.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1: Subject Line**
- Subsystem: `ASoC: SDCA`
- Action verb: "Add" (device ID addition)
- Summary: Add CS47L47 SoundWire device ID to the SDCA class driver

Record: [ASoC: SDCA] [Add] [SoundWire ID for CS47L47 added to class
driver device table]

**Step 1.2: Tags**
- `Signed-off-by: Richard Fitzgerald <rf@opensource.cirrus.com>` -
  Author, Cirrus Logic employee (device vendor)
- `Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.dev>` -
  SoundWire subsystem reviewer
- `Link: https://patch.msgid.link/20260223150256.326143-4-
  rf@opensource.cirrus.com` - patch 4 of a series (message numbering
  indicates patch 3/3 of the content, with 1 being cover letter)
- `Signed-off-by: Mark Brown <broonie@kernel.org>` - Applied by the ASoC
  subsystem maintainer
- No Fixes: tag (expected for a device ID addition)
- No Cc: stable (expected)

Record: Reviewed by SoundWire expert. Applied by ASoC maintainer. Author
is from Cirrus Logic (vendor).

**Step 1.3: Commit Body**
The body is minimal: "Add the SoundWire ID for CS47L47 to the class
driver." This is standard for device ID additions — no bug description
needed because this is hardware enablement.

Record: Straightforward device ID addition. No bug fix, no failure mode
described.

**Step 1.4: Hidden Bug Fix Detection**
This is not a hidden bug fix. It is a device ID addition to enable new
hardware (CS47L47 audio codec) on an existing driver. This falls
squarely into the "NEW DEVICE IDs" exception category.

Record: Not a hidden bug fix. It's a device ID addition — an explicit
exception category for stable.

## PHASE 2: DIFF ANALYSIS

**Step 2.1: Inventory**
- Files changed: 1 (`sound/soc/sdca/sdca_class.c`)
- Lines added: 1
- Lines removed: 0
- Function modified: None — change is in the `class_sdw_id[]` static
  data table
- Scope: Single-line addition to a device ID table — as minimal as
  possible

Record: [sound/soc/sdca/sdca_class.c +1/-0] [No function logic changed,
only data table entry added] [Trivial single-line]

**Step 2.2: Code Flow Change**
- Before: The `class_sdw_id[]` table contains one entry
  `SDW_SLAVE_ENTRY(0x01FA, 0x4245, 0)` matching one Cirrus Logic device.
- After: The table has two entries, adding `SDW_SLAVE_ENTRY(0x01FA,
  0x4747, 0)` for CS47L47.
- Effect: The SoundWire bus will now match CS47L47 devices to this
  driver and call `class_sdw_probe()`.

Record: Before: only CS42L45 (0x4245) matched. After: CS47L47 (0x4747)
also matched. Normal probe path, no error path changes.

**Step 2.3: Bug Mechanism**
Category (h) — Hardware workarounds/enablement. This is a device ID
addition, not a bug fix.

Record: [Device ID addition] [Adds SoundWire slave entry for CS47L47 to
existing driver's ID table]

**Step 2.4: Fix Quality**
- Obviously correct: Yes — identical pattern to the existing entry, just
  a different device/part ID
- Minimal: Yes — exactly 1 line
- Regression risk: Essentially zero — only affects CS47L47 hardware;
  cannot impact existing devices
- No red flags

Record: Trivially correct. Zero regression risk for existing devices.

## PHASE 3: GIT HISTORY

**Step 3.1: Blame**
The device ID table was introduced in commit `2d877d0659cb6` ("ASoC:
SDCA: Add basic SDCA class driver") by Charles Keepax, November 2025.
This was merged in v6.19-rc1. The SDCA class driver exists in v7.0.

Record: Driver introduced in v6.19, present in v7.0. Device ID table
area unchanged since creation.

**Step 3.2: No Fixes: tag** — expected, as this is a device ID addition.

**Step 3.3: File History**
Only 3 commits to `sdca_class.c`:
1. `2d877d0659cb6` - Initial driver
2. `7a5214f769c7c` - Add suspend support
3. `da7afdc79cba0` - Add init serialization lock

All are from the same Cirrus Logic team. No conflicting changes.

Record: Clean history, no prerequisites needed beyond the base driver.

**Step 3.4: Author**
Richard Fitzgerald is a Cirrus Logic engineer, the vendor of the
CS47L47. He's a regular contributor to the Cirrus Logic sound codec
drivers (cs35l56, cs42l42 family). This is authoritative — the device
vendor adding their own device ID.

Record: Author is from the device vendor (Cirrus Logic), regular sound
subsystem contributor.

**Step 3.5: Dependencies**
This is patch 3/3 of the series "ASoC: SDCA: Initial support for Cirrus
Logic CS47L47":
1. `soundwire: intel_auxdevice: Add CS47L47 to wake_capable_list`
   (supplementary)
2. `ASoC: soc_sdw_utils: Add device info for CS47L47` (supplementary)
3. This commit: Add device ID to class driver (core enablement)

This commit is standalone — it adds the device ID that allows probe. The
other patches add supplementary features (wake capability, extra device
info) but are not prerequisites for basic device operation via the class
driver.

Record: Standalone. Other series patches are supplementary, not required
for this to work.

## PHASE 4: MAILING LIST

**Step 4.1-4.5: External Research**
Lore pages were blocked by anti-scraping, but from patchew.org I
confirmed:
- This is patch 3/3 of the series
- The patch was reviewed by Pierre-Louis Bossart (SoundWire expert)
- Applied by Mark Brown (ASoC maintainer)
- No NAKs, no concerns raised
- Single revision — no v2/v3 needed

Record: Clean review. Applied by maintainer. No concerns raised.

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1-5.5:**
The only change is in the `class_sdw_id[]` data table. No functions are
modified. The table is consumed by the SoundWire bus matching
infrastructure — when a CS47L47 device appears on the bus, the existing
`class_sdw_probe()` function will be called. This is a well-tested code
path (already used for the CS42L45 device).

Record: No function logic changed. The existing probe path handles the
new device ID through standard bus matching.

## PHASE 6: STABLE TREE ANALYSIS

**Step 6.1:** The SDCA class driver was introduced in v6.19. This v7.0
stable tree has the driver. The file has had minimal changes (3 total
commits) and the device ID table area is untouched since creation.

**Step 6.2:** The patch will apply cleanly — the context around the
device ID table is unchanged from the original driver creation.

**Step 6.3:** No related fixes already in stable for this device.

Record: Code exists in v7.0 stable. Clean apply expected. No conflicts.

## PHASE 7: SUBSYSTEM CONTEXT

**Step 7.1:** ASoC (ALSA System on Chip) / SDCA — audio codec driver.
Criticality: IMPORTANT — audio is a core user-facing feature on laptops
and embedded devices.

**Step 7.2:** Active subsystem with regular contributions from Cirrus
Logic and Intel teams.

Record: [ASoC/SDCA audio] [IMPORTANT criticality] [Active subsystem]

## PHASE 8: IMPACT AND RISK

**Step 8.1:** Affected users: Anyone with CS47L47 hardware (Cirrus Logic
audio codec on SoundWire bus). Without this patch, the CS47L47 device
will not be recognized by the kernel and audio will not work.

**Step 8.2:** Trigger: Device enumeration on the SoundWire bus during
boot. Every user with this hardware is affected, every boot.

**Step 8.3:** Without this fix: no audio support for CS47L47 hardware.
Severity: MEDIUM-HIGH (hardware completely non-functional).

**Step 8.4:** Risk-benefit:
- BENEFIT: HIGH — enables an entire audio codec for users with this
  hardware
- RISK: VERY LOW — 1 line, identical pattern to existing entry, only
  affects CS47L47 hardware, zero regression risk for other devices
- Ratio: Excellent

Record: [HIGH benefit] [VERY LOW risk] [Excellent ratio]

## PHASE 9: FINAL SYNTHESIS

**Step 9.1: Evidence**
FOR backporting:
- Classic device ID addition (explicit stable exception category)
- Single line change, obviously correct
- Zero regression risk for existing devices
- From the device vendor (Cirrus Logic)
- Reviewed by SoundWire expert, applied by ASoC maintainer
- Enables hardware that is completely non-functional without it
- Applies cleanly to v7.0

AGAINST backporting:
- Not a bug fix per se (hardware enablement)
- Part of a 3-patch series (but standalone for basic support)

**Step 9.2: Stable Rules Checklist**
1. Obviously correct and tested? YES — trivial pattern match, reviewed,
   applied by maintainer
2. Fixes a real bug? N/A — device ID addition exception
3. Important issue? YES — hardware completely non-functional without it
4. Small and contained? YES — 1 line
5. No new features or APIs? Correct — no new features, just device
   recognition
6. Can apply to stable? YES — clean apply

**Step 9.3: Exception Category**
YES — this is a **NEW DEVICE ID** addition to an existing driver. This
is explicitly listed as an allowed exception for stable trees.

**Step 9.4: Decision**
This is a textbook device ID addition — a single `SDW_SLAVE_ENTRY` line
added to an existing driver's device table. It enables the CS47L47 audio
codec to be recognized by the kernel's SDCA class driver. The change is
trivially correct, carries zero regression risk, and falls into the
explicit "New Device IDs" exception category for stable.

## Verification

- [Phase 1] Parsed tags: Reviewed-by Pierre-Louis Bossart, Signed-off-by
  Mark Brown (maintainer)
- [Phase 2] Diff analysis: exactly 1 line added —
  `SDW_SLAVE_ENTRY(0x01FA, 0x4747, 0)` to device ID table
- [Phase 3] git blame: device ID table introduced in commit
  2d877d0659cb6 (v6.19), unchanged since
- [Phase 3] git log: only 3 commits to sdca_class.c, clean history
- [Phase 3] Author: Richard Fitzgerald is Cirrus Logic (device vendor)
  engineer, regular contributor
- [Phase 4] patchew.org: confirmed patch 3/3 of series, clean review, no
  NAKs
- [Phase 4] b4 dig: failed to find (commit not in local tree), used web
  search instead
- [Phase 4] lore: blocked by anti-scraping (Anubis), used patchew as
  fallback
- [Phase 5] No function logic changed — only data table addition
- [Phase 6] SDCA class driver exists in v7.0 (introduced v6.19), clean
  apply expected
- [Phase 6] Confirmed no 0x4747 or CS47L47 references exist in current
  tree
- [Phase 7] ASoC subsystem, IMPORTANT criticality
- [Phase 8] Benefit: HIGH (enables hardware); Risk: VERY LOW (1-line
  data-only change)
- UNVERIFIED: Could not read original lore discussion directly due to
  anti-scraping. Used patchew mirror instead, which showed no concerns.

**YES**

 sound/soc/sdca/sdca_class.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/sdca/sdca_class.c b/sound/soc/sdca/sdca_class.c
index 918b638acb577..55c33ff63ca21 100644
--- a/sound/soc/sdca/sdca_class.c
+++ b/sound/soc/sdca/sdca_class.c
@@ -317,6 +317,7 @@ static const struct dev_pm_ops class_pm_ops = {
 
 static const struct sdw_device_id class_sdw_id[] = {
 	SDW_SLAVE_ENTRY(0x01FA, 0x4245, 0),
+	SDW_SLAVE_ENTRY(0x01FA, 0x4747, 0),
 	{}
 };
 MODULE_DEVICE_TABLE(sdw, class_sdw_id);
-- 
2.53.0

