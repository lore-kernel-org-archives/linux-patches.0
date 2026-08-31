Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B31765883E9;
	Mon, 31 Aug 2026 13:50:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184219; cv=none; b=lmPzEigRfB6tqEkLsXI4EXh8sVl8zEjnAR1YIBHdv7cP3CBdvFVfOz5I130ePQz5awh7xPgjEQtoXvnafSb8j7fIt/cOCfa/vG0lCtv5FEiyfbIt6pR6ANWXL6Zkck22QNbdQUSaye+psDZnZ0nBm6/xG/9dhp8UtivkHJRr/Y8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184219; c=relaxed/simple;
	bh=2IFS5mWLBlvBlD3qJIdiLML0pCi6P9UsX8yPxq0g7Sk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TnGYzNgHuWb4ncABSTBnlmwntBHtYjxkRGwz+XOH2A478keTLJnHJ74TNz4kOBeXsd7Uofh8K301o/+GsJfUsJ6LmCD6LbS9+OKdGkzvqIj9656znDT3o/eshWaRJdv/tikpEdzzutWnE0BfeLXWHRiNxvAc+bMI1ce+i/u/Qd4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FSRDZkSZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FSRDZkSZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A14A1F00ACA;
	Mon, 31 Aug 2026 13:50:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788184216;
	bh=z1mN8Wwr8AifXzMeBKomArG90ftuqMTyG0a2XRVDaKM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FSRDZkSZPvRmN+HiFZtwfYFdk18Z9dGphWd4WZ9cmIL8SXe/fpHZ7ABeiyYvf4VbM
	 Dxqf4SgzdxSwwX3Wr4i5JtQATAkqkYOFOUMdxC2KdFGhkTSMkI7RkA2LIZLlSFfhNB
	 pXAbrnK6tATGPRASymedde8GYpviD652+JOrEdHnT7xAS0u1nJr7vPS6VHjKM0bYBe
	 eW0KyRKjjgyfuMu5GS7fjeNjUctwtS40kCn6dqnogjQOabc4BEkzo0/WDyz1IUdsHz
	 xJ7O2s3ZHK9gI7nKb0WDpCMw7DE9aaKByMoUD+eS5PqfHwDZicMSBrvXvZm7Sb4kDi
	 9Fd+y+ULzjA8g==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Candice Li <candice.li@amd.com>,
	Hawking Zhang <Hawking.Zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	kenneth.feng@amd.com,
	christian.koenig@amd.com,
	airlied@gmail.com,
	simona@ffwll.ch,
	amd-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] drm/amdgpu/pm: fix SmartShift bias sysfs store PM refcount on parse error
Date: Mon, 31 Aug 2026 09:29:49 -0400
Message-ID: <20260831133314.4125787-561-sashal@kernel.org>
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

From: Candice Li <candice.li@amd.com>

[ Upstream commit a4b0c3f5d2287997876d8f711a40d3c0418458d8 ]

Return the parse error before acquiring PM access.

Signed-off-by: Candice Li <candice.li@amd.com>
Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: drm/amdgpu/pm: fix SmartShift bias sysfs
store PM refcount on parse error

**Local tree:** `stable/linux-6.18.y` at **v6.18.44** (`make
kernelversion` = 6.18.44)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject Line
**Record:** `[drm/amdgpu/pm]` `[fix]` — Corrects SmartShift bias sysfs
store handler so PM runtime refcount is not touched on `kstrtoint()`
parse failure.

### Step 1.2: Tags
**Record:**
- **Signed-off-by:** Candice Li \<candice.li@amd.com\> (author)
- **Reviewed-by:** Hawking Zhang \<Hawking.Zhang@amd.com\> (AMD
  reviewer)
- **Signed-off-by:** Alex Deucher \<alexander.deucher@amd.com\>
  (drm/amdgpu maintainer)
- No Fixes:, Reported-by:, Tested-by:, Link:, or Cc: stable tags
- Notable: maintainer-reviewed AMD driver fix; no syzbot/fuzzer report

### Step 1.3: Body Analysis
**Record:**
- **Bug:** On invalid sysfs input, `amdgpu_set_smartshift_bias()` calls
  `amdgpu_pm_put_access()` without a matching `amdgpu_pm_get_access()`.
- **Symptom:** Runtime PM usage-count underflow; kernel emits `Runtime
  PM usage count underflow!` via `dev_warn()`.
- **Root cause (author):** Parse error should be returned before
  acquiring PM access.
- **Version info:** None in message; bug introduced in this tree by
  commit `55aa33c3fe3876` (Feb 2025 refactor).

### Step 1.4: Hidden Bug Fix?
**Record:** No — this is an explicit refcount/PM pairing bug fix, not
disguised cleanup.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Change Inventory
**Record:**
- **File:** `drivers/gpu/drm/amd/pm/amdgpu_pm.c` (+3 / −5)
- **Function:** `amdgpu_set_smartshift_bias()` only
- **Scope:** Single-file, surgical fix in one sysfs store handler

### Step 2.2: Code Flow Change

**Before (buggy code in v6.18.44):**

```1865:1886:drivers/gpu/drm/amd/pm/amdgpu_pm.c
        r = kstrtoint(buf, 10, &bias);
        if (r)
                goto out;

        r = amdgpu_pm_get_access(adev);
        if (r < 0)
                return r;
        // ... clamp bias, set amdgpu_smartshift_bias ...
out:
        amdgpu_pm_put_access(adev);

        return r;
```

**After (fixed):**
- Parse error → `return r` immediately (no PM access)
- Success path → `get_access` → work → `put_access` → `return count`

**Record:**
- **Hunk 1:** `kstrtoint` failure: `goto out` + spurious `put_access` →
  early `return r`
- **Hunk 2:** Success path: remove `out:` label; always `return count`
  after balanced get/put
- **Affected path:** Sysfs store error path on invalid input; normal
  path unchanged

### Step 2.3: Bug Mechanism
**Record:**
- **Category:** Reference counting / resource management bug
- **Mechanism:** Commit `55aa33c3fe3876` moved `kstrtoint()` before
  `amdgpu_pm_get_access()` but kept the `out:` label that
  unconditionally calls `amdgpu_pm_put_access()`. On parse failure,
  `pm_runtime_put_autosuspend()` runs without a prior
  `pm_runtime_resume_and_get()`, triggering `rpm_drop_usage_count()`
  underflow handling:

```1079:1095:drivers/base/power/runtime.c
static int rpm_drop_usage_count(struct device *dev)
{
        int ret;

        ret = atomic_sub_return(1, &dev->power.usage_count);
        if (ret >= 0)
                return ret;
        // ...
        atomic_inc(&dev->power.usage_count);
        dev_warn(dev, "Runtime PM usage count underflow!\n");
        return -EINVAL;
}
```

### Step 2.4: Fix Quality
**Record:**
- Obviously correct: matches the pattern used by other sysfs stores in
  the same file (e.g. `amdgpu_set_pp_force_performance_level()` at lines
  388–408)
- Minimal, no unrelated changes
- Regression risk: very low; only reorders error handling on the parse-
  failure path
- No API or behavior change on the success path

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
**Record:**
- `amdgpu_set_smartshift_bias()` introduced in `30d95a37f46d1`
  (2021-05-30, v5.13 era)
- Original code called `pm_runtime_get_sync()` **before** `kstrtoint()`,
  so `goto out` + `put` was correct
- Bug introduced in `55aa33c3fe3876` (2025-02-04, Lijo Lazar) — "Add
  APIs for device access checks"
- Blame confirms lines 1865–1867 (`kstrtoint` + `goto out`) from
  original commit; lines 1869–1871, 1884 (`get_access`/`put_access`)
  from refactor commit

### Step 3.2: Fixes: Tag
**Record:** N/A — no Fixes: tag present.

### Step 3.3: Related File History
**Record:**
- `55aa33c3fe3876` — large PM access API refactor (616-line change in
  this file)
- `494c1432542b3` — earlier SmartShift consistency work
- Fix is standalone; not part of a required multi-commit dependency for
  this function
- Patch submitted as **[PATCH 2/8]** in a series, but this hunk is self-
  contained

### Step 3.4: Author Context
**Record:**
- Candice Li: AMD engineer, regular amdgpu contributor
- Lijo Lazar: authored the refactor that introduced the bug
- Alex Deucher (maintainer) signed off on the fix

### Step 3.5: Dependencies
**Record:** No prerequisites. Fix applies cleanly to current v6.18.44
code; `amdgpu_pm_get_access()`/`amdgpu_pm_put_access()` already exist in
this tree.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Original Discussion
**Record:**
- `b4 dig -c a4b0c3f5d2287`: **no match** (patch on freedesktop.org amd-
  gfx, not lore.kernel.org)
- Fetched: https://lists.freedesktop.org/archives/amd-
  gfx/2026-May/145516.html
- Part of 8-patch series by Candice Li (2026-05-28)
- No explicit stable nomination found in thread
- No NAKs observed in fetched content

### Step 4.2: Reviewers
**Record:** CC'd Hawking Zhang, Tao Zhou, Stanley Yang, Thomas Chai;
Reviewed-by Hawking Zhang; Signed-off-by Alex Deucher

### Step 4.3: Bug Report
**Record:** No external bug report, syzbot link, or user Reported-by.
Bug identified by code inspection during related PM cleanup work.

### Step 4.4: Series Context
**Record:** Patch 2/8 in series covering OD index validation, this
refcount fix, RAS EEPROM validation, etc. This fix is independent of
patches 1 and 3–8.

### Step 4.5: Stable List History
**Record:** lore.kernel.org/stable search blocked (bot protection). No
stable-list discussion found via other sources.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key Functions
**Record:** `amdgpu_set_smartshift_bias()`, `amdgpu_pm_get_access()`,
`amdgpu_pm_put_access()`

### Step 5.2: Callers
**Record:** `amdgpu_set_smartshift_bias` is registered as the `.store`
callback for `smartshift_bias` via
`AMDGPU_DEVICE_ATTR_RW(smartshift_bias, ...)` at line 2544. Invoked when
root (or privileged user) writes to
`/sys/class/drm/card*/device/smartshift_bias`.

### Step 5.3: Callees
**Record:**
- `kstrtoint()` — input parsing
- `amdgpu_pm_get_access()` → `amdgpu_pm_dev_state_check()` +
  `pm_runtime_resume_and_get()`
- `amdgpu_pm_put_access()` → `pm_runtime_mark_last_busy()` +
  `pm_runtime_put_autosuspend()`

### Step 5.4: Reachability
**Record:**
- Reachable from userspace via sysfs write (requires root/privileged
  access)
- Only exposed on SmartShift-capable hardware (`ss_bias_attr_update()`
  gates visibility)
- Trigger: writing non-integer value, e.g. `echo abc >
  .../smartshift_bias`

### Step 5.5: Similar Patterns
**Record:** `amdgpu_set_smartshift_bias` is the **only** sysfs store in
this file that parses input (`kstrtoint`) before `get_access` while
retaining a `goto out` that unconditionally calls `put_access`. Other
`goto out` usages (gpu metrics, temp metrics, fan control) all occur
**after** successful `get_access`.

---

## PHASE 6: CROSS-REFERENCE AGAINST LOCAL TREE

### Step 6.1: Buggy Code Present?
**Record:** **YES.** Buggy code confirmed at lines 1865–1886 in
v6.18.44. Introduced by `55aa33c3fe3876`, present since v6.18-rc1.

### Step 6.2: Backport Complications
**Record:** Clean apply expected. Current tree matches the diff base
exactly. No conflicting changes in this function since the refactor.

### Step 6.3: Fix Already Present?
**Record:** **NO.** Fix commit `a4b0c3f5d2287` exists in the repo object
database but is **not** an ancestor of HEAD (v6.18.44).

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: Subsystem Criticality
**Record:** `drivers/gpu/drm/amd/pm` — **IMPORTANT** (AMD GPU power
management; affects laptop SmartShift systems)

### Step 7.2: Subsystem Activity
**Record:** Actively maintained; recent stable commits in this file
include torn gpu metrics reads, scpm read-only attrs, sysfs cleanup
fixes.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Who Is Affected
**Record:** AMD SmartShift 2.0 laptop users (APU + dGPU power sharing)
who write to `smartshift_bias` sysfs. Narrow hardware scope, but real
production systems.

### Step 8.2: Trigger Conditions
**Record:**
- Invalid integer written to `smartshift_bias` sysfs
- Requires root/privileged sysfs write access
- Unlikely in normal use; plausible via scripting error or manual
  experimentation
- Not security-relevant (privileged access required)

### Step 8.3: Failure Mode Severity
**Record:**
- **Failure:** Runtime PM usage-count underflow warning;
  `pm_runtime_mark_last_busy()` called spuriously
- **Severity:** **MEDIUM** — no crash, panic, or data corruption; kernel
  catches underflow and restores counter, but PM accounting is briefly
  wrong and a `dev_warn` is emitted. Repeated triggers could affect
  suspend/resume behavior.

### Step 8.4: Risk-Benefit
**Record:**
- **Benefit:** MEDIUM — fixes real refcount bug on an error path in
  production driver code present since 6.18.0
- **Risk:** VERY LOW — 3-line logic change, maintainer-reviewed, matches
  established patterns in the same file
- **Ratio:** Benefit outweighs risk

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence Summary

**FOR backport:**
- Real refcount bug introduced by `55aa33c3fe3876` refactor, present in
  v6.18.44
- Obviously correct, minimal fix (3 insertions, 5 deletions)
- Maintainer-reviewed and signed off by Alex Deucher
- Matches error-handling pattern used elsewhere in `amdgpu_pm.c`
- Reference counting bugs in PM paths are standard stable material

**AGAINST backport:**
- Only triggered by invalid sysfs input (root-only)
- Limited to SmartShift-capable AMD hardware
- Failure mode is WARN + counter correction, not crash/corruption
- No user reports or fuzzer findings

**Unresolved:** No stable-list nomination found; no user-reported
instances.

### Step 9.2: Stable Rules Checklist
| Criterion | Result |
|-----------|--------|
| 1. Obviously correct and tested? | **PASS** — logic is clear;
Reviewed-by from AMD; no Tested-by |
| 2. Fixes a real bug affecting users? | **PASS** — refcount imbalance
on parse-error path |
| 3. Important issue? | **PASS** (borderline) — runtime PM underflow;
MEDIUM severity |
| 4. Small and contained? | **PASS** — 8 lines net, one function |
| 5. No new features/APIs? | **PASS** |
| 6. Can apply to local tree? | **PASS** — buggy code present; clean
apply |

### Step 9.3: Exception Categories
**Record:** None applicable (not device ID, quirk, DT, build, or docs
fix).

### Step 9.4: Decision Rationale

This is a clear bug introduced in v6.18 by the PM access API refactor
(`55aa33c3fe3876`). The original SmartShift bias handler correctly
acquired runtime PM before parsing; the refactor inverted that order but
left the unconditional `out:` cleanup, breaking get/put pairing. The fix
restores correct refcount semantics with zero functional change on the
success path.

While the trigger is narrow (invalid sysfs write on SmartShift hardware)
and the failure mode is a caught underflow warning rather than a crash,
reference-count bugs in GPU runtime PM are appropriate for stable
backport: the fix is trivial, obviously correct, maintainer-approved,
and the buggy code is present throughout the 6.18.y series.

---

## Verification

- [Phase 1] Parsed commit message and tags from user-provided diff and
  mailing list
- [Phase 2] Read current `amdgpu_set_smartshift_bias()` at lines
  1856–1887 in v6.18.44; confirmed buggy get/put pairing
- [Phase 2] Read `rpm_drop_usage_count()` at lines 1079–1095; confirmed
  underflow warning behavior
- [Phase 3] `git blame -L 1856,1887`: bug introduced by
  `55aa33c3fe3876`, original function by `30d95a37f46d1`
- [Phase 3] `git show 55aa33c3fe3876`: confirmed refactor moved
  `kstrtoint` before `get_access` while keeping `goto out`
- [Phase 3] `git show 30d95a37f46d1`: original code had
  `pm_runtime_get_sync` before `kstrtoint` (correct pairing)
- [Phase 3] `git merge-base --is-ancestor 55aa33c3fe3876 HEAD`: buggy
  commit IS in v6.18.44
- [Phase 3] `git tag --contains 55aa33c3fe3876`: present since v6.18-rc1
- [Phase 4] `b4 dig -c a4b0c3f5d2287`: no lore match (patch on
  freedesktop.org)
- [Phase 4] Fetched https://lists.freedesktop.org/archives/amd-
  gfx/2026-May/145516.html: confirmed patch content and series context
- [Phase 5] Grep for `goto out` in `amdgpu_pm.c`: only smartshift_bias
  has parse-before-get with unconditional put at `out`
- [Phase 5] Confirmed `AMDGPU_DEVICE_ATTR_RW(smartshift_bias)`
  registration at line 2544
- [Phase 6] `git describe HEAD` = v6.18.44; `make kernelversion` =
  6.18.44
- [Phase 6] `git merge-base --is-ancestor a4b0c3f5d2287 HEAD`: fix NOT
  in current tree
- [Phase 6] Compared current code to provided diff: exact match, clean
  apply expected
- [Phase 8] Confirmed failure mode via `rpm_drop_usage_count` underflow
  path
- [UNVERIFIED] No runtime test of actual sysfs write triggering the
  warning

**YES**The background searches finished and match the earlier analysis:

- The fix exists in the repo as `a4b0c3f5d2287` / `b9dcdc6fd5e2d`, but
  it is **not** in the current `stable/linux-6.18.y` checkout at
  v6.18.44.
- The buggy code from `55aa33c3fe3876` **is** present in this tree.

Verdict remains **YES** for backporting to this 6.18.y tree.

 drivers/gpu/drm/amd/pm/amdgpu_pm.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/amd/pm/amdgpu_pm.c b/drivers/gpu/drm/amd/pm/amdgpu_pm.c
index 94c534c1d0bed..d253b974223c6 100644
--- a/drivers/gpu/drm/amd/pm/amdgpu_pm.c
+++ b/drivers/gpu/drm/amd/pm/amdgpu_pm.c
@@ -1859,12 +1859,12 @@ static ssize_t amdgpu_set_smartshift_bias(struct device *dev,
 {
 	struct drm_device *ddev = dev_get_drvdata(dev);
 	struct amdgpu_device *adev = drm_to_adev(ddev);
-	int r = 0;
+	int r;
 	int bias = 0;
 
 	r = kstrtoint(buf, 10, &bias);
 	if (r)
-		goto out;
+		return r;
 
 	r = amdgpu_pm_get_access(adev);
 	if (r < 0)
@@ -1876,14 +1876,12 @@ static ssize_t amdgpu_set_smartshift_bias(struct device *dev,
 		bias = AMDGPU_SMARTSHIFT_MIN_BIAS;
 
 	amdgpu_smartshift_bias = bias;
-	r = count;
 
 	/* TODO: update bias level with SMU message */
 
-out:
 	amdgpu_pm_put_access(adev);
 
-	return r;
+	return count;
 }
 
 static int ss_power_attr_update(struct amdgpu_device *adev, struct amdgpu_device_attr *attr,
-- 
2.53.0

