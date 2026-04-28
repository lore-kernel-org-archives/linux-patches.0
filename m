Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 317E03F54BB;
	Tue, 28 Apr 2026 10:42:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777372942; cv=none; b=VgwHrgRJXg7SDXcub8qBNprAL9GTtrh+fxQZ6heA8eRdFVIU4Fr97NVC3P1hVb7QjxEr3QbcphD8O0Fxzxl7bIf9n5kj7BBTR1DAo7pnQtzT+i2N1cYF2Y9jSpbj/BKwQ61JCHg6aG3NmHasqY2sscBhw/owE/snY4Ddpgm9cSE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777372942; c=relaxed/simple;
	bh=j/TzdqBcLtZkvc+ZZXuxANgusDVdXkuUKurqgbt2RC0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XK+FWNpy8Fp4MQWlLi0+9ihnWKqH33kfKXQjLP/mnYotocPD53wqbvOqEoCOlDziNM/IbmcBP8DhL5o0SGbKfqpt/VyKfn7NsXDoqssXct5041JL62WnQE21yeFbbBE9hNSlpc1LHtKmmVqrUWLwDQJ8VnW8Pv3x6YEcmmujjnQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uWQXTdRM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uWQXTdRM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBAB2C2BCB7;
	Tue, 28 Apr 2026 10:42:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777372941;
	bh=j/TzdqBcLtZkvc+ZZXuxANgusDVdXkuUKurqgbt2RC0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uWQXTdRMQ09QPAoHOsCh0rd3acyZVVozerk/XtE6Uc4r+3iXF+bx+ADoyvuVgCE27
	 C7tBqxDRNSzdQ5QatlXdXKBnRr2e77w48Gj/Mi+iJcnV6HdgRXn0W8c3GFEZ2rSBJ/
	 C5nFLyqZJddomLZEQiZJpLiFm4LAXMnei0RGl/bv5uSFkm+howa97DbyJAjoTQWlbP
	 Viia6qxP87uaJ96pFc9bkkIOgGqn9ApL3OnQbY+Ui0NXKiNCNfL0xxfR0NFrwT/p3c
	 aTZmGu77nyqThk2M35mQKsNznC8FLXt0nklzAFQjHZ8P3FQgfrwD7oMXUmzy7UJrpF
	 j/jmBnlCfbQnQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Zhan Xusheng <zhanxusheng1024@gmail.com>,
	Zhan Xusheng <zhanxusheng@xiaomi.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>,
	ntfs3@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-5.15] fs/ntfs3: fix $LXDEV xattr lookup
Date: Tue, 28 Apr 2026 06:40:45 -0400
Message-ID: <20260428104133.2858589-34-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260428104133.2858589-1-sashal@kernel.org>
References: <20260428104133.2858589-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 7.0.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Zhan Xusheng <zhanxusheng1024@gmail.com>

[ Upstream commit bb82fe0872de867f87fd4f64c9cb157903ac78db ]

Use correct xattr name ("$LXDEV") and buffer size when calling
ntfs_get_ea(), otherwise the attribute may not be read.

Signed-off-by: Zhan Xusheng <zhanxusheng@xiaomi.com>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have enough information to make a thorough assessment. Let me
compile the analysis.

## Analysis: fs/ntfs3: fix $LXDEV xattr lookup

### PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1 (Subject):**
Record: Subsystem `fs/ntfs3:`, action verb `fix`, summary: fix $LXDEV
extended attribute lookup failing due to wrong name_len passed to
`ntfs_get_ea()`.

**Step 1.2 (Tags):**
Record: Present tags:
- `Signed-off-by: Zhan Xusheng <zhanxusheng@xiaomi.com>` (author)
- `Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-
  software.com>` (ntfs3 maintainer)
- No `Fixes:`, no `Reported-by:`, no `Link:`, no `Cc: stable`, no
  `Reviewed-by:`, no `Tested-by:`, no syzbot.

**Step 1.3 (Body):**
Record: Commit body states two things: (a) wrong xattr *name* is used
via `sizeof("$$LXDEV") - 1`; (b) this may cause the attribute not to be
read. No crash/stack trace, no version info, no reproducer;
straightforward bug description.

**Step 1.4 (Hidden fix check):**
Record: Not hidden — verb is "fix" and described as a correctness bug.
Confirmed by diff.

### PHASE 2: DIFF ANALYSIS

**Step 2.1 (Inventory):**
Record: One file `fs/ntfs3/xattr.c`, one function `ntfs_get_wsl_perm`, 1
line changed (+1/-1). Single-file, single-char surgical fix.

**Step 2.2 (Flow change):**
Record: Before: `ntfs_get_ea(inode, "$LXDEV", sizeof("$$LXDEV") - 1, …)`
passed `name_len = 7` to `ntfs_get_ea()`. After: `sizeof("$LXDEV") - 1 =
6`. Only the name-length argument is altered; everything else (name
pointer, buffer, size, return check) remains identical.

**Step 2.3 (Bug mechanism):**
Record: Category = logic/correctness bug (typo). `find_ea()`
(fs/ntfs3/xattr.c:45-66) matches entries by:
```45:62:fs/ntfs3/xattr.c
static inline bool find_ea(const struct EA_FULL *ea_all, u32 bytes,
                           const char *name, u8 name_len, u32 *off, u32
*ea_sz)
{
        ...
                if (ea->name_len == name_len &&
                    !memcmp(ea->name, name, name_len)) {
```
`ntfs_save_wsl_perm()` stores `$LXDEV` with `name_len = 6`
(fs/ntfs3/xattr.c:1001), but `ntfs_get_wsl_perm()` was querying with
`name_len = 7`. Since the first check (`ea->name_len == name_len`)
requires exact equality, the lookup **always fails**. Consequence:
`inode->i_rdev` is never populated from the `$LXDEV` xattr for WSL-
created character/block device nodes on NTFS.

**Step 2.4 (Quality):**
Record: Obviously correct — the other three `$LXUID/$LXGID/$LXMOD` calls
and the corresponding `ntfs_set_ea(…, "$LXDEV", sizeof("$LXDEV") - 1,
…)` all use the correct form. The fix makes the read path consistent
with the write path. No risk of regression: the old path was a
guaranteed miss; the new path can only succeed more often. Not touching
locks, memory mgmt, or any hot path.

### PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1 (Blame):**
Record: `git blame` on lines 1034-1036 shows the exact line was
introduced by `be71b5cba2e64` ("fs/ntfs3: Add attrib operations",
Konstantin Komarov, 2021-08-13). `git log -S '"$$LXDEV"'` confirms this
is the single origin. The bug is a birth defect of the ntfs3 xattr code.

**Step 3.2 (Fixes: tag):**
Record: No `Fixes:` tag in the commit. Based on blame, the logical Fixes
target is `be71b5cba2e64` (pre-upstream). First kernel version that
contains the bug: **v5.15** (verified via `git tag --contains
be71b5cba2e64` returning `v5.15`, `v5.15-rc1`, etc.).

**Step 3.3 (File history):**
Record: Recent commits to `fs/ntfs3/xattr.c` in 7.0 tree are unrelated
(delalloc support, d_compare fixes, posix_acl changes, ACL-mode
reduction). No prerequisite refactoring is required.

**Step 3.4 (Author):**
Record: First patch by `zhanxusheng1024@gmail.com` /
`zhanxusheng@xiaomi.com` — not a maintainer, but the patch goes through
Konstantin Komarov, the ntfs3 maintainer, who applied it (second SoB).

**Step 3.5 (Dependencies):**
Record: No dependencies — the changed function `ntfs_get_ea()` has the
same signature across all stable trees with ntfs3 (v5.15+).

### PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

**Step 4.1 / 4.2 / 4.4 (b4 dig):**
Record:
- `b4 dig -c bb82fe0872de8` → found submission at https://lore.kernel.or
  g/all/20260327032454.101579-1-zhanxusheng@xiaomi.com/
- `b4 dig -a` → only **v1** exists; the applied version is the latest.
- `b4 dig -w` → recipients: Konstantin Komarov (maintainer), linux-
  kernel@vger.kernel.org, Zhan Xusheng.
- Full thread (saved via `-m`) shows Konstantin Komarov replied on 7 Apr
  2026: "Thanks, your patch is applied." No stable nomination was
  requested, no NAKs or concerns raised.

**Step 4.3 (Bug reports):**
Record: No Link: tags, no Reported-by, no bugzilla. No syzbot report.
The author evidently found this by reading code or hitting WSL-created
device nodes on NTFS.

**Step 4.5 (Stable ML):**
Record: No stable-list discussion was found; not relevant here.

### PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1 (Functions):**
Record: Only `ntfs_get_wsl_perm()` is modified.

**Step 5.2 (Callers):**
Record: `ntfs_get_wsl_perm()` is called once, from
`fs/ntfs3/inode.c:381` inside MFT attribute processing:
```373:384:fs/ntfs3/inode.c
        case ATTR_EA_INFO:
                if (!attr->name_len &&
                    resident_data_ex(attr, sizeof(struct EA_INFO))) {
                        ni->ni_flags |= NI_FLAG_EA;
                        /*
    - ntfs_get_wsl_perm updates inode->i_uid, inode->i_gid,
      inode->i_mode
                         */
                        inode->i_mode = mode;
                        ntfs_get_wsl_perm(inode);
```
Triggered whenever ntfs3 loads an inode that carries EA_INFO (any NTFS
inode with extended attributes, typical for WSL-managed files).

**Step 5.3 (Callees):**
Record: Calls `ntfs_get_ea()` (and through it `find_ea()` → `memcmp`).
No locking/memory-management changes.

**Step 5.4 (Reachability):**
Record: Reachable from `ntfs_iget5 -> ntfs_read_mft` — the standard
inode-read path. Any open/stat/readdir of a WSL-special file on NTFS
triggers the buggy code. Fully reachable from unprivileged userspace
with an NTFS mount.

**Step 5.5 (Similar patterns):**
Record: `sizeof("$LXUID")`, `sizeof("$LXGID")`, `sizeof("$LXMOD")` calls
are correct. The `ntfs_set_ea(… "$LXDEV", sizeof("$LXDEV") - 1 …)` at
line 1001 is also correct. The `$$LXDEV` typo is unique to this one
`get_ea` call — no other instances.

### PHASE 6: CROSS-REFERENCING AND STABLE TREE ANALYSIS

**Step 6.1 (Code exists in stable?):**
Record: Yes, the buggy code exists identically in all active stable
branches — verified by `git show`:
- `stable/linux-5.15.y` line 1024
- `stable/linux-6.6.y` line 1012
- `stable/linux-6.12.y` line 1013
- `stable/linux-6.19.y` line 1038
All contain `sizeof("$$LXDEV") - 1`.

**Step 6.2 (Backport complications):**
Record: None. The context around the change is essentially identical
across all stable trees; only the line number varies. Patch applies
cleanly (or with trivial offset).

**Step 6.3 (Related stable fixes):**
Record: No prior `$LXDEV` fix has landed in stable — the bug has existed
unmodified since v5.15.

### PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

**Step 7.1 (Subsystem):**
Record: fs/ntfs3 — filesystem driver. Criticality: **IMPORTANT**
(filesystem affecting data correctness for NTFS users, particularly
those using NTFS cross-booted with Windows/WSL).

**Step 7.2 (Activity):**
Record: ntfs3 is actively maintained by Paragon Software; steady trickle
of small fixes.

### PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1 (Who is affected):**
Record: Users of ntfs3 who have NTFS volumes containing WSL-created
character/block device special files. Niche but real (WSL users who
mount the same NTFS on Linux).

**Step 8.2 (Trigger):**
Record: Triggers whenever an ntfs3 inode for a special device file with
WSL attributes is loaded. No privilege needed beyond access to a mounted
NTFS volume. Deterministic (not a race).

**Step 8.3 (Severity):**
Record: No crash; no data corruption of on-disk data. The user-visible
symptom is that `S_ISCHR`/`S_ISBLK` files have `i_rdev = 0` (or
uninitialized) — device nodes are effectively broken. **Severity:
LOW–MEDIUM** (functional correctness bug, not a safety bug).

**Step 8.4 (Risk-Benefit):**
Record:
- Benefit: LOW-MEDIUM — fixes functional correctness for a specific
  interop feature (WSL<->Linux on NTFS).
- Risk: VERY LOW — 1-character fix, obviously correct, cannot make the
  read path worse; write path is unchanged.
- Ratio: clearly favorable for stable.

### PHASE 9: FINAL SYNTHESIS

**Step 9.1 (Evidence):**
- FOR: Genuine bug with zero controversy; obvious typo; present since
  v5.15 in all stable trees; maintainer-accepted; minimal scope (1
  char); fix makes read symmetric with write; trivial backport.
- AGAINST: Low user impact (niche WSL interop); no `Cc: stable` /
  `Fixes:`; no Reported-by/syzbot; no crash or data corruption.
- Unresolved: None material.

**Step 9.2 (Stable rules):**
1. Obviously correct and tested? **Yes** — one-character change, read
   symmetry with the write path proves correctness.
2. Fixes a real bug? **Yes** — `$LXDEV` xattr lookup is guaranteed to
   fail.
3. Important issue (crash/security/corruption/deadlock)? **No** —
   functional correctness only, no crash or data loss.
4. Small and contained? **Yes** — 1 line, 1 character.
5. No new features or APIs? **Correct — no new features.**
6. Applies to stable trees? **Yes** — verified identical context in
   5.15.y..6.19.y.

**Step 9.3 (Exceptions):**
Not an exception category, but the fix is a trivial, obvious correctness
fix (closest to "correctness typo fix") — a class the stable tree
routinely accepts.

**Step 9.4 (Decision):**
The only soft point against is that this is not an obvious "important"
crash/security/corruption fix per rule #3. However, stable *does*
routinely take obviously-correct, low-risk functional fixes,
particularly when they restore feature functionality broken since a
feature's introduction. The risk of regression is essentially nil (the
fix cannot make the read path fail *more* often than it already does —
it fails 100% of the time today). Benefit is concrete: WSL device-node
interop on NTFS begins working. Given extreme simplicity and clarity, I
lean YES.

### Verification
- [Phase 1] Parsed commit message and tags: no Fixes:, no Cc: stable, no
  Reported-by, two SoBs (author + ntfs3 maintainer).
- [Phase 2] Diff inspection: 1 line changed; argument `name_len` goes
  from 7 → 6.
- [Phase 2] Read `find_ea` at `fs/ntfs3/xattr.c:45-66` confirming exact
  `ea->name_len == name_len` comparison that guarantees miss with wrong
  length.
- [Phase 2] Read `ntfs_save_wsl_perm` at `fs/ntfs3/xattr.c:1001` —
  storage side correctly uses `sizeof("$LXDEV") - 1` (=6), confirming
  asymmetry.
- [Phase 3] `git log -S '"$$LXDEV"'` → buggy code introduced in
  `be71b5cba2e64` (2021-08-13, "fs/ntfs3: Add attrib operations").
- [Phase 3] `git blame` confirms the single origin commit.
- [Phase 3] `git tag --contains be71b5cba2e64 | rg '^v'` → first kernel
  is v5.15.
- [Phase 4] `b4 dig -c bb82fe0872de8` → lore URL `https://lore.kernel.or
  g/all/20260327032454.101579-1-zhanxusheng@xiaomi.com/`.
- [Phase 4] `b4 dig -a` → only v1, which is the applied version.
- [Phase 4] `b4 dig -w` → recipients: Konstantin Komarov, linux-
  kernel@vger.kernel.org.
- [Phase 4] Read full thread mbox: maintainer reply "Thanks, your patch
  is applied"; no stable nomination, no NAKs, no concerns.
- [Phase 5] Grepped `ntfs_get_wsl_perm` → single caller at
  `fs/ntfs3/inode.c:381` in MFT processing; reachable from every inode
  load that has EA_INFO.
- [Phase 6] Verified stable branches 5.15.y, 6.6.y, 6.12.y, 6.19.y all
  contain `sizeof("$$LXDEV") - 1` — fix applies cleanly everywhere.
- [Phase 8] Reasoned failure mode from code structure: `find_ea` always
  returns false → `ntfs_get_ea` returns -ENODATA → `i_rdev` never set
  for WSL char/block nodes.
- UNVERIFIED: No runtime reproducer was executed; impact inferred from
  code reading. Author cites no user-visible trace, but the code path is
  deterministic.

Summary: a small, obviously-correct typo fix to ntfs3 that has been
dormant since v5.15. Not a crash/security fix, but functionally restores
WSL device-node metadata on NTFS with negligible regression risk. On
balance, this fits the class of tiny, safe correctness fixes that are
appropriate for stable.

**YES**

 fs/ntfs3/xattr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ntfs3/xattr.c b/fs/ntfs3/xattr.c
index 3fffda7848922..9eeac0ab2b714 100644
--- a/fs/ntfs3/xattr.c
+++ b/fs/ntfs3/xattr.c
@@ -1031,7 +1031,7 @@ void ntfs_get_wsl_perm(struct inode *inode)
 		i_gid_write(inode, (gid_t)le32_to_cpu(value[1]));
 		inode->i_mode = le32_to_cpu(value[2]);
 
-		if (ntfs_get_ea(inode, "$LXDEV", sizeof("$$LXDEV") - 1,
+		if (ntfs_get_ea(inode, "$LXDEV", sizeof("$LXDEV") - 1,
 				&value[0], sizeof(value),
 				&sz) == sizeof(value[0])) {
 			inode->i_rdev = le32_to_cpu(value[0]);
-- 
2.53.0

