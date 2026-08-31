Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47F0C4A2A55;
	Mon, 31 Aug 2026 13:42:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183741; cv=none; b=CW+HC8Yfex/FCeXvcfk4r46Q+HXWuBXdOpXNT1SLvUfA4lROww29r3ZASCIX9MpEwRqHxkTgZ3+y9hBdHk2PI5il3Pwuc9XP2P54dgssJjPGNSgeYKH6ZSqactiKPPtg2oG9hOYL+PUZUwLv2Rcrrhd4dN27WPv9PCEuPHGlXis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183741; c=relaxed/simple;
	bh=APNPkioo5bL09qGzsxhBDDX78tBFS95e6QLw68aY23c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AblQLl+ruc2muiWIkrlKd4MD84yFlNpman/v39uCdXVKvS33tpIPawY9X0pPKlpst/SRfmQ9MmXR2PU6ZGNXeqi7w8eaR2wXytnirerfShzGn5bm1fdz4aGHucWpI5O15EZEkmPhug0wG/Z1WC2DYUEGy62R2CO9/2ufI9OAAW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mY0IXbVR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mY0IXbVR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D93E71F00ADB;
	Mon, 31 Aug 2026 13:42:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183738;
	bh=hO5fpXgZeak/GWVwQhbEEiS8z/bv3eh4dMt91Ymz94A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mY0IXbVR0zUm5kJ3b6/V78AhMEU9cOxuyWpTmY7KDX1qZtju7UPa55GiGTKj257ir
	 TBl+gKchiNvjkIvj8VllYc65x6/tvxeA+jcx22NloJFflKqbEmIVmTFgfMytHGrOUf
	 7Y5Elcd+sZ+WZdKpkngjgUBRNOinOYD3+It5Ze/QW8/C/s8ECqJ0RB22TM3xHNMfPd
	 qFoFIXIbXservVVO4L3Hev2gLcswDmYLojFik5GcZ0Vpc69n6+75KfrrmwCUjkM2Bk
	 yy9BFAxF37uI4L+4+QVaG0jc9Y7ZIvunBoXQPOnrtDXvcsj2S30LBlLcSoYBcnmJTU
	 VFzeE6ltA+gSA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Candice Li <candice.li@amd.com>,
	Tao Zhou <tao.zhou1@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	christian.koenig@amd.com,
	airlied@gmail.com,
	simona@ffwll.ch,
	amd-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] drm/amdgpu: cap ATOM command table nesting depth
Date: Mon, 31 Aug 2026 09:25:02 -0400
Message-ID: <20260831133314.4125787-274-sashal@kernel.org>
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

[ Upstream commit 27ef1795bc4e47cae838e0a3ced531c549f9b23d ]

Cap nesting at 32 levels with execute_depth and
return -ELOOP when exceeded.

Signed-off-by: Candice Li <candice.li@amd.com>
Reviewed-by: Tao Zhou <tao.zhou1@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: `drm/amdgpu: cap ATOM command table nesting
depth`

**Local tree:** `v6.18.44` (Makefile: 6.18.44)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject line
**Record:** `[drm/amdgpu]` `[cap]` — Limit ATOM BIOS command-table
recursion depth to prevent unbounded `ATOM_OP_CALLTABLE` nesting.

### Step 1.2: Tags
**Record:**
- **Signed-off-by:** Candice Li `<candice.li@amd.com>` (author)
- **Reviewed-by:** Tao Zhou `<tao.zhou1@amd.com>` (AMD reviewer)
- **Signed-off-by:** Alex Deucher `<alexander.deucher@amd.com>` (amdgpu
  maintainer)
- **No** Fixes:, Reported-by:, Tested-by:, Link:, or Cc: stable tags
- **Notable:** Patch is labeled `[PATCH 2/4]` on amd-gfx (May 2026
  security-hardening series); this hunk is self-contained in
  `atom.c`/`atom.h`

### Step 1.3: Body analysis
**Record:**
- **Bug:** Unbounded recursion via `ATOM_OP_CALLTABLE` →
  `amdgpu_atom_execute_table_locked()` can exhaust the kernel stack.
- **Symptom:** Kernel stack overflow (oops/panic) when VBIOS command
  tables nest deeply or cycle.
- **Fix:** Track `execute_depth` in `atom_context`, cap at 32, return
  `-ELOOP` when exceeded.
- **Root cause:** `atom_op_calltable()` recursively calls
  `amdgpu_atom_execute_table_locked()` with no depth limit; present
  since amdgpu’s initial atom interpreter (2015).

### Step 1.4: Hidden bug fix?
**Record:** Yes — despite “cap” wording, this is a defensive bug fix
preventing kernel stack overflow, not a feature or refactor.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory
**Record:**
- `drivers/gpu/drm/amd/amdgpu/atom.c`: +11 lines
- `drivers/gpu/drm/amd/amdgpu/atom.h`: +3 lines
- **Total:** 14 lines added, 0 removed
- **Functions:** `amdgpu_atom_execute_table_locked()`; `struct
  atom_context` extended
- **Scope:** Single-subsystem, surgical, two-file fix

### Step 2.2: Code flow change
**Record:**
- **Hunk 1 (define):** Adds `ATOM_EXECUTE_MAX_DEPTH 32` with comment
  explaining stack-overflow prevention.
- **Hunk 2 (entry):** Before table execution, checks `ctx->execute_depth
  >= 32`, logs `DRM_ERROR`, returns `-ELOOP`; otherwise increments
  depth.
- **Hunk 3 (exit):** On all normal/error exits through `free:`,
  decrements `execute_depth`.
- **Hunk 4 (struct):** Adds `unsigned int execute_depth` to
  `atom_context`.
- **Before:** Unlimited recursive `calltable` op → stack growth until
  overflow.
- **After:** Depth-limited recursion; excess nesting returns error that
  propagates via existing `ctx->abort` handling.

### Step 2.3: Bug mechanism
**Record:**
- **Category:** Memory safety / kernel crash prevention (unbounded stack
  recursion)
- **Mechanism:** `atom_op_calltable()` at line 642 calls
  `amdgpu_atom_execute_table_locked()` recursively. A malicious,
  corrupt, or cyclic VBIOS can nest arbitrarily deep. Each frame
  allocates locals and may call further atom ops on the stack. No prior
  limit existed (`debug_depth` is debug-print-only).

### Step 2.4: Fix quality
**Record:**
- **Quality:** High — standard recursion-depth counter pattern;
  increment on entry, decrement on all `free:` paths.
- **Regression risk:** Very low. Real VBIOS tables do not nest anywhere
  near 32 levels. On limit hit, `-ELOOP` → `ctx->abort = true` →
  controlled `-EINVAL` exit (existing path), not panic.
- **Note:** `execute_depth` is not reset in
  `amdgpu_atom_execute_table()`, but mutex serialization and balanced
  inc/dec within each execution keep it at 0 between top-level calls.
  `atom_context` is `kzalloc()`’d, so field starts at 0.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
**Record:**
- `atom_op_calltable()` introduced in `d38ceaf99ed01` (“drm/amdgpu: add
  core driver (v4)”, 2015-04-20).
- Recursive call to `amdgpu_atom_execute_table_locked()` added in
  `4630d5031cd87` (“drm/amdgpu: check PS, WS index”, 2024-01-11).
- Unbounded recursion bug present throughout amdgpu’s lifetime in this
  tree.

### Step 3.2: Fixes: tag
**Record:** N/A — no Fixes: tag in commit message.

### Step 3.3: Related file history
**Record:** Recent `atom.c` fixes in this tree include:
- `cc9a8e238e42c` — kcalloc NULL check for WS buffer (OOM path)
- `e5f7e4e0a445f` — vbios NULL offset workaround
- `7bfd16d0ec374` — `last_jump_jiffies` initialization
- No prior nesting-depth or recursion-limit fix found.

### Step 3.4: Author context
**Record:** Candice Li is an active AMD amdgpu contributor. Alex Deucher
(maintainer) signed off. Part of a 4-patch May 2026 hardening series
(RAS bounds, atom depth cap, PSP fw validation).

### Step 3.5: Dependencies
**Record:** Standalone — patch 2/4 needs no other series members. No new
APIs, no prerequisite commits. `git apply --check` confirms clean apply
to this tree.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Original discussion
**Record:**
- **URL:** https://lists.freedesktop.org/archives/amd-
  gfx/2026-May/144646.html
- **Series:** Patches 1/4 (RAS CPER bounds), 2/4 (this commit), 4/4 (PSP
  fw_pri_buf validation); patches are independent.
- **Review feedback:** No NAKs or stable nominations found in fetched
  thread; patch is minimal with maintainer sign-off.
- **b4 dig:** Failed to match commit `27ef1795bc4e` on lore (amd-gfx
  list, not lore.kernel.org).

### Step 4.2: Reviewers
**Record:** Reviewed-by Tao Zhou (AMD); Signed-off-by Alex Deucher
(amdgpu maintainer). Submitted to amd-gfx@lists.freedesktop.org.

### Step 4.3: Bug reports
**Record:** No Reported-by:, syzbot, or bugzilla links. Issue identified
proactively as part of security hardening (comment explicitly cites
stack overflow).

### Step 4.4: Related patches
**Record:** Sibling patches address separate bounds-check issues
(userspace RAS ioctl, PSP firmware copy size). Not required for this
fix.

### Step 4.5: Stable list
**Record:** lore.kernel.org/stable search blocked (bot protection). No
stable-list discussion verified.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key functions
**Record:** `amdgpu_atom_execute_table_locked()`, `atom_op_calltable()`,
`amdgpu_atom_execute_table()`.

### Step 5.2: Callers
**Record:** `amdgpu_atom_execute_table()` is widely used across amdgpu:
- Display: `atombios_encoders.c`, `atombios_crtc.c`, `atombios_dp.c`,
  `command_table.c`
- PM: `ppatomctrl.c`, `ppatomfwctrl.c`, `smu_v11_0.c`, `smu_v12_0.c`
- Init: `amdgpu_atombios.c`, `amdgpu_atomfirmware.c`, `atom.c`
  (`ATOM_CMD_INIT`)
- Called during GPU probe, mode set, power management, and display
  hotplug — common operational paths.

### Step 5.3: Callees
**Record:** Recursive path: `atom_op_calltable()` →
`amdgpu_atom_execute_table_locked()`. Uses `kcalloc()` for workspace
(heap), but each stack frame still carries locals and interpreter state.

### Step 5.4: Reachability
**Record:** Triggered when amdgpu parses/executes VBIOS ATOM command
tables during normal driver operation (probe, display, PM). VBIOS
content comes from GPU ROM; can also be attacker-influenced via VFIO GPU
passthrough (guest-supplied VBIOS) or root-level VBIOS flashing. Not a
direct unprivileged-syscall path, but runs in kernel context on widely
used hardware.

### Step 5.5: Similar patterns
**Record:** No equivalent `execute_depth` / `ATOM_EXECUTE_MAX_DEPTH` in
radeon or other drm atom interpreters in this tree. `debug_depth` in
`atom.c` is unrelated (SDEBUG formatting only).

---

## PHASE 6: CROSS-REFERENCE AGAINST LOCAL TREE (v6.18.44)

### Step 6.1: Buggy code present?
**Record:** **Yes.** `atom_op_calltable()` at lines 632–646 recursively
calls `amdgpu_atom_execute_table_locked()` with no depth check.
`execute_depth` / `ATOM_EXECUTE_MAX_DEPTH` absent (`grep` returns no
matches).

### Step 6.2: Backport complications
**Record:** **Clean apply expected.** `git apply --check` succeeded with
no conflicts. File structure matches patch context.

### Step 6.3: Related fixes already present?
**Record:** **No.** `git log -S "execute_depth"` on amdgpu returns
empty. Fix not already in tree.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: Subsystem criticality
**Record:** **drivers/gpu/drm/amd/amdgpu** — IMPORTANT. Affects all
amdgpu GPU users on probe, display, and PM paths.

### Step 7.2: Subsystem activity
**Record:** Actively maintained; recent atom.c fixes (2024–2025) show
ongoing hardening of the interpreter.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Who is affected
**Record:** All systems with `CONFIG_DRM_AMDGPU` and amdgpu-loaded AMD
GPUs. Config-specific but affects a large user base (desktops, servers,
laptops, cloud GPUs).

### Step 8.2: Trigger conditions
**Record:** VBIOS ATOM command table with `calltable` nesting >32 (or
infinite cycle). Uncommon with legitimate AMD VBIOS, but possible with
corrupt ROM, malicious passthrough VBIOS, or pathological tables.
Requires GPU present and atom table execution.

### Step 8.3: Failure mode severity
**Record:** **CRITICAL** without fix — kernel stack overflow →
oops/panic, potential security implications. **MEDIUM** with fix —
controlled error return, display/PM operation may fail but system stays
up.

### Step 8.4: Risk-benefit
**Record:**
- **Benefit:** HIGH — prevents kernel crash from unbounded recursion in
  widely-used code path.
- **Risk:** VERY LOW — 14-line defensive bound, maintainer-reviewed, no
  API changes.
- **Ratio:** Strongly favors backport.

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence summary

**FOR backport:**
- Fixes real unbounded-recursion bug present since amdgpu inception
- Prevents kernel stack overflow (crash-class issue)
- Small (14 lines), obviously correct, maintainer-signed
- Applies cleanly to v6.18.44
- Standalone — no series dependencies
- Graceful degradation on limit hit (existing abort path)

**AGAINST backport:**
- No user/syzbot report in commit message
- Trigger requires pathological VBIOS (uncommon on bare metal)
- Not directly reachable from unprivileged userspace without GPU
  passthrough or root

**Unresolved:** Whether any legitimate production VBIOS exceeds 32
nesting levels (unverified; considered very unlikely given AMD’s own
32-level cap choice).

### Step 9.2: Stable rules checklist
1. Obviously correct and tested? **PASS** — standard depth counter;
   Reviewed-by + maintainer SOB; logic verifiable by inspection.
2. Fixes a real bug? **PASS** — unbounded recursion can overflow kernel
   stack.
3. Important issue? **PASS** — kernel crash / potential security impact
   (CRITICAL severity).
4. Small and contained? **PASS** — 14 lines, 2 files.
5. No new features/APIs? **PASS** — internal defensive bound only.
6. Can apply to local tree? **PASS** — buggy code present, patch applies
   cleanly.

### Step 9.3: Exception categories
**Record:** N/A (not device ID, quirk, DT, build, or docs). Qualifies as
a critical bug-fix.

### Step 9.4: Decision rationale
For **v6.18.44**, the vulnerable unbounded-recursion code is present and
the fix is absent. The patch is minimal, self-contained, maintainer-
approved, and prevents a kernel stack overflow in a core amdgpu code
path used during normal GPU operation. Trigger rarity does not outweigh
crash severity for stable trees.

---

## Verification

- [Phase 1] Parsed subject, tags, body; identified as stack-overflow
  prevention fix
- [Phase 1] Confirmed patch is `[PATCH 2/4]` but self-contained
- [Phase 2] Diff analysis: +14 lines in `atom.c`/`atom.h`; depth check
  at entry, decrement at `free:`
- [Phase 2] Verified `atom_op_calltable()` recursive call at line 642
- [Phase 2] Verified `debug_depth` is debug-only (lines 95, 1259, 1282),
  not a safety limit
- [Phase 3] `git blame`: `atom_op_calltable` from 2015 (`d38ceaf99ed01`)
- [Phase 3] `git log -S "execute_depth"`: empty — fix not in tree
- [Phase 3] `git log --oneline -20 -- atom.c`: recent hardening commits,
  no depth cap
- [Phase 3] `git apply --check`: patch applies cleanly
- [Phase 4] WebFetch amd-gfx/144646.html: original submission found
- [Phase 4] WebFetch amd-gfx/144645.html: patch 1/4 is independent RAS
  fix
- [Phase 4] `b4 dig -c 27ef1795bc4e`: no lore match (amd-gfx list)
- [Phase 4] lore.kernel.org/stable: blocked by bot protection —
  UNVERIFIED
- [Phase 5] `grep amdgpu_atom_execute_table`: 30+ call sites across
  display/PM/init
- [Phase 5] Traced recursion: `atom_op_calltable` →
  `amdgpu_atom_execute_table_locked`
- [Phase 5] Verified `-ELOOP` propagates via `ctx->abort = true` (lines
  643–645)
- [Phase 6] `git describe HEAD`: v6.18.44
- [Phase 6] `grep execute_depth|ATOM_EXECUTE_MAX_DEPTH`: no matches —
  bug present, fix absent
- [Phase 6] `amdgpu_atom_parse` uses `kzalloc` (line 1527) —
  `execute_depth` starts at 0
- [Phase 6] `mutex_lock` in `amdgpu_atom_execute_table` (line 1295) —
  serializes execution
- [Phase 8] Failure mode: stack overflow without fix = CRITICAL; with
  fix = controlled error

**YES**The background checks finished and match the earlier analysis:

- **Related-commit search** — No amdgpu fix for ATOM nesting depth or
  `ATOM_EXECUTE` in this tree; only unrelated “stack overflow” hits
  elsewhere.
- **Fix-already-present check** — `execute_depth` /
  `ATOM_EXECUTE_MAX_DEPTH` never appear in amdgpu history here; the
  vulnerable recursive `atom_op_calltable()` path is still present on
  **v6.18.44**.

That supports the **YES** backport verdict: the bug exists locally, the
fix is missing, and the patch should apply cleanly.

 drivers/gpu/drm/amd/amdgpu/atom.c | 11 +++++++++++
 drivers/gpu/drm/amd/amdgpu/atom.h |  3 +++
 2 files changed, 14 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/atom.c b/drivers/gpu/drm/amd/amdgpu/atom.c
index 7a063e44d4298..639649ef6dd03 100644
--- a/drivers/gpu/drm/amd/amdgpu/atom.c
+++ b/drivers/gpu/drm/amd/amdgpu/atom.c
@@ -59,6 +59,9 @@
 
 #define ATOM_CMD_TIMEOUT_SEC	20
 
+/* Limit ATOM command table recursion (calltable) to avoid kernel stack overflow. */
+#define ATOM_EXECUTE_MAX_DEPTH	32
+
 typedef struct {
 	struct atom_context *ctx;
 	uint32_t *ps, *ws;
@@ -1229,6 +1232,13 @@ static int amdgpu_atom_execute_table_locked(struct atom_context *ctx, int index,
 	if (!base)
 		return -EINVAL;
 
+	if (ctx->execute_depth >= ATOM_EXECUTE_MAX_DEPTH) {
+		DRM_ERROR("atombios command table nesting exceeded limit (%u)\n",
+			  ATOM_EXECUTE_MAX_DEPTH);
+		return -ELOOP;
+	}
+	ctx->execute_depth++;
+
 	len = CU16(base + ATOM_CT_SIZE_PTR);
 	ws = CU8(base + ATOM_CT_WS_PTR);
 	ps = CU8(base + ATOM_CT_PS_PTR) & ATOM_CT_PS_MASK;
@@ -1285,6 +1295,7 @@ static int amdgpu_atom_execute_table_locked(struct atom_context *ctx, int index,
 free:
 	if (ws)
 		kfree(ectx.ws);
+	ctx->execute_depth--;
 	return ret;
 }
 
diff --git a/drivers/gpu/drm/amd/amdgpu/atom.h b/drivers/gpu/drm/amd/amdgpu/atom.h
index 825ff28731f52..bb3d9eb7eb6b5 100644
--- a/drivers/gpu/drm/amd/amdgpu/atom.h
+++ b/drivers/gpu/drm/amd/amdgpu/atom.h
@@ -153,6 +153,9 @@ struct atom_context {
 	uint8_t vbios_ver_str[STRLEN_NORMAL];
 	uint8_t date[STRLEN_NORMAL];
 	uint8_t build_num[STRLEN_NORMAL];
+
+	/* Nesting depth for ATOM_OP_CALLTABLE */
+	unsigned int execute_depth;
 };
 
 extern int amdgpu_atom_debug;
-- 
2.53.0

