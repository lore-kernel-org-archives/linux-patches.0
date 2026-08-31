Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05C125678ED;
	Mon, 31 Aug 2026 13:48:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184089; cv=none; b=gOTy/4mNc9UrnMmIvbkknCbtj7DuUcWGYJd/k3GSPQyE6/CCkrbUjU4hWiGeu0DMt2D3dVQAy3BPnaiF951SNQjYao91AiReUovABxWER7GRo3I18N1yKmTmKUulaGwuvrSzAt6Yhe7GVwMZpkQEK6iy6XxQsOCJVDsC0MEGtFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184089; c=relaxed/simple;
	bh=HPh1+K8z50chjoh1AS4lqFYWOSmTGRbB3wRmetVIK2g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XnKpUNi5N2jNhs2kqm0gVzNCRJNIqEgMYTjFWeV2d7H7LYSDCCNG6i6RjY0J40BYZR8Hf/kruvY08+HFySCcFA2OqoaTAvlEkEjtESoDbJWoUBC1CJEf0jbYY1JkKE5Y4J059POFmVBo9CY2GYlJdrcThzUY7wBKoyQmVG2blac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=djE6Z8hs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="djE6Z8hs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EDF81F00A3E;
	Mon, 31 Aug 2026 13:48:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788184085;
	bh=0d9n3jwUIqfDYpN8X4JkH/rBGvoUBMz3sO4aQ/1nhGk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=djE6Z8hscfvq+XKrDOKhCtHrEBjGonbShOeWEhY7Ydt+eBqrHWNPt7SvQfm6pyVxD
	 91vO9krGyGWpeuB/iD+OQgLaRHajJMpOK7pYiIypjm92U+zuROJ8C8MILsxnBb9KaK
	 zVLP0uNQRJJvwii4T7LGxY99GJxsdvmTU7CYWxLjcb3bP/FRltYg0wYWwZCmn/Yd39
	 4y1qWCGHXnYh+kkN+UhgyUqFuU4XbckZWYdsoZ2sinrwLKDU77Gc4EwGbge+2O/Ad6
	 Wy9MnaoEtGjTbH4JS09ZYytSMEwcaLbANyaovt7Ktj+U2V3iPv/+OqnS50QuAjlD6c
	 x2ycBzvJLR56A==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Lijo Lazar <lijo.lazar@amd.com>,
	Asad Kamal <asad.kamal@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	kenneth.feng@amd.com,
	christian.koenig@amd.com,
	airlied@gmail.com,
	simona@ffwll.ch,
	amd-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.6] drm/amd/pm: Check SMUv13.0.6/12 metrics integrity
Date: Mon, 31 Aug 2026 09:28:30 -0400
Message-ID: <20260831133314.4125787-482-sashal@kernel.org>
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

From: Lijo Lazar <lijo.lazar@amd.com>

[ Upstream commit 6fc63d80c01a480e3d2c98620f07d46e5bcfc85a ]

Check if data fetch is proper by matching the first few bytes against
0xFFs. If 0xFFs, that means data couldn't be read properly.

Signed-off-by: Lijo Lazar <lijo.lazar@amd.com>
Reviewed-by: Asad Kamal <asad.kamal@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: `drm/amd/pm: Check SMUv13.0.6/12 metrics
integrity`

**Local tree:** `v6.18.43` (Linux 6.18.43)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject line
**Record:** `[drm/amd/pm]` `[Check]` — Add integrity validation for SMU
v13.0.6/12 metrics table reads.

### Step 1.2: Tags
**Record:**
- `Signed-off-by: Lijo Lazar <lijo.lazar@amd.com>` (author)
- `Reviewed-by: Asad Kamal <asad.kamal@amd.com>`
- `Signed-off-by: Alex Deucher <alexander.deucher@amd.com>` (AMD DRM
  maintainer)
- No `Fixes:`, `Reported-by:`, `Link:`, `Cc: stable@vger.kernel.org`, or
  `Tested-by:`

Notable: AMD maintainer review and sign-off, but no public bug report or
fuzzer report.

### Step 1.3: Body analysis
**Record:**
- **Bug:** SMU metrics table fetch can succeed at the SMC-message level
  while the copied data is invalid (all `0xFF`, meaning unread).
- **Symptom:** Driver treats poisoned/unread data as valid metrics.
- **Root cause:** No post-copy validation after `GetMetricsTable` +
  VRAM/CPU copy.
- **Fix:** Check first 16 bytes with `memchr_inv()`; if all `0xFF`,
  return `-EHWPOISON`.
- No kernel version or hardware list in the message; subject names
  SMUv13.0.6/12.

### Step 1.4: Hidden bug fix?
**Record:** Yes. Despite “Check” wording, this is a real correctness bug
fix: it stops silently consuming invalid SMU metrics that would
otherwise drive power limits, clock tables, sysfs metrics, and XGMI
configuration.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory
**Record:**
- **File:** `drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_6_ppt.c` (+4
  lines)
- **Function:** `smu_v13_0_6_get_metrics_table()`
- **Scope:** Single-file, surgical fix

Note: upstream diff context uses `amdgpu_hdp_invalidate()` +
`smu_cmn_vram_cpy()`. This tree uses `amdgpu_asic_invalidate_hdp()` +
`memcpy()` — same logical point, different API names.

### Step 2.2: Code flow change
**Record:**
- **Before:** After SMC message + copy, metrics are cached and returned
  unconditionally.
- **After:** After copy, if first `min(16, table_size)` bytes are all
  `0xFF`, return `-EHWPOISON` and do not update `metrics_time`.
- **Path:** Metrics refresh path (cache bypass or >1 ms stale).

### Step 2.3: Bug mechanism
**Record:**
- **Category:** Memory/hardware data integrity / logic correctness
- **Mechanism:** Uninitialized or failed VRAM read leaves `0xFF`
  pattern; driver previously treated it as valid. With all-`0xFF` data,
  `AccumulationCounter` appears non-zero, so
  `smu_v13_0_6_setup_driver_pptable()` can exit its retry loop
  immediately and write garbage into `pptable` (power limits, clock
  tables, serial numbers). The fix detects poisoned data before
  caching/propagation.

### Step 2.4: Fix quality
**Record:**
- Obviously correct: `0xFF` fill is a standard “unread” sentinel;
  `memchr_inv()` is used elsewhere in the kernel for this pattern (e.g.
  `amd_pmf` policy buffer validation).
- Minimal (4 lines), no API changes.
- Low regression risk: only triggers on fully-`0xFF` prefix; legitimate
  metrics are unaffected.
- `-EHWPOISON` is already used in amdgpu for hardware data integrity
  failures.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
**Record:** `smu_v13_0_6_get_metrics_table()` at lines 750–778 is
present in this tree; blame points to merge commit `5d324e5159d9e`
(history is flattened through merges). The vulnerable function exists in
v6.18.43.

### Step 3.2: Fixes tag
**Record:** N/A — no `Fixes:` tag.

### Step 3.3: Related file history
**Record:** Recent PM commits in this tree include `75849e13e428e` (xgmi
max speed reporting) and `33c3a4db31719` (invalid energy_accumulator on
smu v13.0.x). No duplicate integrity-check fix found. This commit is not
in this tree yet (`git log --grep` returned nothing).

### Step 3.4: Author context
**Record:** Lijo Lazar is an active AMD PM contributor (`75849e13e428e`
xgmi fix in this tree). Patch reviewed by fellow AMD engineer Asad Kamal
and maintainer Alex Deucher.

### Step 3.5: Dependencies
**Record:** Standalone. `memchr_inv()` and `-EHWPOISON` are available.
Backport inserts after the local copy call (`memcpy`), not upstream’s
`smu_cmn_vram_cpy`.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Original discussion
**Record:** Patch submitted to amd-gfx on 2026-04-18 by Lijo Lazar.
Thread: https://lists.freedesktop.org/archives/amd-
gfx/2026-April/143042.html (also mirrored at yhbt.net). Included in Alex
Deucher’s drm-next-7.2 pull. `b4 dig -c` could not be run (commit not in
this checkout). lore.kernel.org direct fetch blocked (bot protection).

### Step 4.2: Reviewers
**Record:** CC’d Hawking.Zhang, Alexander.Deucher, Asad.Kamal. Asad
Kamal replied 2026-04-20 (Reviewed-by in final commit). No NAKs found.

### Step 4.3: Bug report
**Record:** No public bug report, syzbot, or Bugzilla link. Likely
internal AMD testing discovery.

### Step 4.4: Series context
**Record:** Standalone 1-patch fix, not part of a multi-patch series.

### Step 4.5: Stable list discussion
**Record:** No stable@ discussion found (UNVERIFIED beyond search; no
stable nomination seen in available sources).

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key functions
**Record:** `smu_v13_0_6_get_metrics_table()` (modified).

### Step 5.2: Callers
**Record:** Direct callers in this tree:
- `smu_v13_0_6_get_pm_metrics()` — sysfs PM metrics (checks `ret`)
- `smu_v13_0_6_setup_driver_pptable()` — DPM init, power/clock limits
  (checks `ret` in retry loop; caller at line 1088 ignores return — pre-
  existing)
- `smu_v13_0_6_get_smu_metrics_data()` — clock/power/thermal sysfs
  (checks `ret`)
- Partition metrics paths at lines 2657, 2758 (check `ret`)
- `smu_v13_0_12_ppt.c:258` — XGMI max speed/width fallback (checks
  `ret`)

### Step 5.3: Callees
**Record:** `smu_cmn_send_smc_msg()`, HDP invalidate, `memcpy()` from
driver table CPU address.

### Step 5.4: Reachability
**Record:** Reachable from GPU init (DPM table setup) and runtime
sysfs/metrics queries on SMU IP 13.0.6 and 13.0.12 hardware (MI300-class
datacenter GPUs). Not a syscall path, but reachable from normal driver
operation on affected hardware.

### Step 5.5: Similar patterns
**Record:** `amd_pmf` uses `memchr_inv(dev->policy_buf, 0xff, ...)` for
the same invalid-read detection pattern. No existing `memchr_inv` +
`0xff` check in amdgpu PM code in this tree.

---

## PHASE 6: CROSS-REFERENCE WITH LOCAL TREE (v6.18.43)

### Step 6.1: Buggy code present?
**Record:** **Yes.** `smu_v13_0_6_get_metrics_table()` at lines 750–778
lacks integrity check. SMU 13.0.6/12 support is wired in `amdgpu_smu.c`
(cases `IP_VERSION(13, 0, 6)` and `IP_VERSION(13, 0, 12)`).

### Step 6.2: Backport difficulty
**Record:** **Clean apply with trivial context adjustment.** Insert
after:

```768:769:drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_6_ppt.c
                amdgpu_asic_invalidate_hdp(smu->adev, NULL);
                memcpy(smu_table->metrics_table, table->cpu_addr,
table_size);
```

### Step 6.3: Related fixes already present?
**Record:** **No.** `grep` found no `memchr_inv` + `0xff` in amdgpu PM.
Commit not in tree history.

---

## PHASE 7: SUBSYSTEM CONTEXT

### Step 7.1: Subsystem and criticality
**Record:** `drivers/gpu/drm/amd/pm` — **IMPORTANT** (AMDGPU power
management for datacenter GPUs; affects power/thermal/clock behavior,
not core kernel).

### Step 7.2: Activity
**Record:** Actively maintained; recent stable-relevant PM fixes in this
tree (xgmi reporting, energy_accumulator invalidation).

---

## PHASE 8: IMPACT AND RISK

### Step 8.1: Who is affected
**Record:** Users of AMD GPUs with SMU firmware IP 13.0.6 or 13.0.12
(MI300/MI325X-class hardware). Config: `CONFIG_DRM_AMDGPU`.

### Step 8.2: Trigger conditions
**Record:** SMU metrics table VRAM read fails or returns uninitialized
`0xFF` data while SMC message succeeds. Can occur during init or runtime
metrics refresh. Not user-triggerable from syscalls; hardware/firmware
timing dependent. Plausible during error recovery or SMU communication
issues.

### Step 8.3: Failure mode severity
**Record:** Without fix: corrupt power limits, clock frequency tables,
thermal/activity metrics, and XGMI parameters derived from `0xFF` data —
risk of incorrect DPM behavior, bogus sysfs readings, and potential
hardware stress. **Severity: HIGH** (incorrect power/clock configuration
from poisoned data). Not a kernel oops, but can cause real hardware
misbehavior.

### Step 8.4: Risk-benefit
**Record:**
- **Benefit:** HIGH for affected datacenter deployments — prevents
  silent use of completely invalid SMU metrics.
- **Risk:** LOW — 4-line defensive check, AMD-reviewed, established
  errno pattern.
- **Ratio:** Strong benefit, minimal risk.

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence summary

**FOR backport:**
- Fixes real bug (silent consumption of unread `0xFF` metrics data)
- Can corrupt power/clock initialization in `setup_driver_pptable()`
- Small, surgical, AMD-maintainer-reviewed
- Code and affected hardware exist in v6.18.43
- Matches existing kernel/amdgpu integrity-check patterns
- Clean backport to this tree

**AGAINST backport:**
- No public bug report or crash trace
- Hardware-specific (MI300-class, niche vs consumer GPUs)
- `setup_driver_pptable()` return still ignored at one call site (pre-
  existing; fix still prevents writing garbage into `pptable`)
- Severity is misconfiguration rather than kernel panic

**Unresolved:** Exact production trigger frequency; no syzbot/user
reports.

### Step 9.2: Stable rules checklist
1. Obviously correct and tested? **PASS** — simple sentinel check;
   Reviewed-by from AMD engineer; maintainer SOB.
2. Fixes real bug affecting users? **PASS** — invalid metrics used for
   PM decisions on real hardware.
3. Important issue? **PASS** — incorrect power/clock limits from
   poisoned SMU data on datacenter GPUs (HIGH severity
   misconfiguration).
4. Small and contained? **PASS** — 4 lines, one function, one file.
5. No new features/APIs? **PASS** — error-path validation only.
6. Can apply to local tree? **PASS** — code present; minor context
   adjustment for `memcpy` vs `smu_cmn_vram_cpy`.

### Step 9.3: Exception categories
**Record:** N/A (not device ID, DT, build fix, or docs). Standard bug
fix.

### Step 9.4: Decision rationale
This patch prevents the driver from silently building power-management
state from completely invalid SMU metrics. On MI300-class hardware in
the 6.18.y tree, a failed metrics read currently produces `0xFF` data
that can populate `pptable` power and clock limits. The fix is minimal,
low-risk, AMD-reviewed, and directly applicable to this checkout.

---

## Verification

- **[Phase 1]** Parsed commit message and tags from user-provided diff
- **[Phase 2]** Read `smu_v13_0_6_get_metrics_table()` at lines 750–778;
  confirmed missing integrity check
- **[Phase 2]** Traced `setup_driver_pptable()` lines 873–942; confirmed
  garbage `0xFF` metrics can populate power/clock limits
- **[Phase 3]** `git describe HEAD` → `v6.18.43`
- **[Phase 3]** `git blame -L 750,778` → function present, no integrity
  check
- **[Phase 3]** `git log --grep="metrics integrity"` → no match (commit
  not in tree)
- **[Phase 3]** `grep memchr_inv.*0xff drivers/gpu/drm/amd/pm` → no
  matches
- **[Phase 4]** Web search found amd-gfx submission (2026-04-18) and
  drm-next-7.2 pull inclusion
- **[Phase 4]** lore.kernel.org fetch failed (bot protection); Asad
  Kamal reply noted via search snippet
- **[Phase 4]** `b4 dig` without commit hash unavailable; commit not in
  local tree
- **[Phase 5]** `grep smu_v13_0_6_get_metrics_table` → 6 call sites in
  `smu_v13_0_6_ppt.c`, 1 in `smu_v13_0_12_ppt.c`
- **[Phase 5]** Verified callers check `ret` (except
  `smu_v13_0_6_setup_driver_pptable()` at line 1088)
- **[Phase 5]** `grep EHWPOISON drivers/gpu/drm/amd` → used in amdgpu
  core (ras, cs, job, kms, xgmi)
- **[Phase 5]** Found `memchr_inv(..., 0xff, ...)` pattern in
  `drivers/platform/x86/amd/pmf/tee-if.c`
- **[Phase 6]** Confirmed `IP_VERSION(13, 0, 6)` and `IP_VERSION(13, 0,
  12)` in `amdgpu_smu.c`
- **[Phase 6]** Confirmed upstream diff context differs
  (`smu_cmn_vram_cpy` vs local `memcpy`); fix placement is equivalent
- **[Phase 7]** `git log --oneline -20 -- drivers/gpu/drm/amd/pm/` →
  active PM maintenance
- **UNVERIFIED:** Exact hardware SKU list beyond IP version 13.0.6/12;
  production incident frequency; full Asad Kamal review thread content

**YES****Verdict: YES** — backport to this tree (`v6.18.43`).

The commit adds a 4-line check in `smu_v13_0_6_get_metrics_table()` so
unread SMU metrics (all `0xFF`) return `-EHWPOISON` instead of being
used for power limits, clock tables, and sysfs metrics on SMU 13.0.6/12
hardware (MI300-class). The buggy code is present in this tree; the
patch applies cleanly after the existing `memcpy()` call.

 drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_6_ppt.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_6_ppt.c b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_6_ppt.c
index 43965b1135fe7..0d065e4073655 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_6_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_6_ppt.c
@@ -768,6 +768,10 @@ int smu_v13_0_6_get_metrics_table(struct smu_context *smu, void *metrics_table,
 		amdgpu_asic_invalidate_hdp(smu->adev, NULL);
 		memcpy(smu_table->metrics_table, table->cpu_addr, table_size);
 
+		if (!memchr_inv(smu_table->metrics_table, 0xff,
+				min(16, table_size)))
+			return -EHWPOISON;
+
 		smu_table->metrics_time = jiffies;
 	}
 
-- 
2.53.0

