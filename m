Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D68A4FDE67;
	Mon, 31 Aug 2026 13:41:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183701; cv=none; b=mimJSo17sXA87ctRWhIsGzz7rhsSFeB6K8wgzMI8m6Jjoqyz95iY9+NtEHSvIYPbnNbdxNPNW8LrVb9t0K/7XpS/muiZNGwNhlnNSus5uIEk0getoBRMmbpk6nF9LMh+9rBQgGd4ARBe3T6SGSCLiYW3b5os1LgDSf1K2EZVbCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183701; c=relaxed/simple;
	bh=gtnAnXwBRmsYFTkNKGnIG/sTS4ep8ljphDpw2tAtWxQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gflbTGUT7W2SCM0aB4V43iyWCQ9hKDaNvgdFGgXDFzUmVR3McDTGd+5sdbgnZ5l9k39I7zbYUfUSifxJhDpmvSDF7GhUj3RVZQJyWkqyg6YHkGpAMWf2XZ/0787xXN493ncjANitEVTLYgW+O0HVVWUdWg7Ds9DGq+nACyTWlgs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ktj73pen; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ktj73pen"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D24D1F000E9;
	Mon, 31 Aug 2026 13:41:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183698;
	bh=4m9C3WtV+4kie0OyMCII7hdpMBWXDh77eQPrzfE9Aac=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ktj73pen5Qlsl68TqZRLRwWOn+tHbJuuyHnViqEF+YL3NqRmT/4m2vX+nqhCnJqFB
	 4Vn+wpGDYw2r1XmV7LLfSpYWul2qZgIwqktXldPndHbohL/XEQt/ZXtRk89Gzqosxj
	 lZu2f38+T3AV7e5zWsFJwqrZ/2SOc2Bs1czWiRPIm4jNnXY1djvL/k0PuH8iAG3fNS
	 umwNiYir5iaGKN7LPcvw3P3GvxlSeHAvuwz3wGc5lNd67ABiJWutB+YqY/DM6tk1HW
	 RAQRZy6ffOe84Io0Iup3mlkXtUG1dnL6lvR2LIYpGl+RqxKd1ICD9m3rYq6qj/jLNX
	 Zd6NUJHcQxTsA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: =?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	kenneth.feng@amd.com,
	christian.koenig@amd.com,
	airlied@gmail.com,
	simona@ffwll.ch,
	amd-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] drm/amd/pm/si: Don't schedule thermal work when queue isn't initialized
Date: Mon, 31 Aug 2026 09:24:39 -0400
Message-ID: <20260831133314.4125787-251-sashal@kernel.org>
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

From: Timur Kristóf <timur.kristof@gmail.com>

[ Upstream commit f8922d5a946699fc2bdc7660e6778bd6726bf8b8 ]

When DPM is turned off with the amdgpu.dpm=0 module parameter,
the thermal work queue isn't initialized so we shouldn't
schedule any work on it.

Signed-off-by: Timur Kristóf <timur.kristof@gmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit bd018d36171a695952c6d391471c279c9e05c8b2)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: `drm/amd/pm/si: Don't schedule thermal work
when queue isn't initialized`

**Local tree:** `v6.18.44` (Makefile: 6.18.44)
**Upstream commit:** `bd018d36171a695952c6d391471c279c9e05c8b2` — **not
present** in this checkout.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject line
**Record:** `[drm/amd/pm/si]` `[Don't schedule]` — prevent scheduling
thermal work on an uninitialized workqueue when DPM is disabled.

### Step 1.2: Tags
**Record:**
- `Signed-off-by: Timur Kristóf <timur.kristof@gmail.com>` (author)
- `Signed-off-by: Alex Deucher <alexander.deucher@amd.com>` (AMD DRM
  maintainer)
- No `Fixes:`, `Reported-by:`, `Cc: stable@vger.kernel.org`, `Link:`,
  `Tested-by:`, or `Reviewed-by:` tags
- Notable: maintainer sign-off; no syzbot/user crash report in message

### Step 1.3: Body analysis
**Record:**
- **Bug:** With `amdgpu.dpm=0`, thermal `struct work_struct` is never
  initialized via `INIT_WORK()`, but thermal IRQ handling can still call
  `schedule_work()` on it.
- **Symptom:** Undefined behavior / kernel crash when a thermal
  interrupt fires under `dpm=0`.
- **Root cause (author):** Thermal IRQ IDs are registered before the
  `amdgpu_dpm == 0` early-return in `si_dpm_sw_init()`, but
  `INIT_WORK()` is skipped on that path.

### Step 1.4: Hidden bug fix?
**Record:** No — this is an explicit bug fix, not disguised cleanup.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory
**Record:**
- **File:** `drivers/gpu/drm/amd/pm/legacy-dpm/si_dpm.c` (+1/-1, net 0
  lines)
- **Function:** `si_dpm_process_interrupt()`
- **Scope:** Single-file, single-line surgical fix

### Step 2.2: Code flow change
**Record:**
- **Before:** Any thermal IRQ (src_id 230/231) →
  `schedule_work(&adev->pm.dpm.thermal.work)` unconditionally.
- **After:** Same path, but only if `amdgpu_dpm` is non-zero.
- **Path affected:** Interrupt handler path (can run in interrupt
  context; work is deferred).

### Step 2.3: Bug mechanism
**Record:** **Memory safety / logic correctness** — use of uninitialized
workqueue.

In `si_dpm_sw_init()`:

```7783:7808:drivers/gpu/drm/amd/pm/legacy-dpm/si_dpm.c
        ret = amdgpu_irq_add_id(adev, AMDGPU_IRQ_CLIENTID_LEGACY, 230,
&adev->pm.dpm.thermal.irq);
        // ...
        ret = amdgpu_irq_add_id(adev, AMDGPU_IRQ_CLIENTID_LEGACY, 231,
&adev->pm.dpm.thermal.irq);
        // ...
        if (amdgpu_dpm == 0)
                return 0;
        // ...
        INIT_WORK(&adev->pm.dpm.thermal.work,
amdgpu_dpm_thermal_work_handler);
```

With `amdgpu.dpm=0`, IRQ handlers are registered but `INIT_WORK()` is
skipped. A thermal interrupt reaching `si_dpm_process_interrupt()` calls
`schedule_work()` on a zeroed but uninitialized work struct (device
allocated via `devm_drm_dev_alloc()`). The work function pointer is
NULL; queueing or executing such work can WARN or oops.

### Step 2.4: Fix quality
**Record:**
- **Quality:** High — mirrors existing `amdgpu_dpm` guards in the same
  file (`si_dpm_hw_init`, `si_dpm_sw_init`).
- **Regression risk:** Very low — only suppresses work scheduling in the
  exact case where work was never initialized.
- **Note:** `kv_dpm.c` has the same pattern unfixed; this commit only
  addresses SI.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
**Record:** `si_dpm_process_interrupt()` and the unguarded
`schedule_work()` line blame to `^5d324e5159d9e` (predates reachable
history in this tree). Bug is long-standing, not a recent regression.

### Step 3.2: Fixes: tag
**Record:** N/A — no `Fixes:` tag.

### Step 3.3: Related file history
**Record:** Recent `si_dpm.c` changes are unrelated powertune/HAINAN
fixes. No duplicate fix for this issue in this tree. Commit
`bd018d36171a` is **not** an ancestor of HEAD.

### Step 3.4: Author context
**Record:** Timur Kristóf is an active `drm/amd/pm` contributor
(multiple recent SI/CI/SMU7 fixes). Alex Deucher committed the fix.

### Step 3.5: Dependencies
**Record:** Standalone one-hunk change. `amdgpu_dpm` is already declared
in `amdgpu.h` (included by `si_dpm.c`). No prerequisite commits
required. Listed as patch 1/3 on the mailing list, but this hunk is
self-contained for SI.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Original discussion
**Record:**
- `b4 dig -c bd018d36171a`: https://patch.msgid.link/20260712173928.2597
  01-1-timur.kristof@gmail.com
- `b4 dig -a`: v1 only; `[PATCH 1/3]` (series has 2 more patches, likely
  KV/CI siblings)
- Lore/patch.msgid.link content blocked by bot protection — **could not
  read thread replies, stable nominations, or NAKs**

### Step 4.2: Reviewers
**Record:** `b4 dig -w` CC'd `amd-gfx@lists.freedesktop.org`, Alex
Deucher, Natalie Vock, Mario Limonciello (AMD), Tvrtko Ursulin.

### Step 4.3: Bug report
**Record:** N/A — no external bug report linked.

### Step 4.4: Related patches
**Record:** Part of a 3-patch series; patches 2/3 and 3/3 not verified
in this tree. This commit does not depend on them.

### Step 4.5: Stable list
**Record:** UNVERIFIED — could not search lore stable archive due to bot
protection.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key functions
**Record:** `si_dpm_process_interrupt()`, `si_dpm_sw_init()`,
`amdgpu_dpm_thermal_work_handler()`

### Step 5.2: Callers
**Record:** `si_dpm_process_interrupt` is the `.process` callback in
`si_dpm_irq_funcs`, wired via `si_dpm_set_irq_funcs()`. Invoked by the
amdgpu IRQ layer on thermal IH events (src_id 230/231).

### Step 5.3: Callees
**Record:** `schedule_work()` → workqueue; handler
`amdgpu_dpm_thermal_work_handler()` (which itself checks
`adev->pm.dpm_enabled`, but that does not help if work was never
initialized).

### Step 5.4: Reachability
**Record:**
- Requires `CONFIG_DRM_AMDGPU_SI` + `amdgpu.si_support=1` (SI support is
  experimental, off by default)
- Requires `amdgpu.dpm=0` module parameter
- Requires thermal IRQ delivery (src_id 230 or 231)
- Not directly userspace-triggerable, but hardware thermal events under
  load are realistic

### Step 5.5: Similar patterns
**Record:** Identical unguarded pattern in `kv_dpm_process_interrupt()`
at line 3189–3190 of `kv_dpm.c` — same `amdgpu_dpm == 0` early-return /
`INIT_WORK` split in `kv_dpm_sw_init()`.

---

## PHASE 6: CROSS-REFERENCE WITH LOCAL TREE (6.18.44)

### Step 6.1: Buggy code present?
**Record:** **YES.** Lines 7674–7675 still have the unguarded
`schedule_work()`:

```7674:7675:drivers/gpu/drm/amd/pm/legacy-dpm/si_dpm.c
        if (queue_thermal)
                schedule_work(&adev->pm.dpm.thermal.work);
```

### Step 6.2: Backport complications
**Record:** Clean apply expected — single-line change, no structural
conflicts. File has had minor unrelated churn but this hunk is
untouched.

### Step 6.3: Fix already present?
**Record:** **NO.** `git merge-base --is-ancestor bd018d36171a HEAD`
fails; grep shows no `queue_thermal && amdgpu_dpm` in tree.

---

## PHASE 7: SUBSYSTEM CONTEXT

### Step 7.1: Subsystem criticality
**Record:** `drivers/gpu/drm/amd/pm` — **IMPORTANT** (GPU driver / power
management). Affects SI ASIC users on amdgpu, not core kernel.

### Step 7.2: Activity
**Record:** Actively maintained; recent SI powertune and display-timing
fixes in this tree.

---

## PHASE 8: IMPACT AND RISK

### Step 8.1: Who is affected
**Record:** Users of Southern Islands GPUs with experimental amdgpu SI
support enabled and `amdgpu.dpm=0`. Narrow but real population
(debugging, workarounds).

### Step 8.2: Trigger conditions
**Record:** `amdgpu.dpm=0` at module load + thermal IRQ from GPU.
Uncommon parameter combo, but thermal events are normal under GPU load.

### Step 8.3: Failure severity
**Record:** Kernel WARN/oops from scheduling or executing uninitialized
work — **HIGH** (system crash). Not data corruption or security
escalation.

### Step 8.4: Risk-benefit
**Record:**
- **Benefit:** Prevents crash on a valid module-parameter configuration
- **Risk:** Minimal (one boolean guard matching existing conventions)
- **Ratio:** Favorable for stable

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence summary

**FOR backport:**
- Real bug with clear mechanism (uninitialized work + `schedule_work()`)
- Can cause kernel crash
- One-line, obviously correct fix
- AMDGPU maintainer sign-off
- Buggy code confirmed in v6.18.44; fix not yet applied
- Matches existing `amdgpu_dpm` guards in same file

**AGAINST backport:**
- Narrow trigger: experimental SI support + `dpm=0` + thermal IRQ
- `CONFIG_DRM_AMDGPU_SI` off by default
- No user/syzbot report in commit message
- Sibling `kv_dpm.c` has same bug (out of scope for this commit)

**Unresolved:**
- Full mailing-list review thread (bot-blocked)
- Whether patches 2/3 fix KV/CI separately

### Step 9.2: Stable rules checklist
1. Obviously correct and tested? **PASS** — logic is clear; maintainer
   SOB; no Tested-by
2. Fixes a real bug? **PASS** — uninitialized work scheduling
3. Important issue? **PASS** — kernel crash (HIGH, narrow audience)
4. Small and contained? **PASS** — 1 line, 1 file
5. No new features/APIs? **PASS**
6. Can apply to local tree? **PASS** — code exists, clean apply expected

### Step 9.3: Exception categories
**Record:** N/A — standard bug fix, not device-ID/quirk/DT/build/doc
exception.

### Step 9.4: Decision rationale
This is a small, surgical crash fix for a valid `amdgpu.dpm=0`
configuration on SI hardware. The audience is narrow (legacy SI +
experimental amdgpu support), but stable trees routinely take such
driver crash fixes when the change is minimal and clearly correct. The
bug exists in this 6.18.44 tree and the fix applies cleanly.

---

## Verification

- [Phase 1] Parsed commit `bd018d36171a`: subject, body, SOBs from Timur
  Kristóf and Alex Deucher; no Fixes/Reported-by/Link tags
- [Phase 2] Diff: 1-line guard `queue_thermal && amdgpu_dpm` before
  `schedule_work()` in `si_dpm_process_interrupt()`
- [Phase 2] Read `si_dpm_sw_init()`: IRQ registered at 7783–7788, early
  return at 7801–7802 skips `INIT_WORK()` at 7808
- [Phase 2] Read `amdgpu_drv.c`: `amdgpu_dpm` module param at lines 162,
  382 (`module_param_named(dpm, ...)`)
- [Phase 3] `git blame -L 7674,7675`: lines present since pre-history
  (`^5d324e5159d9e`)
- [Phase 3] `git merge-base --is-ancestor bd018d36171a HEAD`: commit
  **NOT** in tree
- [Phase 3] `git log --oneline -20 -- si_dpm.c`: no duplicate fix
- [Phase 3] `git log --author="Timur Kristóf" -10 --
  drivers/gpu/drm/amd/pm/`: author active in subsystem
- [Phase 4] `b4 dig -c bd018d36171a`: found v1 at https://patch.msgid.li
  nk/20260712173928.259701-1-timur.kristof@gmail.com
- [Phase 4] `b4 dig -a`: patch 1/3 in series
- [Phase 4] `b4 dig -w`: CC'd amd-gfx, Alex Deucher, Mario Limonciello
- [Phase 4] UNVERIFIED: lore/patch.msgid.link thread content (bot
  protection)
- [Phase 5] `si_dpm_process_interrupt` wired via
  `si_dpm_irq_funcs.process` at line 8155
- [Phase 5] `kv_dpm.c` has identical unguarded pattern at 3189–3190
- [Phase 5] `amdgpu_dpm_thermal_work_handler()` checks `dpm_enabled` but
  does not prevent uninitialized-work bug
- [Phase 6] `git describe HEAD`: v6.18.44-2-g1b9e1abadee04; Makefile
  6.18.44
- [Phase 6] Buggy code confirmed at si_dpm.c:7674–7675 in working tree
- [Phase 6] `si_dpm.c` includes `amdgpu.h` with `extern int amdgpu_dpm`
  — fix compiles
- [Phase 7] `CONFIG_DRM_AMDGPU_SI` in Kconfig: experimental SI support,
  off by default
- [Phase 8] Failure mode: crash from uninitialized `schedule_work()` —
  severity HIGH, trigger narrow

**YES****Result:** The fix commit `bd018d36171a` is **not** in this tree
(`v6.18.44`), and the bug is still present in `si_dpm.c`.

**Verdict:** **YES** — backport recommended.

With `amdgpu.dpm=0`, thermal IRQ handlers are registered but
`INIT_WORK()` is skipped, so a thermal interrupt can call
`schedule_work()` on an uninitialized work struct and crash the kernel.
The one-line guard (`queue_thermal && amdgpu_dpm`) matches existing
checks in the same file and should apply cleanly to 6.18.y.

 drivers/gpu/drm/amd/pm/legacy-dpm/si_dpm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/pm/legacy-dpm/si_dpm.c b/drivers/gpu/drm/amd/pm/legacy-dpm/si_dpm.c
index ea97276358c0a..39928eb71d669 100644
--- a/drivers/gpu/drm/amd/pm/legacy-dpm/si_dpm.c
+++ b/drivers/gpu/drm/amd/pm/legacy-dpm/si_dpm.c
@@ -7690,7 +7690,7 @@ static int si_dpm_process_interrupt(struct amdgpu_device *adev,
 		break;
 	}
 
-	if (queue_thermal)
+	if (queue_thermal && amdgpu_dpm)
 		schedule_work(&adev->pm.dpm.thermal.work);
 
 	return 0;
-- 
2.53.0

