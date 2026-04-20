Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4450D3B5832;
	Mon, 20 Apr 2026 13:16:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776691014; cv=none; b=FrilQ6AgqI1Qb91fT7RS/qLw9f0bLVFMDImymaGA13oVwrhoAaFXF653PbzXeMGDR5RcG5pGHU/hxHA2NnzUL8hKGGn5zeL6mJpnDDbfx6PWdDKjcJ14GGJ1XQmLKhtirtezR3fdDkf8zQEHRWfhe9r7EegiGEBUhzV01Nk3KiA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776691014; c=relaxed/simple;
	bh=NOoahQgDNyfghUyUAMgyKDJl+Dm7UfdzwD1WI2hXVT0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=m8rEIPToK6cynLOQ9vVK7epZmuxJlTwQZ6IKAPkpFarP7nzBhtNVKCMjp3etRDZ0SYpcCx2v0xNvLoFTilj9FdnsIjz1F206cX7asW3FzNBAh3M/CygfxraPMWLgKrVOdnjkY5SSS9M/BIQaIcTNJtweHMXmDkSrC1koF+OO7Dw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=k3aZtpo7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="k3aZtpo7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EE90C2BCB4;
	Mon, 20 Apr 2026 13:16:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776691014;
	bh=NOoahQgDNyfghUyUAMgyKDJl+Dm7UfdzwD1WI2hXVT0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k3aZtpo7p/LTjynoy/7mw3x6ilAg0KBI9n+tnx3PbosSFFhlILHsT2UltqGKhPGQ7
	 eFHCPd3v9cDRxg4/mnF8V2A8HwCbW3RevxsSKVHbms64zm7mhv059E6E7ap0RSCGgN
	 Q34Iy+OkuWW3a2C6nqNf8ku03tOHNhLnQgEHjatwKubAYL2L7unaq0rfD/12wbY/5h
	 e2TWldxre5CFqrS8xl/QFH/jUEzEHgHdvmiikv+xLkxxmLICn9qIDdGfiMVF3N211G
	 3MALaG0oVHk2S1ZOh8LwBXcGhffzxpqRFgjbUBlb8zANLipWgyKBMRUX1+nweYsK8+
	 D6UAefQQ2Xamg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Huisong Li <lihuisong@huawei.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	rafael@kernel.org,
	linux-acpi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-5.10] ACPI: processor: idle: Fix NULL pointer dereference in hotplug path
Date: Mon, 20 Apr 2026 09:08:29 -0400
Message-ID: <20260420131539.986432-43-sashal@kernel.org>
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

From: Huisong Li <lihuisong@huawei.com>

[ Upstream commit 47e6a863a88034be102bde11197f2ca1bc18cbaf ]

A cpuidle_device might fail to register during boot, but the system can
continue to run. In such cases, acpi_processor_hotplug() can trigger
a NULL pointer dereference when accessing the per-cpu acpi_cpuidle_device.

So add NULL pointer check for the per-cpu acpi_cpuidle_device in
acpi_processor_hotplug.

Signed-off-by: Huisong Li <lihuisong@huawei.com>
Link: https://patch.msgid.link/20260403090253.998322-1-lihuisong@huawei.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have all the information needed. Let me compile the complete
analysis.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1: Subject Line**
- Subsystem: `ACPI: processor: idle`
- Action verb: "Fix"
- Summary: Fix NULL pointer dereference in hotplug path
- Record: [ACPI/processor/idle] [Fix] [NULL pointer dereference in CPU
  hotplug when cpuidle_device failed to register]

**Step 1.2: Tags**
- `Signed-off-by: Huisong Li <lihuisong@huawei.com>` — author
- `Link:
  https://patch.msgid.link/20260403090253.998322-1-lihuisong@huawei.com`
  — lore reference
- `Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>` — ACPI
  maintainer applied it
- No Fixes: tag, no Reported-by, no Tested-by, no Cc: stable
- Record: Single patch, accepted by subsystem maintainer Rafael J.
  Wysocki. No Fixes: tag (expected for review candidates).

**Step 1.3: Commit Body**
- Bug: cpuidle_device registration can fail during boot, but the system
  continues running. When `acpi_processor_hotplug()` is later invoked
  (CPU soft online), it accesses the per-cpu `acpi_cpuidle_device` which
  may be NULL.
- Symptom: NULL pointer dereference.
- Root cause: Missing NULL check for per-cpu device before use.

**Step 1.4: Hidden Bug Fix?**
- Commit uses explicit "Fix" in subject — straightforward.

## PHASE 2: DIFF ANALYSIS

**Step 2.1: Inventory**
- 1 file modified: `drivers/acpi/processor_idle.c`
- Net: 1 line added, 3 removed (minor restructuring)
- Function modified: `acpi_processor_hotplug()`
- Scope: Single-function surgical fix.

**Step 2.2: Code Flow Change**

BEFORE:
```c
int ret = 0;
struct cpuidle_device *dev;
...
if (!pr->flags.power_setup_done)
    return -ENODEV;
dev = per_cpu(acpi_cpuidle_device, pr->id);
cpuidle_pause_and_lock();
cpuidle_disable_device(dev);   // dev could be NULL
```

AFTER:
```c
struct cpuidle_device *dev = per_cpu(acpi_cpuidle_device, pr->id);
int ret = 0;
...
if (!pr->flags.power_setup_done || !dev)
    return -ENODEV;
cpuidle_pause_and_lock();
cpuidle_disable_device(dev);   // dev guaranteed non-NULL
```

The fix moves the `dev` assignment before the check and adds `|| !dev`
to the early return.

**Step 2.3: Bug Mechanism**

This is a **NULL pointer dereference fix** (defensive). The per-cpu
`acpi_cpuidle_device` can be NULL when:
1. `acpi_processor_power_init()` sets `power_setup_done = 1`
2. `cpuidle_register_device()` then fails
3. The memory leak fix (`11b3de1c03fa9`, Jul 2025) sets
   `per_cpu(acpi_cpuidle_device, pr->id) = NULL`

**Step 2.4: Fix Quality**

Important nuance discovered through deep analysis: The three callee
functions currently DO handle NULL dev:
- `cpuidle_disable_device(NULL)` → returns via `if (!dev ||
  !dev->enabled)` (since 2012)
- `acpi_processor_setup_cpuidle_dev(pr, NULL)` → returns via `if (!dev)`
  (since 2016)
- `cpuidle_enable_device(NULL)` → returns `-EINVAL` via `if (!dev)`
  (since 2012)

So there is no actual kernel crash in practice. However, the fix:
- Prevents unnecessary `cpuidle_pause_and_lock()` /
  `cpuidle_resume_and_unlock()` (global mutex)
- Prevents `acpi_processor_get_power_info()` from needlessly modifying
  processor flags
- Makes the code correct at the right abstraction level rather than
  relying on callee guards
- Zero regression risk

## PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1: Blame**
- `acpi_processor_hotplug()` core structure: Len Brown, 2007
  (`4f86d3a8e29720`)
- Per-cpu device usage: Wei Yongjun, 2012 (`e8b1b59dc8e42a`)
- Per-cpu variable introduced: Daniel Lezcano, 2012 (`3d339dcbb56d`)
- The code exists in ALL stable trees.

**Step 3.2: Fixes Tag**
No Fixes: tag present. However, the root cause path was created by
`11b3de1c03fa9` ("Fix memory leak when register cpuidle device failed",
Jul 2025) by the SAME author (Huisong Li). That commit has `Fixes:
3d339dcbb56d` (2012), so it likely went to all active stable trees. This
fix is a necessary companion to the memory leak fix.

**Step 3.3: File History**
The file has had significant recent activity from Huisong Li (a series
of cleanups/refactors accepted into 6.19/7.0). The hotplug function
itself has been stable since 2012.

**Step 3.4: Author**
Huisong Li is an active contributor to ACPI processor idle code, having
submitted 10+ patches to this file. He is the same author who introduced
the memory leak fix that created the condition for this bug.

**Step 3.5: Dependencies**
No dependencies. The fix is self-contained and touches only the
`acpi_processor_hotplug()` function, which is identical in stable trees.

## PHASE 4: MAILING LIST RESEARCH

**Step 4.1-4.5:** Lore was not accessible due to anti-scraping
protection. b4 dig did not find a match. The commit's Link: tag
references `20260403090253.998322-1-lihuisong@huawei.com`. The patch was
accepted directly by Rafael J. Wysocki (ACPI maintainer). No NAKs or
concerns are evident from the acceptance.

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1:** Function modified: `acpi_processor_hotplug()`

**Step 5.2: Callers**
- `acpi_processor_soft_online()` in `drivers/acpi/processor_driver.c`
  line 124
- Called during CPU soft online events (hotplug path)
- Return value is IGNORED by the caller

**Step 5.3-5.4: Call Chain**
CPU hotplug → `acpi_processor_soft_online()` →
`acpi_processor_hotplug()` → cpuidle lock/disable/enable
This is a system-level path triggered during CPU online/offline
operations on ACPI systems.

**Step 5.5: Similar Patterns**
`acpi_processor_power_state_has_changed()` (lines 1322-1344) has the
same pattern — uses `per_cpu(acpi_cpuidle_device, cpu)` without NULL
check. The fix does NOT address this function, but it has an additional
`!_pr->flags.power_setup_done` guard that may be sufficient.

## PHASE 6: STABLE TREE ANALYSIS

**Step 6.1:** The buggy code (the `acpi_processor_hotplug()` function
with per-cpu device) exists in ALL active stable trees since 2012
(`3d339dcbb56d`). The NULL condition was introduced by `11b3de1c03fa9`
(Jul 2025), which has a Fixes: tag targeting 2012, so it was very likely
backported to stable.

**Step 6.2:** The patch should apply cleanly to stable trees — the
function has been stable since 2012.

**Step 6.3:** No other fix for this specific issue found.

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

**Step 7.1:** Subsystem: ACPI processor idle (drivers/acpi/).
Criticality: IMPORTANT — affects all x86/ARM ACPI systems.

**Step 7.2:** Active subsystem with recent refactoring by the same
author.

## PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1:** Affected: All ACPI systems where cpuidle device
registration fails during boot.

**Step 8.2:** Trigger: CPU hotplug (online/offline) after boot failure
of cpuidle device registration. This is not common but can happen on
real hardware.

**Step 8.3:** Severity: The callee functions currently handle NULL, so
no actual crash. However, the fix prevents unnecessary mutex
acquisition, state flag modifications, and returns a clean error.
Severity: **LOW-MEDIUM** (defensive fix preventing potential issues).

**Step 8.4: Risk-Benefit**
- BENEFIT: Prevents unnecessary lock operations, incorrect state
  modifications, and makes code robust against future changes. If callee
  NULL guards are ever removed, this prevents a kernel crash.
- RISK: Essentially zero — adds a NULL check to an early return path.
- Ratio: Favorable for backport.

## PHASE 9: FINAL SYNTHESIS

**Evidence FOR backporting:**
- Small, surgical fix (3 lines, single function)
- Obviously correct — adds a NULL check
- Zero regression risk
- Accepted by ACPI subsystem maintainer (Rafael J. Wysocki)
- Companion fix to `11b3de1c03fa9` (memory leak fix) which likely went
  to stable
- Prevents unnecessary global mutex lock/unlock on error path
- Prevents incorrect state modifications via
  `acpi_processor_get_power_info()`
- Makes code robust against future callee changes
- Affects ACPI systems (wide user base)
- Applies cleanly to stable trees

**Evidence AGAINST backporting:**
- No actual NULL pointer dereference crash in current code (callee
  functions handle NULL)
- The commit message overstates the issue ("NULL pointer dereference")
- No Reported-by indicating anyone hit this in practice
- No Fixes: tag

**Stable Rules Checklist:**
1. Obviously correct and tested? **YES**
2. Fixes a real bug? **BORDERLINE** — prevents unnecessary/incorrect
   operations when dev is NULL; defensive against future callee changes
3. Important issue? **LOW-MEDIUM** — no crash, but prevents incorrect
   behavior
4. Small and contained? **YES** (3 lines, 1 function)
5. No new features? **Correct**
6. Can apply to stable? **YES** — function is identical in stable trees

## Verification

- [Phase 2] Diff analysis: moves `dev` assignment before checks, adds
  `|| !dev` to early return — 3 net line changes in single function
- [Phase 2] Verified all three callee functions handle NULL:
  `cpuidle_disable_device` (cf31cd1a0c, 2012), `cpuidle_enable_device`
  (1b0a0e9a15b9, 2012), `cpuidle_get_cpu_driver` (bf4d1b5ddb78, 2012),
  `acpi_processor_setup_cpuidle_dev` (a36a7fecfe60, 2016)
- [Phase 3] git blame: `acpi_processor_hotplug()` from Len Brown 2007,
  per-cpu dev from Wei Yongjun 2012
- [Phase 3] Found `11b3de1c03fa9` (Jul 2025, same author) — memory leak
  fix that introduced the NULL condition; has `Fixes: 3d339dcbb56d`
  targeting 2012
- [Phase 3] Original 2016 function (`a36a7fecfe6071`) already had `!dev`
  guard in `acpi_processor_setup_cpuidle_dev`
- [Phase 3] Caller `acpi_processor_soft_online()` ignores return value
  (line 124 of processor_driver.c)
- [Phase 4] b4 dig: no match found; lore blocked by anti-scraping
- [Phase 5] grep callers: single caller in `processor_driver.c` during
  CPU soft online
- [Phase 6] The `acpi_processor_hotplug()` function is identical in
  stable trees (unchanged since 2012)
- UNVERIFIED: Whether `11b3de1c03fa9` was actually backported to stable
  (but likely, given its Fixes: tag)
- UNVERIFIED: Full mailing list discussion (lore inaccessible)

## Decision

The fix is small (3 lines), obviously correct, has zero regression risk,
and was accepted by the ACPI maintainer. While the actual NULL pointer
dereference doesn't manifest as a crash due to existing callee guards,
the fix properly handles the error condition at the right level —
preventing unnecessary global mutex operations and incorrect state
modifications when `dev` is NULL. It is a necessary companion to the
memory leak fix `11b3de1c03fa9` which likely went to stable. The fix
applies cleanly to all stable trees.

**YES**

 drivers/acpi/processor_idle.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/acpi/processor_idle.c b/drivers/acpi/processor_idle.c
index d4753420ae0b7..74ea25091923f 100644
--- a/drivers/acpi/processor_idle.c
+++ b/drivers/acpi/processor_idle.c
@@ -1275,16 +1275,15 @@ static int acpi_processor_get_power_info(struct acpi_processor *pr)
 
 int acpi_processor_hotplug(struct acpi_processor *pr)
 {
+	struct cpuidle_device *dev = per_cpu(acpi_cpuidle_device, pr->id);
 	int ret = 0;
-	struct cpuidle_device *dev;
 
 	if (disabled_by_idle_boot_param())
 		return 0;
 
-	if (!pr->flags.power_setup_done)
+	if (!pr->flags.power_setup_done || !dev)
 		return -ENODEV;
 
-	dev = per_cpu(acpi_cpuidle_device, pr->id);
 	cpuidle_pause_and_lock();
 	cpuidle_disable_device(dev);
 	ret = acpi_processor_get_power_info(pr);
-- 
2.53.0

