Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 248F2509F1E;
	Mon, 19 Oct 2026 13:55:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418102; cv=none; b=knXOAPkp0q3CG+EYbsptXVxxufO/gvQfxlrTG21ZfKkNCU/4iuELXI3qeTJfEM5UBS2hTjqx+0N3t5hd24azrLCeRWXV09bNaNvSn9GNcgZwgOM1ThTGcsiN3SevBnJoEWoiq7uzWlbJwScdhjY6j/nZh7CI3yrvZkP312nnGLY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418102; c=relaxed/simple;
	bh=IJsAW//axB7PPIY3M0ncNKefPpZVH1JWJBfNugfKrQs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nrV8VPDvmcALEGPwb2M8mHEN06quy+jneuNerel1AV1YUCkSX+MdPMjQGcTcQg8XZcZadmTCZBRE1IABuPmpFCvHqRoZA+L5cqAFfKAVSD979SNIleis7aBqiuGpM1n8RkK2h6CIX85UrTLjnGWTKAI7r+r+v/V3vrs3S8F8F7g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SuKYSIrR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SuKYSIrR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D77A41F000C6;
	Mon, 19 Oct 2026 13:54:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418100;
	bh=KVlb/UQZEQ9XYCyR8HMzIQf+mLj6dzHuzCZGY1Lt30w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SuKYSIrRjPv0M1BAYnMAQbnp+lXpIxCxG6qEKfDShKwm4pxIBKV745Vc0ek08vdQH
	 FAVtfj0kcDyOdpd4ZzTJw23jhBcu7o1BNL7ZudLogce/GN1lPN3OdU0yrdgnCOtTgo
	 +uHW/f+39mE71D8Ib8U3h7ZWt+1Qgc1NjURjngiILzhUwU7QVuLcvgqTYpwKl5zv8A
	 enMasE0Dz0vbRALJpYP/iym3E0rVl8hEkhVNP9RdoVQjewvyaSMye5iwE3eLQkjtpG
	 zx9eMnyYd4mIFJGzJ7OROXNbf8HCZapkezw3KYieSl8BmJ2WFWkWCAEz7QTi3/kddP
	 290O6/sTwfJjg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Gangliang Xie <ganglxie@amd.com>,
	Tao Zhou <tao.zhou1@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	christian.koenig@amd.com,
	airlied@gmail.com,
	simona@ffwll.ch,
	amd-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.6] drm/amdgpu: add buf length check
Date: Mon, 19 Oct 2026 09:45:03 -0400
Message-ID: <20261019135441.1420968-12-sashal@kernel.org>
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

From: Gangliang Xie <ganglxie@amd.com>

[ Upstream commit 473f99e4a262776141366f7fb10f101d0f22b019 ]

add buf length check before using it to access data

Signed-off-by: Gangliang Xie <ganglxie@amd.com>
Reviewed-by: Tao Zhou <tao.zhou1@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The local tree is **6.18.53** (`v6.18.53-5049-g0f0bdc2b0dffb` on
`autosel`). The buggy debugfs TA load/invoke paths are in this tree; the
length checks are not in the `v6.18.53` tag. Verdict is for this
checkout only.

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

**Step 1.1: PARSE THE SUBJECT LINE**
Record: `[drm/amdgpu] [add] [buf length check before using a userspace-
supplied length to copy/access data]`

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**
Record:
- `Fixes:` — none (expected)
- `Reported-by:` — none
- `Tested-by:` — none
- `Reviewed-by: Tao Zhou <tao.zhou1@amd.com>`
- `Acked-by:` — none
- `Link:` — none in the commit; lore found separately
- `Cc: stable@vger.kernel.org` — none (expected)
- `Signed-off-by: Gangliang Xie <ganglxie@amd.com>` (author)
- `Signed-off-by: Alex Deucher <alexander.deucher@amd.com>` (amdgpu
  maintainer)
- Ignore: `[Upstream commit 473f99e4a262…]`, `Signed-off-by: Sasha
  Levin` (pipeline)

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**
Record:
- Bug description: userspace-supplied buffer lengths are used to
  copy/access data without enough validation
- Symptom: out-of-bounds access / invalid allocation when the length is
  too small or too large
- Version info: none in the message
- Root cause: `ta_bin_len` / `shared_buf_len` from `copy_from_user` are
  trusted after only a partial check (load has an upper bound; invoke
  has none)

**Step 1.4: DETECT HIDDEN BUG FIXES**
Record: This is a real bounds-check fix, not cleanup. “Add buf length
check before using it to access data” is an OOB / crash-prevention
patch.

===============================================================
PHASE 2: DIFF ANALYSIS - LINE BY LINE
===============================================================

**Step 2.1: INVENTORY THE CHANGES**
Record:
- File: `drivers/gpu/drm/amd/amdgpu/amdgpu_psp_ta.c` (+4 / -1)
- Functions: `ta_if_load_debugfs_write()`,
  `ta_if_invoke_debugfs_write()`
- Scope: single-file surgical fix

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**
Record:
- Load, before: reject only `ta_bin_len > PSP_1_MEG` (`0x100000`).
  `ta_bin_len == 0` or smaller than `struct common_firmware_header` (32
  bytes) still proceeds to `memdup_user()` then `get_bin_version()`.
- Load, after: also reject `ta_bin_len < sizeof(struct
  common_firmware_header)`.
- Invoke, before: `shared_buf_len` is copied from userspace and passed
  straight to `memdup_user()` with no min/max check.
- Invoke, after: reject `shared_buf_len == 0` or `shared_buf_len >
  PSP_1_MEG`.

**Step 2.3: IDENTIFY THE BUG MECHANISM**
Record: **Memory safety / size validation (OOB read + unbounded copy).**

Load path (the crash):
- `get_bin_version()` does `hdr->ucode_version` at offset 16 of `struct
  common_firmware_header`.
- `ta_bin_len == 0`: `memdup_user(..., 0)` goes through `kmalloc(0)` →
  `ZERO_SIZE_PTR` (`(void *)16`). Reading `ucode_version` is a distinct
  fault.
- `0 < ta_bin_len < 32`: allocated buffer is smaller than the header;
  reading `ucode_version` is an out-of-bounds read (KASAN OOB / slab
  overrun).

Invoke path:
- No upper bound: `memdup_user()` of a user-controlled `uint32_t` (up to
  ~4GiB). That is an unbounded kernel allocation.
  `prep_ta_mem_context()` later rejects lengths above `shared_mem_size`
  (`PSP_RAS_SHARED_MEM_SIZE` = 0x4000), so this is not an OOB write into
  TA shared memory, but it is still a large GFP_USER allocation from
  debugfs.
- Zero length: `memcpy` of 0 bytes would not crash; the
  `!shared_buf_len` check is defensive.

This completes `c99769bceab4e` (“Validate TA binary size” / “avoid OOB
write”), which added only the load-path upper bound and was `Cc:
stable@vger.kernel.org`.

**Step 2.4: ASSESS THE FIX QUALITY**
Record: Obviously correct, 4 lines, no API/locking/structure changes.
Regression risk is very low: only rejects sizes that cannot be a valid
firmware header or that exceed the existing 1MiB PSP cap. Invoke still
allows up to 1MiB while shared mem is 16KiB; that is conservative, not
wrong.

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

**Step 3.1: BLAME THE CHANGED LINES**
Record:
- Buggy debugfs TA I/F: `e50d9ba0d2cd0` (2022-04-21) “Add debugfs TA
  load/unload/invoke support” — in this tree (present since ~v5.19-era).
- Load upper bound: `c99769bceab4e` (2024-08-20) — in v6.18.
- `memdup_user` conversion: `99eeb8358e6cd` (2025-09-08) — in v6.18; no
  functional change.

**Step 3.2: FOLLOW THE FIXES: TAG**
Record: No `Fixes:` tag. The incomplete prior fix is `c99769bceab4e`,
which is in this tree.

**Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**
Record: Recent related commits on this file: locking (`5c42d9f8b0049`,
not in `v6.18.53`), `memdup_user`, “Validate TA binary size”. This patch
is standalone; it only tightens existing `if` checks and does not depend
on the locking change. Dry-run apply of the upstream diff onto the
`v6.18.53` file succeeded.

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**
Record: Gangliang Xie is an AMD contributor with nearby hardening checks
(`add first record offset check`, `add check for xcp id`). Not the
subsystem maintainer. Maintainer Alex Deucher signed it off.

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**
Record: None required. The functions, `PSP_1_MEG`, `memdup_user`, and
the load-path upper bound all exist in this tree. Standalone.

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**
Record:
- `b4 dig -c 473f99e4a262`:
  https://patch.msgid.link/20260616093508.37315-1-ganglxie@amd.com
- `b4 dig -a`: single revision **v1 only** (2026-06-16), no v2/v3
- Thread: author patch + `Reviewed-by: Tao Zhou`. No NAK, no stable
  nomination in review, no discussion of risk
- lore.kernel.org HTTP fetch returned 403; thread recovered via `b4 dig
  -m`

**Step 4.2: CHECK WHO REVIEWED THE PATCH**
Record (`b4 dig -w`): To `amd-gfx@lists.freedesktop.org`; Cc Hawking
Zhang, Tao Zhou. Reviewed-by Tao Zhou; Signed-off-by Alex Deucher
(amdgpu maintainer).

**Step 4.3: SEARCH FOR THE BUG REPORT**
Record: No `Reported-by`, syzbot, or bugzilla. Internal AMD hardening,
not a public crash report.

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**
Record: Standalone one-patch series. Sibling in-tree OOB fix
`c99769bceab4e` was explicitly `Cc: stable`.

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**
Record: lore.kernel.org/stable HTTP 403. No evidence in the amd-gfx
thread that this was rejected for stable. UNVERIFIED: no stable-list
discussion recovered.

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

**Step 5.1: IDENTIFY KEY FUNCTIONS**
Record: `ta_if_load_debugfs_write`, `ta_if_invoke_debugfs_write`.
Helpers used: `get_bin_version`, `prep_ta_mem_context`, `memdup_user`.

**Step 5.2: TRACE CALLERS**
Record: Only wired as `.write` in `ta_load_debugfs_fops` /
`ta_invoke_debugfs_fops`. Created by `amdgpu_ta_if_debugfs_init()` from
`amdgpu_debugfs.c` as:
- `/sys/kernel/debug/dri/<N>/ta_if/ta_load` (mode 0200)
- `/sys/kernel/debug/dri/<N>/ta_if/ta_invoke` (mode 0200)
Under `#if defined(CONFIG_DEBUG_FS)`.

**Step 5.3: TRACE CALLEES**
Record: `copy_from_user` → `memdup_user` → `get_bin_version` /
`prep_ta_mem_context` → PSP TA load/invoke. `psp_copy_fw()` already uses
`if (!bin_size || bin_size > PSP_1_MEG)` before memcpy into a 1MiB
buffer — the same pattern this patch adds.

**Step 5.4: FOLLOW THE CALL CHAIN**
Record: Reachable from a write to those debugfs files. Not a syscall for
unprivileged users; debugfs is typically root/`CAP_SYS_ADMIN`. Still a
documented load path: writing a truncated TA blob follows the intended
interface and oopses.

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**
Record: Same 0 / `PSP_1_MEG` check already exists in `psp_copy_fw()`.
The 2024 load-path upper bound was the same class of bug and went to
stable.

===============================================================
PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
===============================================================

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**
Record: Yes. `v6.18.53` has:
```
if (ta_bin_len > PSP_1_MEG)
    return -EINVAL;
```
and invoke `memdup_user(&buf[copy_pos], shared_buf_len)` with no length
check. Bug introduced in 2022 (`e50d9ba0d2cd0`); load upper bound only
since 2024.

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**
Record: Clean apply onto the `v6.18.53` file (dry-run `patch -p1` return
0). Context matches. No rework needed.

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**
Record: Upper-bound-only fix `c99769bceab4e` is in this tree. This
commit is the missing lower bound and the invoke-path check. No
duplicate of this exact fix in `v6.18.53`.

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

**Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY**
Record: `drivers/gpu/drm/amd/amdgpu` — IMPORTANT (very common GPU
driver), but this path is debugfs/CONFIG_DEBUG_FS, so impact is narrower
than core amdgpu.

**Step 7.2: ASSESS SUBSYSTEM ACTIVITY**
Record: Actively developed; this file has had several stability fixes
(NULL deref, locking, OOB size). Mature debugfs interface (since 2022),
not brand-new code.

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

**Step 8.1: DETERMINE WHO IS AFFECTED**
Record: AMDGPU users with `CONFIG_DEBUG_FS`, writing
`dri/<N>/ta_if/ta_load` or `ta_invoke`. Driver-specific + config-
specific (debugfs). Not universal.

**Step 8.2: DETERMINE THE TRIGGER CONDITIONS**
Record: Write a length field that is 0, smaller than the firmware
header, or (invoke) larger than 1MiB. Easy to hit with a truncated TA
binary on the documented load interface. Unprivileged users generally
cannot; root/debugfs can.

**Step 8.3: DETERMINE THE FAILURE MODE SEVERITY**
Record:
- Load, `ta_bin_len == 0`: `ZERO_SIZE_PTR` deref → oops. **HIGH**
- Load, undersized header: OOB read. **HIGH**
- Invoke, huge length: large `GFP_USER` alloc, then `-EINVAL` from
  `prep_ta_mem_context`. **MEDIUM** (DoS-ish, privileged)
- Invoke, zero length: not a demonstrated crash. **LOW**

Overall severity: **HIGH** for the load-path oops/OOB; interface is
privileged.

**Step 8.4: CALCULATE RISK-BENEFIT RATIO**
Record:
- Benefit: prevents a kernel oops/OOB on a shipped debugfs firmware-load
  path; finishes a check that stable already accepted
- Risk: 4 lines, reject-only, very low
- Ratio: benefit > risk

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

**Step 9.1: COMPILE THE EVIDENCE**

FOR:
- Real OOB / `ZERO_SIZE_PTR` crash on load with a too-small `ta_bin_len`
- Invoke path had no length cap at all (unbounded `memdup_user`)
- Same file’s prior OOB size check was `Cc: stable`
- Same `!size || size > PSP_1_MEG` pattern already used in
  `psp_copy_fw()`
- 4-line, obviously correct, maintainer-acked
- Buggy code exists in this 6.18.53 tree; patch applies cleanly
- No new API/feature

AGAINST:
- debugfs, mode 0200, typically root-only
- No public reporter, syzbot, or crash log
- Sparse commit message; no `Fixes:`
- Invoke zero-length is not itself a crash

UNRESOLVED:
- Could not read lore.kernel.org/stable over HTTP (403)
- No evidence of an in-the-wild crash, only code-path analysis

**Step 9.2: APPLY THE STABLE RULES CHECKLIST**
1. Obviously correct and tested? **PASS** — reviewed, maintainer SOB,
   trivial predicates
2. Fixes a real bug that affects users? **PASS** — documented TA load
   path oopses on a truncated blob
3. Important issue (crash, security, corruption, deadlock)? **PASS** —
   kernel oops / OOB read (privileged debugfs, still a crash)
4. Small and contained? **PASS** — +4/-1, one file
5. No new features or APIs? **PASS**
6. Can apply to the local tree? **PASS** — clean apply to `v6.18.53`
   file; all helpers present

**Step 9.3: CHECK FOR EXCEPTION CATEGORIES**
Record: Not a device-ID/quirk/DT/build/docs exception. Ordinary small
memory-safety fix.

**Step 9.4: MAKE YOUR DECISION**

This belongs in this 6.18.y tree. The load-path hole is a real oops, the
invoke path was never given the cap that load got in 2024, and the patch
is the smallest possible completion of that already-stable-worthy check.

What it solves for stable users: writing a too-small TA binary to
`ta_load` no longer walks off a kernel buffer (or `ZERO_SIZE_PTR`);
`ta_invoke` no longer `memdup_user`s an unchecked userspace length.

Risk vs benefit: four reject-only lines vs. a debugfs-triggered oops on
a common driver. Backport.

Verification:
- [Phase 1] Parsed tags: Reviewed-by Tao Zhou; SOB Alex Deucher; no
  Fixes/Reported-by/Cc:stable
- [Phase 1] Body: “add buf length check before using it to access data”
- [Phase 2] Diff: +4/-1 in `amdgpu_psp_ta.c`; load min-size; invoke
  0/`PSP_1_MEG`
- [Phase 2] `common_firmware_header` is 32 bytes; `ucode_version` at
  offset 16 (`amdgpu_ucode.h`)
- [Phase 2] `memdup_user()` → `kmem_buckets_alloc` → `kmalloc`;
  `kmalloc(0)` returns `ZERO_SIZE_PTR` (`include/linux/slab.h`)
- [Phase 3] File added in `e50d9ba0d2cd0` (2022); upper bound
  `c99769bceab4e` (Cc:stable, in v6.18); `memdup_user` `99eeb8358e6cd`
  in v6.18
- [Phase 3] No Fixes tag; `git merge-base --is-ancestor e50d9ba0d2cd0
  HEAD` yes
- [Phase 3] Author: AMD contributor; maintainer merged
- [Phase 4] `b4 dig -c 473f99e4a262`: msgid
  20260616093508.37315-1-ganglxie@amd.com
- [Phase 4] `b4 dig -a`: v1 only
- [Phase 4] `b4 dig -w`: amd-gfx, Hawking Zhang, Tao Zhou
- [Phase 4] mbox: Reviewed-by only; no NAK
- [Phase 4] lore.kernel.org WebFetch 403; stable-list search UNVERIFIED
- [Phase 5] Callers: debugfs fops only; `amdgpu_ta_if_debugfs_init()`
  from `amdgpu_debugfs.c`
- [Phase 5] `psp_copy_fw()` already has `!bin_size || bin_size >
  PSP_1_MEG`
- [Phase 5] `PSP_RAS_SHARED_MEM_SIZE` = 0x4000
- [Phase 6] `git describe HEAD` → `v6.18.53-5049-g0f0bdc2b0dffb`; `make
  kernelversion` → 6.18.53
- [Phase 6] `v6.18.53` file lacks both new checks; dry-run apply of
  upstream diff: success
- [Phase 6] `git merge-base --is-ancestor 473f99e4a262 HEAD` no
  (upstream not in this history as that SHA); buggy code is still
  present at the v6.18.53 tag
- [Phase 8] Failure: load-path oops/OOB HIGH; invoke unbounded alloc
  MEDIUM; trigger is debugfs write

**YES**

 drivers/gpu/drm/amd/amdgpu/amdgpu_psp_ta.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_psp_ta.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_psp_ta.c
index 0d3c18f04ac36..8ae72c862d112 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_psp_ta.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_psp_ta.c
@@ -166,7 +166,8 @@ static ssize_t ta_if_load_debugfs_write(struct file *fp, const char *buf, size_t
 	if (ret)
 		return -EFAULT;
 
-	if (ta_bin_len > PSP_1_MEG)
+	if (ta_bin_len < sizeof(struct common_firmware_header) ||
+	    ta_bin_len > PSP_1_MEG)
 		return -EINVAL;
 
 	copy_pos += sizeof(uint32_t);
@@ -321,6 +322,8 @@ static ssize_t ta_if_invoke_debugfs_write(struct file *fp, const char *buf, size
 	ret = copy_from_user((void *)&shared_buf_len, &buf[copy_pos], sizeof(uint32_t));
 	if (ret)
 		return -EFAULT;
+	if (!shared_buf_len || shared_buf_len > PSP_1_MEG)
+		return -EINVAL;
 	copy_pos += sizeof(uint32_t);
 
 	shared_buf = memdup_user(&buf[copy_pos], shared_buf_len);
-- 
2.53.0

