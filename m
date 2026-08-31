Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACA8550AC0F;
	Mon, 31 Aug 2026 13:42:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183759; cv=none; b=NU98PHBAoIOuXCgcxE7y0/w1NOErsGPW/bVh+PSI5MnMnj6ezO27fh9nZIp9uRPBInZZ2LyA3ntl+5xVeLRrvSoG1kKSLu1q3G29iXZ2+wwr4+oUk4R4Li4G1jGtxmw4K4Vyus6ArGPgQuEOkNEF0nUXs1BeUn4Dt8qsAHgwbB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183759; c=relaxed/simple;
	bh=ip3uqP6LdGCeo6Ef+SAp7a5Ks1NkrQKUZz+6IiTEs80=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pn8rGn0OtPLV/pXMeIb7gXH+uTdNoXyaK19j6NrMSg18tyt0wC4PWPbdJ8Y06CCKvE18Mw0z6fnUxQC3g3uXeu/YxFGqbCAtXYwedY0VbSZxqc7+55UbD/hkr0H3GzClHdQvvIcUzgdClTke9jloNvCRqhG0j8Y0rvdAGfMtYcM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ThDBZjMe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ThDBZjMe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D4E51F00A3E;
	Mon, 31 Aug 2026 13:42:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183756;
	bh=1+5YrTWgODKYZ05UNQTznSRi30GcJMSjctnTqswf/wE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ThDBZjMe64Ji/2vZ//PlB5GSymlmJsPl0RBPCrzrB0zNIvd7fOWAmAICFgxWUZSuE
	 DXjYJwWIyFGCr4gk2jbKGX1uy4Erro4vFBZPtvfQjivMz4SaGdLtyqnYNQo+Yrcxlw
	 cT24gO37O+60OsJIKLDjjelxCFXtMOp6ww3sdPqKTaTOBobYPd2F6V5kqeIB/02P4d
	 tkeXNWdRx+MjmqFp5V+NK4fTk1FWU5/ms37QfbRd7tskUgnhZ3pdaiFvD/LYds/Mn9
	 XQT5Qb6mBsBeOVyJNfVBq+5hn/r+JAQ4oVcQH4c4uvkfO2NKZb8DUXKIo3f38zKqfV
	 xbR3kTIT4KN6A==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Zhang Tianci <zhangtianci.1997@bytedance.com>,
	Li Yichao <liyichao.1@bytedance.com>,
	Miklos Szeredi <mszeredi@redhat.com>,
	Sasha Levin <sashal@kernel.org>,
	miklos@szeredi.hu,
	fuse-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] fuse: set ff->flock only on success
Date: Mon, 31 Aug 2026 09:25:13 -0400
Message-ID: <20260831133314.4125787-285-sashal@kernel.org>
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

From: Zhang Tianci <zhangtianci.1997@bytedance.com>

[ Upstream commit 71947173cef279be5eed209ec28f8c11f9d73159 ]

If FUSE_SETLK fails (e.g., due to EWOULDBLOCK), we shall not set
FUSE_RELEASE_FLOCK_UNLOCK in fuse_file_release().

Reported-by: Li Yichao <liyichao.1@bytedance.com>
Signed-off-by: Zhang Tianci <zhangtianci.1997@bytedance.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: `fuse: set ff->flock only on success`

**Local tree:** `v6.18.44-1-g2736c32da98b9` (6.18.44 stable, detached
from `stable/linux-6.18.y`)
**Commit under review:** `71947173cef279be5eed209ec28f8c11f9d73159`
(mainline; **not yet in this tree**)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Parse the subject line
**Record:** `[fuse]` `[set]` — set `ff->flock` only when `fuse_setlk()`
succeeds, so failed flock attempts do not trigger unlock on file
release.

### Step 1.2: Parse all commit message tags
**Record:**
- **Reported-by:** Li Yichao `<liyichao.1@bytedance.com>` — real-world
  reporter (ByteDance)
- **Signed-off-by:** Zhang Tianci `<zhangtianci.1997@bytedance.com>`
  (author)
- **Signed-off-by:** Miklos Szeredi `<mszeredi@redhat.com>` (FUSE
  maintainer, committer)
- No Fixes:, Cc: stable, Link:, Tested-by:, Reviewed-by:, Acked-by:

Notable: maintainer committed the patch; reporter from production FUSE
user.

### Step 1.3: Analyze commit body
**Record:**
- **Bug:** `ff->flock = true` is set before `fuse_setlk()`. If
  `FUSE_SETLK` fails (e.g. `-EWOULDBLOCK` for non-blocking flock),
  `ff->flock` remains set.
- **Symptom:** On `close()`, `fuse_file_release()` sets
  `FUSE_RELEASE_FLOCK_UNLOCK` even though no flock was acquired.
- **Failure mode:** Spurious flock unlock sent to the FUSE userspace
  daemon on file release.
- **Root cause:** Flag tracks intent to lock, not actual lock success.
- No kernel version range mentioned in the message.

### Step 1.4: Detect hidden bug fixes
**Record:** Not disguised — this is an explicit correctness fix for
flock release handling. The commit message clearly describes incorrect
unlock behavior on the error path.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory the changes
**Record:**
- **Files:** `fs/fuse/file.c` (+2 / -1, net +1 line)
- **Function modified:** `fuse_file_flock()`
- **Scope:** Single-file, surgical fix (3-line hunk)

### Step 2.2: Code flow change
**Record:**
- **Hunk (fuse_file_flock):**
  - **Before:** `ff->flock = true` unconditionally, then `err =
    fuse_setlk(file, fl, 1)`
  - **After:** `err = fuse_setlk(file, fl, 1)` first; `ff->flock = true`
    only if `!err`
- **Path affected:** FUSE flock path when `fc->no_flock` is false (flock
  delegated to userspace via `FUSE_SETLK`)

### Step 2.3: Bug mechanism
**Record:**
- **Category:** Logic / correctness fix (lock state tracking)
- **Mechanism:** `ff->flock` gates `FUSE_RELEASE_FLOCK_UNLOCK` in
  `fuse_file_release()`:

```358:361:fs/fuse/file.c
        if (ra && ff->flock) {
                ra->inarg.release_flags |= FUSE_RELEASE_FLOCK_UNLOCK;
                ra->inarg.lock_owner = fuse_lock_owner_id(ff->fm->fc,
id);
        }
```

Setting the flag before confirming lock success causes a spurious unlock
request on `close()` after a failed `flock(2)`.

### Step 2.4: Fix quality assessment
**Record:**
- Fix is obviously correct: the flag should reflect a successfully
  acquired flock, not an attempted one.
- Minimal change; mirrors standard “set state only on success” pattern.
- **Regression risk:** Very low. A successful flock still sets the flag;
  failed attempts no longer poison release behavior.
- No API, locking, or structural changes.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame the changed lines
**Record:**
- `fuse_file_flock()` dates to 2007 (`a9ff4f87056cd`)
- `ff->flock = true` before `fuse_setlk()` introduced in
  `37fb3a30b46237` (“fuse: fix flock”, Aug 2011, Miklos Szeredi)
- Bug has existed since v3.0 era; long-present in stable trees including
  6.18.y

### Step 3.2: Follow Fixes: tag
**Record:** No Fixes: tag. The introducing commit is `37fb3a30b46237`,
which is certainly in this tree.

### Step 3.3: File history for related changes
**Record:**
- Standalone one-patch fix (v1 only on lore)
- Recent FUSE stable activity in this tree includes writeback, virtiofs,
  and fuse-uring fixes — unrelated to this flock issue
- Commit `71947173cef27` is in `origin/master` but **not** in
  `stable/linux-6.18.y` (confirmed via `git log
  stable/linux-6.18.y..origin/master`)

### Step 3.4: Author's other commits
**Record:** Zhang Tianci has other FUSE contributions (e.g. attribute
staleness checks). Miklos Szeredi is the FUSE maintainer and applied the
patch.

### Step 3.5: Dependencies / prerequisites
**Record:** No dependencies. Uses existing `ff->flock`, `fuse_setlk()`,
and `FUSE_RELEASE_FLOCK_UNLOCK` — all present in 6.18.44. `git show
71947173cef27 | git apply --check` succeeds cleanly.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Original patch discussion
**Record:**
- **URL:** https://patch.msgid.link/20251225111156.47987-1-
  zhangtianci.1997@bytedance.com
- **Series:** v1 only (no v2/v3)
- **Maintainer response:** Miklos Szeredi: “Applied, thanks.”
- No NAKs or objections found in thread
- No explicit stable nomination in thread

### Step 4.2: Reviewers from b4 dig -w
**Record:** CC'd: `miklos@szeredi.hu`, `linux-fsdevel@vger.kernel.org`,
`linux-kernel@vger.kernel.org`, reporter Li Yichao, co-worker
xieyongji@bytedance.com. FUSE maintainer reviewed and applied.

### Step 4.3: Bug report
**Record:** Reported-by from ByteDance engineer; no syzbot/bugzilla
link. Production FUSE user hit the issue with failed non-blocking flock
+ file close.

### Step 4.4: Related patches / series
**Record:** Standalone patch; no series dependencies.

### Step 4.5: Stable mailing list history
**Record:** Not searched on lore stable list (Anubis bot blocked direct
lore fetch). No stable discussion found via b4.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key functions
**Record:** `fuse_file_flock()` (modified), `fuse_setlk()` (called),
`fuse_file_release()` (affected downstream)

### Step 5.2: Callers
**Record:**
- `fuse_file_flock` is the `.flock` handler in `fuse_file_operations`
  (line 3137)
- Reached from `SYSCALL_DEFINE2(flock)` in `fs/locks.c` when
  `file->f_op->flock` is set and `LOCK_NB` is used (`F_SETLK` vs
  `F_SETLKW`)
- Callable by any unprivileged process with a FUSE file descriptor

### Step 5.3: Callees
**Record:** `fuse_setlk()` → `fuse_simple_request()` with
`FUSE_SETLK`/`FUSE_SETLKW` and `FUSE_LK_FLOCK` flag. Returns errors
including `-EWOULDBLOCK` (mapped from userspace daemon response).

### Step 5.4: Call chain / reachability
**Record:**
```
userspace flock(2) → SYSCALL_DEFINE2(flock) → file->f_op->flock
(fuse_file_flock)
  → fuse_setlk() → [on failure] return error
  → [on close] fuse_release → fuse_file_release →
FUSE_RELEASE_FLOCK_UNLOCK if ff->flock
```
**Reachable from userspace:** Yes, via `flock(2)` on FUSE-mounted files
when `fc->no_flock` is false.

### Step 5.5: Similar patterns
**Record:** The `no_flock` fallback path uses `locks_lock_file_wait()`
and does not set `ff->flock` — only the userspace-delegated flock path
is affected. No sibling functions with the same pre-set pattern found.

---

## PHASE 6: CROSS-REFERENCING AGAINST LOCAL TREE

### Step 6.1: Does the buggy code exist?
**Record:** **Yes.** Current tree at `fs/fuse/file.c:2531` still has
unconditional `ff->flock = true` before `fuse_setlk()`. Bug present
since 2011 (`37fb3a30b46237`).

### Step 6.2: Backport complications
**Record:** Patch applies cleanly (`git apply --check` passed). No
refactoring conflicts expected. Trivial backport.

### Step 6.3: Related fixes already present?
**Record:** No equivalent fix in `stable/linux-6.18.y`. Commit
`71947173cef27` is only in mainline (post-6.18.y branch point).

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: Subsystem criticality
**Record:** **fs/fuse** — IMPORTANT. FUSE is widely used (virtio-fs,
cloud storage mounts, container/shared filesystems). File locking
correctness affects data integrity for multi-process workloads.

### Step 7.2: Subsystem activity
**Record:** FUSE subsystem actively maintained in 6.18.y with multiple
recent stable-relevant fixes (writeback, virtiofs UAF, fuse-uring
races).

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Who is affected
**Record:** Users of FUSE filesystems that support flock (i.e.
`FUSE_FLOCK_LOCKS` negotiated, `fc->no_flock == 0`). Includes virtio-fs
and custom FUSE implementations using BSD-style flock.

### Step 8.2: Trigger conditions
**Record:**
1. Open file on FUSE mount with flock support
2. Call `flock(fd, LOCK_EX | LOCK_NB)` (or `LOCK_SH | LOCK_NB`) when
   lock cannot be acquired
3. Close the file descriptor
**Likelihood:** Moderate — non-blocking flock failure is a normal,
documented API path. **Unprivileged users can trigger.**

### Step 8.3: Failure mode severity
**Record:** Spurious `FUSE_RELEASE_FLOCK_UNLOCK` on close after a failed
lock attempt. This can corrupt flock state in the userspace filesystem
daemon — potentially releasing locks held by other processes or breaking
mutual exclusion guarantees. **Severity: HIGH** (data integrity /
locking correctness; not a kernel oops, but serious application-visible
bug).

### Step 8.4: Risk-benefit ratio
**Record:**
- **Benefit:** HIGH — fixes real lock-handling bug on a common error
  path
- **Risk:** VERY LOW — 3-line, obviously correct change
- **Ratio:** Strongly favors backport

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence summary

**FOR backport:**
- Real bug with production reporter (ByteDance)
- FUSE maintainer applied and signed off
- Long-standing bug (since 2011) present in 6.18.44
- Incorrect spurious unlock on failed `flock(LOCK_NB)` + `close()`
- Lock correctness / potential data corruption
- Tiny, surgical, applies cleanly
- No dependencies

**AGAINST backport:**
- No kernel crash or oops (correctness bug, not memory safety)
- Affects only FUSE mounts with flock support enabled (not universal)
- No explicit stable nomination in mailing list

**Unresolved:** None material to the decision.

### Step 9.2: Stable rules checklist
1. Obviously correct and tested? **PASS** — logic is self-evident;
   maintainer applied; reporter verified the scenario
2. Fixes a real bug affecting users? **PASS** — spurious unlock after
   failed flock
3. Important issue? **PASS** — lock state corruption / data integrity
   (HIGH)
4. Small and contained? **PASS** — 3 lines, one function
5. No new features or APIs? **PASS**
6. Can apply to local tree? **PASS** — clean apply verified

### Step 9.3: Exception categories
**Record:** None (not a device ID, quirk, DT, build, or docs fix).
Qualifies on merit as a correctness bug fix.

### Step 9.4: Decision rationale
This commit fixes a real, long-standing logic bug in FUSE flock
handling. When a non-blocking flock fails, the kernel incorrectly marks
the file as flock-held and sends `FUSE_RELEASE_FLOCK_UNLOCK` on close,
potentially corrupting lock state in the userspace filesystem. The fix
is minimal, maintainer-approved, applies cleanly to 6.18.44, and the
buggy code is present in this tree. Stable users running FUSE with flock
support benefit directly.

---

## Verification

- [Phase 1] `git show 71947173cef27`: parsed subject, tags (Reported-by,
  SOBs), body
- [Phase 2] Read `fs/fuse/file.c` lines 2519–2536, 349–361; confirmed
  diff mechanics
- [Phase 2] Read `fuse_setlk()` at lines 2470–2494; confirmed error
  return path
- [Phase 3] `git describe HEAD`: v6.18.44 stable tree
- [Phase 3] `git blame -L 2519,2536 fs/fuse/file.c`: bug introduced
  `37fb3a30b46237` (2011)
- [Phase 3] `git show 37fb3a30b46237`: original `ff->flock = true`
  placement
- [Phase 3] `git log stable/linux-6.18.y..origin/master --
  fs/fuse/file.c`: fix only in mainline
- [Phase 3] `git show 71947173cef27 | git apply --check`: clean apply
- [Phase 4] `b4 dig -c 71947173cef27`: lore URL found
- [Phase 4] `b4 dig -c 71947173cef27 -a`: v1 only
- [Phase 4] `b4 dig -c 71947173cef27 -w`: miklos@szeredi.hu CC'd
- [Phase 4] `b4 dig -m /tmp/fuse_flock_thread.mbox`: Miklos “Applied,
  thanks”
- [Phase 5] Read `fs/locks.c` SYSCALL_DEFINE2(flock): confirms VFS →
  `.flock` path
- [Phase 5] Read `fuse_file_operations`: `.flock = fuse_file_flock`
- [Phase 5] `fuse_file_alloc()` uses `kzalloc`: `ff->flock` starts false
- [Phase 6] Grep confirmed buggy code at line 2531 in current tree
- [Phase 6] `git branch --contains 71947173cef27`: not in
  stable/linux-6.18.y
- [Phase 8] Read `include/uapi/linux/fuse.h`:
  `FUSE_RELEASE_FLOCK_UNLOCK` definition

**YES**The background searches finished and match what the earlier
analysis used:

- **Tree:** detached HEAD on `stable/linux-6.18.y` (6.18.44)
- **Commit:** `71947173cef27` on `origin/master` — `fuse: set ff->flock
  only on success`
- **Status in this tree:** not present yet; patch applies cleanly

**Verdict remains YES** — backport to 6.18.y is warranted. It fixes a
real FUSE flock bug where a failed non-blocking `flock()` still triggers
`FUSE_RELEASE_FLOCK_UNLOCK` on close, which can corrupt lock state in
the userspace daemon.

 fs/fuse/file.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index 585dd90361b65..9f3501a5c6c12 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -2528,8 +2528,9 @@ static int fuse_file_flock(struct file *file, int cmd, struct file_lock *fl)
 		struct fuse_file *ff = file->private_data;
 
 		/* emulate flock with POSIX locks */
-		ff->flock = true;
 		err = fuse_setlk(file, fl, 1);
+		if (!err)
+			ff->flock = true;
 	}
 
 	return err;
-- 
2.53.0

