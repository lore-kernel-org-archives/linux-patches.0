Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DC1E50EC07;
	Mon, 31 Aug 2026 13:42:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183773; cv=none; b=V4Y0Vuy6NjEp6w+2fm1fGieMsZL044UC8KaFSTq/oTMWlrSZ1IGLx1u1tOi8JcFVy1psV5bkzDYAmgpA1WBlFtj16vULLet+uA3gVoOgy71PiUGdCWT/jICDcHQ7/U15WH7nd10gBK0D8QWUPfBr4Eq5Ru4ZnFAK1UCdGopsniU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183773; c=relaxed/simple;
	bh=sGWWPfIRwjnqqGifBEenrFZqZbr1OLcCZIhEzeMjpFI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FnQK9MKv2uRIkSTtqA2TCwm+Bw/xguXIwVjEBE3uePgiHN0p/kEymHyV3HcmraCnRkPoHwuxzmLPM1ioebqvhm4dvHaSpLgamBaPS2wk0Pc1hiC+1whS+pivpAnhY6qJMxjLWysyMyNCG/tWYYYG3fUoWbpMLTC9/kZzBO49j0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hRzFf3C4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hRzFf3C4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0E091F00ACA;
	Mon, 31 Aug 2026 13:42:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183770;
	bh=NGuwoDVHLgtJ2rDyD++fdHLpV9xhiG+TZX+iQoBYp88=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hRzFf3C4kmxgkn5EflsI0qCSzrBndo8M29YUojKl168tdNrwQ/0GJ3fYko3UUpidW
	 790mvTSFQ4rOQ+4ZpQ1+wju6fQDjiMDg7K/rGNmJ7XyHctaeUCxVseaEuvrkq3wyvq
	 bGid5u7cHIaWEYl5bv62gIluFYVWPdTsighp9BKIjU4m4ZqJOw4yb/JRjFi5wp4x/J
	 b0sP5FIZrND92oon3Eo+ipofLznH3WwAnXc3qAfGFPP2Pt3eOEKAPizugUTHiGhG4Z
	 /2NpspEdO0tznqjl5tJHa+jqamjPaWqUqN4HtYeot53K29C4AIfYeNUlJS8e6NTnib
	 PMrhACUMI/MBw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Heiko Carstens <hca@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>,
	gor@linux.ibm.com,
	linux-s390@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] s390/zcore: Removed unused variables
Date: Mon, 31 Aug 2026 09:25:22 -0400
Message-ID: <20260831133314.4125787-294-sashal@kernel.org>
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

From: Heiko Carstens <hca@linux.ibm.com>

[ Upstream commit 0a2aa995c0a1d363b5f0803862e84834e3876ae2 ]

allmodconfig with clang W=1 points out unused global variables:

drivers/s390/char/zcore.c:49:23: error: variable
 'zcore_reipl_file' set but not used [-Werror,-Wunused-but-set-global]
drivers/s390/char/zcore.c:50:23: error: variable
 'zcore_hsa_file' set but not used [-Werror,-Wunused-but-set-global]

Remove both of them, since there is no point in keeping them.

Reviewed-by: Christian Borntraeger <borntraeger@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: `s390/zcore: Removed unused variables`

**Local tree:** Linux **6.18.44** (`stable/linux-6.18.y`, `git describe
HEAD` → `v6.18.44`)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: PARSE THE SUBJECT LINE
**Record:** `[s390/zcore]` `[Removed]` — removes two unused static
`struct dentry *` globals in the zcore crash-dump driver.

### Step 1.2: PARSE ALL COMMIT MESSAGE TAGS
**Record:**
- **Reviewed-by:** Christian Borntraeger `<borntraeger@linux.ibm.com>`
  (s390 maintainer)
- **Signed-off-by:** Heiko Carstens `<hca@linux.ibm.com>` (s390
  maintainer)
- **Signed-off-by:** Alexander Gordeev `<agordeev@linux.ibm.com>`
- No Fixes:, Reported-by:, Tested-by:, Link:, Cc: stable tags
- Notable: no syzbot, no user bug report — build-time issue only

### Step 1.3: ANALYZE THE COMMIT BODY TEXT
**Record:**
- **Bug:** `allmodconfig` with **clang** and **W=1** treats
  `zcore_reipl_file` and `zcore_hsa_file` as `-Werror,-Wunused-but-set-
  global` errors.
- **Symptom:** compilation failure (not a runtime failure).
- **Root cause (author):** globals are assigned from
  `debugfs_create_file()` but never read afterward; no reason to keep
  them.
- **Version info:** none stated; failure requires clang + W=1 (+
  typically W=e or CONFIG_WERROR for `-Werror`).

### Step 1.4: DETECT HIDDEN BUG FIXES
**Record:** Not a hidden runtime fix. This is an explicit **build-fix /
warning cleanup**. The variables became dead when debugfs return-value
checking was removed upstream in `7449ca87312a5` ("s390/zcore: no need
to check return value of debugfs_create functions", 2021), which dropped
the only uses of these pointers beyond assignment.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: INVENTORY THE CHANGES
**Record:**
- **File:** `drivers/s390/char/zcore.c` only (+2 / −6 lines)
- **Functions:** `zcore_init()` (init path only)
- **Scope:** single-file surgical change

### Step 2.2: UNDERSTAND THE CODE FLOW CHANGE
**Record:**
- **Hunk 1 (globals):** Removes `static struct dentry *zcore_reipl_file`
  and `zcore_hsa_file` declarations.
- **Hunk 2 (`zcore_init`):** Before: assign return values of
  `debugfs_create_file()` to globals. After: call
  `debugfs_create_file()` directly without storing results.
- **Behavior:** debugfs files `reipl` and `hsa` are still created
  identically; only the unused storage is removed.

### Step 2.3: IDENTIFY THE BUG MECHANISM
**Record:** **Build / compiler-warning category.** With `W=1`, the
kernel stops suppressing `-Wno-unused-but-set-variable` (see
`scripts/Makefile.extrawarn`). Clang reports globals as `-Wunused-but-
set-global`. With `W=e` or `CONFIG_WERROR`, this becomes a hard error.
No runtime bug (no UAF, leak, race, or NULL deref).

### Step 2.4: ASSESS THE FIX QUALITY
**Record:** Obviously correct — the pointers were never read after
assignment, and `zcore.c` has no `debugfs_remove` or `__exit` path that
would need them. Minimal diff, zero functional change. Regression risk:
**very low**.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: BLAME THE CHANGED LINES
**Record:** Lines 50–51 and 357–360 in current tree trace to
`e664048784506` (v6.18 import). Variables originally added for debugfs
error handling (`099b765139929`, `b4b3d128c821d`) and became unused when
return-value checks were removed in `7449ca87312a5` (2021).

### Step 3.2: FOLLOW THE FIXES: TAG
**Record:** N/A — no Fixes: tag.

### Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES
**Record:** Upstream fix: `0a2aa995c0a1d363b5f0803862e84834e3876ae2`.
Stable-queue copy: `423880f00db3d`. Fix is **not** in current HEAD
(`merge-base --is-ancestor` → exit 1). Master already has the fix (no
`zcore_reipl_file` on `master`). Standalone one-commit fix, not part of
a series.

### Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS
**Record:** Heiko Carstens is s390 maintainer. Recent s390 stable
commits on this tree are security/crash fixes (zcrypt, dasd, qeth). This
is a lower-severity build hygiene fix from the same subsystem.

### Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS
**Record:** No dependencies. Patch applies cleanly (`git show
423880f00db3d | patch --dry-run` succeeded). No new APIs or structures
assumed.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION
**Record:** `b4 dig -c 0a2aa995c0a1d363b5f0803862e84834e3876ae2` — **no
lore match found**. Likely committed directly to s390 tree without a
searchable lore thread.

### Step 4.2: CHECK WHO REVIEWED THE PATCH
**Record:** Reviewed-by Christian Borntraeger (s390 co-maintainer). b4
dig -w not available due to no lore match.

### Step 4.3: SEARCH FOR THE BUG REPORT
**Record:** N/A — no Reported-by or Link tags. Failure mode documented
only in commit message (clang W=1 allmodconfig).

### Step 4.4: CHECK FOR RELATED PATCHES AND SERIES
**Record:** Standalone. Related historical commit `7449ca87312a5`
introduced the dead assignments; that behavioral change is already
present in this tree's `zcore.c`.

### Step 4.5: CHECK STABLE MAILING LIST HISTORY
**Record:** Not searched individually; however, this **same stable
tree** already contains analogous W=1 clang build fixes (see Phase 8).

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF
**Record:** `zcore_init()` only.

### Step 5.2: TRACE CALLERS
**Record:** `zcore_init` registered via `subsys_initcall(zcore_init)` —
runs once at boot on s390 when `CONFIG_CRASH_DUMP` is enabled
(`drivers/s390/char/Makefile`: `obj-$(CONFIG_CRASH_DUMP) += zcore.o`).

### Step 5.3: TRACE CALLEES
**Record:** `debugfs_create_dir()`, `debugfs_create_file()` — creates
debugfs nodes for crash-dump tooling. Return values were stored but
never used for cleanup or error handling.

### Step 5.4: FOLLOW THE CALL CHAIN
**Record:** Init-only path at boot. Not reachable from userspace
syscalls. Bug trigger is **compile-time** when building the driver
object, not at runtime.

### Step 5.5: SEARCH FOR SIMILAR PATTERNS
**Record:** Same pattern fixed on this stable tree for other drivers —
e.g. `4a894ba48fa51` (matroxfb, "Mark variable with __maybe_unused to
avoid W=1 build break"), `433bb1344ef66` (nfsd), `248e4b9cc719f`
(nfs/blocklayout, "Fix compilation error (`make W=1`)").

---

## PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE

### Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?
**Record:** **YES.** `drivers/s390/char/zcore.c` lines 50–51 and 357–360
still declare and assign `zcore_reipl_file` / `zcore_hsa_file`. Dead-
assignment state present since the 2021 debugfs cleanup; clang W=1
exposure is newer.

### Step 6.2: CHECK FOR BACKPORT COMPLICATIONS
**Record:** **Clean apply** expected — file matches upstream pre-fix
content. No recent churn on `zcore.c` in 6.18.y (only `e664048784506`
import + unrelated s390 char commits elsewhere).

### Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE
**Record:** Fix **not** present in HEAD. No alternate fix found via grep
or log.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY
**Record:** **s390/char/zcore** — platform-specific crash-dump support.
**Criticality: PERIPHERAL** (s390-only, CONFIG_CRASH_DUMP). Important
for IBM/mainframe crash-dump workflows but not universal.

### Step 7.2: ASSESS SUBSYSTEM ACTIVITY
**Record:** s390 subtree on 6.18.y is active (zcrypt security fixes,
dasd, qeth, monwriter). zcore.c itself is stable/unchanged since branch.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: DETERMINE WHO IS AFFECTED
**Record:** **Config-specific:** s390 builders using
`CONFIG_CRASH_DUMP=y`, **clang**, and **W=1** (often with
W=e/CONFIG_WERROR). Not affected: default gcc builds, prebuilt distro
kernels, non-s390 arches.

### Step 8.2: DETERMINE THE TRIGGER CONDITIONS
**Record:** `make W=1` (or W=1e) + clang + allmodconfig (or any config
enabling zcore). Unprivileged users cannot trigger at runtime. Trigger
is **developer/CI build configuration** — uncommon but real for kernel
CI and s390 maintainers.

### Step 8.3: DETERMINE THE FAILURE MODE SEVERITY
**Record:** **Compilation error** — severity **MEDIUM** for stable rules
(build fix, not crash/corruption/security). Severity **LOW** for end
users running shipped kernels.

### Step 8.4: CALCULATE RISK-BENEFIT RATIO
**Record:**
- **Benefit:** Unblocks clang W=1 allmodconfig builds on s390; aligns
  with existing 6.18.y precedent for identical W=1 fixes.
- **Risk:** Minimal — removes dead code only.
- **Ratio:** Favorable for backport given precedent and zero runtime
  impact.

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: COMPILE THE EVIDENCE

**FOR backport:**
- Genuine build failure under documented kernel build flags (clang W=1)
- Build-fix exception category in stable rules
- Tiny, maintainer-reviewed, obviously correct
- Applies cleanly; buggy code confirmed in 6.18.44
- **Precedent on this tree:** `4a894ba48fa51`, `433bb1344ef66`,
  `248e4b9cc719f` — same class of W=1 clang fix already backported to
  `stable/linux-6.18.y`
- No functional change to debugfs behavior

**AGAINST backport:**
- No runtime bug; default builds unaffected
- Narrow audience (s390 + CONFIG_CRASH_DUMP + clang W=1)
- Variables unused since 2021 without widespread reports
- No lore discussion or explicit stable nomination found

**UNRESOLVED:**
- b4 dig found no mailing-list thread (patch likely landed via s390 tree
  directly)

### Step 9.2: STABLE RULES CHECKLIST
1. Obviously correct and tested? **PASS** — trivial dead-code removal;
   Reviewed-by s390 maintainer.
2. Fixes a real bug affecting users? **PASS** — real compile failure for
   s390 clang W=1 builders.
3. Important issue? **PASS (borderline)** — build fix, not
   crash/security; MEDIUM severity.
4. Small and contained? **PASS** — 8 lines, one file.
5. No new features or APIs? **PASS** — pure cleanup.
6. Can apply to the local tree? **PASS** — code present; dry-run apply
   succeeded.

### Step 9.3: EXCEPTION CATEGORIES
**Record:** **Build fix** — fixes compilation error with clang W=1 on
s390.

### Step 9.4: DECISION RATIONALE

For **Linux 6.18.y**, this commit should be backported. The fix is
surgical, risk-free, and addresses a reproducible build break under
`make W=1` with clang — the same class of issue already accepted on this
stable branch (matroxfb, nfsd, nfs/blocklayout). While end users of
prebuilt kernels are unaffected, kernel builders and CI on s390 are
blocked without it, and stable policy explicitly includes build fixes.

---

## Verification

- **[Phase 1]** Parsed subject, tags, body from user-provided commit and
  `git show 423880f00db3d` / `git show 0a2aa995c0a1`
- **[Phase 2]** Read diff; confirmed 2 insertions, 6 deletions in
  `zcore.c`; analyzed `zcore_init()` only
- **[Phase 3]** `git describe HEAD` → v6.18.44; `git blame` on lines
  49–52, 355–362; `git log -S zcore_reipl_file` found introduction
  history via `7449ca87312a5`, `b4b3d128c821d`, `099b765139929`; `merge-
  base --is-ancestor 423880f00db3d HEAD` → not in tree;
  `master:drivers/s390/char/zcore.c` has fix applied
- **[Phase 4]** `b4 dig -c 0a2aa995` → no lore match; `b4 dig -c
  423880f00db3d` → no lore match
- **[Phase 5]** Read `zcore.c`; `grep` callers — `subsys_initcall` only;
  `grep debugfs_remove` → none; Makefile: `obj-$(CONFIG_CRASH_DUMP) +=
  zcore.o`
- **[Phase 6]** `grep zcore_reipl_file` in tree → present; `git show
  423880f00db3d | patch --dry-run` → applies cleanly
- **[Phase 7]** `git log stable/linux-6.18.y -15 -- drivers/s390/` —
  active s390 stable maintenance
- **[Phase 8]** Read `scripts/Makefile.extrawarn` lines 108–130 (W=1
  enables unused-but-set warnings); `git log stable/linux-6.18.y
  --grep=W=1` found precedent commits `4a894ba48fa51`, `433bb1344ef66`,
  `248e4b9cc719f`; `git show 4a894ba48fa51` — identical W=1 clang build-
  break pattern
- **[Phase 9]** Synthesis and checklist completed from verified evidence
  above

**YES**The background check finished: commit `423880f00db3d` is **not**
in the current `stable/linux-6.18.y` tree (ancestor check exit code 1).
The unused `zcore_reipl_file` / `zcore_hsa_file` globals are still
present in `drivers/s390/char/zcore.c` at v6.18.44.

**Verdict unchanged:** backport **YES** — small clang `W=1` build fix,
applies cleanly, matches similar W=1 fixes already on this stable
branch.

 drivers/s390/char/zcore.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/s390/char/zcore.c b/drivers/s390/char/zcore.c
index 33cebb91b9338..e74f41f201099 100644
--- a/drivers/s390/char/zcore.c
+++ b/drivers/s390/char/zcore.c
@@ -47,8 +47,6 @@ struct ipib_info {
 static struct debug_info *zcore_dbf;
 static int hsa_available;
 static struct dentry *zcore_dir;
-static struct dentry *zcore_reipl_file;
-static struct dentry *zcore_hsa_file;
 static struct ipl_parameter_block *zcore_ipl_block;
 static unsigned long os_info_flags;
 
@@ -354,10 +352,8 @@ static int __init zcore_init(void)
 		goto fail;
 
 	zcore_dir = debugfs_create_dir("zcore" , NULL);
-	zcore_reipl_file = debugfs_create_file("reipl", S_IRUSR, zcore_dir,
-						NULL, &zcore_reipl_fops);
-	zcore_hsa_file = debugfs_create_file("hsa", S_IRUSR|S_IWUSR, zcore_dir,
-					     NULL, &zcore_hsa_fops);
+	debugfs_create_file("reipl", S_IRUSR, zcore_dir, NULL, &zcore_reipl_fops);
+	debugfs_create_file("hsa", S_IRUSR|S_IWUSR, zcore_dir, NULL, &zcore_hsa_fops);
 
 	register_reboot_notifier(&zcore_reboot_notifier);
 	atomic_notifier_chain_register(&panic_notifier_list, &zcore_on_panic_notifier);
-- 
2.53.0

