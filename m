Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0B005803B5;
	Mon, 31 Aug 2026 13:49:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184189; cv=none; b=jkl17QpZ34+ofbnYpUL9OVSVoCAMv6cBHXU8G518RPCj873ZoZq0qlXZxM7xrdpFS2ZIhDwz1odOEUvDBCf1wudnr/d9jd4C+akDhag3xuQWJ1Y9kiwV1jVOQLsQnLJxNB3ax2FyLogoP82PJYXYdJNtEXZvMegeTRX5iRrNRwo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184189; c=relaxed/simple;
	bh=LPueD1hUsDjQlY4SKgu6VHjnhiah98+PhF0cjozIjDE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ifTzv3kGi3xn2WK17+Ks9pvkZcAFkXUXpXPyUMf5RQKeFFwxORn8ofB2Jqty4RROH7+uccL1CwSiqy2GolE6E08d9FIFBMg/JRFahvhBKgpgytm/URYfA6/BiDxGQMY8lNRq3YMDSvXqksbYxPUV+JX4xvT2A4jXnde+CGzXYXs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cbLXvWdT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cbLXvWdT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF3B91F00A3D;
	Mon, 31 Aug 2026 13:49:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788184186;
	bh=sEnbmS/e3mUQWPuHjNXWSDPAdU/HRaTajz+dBcPwjX4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cbLXvWdT39QgBFWWQBTWB6aOXGRgsvBs/9IFM31ocpAPeazTpEtV/8NJcomr4E9Xq
	 6GUwAgdD+MTJ1Yess+8jAVekVnyy/dvznlSwKYscDwi/+NCnbnhHimCmrqR7TbbJBw
	 iNQsakS8gTd/NISmDC7qYoUxSukHYk1vZDAfE1Wq1mCAHbvFg258p4nt+9V9PWJsVU
	 hO47biD36a1k2PN+985Qi0SWqV3X5I91kR5xGp8UE0kppdWwxbv5IyknQk4/ArW/J1
	 ljoFItTHa1hVrWejwOyB0ytX1ZUtW256O8o+w73bG/8SSRFbjkoQ5OST+UTKWrYCnk
	 gAkfF+xlLQpWQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Luis de Carlos <reskoldo73@gmail.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>,
	teackot@gmail.com,
	hansg@kernel.org,
	platform-driver-x86@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.12] platform/x86: msi-ec: Add support for MSI Pulse GL66 12th Gen
Date: Mon, 31 Aug 2026 09:29:31 -0400
Message-ID: <20260831133314.4125787-543-sashal@kernel.org>
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

From: Luis de Carlos <reskoldo73@gmail.com>

[ Upstream commit ab7be7ed913086e076bfd8aba79f614f415cd6dc ]

Add the firmware string '1583EMS1.109' to the ALLOWED_FW_10 array.
This enables Embedded Controller support, including battery charge
thresholds, for the MSI Pulse GL66 12UEK (MS-1583) laptop.

Signed-off-by: Luis de Carlos <reskoldo73@gmail.com>
Link: https://patch.msgid.link/20260527134750.25263-1-reskoldo73@gmail.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit Message Forensics

### Step 1.1: Subject Line
**Record:** `[platform/x86: msi-ec]` `[Add]` — Add firmware whitelist
entry to enable EC support for MSI Pulse GL66 12th Gen (MS-1583).

### Step 1.2: Commit Message Tags
**Record:**
- **Signed-off-by:** Luis de Carlos `<reskoldo73@gmail.com>` (author)
- **Link:**
  https://patch.msgid.link/20260527134750.25263-1-reskoldo73@gmail.com
- **Reviewed-by:** Ilpo Järvinen `<ilpo.jarvinen@linux.intel.com>`
  (subsystem maintainer)
- **Signed-off-by:** Ilpo Järvinen (committer/maintainer)
- No Fixes:, Reported-by:, Tested-by:, Cc: stable@vger.kernel.org, or
  syzbot tags
- Notable: Reviewed and committed by platform/x86 maintainer Ilpo
  Järvinen

### Step 1.3: Commit Body Analysis
**Record:**
- **Bug description:** Not a crash/corruption bug. The `msi-ec` driver
  refuses to load on firmware `1583EMS1.109` because it is absent from
  `ALLOWED_FW_10`.
- **Symptom:** Driver init returns `-EOPNOTSUPP` with "Firmware version
  is not supported"; battery charge thresholds and other EC extras
  unavailable on MSI Pulse GL66 12UEK (MS-1583).
- **Root cause:** Missing firmware string in the whitelist for existing
  `CONF10` configuration.
- **Version info:** None stated; laptop is 12th Gen (Alder Lake era).

### Step 1.4: Hidden Bug Fix Detection
**Record:** Not a hidden bug fix. This is explicit hardware enablement —
adding a firmware identification string so an existing, tested
configuration (`CONF10`) is selected for a new laptop variant.
Functionally equivalent to adding a device ID.

---

## Phase 2: Diff Analysis

### Step 2.1: Change Inventory
**Record:**
- **Files:** `drivers/platform/x86/msi-ec.c` (+1 line)
- **Functions/areas:** `ALLOWED_FW_10[]` firmware whitelist array
- **Scope:** Single-file, single-line surgical change

### Step 2.2: Code Flow Change
**Record:**
- **Before:** `load_configuration()` iterates `CONFIGS[]`, calls
  `match_string()` on each `allowed_fw` list. Firmware `1583EMS1.109`
  matches nothing → warning + `-EOPNOTSUPP` → `msi_ec_init()` fails →
  module does not load.
- **After:** `1583EMS1.109` matches `ALLOWED_FW_10` → `CONF10` is copied
  into `conf` → `battery_hook_register()` succeeds → charge threshold
  sysfs attributes become available.
- **Path affected:** Module initialization (`__init`), normal boot path
  for matching MSI hardware.

### Step 2.3: Bug Mechanism
**Record:** Category: **Hardware enablement / device identification**
(not memory safety, race, or crash). The driver deliberately whitelists
firmware versions before exposing EC register addresses. Missing entry =
safe refusal to load, not a kernel defect.

### Step 2.4: Fix Quality
**Record:** Obviously correct — reuses existing `CONF10` already used
for `1582EMS1.107` (GF66 11UC), a closely related MS-158x platform.
Minimal change. Regression risk very low: only affects systems reporting
exactly this firmware string; no API, locking, or memory management
changes.

---

## Phase 3: Git History Investigation

### Step 3.1: Blame
**Record:** `ALLOWED_FW_10` and `CONF10` introduced in `8abba08944663`
("platform/x86: msi-ec: Add more EC configs", 2023-10-06, v6.6 era).
Present in this tree since driver merge.

### Step 3.2: Fixes: Tag
**Record:** N/A — no Fixes: tag present.

### Step 3.3: Related File History
**Record:** Recent `msi-ec.c` history in this tree (v6.18.44):
- `59fff63cc2b75` Merge platform-drivers-x86 v6.7-1
- `6284e67aa6cb3` Fix the 3rd config
- `8abba08944663` Add more EC configs
- `392cacf2aa10d` Add new msi-ec driver (v6.4)

On master but not in this stable tree:
- `ab7be7ed91308` — this commit (Pulse GL66)
- `4c8f323b9e151` — unrelated include fix for future acpi.h change

**Standalone:** Yes. No series dependency.

### Step 3.4: Author Context
**Record:** Luis de Carlos is a hardware reporter/user contributor. Ilpo
Järvinen is the platform/x86 maintainer who reviewed and committed the
patch.

### Step 3.5: Prerequisites
**Record:** No prerequisites. `CONF10`, `CONFIGS[]`,
`load_configuration()`, and `ALLOWED_FW_10` all exist in v6.18.44. The
`4c8f323b9e151` dmi.h include commit is independent and not needed for
this one-line addition.

---

## Phase 4: Mailing List and External Research

### Step 4.1: Original Discussion
**Record:**
- **b4 dig URL:**
  https://patch.msgid.link/20260527134750.25263-1-reskoldo73@gmail.com
- **Series revisions:** v1 → v2 (v2 is what was committed)
- **Reviewer feedback:** Ilpo Järvinen applied to his review branch with
  acknowledgment ("Thank you for your contribution, it has been
  applied")
- **No NAKs, no stable nomination** in thread
- **No objections** raised

### Step 4.2: Reviewers
**Record:** CC'd: `platform-driver-x86@vger.kernel.org`, `linux-
kernel@vger.kernel.org`, teackot@gmail.com (driver author),
hansg@kernel.org. Reviewed/committed by Ilpo Järvinen.

### Step 4.3: Bug Report
**Record:** No external bug report, syzbot, or bugzilla link. User-
submitted hardware enablement from laptop owner.

### Step 4.4: Related Patches
**Record:** Standalone 1/1 patch. No multi-patch series dependencies.

### Step 4.5: Stable Mailing List
**Record:** Not searched separately; no stable nomination found in the
patch thread itself.

---

## Phase 5: Code Semantic Analysis

### Step 5.1: Key Functions
**Record:** `ALLOWED_FW_10[]` (data), `load_configuration()`,
`msi_ec_init()`.

### Step 5.2: Callers
**Record:** `msi_ec_init()` → `load_configuration()` at module init.
`msi_ec` is a loadable module (`CONFIG_MSI_EC`, tristate) probed on MSI
laptops matching DMI vendor table. Called once at boot/module load.

### Step 5.3: Callees
**Record:** `ec_get_firmware_version()` reads EC register 0xa0;
`match_string()` compares against whitelist; on match,
`battery_hook_register()` exposes charge threshold sysfs via ACPI
battery hook.

### Step 5.4: Reachability
**Record:** Triggered when `CONFIG_MSI_EC=m/y` on MSI laptop with
firmware `1583EMS1.109`. Requires root to load module (or built-in at
boot). Not a syscall path; hardware-specific platform driver init.

### Step 5.5: Similar Patterns
**Record:** The driver has 14 `ALLOWED_FW_*` arrays with the same
pattern. Adding entries to existing arrays is the established mechanism
for new hardware variants (e.g., `8abba08944663` added many configs at
once).

---

## Phase 6: Cross-Reference Against Local Tree

### Step 6.1: Buggy Code Exists?
**Record:** **YES.** Local tree is **v6.18.44** (6.18.y stable).
`ALLOWED_FW_10` exists with only `"1582EMS1.107"`. Firmware
`1583EMS1.109` is not whitelisted. Commit `ab7be7ed91308` is on master
but not in this tree.

### Step 6.2: Backport Complications
**Record:** **Clean apply expected.** Single-line insertion into
existing array at line 825. No conflicts with local modifications. Index
in commit (`f19504dbf164c`) matches current tree structure around
`CONF9`/`ALLOWED_FW_10`.

### Step 6.3: Related Fixes Already Present?
**Record:** No. `git grep 1583EMS1` returns no matches. No alternative
fix for Pulse GL66 in this tree.

---

## Phase 7: Subsystem and Maintainer Context

### Step 7.1: Subsystem Criticality
**Record:** `drivers/platform/x86/` — **PERIPHERAL** platform driver for
MSI laptop EC extras. Optional module; laptop functions without it (no
crash), but battery charge threshold control is unavailable.

### Step 7.2: Subsystem Activity
**Record:** Driver added v6.4 (2023), configs expanded v6.6. Mature but
still receiving firmware whitelist additions. Low churn in stable tree.

---

## Phase 8: Impact and Risk Assessment

### Step 8.1: Who Is Affected
**Record:** **Hardware-specific** — owners of MSI Pulse GL66 12UEK
(MS-1583) with firmware `1583EMS1.109` who build/load `CONFIG_MSI_EC`.
Small population.

### Step 8.2: Trigger Conditions
**Record:** Boot or `modprobe msi-ec` on matching MSI laptop with this
exact firmware. Not timing-dependent. Requires `CONFIG_MSI_EC` enabled.
Unprivileged users cannot trigger module load.

### Step 8.3: Failure Mode Severity
**Record:** Without patch: driver refuses to load (`-EOPNOTSUPP`),
charge thresholds unavailable. **Severity: LOW** — missing
functionality, not crash, corruption, hang, or security issue. Laptop
otherwise works.

### Step 8.4: Risk-Benefit
**Record:**
- **Benefit:** Enables battery charge threshold and EC extras for a real
  laptop on stable kernel; matches official stable rule allowing device
  ID additions
- **Risk:** Very low — 1 line, whitelist-only, reuses proven `CONF10`
  config
- **Ratio:** Moderate benefit for affected users, negligible risk

---

## Phase 9: Final Synthesis

### Step 9.1: Evidence Summary

**FOR backporting:**
- Explicitly allowed by `Documentation/process/stable-kernel-rules.rst`:
  "just add a device ID"
- Firmware string is this driver's device-identification mechanism
- 1 line, obviously correct, maintainer-reviewed
- Driver and `CONF10` already exist in v6.18.44
- Clean apply, no dependencies
- Enables real hardware functionality for stable-kernel users

**AGAINST backporting:**
- Not a crash/corruption/security/deadlock fix
- Affects one laptop model with small user base
- Optional module — system works without it
- No user bug reports beyond patch author

**Unresolved:** Whether `CONF10` register map is fully validated on
MS-1583 (author and maintainer accepted it; no independent test reports
in thread).

### Step 9.2: Stable Rules Checklist
1. Obviously correct and tested? **PASS** — maintainer
   reviewed/committed; trivial whitelist addition
2. Fixes real bug affecting users? **PASS** — per stable rules, "just
   add a device ID" is sufficient; missing ID prevents driver from
   loading on real hardware
3. Important issue? **PASS (by exception)** — not crash-level, but
   device ID additions are explicitly permitted
4. Small and contained? **PASS** — 1 line, 1 file
5. No new features or APIs? **PASS** — no new APIs; enables existing
   `CONF10` on new hardware variant
6. Can apply to local tree? **PASS** — driver infrastructure present,
   clean 1-line apply

### Step 9.3: Exception Category
**Record:** **NEW DEVICE ID** — firmware version string added to
existing driver's whitelist, enabling existing `CONF10` configuration.
Directly matches stable-kernel-rules.rst line 15 and the user's "NEW
DEVICE IDs" exception.

### Step 9.4: Decision Rationale

This commit adds firmware `1583EMS1.109` to the `ALLOWED_FW_10`
whitelist so the existing `msi-ec` driver loads on the MSI Pulse GL66
12UEK. The local tree (v6.18.44) has the driver and `CONF10` but lacks
this string, so affected laptops cannot use kernel-managed battery
charge thresholds.

Per the stable rules in this tree's own documentation, patches that
"just add a device ID" are explicitly acceptable for stable. The
firmware string serves as the device identifier for `msi-ec`. The change
is one line, maintainer-reviewed, applies cleanly, and carries
negligible regression risk.

---

## Verification

- [Phase 1] Parsed subject, tags, body; identified hardware enablement
  intent
- [Phase 1] No syzbot/Fixes:/Cc: stable tags found
- [Phase 2] Diff: +1 line to `ALLOWED_FW_10[]` in
  `drivers/platform/x86/msi-ec.c`
- [Phase 2] Read `load_configuration()` at lines 1306–1337: confirms
  `-EOPNOTSUPP` without whitelist match
- [Phase 3] `git describe HEAD`: v6.18.44
- [Phase 3] `git blame -L 824,827`: `ALLOWED_FW_10` from `8abba08944663`
  (2023-10-06)
- [Phase 3] `git show ab7be7ed91308`: confirmed commit hash and 1-line
  diff
- [Phase 3] `git log HEAD..master -- drivers/platform/x86/msi-ec.c`: 2
  commits (this + unrelated include fix)
- [Phase 3] `git show 4c8f323b9e151`: confirmed NOT a prerequisite
- [Phase 4] `b4 dig -c ab7be7ed91308`: found v2 thread at
  patch.msgid.link
- [Phase 4] `b4 dig -a`: v1→v2 series, v2 committed
- [Phase 4] `b4 dig -w`: Ilpo Järvinen, platform-driver-x86 list CC'd
- [Phase 4] Read `/tmp/msi-ec-pulse.mbox`: maintainer applied patch, no
  NAKs, no stable CC
- [Phase 5] `grep match_string`: used in `load_configuration()` line
  1319
- [Phase 5] Read `Kconfig` MSI_EC help text: confirms charge threshold
  purpose
- [Phase 6] `grep 1583EMS1`: not present in local tree
- [Phase 6] `grep 1582EMS1`: present at line 825, confirming target
  array exists
- [Phase 6] Read `Documentation/process/stable-kernel-rules.rst` line
  15: "just add a device ID" explicitly allowed
- [Phase 8] Confirmed failure mode is `-EOPNOTSUPP` (LOW severity), not
  crash

**YES**The MSI Pulse GL66 `msi-ec` commit is a good stable backport
candidate for this tree (v6.18.44).

It adds one firmware string (`1583EMS1.109`) to the existing
`ALLOWED_FW_10` whitelist so the already-present `CONF10` config can
load on the MSI Pulse GL66 12UEK. Without it, `msi-ec` returns
`-EOPNOTSUPP` and battery charge thresholds stay unavailable.

This fits the stable rule for device ID additions: one line, maintainer-
reviewed, clean apply, and the driver infrastructure is already in
6.18.y. It is hardware enablement, not a crash fix, but that is
explicitly allowed for this kind of change.

**YES**

 drivers/platform/x86/msi-ec.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/platform/x86/msi-ec.c b/drivers/platform/x86/msi-ec.c
index f19504dbf164c..0157e233e4300 100644
--- a/drivers/platform/x86/msi-ec.c
+++ b/drivers/platform/x86/msi-ec.c
@@ -823,6 +823,7 @@ static struct msi_ec_conf CONF9 __initdata = {
 
 static const char * const ALLOWED_FW_10[] __initconst = {
 	"1582EMS1.107", // GF66 11UC
+	"1583EMS1.109", // Pulse GL66 12UEK
 	NULL
 };
 
-- 
2.53.0

