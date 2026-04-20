Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DE593BF667;
	Mon, 20 Apr 2026 13:26:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776691573; cv=none; b=Qb5hjzFz1r3ezJ2x9yJX58roTou4zhagpeIMNnU/vd8sjZ1LEhN3oYMVkVyaLWFlILfOSMVlavG5dWVUds6P6uWBxpGIkA3nnXDvIum/QP/i65zLukbozO3KI1T+nSVPg6FNe3FJu1tmLqBJ11OzchAs1fiubtICSNt0+sn/SHs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776691573; c=relaxed/simple;
	bh=vSLavixEUEuwgCzTDQQQmqZVD/P6u16k5TITO7ii3go=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bmmF4XrUr5p1cTkdZNC90elyroXMYCSA+nCnq+Ww5e/94A8iy4nt6mPWb7l2NIMKl5L8ajPuerDuR6RZBUBZKjGznFSxdBfefEVo0vpRGUPcBUbHnghtHQqOUH/9H4tylg7n2TWvS8LQD/+4FoMr8rrXu5Lw0Gm/1ODfeWl3Uyc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YF6tKH4x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YF6tKH4x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE2D4C19425;
	Mon, 20 Apr 2026 13:26:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776691573;
	bh=vSLavixEUEuwgCzTDQQQmqZVD/P6u16k5TITO7ii3go=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YF6tKH4x0BXhU0Ss5Qb+6oyUDToKjvZ4IaRvnKvejLPEMbR6nbmKJCTMvfiCB+ff2
	 3NVI9Z41Ome/CuHNxwLhUeZOl/IPjRKdIolbgO9bQkSUOKxdUIUyUIsrb42HYkhSv+
	 2aolkBzqKrVARSVnOzAv/lgur5aPmFVh2GkX0vwxnIb60xQbmhICeK6IB1U29Oldql
	 PIlkY5hrpWcqFA7juZ4wENnpp+1mzVn7w084UXFDrgq/AGj/wqUshOKbuym/2UAC8f
	 trpECLwjbOa6lNetqTuS78Krj5FIgjjnsJVgqYAR4JBrFVpn2uxx/XLwWmYFx2R0pi
	 i794zIo3i5WaQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Maciej Strozek <mstrozek@opensource.cirrus.com>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	lgirdwood@gmail.com,
	perex@perex.cz,
	tiwai@suse.com,
	linux-sound@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-6.19] ASoC: sdw_utils: Add CS42L43B codec info
Date: Mon, 20 Apr 2026 09:18:22 -0400
Message-ID: <20260420132314.1023554-108-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420132314.1023554-1-sashal@kernel.org>
References: <20260420132314.1023554-1-sashal@kernel.org>
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

From: Maciej Strozek <mstrozek@opensource.cirrus.com>

[ Upstream commit 3e314fde2304b328929c471a70906bc5968f9dcf ]

Add codec_info for a new variant of CS42L43. It can resue existing info
but needs a new part_id.

Signed-off-by: Maciej Strozek <mstrozek@opensource.cirrus.com>
Reviewed-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://patch.msgid.link/20260306152829.3130530-2-mstrozek@opensource.cirrus.com
Tested-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have a complete picture. Let me compile the full analysis.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1: Subject Line**
Record: [ASoC: sdw_utils] [Add] [CS42L43B codec info entry to
codec_info_list]

**Step 1.2: Tags**
- Signed-off-by: Maciej Strozek (Cirrus Logic engineer, author)
- Reviewed-by: Charles Keepax (Cirrus Logic, subsystem expert)
- Tested-by: Charles Keepax (verified the fix works)
- Link: patch.msgid.link for original submission
- Signed-off-by: Mark Brown (ASoC maintainer, applied the patch)

Record: Reviewed AND tested by Charles Keepax (Cirrus Logic), applied by
ASoC maintainer Mark Brown. No Fixes tag (expected). No syzbot.

**Step 1.3: Body Text**
The message says: "Add codec_info for a new variant of CS42L43. It can
reuse existing info but needs a new part_id." This is adding a device ID
(part_id = 0x2A3B) for a hardware variant of the existing CS42L43 codec.

Record: New hardware variant CS42L43B needs a new part_id entry. Reuses
existing callbacks and configuration.

**Step 1.4: Hidden Bug Fix Detection**
At face value this is a device ID addition, not a "hidden" bug fix.
However, as I'll show in Phase 6, the ACPI match tables referencing
CS42L43B are already in v7.0, making this missing entry cause audio
probe failure on affected systems.

Record: This is a device ID addition that also fixes a functional gap
(ACPI tables present but codec_info missing).

---

## PHASE 2: DIFF ANALYSIS

**Step 2.1: Inventory**
- Files changed: `sound/soc/sdw_utils/soc_sdw_utils.c`
- Lines added: ~54 lines (all data, no code logic)
- Lines removed: 0
- Functions modified: None; the change is within the `codec_info_list[]`
  static array initializer
- Scope: single-file, purely additive data entry

Record: 1 file, +54 lines of struct data, 0 removed, purely data.

**Step 2.2: Code Flow Change**
The diff adds a new `codec_info_list[]` entry with `.part_id = 0x2A3B`
between the existing CS42L43 entry (0x4243) and the CS42L45 entry
(0x4245). The new entry is structurally identical to the CS42L43 entry —
same name_prefix, same sidecar functions, same 4 DAIs with same
callbacks, same quirks. The only difference is `.part_id = 0x2A3B`.

Record: Before: no entry for 0x2A3B; After: new entry identical to
0x4243 but with part_id 0x2A3B.

**Step 2.3: Bug Mechanism**
This is category (h) — Hardware workaround / Device ID addition. The new
`part_id = 0x2A3B` is the SoundWire equivalent of a PCI/USB device ID,
enabling the CS42L43B hardware variant to be matched by
`asoc_sdw_find_codec_info_part()`.

Record: Device ID addition (new part_id for SoundWire codec variant).

**Step 2.4: Fix Quality**
- The data is an exact copy of the existing 0x4243 entry with only
  part_id changed
- All referenced callbacks (`asoc_sdw_cs42l43_hs_rtd_init`,
  `asoc_sdw_cs42l43_spk_init`, etc.) already exist
- No new code logic, no new functions, no API changes
- Regression risk: essentially zero (only affects systems with CS42L43B
  hardware)

Record: Trivially correct, minimal regression risk. Pure data addition.

---

## PHASE 3: GIT HISTORY

**Step 3.1: Blame**
The existing CS42L43 entry (0x4243) was introduced in commit
`e377c94773171e` by Vijendar Mukunda on 2024-08-01, when the
codec_info_list was moved from Intel SOF to common sdw_utils. This file
has been in the tree since v6.12.

Record: File created v6.12 (2024-08-01). CS42L43 entry (0x4243) has been
stable since then.

**Step 3.2: No Fixes tag** — expected, N/A.

**Step 3.3: File History**
Recent changes to this file are mostly additions of new codec entries
and minor fixes. The file is actively maintained as new codecs and
variants are added.

Record: Active file with frequent codec_info additions. No conflicts
expected.

**Step 3.4: Author Context**
Maciej Strozek is a Cirrus Logic engineer, a regular contributor to the
CS42L43/CS42L45 codec subsystem. He has ~10 recent commits in the sound
subsystem.

Record: Author is domain expert at Cirrus Logic, the vendor of this
codec.

**Step 3.5: Dependencies**
The critical dependency is the ACPI match entries for CS42L43B. These
exist in:
- `sound/soc/amd/acp/amd-acp70-acpi-match.c` (commit `ddd9bf2212ab8`,
  2026-01-27) — **already in v7.0**
- `sound/soc/amd/acp/amd-acp63-acpi-match.c` (commit `fd13fc700e3e2`,
  2026-02-24) — **already in v7.0**

Both ACPI match tables reference `0x00003101FA2A3B01ull` which encodes
part_id 0x2A3B. These are already in the stable tree. Without this
codec_info entry, the ACPI match succeeds but the codec configuration
lookup fails.

Record: Dependencies are MET — ACPI match tables for cs42l43b already in
v7.0.

---

## PHASE 4: MAILING LIST

**Step 4.1-4.5:**
b4 dig could not find the commit (likely the Message-ID format didn't
match expectations). Lore was protected by anti-scraping. However, the
commit itself documents the review chain: Reviewed-by and Tested-by from
Charles Keepax, applied by Mark Brown. This is the standard ASoC review
process.

Record: Could not fetch lore discussion due to anti-scraping protection.
The commit tags show proper review process.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1: Key Functions**
No functions are modified. The change is in the static
`codec_info_list[]` array.

**Step 5.2: Callers of `asoc_sdw_find_codec_info_part()`**
This function is called at two critical points:
- Line 1366: `asoc_sdw_count_sdw_endpoints()` — if it returns NULL,
  returns `-EINVAL`, causing the entire endpoint counting to fail
- Line 1526: the DAI link creation path — if it returns NULL, returns
  `-EINVAL`, causing the machine driver probe to fail

Record: Without a matching codec_info entry, the machine driver probe
fails with -EINVAL. Audio is completely non-functional on affected
systems.

**Step 5.3-5.5:** N/A — no new code logic to trace.

---

## PHASE 6: STABLE TREE ANALYSIS

**Step 6.1: Buggy Code in Stable Trees**
The `codec_info_list[]` array exists in v7.0 (file created in v6.12).
The ACPI match tables for cs42l43b are already in v7.0 (`ddd9bf2212ab8`
and `fd13fc700e3e2` both verified as ancestors of v7.0). This means v7.0
stable already has systems defined that use CS42L43B hardware, but the
codec_info entry for part_id 0x2A3B is MISSING.

Record: The gap exists in v7.0 — ACPI tables reference CS42L43B but
codec_info_list lacks the entry.

**Step 6.2: Backport Complications**
The patch is purely additive data into a well-defined array. It should
apply cleanly.

Record: Clean apply expected.

**Step 6.3:** No prior fix for this issue.

---

## PHASE 7: SUBSYSTEM CONTEXT

**Step 7.1:** ASoC / SoundWire machine driver support — IMPORTANT
subsystem. Audio is a core user-facing feature.
**Step 7.2:** Actively maintained with frequent additions.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1: Who is Affected**
Users with AMD ACP63 or ACP70 platforms that have CS42L43B audio codec
hardware. These are real laptop configurations defined in the ACPI match
tables already in v7.0.

**Step 8.2: Trigger Conditions**
Boot any system with CS42L43B hardware → audio subsystem probes → ACPI
match succeeds → codec_info lookup fails → `-EINVAL` → no audio. This is
100% reproducible on affected hardware.

**Step 8.3: Failure Mode**
Machine driver probe failure (returns -EINVAL). Complete audio loss on
affected systems. Severity: **HIGH** — audio is a fundamental feature.

**Step 8.4: Risk-Benefit**
- Benefit: HIGH — enables audio on affected hardware; fixes complete
  functional failure
- Risk: VERY LOW — purely additive data, identical to existing proven
  entry, only part_id differs
- Ratio: Strongly favorable

---

## PHASE 9: FINAL SYNTHESIS

**Evidence FOR backporting:**
- Device ID addition to existing driver (explicit stable exception)
- ACPI match tables referencing this hardware are ALREADY in v7.0
- Without this, audio probe fails with -EINVAL on affected systems
- Purely data — no new code paths, no new logic
- Exact copy of existing, proven CS42L43 entry with only part_id changed
- Reviewed AND tested by Cirrus Logic domain expert
- Applied by ASoC maintainer Mark Brown
- Zero regression risk (only affects cs42l43b hardware)

**Evidence AGAINST backporting:**
- No explicit Fixes: tag or Cc: stable (expected for autosel candidates)
- 54 lines rather than single-line ID addition (but all data, no code)
- Commit message doesn't describe a "bug" — describes hardware
  enablement

**Stable Rules Checklist:**
1. Obviously correct and tested? **YES** — exact copy of existing entry,
   tested by reviewer
2. Fixes a real bug? **YES** — audio probe failure on hardware already
   matched by ACPI tables in v7.0
3. Important? **YES** — complete audio loss
4. Small and contained? **YES** — 54 lines of data in one file
5. No new features or APIs? **YES** — just a device ID
6. Can apply to stable? **YES** — clean apply expected

**Exception Category:** Device ID addition to existing driver.

---

## Verification

- [Phase 1] Parsed tags: Reviewed-by + Tested-by from Charles Keepax
  (Cirrus), applied by Mark Brown (ASoC maintainer)
- [Phase 2] Diff analysis: +54 lines, all struct data, new
  `codec_info_list[]` entry with `.part_id = 0x2A3B`, identical to
  existing 0x4243 entry
- [Phase 3] git blame: CS42L43 entry (0x4243) introduced in
  e377c94773171e (v6.12, 2024-08-01), present in v7.0
- [Phase 3] git merge-base: ddd9bf2212ab8 (ACP70 cs42l43b ACPI match) IS
  ancestor of v7.0 — confirmed
- [Phase 3] git merge-base: fd13fc700e3e2 (ACP63 cs42l43b ACPI match) IS
  ancestor of v7.0 — confirmed
- [Phase 4] b4 dig failed to find match; lore anti-scraping blocked web
  fetch
- [Phase 5] Verified call sites: `asoc_sdw_find_codec_info_part()`
  returns NULL for unknown part_id → callers return -EINVAL → probe
  failure
- [Phase 5] Read lines 1366-1368 and 1526-1528: confirmed NULL → -EINVAL
  return path
- [Phase 6] ACPI match tables reference `0x00003101FA2A3B01ull` (part_id
  0x2A3B) already in v7.0
- [Phase 6] codec_info_list lacks 0x2A3B entry in v7.0 — confirmed via
  grep
- [Phase 8] Failure mode: probe returns -EINVAL → complete audio loss on
  cs42l43b systems, severity HIGH

The ACPI match tables already in v7.0 promise CS42L43B support, but
without this codec_info entry, the machine driver probe fails. This is a
device ID addition that fixes complete audio failure on affected AMD
laptop platforms.

**YES**

 sound/soc/sdw_utils/soc_sdw_utils.c | 54 +++++++++++++++++++++++++++++
 1 file changed, 54 insertions(+)

diff --git a/sound/soc/sdw_utils/soc_sdw_utils.c b/sound/soc/sdw_utils/soc_sdw_utils.c
index 0e67d9f34cba3..4f9089b2a9f84 100644
--- a/sound/soc/sdw_utils/soc_sdw_utils.c
+++ b/sound/soc/sdw_utils/soc_sdw_utils.c
@@ -723,6 +723,60 @@ struct asoc_sdw_codec_info codec_info_list[] = {
 		},
 		.dai_num = 4,
 	},
+	{
+		.part_id = 0x2A3B,
+		.name_prefix = "cs42l43",
+		.count_sidecar = asoc_sdw_bridge_cs35l56_count_sidecar,
+		.add_sidecar = asoc_sdw_bridge_cs35l56_add_sidecar,
+		.dais = {
+			{
+				.direction = {true, false},
+				.codec_name = "cs42l43-codec",
+				.dai_name = "cs42l43-dp5",
+				.dai_type = SOC_SDW_DAI_TYPE_JACK,
+				.dailink = {SOC_SDW_JACK_OUT_DAI_ID, SOC_SDW_UNUSED_DAI_ID},
+				.rtd_init = asoc_sdw_cs42l43_hs_rtd_init,
+				.controls = generic_jack_controls,
+				.num_controls = ARRAY_SIZE(generic_jack_controls),
+				.widgets = generic_jack_widgets,
+				.num_widgets = ARRAY_SIZE(generic_jack_widgets),
+			},
+			{
+				.direction = {false, true},
+				.codec_name = "cs42l43-codec",
+				.dai_name = "cs42l43-dp1",
+				.dai_type = SOC_SDW_DAI_TYPE_MIC,
+				.dailink = {SOC_SDW_UNUSED_DAI_ID, SOC_SDW_DMIC_DAI_ID},
+				.rtd_init = asoc_sdw_cs42l43_dmic_rtd_init,
+				.widgets = generic_dmic_widgets,
+				.num_widgets = ARRAY_SIZE(generic_dmic_widgets),
+				.quirk = SOC_SDW_CODEC_MIC,
+				.quirk_exclude = true,
+			},
+			{
+				.direction = {false, true},
+				.codec_name = "cs42l43-codec",
+				.dai_name = "cs42l43-dp2",
+				.dai_type = SOC_SDW_DAI_TYPE_JACK,
+				.dailink = {SOC_SDW_UNUSED_DAI_ID, SOC_SDW_JACK_IN_DAI_ID},
+			},
+			{
+				.direction = {true, false},
+				.codec_name = "cs42l43-codec",
+				.dai_name = "cs42l43-dp6",
+				.dai_type = SOC_SDW_DAI_TYPE_AMP,
+				.dailink = {SOC_SDW_AMP_OUT_DAI_ID, SOC_SDW_UNUSED_DAI_ID},
+				.init = asoc_sdw_cs42l43_spk_init,
+				.rtd_init = asoc_sdw_cs42l43_spk_rtd_init,
+				.controls = generic_spk_controls,
+				.num_controls = ARRAY_SIZE(generic_spk_controls),
+				.widgets = generic_spk_widgets,
+				.num_widgets = ARRAY_SIZE(generic_spk_widgets),
+				.quirk = SOC_SDW_CODEC_SPKR | SOC_SDW_SIDECAR_AMPS,
+			},
+		},
+		.dai_num = 4,
+	},
 	{
 		.part_id = 0x4245,
 		.name_prefix = "cs42l45",
-- 
2.53.0

