Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A0F147087C;
	Mon, 19 Oct 2026 13:55:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418153; cv=none; b=hAyykboN64x5jcQE6+AQH0pFAdU01xme95wRRnx7ZNwg4eIqe3GI16L0GWTRFo3PnnHOGgB/fcZeGzkylS512JOP8sHRx98S7jbLZW8U/PTzzDL0dhzgk0wgqLhALFt8IXDcSg6oJqkXoaw0SfF+rWGRr9WaiK6QBl1h7/7PEvo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418153; c=relaxed/simple;
	bh=idxJTWz9kZBql8/0EeIK+H1f8ChvNnjuFL425CHBp7Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lW0rUfu+GghNID70JcuZVCr/mDdMctKbBY7oQIhvvevUmqfSBC62YGJxHa0ZdtCG1+TM9++aaqPi+wQPyOD9DUSGGovw7SumzOXBQvW8m6YLaclZrDs7yvWfECCmn5WdSw21gSTeajrFnj1zWtKJASsUP1e8yX5/2/2V4CFvNY8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SEo09rZw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SEo09rZw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25AE31F000C5;
	Mon, 19 Oct 2026 13:55:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418151;
	bh=yzhvP2maok5FE2SelQJTFE9TDi5tqPDm3EZJ/Ng2Qgs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SEo09rZwGwllW/KiCk4NbQhnLxQ7dCIpFdfwRDXLlPzCMUcJ3BWlGjQigzJKcbpzp
	 IkCBg1reh8j9gzQg+tVVGrt6ZZAx1rBjrsiDWi9TMpLiQpL4q7oo7fgvATucOFVhYa
	 Aq6KPDZiIvw79RyaCsVsGkOX1EyPn4tGbY/70Wb21XbnvvpWkPTCzHEG933c0r0aZC
	 2r/Cri27M3LEpxvSy43Mj2TmvweF54SWvh63vuivj2zn0WKdVUXMowzMAgb+n8mSws
	 VagIlIgUZ+oV9P13IgYd0TCBALxF5VBRiHYeP/TaruwWEb9L6H0WTaU2ZhSn/zOxnm
	 n1xXboEDqCV4w==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Lijo Lazar <lijo.lazar@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	christian.koenig@amd.com,
	airlied@gmail.com,
	simona@ffwll.ch,
	amd-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] drm/amdgpu: Validate ATPX buffer length before use
Date: Mon, 19 Oct 2026 09:45:39 -0400
Message-ID: <20261019135441.1420968-48-sashal@kernel.org>
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

From: Lijo Lazar <lijo.lazar@amd.com>

[ Upstream commit 916867cd75dbbc383aa6cb724556de769912157a ]

Add amdgpu_atpx_buffer_validate() to check that the returned ACPI
buffer is of type ACPI_TYPE_BUFFER, is large enough to hold the u16
size field, and that the BIOS-reported size does not exceed the actual
allocation length or fall below the minimum required by the caller.
Use it in VERIFY_INTERFACE and GET_PX_PARAMETERS callers.

Signed-off-by: Lijo Lazar <lijo.lazar@amd.com>
Assisted-by: Claude Sonnet (Cursor AI)
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

I have enough to decide: the 6.18.y tree still has the unvalidated ATPX
ACPI path, and the patch is a small, self-contained memory-safety fix.

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

**Step 1.1: PARSE THE SUBJECT LINE**

Record: [drm/amdgpu] [Validate] [Check ACPI ATPX response buffer type
and length before reading the BIOS-reported size and memcpy]

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**

Record:
- Signed-off-by: Lijo Lazar <lijo.lazar@amd.com> (author)
- Assisted-by: Claude Sonnet (Cursor AI)
- Acked-by: Alex Deucher <alexander.deucher@amd.com> (amdgpu maintainer)
- Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
- (pipeline) Signed-off-by: Sasha Levin — ignored per instructions
- (pipeline) `[ Upstream commit 916867cd75dbbc383aa6cb724556de769912157a
  ]` — ignored per instructions
- No Fixes:, Reported-by:, Tested-by:, Link:, or Cc: stable (absence
  expected)

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**

Record:
- Bug: ATPX ACPI responses are used without checking object type, that
  the allocation is large enough to hold the leading `u16` size field,
  or that the BIOS-reported size is within the real ACPI buffer.
- Symptom/failure mode: out-of-bounds read and/or NULL dereference when
  firmware returns a short buffer, a claimed size larger than
  `buffer.length`, or a non-buffer object.
- Version information: none in the message. History shows the pattern
  dates to the original amdgpu ATPX code (2015).
- Root cause: callers did `size = *(u16 *)info->buffer.pointer` then
  `memcpy(..., min(sizeof(output), size))` with only a minimum-size
  check on the BIOS-reported value, never on ACPI type/`buffer.length`.

**Step 1.4: DETECT HIDDEN BUG FIXES**

Record: Not hidden. The subject and body describe a memory-safety
validation fix. It is not cleanup or a feature.

===============================================================
PHASE 2: DIFF ANALYSIS - LINE BY LINE
===============================================================

**Step 2.1: INVENTORY THE CHANGES**

Record:
- File: `drivers/gpu/drm/amd/amdgpu/amdgpu_atpx_handler.c` (+21 / −12)
- Functions: new `amdgpu_atpx_buffer_validate()`; modified
  `amdgpu_atpx_validate()`, `amdgpu_atpx_verify_interface()`
- Scope: single-file surgical fix

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**

Record:
- Hunk 1: add helper that requires non-NULL object, `ACPI_TYPE_BUFFER`,
  `buffer.length >= 2`, `buffer.length >= claimed u16 size`, and
  `claimed size >= min_size`. `&&` short-circuit makes the `u16` load
  safe.
- Hunk 2 (`amdgpu_atpx_validate` / GET_PX_PARAMETERS): old path zeroed
  `output`, loaded claimed size, rejected only `size < 10`, then
  `memcpy` of `min(sizeof(output), size)`. New path validates first,
  then the same bounded copy. `sizeof(struct atpx_px_params)` is 10
  (`u16+u32+u32`, packed), so the minimum is unchanged for valid
  firmware.
- Hunk 3 (`amdgpu_atpx_verify_interface`): same, replacing hardcoded
  `size < 8` with `sizeof(struct atpx_verify_interface)` which is also
  8.

**Step 2.3: IDENTIFY THE BUG MECHANISM**

Record:
- Category: memory safety — OOB read and possible NULL deref on
  firmware-controlled ACPI data
- Mechanism:
  1. No type check. `union acpi_object` overlays `integer` and `buffer`.
     An INTEGER 0 makes `buffer.length` 0 and `buffer.pointer` NULL →
     `*(u16 *)NULL` oops.
  2. No `buffer.length >= sizeof(u16)` check → OOB 2-byte read on
     empty/short buffers.
  3. memcpy used BIOS size capped only by `sizeof(output)`, not by
     `buffer.length`. Example: length=4, claimed size=10 → copy 10 bytes
     from a 4-byte buffer.

**Step 2.4: ASSESS THE FIX QUALITY**

Record:
- Obviously correct; check order is right; min sizes match the old
  hardcoded 8/10.
- Minimal; no API change.
- Regression risk is low: it only rejects responses that were already
  type-confused or out of bounds. A BIOS that “worked” only because
  memcpy read extra heap bytes was already relying on undefined
  behavior.

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

**Step 3.1: BLAME THE CHANGED LINES**

Record: Buggy loads/memcpy introduced in `d38ceaf99ed015` (“drm/amdgpu:
add core driver (v4)”, 2015-06-03), first in v4.2-rc1. Present for the
entire life of amdgpu ATPX. printk→pr_err only in `07867a78f88465`
(2023).

**Step 3.2: FOLLOW THE FIXES: TAG**

Record: No Fixes: tag (expected). Introducing commit is in this tree
(`git merge-base --is-ancestor d38ceaf99ed015 HEAD` succeeded).

**Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**

Record: Sibling series patch 1/2 is `c8373721c3e54` “Validate ATIF
buffer length before use” on `amdgpu_acpi.c`. Independent file. Other
recent ATPX commits are unused-function removal and printk conversion,
not prerequisites. Standalone.

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**

Record: Lijo Lazar is a regular AMD contributor (bounds checks, reset,
ACPI). Maintainer Acked-by/SOB from Alex Deucher.

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**

Record: Submitted as PATCH 2/2 with ATIF 1/2. No shared symbols or
types. ATPX applies alone. radeon still has the old pattern in
`radeon_atpx_handler.c`; that is out of scope, not a dependency.

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**

Record:
- `b4 dig -c 916867cd75db...` and local SHA: lore.kernel.org returned
  errors; no b4 match.
- Fallback: https://www.mail-archive.com/amd-
  gfx@lists.freedesktop.org/msg145005.html (PATCH 2/2, 2026-06-14)
- Review: https://www.mail-archive.com/amd-
  gfx@lists.freedesktop.org/msg145042.html — Alex Deucher: “Series is:
  Acked-by”
- Series: v1 only; no v2/v3; no NAK; no reviewer Cc: stable
- Freedesktop June 2026 index lists the submission and Deucher’s ack
  only

**Step 4.2: CHECK WHO REVIEWED THE PATCH**

Record: Maintainer Alex Deucher acked the series. Recipients from mail-
archive: amd-gfx. b4 -w failed (lore error).

**Step 4.3: SEARCH FOR THE BUG REPORT**

Record: No Reported-by, syzbot, bugzilla, or CVE found. Code-review
hardening against malformed ACPI, not a user reproducer.

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**

Record: 1/2 ATIF (`amdgpu_acpi.c`) is the same class of fix. ATIF
already had `obj->type != ACPI_TYPE_BUFFER`; ATPX `amdgpu_atpx_call()`
never checked type. ATPX does not need 1/2.

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**

Record: lore.kernel.org/stable search returned 403. Web search did not
show a prior stable discussion of this subject. UNVERIFIED whether
anyone already requested or rejected it for stable.

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

**Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF**

Record: `amdgpu_atpx_buffer_validate` (new), `amdgpu_atpx_validate`,
`amdgpu_atpx_verify_interface`

**Step 5.2: TRACE CALLERS**

Record:
- `amdgpu_atpx_verify_interface` / `amdgpu_atpx_validate` ←
  `amdgpu_atpx_init()` ← `amdgpu_atpx_detect()` when ATPX exists and
  there are two VGA-class devices ← `amdgpu_register_atpx_handler()` ←
  `amdgpu_init()` in `amdgpu_drv.c` (module init)
- Gated by `CONFIG_VGA_SWITCHEROO` (x86 + ACPI + PCI hybrid-laptop GPU
  switching)

**Step 5.3: TRACE CALLEES**

Record: `amdgpu_atpx_call()` → `acpi_evaluate_object(...,
ACPI_ALLOCATE_BUFFER)`. On failure other than `AE_NOT_FOUND` it frees
and returns NULL. Success and `AE_NOT_FOUND` return `buffer.pointer`
with **no type check**. Callers only test `if (!info)`.

**Step 5.4: FOLLOW THE CALL CHAIN**

Record: Reachable on amdgpu module load on hybrid PX laptops. Not a
syscall hot path; it is a common boot/probe path for those machines.
Unprivileged users do not trigger it directly; a crash still takes down
the GPU/driver init (and can oops the kernel).

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**

Record: Identical unvalidated pattern remains in
`drivers/gpu/drm/radeon/radeon_atpx_handler.c`. ATIF now validates type
and both sizes. Confirms a systematic ACPI-buffer issue; this patch
covers amdgpu ATPX only.

===============================================================
PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
===============================================================

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**

Record:
- Local tree: `git describe HEAD` = `v6.18.53-5049-g0f0bdc2b0dffb`;
  `Makefile` 6.18.53; branch `autosel`
- Candidate is **not** in `v6.18.53` (`merge-base --is-ancestor` failed)
- `v6.18.53:drivers/gpu/drm/amd/amdgpu/amdgpu_atpx_handler.c` still has
  `size = *(u16 *) info->buffer.pointer` / `size < 10` / `size < 8`
- `git diff v6.18.53 9d367fab451d9^ -- amdgpu_atpx_handler.c` is empty:
  pre-fix file matches 6.18.53
- Bug introduced v4.2; present in this series

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**

Record: Clean apply. Same file content as the commit’s parent. No
refactor since 6.18.53 on these functions.

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**

Record: No earlier ATPX buffer-length fix in this file’s history besides
the candidate. ATIF sibling is also not in v6.18.53; not required.

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

**Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY**

Record: [drm/amdgpu ATPX / vga_switcheroo] [IMPORTANT — common x86
hybrid AMD laptop path, not core mm/vfs, not staging]

**Step 7.2: ASSESS SUBSYSTEM ACTIVITY**

Record: amdgpu is actively developed; this ATPX file is mature (2015)
with occasional quirks. Long-lived bug, not a recent-feature regression.

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

**Step 8.1: DETERMINE WHO IS AFFECTED**

Record: Driver-specific + config-specific: `CONFIG_VGA_SWITCHEROO`
amdgpu users on hybrid PX systems (two GPUs, ATPX ACPI method). Typical
of 2008–2010s and some later A+A laptops. Distro kernels usually enable
VGA_SWITCHEROO on x86.

**Step 8.2: DETERMINE THE TRIGGER CONDITIONS**

Record: Module init / ATPX detect. Needs ATPX plus a malformed ACPI
return (wrong type, length < 2, or claimed size > actual). No evidence
an unprivileged user can inject ACPI here; buggy/malicious firmware can.
No public reproducer. Severity if it hits is a boot-time oops, not a
rare runtime race.

**Step 8.3: DETERMINE THE FAILURE MODE SEVERITY**

Record: NULL deref or OOB read during GPU/hybrid init → kernel oops.
Severity HIGH (crash). Not confirmed privilege escalation. Not data
corruption.

**Step 8.4: CALCULATE RISK-BENEFIT RATIO**

Record:
- Benefit: medium-high for hybrid AMD laptops; prevents oops on bad ATPX
  data; completes validation the driver already attempted.
- Risk: very low (one helper, two call sites, min sizes unchanged).
- Ratio: favorable.

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

**Step 9.1: COMPILE THE EVIDENCE**

FOR:
- Real OOB read / possible NULL deref on ACPI ATPX responses
- Incomplete size check since 2015, present in 6.18.53
- Small, obviously correct, maintainer-acked
- Applies cleanly; no new API; no series dependency
- Boot path on hybrid laptops, not dead code

AGAINST:
- No user/syzbot report
- Trigger needs bad firmware
- ATPX is a shrinking hybrid-laptop population
- Same bug still in radeon (unrelated)

UNRESOLVED:
- b4/lore 403; no stable-list discussion confirmed
- No known machine that actually returns a short/wrong-type ATPX object

**Step 9.2: APPLY THE STABLE RULES CHECKLIST**

1. Obviously correct and tested? **PASS** — helper logic is sound;
   Acked-by amdgpu maintainer
2. Fixes a real bug that affects users? **PASS** — missing type/length
   checks; crash if firmware is wrong
3. Important issue? **PASS** — oops/OOB, HIGH; not a feature
4. Small and contained? **PASS** — +21/−12, one file
5. No new features or APIs? **PASS**
6. Can apply to the local tree? **PASS** — v6.18.53 has the buggy code;
   diff would apply cleanly

**Step 9.3: CHECK FOR EXCEPTION CATEGORIES**

Record: Not a device-ID/quirk/DT/build/docs exception. Standard memory-
safety bug fix.

**Step 9.4: MAKE YOUR DECISION**

This belongs on 6.18.y. The tree still trusts BIOS-reported ATPX sizes
without checking ACPI object type or real buffer length. That can oops
at amdgpu init on hybrid systems. The fix is tiny, matches existing
mins, and was acked by the maintainer.

### What the commit solves for this tree

On `v6.18.53`, `amdgpu_atpx_verify_interface()` and GET_PX_PARAMETERS
still do `*(u16 *)info->buffer.pointer` and memcpy without confirming
`ACPI_TYPE_BUFFER` or that `buffer.length` covers the claimed size.
Wrong-type INTEGER 0 is a NULL deref; a short buffer or oversized
claimed length is an OOB read. Stable 6.18 users of hybrid AMD laptops
hit this on module load if firmware is buggy.

### Risk vs benefit

Benefit is avoiding a probe-time oops. Risk is a few lines of stricter
validation that valid ATPX responses already satisfy (`sizeof` 8 and
10). Sibling ATIF patch is not required.

### Concerns

No field report. radeon is still unfixed. Neither blocks backporting
this amdgpu change.

Verification:
- [Phase 1] Tags: author SOB, Assisted-by Claude, Acked-by/SOB Alex
  Deucher; no Fixes/Reported-by/Cc stable
- [Phase 2] Diff: +21/−12 in one file; helper plus two call sites; min
  8/10 preserved via sizeof
- [Phase 2] `union acpi_object` in `include/acpi/actypes.h`: INTEGER vs
  BUFFER overlay confirmed
- [Phase 3] blame: `d38ceaf99ed015` (v4.2-rc1); in this tree
- [Phase 3] parent is ATIF 1/2 on a different file; ATPX standalone
- [Phase 4] b4 dig failed (lore error); mail-archive PATCH 2/2 + Deucher
  series ack
- [Phase 4] No stable-list hit (lore 403) — UNVERIFIED
- [Phase 5] Call chain: amdgpu_init → register_atpx_handler → detect →
  init → verify/validate; CONFIG_VGA_SWITCHEROO
- [Phase 5] `amdgpu_atpx_call` has no type check (unlike ATIF)
- [Phase 5] Same bug still in `radeon_atpx_handler.c`
- [Phase 6] `git describe HEAD`: v6.18.53-5049; candidate not in
  v6.18.53; buggy code present; empty diff vs parent file
- [Phase 8] Failure mode: oops/OOB on ATPX probe, HIGH; trigger = hybrid
  PX + bad ACPI
- UNVERIFIED: no concrete BIOS reproducer; no CVE

**YES**

 .../gpu/drm/amd/amdgpu/amdgpu_atpx_handler.c  | 33 ++++++++++++-------
 1 file changed, 21 insertions(+), 12 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_atpx_handler.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_atpx_handler.c
index 3893e6fc2f037..e2a4644896ca8 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_atpx_handler.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_atpx_handler.c
@@ -89,6 +89,15 @@ bool amdgpu_is_atpx_hybrid(void)
 	return amdgpu_atpx_priv.atpx.is_hybrid;
 }
 
+static bool amdgpu_atpx_buffer_validate(const union acpi_object *obj,
+					size_t min_size)
+{
+	return obj && obj->type == ACPI_TYPE_BUFFER &&
+	       obj->buffer.length >= sizeof(u16) &&
+	       obj->buffer.length >= *(u16 *)obj->buffer.pointer &&
+	       *(u16 *)obj->buffer.pointer >= min_size;
+}
+
 /**
  * amdgpu_atpx_call - call an ATPX method
  *
@@ -179,15 +188,15 @@ static int amdgpu_atpx_validate(struct amdgpu_atpx *atpx)
 		if (!info)
 			return -EIO;
 
-		memset(&output, 0, sizeof(output));
-
-		size = *(u16 *) info->buffer.pointer;
-		if (size < 10) {
-			pr_err("ATPX buffer is too small: %zu\n", size);
+		if (!amdgpu_atpx_buffer_validate(info, sizeof(output))) {
+			pr_err("Invalid ATPX GET_PX_PARAMETERS response\n");
 			kfree(info);
 			return -EINVAL;
 		}
-		size = min(sizeof(output), size);
+
+		memset(&output, 0, sizeof(output));
+
+		size = min(sizeof(output), (size_t)*(u16 *)info->buffer.pointer);
 
 		memcpy(&output, info->buffer.pointer, size);
 
@@ -258,15 +267,15 @@ static int amdgpu_atpx_verify_interface(struct amdgpu_atpx *atpx)
 	if (!info)
 		return -EIO;
 
-	memset(&output, 0, sizeof(output));
-
-	size = *(u16 *) info->buffer.pointer;
-	if (size < 8) {
-		pr_err("ATPX buffer is too small: %zu\n", size);
+	if (!amdgpu_atpx_buffer_validate(info, sizeof(output))) {
+		pr_err("Invalid ATPX VERIFY_INTERFACE response\n");
 		err = -EINVAL;
 		goto out;
 	}
-	size = min(sizeof(output), size);
+
+	memset(&output, 0, sizeof(output));
+
+	size = min(sizeof(output), (size_t)*(u16 *)info->buffer.pointer);
 
 	memcpy(&output, info->buffer.pointer, size);
 
-- 
2.53.0

