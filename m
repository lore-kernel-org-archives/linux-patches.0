Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77D7B583AB5;
	Mon, 31 Aug 2026 13:50:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184205; cv=none; b=oenYEL29LBA6XrKyu/aLhOOSTHYvCbuuKST7ZvgcyDghCgZOVP7M1pjRYh7idD34AYbZjzv3n+ZeMKTfXjoq5XEcYu780Bq7fGzDXN3t4kCHq6M36YszIeQ+MenHgxIY89gibLtQxTpJufLoIVoKMOvzLLGcB4i4TunR1ZpP2Hs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184205; c=relaxed/simple;
	bh=BGZDSPxHc1gRRkFlT/enxSIwikFaUZRT3Fwb2KOoMQM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=C9eq2WscmeGZHx4uZQXvLiRRndcHeCqG6HknWClJWsPrQ4BRGv88yTvdesG+3rrfl8TGtmJHqbgtMZeh6Ejre9/o3uBFEvJ2OCYQj96TYxGCdfs8tXptbYSvRJb4oOAd7BbAQ0rk1am8BbvrV3qPS/QHShtktKCOtpGpLAugvxw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Pg/B5Lox; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Pg/B5Lox"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB6711F000E9;
	Mon, 31 Aug 2026 13:50:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788184202;
	bh=it4mtCYNz8u1hklavjiA7XOWE9P7mg7elTYlRIEuKIk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Pg/B5Loxw4gL5YwySWVrtC1B0Xe1yAbiTLGiE6OFXrYzRLwRZvlg4990wvwnPYJBS
	 3wef6ygVFz4cHfEKzJls45CWPDfGHFZW8pLhask1F8pp3RcFWqrN6NtGC+VZmEEjbZ
	 lXxPI9vrETtMEXTtI84S9TcdVjsLi85rzqe0AAxVI/OFPPsZQpFhsq23VPYupwVzNQ
	 uHQnQFB2ac8lD0+6ucZWxx6LL8wVzcyvs6ymhFG5tcZKOX7yAes4pQvrfq0OtfwX7k
	 g1kgcY2T8KF5py6u7h2SZ41bdn5Vt2XmFA9rFNy3w8lLMihJcyXxLO0ge8cmAJx2OY
	 oyGHoK1sFuN5w==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Alexander Egorov <begeebe@gmail.com>,
	Derek J Clark <derekjohn.clark@gmail.com>,
	Antheas Kapenekakis <lkml@antheas.dev>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>,
	samsagax@gmail.com,
	hansg@kernel.org,
	platform-driver-x86@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] platform/x86: oxpec: add support for OneXPlayer Super X
Date: Mon, 31 Aug 2026 09:29:40 -0400
Message-ID: <20260831133314.4125787-552-sashal@kernel.org>
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

From: Alexander Egorov <begeebe@gmail.com>

[ Upstream commit 0b6573e23acc7bca808e539e3edea49683f106de ]

OneXPlayer Super X identifies itself via DMI as:

  board vendor: ONE-NETBOOK
  board name:   ONEXPLAYER SUPER X
  product name: ONEXPLAYER SUPER X

Current mainline oxpec does not contain a matching DMI entry for this
system, so the in-tree driver is not auto-loaded.

The tested Super X fan, PWM, turbo-toggle, and battery charge-control EC
layout matches the existing ONEXPLAYER G1 A handling.

Add a DMI match for OneXPlayer Super X and reuse the oxp_g1_a board data.

Reviewed-by: Derek J Clark <derekjohn.clark@gmail.com>
Reviewed-by: Antheas Kapenekakis <lkml@antheas.dev>
Signed-off-by: Alexander Egorov <begeebe@gmail.com>
Link: https://patch.msgid.link/20260519155124.3240359-1-begeebe@gmail.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit Message Forensics

### Step 1.1: Subject Line
**Record:** `[platform/x86: oxpec]` `[add]` — Add DMI match so the
existing oxpec driver auto-loads on OneXPlayer Super X hardware.

### Step 1.2: Tags
**Record:**
- **Reviewed-by:** Derek J. Clark, Antheas Kapenekakis, Ilpo Järvinen
  (subsystem maintainer)
- **Signed-off-by:** Alexander Egorov (author), Ilpo Järvinen
  (maintainer commit)
- **Link:**
  https://patch.msgid.link/20260519155124.3240359-1-begeebe@gmail.com
- No Fixes:, Reported-by:, Tested-by:, Cc: stable@vger.kernel.org, or
  syzbot tags
- Notable: Three Reviewed-by lines including the x86 platform maintainer
  — strong review signal

### Step 1.3: Body Analysis
**Record:**
- **Bug:** OneXPlayer Super X reports DMI `ONE-NETBOOK` / `ONEXPLAYER
  SUPER X`, but no matching `dmi_table` entry exists, so
  `oxp_platform_init()` returns `-ENODEV` and the driver never loads.
- **Symptom:** No fan control (PWM/hwmon), no turbo-toggle sysfs, no
  battery charge-control EC features on Super X.
- **Root cause:** Missing DMI quirk entry; EC layout matches existing
  `oxp_g1_a` profile.
- **Version info:** None stated; hardware is a new OneXPlayer variant.

### Step 1.4: Hidden Bug Fix?
**Record:** Not disguised — this is explicit hardware enablement.
Functionally it fixes “driver doesn’t bind on this machine,” which is a
real usability defect for Super X owners, though not a crash or security
issue.

---

## Phase 2: Diff Analysis

### Step 2.1: Inventory
**Record:**
- **Files:** `drivers/platform/x86/oxpec.c` only (+7 lines)
- **Functions modified:** `dmi_table[]` static data only; no function
  logic changed
- **Scope:** Single-file, surgical DMI table addition

### Step 2.2: Code Flow Change
**Record:**
- **Before:** `dmi_first_match(dmi_table)` fails for Super X →
  `oxp_platform_init()` returns `-ENODEV` → no platform device, no
  hwmon/battery EC sysfs.
- **After:** Super X matches new entry → `board = oxp_g1_a` → driver
  probes and exposes fan PWM, turbo toggle, charge control identical to
  G1 A.
- **Path affected:** Module init / DMI matching only (normal boot path
  for matching hardware).

### Step 2.3: Bug Mechanism
**Record:** **Hardware workaround / DMI quirk** — same category as
PCI/USB ID additions. Missing DMI match prevents driver binding on
known-compatible hardware.

### Step 2.4: Fix Quality
**Record:** Obviously correct — reuses tested `oxp_g1_a` board data per
author hardware validation. Minimal diff, no logic changes. Regression
risk: very low (only affects machines with exact DMI string `ONEXPLAYER
SUPER X`).

---

## Phase 3: Git History Investigation

### Step 3.1: Blame
**Record:** Adjacent G1 A entry introduced in `b369395c895bf` (“Add
support for the OneXPlayer G1”, Apr 2025); `driver_data = oxp_g1_a` set
in `232b41d3c2ce8` (Jul 2025). G1 A support is an ancestor of HEAD and
present in `v6.18`.

### Step 3.2: Fixes: Tag
**Record:** N/A — no Fixes: tag.

### Step 3.3: Related File History
**Record:** Recent oxpec DMI additions already backported to this 6.18.y
tree:
- `43c40bfb85038` — OneXPlayer APEX
- `1faaa81aabab7` — OneXPlayer X1z
- `ba6af12e600bf` — Aokzoe A2 Pro
- `0a4e44eb4b0c1` — OneXPlayer X1 Air (committed by Greg K-H with
  upstream marker)

Same pattern, same file, same driver. Standalone one-commit change.

### Step 3.4: Author Context
**Record:** Alexander Egorov authored this patch; Antheas Kapenekakis is
the primary oxpec maintainer (authored most recent device additions).
Ilpo Järvinen is x86 platform maintainer and committed the patch.

### Step 3.5: Dependencies
**Record:** Requires `oxp_g1_a` enum and its EC handling — **present in
this tree** since v6.18. No other commits needed. Patch inserts cleanly
between G1 A and G1 i entries.

---

## Phase 4: Mailing List and External Research

### Step 4.1: Original Discussion
**Record:** `b4 dig -c <commit>` not possible — commit is not in local
tree. Lore/patch.msgid.link fetch blocked (Anubis bot protection).
**UNVERIFIED:** full mailing-list thread content and any explicit stable
nominations in replies.

### Step 4.2: Reviewers
**Record:** From commit message — Derek J. Clark (oxpec co-maintainer),
Antheas Kapenekakis (oxpec maintainer), Ilpo Järvinen (x86 platform
maintainer). Appropriate reviewers CC’d per commit metadata.

### Step 4.3: Bug Report
**Record:** N/A — no Reported-by or external bug link beyond patch
submission.

### Step 4.4: Related Patches
**Record:** Standalone; not part of a multi-patch series. Same class as
other oxpec DMI additions already in 6.18.y.

### Step 4.5: Stable List History
**Record:** **UNVERIFIED** (lore blocked). However, four analogous oxpec
DMI additions are already in `v6.18..v6.18.44`, establishing precedent
in this tree.

---

## Phase 5: Code Semantic Analysis

### Step 5.1: Key Functions
**Record:** Only `dmi_table[]` modified. Relevant init path:
`oxp_platform_init()` → `dmi_first_match()` →
`platform_create_bundle()`.

### Step 5.2: Callers
**Record:** `oxp_platform_init()` is `module_init` — runs at module load
/ built-in init. Affects every boot on matching DMI hardware when
`CONFIG_OXP_EC` is enabled.

### Step 5.3: Callees
**Record:** `dmi_first_match()`, `platform_create_bundle()`,
`oxp_platform_probe()` — standard platform driver init. `oxp_g1_a` path
uses existing `read_from_ec`/`write_to_ec` for fan, turbo, battery.

### Step 5.4: Reachability
**Record:** Triggered automatically at boot on OneXPlayer Super X with
`CONFIG_OXP_EC=y/m`. No userspace syscall needed; affects all Super X
users on this kernel.

### Step 5.5: Similar Patterns
**Record:** Nine+ prior DMI entries in same table for other
OneXPlayer/AOKZOE models; four similar additions already backported to
6.18.y.

---

## Phase 6: Cross-Reference Against Local Tree

### Step 6.1: Buggy Code Present?
**Record:** **YES.** Local tree is **v6.18.44**.
`drivers/platform/x86/oxpec.c` exists with `oxp_g1_a` and G1 A DMI
entry, but **no** `ONEXPLAYER SUPER X` entry (verified by grep and
reading lines 267–280). Super X owners on 6.18.44 get no oxpec support.

### Step 6.2: Backport Complications
**Record:** **Clean apply expected** — 7-line insertion between existing
G1 A and G1 i blocks; no structural divergence in that region.

### Step 6.3: Related Fixes Already Present?
**Record:** G1 A support (`b369395c895bf`) and G1 AMD turbo fix
(`232b41d3c2ce8`) already in tree. Super X fix not present.

---

## Phase 7: Subsystem Context

### Step 7.1: Subsystem Criticality
**Record:** `drivers/platform/x86/` — **PERIPHERAL** (handheld gaming
device EC driver). Important to Super X users; not core kernel.

### Step 7.2: Activity
**Record:** Actively maintained — four oxpec DMI additions backported to
6.18.y in the last few months.

---

## Phase 8: Impact and Risk Assessment

### Step 8.1: Who Is Affected
**Record:** OneXPlayer Super X owners running Linux 6.18.y with
`CONFIG_OXP_EC` enabled (typical on distro kernels for x86 handhelds).

### Step 8.2: Trigger Conditions
**Record:** Every boot on matching hardware. Common for device owners;
not timing-dependent.

### Step 8.3: Failure Mode Severity
**Record:** Missing fan control, turbo management, and battery charge
limiting — **MEDIUM** (no crash/corruption, but degraded hardware
management and potential thermal/battery issues without manual
workarounds).

### Step 8.4: Risk-Benefit
**Record:**
- **Benefit:** Enables full EC platform support on a shipping device;
  consistent with prior oxpec stable backports.
- **Risk:** Very low — 7-line DMI entry, exact string match, reuses
  validated board profile.
- **Ratio:** Favorable; matches established 6.18.y policy for this
  driver.

---

## Phase 9: Final Synthesis

### Step 9.1: Evidence Summary

**FOR backport:**
- Trivial DMI quirk addition (stable exception category: device ID /
  hardware quirk)
- Fixes real user-visible problem (driver won’t load)
- Hardware-tested; three Reviewed-by including maintainer
- Prerequisites (`oxp_g1_a`) present since v6.18
- Four analogous oxpec DMI patches already in 6.18.y
- Clean, minimal diff

**AGAINST backport:**
- Not a crash, security, or data-corruption fix
- Only affects one specific handheld model
- Mailing-list stable nomination not verified

**UNRESOLVED:**
- Full lore thread content and any explicit Cc: stable discussion

### Step 9.2: Stable Rules Checklist
1. Obviously correct and tested? **PASS** — reuses G1 A profile,
   hardware-tested, maintainer-reviewed
2. Fixes real bug affecting users? **PASS** — driver fails to bind; EC
   features unavailable
3. Important issue? **PASS** (moderate) — hardware management broken for
   device owners; aligns with stable’s device-ID exception
4. Small and contained? **PASS** — 7 lines, one file
5. No new features/APIs? **PASS** — no new APIs; enables existing driver
   on new DMI
6. Can apply to local tree? **PASS** — prerequisites present, clean
   insert

### Step 9.3: Exception Category
**Record:** Hardware quirk / DMI ID addition to existing driver (stable
exception #1 and #2).

### Step 9.4: Decision Rationale

For **Linux 6.18.44** (this checkout): the oxpec driver and `oxp_g1_a`
board profile already exist, but Super X is not matched, so owners lack
fan control, turbo toggle, and battery charge management. The fix is a
7-line DMI entry reusing validated board data — the same pattern already
accepted four times in this 6.18.y series. Risk is negligible; benefit
is concrete for Super X users.

---

## Verification

- **[Phase 1]** Parsed commit message, tags, and body from user-provided
  diff
- **[Phase 2]** Diff analysis: +7 lines in `dmi_table[]`, no function
  logic changed
- **[Phase 3]** `git describe HEAD` → v6.18.44; `make kernelversion`
  equivalent → 6.18.44
- **[Phase 3]** `git log --oneline -20 -- drivers/platform/x86/oxpec.c`
  → recent oxpec history
- **[Phase 3]** `git blame -L 267,273` → G1 A entry from
  `b369395c895bf`, `oxp_g1_a` from `232b41d3c2ce8`
- **[Phase 3]** `git merge-base --is-ancestor b369395c895bf HEAD` → G1
  support is ancestor
- **[Phase 3]** `git merge-base --is-ancestor b369395c895bf v6.18` → G1
  support in v6.18 base
- **[Phase 3]** `git log v6.18..v6.18.44 --oneline --
  drivers/platform/x86/oxpec.c` → 4 prior DMI backports
- **[Phase 3]** `git show 0a4e44eb4b0c1` → X1 Air backport by Greg K-H
  with upstream marker
- **[Phase 4]** `b4 dig` → requires commit in tree; not runnable for
  candidate commit
- **[Phase 4]** WebFetch lore/patch.msgid.link → blocked by Anubis;
  thread content UNVERIFIED
- **[Phase 5]** Read `oxp_platform_init()` at lines 1076–1099 →
  `-ENODEV` when DMI unmatched
- **[Phase 5]** Read `oxp_g1_a` usage in turbo/PWM/battery paths →
  existing handling confirmed
- **[Phase 6]** Grep for `ONEXPLAYER SUPER X` → not present in tree
  (only unrelated eisa.ids match)
- **[Phase 6]** Read `drivers/platform/x86/oxpec.c` lines 267–280 → G1 A
  present, Super X absent
- **[Phase 6]** `git show v6.18:drivers/platform/x86/oxpec.c | grep -c
  "ONEXPLAYER G1 A"` → 1 (G1 A in v6.18)
- **[Phase 7]** Kconfig `OXP_EC` at line 1025 → driver exists, depends
  on ACPI_EC/ACPI_BATTERY/HWMON/X86

**YES**

 drivers/platform/x86/oxpec.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/platform/x86/oxpec.c b/drivers/platform/x86/oxpec.c
index a30845ba37969..56df03cd195fd 100644
--- a/drivers/platform/x86/oxpec.c
+++ b/drivers/platform/x86/oxpec.c
@@ -271,6 +271,13 @@ static const struct dmi_system_id dmi_table[] = {
 		},
 		.driver_data = (void *)oxp_g1_a,
 	},
+	{
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "ONE-NETBOOK"),
+			DMI_EXACT_MATCH(DMI_BOARD_NAME, "ONEXPLAYER SUPER X"),
+		},
+		.driver_data = (void *)oxp_g1_a,
+	},
 	{
 		.matches = {
 			DMI_MATCH(DMI_BOARD_VENDOR, "ONE-NETBOOK"),
-- 
2.53.0

