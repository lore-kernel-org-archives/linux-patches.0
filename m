Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6FEC47605F;
	Mon, 31 Aug 2026 13:35:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183338; cv=none; b=uFG1JBVy0VfYmutnA511N3ideD0o82L8o31MXOSVrCE/sHPrcICwujNEhuYmufZClkF/voq/QW1ApBCaV0764WpFu/1yDvOA00ovjOxc/U3QkcCOQ64bckmNAptbBwc40AWKjPo1uCjqsiitguhYZ6JkunzYJ/2oc7mLmYzYGo8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183338; c=relaxed/simple;
	bh=z/q8QMbgimzJ8DdJc4UIkPKJOi4a/1wTS9yJfPc881w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Jqv/4wT16RNsDuBhOcTISfLqMkPE+d2GQdBIkzlclfTqyq0F83viYhO0VgcVHmOj2mCUqkMSGgAPs0Vp1zBbx4NljOk5DxdJ2txYF1rkot5czA1TxYWVoDCqgUd5v4fW0EKwaHmN3Rv+I3jEUV6pSBZO2IKzNRSEyQyz7O40YIA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ahai/8k1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ahai/8k1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75F851F000E9;
	Mon, 31 Aug 2026 13:35:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183335;
	bh=Q1t7adITbd9K62Sw4i0sIOi7F0jillbwNrJTFaehe3c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ahai/8k1M0Zch7yHj2wXsC8UToI56wd1ztr4t96bnxvb3sSnUGDhI7IEEYxRcqdaA
	 zDkuWfyAKQdOgKRPFKyLfOwNe3VYej6mGLwxYz4pHzJRr4YaGsqoOgfGpjIMazceJT
	 oDNe7R+trovSZU3+rrueP6qfEg05kfvI53jTHpK55tzVpMWlJoadrvvj6j/X/9TmUp
	 wE/9qA0bssuWK95+ieP9Bl7dXdlUUbBl8Sp2C+pWzSqy5xzDCf4crAfd9/TwqJofj6
	 /xlMqPCOc3Tb/wrrpiQVNVI2aupERc7w+c9Hh1kKveD32ytF0XqbZw/N5XWSNb0BKu
	 l9n4clVgOnu5w==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: yahia ahmed <yahia.a.abdrabou@gmail.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>,
	hansg@kernel.org,
	platform-driver-x86@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] platform/x86: hp-wmi: Add thermal support for board 8B2F
Date: Mon, 31 Aug 2026 09:21:55 -0400
Message-ID: <20260831133314.4125787-87-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260831133314.4125787-1-sashal@kernel.org>
References: <20260831133314.4125787-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.48
Content-Transfer-Encoding: 8bit

From: yahia ahmed <yahia.a.abdrabou@gmail.com>

[ Upstream commit abefbbfc71f5ee50f9e549a2d143f23694d65fc2 ]

Added thermal support for board ID 8B2F.

Signed-off-by: yahia ahmed <yahia.a.abdrabou@gmail.com>
Link: https://patch.msgid.link/20260522203418.28784-1-yahia.a.abdrabou@gmail.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit Message Forensics

### Step 1.1: Parse the Subject Line
**Record:** `[platform/x86: hp-wmi]` `[Add]` — Add thermal support for
HP WMI board ID `8B2F` in the existing Victus S thermal-profile DMI
table.

### Step 1.2: Parse All Commit Message Tags
**Record:**
- **Fixes:** — none
- **Reported-by:** — none
- **Tested-by:** — none
- **Reviewed-by:** Ilpo Järvinen `<ilpo.jarvinen@linux.intel.com>`
  (platform/x86 maintainer)
- **Acked-by:** — none
- **Link:** https://patch.msgid.link/20260522203418.28784-1-
  yahia.a.abdrabou@gmail.com
- **Cc: stable:** — none (expected for manual review)
- **Signed-off-by:** yahia ahmed, Ilpo Järvinen (ignore pipeline-added
  SOBs)

Notable: maintainer Reviewed-by; no syzbot/crash reports.

### Step 1.3: Analyze Commit Body
**Record:**
- **Bug description:** Board `8B2F` is missing from
  `victus_s_thermal_profile_boards`, so Victus S thermal-profile
  handling is not activated.
- **Symptom:** On `8B2F` hardware, platform_profile thermal switching
  and Victus S fan/thermal WMI paths do not engage; generic fallback is
  used instead.
- **Version info:** None in message.
- **Root cause:** Missing DMI board-name entry in an existing quirk
  table.

### Step 1.4: Detect Hidden Bug Fixes
**Record:** Not disguised cleanup. This is explicit hardware-enablement:
a DMI quirk entry for a laptop board that needs the existing Victus S
thermal path. Without it, thermal/fan behavior is wrong or absent, not
merely cosmetic.

---

## Phase 2: Diff Analysis

### Step 2.1: Inventory the Changes
**Record:**
- **Files:** `drivers/platform/x86/hp/hp-wmi.c` (+4 lines)
- **Functions/areas:** `victus_s_thermal_profile_boards[]` init table
- **Scope:** Single-file, surgical DMI table addition

### Step 2.2: Code Flow Change
**Record:**
- **Before:** `setup_active_thermal_profile_params()` does not match
  board `8B2F`; `is_victus_s_board` stays false.
- **After:** Board `8B2F` matches; `is_victus_s_board = true`,
  `active_thermal_profile_params = &victus_s_thermal_params`.
- **Affected path:** Module init →
  `setup_active_thermal_profile_params()` → `thermal_profile_setup()` /
  `is_victus_s_thermal_profile()` consumers (platform_profile, hwmon fan
  paths).

### Step 2.3: Bug Mechanism
**Record:**
- **Category:** Hardware quirk / missing device (DMI board) ID
- **Mechanism:** Wrong code path for known hardware needing Victus S WMI
  thermal commands and GPU thermal settings

### Step 2.4: Fix Quality
**Record:** Obviously correct — one DMI entry pointing at existing
`victus_s_thermal_params`. Minimal risk; no API/locking changes.
Maintainer-reviewed.

---

## Phase 3: Git History Investigation

### Step 3.1: Blame Changed Lines
**Record:** `victus_s_thermal_profile_boards` table
introduced/refactored in `d9aefb386fdc4` (Jan 2026, "fix platform
profile values for Omen 16-wf1xxx"). Prior entries added by commits like
`54afb047cd7eb`, `94b2a56fd4b1c`, `d4ff92dd98ad1`. The missing-board
pattern is longstanding; this extends the same table.

### Step 3.2: Follow Fixes Tag
**Record:** N/A — no `Fixes:` tag.

### Step 3.3: Related File History
**Record:** Recent related commits are the same pattern (add board IDs
for Victus/Omen thermal support): `54afb047cd7eb`, `748f897511446`,
`6e4ab59b8391a`, `d9aefb386fdc4`, etc. Standalone one-entry addition;
not part of a multi-patch series.

### Step 3.4: Author Context
**Record:** yahia ahmed — no other hp-wmi commits in this tree.
Reviewed/committed by Ilpo Järvinen (subsystem maintainer).

### Step 3.5: Dependencies
**Record:** Requires Victus S thermal infrastructure already in tree
(`victus_s_thermal_params`, `victus_s_thermal_profile_boards`,
`setup_active_thermal_profile_params()`). **Present in this 6.18.44
tree.** Commit diff context (e.g. `omen_v1_legacy_thermal_params`,
boards `8902`/`8A44`) does not match current tree; backport needs a one-
entry addition to the current `dmi_system_id` table, not a literal
apply.

---

## Phase 4: Mailing List and External Research

### Step 4.1: Original Patch Discussion
**Record:** `b4 dig -c` unavailable (commit not in this checkout). `b4
shazam` and curl/lore fetch blocked (403/Anubis). Link present but
thread content unverified.

### Step 4.2: Reviewers
**Record:** Reviewed-by and Signed-off-by: Ilpo Järvinen (platform/x86
maintainer). Full recipient list unverified.

### Step 4.3: Bug Report
**Record:** No external bug report or syzbot link.

### Step 4.4: Related Patches/Series
**Record:** Same pattern as prior Victus board additions
(`54afb047cd7eb` added `8BBE`/`8BD4`/`8BD5`). Standalone patch.

### Step 4.5: Stable List History
**Record:** Not searched successfully (lore blocked). Similar hp-wmi
stable backports in this tree are crash/ACPI fixes, not board-ID-only
additions.

---

## Phase 5: Code Semantic Analysis

### Step 5.1: Key Functions
**Record:** `victus_s_thermal_profile_boards[]`,
`setup_active_thermal_profile_params()`,
`is_victus_s_thermal_profile()`, `thermal_profile_setup()`,
`platform_profile_victus_s_set_ec()`, hwmon fan read/write paths.

### Step 5.2: Callers
**Record:** `setup_active_thermal_profile_params()` called from
`hp_wmi_init()` before probe. `is_victus_s_thermal_profile()` used in
thermal profile setup, hwmon fan visibility/read/write, powersource
handler registration/cleanup.

### Step 5.3: Callees
**Record:** `dmi_first_match()`, `omen_thermal_profile_set()`,
`victus_s_gpu_thermal_profile_set()`,
`devm_platform_profile_register()`.

### Step 5.4: Reachability
**Record:** Runs at boot on HP WMI laptops. Affects any user of
`platform_profile` sysfs and hwmon fan interfaces on board `8B2F`.
Userspace-reachable on affected hardware.

### Step 5.5: Similar Patterns
**Record:** Same table pattern as `8BBE`, `8BD4`, `8BD5`, `8C99`, etc.
Board `8B2F` also appears in `sound/soc/amd/yc/acp6x-mach.c` (HP OMEN
Gaming Laptop 16-ap0xxx audio quirk, commit `65aabf8896687`), confirming
real hardware in the ecosystem.

---

## Phase 6: Cross-Reference Against Local Tree

### Step 6.1: Does Buggy Code Exist?
**Record:** **Yes.** Local tree is **v6.18.44** (`VERSION=6`,
`PATCHLEVEL=18`, `SUBLEVEL=44`). `victus_s_thermal_profile_boards`
exists; **`8B2F` is absent.** Victus S infrastructure present since
`d9aefb386fdc4` and related commits.

### Step 6.2: Backport Complications
**Record:** Minor adaptation needed — commit diff context differs from
current tree (no `omen_v1_legacy_thermal_params`; fewer/different
entries). Actual backport: add one `dmi_system_id` entry with
`victus_s_thermal_params`. Clean, low conflict risk.

### Step 6.3: Related Fixes Already Present?
**Record:** No existing `8B2F` entry in hp-wmi or grep across tree
(except unrelated nls/audio entries).

---

## Phase 7: Subsystem and Maintainer Context

### Step 7.1: Subsystem Criticality
**Record:** `drivers/platform/x86/hp/` — **IMPORTANT** (laptop platform
driver; thermal/fan/power management for HP hardware).

### Step 7.2: Subsystem Activity
**Record:** Actively developed — multiple hp-wmi thermal/board commits
in 2025–2026 in this tree.

---

## Phase 8: Impact and Risk Assessment

### Step 8.1: Who Is Affected
**Record:** Owners of HP laptops with DMI board name `8B2F` (HP
OMEN/Victus family; corroborated by audio quirk for 16-ap0xxx line).

### Step 8.2: Trigger Conditions
**Record:** Boot on matching hardware with `CONFIG_HP_WMI`. Common for
affected laptop owners; not a race or rare error path.

### Step 8.3: Failure Mode Severity
**Record:** Without fix: wrong thermal profile path — no Victus S
platform_profile modes, incorrect fan WMI path, no GPU thermal mode
control via driver. **Severity: MEDIUM** (functional/hardware issue;
BIOS still provides baseline thermal management; not a kernel crash).

### Step 8.4: Risk-Benefit
**Record:**
- **Benefit:** Enables correct thermal/fan behavior on real hardware for
  stable users who cannot upgrade kernels.
- **Risk:** Very low — 4 lines, existing data structure, no behavior
  change for other boards.
- **Ratio:** Favorable.

---

## Phase 9: Final Synthesis

### Step 9.1: Evidence Summary

**FOR backport:**
- Explicit device/quirk ID addition to existing driver (stable-
  rules.rst: "just add a device ID" or "hardware quirk")
- Trivial, obviously correct, maintainer-reviewed
- Real hardware (`8B2F` confirmed in tree via audio DMI quirk)
- Required infrastructure exists in v6.18.44
- Enables platform_profile and hwmon fan control on affected laptops

**AGAINST backport:**
- Not a crash/security/corruption fix
- No user bug report or syzbot evidence
- Commit diff does not apply literally to current tree (needs minor
  adaptation)
- Mailing list discussion unverified

**UNRESOLVED:**
- Exact laptop model and user testing details from lore thread
- Whether reviewers nominated `Cc: stable`

### Step 9.2: Stable Rules Checklist
1. Obviously correct and tested? **PASS** (maintainer reviewed; pattern
   proven by sibling board entries)
2. Fixes real bug affecting users? **PASS** (hardware quirk —
   wrong/missing thermal path on `8B2F`)
3. Important issue? **PASS** (hardware quirk per stable rules;
   functional thermal/fan management)
4. Small and contained? **PASS** (4 lines, one file)
5. No new features/APIs? **PASS** (DMI table entry only; no new APIs)
6. Can apply to local tree? **PASS** (minor one-entry adaptation to
   current table)

### Step 9.3: Exception Category
**Record:** Hardware quirk / device ID addition (DMI board ID in
existing hp-wmi driver). Matches `Documentation/process/stable-kernel-
rules.rst` line 15: "just add a device ID" and line 19: "hardware
quirk."

### Step 9.4: Decision Rationale
For **v6.18.44**, the Victus S thermal framework is present but board
`8B2F` is missing. This is the same class of change as prior Victus
board additions — a DMI quirk entry enabling correct thermal and fan
behavior on real HP hardware. It is small, maintainer-reviewed, low
risk, and explicitly within stable policy for device-ID/quirk additions.
The commit should be adapted (not cherry-picked verbatim) to the current
`dmi_system_id` table layout.

---

## Verification

- **[Phase 1]** Parsed subject, tags, body; no Fixes/Reported-by/syzbot
- **[Phase 2]** Diff: +4 lines, one DMI entry with
  `victus_s_thermal_params`
- **[Phase 3]** `git describe HEAD`: v6.18.44; `git blame` on table:
  `d9aefb386fdc4` refactor; related commits `54afb047cd7eb`,
  `6e4ab59b8391a`
- **[Phase 3]** `git log --grep="8B2F"`: no hp-wmi commit in tree
- **[Phase 4]** `b4 dig -c`: failed (commit not in checkout); `b4
  shazam`: message-id unknown; lore/patch.msgid.link: blocked
  (403/Anubis)
- **[Phase 5]** Read `setup_active_thermal_profile_params()`,
  `is_victus_s_thermal_profile()`, `thermal_profile_setup()`, hwmon
  paths
- **[Phase 5]** `grep 8B2F`: found in `acp6x-mach.c` (HP OMEN 16-ap0xxx
  audio quirk, `65aabf8896687`)
- **[Phase 6]** `grep 8B2F` in hp-wmi.c: absent;
  `victus_s_thermal_params` and table exist
- **[Phase 6]** Commit diff context (`omen_v1_legacy_thermal_params`,
  boards `8902`/`8A44`) not in current tree — adaptation required
- **[Phase 7]** hp-wmi actively maintained; Ilpo Järvinen is maintainer
- **[Phase 8]** Impact: thermal/fan/platform_profile on board `8B2F`;
  severity MEDIUM; risk very low
- **[Phase 9]** `Documentation/process/stable-kernel-rules.rst` line 15
  confirms device-ID additions are stable-appropriate

**YES**

 drivers/platform/x86/hp/hp-wmi.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/platform/x86/hp/hp-wmi.c b/drivers/platform/x86/hp/hp-wmi.c
index 550d4b39a92af..3f9c718123a85 100644
--- a/drivers/platform/x86/hp/hp-wmi.c
+++ b/drivers/platform/x86/hp/hp-wmi.c
@@ -158,6 +158,10 @@ static const struct dmi_system_id victus_s_thermal_profile_boards[] __initconst
 		.matches = { DMI_MATCH(DMI_BOARD_NAME, "8BAB") },
 		.driver_data = (void *)&omen_v1_thermal_params,
 	},
+	{
+		.matches = { DMI_MATCH(DMI_BOARD_NAME, "8B2F") },
+		.driver_data = (void *)&victus_s_thermal_params,
+	},
 	{
 		.matches = { DMI_MATCH(DMI_BOARD_NAME, "8BBE") },
 		.driver_data = (void *)&victus_s_thermal_params,
-- 
2.53.0

