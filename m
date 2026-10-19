Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBB31546422;
	Mon, 19 Oct 2026 14:06:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418815; cv=none; b=DDiVbRdYyX1nbY7UVoi6R7rjekdpjbrj+aPH3uaMpSk7HaPBk9ZvIWZbvzeEHyBXdNxJK5V8YlUkl9DwkShTn4UBblrQYMQ10+Z1EmmHGci4+UWLBXTU8DI5uSDEmQ2f8ALk81HqgxPdrh35lDLORJdfGcjL33dLcuUl3HnMltQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418815; c=relaxed/simple;
	bh=a96vZeOudisHkaTw5Le90gYqgV+c/SH9KynmdqrMl2A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SvQjO/fmZQ7/Q2UNfQyKtkAE07uKbLfIMU8sooC66tzP3rtDf4tsAIL1Hw1QlDQn57ucBQHOGglmlk75bE/2A5CjvUq6dAcO1KKYyg+Gvk/zohmq2oqpFszW4/pWIii2fz6gxiZwz07t62jxbR00phaDGuLg5TtwyCSIceqX8oc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cLbpZmi3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cLbpZmi3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9F6A1F000C7;
	Mon, 19 Oct 2026 14:06:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418809;
	bh=4ZRgmKFdCpPDginywHt5VsDhsJlJuuAVf2iJq272ijA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cLbpZmi3k+0UfjK47JYAv/pXN9wEGqiMsrqiABpC5iYD5kYaxAdheXOXk/9OUY2WB
	 P/vlfRqF7bmIELWvR33jJKSC0hpPvXvl9WqBFd8J131UMdBe1XpeW5zZegWqxW9OVX
	 wwSrjAo4j3pSoiMwPvpKLyrS00evPXpljc+ZNrYugq2R1RyCfYNcx/fljFhD2F2Qz5
	 7Mp5Fsko9D7b++Hi/CGm9ycayvylQn636/k0aaUj2F737KWxtDDzBhDa17oE0eT6ek
	 VZwv3W4WbN49hpXgjG0yyJ7MONNULM34JK1oLIN39WD65gKE3Td0Fb8YI09fRyW7Ln
	 7ae9aDgqX6YDA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Heiko Carstens <hca@linux.ibm.com>,
	sashiko-bot <sashiko-bot@kernel.org>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>,
	agordeev@linux.ibm.com,
	gerald.schaefer@linux.ibm.com,
	linux-s390@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] s390/mm: Add missing mm check to do_secure_storage_access()
Date: Mon, 19 Oct 2026 09:53:23 -0400
Message-ID: <20261019135441.1420968-512-sashal@kernel.org>
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

From: Heiko Carstens <hca@linux.ibm.com>

[ Upstream commit 7cf227b2707ed0129018c283ffc8f893945586db ]

Similar like the normal exception handler the secure storage access
exception handler needs to verify if mm is not NULL, which may happen
with kernel threads.

Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Closes: https://lore.kernel.org/all/20260717132345.539A11F00A3A@smtp.kernel.org/
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Reviewed-by: Christian Borntraeger <borntraeger@linux.ibm.com>> ---
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The local tree is **7.3.0-rc4** (`v7.3-rc4-27-gf0100363d8c37`). The
candidate is `7cf227b2707ed` (“s390/mm: Add missing mm check to
do_secure_storage_access()”). The function and the unguarded
`current->mm` path exist here; the decision is whether this fix belongs
in this tree on technical merit.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1 — Subject line**
- Record: **[s390/mm]** **[Add]** missing `mm` check in
  `do_secure_storage_access()`. “Add missing … check” is a correctness
  fix, not a feature.

**Step 1.2 — Tags**
- Record:
  - `Reported-by: sashiko-bot <sashiko-bot@kernel.org>` — static/AI
    review, not syzbot
  - `Closes: https://lore.kernel.org/all/20260717132345.539A11F00A3A@smt
    p.kernel.org/`
  - `Signed-off-by: Heiko Carstens <hca@linux.ibm.com>` (author; s390
    architecture maintainer)
  - `Reviewed-by: Christian Borntraeger <borntraeger@linux.ibm.com>`
    (KVM/s390)
  - `Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>` (s390 maintainer,
    applied)
  - No `Fixes:`, no `Cc: stable` (expected for this pipeline)
  - Ignore any Sasha Levin SOB (none on the real commit)

**Step 1.3 — Body**
- Record:
  - **Bug:** secure-storage exception handler did not check `current->mm
    != NULL`, unlike `do_exception()`.
  - **Symptom:** kernel thread with `mm == NULL` can hit PGM 0x3d and
    then `mmap_read_lock(NULL)`.
  - **Failure mode:** NULL dereference in the exception handler.
  - **Root cause:** user-fault path assumed `current->mm` was always
    valid.
  - **Version info:** none in the message. Function dates to 2020
    (`084ea4d611a3d0`).

**Step 1.4 — Hidden bug fix?**
- Record: Not hidden. Explicit missing-check / NULL-deref fix. Not
  cleanup disguised as a fix.

---

## PHASE 2: DIFF ANALYSIS

**Step 2.1 — Inventory**
- Record:
  - File: `arch/s390/mm/fault.c` (+2 / −3)
  - Function: `do_secure_storage_access()`
  - Scope: single-file surgical fix

**Step 2.2 — Code flow**
- Record:
  - **Before:** user-fault path did `if (faulthandler_disabled())` then
    `mm = current->mm; mmap_read_lock(mm)`.
  - **After:** `mm = current->mm` is taken first; path is `if
    (faulthandler_disabled() || !mm) return
    handle_fault_error_nolock(regs, 0);`
  - Affected path: non-kernel-fault PGM 0x3d (user mode, or kernel
    uaccess via secondary space).
  - `handle_fault_error_nolock()` is already the no-lock fallback: user
    SIGSEGV, or kernel `fixup_exception()` / oops.

**Step 2.3 — Bug mechanism**
- Record:
  - **Category:** memory safety — NULL pointer dereference
  - **Mechanism:** `mmap_read_lock(mm)` with `mm == NULL` (kernel
    thread).
  - **Fix:** same `!mm` guard as `do_exception()` at line 285.

**Step 2.4 — Fix quality**
- Record:
  - Obviously correct: one extra condition, same pattern as the normal
    fault handler.
  - Minimal; no unrelated edits.
  - Regression risk is very low: the new path only avoids locking a NULL
    `mm`. For kernel uaccess, `handle_fault_error_nolock()` runs
    exception fixups and returns `-EFAULT`, which is the intended
    behavior (same as `do_exception()` and as `11709abccf93b` for atomic
    context).

---

## PHASE 3: GIT HISTORY

**Step 3.1 — Blame**
- Record:
  - `do_secure_storage_access()` introduced in `084ea4d611a3d0`
    (2020-01-21): already did `mm = current->mm;
    down_read(&mm->mmap_sem)` with no NULL check.
  - `11709abccf93b` (2025-06-03) added `faulthandler_disabled()` after a
    real qemu crash (`copy_page_from_iter_atomic` → PGM 0x3d while
    `in_atomic`), but still assigned `mm = current->mm` afterward with
    no `!mm` check.
  - The `!mm` check on this path is `7cf227b2707ed` itself.
  - `do_exception()` has had `faulthandler_disabled() || !mm` for years
    (`a12d622ad541b5` / `70ffdb9393a72`).

**Step 3.2 — Fixes: tag**
- Record: No `Fixes:` tag. The incomplete guard is from `11709abccf93b`
  (in this tree). The NULL-mm hole has existed since the handler was
  added in 2020.

**Step 3.3 — File history**
- Record: This is v4 2/8 of “Reintroduce support for
  DCACHE_WORD_ACCESS”. Neighbors:
  - 1/8 VM_SPARSE (unrelated feature)
  - 3/8 `lock_mm_and_find_vma()` (refactor; still needs `mm != NULL`)
  - 4–7 more handler cleanups
  - 8/8 DCACHE_WORD_ACCESS feature
- This patch is standalone. It does not depend on 1/8 or 8/8.

**Step 3.4 — Author**
- Record: Heiko Carstens is s390 architecture maintainer (`MAINTAINERS`:
  S390 ARCHITECTURE). He wrote the 2025 atomic-context fix and this
  follow-up. Borntraeger reviewed.

**Step 3.5 — Prerequisites**
- Record: None. It only adds `|| !mm` next to an existing
  `faulthandler_disabled()` check. Applies standalone on this tree’s
  `fault.c`.

---

## PHASE 4: MAILING LIST / EXTERNAL

**Step 4.1 — Original discussion**
- Record:
  - `b4 dig -c 7cf227b2707ed` →
    https://patch.msgid.link/20260720085834.898025-3-hca@linux.ibm.com
  - `b4 dig -a`: v1/v2 were VM_SPARSE-only; v3 “Reintroduce
    DCACHE_WORD_ACCESS”; v4 is the applied series. This mm-check first
    appears as v4 2/8.
  - Sashiko report (Closes:): **[High] Missing !mm check … kernel
    threads faulting on user-space accesses … NULL pointer
    dereference.** Example given: `copy_from_user()` onto a secure page
    from a kernel thread, then `mmap_read_lock(NULL)`.
  - Alexander Gordeev (S390 MM) called that sashiko note a **false
    positive** on a related patch.
  - Heiko still took the check: he wanted the handler to match
    `do_exception()` and to address the sashiko reports. Borntraeger
    gave `Reviewed-by` on this exact patch. No NAK.

**Step 4.2 — Recipients (`b4 dig -w`)**
- Record: Heiko, Gordeev, Schnelle, Gorbik, Borntraeger, Frank,
  Imbrenda, Hildenbrand; `linux-s390@`, `kvm@`, `linux-kernel@`. Right
  maintainers were on CC.

**Step 4.3 — Bug report**
- Record: Sashiko static finding, severity High. Not a user crash log
  for the `!mm` case. The related 2025 bug *was* a real qemu oops on
  this same handler. WebFetch/curl to lore returned 403; thread was
  recovered with `b4 mbox`.

**Step 4.4 — Series**
- Record: Bundled with a feature series, but this hunk is an independent
  NULL check. Other 2/8–7/8 patches are not required for this guard.

**Step 4.5 — Stable list**
- Record: **UNVERIFIED** — lore.kernel.org `/stable/` returned 403. No
  stable discussion found in the saved v4 mbox (no `Cc: stable` in
  review).

---

## PHASE 5: CODE SEMANTICS

**Step 5.1 — Functions**
- Record: `do_secure_storage_access()` only.

**Step 5.2 — Callers**
- Record: Trap table in `arch/s390/kernel/traps.c`: `[0x3d] =
  do_secure_storage_access`. Hardware PGM 0x3d (secure storage access).
  `COND_TRAP` weak-aliases to `default_trap_handler` if the symbol is
  absent. Reached from `__do_pgm_check` → exception handler, not a
  normal syscall helper.

**Step 5.3 — Callees**
- Record: After the check: `lock_mm_and_find_vma` / `mmap_read_lock`,
  `folio_walk_*`, `arch_make_folio_accessible`. On the new path:
  `handle_fault_error_nolock()` only (no lock, no folio walk).

**Step 5.4 — Reachability**
- Record: `is_kernel_fault()` is false for user mode, or kernel mode
  with `teid.as == PSW_BITS_AS_SECONDARY` (uaccess). User processes have
  an `mm`. Kernel threads have `current->mm == NULL` unless `use_mm()`.
- Reachable in principle: kernel-thread uaccess to a secure page without
  `use_mm()`.
- Confirmed real traffic on this handler: `11709abccf93b` stack (qemu
  `vfs_write` → `copy_page_from_iter_atomic` → PGM 0x3d). Those tasks
  have an `mm`; they hit the atomic case, not `!mm`.
- Userspace-reachable for normal tasks: yes, but they have `mm`, so this
  check does not change that path.

**Step 5.5 — Similar patterns**
- Record: `do_exception()` already uses `is_kernel_fault() ||
  faulthandler_disabled() || !mm`. This commit brings the secure handler
  in line. No other copy of this hole in `fault.c`.

---

## PHASE 6: LOCAL TREE

**Step 6.1 — Does the buggy code exist here?**
- Record: Yes. Tree is **7.3.0-rc4**. `do_secure_storage_access()` is in
  `arch/s390/mm/fault.c` under `CONFIG_KVM`. Current source already has
  `if (faulthandler_disabled() || !mm)` at line 451 (`git merge-base
  --is-ancestor 7cf227b2707ed HEAD` succeeded). The unguarded
  `mmap_read_lock(current->mm)` pattern was present from 2020 until this
  commit (v7.3-rc1).

**Step 6.2 — Backport difficulty**
- Record: Clean apply on this tree. Later refactors
  (`lock_mm_and_find_vma`, goto, `__context_unsafe`) still keep the
  `!mm` check.

**Step 6.3 — Related fixes already here?**
- Record: `11709abccf93b` is here (atomic/`faulthandler_disabled` only).
  No earlier `!mm` fix on this path. This commit is the `!mm` fix.

---

## PHASE 7: SUBSYSTEM

**Step 7.1**
- Record: **s390 MM / Secure Execution (Ultravisor) exception
  handling**. Criticality: **IMPORTANT** on s390 with KVM/protected
  virtualization; not core-universal. Not staging.

**Step 7.2**
- Record: Active. Multiple 2025–2026 fixes on this same function (atomic
  handling, donated-memory fixups, folio_walk, vmalloc). Mature handler,
  still getting real-bug fixes.

---

## PHASE 8: IMPACT AND RISK

**Step 8.1 — Who is affected**
- Record: s390 systems with `CONFIG_KVM` that take PGM 0x3d (Secure
  Execution / protected virt). Not universal.

**Step 8.2 — Trigger**
- Record: Kernel thread (`current->mm == NULL`) takes a user/secondary-
  space secure-storage exception (e.g. uaccess to a secure page).
  Unprivileged users do not directly set `mm` to NULL. Likelihood is
  lower than the 2025 atomic qemu case; Gordeev called the sashiko
  report a false positive. Heiko still treated the check as required for
  parity with `do_exception()`.

**Step 8.3 — Failure mode**
- Record: `mmap_read_lock(NULL)` → kernel oops. **Severity: HIGH** if
  the path runs; **MEDIUM** if it is only defensive. Exception-handler
  NULL deref is still a crash class of bug.

**Step 8.4 — Risk vs benefit**
- Record:
  - **Benefit:** Medium–high. Prevents an oops on a path that already
    crashed qemu in atomic context; completes the standard three-way
    fault-handler guard.
  - **Risk:** Very low. One condition, error-path only, same semantics
    as `do_exception()`.
  - **Ratio:** Favor including it.

---

## PHASE 9: SYNTHESIS

**Step 9.1 — Evidence**

**For:**
- Real NULL-deref if `mm` is NULL before `mmap_read_lock()`.
- Same guard `do_exception()` has used for years.
- Same function already needed a production fix (`11709abccf93b`) for
  kernel uaccess to secure pages.
- 5-line, obviously correct change; `handle_fault_error_nolock()` is the
  right fallback (exception fixup / `-EFAULT`).
- Written by the s390 arch maintainer; Reviewed-by Borntraeger.
- Sashiko rated the hole High and described the `copy_from_user` +
  kernel-thread scenario.
- Code exists in this 7.3-rc4 tree; no missing prerequisites.

**Against:**
- Gordeev called the sashiko `!mm` note a false positive (may not be hit
  by real kernel threads that use `use_mm()`).
- No live crash log for the `!mm` case (sashiko static analysis).
- s390 + KVM + Secure Execution only.
- Landed as 2/8 of a feature series (the hunk itself is independent).

**Unresolved:**
- Stable-list history (lore `/stable/` 403).
- No public reproducer of a kernel-thread `!mm` crash.

**Step 9.2 — Stable rules**
1. Obviously correct and tested? **PASS** — one condition, reviewed by
   KVM/s390, applied by s390 maintainer.
2. Fixes a real bug that affects users? **PASS** — NULL `mm` then
   `mmap_read_lock()` is a real oops; sibling path already crashed qemu.
   Trigger may be uncommon, but the hole is real.
3. Important (crash/security/corruption/deadlock)? **PASS** — exception-
   handler NULL deref / oops.
4. Small and contained? **PASS** — +2/−3 in one function.
5. No new features/APIs? **PASS**.
6. Applies to this tree? **PASS** — `fault.c` and the user-fault path
   are present; patch is trivial here.

**Step 9.3 — Exceptions**
- Record: None (not a device ID, quirk, DT, build, or docs fix).
  Qualifies as a normal crash-prevention fix.

**Step 9.4 — Decision**
This tree has the handler and had the unguarded `mm` use. The fix is a
one-line NULL check that matches `do_exception()` and closes a crash
path in the PGM 0x3d handler. Benefit outweighs risk.

---

### What the commit solves (for this tree)

`do_secure_storage_access()` handles s390 PGM 0x3d. On the
user/secondary-space path it took `mmap_read_lock(current->mm)` without
checking `mm`. Kernel threads have `mm == NULL`, so that is a NULL
deref. `do_exception()` already checks `faulthandler_disabled() || !mm`.
The 2025 commit added only the atomic half after a qemu oops; this
commit adds the missing `!mm` half. On this 7.3-rc4 tree the function
exists and the check is the right fix.

### Risk vs benefit

Very low risk, meaningful crash-prevention benefit on s390 KVM/Secure
Execution. No API or structural change.

---

Verification:
- [Phase 1] Parsed tags: Reported-by sashiko-bot; Closes lore msgid
  `20260717132345.539A11F00A3A`; Reviewed-by Borntraeger; SOB Heiko +
  Gorbik; no Fixes/Cc-stable
- [Phase 1] Body: kernel-thread `mm == NULL` vs normal exception handler
- [Phase 2] Diff: `arch/s390/mm/fault.c` +2/−3; `if
  (faulthandler_disabled() || !mm)` then `handle_fault_error_nolock`
- [Phase 2] Confirmed `handle_fault_error_nolock()` does
  fixup/SIGSEGV/oops and does not unlock `mm`
- [Phase 3] `git show 7cf227b2707ed`; ancestor of HEAD
- [Phase 3] Blame: function from `084ea4d611a3d0` (2020); `!mm` on
  `do_exception` long-standing; `faulthandler_disabled` only from
  `11709abccf93b` (2025)
- [Phase 3] `git show 11709abccf93b`: real qemu stack, sleeping on
  mmap_lock in atomic PGM 0x3d
- [Phase 3] Series neighbors 79ef8d384fdfb…46a8c8d142ba8 do not replace
  this check
- [Phase 4] `b4 dig -c 7cf227b2707ed`:
  https://patch.msgid.link/20260720085834.898025-3-hca@linux.ibm.com
- [Phase 4] `b4 dig -a`: v4 is the applied series; this is 2/8
- [Phase 4] `b4 dig -w`: s390 + KVM maintainers on CC
- [Phase 4] `b4 mbox` of Closes: sashiko [High] NULL deref; Gordeev
  “false positive”; Heiko still aligned with `do_exception()`
- [Phase 4] WebFetch/curl lore: 403; UNVERIFIED: stable@ discussion
- [Phase 5] `git grep do_secure_storage_access`: `traps.c` PGM 0x3d +
  `entry.h`
- [Phase 5] Read `is_kernel_fault()`: user mode or secondary AS → user
  path
- [Phase 6] `git describe HEAD` = v7.3-rc4-27-gf0100363d8c37; `make
  kernelversion` = 7.3.0-rc4
- [Phase 6] Current `fault.c:451` has `faulthandler_disabled() || !mm`
- [Phase 7] MAINTAINERS: Heiko = S390 ARCHITECTURE; Gordeev = S390 MM
- [Phase 8] Failure mode: NULL deref in exception handler; trigger
  narrower than the 2025 atomic bug
- UNVERIFIED: whether a kernel thread without `use_mm()` has hit this on
  a production machine; Gordeev doubted it

The fix is small, matches the existing fault-handler contract, and
prevents an oops on this tree’s s390 secure-storage path.

**YES**

 arch/s390/mm/fault.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/s390/mm/fault.c b/arch/s390/mm/fault.c
index 069f72703a915..46e5748b5b1b3 100644
--- a/arch/s390/mm/fault.c
+++ b/arch/s390/mm/fault.c
@@ -404,9 +404,9 @@ void do_secure_storage_access(struct pt_regs *regs)
 {
 	union teid teid = { .val = regs->int_parm_long };
 	unsigned long addr = get_fault_address(regs);
+	struct mm_struct *mm = current->mm;
 	struct vm_area_struct *vma;
 	struct folio_walk fw;
-	struct mm_struct *mm;
 	struct folio *folio;
 	int rc;
 
@@ -448,9 +448,8 @@ void do_secure_storage_access(struct pt_regs *regs)
 		if (rc)
 			return handle_fault_error_nolock(regs, 0);
 	} else {
-		if (faulthandler_disabled())
+		if (faulthandler_disabled() || !mm)
 			return handle_fault_error_nolock(regs, 0);
-		mm = current->mm;
 		mmap_read_lock(mm);
 		vma = find_vma(mm, addr);
 		if (!vma)
-- 
2.53.0

