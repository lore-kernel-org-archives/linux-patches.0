Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2795C533CFC;
	Mon, 19 Oct 2026 13:56:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418171; cv=none; b=qdnUZEp0cPSn0aEMQ+TM7tD6hPXRVVpEA6/9Mh6tC82IUlUdvlS6gijM5I7B5RrweucCGPx/FkU+fsLRnBow4tdk0X5fxERPR+WO65qGEU5kTuDCnG/8IaY9OCZErfDN0ShpRCk66lq7krAZuAHzZuo9lL8HNuMxO7LRqaQRh8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418171; c=relaxed/simple;
	bh=JVnMUyYCFP8Kl/qChmzFxwajTO8+cKtIE2QnyNtFB7Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tBAbbjM6Ucu60HBU/Kw04ZHk91bnFAaEdqbvc88Uqnnf9GGAFv6b7Noh/4v6JFw7is4cm1HHUFMNDVlVWq5ANLHJyUNPxMVprncWnbRIoGGvwOQLzOrkXVffTa/aI9HgyI6L0RrBNEyr7Ed2yFEcouHqgLbk0Zo32Pt9Z/ZKGVM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=W7ssvKoY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="W7ssvKoY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F051F1F000C8;
	Mon, 19 Oct 2026 13:56:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418168;
	bh=jHdCrDtDzd0B4HxFNPxlVm2gyHM/CHn/y1BW3PpG5ro=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=W7ssvKoYLRR6He4eMNJBwK+ClcdJ/LoxMDhsDprLP4M/5b0P89hKwWTQ1kla9GNpy
	 Auf2DeP+DLj+3/pINjHFnuT0J7eTOwwGjYI1iTqT8t202KU9V1Bw8PjsffsCzMkJ4T
	 tgkN9b7J9VER5o49ryGcuWutfIBg6hEX+0AFJ3m6a8UcB5CeIEOj52w2IsC8byGZ0m
	 fvChwamCBXw3SsFBlIhAQ++Gqf/kinbclUGR4SAkyJKHOKJLOwojExPahMWVFXHAFv
	 czVUSppKJMJwc7V1z5JFQQ5I6RyVr5q3l0+aRyj87N2mASDcV0OsakOeP1OedUfMF+
	 ZJRTxfYNj1qIg==
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
Subject: [PATCH AUTOSEL 6.18-5.10] drm/amdgpu: Add checks to vbios fetch through ATRM
Date: Mon, 19 Oct 2026 09:45:51 -0400
Message-ID: <20261019135441.1420968-60-sashal@kernel.org>
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

[ Upstream commit 8c3fcfc14fc1320a1155acb2dd7656fce7003bc0 ]

Check if a valid buffer object is returned after ATRM call. Also, match
the buffer length against requested size before copying.

Signed-off-by: Lijo Lazar <lijo.lazar@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

This 6.18.53 tree still copies an untrusted ATRM ACPI buffer with no
type or length check, which is a real heap overflow / NULL-deref during
dGPU probe. The patch is a small, self-contained memory-safety fix and
belongs in this tree.

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

Step 1.1: PARSE THE SUBJECT LINE
Record: [drm/amdgpu] [Add] [checks on ATRM ACPI return before copying
VBIOS data]
Subsystem prefix `drm/amdgpu`. Verb is “Add checks,” which here means
adding missing validation, not a feature.

Step 1.2: PARSE ALL COMMIT MESSAGE TAGS
Record:
- Signed-off-by: Lijo Lazar \<lijo.lazar@amd.com\> (author)
- Reviewed-by: Alex Deucher \<alexander.deucher@amd.com\> (amdgpu
  maintainer)
- Signed-off-by: Alex Deucher \<alexander.deucher@amd.com\>
- No Fixes:, Reported-by, Tested-by, Link:, or Cc: stable (absence
  expected)
- Ignore pipeline-added “Upstream commit …” and “Signed-off-by: Sasha
  Levin”

Notable: maintainer Reviewed-by + SOB. No fuzzer or user crash report.

Step 1.3: ANALYZE THE COMMIT BODY TEXT
Record:
- Bug: ATRM ACPI evaluation result used without checking it is a buffer,
  and without capping copy size to the requested length.
- Symptom: NULL deref if `buffer.pointer` is NULL; type-confused access
  if the object is not `ACPI_TYPE_BUFFER`; `memcpy` of firmware-
  controlled `obj->buffer.length` into a 4 KiB slot of a 256 KiB
  kmalloc, i.e. heap overflow especially on the last 4 KiB page.
- Version info: none in the message. Code dates to amdgpu core (v4.2).
- Root cause (author): ATRM can return a non-buffer or oversized buffer;
  copy must be validated first.

Step 1.4: DETECT HIDDEN BUG FIXES
Record: Yes. “Add checks” is defensive language for a memory-safety bug:
missing type check + unbounded memcpy from ACPI firmware data. Same
pattern as this author’s ATIF/ATPX buffer validation commits.

===============================================================
PHASE 2: DIFF ANALYSIS - LINE BY LINE
===============================================================

Step 2.1: INVENTORY THE CHANGES
Record:
- File: `drivers/gpu/drm/amd/amdgpu/amdgpu_bios.c` (+8 / -2)
- Function: `amdgpu_atrm_call()`
- Scope: single-function surgical fix

Step 2.2: UNDERSTAND THE CODE FLOW CHANGE
Record:
Before: after `acpi_evaluate_object` success, `obj = buffer.pointer`
then `memcpy(bios+offset, obj->buffer.pointer, obj->buffer.length)` and
`return obj->buffer.length`.
After: reject NULL or non-buffer objects (`kfree` + `-EINVAL`); `len =
min_t(size_t, obj->buffer.length, len)`; copy that many bytes; return
the capped length.
Path: dGPU VBIOS fetch via ATRM during probe (`amdgpu_atrm_get_bios` →
`amdgpu_get_bios_dgpu` → `amdgpu_get_bios`).

Step 2.3: IDENTIFY THE BUG MECHANISM
Record:
- Category: memory safety (NULL deref + out-of-bounds write) on an
  ACPI/firmware path.
- Mechanism: `union acpi_object` is type-tagged. Using `.buffer.length`
  / `.buffer.pointer` when type is INTEGER/PACKAGE/etc. reads the wrong
  union members. Even with a real buffer, firmware can return length \>
  requested 4096. Destination is `adev->bios` (`kmalloc(256*1024)`),
  `offset = i * 4096`. Last page (`i == 63`) overflow writes past the
  allocation.

Step 2.4: ASSESS THE FIX QUALITY
Record:
- Obviously correct: type check is the standard ACPI pattern (ATIF
  already does `obj->type != ACPI_TYPE_BUFFER`; nouveau `acpi_read_bios`
  already does `min(length, obj->buffer.length)`).
- Minimal; no unrelated churn; no API change.
- Regression risk low: well-behaved ATRM still copies ≤ requested size.
  Oversize/wrong-type now fails this chunk; caller already treats `ret <
  ATRM_BIOS_PAGE` as end-of-data and then `check_atom_bios()`. `-EINVAL`
  is `< 4096`, so the loop stops and BIOS validation fails instead of
  overflowing.
- Remaining gap (not a reason to reject): no check that
  `obj->buffer.pointer` is non-NULL when type is BUFFER; ACPI normally
  provides one. ACPI_FAILURE path still does not `kfree` (pre-existing).

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

Step 3.1: BLAME THE CHANGED LINES
Record: Unchecked `memcpy` comes from `d38ceaf99ed015` (“drm/amdgpu: add
core driver (v4)”, 2015-04-20), first in v4.2-rc1. Present for the
entire life of amdgpu, including this 6.18 tree.

Step 3.2: FOLLOW THE FIXES: TAG
Record: No Fixes: tag. Introducer is the original amdgpu core commit,
which is in this tree.

Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES
Record: Recent `amdgpu_bios.c` work is VBIOS source selection (ROM BAR,
VFCT, shadow ROM), not ATRM copy logic. ATRM skip for removable devices
is `432e664e7c98c`. This patch is standalone, not “X/Y”. Sibling
hardening (not prerequisites): `c8373721c3e54` ATIF buffer validation,
`9d367fab451d9` ATPX buffer validation (same author, May 2026). No
follow-ups on this file after the candidate.

Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS
Record: Lijo Lazar is a regular AMD amdgpu contributor. Same-era ACPI
object validation: ATIF and ATPX. Maintainer Alex Deucher reviewed.

Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS
Record: None. Uses existing `acpi_evaluate_object`, `ACPI_TYPE_BUFFER`,
`min_t`, `memcpy`. `git diff v6.18.53 <candidate> -- amdgpu_bios.c` is
exactly this hunk. Applies standalone.

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION
Record:
- `b4 dig -c 8c3fcfc14fc1320a1155acb2dd7656fce7003bc0` →
  https://patch.msgid.link/20260615053911.59876-1-lijo.lazar@amd.com
- `b4 dig -a`: v1 only, 2026-06-15, no later revisions.
- Thread: patch from Lijo Lazar; Alex Deucher Reviewed-by. No NAK, no
  stable nomination, no risk flags.
- lore.kernel.org WebFetch returned 403; thread recovered via `b4 dig
  -m`.

Step 4.2: CHECK WHO REVIEWED THE PATCH
Record (`b4 dig -w`): To/Cc Lijo Lazar, amd-gfx@lists.freedesktop.org,
Hawking Zhang, Alexander Deucher, Asad Kamal, Candice Li. Subsystem
maintainer reviewed.

Step 4.3: SEARCH FOR THE BUG REPORT
Record: No Reported-by / Link. No public crash report found. Bug is from
code inspection of untrusted ACPI length.

Step 4.4: CHECK FOR RELATED PATCHES AND SERIES
Record: Standalone v1. Related ATIF/ATPX validation patches are
independent files (`amdgpu_acpi.c`, `amdgpu_atpx_handler.c`). radeon
`radeon_atrm_call()` still has the old memcpy (separate driver; not
required for this backport).

Step 4.5: CHECK STABLE MAILING LIST HISTORY
Record: lore.kernel.org/stable WebFetch 403. `b4 dig` showed only amd-
gfx. No evidence this was rejected for stable. Absence of prior stable
discussion is not a negative.

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF
Record: `amdgpu_atrm_call()` only.

Step 5.2: TRACE CALLERS
Record:
- `amdgpu_atrm_call` ← `amdgpu_atrm_get_bios` (CONFIG_ACPI)
- `amdgpu_atrm_get_bios` ← `amdgpu_get_bios_dgpu`
- `amdgpu_get_bios_dgpu` ← `amdgpu_get_bios` (non-APU)
- `amdgpu_get_bios` ← `amdgpu_device.c` during COMMON IP `early_init` /
  device init
Context: process context, driver probe, hybrid/PX dGPU laptops. Not IRQ.
Userspace cannot call it directly; it runs when amdgpu binds.

Step 5.3: TRACE CALLEES
Record: `acpi_evaluate_object`, `acpi_format_exception`, `memcpy`,
`kfree`, `min_t`, `DRM_ERROR`. ACPI allocates with
`ACPI_ALLOCATE_BUFFER`.

Step 5.4: FOLLOW THE CALL CHAIN
Record: Reachable on boot/module load for discrete AMD GPUs on PX
platforms with an ATRM ACPI method (on-platform only; removable devices
skipped). Failure of ATRM can make `amdgpu_get_bios()` fail and probe
return `-EINVAL` unless VBIOS is optional. Heap overflow is reachable
whenever ATRM returns a too-large buffer.

Step 5.5: SEARCH FOR SIMILAR PATTERNS
Record: Same unfixed pattern in `drivers/gpu/drm/radeon/radeon_bios.c`.
Nouveau already caps length. ATIF/ATPX in amdgpu already validate
type/length. Systematic ACPI-buffer issue; this commit fixes amdgpu ATRM
only.

===============================================================
PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
===============================================================

Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?
Record: Yes. Local tree is 6.18.53 (`git describe HEAD` →
`v6.18.53-5049-g0f0bdc2b0dffb`, `VERSION=6 PATCHLEVEL=18 SUBLEVEL=53`).
`v6.18.53:drivers/gpu/drm/amd/amdgpu/amdgpu_bios.c` still has:
```
memcpy(bios+offset, obj->buffer.pointer, obj->buffer.length);
```
Bug since v4.2 (`d38ceaf99ed015`).

Step 6.2: CHECK FOR BACKPORT COMPLICATIONS
Record: Clean apply. Diff vs v6.18.53 is only this hunk. Surrounding
`amdgpu_atrm_call` matches the patch context.

Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE
Record: No other ATRM copy-size fix in this tree. ATIF/ATPX validation
does not cover ATRM.

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY
Record: [drm/amdgpu VBIOS/ACPI] [IMPORTANT] — not mm/core, but a widely
used GPU driver; probe-time heap overflow can oops or corrupt kernel
memory.

Step 7.2: ASSESS SUBSYSTEM ACTIVITY
Record: amdgpu is actively developed; this ATRM helper has been
unchanged since 2015 aside from log-string tweaks. Long-lived bug, not a
new-code issue.

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

Step 8.1: DETERMINE WHO IS AFFECTED
Record: Driver-specific: discrete AMD GPUs on hybrid/PX systems with
ATRM (typical laptop mux). CONFIG_ACPI. Not APUs (`amdgpu_get_bios_apu`
does not call ATRM). Still a real, common laptop class.

Step 8.2: DETERMINE THE TRIGGER CONDITIONS
Record: Device probe when ATRM is present. Unprivileged users do not
invoke it directly; broken/malicious ACPI (buggy laptop firmware, or
attacker-controlled tables in some virt setups) can trigger overflow.
Well-behaved 4 KiB ATRM responses are unaffected.

Step 8.3: DETERMINE THE FAILURE MODE SEVERITY
Record: Kernel heap out-of-bounds write and/or NULL deref oops during
GPU init. Severity HIGH (crash; potential memory corruption). Not a
guaranteed panic on every AMD system.

Step 8.4: CALCULATE RISK-BENEFIT RATIO
Record:
- Benefit: HIGH for ATRM systems — prevents overflow/oops; zero behavior
  change for correct firmware.
- Risk: VERY LOW — 8 lines, error-path + bounds cap, maintainer-
  reviewed.
- Ratio: strongly favors backport.

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

Step 9.1: COMPILE THE EVIDENCE
FOR:
- Unbounded `memcpy` from ACPI-controlled length into a fixed kmalloc
  (heap OOB).
- Missing type check → type-confused union access / NULL deref.
- Present in this 6.18.y tree since amdgpu introduction (v4.2).
- Small, obviously correct, applies cleanly.
- Maintainer Reviewed-by.
- Same class as ATIF/ATPX ACPI buffer validation.

AGAINST:
- No user/syzbot report; described as “add checks.”
- Only hybrid/PX ATRM path, not all amdgpu users.
- radeon sibling left unfixed (out of scope).

UNRESOLVED:
- Could not fetch lore/stable HTML (403); mbox via b4 was sufficient.
- No public reproducer; overflow depends on ATRM returning a bad object
  (verified in code, not in a crash log).

Step 9.2: APPLY THE STABLE RULES CHECKLIST
1. Obviously correct and tested? PASS — type check + min length;
   maintainer review; caller already handles short reads.
2. Fixes a real bug that affects users? PASS — firmware-supplied length
   used as memcpy size on a real probe path.
3. Important issue? PASS — heap overflow / oops, HIGH.
4. Small and contained? PASS — one function, +8/-2.
5. No new features or APIs? PASS.
6. Can apply to the local tree? PASS — identical context on v6.18.53.

Step 9.3: CHECK FOR EXCEPTION CATEGORIES
Record: None (not a device ID/quirk/DT/build/doc exception). Qualifies
as a normal memory-safety bug fix.

Step 9.4: MAKE YOUR DECISION
YES. This tree still has the unchecked ATRM copy. The patch is a
contained, high-value memory-safety fix with negligible regression risk.

===============================================================
What the commit solves for this tree
===============================================================

`amdgpu_atrm_call()` fetches VBIOS in 4 KiB ATRM pages into a 256 KiB
buffer. Before this change it memcpy’d `obj->buffer.length` with no
check that ACPI returned a buffer or that length ≤ 4096. Bad firmware
(wrong type or oversized buffer) can NULL-deref or smash the heap during
amdgpu probe on PX laptops. The fix rejects invalid objects and caps the
copy. That matches stable rules: real bug, important, small, no new API,
clean apply to 6.18.53.

Risk vs benefit: benefit is preventing overflow/oops; risk is a tighter
copy that only changes broken ATRM responses. No prerequisites.

===============================================================
Verification
===============================================================
- [Phase 1] Parsed tags: author Lijo Lazar; Reviewed-by/SOB Alex
  Deucher; no Fixes/Reported-by/Cc:stable.
- [Phase 2] Diff: `amdgpu_atrm_call()` +8/-2; type check + `min_t`
  before memcpy.
- [Phase 2] Pre-fix at `e0d5ff3ff014b^` and at `v6.18.53`: raw memcpy of
  `obj->buffer.length`.
- [Phase 2] `union acpi_object` in `include/acpi/actypes.h`: INTEGER vs
  BUFFER overlay confirms type confusion.
- [Phase 2] Caller loop: `ATRM_BIOS_PAGE` 4096, `size` 256*1024; last
  chunk overflow is past kmalloc.
- [Phase 3] `git blame` on parent: `d38ceaf99ed015` (2015), `git
  describe --contains` → v4.2-rc1.
- [Phase 3] No Fixes: tag; introducer is in this tree.
- [Phase 3] ATIF/ATPX validation commits are sibling files, not
  prerequisites.
- [Phase 3] `git log e0d5ff3ff014b..HEAD -- amdgpu_bios.c`: no follow-
  ups.
- [Phase 4] `b4 dig -c 8c3fcfc14fc1…`: lore msgid
  20260615053911.59876-1-lijo.lazar@amd.com.
- [Phase 4] `b4 dig -a`: v1 only.
- [Phase 4] `b4 dig -w`: amd-gfx + Deucher/Zhang/Kamal/Li.
- [Phase 4] mbox: Deucher Reviewed-by; no NAK.
- [Phase 4] WebFetch lore/stable: 403; treated as UNVERIFIED for HTML,
  covered by b4 mbox.
- [Phase 5] Callers: `amdgpu_atrm_get_bios` → `amdgpu_get_bios_dgpu` →
  `amdgpu_get_bios` → `amdgpu_device.c` probe.
- [Phase 5] radeon still unfixed; nouveau already mins length.
- [Phase 6] `git describe HEAD`: v6.18.53-5049-g0f0bdc2b0dffb; `make
  kernelversion` 6.18.53.
- [Phase 6] `git diff v6.18.53 <candidate> -- amdgpu_bios.c`: this hunk
  only → clean apply.
- [Phase 8] Failure mode: heap OOB / NULL deref on ATRM probe, HIGH.
- UNVERIFIED: live ATRM firmware that returns oversized buffers (no
  crash report); stable-list HTML search (403).

**YES**

 drivers/gpu/drm/amd/amdgpu/amdgpu_bios.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_bios.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_bios.c
index dec312b0f3b0a..f28dec3630de5 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_bios.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_bios.c
@@ -280,8 +280,14 @@ static int amdgpu_atrm_call(acpi_handle atrm_handle, uint8_t *bios,
 	}
 
 	obj = (union acpi_object *)buffer.pointer;
-	memcpy(bios+offset, obj->buffer.pointer, obj->buffer.length);
-	len = obj->buffer.length;
+	if (!obj || obj->type != ACPI_TYPE_BUFFER) {
+		DRM_ERROR("ATRM returned an invalid object\n");
+		kfree(buffer.pointer);
+		return -EINVAL;
+	}
+
+	len = min_t(size_t, obj->buffer.length, len);
+	memcpy(bios+offset, obj->buffer.pointer, len);
 	kfree(buffer.pointer);
 	return len;
 }
-- 
2.53.0

