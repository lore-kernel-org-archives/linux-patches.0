Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40E485458BD;
	Mon, 19 Oct 2026 14:06:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418799; cv=none; b=Q+FqIfgZf/tL/tVZGGu1qoVJaYPxdFIa2+WGqWT/FRmdVINqhblzNKEP87UuP/hkMIFqCGn8Dw84rJRTAbvBYl3HJ6nmLuRNqfl5Xab+U16XeH4UqCGcoGsV9Sgkc1up04Ioz1cs+y+Mujo+e8L9lXhaNP4XZxIKP1MMbsAQTdg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418799; c=relaxed/simple;
	bh=Qri4XrResgnJyvy3lzzrFPrrq7csbZKJA6h23ifmimk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nm+0PdwGYPisoKTb0oxFJ4et8LH/mD4ZKwx6GqwTfc8M6EunyCNe2UXJ3VrLuMaBB1b18URdds7BREUEauo6A4ic6JyZ8MZP89M2+xmqdptmRmTJK7z8nNcD96LCSwf5/2n36Xc/wfjxfJvmKy/Wf57lm1TzlnU4Gi74jcDcOkY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QuJPTty5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QuJPTty5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD4EC1F000C5;
	Mon, 19 Oct 2026 14:06:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418797;
	bh=tDiFVdZd6x1/FpLu1PcrtGHQ8LNj3Xzgk1lKCM43d+Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QuJPTty5Mq1lXSKSaGZKApcO77YuCCIskcpwnCWvKx30dzgFQNMU/I7VFkHvpoFZN
	 X0+81gZs4xkynafE6wRZKTB40kUGmhTe6wZpAk9/BAd7/Jh9sd6NNRHYzdRmvAHcns
	 RnKkv7Ev2W/vGUMmJl7NAy1TgR41BnMJe9a3r4DaneqO95/Hw9atYmTWG9AEz7wnBM
	 +8eKLln32pD1jAVQox0oe4Cqg2KMlYFzCC9y5n6kj7GfDteOUhVAD8uPTW58QkTHxv
	 RJBSECN83IDPd/R0cyO+OznEXTM44OLHrhjzqVo9bEVEr6a/O8bpAN2IM5c/vGiiX1
	 NzxE0Hc5TgqiQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Eric Huang <jinhuieric.huang@amd.com>,
	Philip Yang <philip.yang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	Felix.Kuehling@amd.com,
	christian.koenig@amd.com,
	airlied@gmail.com,
	simona@ffwll.ch,
	amd-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.1] drm/amdkfd: add sanity check in svm_range_is_valid
Date: Mon, 19 Oct 2026 09:53:14 -0400
Message-ID: <20261019135441.1420968-503-sashal@kernel.org>
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

From: Eric Huang <jinhuieric.huang@amd.com>

[ Upstream commit aa7e29cf9a37092cf5057a612ee09f28df20258f ]

to prevent svm range to be overflow or underflow.

Signed-off-by: Eric Huang <jinhuieric.huang@amd.com>
Reviewed-by: Philip Yang <philip.yang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Local tree

This checkout is **6.18.y** (`v6.18.53`, Makefile `VERSION=6` /
`PATCHLEVEL=18` / `SUBLEVEL=53`, branch `autosel`). The verdict is only
for this tree.

`git merge-base --is-ancestor` shows the buggy SVM range math **is** in
`v6.18.53`; the fix is **not**.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1: PARSE THE SUBJECT LINE**

Record: `[drm/amdkfd] [add] sanity check in svm_range_is_valid`

Subsystem: AMD KFD SVM (HMM shared virtual memory). Verb “add” plus
“sanity check” is a bounds/overflow guard, not a feature.

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**

Record:
- Signed-off-by: Eric Huang (author)
- Reviewed-by: Philip Yang (original author of `svm_range_is_valid`)
- Signed-off-by: Alex Deucher (amdgpu/amdkfd maintainer)
- No Fixes:, Reported-by:, Tested-by:, Link:, or Cc: stable (absence is
  expected)

Pipeline-added markers (`[Upstream commit …]`, Sasha Levin SOB) are
ignored.

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**

Record:
- Bug: SVM range start/size can overflow or underflow when converted to
  byte bounds.
- Symptom: not spelled out (no stack trace, CVE, or repro).
- Root cause (from code + review, not from the one-line body): `end =
  start + (size << PAGE_SHIFT)` wraps; `size == 0` makes `last = start +
  size - 1` underflow.

**Step 1.4: DETECT HIDDEN BUG FIXES**

Record: Yes. “Sanity check” here is an integer overflow/underflow fix in
range validation, not style cleanup. Philip Yang said so on list:
overflow wrap plus `size == 0` underflow of `last = start + size - 1`.

---

## PHASE 2: DIFF ANALYSIS

**Step 2.1: INVENTORY THE CHANGES**

Record:
- File: `drivers/gpu/drm/amd/amdkfd/kfd_svm.c` (+7 / −1)
- Function: `svm_range_is_valid()`
- Scope: single-file surgical fix

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**

Before (`v6.18.53`):

```c
start <<= PAGE_SHIFT;
end = start + (size << PAGE_SHIFT);
do { vma_lookup... } while (start < end);
return svm_range_check_vm(p, start_unchg, (end - 1) >> PAGE_SHIFT, ...);
```

After:
- `size == 0` → `-EINVAL`
- `check_add_overflow(start, size << PAGE_SHIFT, &end)` → `-EOVERFLOW`
- Same VMA walk only if the byte range is representable

Path: ioctl/CRIU validation, not a hot inner loop.

**Step 2.3: IDENTIFY THE BUG MECHANISM**

Record: **Integer overflow / underflow (memory-safety / validation
bypass).**

Overflow: userspace `AMDKFD_IOC_SVM` can pass page-aligned `start_addr`
and `size` whose sum wraps 64-bit. After `svm_ioctl()` shifts both into
pages, `end` wraps. The `do/while (start < end)` then walks a
**truncated/wrapped** range. `svm_range_check_vm()` can see `last <
start`, where `interval_tree_iter_first()` treats a non-overlapping
inverted interval as empty and returns success. Callers then run
`svm_range_add()` with the original huge `start`/`size`.

Underflow: `size == 0` makes `(end - 1)` wrap when `end == 0`, so
`svm_range_check_vm()` can be asked to scan ~the whole VA tree. Philip
Yang called that out as the reason for the extra check.

**Step 2.4: ASSESS THE FIX QUALITY**

Record: Obviously correct, minimal, error-path only. Regression risk is
low: overflowing/zero ranges were never valid. `-EOVERFLOW` is a new
errno for this ioctl; those requests were undefined before.
`check_add_overflow()` is already provided via `linux/mm.h` (`kfd_svm.c`
→ `kfd_svm.h` → `linux/hmm.h` → `linux/mm.h` → `linux/overflow.h`). KFD
is 64-bit only (`HSA_AMD depends on X86_64 || ARM64 || PPC64 || …`), so
`unsigned long end` matches `uint64_t` arithmetic.

The check does not separately test `size << PAGE_SHIFT` wrap. On the
ioctl path size is a page-aligned byte length shifted down then up, so
the add is the real wrap. That leftover is not a reason to reject the
patch.

---

## PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1: BLAME THE CHANGED LINES**

Record: Unchecked `end = start + (size << PAGE_SHIFT)` is from
`42de677f799997` (“drm/amdkfd: register svm range”, Philip Yang, 2020).
Present in this tree (`git merge-base --is-ancestor 42de677f799997
v6.18.53` → yes). SVM landed ~5.11; the bug is old in 6.18.y.

**Step 3.2: FOLLOW THE FIXES: TAG**

Record: No Fixes: tag. Not applicable.

**Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**

Record: Recent `kfd_svm.c` work on this tree is unrelated (CRIU
list_del, NULL in `svm_range_set_attr`, TLB, GPU reset). No prior
overflow fix for this helper. Standalone, not patch N/M.

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**

Record: Eric Huang is an AMD KFD contributor (including `drm/amdkfd: fix
a vulnerability of integer overflow in kfd debugger`, already in this
tree with Cc: stable). Philip Yang owns this SVM code. Alex Deucher is
the subsystem maintainer.

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**

Record: None. `check_add_overflow()` and `svm_range_is_valid()` both
exist here. Applies standalone to `v6.18.53` (same hunk as the
candidate).

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**

`b4 dig -c aa7e29cf9a37092cf5057a612ee09f28df20258f` failed (lore HTTP
error). Found the thread on amd-gfx:

- v1: https://lists.freedesktop.org/archives/amd-
  gfx/2026-June/146929.html — overflow check only
- Philip Yang: https://lists.freedesktop.org/archives/amd-
  gfx/2026-June/146952.html — overflow check is good; also reject `size
  == 0` because `last = start + size - 1` underflows
- v2 typo (`retrune`): 147063
- v2 fixed: https://lists.freedesktop.org/archives/amd-
  gfx/2026-June/147065.html — committed form
- Reviewed-by: https://lists.freedesktop.org/archives/amd-
  gfx/2026-June/147704.html
- Landed in drm-next-7.3 pull (Aug 2026)

No NAKs. No Cc: stable on the thread.

**Step 4.2: CHECK WHO REVIEWED THE PATCH**

Record: Philip Yang (SVM author) requested the size==0 check and
Reviewed-by. Alex Deucher signed off and pulled it.

**Step 4.3: SEARCH FOR THE BUG REPORT**

Record: No syzbot/bugzilla. Author-driven hardening after review.

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**

Record: Single patch, two revisions. Self-contained.

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**

Record: No useful stable-list hit for this subject. Not previously
rejected for 6.18.y (UNVERIFIED beyond search noise).

---

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1: KEY FUNCTIONS**

Record: `svm_range_is_valid()` only.

**Step 5.2: TRACE CALLERS**

Record:
- `svm_range_set_attr()` — `AMDKFD_IOC_SVM` SET_ATTR and CRIU restore
- `svm_range_get_attr()` — GET_ATTR and CRIU checkpoint

`kfd_ioctl_svm()`: flags `0` (not `KFD_IOC_FLAG_CHECKPOINT_RESTORE`).
Any opener of `/dev/kfd` can call it. It already rejects zero/unaligned
byte size, then shifts into pages and calls these helpers.

**Step 5.3: TRACE CALLEES**

Record: `vma_lookup()`, `svm_range_check_vm()` →
`interval_tree_iter_first()`. Overflow changes which interval is walked.

**Step 5.4: FOLLOW THE CALL CHAIN**

Record: Userspace ioctl → `kfd_ioctl_svm` → `svm_ioctl` → set/get_attr →
`svm_range_is_valid`. Reachable from userspace with KFD access (ROCm/HIP
unified memory). Not theoretical.

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**

Record: `svm_range_add()` still does `last = start + size - 1UL`, but
only after this validator. Rejecting wrap/zero here closes that gate.
`kfd_ioctl_svm` already rejects byte `size == 0`; the new check covers
CRIU/`svm_range_*_attr` in page units.

---

## PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**

Record: Yes. `v6.18.53` `kfd_svm.c` still has `end = start + (size <<
PAGE_SHIFT)` at the old line 3424. Introduced 2020; in 6.18 from day
one.

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**

Record: Clean apply. Same function signature (no later `mapped`
argument). No extra include. Surrounding SVM code matches.

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**

Record: No other overflow fix for `svm_range_is_valid` on `v6.18.53`.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

**Step 7.1: SUBSYSTEM AND CRITICALITY**

Record: `drivers/gpu/drm/amd/amdkfd` SVM. **IMPORTANT** for AMD GPU
compute (ROCm/HIP), not core mm/VFS. Config: `CONFIG_HSA_AMD_SVM`.

**Step 7.2: SUBSYSTEM ACTIVITY**

Record: Actively maintained; this helper itself has been stable since
~2021 aside from `vma_lookup` and `svm_range_check_vm` tweaks.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1: WHO IS AFFECTED**

Record: AMD GPU users with KFD SVM (unified/managed memory). Driver- and
config-specific, but a common production path.

**Step 8.2: TRIGGER CONDITIONS**

Record:
- Overflow: page-aligned `start_addr + size` wraps `uint64_t`. Easy to
  send; not a normal HIP range.
- Underflow: `size == 0` in pages (ioctl already blocks this;
  CRIU/internal callers may not).
- Unprivileged `/dev/kfd` users can hit the overflow path.

**Step 8.3: FAILURE MODE SEVERITY**

Record: Validation bypass after wrap: SVM may be applied to a range that
was never fully VMA-checked; interval-tree overlap can be skipped; GPU
mapping of the wrong host range or later crashes. Severity **HIGH**
(userspace-triggerable overflow in GPU VA validation). Not a proven
panic-on-boot, but more than a log-only issue.

**Step 8.4: RISK-BENEFIT RATIO**

Record:
- Benefit: HIGH for KFD SVM — closes wrap-around validation.
- Risk: VERY LOW — 7 lines, reject-only, maintainer-reviewed.
- Ratio: strongly favors backport.

---

## PHASE 9: FINAL SYNTHESIS

**Step 9.1: EVIDENCE**

FOR:
- Real wrap in `end = start + (size << PAGE_SHIFT)` on a userspace ioctl
- Wrap can make the VMA walk check the wrong range and still return 0
- `size == 0` underflows `last` (Philip Yang)
- 7-line, obviously correct `check_add_overflow` + zero check
- Reviewed by the SVM author; signed off by Deucher
- Bug present in this 6.18.y tree since original SVM
- Applies cleanly; no new API; no prerequisites

AGAINST:
- Terse commit message, no crash/CVE/syzbot
- Ioctl already rejects byte `size == 0` (overflow still open)
- Affects AMD KFD SVM, not every machine

UNRESOLVED:
- Exact post-bypass corruption vs. later `-EFAULT` not demonstrated with
  a repro
- lore.kernel.org/`b4 dig` failed; amd-gfx archive used instead
- No stable-list discussion found

**Step 9.2: STABLE RULES CHECKLIST**

1. Obviously correct and tested? **PASS** — review + drm-next inclusion
2. Fixes a real bug that affects users? **PASS** — ioctl-reachable
   overflow
3. Important (crash/security/corruption/deadlock)? **PASS** — HIGH,
   validation bypass
4. Small and contained? **PASS** — 8-line hunk, one function
5. No new features or APIs? **PASS**
6. Can apply to the local tree? **PASS** — present bug, clean apply on
   6.18.53

**Step 9.3: EXCEPTION CATEGORIES**

Record: Not a device ID/quirk/DT/docs case. Ordinary small overflow fix.

**Step 9.4: DECISION**

This belongs on 6.18.y: old bug, userspace-reachable, tiny fix,
maintainer-acked, applies as-is.

---

### What it solves for stable users

`svm_range_is_valid()` is the gate for `AMDKFD_IOC_SVM`. Without
overflow checks, a wrapping `start+size` can skip the intended VMA
coverage check and still proceed into SVM range insert/map. Zero size
underflows the last-page index. Both are closed with `-EINVAL` /
`-EOVERFLOW`.

### Risk vs benefit

Benefit is closing a GPU SVM validation hole on hardware this tree
already supports. Risk is rejecting inputs that were never valid.

---

### Verification

- [Phase 1] Tags: Eric Huang SOB, Philip Yang Reviewed-by, Alex Deucher
  SOB; no Fixes/Reported-by
- [Phase 2] Diff: +7/−1 in `svm_range_is_valid`; zero check +
  `check_add_overflow`
- [Phase 2] Pre-patch `v6.18.53` still uses `end = start + (size <<
  PAGE_SHIFT)`
- [Phase 3] Blame: `42de677f799997` (2020); ancestor of `v6.18.53` (exit
  0)
- [Phase 3] Fix not in `v6.18.53` (`merge-base --is-ancestor` of
  upstream SHA → not ancestor, exit 1)
- [Phase 3] No prior overflow fix in `kfd_svm.c` on this file’s 6.18.53
  history
- [Phase 4] `b4 dig` failed (lore error)
- [Phase 4] amd-gfx v1 146929; Philip asked for `size==0` on 146952;
  committed form 147065; R-b 147704
- [Phase 5] Callers: `svm_range_set_attr` / `svm_range_get_attr` from
  `svm_ioctl` and CRIU
- [Phase 5] `AMDKFD_IOC_SVM` registered with flags `0` (unprivileged vs
  CRIU)
- [Phase 5] `kfd_ioctl_svm` already rejects `!args->size` and unaligned
  size; overflow still possible
- [Phase 5] `interval_tree_iter_first` returns NULL when `last < start`
  (inverted range)
- [Phase 6] `check_add_overflow` available via hmm.h → mm.h →
  overflow.h; no extra include
- [Phase 6] `HSA_AMD` is 64-bit only — `unsigned long end` is 64-bit
- [Phase 7] Config `HSA_AMD_SVM`, AMD GPU compute
- [Phase 8] Failure: wrap → wrong VMA walk → possible validation bypass;
  HIGH
- UNVERIFIED: no crash repro; lore/stable search incomplete due to HTTP
  403

The patch is small, surgical, and meets the stable criteria for this
6.18.y tree.

**YES**

 drivers/gpu/drm/amd/amdkfd/kfd_svm.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_svm.c b/drivers/gpu/drm/amd/amdkfd/kfd_svm.c
index 202ed1c456320..1b29dee7948d8 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_svm.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_svm.c
@@ -3421,7 +3421,13 @@ svm_range_is_valid(struct kfd_process *p, uint64_t start, uint64_t size)
 	unsigned long start_unchg = start;
 
 	start <<= PAGE_SHIFT;
-	end = start + (size << PAGE_SHIFT);
+
+	if (size == 0)
+		return -EINVAL;
+
+	if (check_add_overflow(start, size << PAGE_SHIFT, &end))
+		return -EOVERFLOW;
+
 	do {
 		vma = vma_lookup(p->mm, start);
 		if (!vma || (vma->vm_flags & device_vma))
-- 
2.53.0

