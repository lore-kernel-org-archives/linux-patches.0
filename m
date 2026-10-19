Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 426134C4606;
	Mon, 19 Oct 2026 14:01:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418472; cv=none; b=jV0jRuHKWRrhAcoP1nhPJ/8WhHcq04I4DmNNjhQUaVPCiThbP+EanS6Yrsjz0Lv5FoldB4NGZ24z/lvOzTHeG9Akskzozs+TYfwxkUxusQFKvV3qbKZg1XSh2JkGD+BK5gwjjH/QcN5CmOxq/8wBjv8pVm5u4VMxv1HTfEwhdw4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418472; c=relaxed/simple;
	bh=Bgs8nsbCp+tgvjP5B+4k3VHCj367cj7VXupzgpKtVSM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=A4oB/1fZ4MndUCftOeswnXYp6fSX6dI+gOEvmSUoVwaDZ/gHjvSj1t65leEHQSN2q85szm/vUoBVJ4/NhAx4rOVQkaYkvvZdqkczKaxBvI2VHQX5MPMsAWW1LRhD/bNpXVhZ3Narnr5YkV1pZtKyKyFqYFTmHKa6SXyQOX5Lvuw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LY4J83kL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LY4J83kL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0897F1F000C4;
	Mon, 19 Oct 2026 14:01:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418469;
	bh=1pBPNFEO0meoCcIWDnS/H5lw/oRXuQ7DEnRFhYwttSE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LY4J83kLVSektUJpgCzqlxZBeoCbI2DiVZxXWQiINQbEnARTK7dgaGiiDOSXakEUf
	 s+D+kIH834oATgw5Ew6FPV4XL9WfE/z5gubGfC8vjmRSlUMWIBzVITkE76+Gv2x9a6
	 N5UtSCtggMSiRAXprNGbpdOf2w3EtnKO/tDNfDqra93nSXP97Q51o+sHIxMOMWiENN
	 K+EmDrKrwdMS/Bzj9lRMY7NvhZ5QCPAmtqQhhWbbHIcV2SgqJ+CtY/4H3lxmGYVH9A
	 7ocxS3lQadY1RVqYZe0xzX5JrPMl5ou7EUhWGxJZev5t3XSYMpaL6MPu57kjwnsJAi
	 CSm+ILKKliukA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: YiPeng Chai <YiPeng.Chai@amd.com>,
	Tao Zhou <tao.zhou1@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	christian.koenig@amd.com,
	airlied@gmail.com,
	simona@ffwll.ch,
	amd-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.1] drm/amdgpu: add bounds check to prevent array overflow
Date: Mon, 19 Oct 2026 09:49:21 -0400
Message-ID: <20261019135441.1420968-270-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261019135441.1420968-1-sashal@kernel.org>
References: <20261019135441.1420968-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.57
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: YiPeng Chai <YiPeng.Chai@amd.com>

[ Upstream commit db15c49a17b8fab9ada38f3a548e5353d7d6b1a8 ]

Add bounds check to prevent array overflow.

v2:
  Add warning messages.

Signed-off-by: YiPeng Chai <YiPeng.Chai@amd.com>
Reviewed-by: Tao Zhou <tao.zhou1@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The local tree is **6.18.53**. The unbounded write into
`mce_adev_list.devs[]` is present in that base; this is a 7-line
overflow guard for that array.

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

Step 1.1: PARSE THE SUBJECT LINE
Record: **[drm/amdgpu] [add] bounds check to prevent array overflow**

Step 1.2: PARSE ALL COMMIT MESSAGE TAGS
Record:
- Signed-off-by: YiPeng Chai (author)
- Reviewed-by: Tao Zhou
- Signed-off-by: Alex Deucher (amdgpu maintainer)
- No Fixes:, Reported-by, Tested-by, Link:, or Cc: stable (absence is
  expected)
- Pipeline-only tags ignored: `[Upstream commit db15c49a17b8…]`, Signed-
  off-by: Sasha Levin

Step 1.3: ANALYZE THE COMMIT BODY TEXT
Record:
- Bug: write into `mce_adev_list.devs[]` with no cap vs
  `MAX_GPU_INSTANCE` (64)
- Symptom: kernel array overflow / adjacent BSS corruption
- Version info: none in the message
- Root cause: registration does `devs[num_gpu++] = adev` with no
  capacity check (the sibling `amdgpu_register_gpu_instance()` has had
  that check since 2018)

Step 1.4: DETECT HIDDEN BUG FIXES
Record: Not disguised. It is an explicit overflow fix. v2 only adds a
ratelimited warning.

===============================================================
PHASE 2: DIFF ANALYSIS
===============================================================

Step 2.1: INVENTORY THE CHANGES
Record:
- File: `drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c` (+7 / −0)
- Function: `amdgpu_register_bad_pages_mca_notifier()`
- Scope: single-file surgical fix

Step 2.2: UNDERSTAND THE CODE FLOW CHANGE
Record:
- Before: always `mce_adev_list.devs[mce_adev_list.num_gpu++] = adev`,
  then register the MCE decode chain once
- After: if `num_gpu >= MAX_GPU_INSTANCE`, warn and return; otherwise
  same as before
- Path: device init / RAS recovery init, not the MCE hot path

Step 2.3: IDENTIFY THE BUG MECHANISM
Record:
- Category: **buffer overflow / out-of-bounds write**
- Mechanism: `devs` is `struct amdgpu_device *devs[MAX_GPU_INSTANCE]`
  (64). Index 64 is past the array and lands on `num_gpu` and the
  following BSS. A pointer-sized store there corrupts static driver
  state.
- Fix: same capacity check already used for `mgpu_info` in
  `amdgpu_kms.c`

Step 2.4: ASSESS THE FIX QUALITY
Record:
- Obviously correct; no API/lock/data-structure change
- Early return only skips adding a 65th device; the decode chain is
  already registered by GPU 0
- Regression risk: **very low** (warn + return). Skipping page-
  retirement for a 65th Aldebaran is safer than overflowing

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

Step 3.1: BLAME THE CHANGED LINES
Record:
- Unbounded store introduced in `91a1a52d03aa0f` (Mukul Joshi,
  2021-09-20): “Fix RAS page retirement with mode2 reset on Aldebaran”
- Present in this 6.18.53 tree (`git merge-base --is-ancestor
  91a1a52d03aa0f v6.18.53` succeeded)

Step 3.2: FOLLOW THE FIXES: TAG
Record: No Fixes: tag. Introducer is `91a1a52d03aa0f`, in this tree.

Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES
Record:
- This tree has **no** `amdgpu_unregister_bad_pages_mca_notifier` (that
  landed later, ~Nov 2025 on amd-gfx)
- `amdgpu_ras_recovery_fini()` / `amdgpu_driver_unload_kms()` never
  shrink `mce_adev_list`
- GPU reset unregisters `mgpu_info` and re-adds it; it does **not** re-
  run `amdgpu_ras_recovery_init()`, so reset does not grow this list
- Series mate patch 2/2 (`drm/amd/ras: use IS_ERR() to check thread
  creation result`) touches `rascore/ras_process.c` and is independent

Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS
Record: YiPeng Chai is a regular amdgpu RAS contributor. Tao Zhou
reviewed; Alex Deucher applied. Not a drive-by change.

Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS
Record: None. The register function in v6.18.53 matches the parent hunk.
Applies standalone.

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION
Record:
- `b4 dig -c db15c49a17b8…` →
  https://patch.msgid.link/20260616093753.4142104-1-YiPeng.Chai@amd.com
- v1 (2026-06-16): check only, silent return
- v2 (same day): added `dev_warn_ratelimited`
- Tao Zhou (v1): “do we need to add warning message for it?” — that is
  the only review request
- No NAKs, no stable discussion, no user crash report

Step 4.2: CHECK WHO REVIEWED THE PATCH
Record (`b4 dig -w`): amd-gfx, Hawking Zhang, Tao Zhou, Candice Li. Tao
Zhou: Reviewed-by on v2. Alex Deucher signed off.

Step 4.3: SEARCH FOR THE BUG REPORT
Record: No syzbot, bugzilla, or user report found. Looks like an
internal correctness/static-analysis fix, not a field crash.

Step 4.4: CHECK FOR RELATED PATCHES AND SERIES
Record:
- 2-patch series; 2/2 is an unrelated `kthread_run` IS_ERR check
- Related later work: “Unregister mce notifier” (Nov 2025) — **not in
  this 6.18.53 tree**, so the list never shrinks here. That makes
  overflow easier to hit than on later mainline

Step 4.5: CHECK STABLE MAILING LIST HISTORY
Record: No lore.kernel.org/stable hit for this subject. lore.kernel.org
fetches returned 403; mail-archive + b4 were used instead.

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

Step 5.1: IDENTIFY KEY FUNCTIONS
Record: `amdgpu_register_bad_pages_mca_notifier()` (modified). Related:
`find_adev()`, `amdgpu_bad_page_notifier()`,
`amdgpu_ras_recovery_init()`. semcode MCP not available; used grep/read.

Step 5.2: TRACE CALLERS
Record:
- Only caller: `amdgpu_ras_recovery_init()` when `CONFIG_X86_MCE_AMD`,
  `asic_type == CHIP_ALDEBARAN`, and `adev->gmc.xgmi.connected_to_cpu`
- That is called only from `amdgpu_device_init()` (not from reset
  reinit)
- `amdgpu_device_init()` ← `amdgpu_driver_load_kms()` ← PCI probe
- `amdgpu_pci_remove()` → `amdgpu_driver_unload_kms()` does **not** drop
  the MCE list entry

Step 5.3: TRACE CALLEES
Record: `dev_warn_ratelimited()`, `mce_register_decode_chain()`
(unchanged, still once)

Step 5.4: FOLLOW THE CALL CHAIN
Record:
- Reachable on MI200/MI250 (Aldebaran) CPU-attached XGMI systems (HPC),
  with RAS enabled
- Not a syscall; probe/unbind-bind
- Unbind/bind without `rmmod` leaves module statics: each successful RAS
  init increments `num_gpu`. After 64 such inits, the next write is OOB

Step 5.5: SEARCH FOR SIMILAR PATTERNS
Record: `amdgpu_register_gpu_instance()` already guards
`mgpu_info.num_gpu >= MAX_GPU_INSTANCE` (blame: `62d73fbcfb3671`, 2018).
This list was a copy without that guard.

===============================================================
PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
===============================================================

Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?
Record: Yes. v6.18.53 has:
`mce_adev_list.devs[mce_adev_list.num_gpu++] = adev;`
with no check. `MAX_GPU_INSTANCE` is 64 in `amdgpu.h`. Introduced 2021,
long before 6.18.

Step 6.2: CHECK FOR BACKPORT COMPLICATIONS
Record: **Clean apply**. v6.18.53 function body matches the parent hunk
(no unregister helper in this tree; not required).

Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE
Record: No other overflow guard or unregister for `mce_adev_list` in
v6.18.53.

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY
Record: drm/amdgpu RAS / x86 MCE decode. **IMPORTANT** for
Aldebaran+XGMI-to-CPU, not core kernel. Still kernel-memory corruption
if it fires.

Step 7.2: ASSESS SUBSYSTEM ACTIVITY
Record: amdgpu RAS is actively maintained; this particular list has been
unchanged since 2021 except later unregister (not in 6.18).

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

Step 8.1: DETERMINE WHO IS AFFECTED
Record: Driver- and config-specific: `CONFIG_DRM_AMDGPU` +
`CONFIG_X86_MCE_AMD` + Aldebaran (PCI 1002:7408/740C/740F/7410) with
host-GPU XGMI. Real HPC/Instinct users exist; not all amdgpu laptops.

Step 8.2: DETERMINE THE TRIGGER CONDITIONS
Record:
- 65+ registrations into a 64-slot array
- A node with 65 Aldebaran GPUs is not realistic
- **In this tree**, no unregister: PCI unbind/bind (or probe after a
  failed teardown that still completed RAS init) grows the list. 64
  cycles is uncommon but a real admin/debug path
- Unprivileged users cannot typically drive 64 GPU rebinds

Step 8.3: DETERMINE THE FAILURE MODE SEVERITY
Record: OOB write of an `amdgpu_device *` past `devs[]` into `num_gpu`
and following BSS → memory corruption, then likely oops on later
MCE/list walk. Severity **HIGH** when hit; likelihood **LOW**.

Step 8.4: CALCULATE RISK-BENEFIT RATIO
Record:
- Benefit: prevents a real overflow on a path this tree never cleans up;
  matches an existing sibling check
- Risk: 7 lines, warn+return, no locking/API change — **very low**
- Ratio: favorable for stable

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

Step 9.1: COMPILE THE EVIDENCE

FOR:
- Real unbounded store into a 64-entry static array (memory safety)
- Buggy code is in 6.18.53 and dates to 2021
- This tree never unregisters, so the counter can climb across
  unbind/bind
- 7-line, obviously correct, same pattern as
  `amdgpu_register_gpu_instance()`
- Reviewed by Tao Zhou; applied by Alex Deucher
- Applies cleanly; no prerequisites

AGAINST:
- Thin commit message; no crash report / syzbot / CVE
- Needs Aldebaran + XGMI-to-CPU + 65 registrations — rare in production
- Series 1/2, but 2/2 is unrelated

UNRESOLVED:
- Could not fetch lore.kernel.org (403); used b4 + mail-archive
- No public statement of how the overflow was found (Coverity vs
  internal test)

Step 9.2: APPLY THE STABLE RULES CHECKLIST
1. Obviously correct and tested? **PASS** — trivial bounds check; v2
   reviewed
2. Fixes a real bug that affects users? **PASS** — OOB write; reachable
   if the list is never drained
3. Important issue? **PASS** — kernel memory corruption (HIGH, uncommon
   trigger)
4. Small and contained? **PASS** — +7 lines, one function
5. No new features or APIs? **PASS**
6. Can apply to the local tree? **PASS** — clean against v6.18.53

Step 9.3: CHECK FOR EXCEPTION CATEGORIES
Record: Not a device-ID/quirk/DT/build/docs exception. It is a normal
memory-safety fix.

Step 9.4: MAKE YOUR DECISION
This is a small, obviously correct overflow guard for code that exists
in this 6.18.53 tree. Because 6.18 never removes entries from
`mce_adev_list`, the overflow is more reachable here than on later
kernels that gained unregister. Benefit outweighs risk.

Verification:
- [Phase 1] Tags: author YiPeng Chai, Reviewed-by Tao Zhou, SOB Alex
  Deucher; no Fixes/Reported-by
- [Phase 2] Diff: +7 lines in
  `amdgpu_register_bad_pages_mca_notifier()`; `if (num_gpu >=
  MAX_GPU_INSTANCE) warn; return;`
- [Phase 3] `git blame` v6.18.53: unbounded store from `91a1a52d03aa0f`
  (2021); ancestor of v6.18.53
- [Phase 3] `git merge-base --is-ancestor 4f933b6727c05 v6.18.53` failed
  — fix is not in 6.18.53
- [Phase 3] No unregister in this tree (`git grep unregister_bad_pages`
  empty; `git log --grep="Unregister mce notifier"` empty)
- [Phase 3] Only recovery_init caller of register; reset path does not
  re-call it
- [Phase 4] `b4 dig -c db15c49a17b8`: v1 + v2; Tao asked for a warning;
  v2 Reviewed-by
- [Phase 4] `b4 dig -a`: two revisions, applied is v2
- [Phase 4] `b4 dig -w`: amd-gfx + Hawking Zhang, Tao Zhou, Candice Li
- [Phase 4] Patch 2/2 is IS_ERR on rascore kthread — independent
- [Phase 4] lore.kernel.org WebFetch 403 — UNVERIFIED via lore HTML;
  mail-archive used instead
- [Phase 5] Callers: only Aldebaran + `connected_to_cpu` in
  `amdgpu_ras_recovery_init` ← `amdgpu_device_init` ← PCI probe
- [Phase 5] Remove path: `amdgpu_pci_remove` →
  `amdgpu_driver_unload_kms` does not touch `mce_adev_list`
- [Phase 6] `git describe HEAD`: v6.18.53-5049-g0f0bdc2b0dffb; `make
  kernelversion`: 6.18.53
- [Phase 6] v6.18.53 function matches parent; MAX_GPU_INSTANCE=64
- [Phase 8] Failure mode: OOB write into BSS → corruption/oops; severity
  HIGH, trigger uncommon
- UNVERIFIED: exact discovery method (no public reproducer)

The patch is a 7-line bounds check that stops a real out-of-bounds write
in RAS MCE GPU tracking. The buggy store is in this 6.18.53 tree, the
tree never shrinks the list on teardown, and the change is obviously
correct with negligible regression risk.

**YES**

 drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c
index 16ae44e131ad4..b03d422572589 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c
@@ -4814,6 +4814,13 @@ static void amdgpu_register_bad_pages_mca_notifier(struct amdgpu_device *adev)
 	 * Use this list instead of mgpu_info to find the amdgpu
 	 * device on which the UMC error was reported.
 	 */
+	if (mce_adev_list.num_gpu >= MAX_GPU_INSTANCE) {
+		dev_warn_ratelimited(adev->dev,
+			"mce_adev_list full, skip notifier registration (max=%d)\n",
+			MAX_GPU_INSTANCE);
+		return;
+	}
+
 	mce_adev_list.devs[mce_adev_list.num_gpu++] = adev;
 
 	/*
-- 
2.53.0

