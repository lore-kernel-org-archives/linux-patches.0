Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E075A52B1DD;
	Mon, 19 Oct 2026 13:58:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418299; cv=none; b=MCwXnAGC/CnSBS+z/pz2OKqScfAXOalTrCx+5dVzxBXAjUISfCrYUGha4smeXGoiScbgJCVmFOj8Bz2kSYfyUGNgtG8eLp+6fKbNnFHk8MJwkWF8co6qf9oi43oWidq5gNJjOqFgAiYL4lV/ygQQGKrjajWCB67SiiMg5t9ZP/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418299; c=relaxed/simple;
	bh=C6xBtm5Cbccb4gXMB+QrHnzcjlLQrPsvCPpOmsaiaR8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jXPiWFG1dAcP82YSR20xHeV1QUX4wksN6vwITzx52X5Ar65WQKDaw7a0OYs1KiDEcmyrS4NRYAQ4ll/LrFvbRV1M5wglxY/LPm1jLK5/0HIx7JdHbjlSWQU3cq5GwiCLERrGIfnUkB5Gr1C5D8CMgUmx4TvXBG7GBt5fDEOihoQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PfM7GFhi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PfM7GFhi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F0461F000C7;
	Mon, 19 Oct 2026 13:58:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418296;
	bh=wxUqKsu4NEFXwujvewbFsEEDQ6diBIStquoc9zRvv0c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PfM7GFhiG/Q2aWyyibQdbMSqvAqbpdXBGFXf44Zs2RRBVdWMh9BZtZd0cK3GMhOPK
	 /2kOn0ryYSgRsrIUaXAO5W2WabA3fN7NPyS/rSpXNu1Bbey3ZXfNx60FC3eH+82i5J
	 aw1u25jsXzYFWN4dTixeFSPmXyE5QPEBgP7LSuOMDukJTUgKZLCbNYByXG0SJigeiQ
	 nA4JHTC27jWQos+VdoJVUfKisuVz5BRA8qhgs27GlUclRQmzhC7WErvIK23Sx8iWpR
	 HL0Hb912ZtONpJEHoyBP0ueguzs/Hm7COvfTlAhGOaEcw1C40n+5pscT0RWy234DqM
	 jOGLE6NgCqQmg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: John Johansen <john.johansen@canonical.com>,
	Sasha Levin <sashal@kernel.org>,
	georgia.garcia@canonical.com,
	paul@paul-moore.com,
	jmorris@namei.org,
	serge@hallyn.com,
	apparmor@lists.ubuntu.com,
	linux-security-module@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.6] apparmor: fix auditing of mount binary data
Date: Mon, 19 Oct 2026 09:47:18 -0400
Message-ID: <20261019135441.1420968-147-sashal@kernel.org>
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

From: John Johansen <john.johansen@canonical.com>

[ Upstream commit b9f2181b90ec047488dcb4fb1c631d417aff07e0 ]

AppArmor only mediates non-binary mount data, and should only
audit the mount data if it is non-binary.

Signed-off-by: John Johansen <john.johansen@canonical.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The local tree is **6.12.111** (`pending-6.12`). The buggy
`audit_mount(..., data, ...)` call is still present, and the two-line
change applies onto the current `match_mnt_path_str()` code.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1: PARSE THE SUBJECT LINE**

Record: **[apparmor] [fix] [do not audit mount data when it is binary]**

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**

Upstream commit: `b9f2181b90ec047488dcb4fb1c631d417aff07e0` (John
Johansen, 2026-07-28; merged via AppArmor v7.3 pull `apparmor-
pr-2026-08-26`).

Record:
- **Fixes:** none (expected for this review pipeline)
- **Reported-by:** none
- **Tested-by:** none on the commit itself
- **Reviewed-by / Acked-by:** none on the commit
- **Link:** none
- **Cc: stable:** none (expected)
- **Signed-off-by:** John Johansen `<john.johansen@canonical.com>`
  (AppArmor maintainer). Ignore any Sasha Levin SOB.

Notable pattern: no user/syzbot report; maintainer-authored correctness
fix. The v7.3 pull lists it under **Bug Fixes** (“auditing of mount
binary data”), not Features/Cleanups.

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**

Record:
- **Bug:** AppArmor mediates only non-binary mount data, but still
  passes binary `data` into `audit_mount()`.
- **Symptom:** AppArmor audit records can include an `options=` field
  built by treating a binary blob as a C string
  (`audit_log_untrustedstring()` → `strlen()`).
- **Version info:** none in the message. The pattern dates to
  `2ea3ffb7782a84` (“apparmor: add mount mediation”, v4.14-rc2).
- **Root cause (author):** audit should follow the same `!binary` rule
  as mediation.

**Step 1.4: DETECT HIDDEN BUG FIXES**

Record: Not a disguised cleanup. Subject and body both say **fix**. It
is a real audit-path bug, not a feature.

---

## PHASE 2: DIFF ANALYSIS

**Step 2.1: INVENTORY THE CHANGES**

Record:
- File: `security/apparmor/mount.c` only (**−2 / +2**)
- Function: `match_mnt_path_str()`
- Scope: single-file surgical fix

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**

Before (this tree, lines 346–349):

```346:349:security/apparmor/mount.c
audit:
        return audit_mount(subj_cred, profile, OP_MOUNT, mntpnt,
devname,
                           type, NULL,
                           flags, data, AA_MAY_MOUNT, &perms, info,
error);
```

After: pass `!binary ? data : NULL` instead of `data`.

`match_mnt()` only wraps `match_mnt_path_str()`, so both new-mount and
remount paths are covered. `aa_umount` / `aa_pivotroot` already pass
NULL data.

**Step 2.3: IDENTIFY THE BUG MECHANISM**

Record: **Logic / correctness in LSM audit** (binary blob treated as a
string).

Verified mechanism:
- `do_match_mnt()` already skips matching when `binary` is set (`data &&
  !binary && (perms->allow & AA_MNT_CONT_MATCH)`).
- `audit_mount()` still stores `data` if `perms->audit & AA_AUDIT_DATA`.
- `audit_cb()` then does `audit_log_untrustedstring(ab, ad->mnt.data)`,
  which uses `strlen()`.

`FS_BINARY_MOUNTDATA` filesystems in this tree: **NFS, NFS4, Btrfs,
Coda**.

Not an unbounded OOB on the `mount(2)` path: `path_mount()` does `((char
*)data_page)[PAGE_SIZE - 1] = 0` before `security_sb_mount()`.
`strlen()` stays inside the `copy_mount_options()` page. The bug is
wrong/garbled audit contents (and a possible hex dump of almost a full
page if the blob has no interior NUL).

**Step 2.4: ASSESS THE FIX QUALITY**

Record: Obviously correct; mirrors the existing `!binary` mediation
check. Minimal. Regression risk is low: binary `options=` simply
disappears from AppArmor mount audit records, which is the intended
policy. No API, locking, or data-structure change.

---

## PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1: BLAME THE CHANGED LINES**

Record: The `flags, data, AA_MAY_MOUNT` argument list is from
**`2ea3ffb7782a84`** (John Johansen, 2017-07-18), described as
v4.14-rc2. Wrapper cred-passing is from `90c436a64a6e20` (2022). The bug
is old, not new 7.x code.

**Step 3.2: FOLLOW THE FIXES: TAG**

Record: No `Fixes:` tag. Buggy code is the original mount-mediation
audit call. `git merge-base --is-ancestor 2ea3ffb7782a84 HEAD` → **yes,
present**.

**Step 3.3: CHECK FILE HISTORY**

Record: Recent `mount.c` commits in this tree: nosymfollow audit flags,
move_mount detached-source fix, mount mediation regression fix. No prior
fix for binary-data auditing. Next mainline commit after this one is
`apparmor: refactory mount to use check_perms` (large refactor). **This
fix is standalone and comes before that refactor.**

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**

Record: John Johansen is the AppArmor maintainer. Same-file history is
almost entirely his. Weight: high.

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**

Record: Diff uses existing `binary` parameter and existing
`audit_mount()` signature. No new helpers. **Applies standalone.** The
following mount refactor is not required.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**

Record:
- `b4 dig -c b9f2181b90ec047488dcb4fb1c631d417aff07e0` (and `-w`) →
  lore.kernel.org returned errors; **no thread recovered**.
- GitHub commit page confirms message/diff match the candidate.
- LKML pull: [GIT PULL] AppArmor updates for v7.3 (John Johansen,
  2026-08-26) lists this under Bug Fixes and notes
  merge/build/regression testing plus linux-next and Ubuntu kernel
  testing.

UNVERIFIED: v1/v2 review comments, NAKs, reviewer-requested `Cc:
stable`.

**Step 4.2: CHECK WHO REVIEWED THE PATCH**

Record: No Reviewed-by on the commit. Author is the subsystem
maintainer. Recipients of the original mail **UNVERIFIED** (b4 -w
failed).

**Step 4.3: SEARCH FOR THE BUG REPORT**

Record: No Reported-by, no bugzilla/syzbot link. Likely found while
preparing the mount refactor (same-day neighbor commits on 2026-08-10).

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**

Record: Same pull as `refactory mount to use check_perms` (cleanup, not
a dependency) and `add audit mode...` (feature, unused by this fix).
Self-contained.

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**

Record: No evidence this was NAK’d for stable. Search did not find a
stable-specific discussion of this title.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1: KEY FUNCTIONS**

Record: `match_mnt_path_str()` modified; `audit_mount()`, `audit_cb()`,
`do_match_mnt()`, `aa_new_mount()`, `aa_remount()`,
`apparmor_sb_mount()` involved.

**Step 5.2: TRACE CALLERS**

Record:
- `match_mnt()` → `match_mnt_path_str()`
- `aa_new_mount()` → `match_mnt` / `match_mnt_path_str` (sets `binary`
  from `FS_BINARY_MOUNTDATA`)
- `aa_remount()` → `match_mnt` (same flag from superblock type)
- `apparmor_sb_mount()` → `aa_new_mount` / `aa_remount` from
  `security_sb_mount()` in `path_mount()`

**Step 5.3: TRACE CALLEES**

Record: `audit_mount` → `aa_audit` → `audit_cb` →
`audit_log_untrustedstring` / `strlen`. Memory alloc/locks are
unchanged.

**Step 5.4: FOLLOW THE CALL CHAIN**

Record: Userspace `mount(2)` / remount → `path_mount` → LSM `sb_mount` →
AppArmor. Reachable from confined tasks that can mount (typically
`CAP_SYS_ADMIN`, or a user namespace). **Yes, userspace-reachable.**
This tree has no AppArmor `fs_context` hooks; the classic `sb_mount`
path is the one that matters here.

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**

Record: Only this `audit_mount` call passes mount `data`. Mediation
already had the `!binary` guard; audit did not. No sibling drivers with
the same bug.

---

## PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**

Record: **Yes.** `make kernelversion` = **6.12.111**; `git describe
HEAD` = `p-6.12-3-gc504cf0baa3d8`. Exact before-context is in
`match_mnt_path_str()`. Introduced **v4.14**. `git merge-base --is-
ancestor b9f2181b90ec HEAD` → **not present**.

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**

Record: **Clean apply.** Surrounding function signature (`subj_cred`,
`rules->policy`, `binary`) already matches. Confirmed `old present:
True` in the current file.

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**

Record: `git log --grep='auditing of mount binary'` on
`security/apparmor/` is empty. Closest related in-tree patch is
`33be0cfa5ba52` (“apparmor: take nosymfollow flag into account”), which
is also AppArmor **mount audit correctness** and was already taken for
this series.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

**Step 7.1: SUBSYSTEM AND CRITICALITY**

Record: **AppArmor LSM** (`security/apparmor/`). **IMPORTANT** (not core
mm/VFS; default MAC on Ubuntu and several LTS distros). Mount mediation
+ audit are user-visible security/audit paths.

**Step 7.2: SUBSYSTEM ACTIVITY**

Record: Mature (~2017 mount mediation) with ongoing stable backports in
this tree. Not a brand-new 7.x subsystem.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1: WHO IS AFFECTED**

Record: Config-specific: `CONFIG_SECURITY_APPARMOR`, confined processes,
filesystems with `FS_BINARY_MOUNTDATA` (NFS/Btrfs/Coda), and only when
an AppArmor mount audit record is generated with `AA_AUDIT_DATA` in
`perms->audit`.

**Step 8.2: TRIGGER CONDITIONS**

Record: Confined `mount()`/`remount` of NFS/Btrfs/Coda with non-NULL
mount data, plus policy that produces a mount audit record with the
data-audit bit. Not every boot; common on Ubuntu NFS/Btrfs systems with
AppArmor. Unprivileged userns mounts can hit it if confined. Not a race.

**Step 8.3: FAILURE MODE SEVERITY**

Record:
- Failure: `options=` in AppArmor audit is a `strlen()` view of a binary
  blob (garbage, early truncate at first NUL, or hex dump of up to
  ~PAGE_SIZE-1).
- Not a panic: VFS NUL-terminates the last byte of the options page.
- **Severity: MEDIUM** (wrong LSM audit; possible bulky hex dump). Not
  crash/deadlock/corruption.

**Step 8.4: RISK-BENEFIT RATIO**

Record:
- **Benefit:** medium for AppArmor+NFS/Btrfs users (correct audit; no
  binary blob in logs). Same class as the in-tree nosymfollow audit fix.
- **Risk:** very low (2 lines, existing `binary` flag, no locking).
- **Ratio:** favorable.

---

## PHASE 9: FINAL SYNTHESIS

**Step 9.1: COMPILE THE EVIDENCE**

**FOR:**
- Real bug: audit disagrees with mediation on binary mount data.
- Maintainer-authored; v7.3 pull classified it as a bug fix; tested in
  linux-next/Ubuntu.
- Two-line, obviously correct, clean apply on 6.12.111.
- Buggy code present since v4.14.
- Touches a live LSM path (NFS/Btrfs).
- This tree already accepted a similar AppArmor mount-audit correctness
  fix (`nosymfollow`).
- No new APIs/features; no dependency on the later mount refactor.

**AGAINST:**
- No user report, syzbot, or CVE.
- Not a crash/deadlock/corruption; gated on `AA_AUDIT_DATA`.
- Short message; no `Fixes:`/`Cc: stable`.
- Present since 2017 without reports (low “bothers people” signal).

**UNRESOLVED:**
- Original lore review thread (b4/lore 403).
- Whether reviewers asked for `Cc: stable`.

**Step 9.2: STABLE RULES CHECKLIST**

1. Obviously correct and tested? **PASS** — two-line mirror of existing
   `!binary` check; maintainer + v7.3 testing.
2. Fixes a real bug that affects users? **PASS** — AppArmor mount audit
   of NFS/Btrfs/Coda can emit binary `options=`.
3. Important issue? **PASS** (medium) — LSM audit correctness / “oh,
   that’s not good”; not a panic. Precedent in this tree: nosymfollow
   mount-audit fix.
4. Small and contained? **PASS** — 2 lines, one function.
5. No new features or APIs? **PASS**.
6. Can apply to the local tree? **PASS**.

**Step 9.3: EXCEPTION CATEGORIES**

Record: None (not a device ID, quirk, DT, build, or docs fix). Qualifies
as a normal small bug fix.

**Step 9.4: DECISION**

Backport. The tree has the bug, the patch applies cleanly, it is a
maintainer LSM audit fix with negligible regression risk, and 6.12
AppArmor users (especially Ubuntu) mount NFS/Btrfs under confinement.

What it solves for stable users: AppArmor will stop stuffing binary
mount blobs into `options=` via
`strlen()`/`audit_log_untrustedstring()`, matching the already-correct
“don’t mediate binary data” rule.

Risk vs benefit: benefit is correct MAC audit on common filesystems;
risk is essentially zero.

---

## Verification

- **[Phase 1]** Parsed tags: only author SOB; no Fixes/Reported-by/Cc
  stable. Upstream SHA `b9f2181b90ec047488dcb4fb1c631d417aff07e0`.
- **[Phase 1]** v7.3 pull (openwall/LKML, 2026-08-26) lists “auditing of
  mount binary data” under Bug Fixes.
- **[Phase 2]** Diff: `match_mnt_path_str()` passes `!binary ? data :
  NULL`; local file still passes `data`.
- **[Phase 2]** `do_match_mnt()` already has `data && !binary &&
  (perms->allow & AA_MNT_CONT_MATCH)`.
- **[Phase 2]** `audit_cb()` uses `audit_log_untrustedstring` → `strlen`
  (`kernel/audit.c`).
- **[Phase 2]** `path_mount()` NUL-terminates `data_page[PAGE_SIZE-1]` —
  not an OOB on this path.
- **[Phase 2]** `FS_BINARY_MOUNTDATA`: nfs, nfs4, btrfs, coda.
- **[Phase 3]** `git blame`: line from `2ea3ffb7782a84` (v4.14-rc2);
  ancestor of HEAD.
- **[Phase 3]** `git merge-base --is-ancestor b9f2181b90ec HEAD` → not
  in this tree.
- **[Phase 3]** No `Fixes:` tag to follow.
- **[Phase 3]** Follow-up mainline commit is a mount refactor, not a
  prerequisite.
- **[Phase 4]** `b4 dig -c/-w` failed (lore 403). UNVERIFIED: review
  NAKs / stable nomination in the original thread.
- **[Phase 4]** No stable-list hit for this title.
- **[Phase 5]** Call chain: `path_mount` → `apparmor_sb_mount` →
  `aa_new_mount`/`aa_remount` → `match_mnt_path_str` → `audit_mount`.
- **[Phase 5]** Only one `audit_mount` site passes `data`.
- **[Phase 6]** `git describe HEAD` = `p-6.12-3-gc504cf0baa3d8`; `make
  kernelversion` = 6.12.111.
- **[Phase 6]** Python check: old snippet present, new snippet absent.
- **[Phase 6]** `git log --grep='auditing of mount binary' --
  security/apparmor/` empty.
- **[Phase 7]** `CONFIG_SECURITY_APPARMOR` exists; AppArmor is
  IMPORTANT.
- **[Phase 8]** Failure mode: garbled/hex `options=` in AppArmor audit,
  severity MEDIUM; not oops.
- **UNVERIFIED:** Original lore review comments; whether `AA_AUDIT_DATA`
  is set in typical Ubuntu mount policy (code path is real; frequency of
  the audit bit is policy-dependent).

The fix is small, surgical, present as a real bug in this 6.12 tree, and
meets the stable criteria for an LSM audit correctness fix.

**YES**

 security/apparmor/mount.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/security/apparmor/mount.c b/security/apparmor/mount.c
index 2f5d918832c10..31f792817643c 100644
--- a/security/apparmor/mount.c
+++ b/security/apparmor/mount.c
@@ -344,8 +344,8 @@ static int match_mnt_path_str(const struct cred *subj_cred,
 
 audit:
 	return audit_mount(subj_cred, profile, OP_MOUNT, mntpnt, devname,
-			   type, NULL,
-			   flags, data, AA_MAY_MOUNT, &perms, info, error);
+			   type, NULL, flags, !binary ? data : NULL,
+			   AA_MAY_MOUNT, &perms, info, error);
 }
 
 /**
-- 
2.53.0

