Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BCA95625F5;
	Mon, 31 Aug 2026 13:47:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184065; cv=none; b=onyGvV0Rina9EH+v88jW6qZVtK3hII3MR6FAxwGjbbZ4EJxM6Nw3glD0/zL3D6yw8oXMmV5nGlSQawmtGb9GL8Es6wgf/sKkTW8aYlgG7ouzAGOlXiQ58FLtJq8x66oEWFZ5QZ4E5PKyMJnhS07GzJqFcKSlOQK3nv1FG7+3NUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184065; c=relaxed/simple;
	bh=JMD6sGZhHL6lBOOQjCShGScd3RUleZiwNUPdv8eBN9A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KmUWyTDMZbF8vuJF3MKsI02TXEJJ99FWyW052om7zLnYkNkJMgwb5SmEg+1SO9BRN5JtZrF2d4wCBy1TsdDC6x1/TADSmeqC0gmR2N4c5emCmDcEZ+XGD1X7H9+30ETvvk/J7aCA9yeNVY4muV99NaUClkEu1v2hhhgJxHZXZcc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OGi9JfMm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OGi9JfMm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1974B1F000E9;
	Mon, 31 Aug 2026 13:47:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788184063;
	bh=oSSiWoblztQ1FgOSfBLo+kvwsJOlDHy87BsbKbClGDQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OGi9JfMmn73ol0XyE9iYmpfJMKoK7tOFDjpzbKcQAXyDkEHQzWBZK2gyqDWPWqBNi
	 SqGsui5u14RWAtxZP0Ls3P0XEyCxeOz3Qp068rWzFJuY58C6logF3thWAmwYip7VdK
	 3sDRqsZN0zHDeooJabrEw4+3Y8fNtmr+BhDGm80FikN6r3QKT/OmfnDOEP9tTjt5BM
	 7r0PdD74Kx45QKTHdz69X+Gecg4yrDRiyiPiR6HYAHd6AhsdqitHQmi1S1ZHq7PtyG
	 nFU4gwIzoZb5hkA5+qOU/9H3FTfDfq2nIa4b3cT4b7FGpE4Ap2x42cY3X2dw6HHQQq
	 CU0eHPr1ciWTQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Charles Keepax <ckeepax@opensource.cirrus.com>,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.dev>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	yung-chuan.liao@linux.intel.com,
	linux-sound@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.1] soundwire: dmi-quirks: Disable ghost Realtek devices
Date: Mon, 31 Aug 2026 09:28:17 -0400
Message-ID: <20260831133314.4125787-469-sashal@kernel.org>
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

From: Charles Keepax <ckeepax@opensource.cirrus.com>

[ Upstream commit 4dab2b904414fac53535c4e4cdad808132f4cdc2 ]

Many systems ship with a Realtek audio codec in the ACPI that doesn't
physically exist in the system. This confuses the newer function
topology system that creates the soundcard, as it builds the card based
on the ACPI information.

Whilst we are working with the laptop vendors to try and stop this
happening there are quite a few systems where this has shipped. Add a
quirk to disable this "ghost" device.

Currently this patch should cover:
 - Asus UX5406AA
 - Lenovo Yoga Pro 9i (83SF)
 - Lenovo Yoga Slim 7 Ultra (83QK)

Signed-off-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.dev>
Link: https://patch.msgid.link/20260520163631.3300102-4-ckeepax@opensource.cirrus.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit Message Forensics

### Step 1.1: Subject Line
**Record:** `[soundwire: dmi-quirks] [disable] Disable ghost Realtek
devices on ACPI — DMI quirk to suppress non-existent rt722 codec entries
reported by broken firmware.`

### Step 1.2: Tags
**Record:**
- **Reviewed-by:** Pierre-Louis Bossart `<pierre-
  louis.bossart@linux.dev>` (SoundWire maintainer)
- **Link:** https://patch.msgid.link/20260520163631.3300102-4-
  ckeepax@opensource.cirrus.com
- **Signed-off-by:** Charles Keepax, Vinod Koul (ignore pipeline-added
  SOBs)
- **No** Fixes:, Reported-by:, Cc: stable@vger.kernel.org, Tested-by:,
  Acked-by:
- **Notable:** Reviewed by subsystem maintainer; message-id suffix `-4-`
  indicates patch 4 of a series (series context could not be fully
  retrieved — see Phase 4)

### Step 1.3: Body Analysis
**Record:**
- **Bug:** ACPI DSDT lists a Realtek rt722 SoundWire codec (link 3, ADR
  `0x000330025d072201`) that is not physically present on the board.
- **Symptom:** The function-topology path builds the sound card from
  ACPI device lists, so the phantom codec confuses machine/topology
  selection and breaks audio initialization on affected laptops.
- **Affected systems:** ASUS UX5406AA, Lenovo Yoga Pro 9i (83SF), Lenovo
  Yoga Slim 7 Ultra (83QK) — Panther Lake (PTL) platforms.
- **Root cause:** Incorrect ACPI firmware tables shipped by OEMs; kernel
  has no way to know the device is phantom without a DMI-specific quirk.

### Step 1.4: Hidden Bug Fix?
**Record:** Yes — labeled as a quirk addition, but it fixes a real
hardware/firmware bug causing non-functional audio. Classic DMI quirk
pattern, same category as existing entries in `dmi-quirks.c`.

---

## Phase 2: Diff Analysis

### Step 2.1: Inventory
**Record:**
- **File:** `drivers/soundwire/dmi-quirks.c` only (+~45 lines, 0
  deletions of logic)
- **Functions modified:** None directly; adds `ghost_realtek[]` table
  and three `adr_remap_quirk_table[]` entries
- **Scope:** Single-file, surgical hardware quirk

### Step 2.2: Code Flow Change
**Record:**
- **Before:** ACPI-reported rt722 on link 3 (`0x000330025d072201`) is
  passed through `sdw_dmi_override_adr()` unchanged → `find_slave()` in
  `slave.c` registers it as a SoundWire slave → machine matching /
  function topology see a phantom codec.
- **After:** On matched DMI systems, that ADR is remapped to `0` →
  `find_slave()` hits `if (!addr) return false;` → phantom device is not
  enumerated → correct machine config and topology are selected.

### Step 2.3: Bug Mechanism
**Record:** **Hardware workaround / firmware quirk.** ACPI advertises a
device that does not exist. The existing `override_adr` + zero-address-
disable mechanism (in `slave.c` since commit `6558b667a7297`) is used to
filter it out before bus enumeration and machine-driver matching.

### Step 2.4: Fix Quality
**Record:** Obviously correct — follows the exact same `adr_remap` +
`dmi_system_id` pattern as all existing quirks in this file. Minimal
risk: only affects three explicitly matched DMI strings. Remapping to
zero is an established, intentional API (`if (!addr) return false` in
`find_slave()`).

---

## Phase 3: Git History Investigation

### Step 3.1: Blame
**Record:**
- `dmi-quirks.c` infrastructure introduced in `f6594cdfec4cd`
  (2021-03-22, v5.12 era)
- Zero-address disable in `slave.c` introduced in `6558b667a7297`
  (2021-03-02, "soundwire: add override addr ops")
- Buggy ACPI ghost devices are an OEM firmware issue, not introduced by
  a specific kernel commit; the *exposure* of the problem is tied to
  function topology (commit `2fbeff33381cf`, 2025-04-14) which is
  present in this tree

### Step 3.2: Fixes: Tag
**Record:** N/A — no Fixes: tag present.

### Step 3.3: Related File History
**Record:** Recent `dmi-quirks.c` commits in this tree are all similar
OEM quirk additions (HP Spectre, NUC M15, HP Omen 16, Dell SKU 0A3E,
Avell B.ON). This commit fits the established pattern. No prerequisite
refactoring commits identified.

### Step 3.4: Author Context
**Record:** Charles Keepax (Cirrus Logic) is an active SoundWire/ASoC
contributor with multiple commits in `drivers/soundwire/` and
`sound/soc/intel/`.

### Step 3.5: Dependencies
**Record:** Self-contained — only modifies `dmi-quirks.c`. Requires:
- `sdw_dmi_override_adr()` and `adr_remap` infrastructure ✓ (in tree
  since 2021)
- `if (!addr) return false` in `find_slave()` ✓ (in tree)
- PTL ACPI machine tables and function topology ✓ (in tree)
- Message-id suggests patch 4 of a series, but this hunk has no code
  dependency on other series patches (UNVERIFIED: could not retrieve
  full series cover letter)

---

## Phase 4: Mailing List and External Research

### Step 4.1–4.5
**Record:**
- `b4 dig -c` failed (commit not in local tree)
- lore.kernel.org and patch.msgid.link blocked (403/Anubis) — could not
  retrieve review thread
- **UNVERIFIED:** Whether reviewers explicitly nominated for stable;
  whether any NAKs exist; full series context beyond patch 4
- Link message-id `20260520163631.3300102-4` indicates this is patch 4;
  the diff itself is standalone (only `dmi-quirks.c`)

---

## Phase 5: Code Semantic Analysis

### Step 5.1: Key Functions
**Record:** `sdw_dmi_override_adr()` (existing), called from
`find_slave()` in `slave.c`; machine selection via
`snd_soc_acpi_sdw_link_slaves_found()` in `sound/soc/soc-acpi.c` and
`hda_sdw_machine_select()` in `sound/soc/sof/intel/hda.c`.

### Step 5.2: Callers
**Record:** `sdw_dmi_override_adr` registered as
`bus->ops->override_adr` in `drivers/soundwire/intel_auxdevice.c`.
Called during ACPI SoundWire slave enumeration (`sdw_acpi_find_one` →
`find_slave`). Affects every ACPI-reported SoundWire device on Intel
platforms at boot/probe time.

### Step 5.3: Callees
**Record:** `dmi_first_match()`, ADR comparison loop, returns remapped
(or original) address.

### Step 5.4: Reachability
**Record:** Triggered automatically at boot on matched DMI systems when
SoundWire ACPI enumeration runs — no userspace action required. Affects
SOF/SDW audio probe path on PTL laptops.

### Step 5.5: Similar Patterns
**Record:** All existing `adr_remap` entries in `dmi-quirks.c` remap
incorrect ADRs to correct ones. This is the first in-tree use of remap-
to-zero to *disable* a device, but `slave.c` explicitly supports that
semantics. The ghost ADR `0x000330025d072201` matches
`rt722_3_single_adr` in `soc-acpi-intel-ptl-match.c` (PTL rt722 on link
3).

---

## Phase 6: Cross-Reference Against Local Tree (v6.18.44)

### Step 6.1: Buggy Code Present?
**Record:** YES. Local tree is **v6.18.44** (`git describe HEAD`).
`drivers/soundwire/dmi-quirks.c` exists with full quirk infrastructure
but **without** `ghost_realtek` entries. PTL support (`soc-acpi-intel-
ptl-match.c`, `CONFIG_SND_SOC_SOF_INTEL_PTL`) and function topology
(`sof-function-topology-lib.c`, `get_function_tplg_files` callbacks) are
all present. The bug (phantom rt722 on link 3 confusing topology/machine
selection) can occur on affected hardware running this kernel.

### Step 6.2: Backport Complications
**Record:** Clean apply expected — file structure matches the diff
context exactly (190 lines currently; diff inserts before closing `};`
of quirk table). No conflicting recent changes to the insertion point.

### Step 6.3: Related Fixes Already Present?
**Record:** No — `git log --grep="ghost"` shows no matching fix in `dmi-
quirks.c`. No `ghost_realtek` or remap-to-zero quirk exists.

---

## Phase 7: Subsystem and Maintainer Context

### Step 7.1: Subsystem
**Record:** `drivers/soundwire/` + Intel SOF audio — **IMPORTANT**
(affects laptop audio on shipping PTL hardware; not core kernel, but
user-visible and blocking).

### Step 7.2: Activity
**Record:** Actively maintained — multiple quirk additions in 2024–2025;
PTL ACPI tables actively updated in this tree.

---

## Phase 8: Impact and Risk Assessment

### Step 8.1: Who Is Affected
**Record:** Users of three specific PTL laptop models (ASUS UX5406AA,
Lenovo 83QK, Lenovo 83SF) with `CONFIG_SND_SOC_SOF_INTEL_PTL` and
SoundWire audio. Not universal, but completely broken audio for those
users without the quirk.

### Step 8.2: Trigger Conditions
**Record:** Every boot on matched hardware — deterministic, not a race.
Unprivileged users cannot trigger it; it is a platform firmware issue at
probe time.

### Step 8.3: Failure Mode
**Record:** Audio card fails to initialize / wrong topology selected →
**no working audio**. Severity: **HIGH** (not kernel crash or data
corruption, but complete loss of primary audio functionality on affected
laptops).

### Step 8.4: Risk-Benefit
**Record:**
- **Benefit:** HIGH for affected laptop owners (restores audio)
- **Risk:** VERY LOW (DMI-gated, 45 lines, established pattern, reviewed
  by maintainer)
- **Ratio:** Strongly favors backport

---

## Phase 9: Final Synthesis

### Step 9.1: Evidence Summary

**FOR backport:**
- Real firmware bug on shipping laptops
- Hardware quirk exception (explicitly stable-appropriate)
- Small, self-contained, obviously correct
- Reviewed by SoundWire maintainer
- All prerequisites present in v6.18.44
- Uses existing, documented zero-ADR-disable mechanism
- Same file/pattern as prior stable-worthy SoundWire DMI quirks

**AGAINST backport:**
- Only three laptop models (narrow scope — normal for DMI quirks)
- Audio broken, not crash/security (still important for affected users)
- Patch 4 of a series (UNVERIFIED whether other patches needed — diff
  appears standalone)
- Could not verify mailing list stable nomination

**UNRESOLVED:**
- Full lore review thread inaccessible
- Whether patch series has dependencies (diff analysis suggests none)

### Step 9.2: Stable Rules Checklist
1. Obviously correct and tested? **PASS** — pattern proven by years of
   similar quirks; maintainer reviewed
2. Fixes a real bug? **PASS** — broken audio on real hardware
3. Important issue? **PASS** — complete audio failure on affected
   laptops (HIGH severity)
4. Small and contained? **PASS** — single file, ~45 lines
5. No new features/APIs? **PASS** — DMI quirk only, no API changes
6. Can apply to local tree? **PASS** — infrastructure exists; clean
   apply expected

### Step 9.3: Exception Category
**Record:** **Hardware quirk/workaround** — explicitly allowed for
stable.

### Step 9.4: Decision Rationale
For **v6.18.44**, PTL laptop support and function topology are both
present, and the phantom rt722 ADR (`0x000330025d072201`) is already
defined in `soc-acpi-intel-ptl-match.c`. Without this quirk, affected
ASUS and Lenovo PTL laptops get broken audio. The fix is minimal, DMI-
scoped, and follows a well-established pattern in the same file. This is
standard stable material for a hardware quirk.

---

## Verification

- **[Phase 1]** Parsed subject, tags, body from provided commit message
- **[Phase 2]** Analyzed provided diff; confirmed remap-to-zero
  semantics
- **[Phase 3]** `git describe HEAD` → v6.18.44
- **[Phase 3]** `git log -- drivers/soundwire/dmi-quirks.c` → quirk
  history back to 2021
- **[Phase 3]** `git show 6558b667a7297` → override_adr + zero-addr
  check introduced 2021
- **[Phase 3]** `git merge-base --is-ancestor 2fbeff33381cf HEAD` →
  function topology in tree
- **[Phase 3]** `git merge-base --is-ancestor f6594cdfec4cd HEAD` → dmi-
  quirks in tree
- **[Phase 4]** `b4 dig -c` → failed (commit not in tree)
- **[Phase 4]** lore.kernel.org / patch.msgid.link → blocked
  (403/Anubis) — **UNVERIFIED** review thread
- **[Phase 5]** Read `drivers/soundwire/slave.c:109-137` →
  `override_adr` then `if (!addr) return false`
- **[Phase 5]** Read `drivers/soundwire/intel_auxdevice.c:283` →
  `override_adr = sdw_dmi_override_adr`
- **[Phase 5]** Read `sound/soc/soc-acpi.c:132-200` → machine matching
  checks enumerated peripherals
- **[Phase 5]** Read `sound/soc/sof/intel/hda.c:1168-1207` → SDW machine
  selection uses `snd_soc_acpi_sdw_link_slaves_found`
- **[Phase 5]** Grep `0x000330025d072201` → matches `rt722_3_single_adr`
  in `soc-acpi-intel-ptl-match.c:382`
- **[Phase 6]** Read current `dmi-quirks.c` → no `ghost_realtek` present
  (fix not yet applied)
- **[Phase 6]** Confirmed `CONFIG_SND_SOC_SOF_INTEL_PTL` in
  `sound/soc/sof/intel/Kconfig`
- **[Phase 6]** Confirmed `get_function_tplg_files` used in PTL ACPI
  match table
- **[Phase 6]** `git log --grep="ghost"` on dmi-quirks → no existing fix

**YES**

 drivers/soundwire/dmi-quirks.c | 35 ++++++++++++++++++++++++++++++++++
 1 file changed, 35 insertions(+)

diff --git a/drivers/soundwire/dmi-quirks.c b/drivers/soundwire/dmi-quirks.c
index 5854218e1a274..32a46a2d90f7c 100644
--- a/drivers/soundwire/dmi-quirks.c
+++ b/drivers/soundwire/dmi-quirks.c
@@ -90,6 +90,19 @@ static const struct adr_remap intel_rooks_county[] = {
 	{}
 };
 
+/*
+ * Many platforms have ghost realtek devices in the ACPI that don't physically
+ * exist, remove those devices.
+ */
+static const struct adr_remap ghost_realtek[] = {
+	/* rt722 on link3 */
+	{
+		0x000330025d072201ull,
+		0x0000000000000000ull
+	},
+	{}
+};
+
 static const struct dmi_system_id adr_remap_quirk_table[] = {
 	/* TGL devices */
 	{
@@ -164,6 +177,28 @@ static const struct dmi_system_id adr_remap_quirk_table[] = {
 		},
 		.driver_data = (void *)hp_omen_16,
 	},
+	/* PTL devices */
+	{
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "ASUS"),
+			DMI_MATCH(DMI_BOARD_NAME, "UX5406AA"),
+		},
+		.driver_data = (void *)ghost_realtek,
+	},
+	{
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "83QK"),
+		},
+		.driver_data = (void *)ghost_realtek,
+	},
+	{
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "83SF"),
+		},
+		.driver_data = (void *)ghost_realtek,
+	},
 	{}
 };
 
-- 
2.53.0

