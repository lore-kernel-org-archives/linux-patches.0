Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FED0555C0D;
	Mon, 31 Aug 2026 13:47:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184025; cv=none; b=cXj6JAr1xKuNBvQHcaCBxnqr7JRrpK2xTAOSW08RJIBcw19Zqfnz+ht15IDFThQ/0Dur8EA4eKat1vSaZ04yo2ktyv5ZkKbifnXbvrGIRDuw7g/3IM8kCMwUVEM1zZFEAAbLjrpqaSw3k7vu4ywHG0o0Ac/JtFD87FQR95lsS3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184025; c=relaxed/simple;
	bh=f7as2J5ha+rh2KMEDaJOJFTJSZpLbsVAhziGPu44PFs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VE1hPYvWAb9TTiEiRIOyYnmQcIV1FRsOZVEyIO2GWWd4f8/2Fa2bNXI1oc3kwNnKZfrfrkfoVh10Jj/9Fr/mtUGR+tXP5FufGdD6/V9S2gupSH1PYNl/3K2Vjxc8Ov+K7XvZk6m/4B4lJM19R5vSqau5ogxSG0JiQpyziT057L8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iGcJK4sV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iGcJK4sV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E26831F000E9;
	Mon, 31 Aug 2026 13:47:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788184022;
	bh=/T4cX/SYuVx3IVIoOuCrfO08y6KbwPPsNAxZ6k+R63k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iGcJK4sVarjLiEe7r8O+FSyYKxKBQGQ+7OiMytmcfpZv4i1g3afADfYHsurUmkF/H
	 oazUGTwwJgaZOMs4y91BkqX1C5y4zxF7M0fgMnLZo2x8J/ZeKbpadtofcjF4Quo82N
	 RsaBXJzeruXj6q6OwP2d5r+GNeDmsvJoePgIZXvQXQfMy5FKJg0dvLV+dAG1qWCAuD
	 IPRDs9MBSAGnMRx6IWxEo1FeJSNVNxjJKVTrRZPwxy1bbAVzZS7ib/bWjhsH1VdQlR
	 rPzc34mll168Mkd1jVst35wvRmzun8tCsv+cC+PIVKzKmcomB8pkAGtgyFHzCs0UBi
	 emi+JftM3RKHw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Lin Xianglin <1021538027@qq.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	Vijendar.Mukunda@amd.com,
	lgirdwood@gmail.com,
	perex@perex.cz,
	tiwai@suse.com,
	linux-sound@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.6] ASoC: amd: yc: Add DMI quirk for HyperX OMEN Gaming Laptop 16-ap1xxx
Date: Mon, 31 Aug 2026 09:27:51 -0400
Message-ID: <20260831133314.4125787-443-sashal@kernel.org>
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

From: Lin Xianglin <1021538027@qq.com>

[ Upstream commit fe21db8c5e7c2a9815a9be54a1f5d556f905506e ]

The HyperX OMEN Gaming Laptop 16-ap1xxx (HP board 8F06) has an
internal digital microphone array attached to the AMD ACP PDM
controller, but the acp6x machine driver does not register the DMIC
sound card because this board is missing from the DMI quirk table,
leaving the internal microphone unusable.

Add a DMI quirk entry for the HP board "8F06" so the acp6x DMIC
capture card gets registered.

Signed-off-by: Lin Xianglin <1021538027@qq.com>
Link: https://patch.msgid.link/tencent_428392223C2AD3BF23E7ABAA7521FE5C0C07@qq.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit Message Forensics

### Step 1.1: Subject Line
**Record:** `[ASoC: amd: yc]` `[Add]` — Add DMI quirk for HyperX OMEN
Gaming Laptop 16-ap1xxx (HP board 8F06) to enable internal DMIC on AMD
ACP6x.

### Step 1.2: Commit Message Tags
**Record:**
- **Signed-off-by:** Lin Xianglin \<1021538027@qq.com\> (author)
- **Link:** https://patch.msgid.link/tencent_428392223C2AD3BF23E7ABAA752
  1FE5C0C07@qq.com
- **Signed-off-by:** Mark Brown \<broonie@kernel.org\> (subsystem
  maintainer merge)
- No Fixes:, Reported-by:, Tested-by:, Reviewed-by:, Acked-by:, or Cc:
  stable@vger.kernel.org
- Notable: maintainer Signed-off-by; no syzbot or multi-reporter tags

### Step 1.3: Commit Body Analysis
**Record:**
- **Bug:** HyperX OMEN Gaming Laptop 16-ap1xxx (HP board `8F06`) has an
  internal DMIC on AMD ACP PDM, but `acp6x` machine driver does not
  register the DMIC sound card because the board is missing from
  `yc_acp_quirk_table`.
- **Symptom:** Internal microphone unusable (no DMIC capture card
  registered).
- **Root cause:** Missing DMI quirk entry; ACPI/`_WOV` path alone does
  not enable registration on this board.
- **Fix:** Add `DMI_MATCH(DMI_BOARD_VENDOR, "HP")` +
  `DMI_MATCH(DMI_BOARD_NAME, "8F06")` with `driver_data = &acp6x_card`.
- **Version info:** None in message; upstream commit `fe21db8c5e7c`
  merged to broonie/sound `for-7.2` (Linux 7.2).

### Step 1.4: Hidden Bug Fix Detection
**Record:** Yes — despite “Add” wording, this is a hardware-enablement
bug fix. Same pattern as prior HP/Lenovo/ASUS DMI quirk commits in this
driver (e.g. `65aabf8896687` for OMEN 16-ap0xxx already in this tree).

---

## Phase 2: Diff Analysis

### Step 2.1: Change Inventory
**Record:**
- **Files:** `sound/soc/amd/yc/acp6x-mach.c` only (+7 lines, 0 removed)
- **Functions modified:** None; only `yc_acp_quirk_table[]` static data
- **Scope:** Single-file surgical hardware-quirk addition

### Step 2.2: Code Flow Change
**Record:**
- **Before:** On HP board `8F06`, `dmi_first_match(yc_acp_quirk_table)`
  returns NULL at `check_dmi_entry`; if ACPI `AcpDmicConnected`/`_WOV`
  also fail, `platform_get_drvdata()` is NULL → `acp6x_probe()` returns
  `-ENODEV` → no DMIC card.
- **After:** DMI match sets `platform_set_drvdata(pdev, &acp6x_card)` →
  `devm_snd_soc_register_card()` registers DMIC capture card.
- **Path affected:** Platform driver probe during boot (`acp6x_probe`).

### Step 2.3: Bug Mechanism
**Record:**
- **Category:** Hardware workaround / quirk (missing board ID in DMI
  table)
- **Mechanism:** ACPI does not reliably expose DMIC config on this HP
  board; existing DMI override path in `acp6x_probe()` was never
  triggered because `8F06` was absent from the table.

### Step 2.4: Fix Quality
**Record:**
- Obviously correct: identical to dozens of existing entries in the same
  table.
- Minimal: 7 lines, no logic changes.
- Regression risk: very low — only affects systems matching HP vendor +
  board name `8F06`.
- No API, locking, or structural changes.

---

## Phase 3: Git History Investigation

### Step 3.1: Blame / Bug Introduction
**Record:**
- `yc_acp_quirk_table` and `acp6x_probe()` DMI override path exist since
  `fa991481b8b22` (Oct 2021, “ASoC: amd: add YC machine driver using
  dmic”).
- Neighboring HP board entries: `8BD6` (b3a51137607cee, Mar 2024),
  `8EE4` (78783e8d588cf), `8E35` (65aabf8896687, backported to this tree
  May 2026).
- Bug is not a regression — it is a missing quirk for hardware never
  previously listed.

### Step 3.2: Fixes: Tag
**Record:** N/A — no Fixes: tag present.

### Step 3.3: Related File History
**Record:** This file has extensive recent quirk activity in v6.18.44
(20+ quirk commits). Direct precedent: `65aabf8896687` — “Add HP OMEN
Gaming Laptop 16-ap0xxx product line in quirk table” — already
backported to this tree with `Cc: stable@vger.kernel.org`. Same
subsystem, same failure mode (internal mic not detected), same fix
pattern.

### Step 3.4: Author Context
**Record:** Lin Xianglin — no prior commits in `sound/soc/amd/yc/` in
this tree. Mark Brown (maintainer) merged upstream.

### Step 3.5: Dependencies
**Record:** No dependencies. Standalone table entry. Applies cleanly
after `8E35` in local tree (`git apply --check` succeeded with 1-line
offset). Upstream context includes `Victus by HP Laptop 16-e1xxx` after
`8F06`; that entry is not in v6.18.44, but the `8F06` hunk is
independent.

---

## Phase 4: Mailing List and External Research

### Step 4.1: Original Patch Discussion
**Record:**
- **b4 dig -c fe21db8c5e7c:** https://patch.msgid.link/tencent_428392223
  C2AD3BF23E7ABAA7521FE5C0C07@qq.com
- **Series revisions:** v1 only (committed version is latest)
- **Review:** Mark Brown replied “Applied to …/broonie/sound.git
  for-7.2. Thanks!” — no NAKs
- **Stable nomination:** None in thread (expected; absence is not
  negative)

### Step 4.2: Reviewers
**Record (b4 dig -w):** CC'd: `linux-sound@vger.kernel.org`, `alsa-
devel@alsa-project.org`, `Vijendar.Mukunda@amd.com`,
`venkataprasad.potturu@amd.com`, `broonie@kernel.org`.

### Step 4.3: Bug Report
**Record:** No external bug report or syzbot link. Hardware-specific
user-facing issue described in commit message. Phoronix notes the quirk
enables internal mic on HyperX OMEN 16-ap1xxx for Linux 7.2.

### Step 4.4: Related Patches
**Record:** Sister fix `d63c219b7ff3` / stable backport `65aabf8896687`
for OMEN 16-ap0xxx (same product line, same mic issue). Mainline also
has `38417f5fc8e3` for Victus 16-e1xxx — not required for this fix.

### Step 4.5: Stable List History
**Record:** No stable-list discussion found for this specific patch.
Sister OMEN ap0xxx patch was explicitly nominated `Cc: stable` and
backported to 6.18.y.

---

## Phase 5: Code Semantic Analysis

### Step 5.1: Key Functions
**Record:** `yc_acp_quirk_table[]` (data), `acp6x_probe()` (consumer at
line 798).

### Step 5.2: Callers
**Record:** `acp6x_probe` registered as `.probe` in `acp6x_mach_driver`,
loaded via `module_platform_driver()`. Platform device `acp_yc_mach`
created from `pci-acp6x.c` during ACP6x PCI probe — runs at boot on AMD
Yellow Carp laptops with `CONFIG_SND_SOC_AMD_YC_MACH`.

### Step 5.3: Callees
**Record:** `dmi_first_match()`, `platform_set_drvdata()`,
`platform_get_drvdata()`, `devm_snd_soc_register_card()`.

### Step 5.4: Reachability
**Record:** Triggered automatically at boot on matching HP hardware. Not
userspace-triggerable, but affects every boot for affected laptop
owners. Unprivileged users cannot trigger the bug path — they simply
lack a working internal mic.

### Step 5.5: Similar Patterns
**Record:** Same file contains 80+ DMI quirk entries for identical DMIC-
enablement purpose. This tree already backports these routinely.

---

## Phase 6: Cross-Reference Against Local Tree (v6.18.44)

### Step 6.1: Buggy Code Present?
**Record:** Yes. `sound/soc/amd/yc/acp6x-mach.c` exists;
`yc_acp_quirk_table` has `8E35` but not `8F06` (confirmed via grep).
Upstream master has `8F06` at line 738; local tree does not. Bug affects
owners of this laptop running v6.18.44.

### Step 6.2: Backport Complications
**Record:** Clean apply — `git apply --check` succeeded inserting entry
after `8E35`. Minor context difference from upstream (no `Victus
16-e1xxx` entry in this tree) does not block application.

### Step 6.3: Related Fixes Already Present?
**Record:** `65aabf8896687` (OMEN 16-ap0xxx + board `8E35`) already in
tree. No fix for `8F06` / 16-ap1xxx present.

---

## Phase 7: Subsystem Context

### Step 7.1: Subsystem and Criticality
**Record:** `sound/soc/amd/yc` — ASoC AMD Yellow Carp audio.
**IMPORTANT** (laptop audio/DMIC), not core kernel, but affects real
hardware users.

### Step 7.2: Subsystem Activity
**Record:** Highly active — 20+ quirk commits in recent history of this
file in v6.18.44 alone.

---

## Phase 8: Impact and Risk Assessment

### Step 8.1: Who Is Affected
**Record:** Owners of HyperX OMEN Gaming Laptop 16-ap1xxx (HP board
`8F06`) with `CONFIG_SND_SOC_AMD_ACP6x` / `CONFIG_SND_SOC_AMD_YC_MACH`
enabled (typical on AMD laptop kernels).

### Step 8.2: Trigger Conditions
**Record:** Every boot on matching hardware where ACPI does not enable
DMIC. Common/likely for this specific board. Not security-relevant; not
unprivileged-triggerable.

### Step 8.3: Failure Mode Severity
**Record:** Internal microphone completely nonfunctional — **MEDIUM**
severity (functional hardware loss, no crash/corruption/security
impact).

### Step 8.4: Risk-Benefit
**Record:**
- **Benefit:** Restores internal mic on a real, shipping laptop model;
  identical to already-accepted stable quirk pattern.
- **Risk:** Very low — 7-line table entry, board-specific match only.
- **Ratio:** Strong benefit, negligible risk. Matches established stable
  practice for this driver.

---

## Phase 9: Final Synthesis

### Step 9.1: Evidence Summary

**FOR backport:**
- Fixes real hardware bug (internal mic unusable)
- Hardware quirk exception category — explicitly stable-worthy
- Tiny, obviously correct, standalone
- Applies cleanly to v6.18.44
- Driver and quirk infrastructure present since 2021
- Sister OMEN ap0xxx fix already backported to this exact tree
- Maintainer (Mark Brown) merged upstream
- No dependencies or prerequisites

**AGAINST backport:**
- Not a crash, security, corruption, or deadlock issue (lower urgency
  than KASAN fixes)
- No Tested-by or explicit Cc: stable in submission
- Laptop may be relatively new, but users on 6.18.y exist

**Unresolved:** No Tested-by tag; no explicit stable nomination for this
specific patch (sister patch had one).

### Step 9.2: Stable Rules Checklist
1. Obviously correct and tested? **PASS** — pattern proven by many
   identical quirks; no Tested-by but maintainer merged.
2. Fixes real bug affecting users? **PASS** — internal mic nonfunctional
   on specific laptop.
3. Important issue? **PASS (moderate)** — functional hardware loss;
   hardware-quirk exception applies strongly.
4. Small and contained? **PASS** — 7 lines, one file, table entry only.
5. No new features or APIs? **PASS** — extends existing quirk table
   only.
6. Can apply to local tree? **PASS** — verified with `git apply
   --check`.

### Step 9.3: Exception Category
**Record:** Hardware quirk/workaround — automatic stable qualification
per stable-kernel-rules exceptions.

### Step 9.4: Decision Rationale
For **v6.18.44**, this commit should be backported. The ACP6x YC machine
driver and DMI quirk mechanism are fully present; the only gap is the
missing `8F06` entry. The fix is identical in nature to `65aabf8896687`,
which stable maintainers already accepted for the closely related OMEN
16-ap0xxx. Risk is negligible; benefit is restoring internal microphone
functionality for affected laptop owners.

---

## Verification

- **[Phase 1]** Parsed commit message tags from user query and upstream
  `fe21db8c5e7c` via GitHub API
- **[Phase 1]** Confirmed no Fixes:/Reported-by:/Cc: stable tags
- **[Phase 2]** Diff analysis: +7 lines to `yc_acp_quirk_table[]` in
  `acp6x-mach.c`
- **[Phase 2]** Read `acp6x_probe()` lines 758–816: confirmed DMI
  override → card registration flow
- **[Phase 3]** `git describe HEAD`: v6.18.44; Makefile VERSION=6
  PATCHLEVEL=18 SUBLEVEL=44
- **[Phase 3]** `git blame` lines 650–677: neighboring HP quirk entries
  and dates
- **[Phase 3]** `git log --oneline -30 --
  sound/soc/amd/yc/acp6x-mach.c`: extensive quirk history;
  `65aabf8896687` sister fix present
- **[Phase 3]** `git show 65aabf8896687`: OMEN ap0xxx fix with Cc:
  stable, backported to this tree
- **[Phase 3]** `git log --diff-filter=A`: file added `fa991481b8b22`
  (2021)
- **[Phase 3]** `git log -S'8F06'`: no results — commit not yet in tree
- **[Phase 4]** `b4 dig -c fe21db8c5e7c`: found lore thread
- **[Phase 4]** `b4 dig -c fe21db8c5e7c -a`: v1 only, no later revisions
- **[Phase 4]** `b4 dig -c fe21db8c5e7c -w`: maintainers and AMD
  developers CC'd
- **[Phase 4]** `b4 dig -c fe21db8c5e7c -m /tmp/ap1xxx.mbox`: Mark Brown
  “Applied to for-7.2”, no NAKs
- **[Phase 4]** GitHub API: upstream commit `fe21db8c5e7c` message
  confirmed
- **[Phase 4]** Mainline raw file curl: `8F06` present at line 738 in
  torvalds/linux master
- **[Phase 5]** `grep acp6x_probe`: probe registered in
  `acp6x_mach_driver`, platform device from `pci-acp6x.c:238`
- **[Phase 6]** `grep 8F06` in local tree: not found
- **[Phase 6]** `grep 8E35` in local tree: present at line 668
- **[Phase 6]** `git apply --check`: patch applies cleanly after `8E35`
  (offset 1 line)
- **[Phase 6]** `grep 'Victus by HP Laptop 16-e1xxx'`: not in local tree
  (upstream-only context; not a blocker)
- **[Phase 7]** Kconfig: `CONFIG_SND_SOC_AMD_YC_MACH` depends on
  `CONFIG_SND_SOC_AMD_ACP6x` — present in tree
- **[Phase 8]** Failure mode assessed as nonfunctional internal mic
  (MEDIUM), not crash/security

**YES****Verdict: YES** — backport to this tree (v6.18.44).

This is a small hardware quirk fix: add HP board `8F06` to
`yc_acp_quirk_table` so the internal DMIC works on the HyperX OMEN
Gaming Laptop 16-ap1xxx. Same pattern as the OMEN 16-ap0xxx quirk
already in this tree (`65aabf8896687`). The patch applies cleanly (+7
lines after the `8E35` entry); upstream is `fe21db8c5e7c`, merged by
Mark Brown.The author/product search finished: **Lin Xianglin** has no
prior commits under `sound/soc/amd/yc/` in this tree, and **`16-ap1xxx`
/ `8F06` are not present** locally. That matches the earlier finding —
the fix is upstream-only (`fe21db8c5e7c`) and still needs backporting to
v6.18.44.The Victus check confirms **`Victus by HP Laptop 16-e1xxx` is
not in v6.18.44** — that entry exists only on mainline, after `8F06`. It
doesn't block the backport: the `8F06` hunk still applies cleanly right
after the existing `8E35` entry.

 sound/soc/amd/yc/acp6x-mach.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/sound/soc/amd/yc/acp6x-mach.c b/sound/soc/amd/yc/acp6x-mach.c
index 636b211856e7d..82a150c51eaca 100644
--- a/sound/soc/amd/yc/acp6x-mach.c
+++ b/sound/soc/amd/yc/acp6x-mach.c
@@ -675,6 +675,13 @@ static const struct dmi_system_id yc_acp_quirk_table[] = {
 			DMI_MATCH(DMI_BOARD_NAME, "8E35"),
 		}
 	},
+	{
+		.driver_data = &acp6x_card,
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "HP"),
+			DMI_MATCH(DMI_BOARD_NAME, "8F06"),
+		}
+	},
 	{
 		.driver_data = &acp6x_card,
 		.matches = {
-- 
2.53.0

