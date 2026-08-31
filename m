Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14DA5556B9A;
	Mon, 31 Aug 2026 13:47:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184028; cv=none; b=d5nSxf9XjIWMOiRQuNlToPywbVSdqcptIT+S9jBfOfFEboRCIpsjXcX6GabyBi8cJ0o43YuHhqo4WaDKjgobTDmvB7S+Pt6Ry94RWoncFL0QCGFtpZiEz29fWp8IVrMEalJXDI0UYhLRxRbmbyj7JY67lksJMc5YvY5ekPWM174=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184028; c=relaxed/simple;
	bh=RBNjRkbwJziDSeepFv501x5dr58Ol0Wq83EhG8icR+g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tbSAiIElATSvicwe3FySM1vzEeZWcsBLXXSdJ8UNodlNCdTxqG1pj5ohX0EpkWkWL4jd4Lb2Vnx25Pd9PPhSpJ+OrxtVgTarPZv5VFLGM06g9ikMLq+XUkJ0l15qO2olkta5u/5K9p2utecdxqDu6Daj0DJhDaAKpojuW+Z1gxo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IwkQfI55; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IwkQfI55"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01D8B1F00A3F;
	Mon, 31 Aug 2026 13:47:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788184025;
	bh=GDe0gr+b9U72FE5tClsc92dN/kS6BmaE5npMBXYeLVQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IwkQfI55pQjW51CLPjeYWpyjarSM0RkKifcIhEW8/XpKKWC//Ha+WeLEvqj48KBnO
	 rk7oaazQ9C413VTHaWjzcKW/gZyAiGhf6xZLoWUz4Dx4qrwdVSNRZAUId7vAjl6kvt
	 Mk38HNIL+8KLIQQnIsj2ine+RQJBkvB/89Phc492BbMhcz+mi62tbPdlYS2GSpx6tG
	 ASwc2bq8PdWKPI5VgeVwVh23k2vtqGONrHiuu7UX0SvhYjICxxesSSDOfuEd5bgd/5
	 bZHq3C1JRBEhxdydJ2ASP7o7B+KGLJneXDJsi23nhw1pg0haMTSBWKPqtAPW3mINtI
	 oFzmabRVj2lbg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Christian Brauner <brauner@kernel.org>,
	Li Chen <me@linux.beauty>,
	Jan Kara <jack@suse.cz>,
	Sasha Levin <sashal@kernel.org>,
	viro@zeniv.linux.org.uk,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] pidfs: preserve thread pidfds reopened by file handle
Date: Mon, 31 Aug 2026 09:27:53 -0400
Message-ID: <20260831133314.4125787-445-sashal@kernel.org>
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

From: Christian Brauner <brauner@kernel.org>

[ Upstream commit bb6bc13c53e211d9148ed2eab3e689c5cd5c75da ]

PIDFD_THREAD shares O_EXCL. do_dentry_open() clears O_EXCL after
pidfs_export_open() validates the flags, so open_by_handle_at()
silently turns a thread pidfd into a process pidfd.

Restore PIDFD_THREAD on the opened file, matching pidfs_alloc_file().

Signed-off-by: Li Chen <me@linux.beauty>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://patch.msgid.link/20260716052726.1032092-1-me@linux.beauty
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit Message Forensics

### Step 1.1: Subject Line
**Record:** `[pidfs]` `[preserve]` — Preserve thread pidfd semantics
when a pidfd is reopened via file handle (`open_by_handle_at()`).

### Step 1.2: Tags
**Record:**
- **Reviewed-by:** Jan Kara `<jack@suse.cz>`
- **Link:**
  https://patch.msgid.link/20260716052726.1032092-1-me@linux.beauty
- **Signed-off-by:** Li Chen `<me@linux.beauty>` (author)
- **Signed-off-by:** Christian Brauner `<brauner@kernel.org>` (pidfs
  maintainer)
- No **Fixes:**, **Reported-by:**, **Tested-by:**, **Cc: stable**, or
  syzbot tags
- Notable: maintainer review and ack from Brauner; no user/fuzzer
  reports

### Step 1.3: Body Analysis
**Record:**
- **Bug:** `PIDFD_THREAD` is aliased to `O_EXCL`. `do_dentry_open()`
  clears `O_EXCL` after `pidfs_export_open()` validates flags, so
  `open_by_handle_at()` drops the thread-pidfd marker.
- **Symptom:** A reopened thread pidfd silently behaves as a process
  pidfd.
- **Root cause:** `pidfs_alloc_file()` already re-applies `PIDFD_THREAD`
  after `dentry_open()`; `pidfs_export_open()` did not.
- **Version info:** None in the message.

### Step 1.4: Hidden Bug Fix?
**Record:** Yes. Despite “preserve” wording, this is a functional
correctness bug fix, not cleanup. It restores API semantics on the
`open_by_handle_at()` path.

---

## Phase 2: Diff Analysis

### Step 2.1: Inventory
**Record:**
- **Files:** `fs/pidfs.c` only (+6 / -1 net)
- **Function:** `pidfs_export_open()`
- **Scope:** Single-file, surgical fix

### Step 2.2: Code Flow Change
**Record:**
- **Before:** `pidfs_export_open()` called `dentry_open()` and returned
  immediately; `do_dentry_open()` stripped `O_EXCL` (`PIDFD_THREAD`).
- **After:** Save `file` from `dentry_open()`, then if successful
  restore `file->f_flags |= oflags & PIDFD_THREAD`.
- **Path affected:** `open_by_handle_at()` → `do_handle_open()` →
  `pidfs_export_open()` for pidfs-backed handles with `O_EXCL`.

### Step 2.3: Bug Mechanism
**Record:** **Logic / correctness fix.** `PIDFD_THREAD` is carried in
`f_flags`, not in the inode. Both thread and process pidfds share the
same `struct pid` in `inode->i_private`; semantics depend on `f_flags`.
Losing `PIDFD_THREAD` changes behavior of consumers that inspect
`f_flags`.

### Step 2.4: Fix Quality
**Record:** Obviously correct. Mirrors the existing pattern in
`pidfs_alloc_file()` in the same file. Minimal regression risk; no new
locks, APIs, or behavior changes beyond restoring intended semantics.

---

## Phase 3: Git History Investigation

### Step 3.1: Blame
**Record:** `pidfs_export_open()` introduced in `5d324e5159d9e`
(2025-11-28) without `PIDFD_THREAD` restoration. `pidfs_alloc_file()` in
the same commit already had the restoration at lines 1063–1065. Bug
present since pidfs export support landed in this tree.

### Step 3.2: Fixes: Tag
**Record:** Not applicable — no `Fixes:` tag.

### Step 3.3: Related File History
**Record:** Recent `fs/pidfs.c` commits in this tree:
- `7446125afb6d9` — pidfs: return -EREMOTE for cross-ns `PIDFD_GET_INFO`
- `ae7a542dbab5b` — pidfs: add missing `BUILD_BUG_ON()`
Standalone fix; not part of a multi-patch series.

### Step 3.4: Author Context
**Record:** Li Chen is not the primary pidfs maintainer; Christian
Brauner is. Patch reviewed by Jan Kara and merged with Brauner’s SOB.

### Step 3.5: Dependencies
**Record:** No prerequisites. Uses existing `PIDFD_THREAD`,
`dentry_open()`, and `pidfs_export_open()` infrastructure already
present in this tree.

---

## Phase 4: Mailing List and External Research

### Step 4.1: Original Discussion
**Record:** Could not retrieve lore/patch.msgid.link — Anubis bot
protection blocked WebFetch. `b4 dig -c <commit>` unavailable because
the fix commit is not in this checkout. Phase 4 partially blocked.

### Step 4.2: Reviewers
**Record:** Unverified via `b4 dig -w`. Commit message shows Reviewed-by
Jan Kara and SOB from Christian Brauner.

### Step 4.3: Bug Report
**Record:** No external bug report, syzbot link, or user Reported-by.

### Step 4.4: Related Patches
**Record:** No series indicated. Complements existing
`pidfs_alloc_file()` logic.

### Step 4.5: Stable List History
**Record:** Unverified — lore blocked. This tree already carries other
pidfs stable backports (`7446125afb6d9`, `ae7a542dbab5b`).

---

## Phase 5: Code Semantic Analysis

### Step 5.1: Key Functions
**Record:** `pidfs_export_open()`, `pidfs_alloc_file()`,
`do_dentry_open()`, `sys_open_by_handle_at()`, `sys_pidfd_send_signal()`

### Step 5.2: Callers
**Record:**
- `pidfs_export_open()` called from `do_handle_open()` in `fs/fhandle.c`
  when `eops->open` is set
- Reachable from `open_by_handle_at()` syscall (userspace)

### Step 5.3: Callees
**Record:** `dentry_open()` → `do_dentry_open()`, which clears `O_EXCL`
at `fs/open.c:981`

### Step 5.4: Reachability
**Record:** Userspace can trigger via:
1. `pidfd_open(tid, PIDFD_THREAD)`
2. `name_to_handle_at(pidfd, ...)`
3. `open_by_handle_at(mountfd, fh, O_EXCL)`
4. `pidfd_send_signal()` or other operations reading `f_flags`

### Step 5.5: Similar Patterns
**Record:** Identical restoration already exists in
`pidfs_alloc_file()`:

```1062:1065:fs/pidfs.c
        pidfd_file = dentry_open(&path, flags, current_cred());
        /* Raise PIDFD_THREAD explicitly as do_dentry_open() strips it.
*/
        if (!IS_ERR(pidfd_file))
                pidfd_file->f_flags |= (flags & PIDFD_THREAD);
```

`pidfs_export_open()` currently lacks this:

```855:862:fs/pidfs.c
static struct file *pidfs_export_open(const struct path *path, unsigned
int oflags)
{
        /*
  - Clear O_LARGEFILE as open_by_handle_at() forces it and raise
  - O_RDWR as pidfds always are.
         */
        oflags &= ~O_LARGEFILE;
        return dentry_open(path, oflags | O_RDWR, current_cred());
}
```

---

## Phase 6: Cross-Reference Against Local Tree

### Step 6.1: Buggy Code Exists?
**Record:** Yes. Local tree is **v6.18.44** (`git describe HEAD`, `make
kernelversion`). `fs/pidfs.c` exists with `pidfs_export_open()` missing
the fix. The fix commit is not present (scoped `-S 'do_dentry_open()
strips O_EXCL' -- fs/pidfs.c` returns nothing).

### Step 6.2: Backport Complications
**Record:** Clean apply expected — 6-line change in one function, no
structural conflicts visible.

### Step 6.3: Related Fixes Already Present?
**Record:** `pidfs_alloc_file()` already has the `PIDFD_THREAD`
restoration pattern. Other pidfs stable fixes (`7446125afb6d9`,
`ae7a542dbab5b`) are present. This specific export-path fix is not.

---

## Phase 7: Subsystem Context

### Step 7.1: Subsystem / Criticality
**Record:** `fs/pidfs.c` — VFS/pidfd subsystem. **IMPORTANT**: affects
process management APIs reachable from userspace; not universal like mm,
but core process-control infrastructure in modern kernels.

### Step 7.2: Activity
**Record:** Actively maintained — multiple pidfs commits in this 6.18.y
tree.

---

## Phase 8: Impact and Risk Assessment

### Step 8.1: Who Is Affected
**Record:** Users of thread pidfds (`PIDFD_THREAD`) combined with pidfs
file-handle APIs (`name_to_handle_at` / `open_by_handle_at`). Config-
independent when pidfs is present (always initialized from
`init/main.c`).

### Step 8.2: Trigger Conditions
**Record:** Reopen a thread-pidfd file handle with `O_EXCL` via
`open_by_handle_at()`. Uncommon but valid documented API usage
(`VALID_FILE_HANDLE_OPEN_FLAGS` explicitly allows `O_EXCL`).
Unprivileged users can trigger on their own pidfds.

### Step 8.3: Failure Mode Severity
**Record:** **MEDIUM–HIGH functional correctness bug.** Without
`PIDFD_THREAD`, `pidfd_send_signal()` uses `PIDTYPE_TGID` instead of
`PIDTYPE_PID`:

```4111:4115:kernel/signal.c
                /* Infer scope from the type of pidfd. */
                if (fd_file(f)->f_flags & PIDFD_THREAD)
                        type = PIDTYPE_PID;
                else
                        type = PIDTYPE_TGID;
```

Signal may be delivered to the thread group instead of the specific
thread. Not a kernel oops, but wrong-target signal delivery is a
meaningful user-visible failure. `pidfd_get_pid()` also propagates
incorrect `f_flags` to callers.

### Step 8.4: Risk-Benefit
**Record:**
- **Benefit:** Restores correct thread-vs-process pidfd semantics on
  file-handle reopen; prevents wrong signal scope.
- **Risk:** Very low — mirrors proven in-tree pattern.
- **Ratio:** Favorable for backport.

---

## Phase 9: Final Synthesis

### Step 9.1: Evidence Summary

**FOR backport:**
- Real, verifiable bug in this tree
- Wrong signal-delivery scope possible
- Tiny, obviously correct fix matching existing code
- Maintainer-reviewed (Brauner SOB, Kara Reviewed-by)
- pidfs fixes already being backported to 6.18.y
- Clean apply to local tree

**AGAINST backport:**
- Niche API path (file handles + thread pidfds)
- No syzbot/user reports
- Not a crash/corruption/deadlock
- Mailing-list discussion unverified

**Unresolved:** Full lore review thread unavailable.

### Step 9.2: Stable Rules Checklist
1. Obviously correct and tested? **PASS** — mirrors
   `pidfs_alloc_file()`; no runtime test in commit, but pattern is
   proven in-tree.
2. Fixes a real bug affecting users? **PASS** — silent semantic
   corruption of thread pidfds.
3. Important issue? **PASS (moderate)** — wrong signal target; not
   crash-level, but meaningful API correctness failure.
4. Small and contained? **PASS** — ~6 lines, one function.
5. No new features or APIs? **PASS**
6. Can apply to local tree? **PASS** — buggy code present, fix not yet
   applied.

### Step 9.3: Exception Categories
**Record:** None (not device ID, quirk, DT, build, or docs).

### Step 9.4: Decision Rationale

This is an oversight in pidfs export support: the `pidfd_open()` path
was fixed at introduction, but the `open_by_handle_at()` path was not.
For 6.18.y users adopting pidfs file handles, a reopened thread pidfd
silently becomes a process pidfd, which can cause `pidfd_send_signal()`
to target the wrong scope. The fix is minimal, matches existing in-tree
code, and carries very low regression risk. Other pidfs fixes (including
less severe ones) are already in this 6.18.44 tree, establishing
precedent for pidfs corrections in stable.

---

## Verification

- [Phase 1] Parsed subject, tags, and body from provided commit message
- [Phase 1] Confirmed no syzbot/Fixes:/Reported-by tags
- [Phase 2] Read current `pidfs_export_open()` and `pidfs_alloc_file()`
  in `fs/pidfs.c`
- [Phase 2] Verified `do_dentry_open()` strips `O_EXCL` at
  `fs/open.c:981`
- [Phase 2] Confirmed `PIDFD_THREAD` is `O_EXCL` in
  `include/uapi/linux/pidfd.h`
- [Phase 3] `git describe HEAD` → `v6.18.44-2-g1b9e1abadee04`; `make
  kernelversion` → `6.18.44`
- [Phase 3] `git blame -L 855,863 fs/pidfs.c` → `pidfs_export_open()`
  from `5d324e5159d9e`
- [Phase 3] `git blame -L 1060,1066 fs/pidfs.c` → `PIDFD_THREAD` restore
  in `pidfs_alloc_file()` from same commit
- [Phase 3] `git log --oneline -S 'do_dentry_open() strips O_EXCL' --
  fs/pidfs.c` → empty (fix not in tree)
- [Phase 3] `git show 7446125afb6d9`, `git show ae7a542dbab5b` → other
  pidfs stable backports present
- [Phase 4] WebFetch lore/patch.msgid.link → blocked by Anubis
- [Phase 4] `b4 dig` → could not run without commit hash in tree
- [Phase 5] Traced `open_by_handle_at` → `do_handle_open()` →
  `eops->open` in `fs/fhandle.c:436-437`
- [Phase 5] Verified `pidfd_send_signal()` checks `f_flags &
  PIDFD_THREAD` in `kernel/signal.c:4112-4115`
- [Phase 5] Verified `pidfd_pid()` returns same `inode->i_private`
  regardless of thread flag
- [Phase 6] Confirmed buggy `pidfs_export_open()` present in local
  6.18.44 tree
- [Phase 6] Confirmed `pidfs_init()` called unconditionally from
  `init/main.c`
- [Phase 8] Assessed failure mode as wrong signal scope, severity
  MEDIUM-HIGH functional

**YES**The background git history checks finished and match what the
analysis already used:

- **`pidfs_export_open` and `pidfs_export_operations`** both date to
  `5d324e5159d9e` in this 6.18.44 tree — the same commit that brought in
  `fs/pidfs.c`, including the existing `PIDFD_THREAD` restore in
  `pidfs_alloc_file()`.
- The broad `git log -S` search for the fix comment was killed after
  hanging; a scoped search on `fs/pidfs.c` already showed the fix is
  **not** in this tree.

**Verdict stands: YES** — small, correct fix for a real bug where
`open_by_handle_at()` drops thread-pidfd semantics on the export path.

 fs/pidfs.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/pidfs.c b/fs/pidfs.c
index 34987fcdd9a87..30450f7f5ec5b 100644
--- a/fs/pidfs.c
+++ b/fs/pidfs.c
@@ -854,12 +854,18 @@ static int pidfs_export_permission(struct handle_to_path_ctx *ctx,
 
 static struct file *pidfs_export_open(const struct path *path, unsigned int oflags)
 {
+	struct file *file;
+
 	/*
 	 * Clear O_LARGEFILE as open_by_handle_at() forces it and raise
 	 * O_RDWR as pidfds always are.
 	 */
 	oflags &= ~O_LARGEFILE;
-	return dentry_open(path, oflags | O_RDWR, current_cred());
+	file = dentry_open(path, oflags | O_RDWR, current_cred());
+	/* do_dentry_open() strips O_EXCL, which encodes PIDFD_THREAD. */
+	if (!IS_ERR(file))
+		file->f_flags |= oflags & PIDFD_THREAD;
+	return file;
 }
 
 static const struct export_operations pidfs_export_operations = {
-- 
2.53.0

