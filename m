Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE7A55DE9A6;
	Mon, 19 Oct 2026 14:02:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418537; cv=none; b=MEBAmZTszustPiP4hmyRO9lQ+Xmw0s6hpGp/Jvv3xnZnrpKABCKoNRRb4GYRiCK/vhCMlIB5fiCgeEHWO7dU2O5oL2jF+Fe5cak5YELgsSOU0iGsESoqgK5u40q9gkGa+KCBNnZO+jinLTk3QkdFCCvTxmLctRpZoKaawoSfxok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418537; c=relaxed/simple;
	bh=OoAODBPG7JuGh6KFSqk77Miq0NaF5LnnMtJ/XBIQmi0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jkORyY07WInFfXp4Kaw0MvJgoEGZq/Cf/A4u7I4H0EAHer+kbOWbf+FsH3Bw1XffNInc0+fcopHM1uxIYEWygO8b7S3brhz6RatyVNk9xXWynYIr2B9ctuKaFkbZYFR6P8etkXQ4piybcqVzQUaYprjshnD4BGIgC+mfOAoPxeo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NjzZ2xGK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NjzZ2xGK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B17421F000C9;
	Mon, 19 Oct 2026 14:02:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418535;
	bh=r2RDo+R5bPz8ehvpSEPrSMIYkGdL2eQ9N6e7gpsV5Rc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NjzZ2xGKGp3ZlF1VpUsuTRFSYzjC3VZPE1PfCUgcS0I4KCj2sgWUZCeJelhcbR2mz
	 DL/YhX0Vm/G/cFACH2d4sMonGXi2wF7KD1E8wB6l86S4fMTuj/2JxvimA3PIHopWw1
	 AsZKqxuZkUS2Fnhsg3th44xn39+wQIMxOV8TulZChsyCb4+cG+hy+9QRJr5uLseK/Y
	 DPFnY7N5MZklxSZgTc8YeQe6d4SX+0iuTUhNyeC11uJBt6vJUe2irNCuL4Z9Ho0slp
	 PJPqjfqN6s2vzX9DgvWrjrLz5ea9Fy8u+n8bOjwF5biqOYRg8y1C6cumWXKzGwaGVu
	 vJkaxb10/IjSA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Michail Tatas <michail.tatas@gmail.com>,
	Corey Minyard <corey@minyard.net>,
	Sasha Levin <sashal@kernel.org>,
	openipmi-developer@lists.sourceforge.net,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] ipmi: Fix leak in __ipmi_bmc_register
Date: Mon, 19 Oct 2026 09:50:08 -0400
Message-ID: <20261019135441.1420968-317-sashal@kernel.org>
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

From: Michail Tatas <michail.tatas@gmail.com>

[ Upstream commit 18e633dd9674c8bf118ea8583bb5a531edc2728a ]

In case that ida_alloc(&ipmi_bmc_ida,...) succeeds and then
platform_device_register() fails, ipmi_bmc_ida is leaked.
Fix by freeing the error path

Signed-off-by: Michail Tatas <michail.tatas@gmail.com>
Message-ID: <anUK_HOy_pCgvsBm@michalis-linux>
Signed-off-by: Corey Minyard <corey@minyard.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

This is a one-line IDA leak fix in IPMI BMC registration. The buggy
error path is in this 6.12.111 tree, the patch applies cleanly, and the
maintainer treated it as a bug fix.

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1: PARSE THE SUBJECT LINE**
Record: `[ipmi] [Fix] leak in __ipmi_bmc_register` — explicit leak fix
in BMC registration.

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**
Record:
- No `Fixes:` tag (expected for this review pipeline)
- No `Reported-by:`, `Tested-by:`, `Reviewed-by:`, `Acked-by:`, `Cc:
  stable`, or `Link:`
- `Signed-off-by: Michail Tatas <michail.tatas@gmail.com>` (author)
- `Message-ID: <anUK_HOy_pCgvsBm@michalis-linux>`
- `Signed-off-by: Corey Minyard <corey@minyard.net>` (IPMI maintainer;
  not a pipeline SOB)
- Ignore any pipeline `Signed-off-by: Sasha Levin` / `[Upstream commit
  ...]` if present

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**
Record:
- Bug: `ida_alloc(&ipmi_bmc_ida, ...)` succeeds, then
  `platform_device_register()` fails, and the IDA ID is never freed.
- Symptom: leaked IDA ID (IDs cannot be reused). Not a kmalloc leak of
  the `bmc` object itself — that is already freed via `put_device()`.
- Failure mode: resource leak on the BMC registration error path; can
  retry (see Phase 5).
- Root cause: `out_list_del` calls `put_device(&bmc->pdev.dev)` (which
  `kfree`s the BMC via `release_bmc_device`) but never `ida_free()`.
- No version range in the message.

**Step 1.4: DETECT HIDDEN BUG FIXES**
Record: Not disguised. Subject and body both say “Fix leak”. This is a
straightforward error-path resource leak.

## PHASE 2: DIFF ANALYSIS

**Step 2.1: INVENTORY THE CHANGES**
Record:
- File: `drivers/char/ipmi/ipmi_msghandler.c` (+1 / −0)
- Function: `__ipmi_bmc_register()` error label `out_list_del`
- Scope: single-file, one-line surgical fix
- Upstream SHA: `18e633dd9674c8bf118ea8583bb5a531edc2728a`

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**
Record: Before — on `platform_device_register()` failure, the code
unlinks the BMC, resets `intf->bmc`, then `put_device()`. After — same
path, but `ida_free(&ipmi_bmc_ida, bmc->pdev.id)` runs **before**
`put_device()`, because `put_device()` → `release_bmc_device()` →
`kfree(bmc)` would make `bmc->pdev.id` unusable.

Verified local error path:

```3255:3261:drivers/char/ipmi/ipmi_msghandler.c
out_list_del:
        mutex_lock(&bmc->dyn_mutex);
        list_del(&intf->bmc_link);
        mutex_unlock(&bmc->dyn_mutex);
        intf->bmc = &intf->tmp_bmc;
        put_device(&bmc->pdev.dev);
        goto out;
```

And the only jump to that label:

```3188:3194:drivers/char/ipmi/ipmi_msghandler.c
                rv = platform_device_register(&bmc->pdev);
                if (rv) {
                        dev_err(intf->si_dev,
                                "Unable to register bmc device: %d\n",
                                rv);
                        goto out_list_del;
                }
```

Successful-registration cleanup already frees the ID in
`cleanup_bmc_work()`:

```3048:3056:drivers/char/ipmi/ipmi_msghandler.c
static void cleanup_bmc_work(struct work_struct *work)
{
        struct bmc_device *bmc = container_of(work, struct bmc_device,
                                              remove_work);
        int id = bmc->pdev.id; /* Unregister overwrites id */

        platform_device_unregister(&bmc->pdev);
        ida_free(&ipmi_bmc_ida, id);
}
```

That work is queued only from `kref_put(&bmc->usecount,
cleanup_bmc_device)`. `out_list_del` uses `put_device()`, not
`kref_put()`, so `ida_free` currently never runs on this failure.

**Step 2.3: IDENTIFY THE BUG MECHANISM**
Record: Category **(a) error-path resource leak**. Mechanism: IDA ID
allocated, never returned on `platform_device_register()` failure. Fix:
add the missing `ida_free()` before the device is released.

Not a kmalloc UAF: `release_bmc_device()` still frees the BMC. Not a
double-free of the ID: `cleanup_bmc_work` is not queued on this path.

**Step 2.4: ASSESS THE FIX QUALITY**
Record: Obviously correct. `ida_free` must precede `put_device` (object
containing the id is freed there). Minimal, no unrelated edits, no
API/lock/hot-path changes. Regression risk is very low.
Double-`ida_free` is not a concern because this path does not go through
`cleanup_bmc_work`.

## PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1: BLAME THE CHANGED LINES**
Record:
- IDA numbering: `68e7e50f195f` (“ipmi: Don't use BMC product/dev ids in
  the BMC name”, Corey Minyard, 2017)
- `out_list_del` + `put_device`: `a2cb600fa22a87` (“ipmi: Rework BMC
  registration”, 2017)
- `ida_alloc` conversion: `9bd9fbd9032a3` (2023) — API rename only; leak
  already existed with `ida_simple_get`
- Partial sibling leak: `4aa7afb0ee20a` (2019) freed `bmc` on
  `ida_simple_get()` failure, but did **not** free the ID after
  `platform_device_register()` failure

Bug has been in-tree since ~2017. All of the above are ancestors of this
HEAD.

**Step 3.2: FOLLOW THE FIXES: TAG**
Record: No `Fixes:` tag. Closest introducer is `68e7e50f195f` (IDA IDs)
plus `a2cb600fa22a87` (error path that omits `ida_free`). Both are in
this tree (`git merge-base --is-ancestor` returned 0).

**Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**
Record: Nearby IPMI fixes in this 6.12 tree (`d4be659a3e56f` SI NULL
deref, `e2a3b77df6aef` refcount leak) are unrelated. Upstream neighbor
`b6c46ab0bdee9` (“Remove all sysfs files on registration failure”) is a
**different** leak in `ipmi_add_smi()` sysfs attributes, not a
prerequisite. This commit is standalone.

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**
Record: Michail Tatas has no other IPMI commits on `origin/master`
besides this one. Corey Minyard (MAINTAINERS: IPMI SUBSYSTEM) authored
the registration rewrite and SOB’d this patch. Maintainer-acked.

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**
Record: Needs `ida_free` / `ida_alloc` / `ipmi_bmc_ida` /
`out_list_del`, all present here. `git apply --check` of `18e633dd9674c`
succeeded at offset −44 lines. Standalone.

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**
Record:
- `b4 dig -c 18e633dd9674c` →
  https://patch.msgid.link/anUK_HOy_pCgvsBm@michalis-linux
- `b4 dig -a`: single **v1**, no later revisions
- Patchew: Corey Minyard replied *“You are correct, added to my next
  tree. Thank you.”* — no NAK, no requested changes
- Included in `[GIT PULL] IPMI bug fixes for 7.3` as “Several cleanup on
  error fixes”

**Step 4.2: CHECK WHO REVIEWED THE PATCH**
Record (`b4 dig -w`): To Corey Minyard (`corey@minyard.net`); Cc
`openipmi-developer@lists.sourceforge.net`, `linux-
kernel@vger.kernel.org`. Subsystem maintainer received and applied it.

**Step 4.3: SEARCH FOR THE BUG REPORT**
Record: No syzbot/bugzilla/`Reported-by`. Found by code inspection.
Maintainer confirmed the leak.

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**
Record: Standalone `[PATCH]`, not `n/m`. Same pull also had unrelated
IPMI error-path fixes (sysfs leftover attrs, SI NULL deref already in
this tree as `d4be659a3e56f`). None required for this one-liner.

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**
Record: Web search of lore.kernel.org/stable for this subject found no
prior stable discussion or rejection. UNVERIFIED that nobody ever asked
for it on stable@; absence of hits is not a reason to skip it.

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1: IDENTIFY KEY FUNCTIONS**
Record: `__ipmi_bmc_register()` only. Helpers involved:
`ida_alloc`/`ida_free`, `platform_device_register`, `put_device`,
`release_bmc_device`, `cleanup_bmc_work`.

**Step 5.2: TRACE CALLERS**
Record: Sole call site is `__bmc_get_device_id()` when BMC identity is
new/changed (`!intf->bmc_registered` or GUID/device/product id change).
That is called from:
- `ipmi_add_smi()` (interface probe)
- `bmc_get_device_id()` used by sysfs attrs (`device_id_show` and
  siblings) and `ipmi_get_version()`
- `redo_bmc_reg()` work scheduled when `!intf->bmc_registered`

**Step 5.3: TRACE CALLEES**
Record: Allocates BMC, takes an IDA id, registers a platform device
`ipmi_bmc.<id>`, creates sysfs links. Error path in question is
register-fail.

**Step 5.4: FOLLOW THE CALL CHAIN (reachability)**
Record: Reachable on IPMI SMI probe and on BMC id refresh. If
`__ipmi_bmc_register()` fails:

```2674:2675:drivers/char/ipmi/ipmi_msghandler.c
                if (__ipmi_bmc_register(intf, &id, guid_set, &guid,
intf_num))
                        need_waiter(intf); /* Retry later on an error.
*/
```

`need_waiter()` arms `ipmi_timer` (1s: `IPMI_TIMEOUT_TIME == 1000`).
`ipmi_timeout_handler()` sees `!intf->bmc_registered` and schedules
`redo_bmc_reg()` → `bmc_get_device_id()` again. Persistent
`platform_device_register()` failure therefore retries about once per
second and leaks one IDA ID per retry. Userspace can also hit
`__bmc_get_device_id` via sysfs BMC attributes and `ipmi_get_version()`.

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**
Record: Only one `ida_free(&ipmi_bmc_ida, ...)` in this file today
(`cleanup_bmc_work`). The 2019 commit `4aa7afb0ee20a` fixed the sibling
leak (kfree BMC if `ida_simple_get` fails). This patch is the missing
half of that cleanup.

## PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**
Record: Yes. Tree is **6.12.111** (`git describe HEAD` →
`p-6.12-3-gc504cf0baa3d8`, `VERSION=6 PATCHLEVEL=12 SUBLEVEL=111`).
`18e633dd9674c` is **not** an ancestor (`merge-base --is-ancestor` exit
1). Local `out_list_del` still has `put_device` without `ida_free`. Bug
dates to 2017 (`68e7e50f195f` / `a2cb600fa22a87`).

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**
Record: `git show 18e633dd9674c | git apply --check` → **Hunk #1
succeeded at 3257 (offset -44 lines)**. Expected difficulty: **clean
apply**. Surrounding `out_list_del` context matches upstream parent.

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**
Record: `4aa7afb0ee20a` is present (ida_alloc-failure kfree). No other
`ida_free` on `out_list_del`. No substitute fix.

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

**Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY**
Record: `drivers/char/ipmi/` — IPMI message handler. **IMPORTANT** for
servers/enterprise/BMC out-of-band management (typical LTS users). Not
core mm/scheduler, not staging.

**Step 7.2: ASSESS SUBSYSTEM ACTIVITY**
Record: Mature (IPMI since 2.6-era). Recent 6.12.y history is bugfixes,
not redesign. Long-lived leak, not a brand-new subsystem.

## PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1: DETERMINE WHO IS AFFECTED**
Record: Config-specific: `CONFIG_IPMI_HANDLER`. Driver-specific: systems
with an IPMI BMC (most servers). Not universal desktop, but core for
enterprise stable.

**Step 8.2: DETERMINE THE TRIGGER CONDITIONS**
Record: `platform_device_register(&bmc->pdev)` failure after a
successful `ida_alloc`. Typical causes: `-ENOMEM`, or platform namespace
issues. Not every boot. If it fails, the 1s retry loop can fire
repeatedly. Not a userspace-triggered security primitive by itself, but
BMC sysfs/`ipmi_get_version` can re-enter registration.

**Step 8.3: DETERMINE THE FAILURE MODE SEVERITY**
Record: IDA ID leak (and IDA bitmap growth). BMC object is freed. Not
oops/deadlock/corruption. Persistent retry can leak one ID per second.
ID space is large (`ida_alloc` without max ≈ 0..INT_MAX), so exhaustion
is slow, but it is a real unbounded leak on a retry path, not a one-shot
init leak.

Severity: **MEDIUM** (resource leak on error/retry path). Still matches
the class of error-path leak fixes that stable regularly takes.

**Step 8.4: CALCULATE RISK-BENEFIT RATIO**
Record:
- Benefit: stops a verified ID leak in IPMI BMC registration, including
  the retry loop. High value relative to patch size for IPMI-using
  servers.
- Risk: **very low** — one line, error path only, ordering is required
  and correct.
- Ratio: strongly favors backport.

## PHASE 9: FINAL SYNTHESIS

**Step 9.1: COMPILE THE EVIDENCE**

FOR:
- Real IDA leak on a live error path that can retry every second
- One-line, obviously correct, `ida_free` before `put_device`
- Buggy code present in this 6.12.111 tree since 2017
- Applies cleanly (offset only)
- IPMI maintainer confirmed and merged it as a bug fix
- Completes the 2019 leak fix that only covered `ida_alloc` failure
- No new API, no refactor, no dependencies missing here

AGAINST:
- Trigger is `platform_device_register()` failure (uncommon)
- Not a crash/UAF/security hole
- No `Reported-by` from production
- ID space is large, so practical exhaustion is slow

UNRESOLVED:
- Direct lore.kernel.org fetch returned 403; discussion recovered via
  `b4 dig` + Patchew
- No stable@ thread found for this subject

**Step 9.2: APPLY THE STABLE RULES CHECKLIST**
1. Obviously correct and tested? **PASS** — 1 line; maintainer: “You are
   correct”
2. Fixes a real bug that affects users? **PASS** — IDA leak; retry can
   repeat it
3. Important issue? **PASS** (MEDIUM leak, same class as other stable
   error-path leaks; IPMI is enterprise-relevant). Not CRITICAL crash,
   but important enough.
4. Small and contained? **PASS** — +1 line, one function
5. No new features or APIs? **PASS**
6. Can apply to the local tree? **PASS** — `git apply --check` succeeded

**Step 9.3: CHECK FOR EXCEPTION CATEGORIES**
Record: Not a device-ID/quirk/DT/build/docs exception. Ordinary small
bugfix.

**Step 9.4: DECISION**
Backport. The leak exists here, the fix is trivial and correct, and IPMI
BMC registration is used on the servers that run this LTS tree.

### What the commit solves for this tree
If BMC platform-device registration fails after `ida_alloc`, 6.12
currently drops the BMC (`put_device`) but keeps the ID.
`__ipmi_bmc_register` failure then schedules a 1s retry, so a sticky
failure leaks IDs continuously. Adding `ida_free(&ipmi_bmc_ida,
bmc->pdev.id)` before `put_device` closes that path.

### Risk vs benefit
Benefit is a real resource-leak fix in a long-lived IPMI path. Risk is
essentially nil.

### Concerns
None for 6.12: no missing helpers, no conflicting refactor, apply is
clean.

---

Verification:
- [Phase 1] Parsed tags: author SOB Michail Tatas; maintainer SOB Corey
  Minyard; Message-ID `anUK_HOy_pCgvsBm@michalis-linux`; no
  Fixes/Reported-by/Cc:stable
- [Phase 2] Diff: +1 `ida_free(&ipmi_bmc_ida, bmc->pdev.id)` in
  `out_list_del` of `__ipmi_bmc_register`
- [Phase 2] Confirmed `out_list_del` is only reached from
  `platform_device_register()` failure; success-path `ida_free` is in
  `cleanup_bmc_work` via `kref_put`, not this path
- [Phase 3] `git blame`: IDA intro `68e7e50f195f` (2017); error label
  `a2cb600fa22a87` (2017); sibling kfree fix `4aa7afb0ee20a` (2019)
- [Phase 3] `git merge-base --is-ancestor` of those three vs HEAD: all
  present; `18e633dd9674c` **not** in HEAD
- [Phase 3] Neighbor `b6c46ab0bdee9` is a different sysfs leak; not a
  prerequisite
- [Phase 4] `b4 dig -c 18e633dd9674c`: lore match
  `https://patch.msgid.link/anUK_HOy_pCgvsBm@michalis-linux`
- [Phase 4] `b4 dig -a`: v1 only
- [Phase 4] `b4 dig -w`: To Corey Minyard, Cc openipmi-developer + LKML
- [Phase 4] Patchew: maintainer “You are correct, added to my next tree”
- [Phase 4] GIT PULL “IPMI bug fixes for 7.3” lists this commit
- [Phase 4] lore.kernel.org WebFetch 403; discussion taken from
  b4/Patchew instead
- [Phase 5] Callers: `__bmc_get_device_id` ← `ipmi_add_smi`, sysfs BMC
  attrs, `ipmi_get_version`, `redo_bmc_reg`
- [Phase 5] Retry: `need_waiter` → 1s `ipmi_timer` → `bmc_reg_work`
  while `!bmc_registered`
- [Phase 6] `git describe HEAD`: `p-6.12-3-gc504cf0baa3d8`; `make
  kernelversion`: 6.12.111
- [Phase 6] `git apply --check`: hunk succeeded at line 3257 (offset
  −44)
- [Phase 7] MAINTAINERS: IPMI SUBSYSTEM → Corey Minyard
- [Phase 8] Failure mode: IDA ID leak on error/retry; severity MEDIUM;
  risk very low
- UNVERIFIED: Direct lore.kernel.org HTML of the thread (403); no
  stable@ archive hit for this subject

**YES**

 drivers/char/ipmi/ipmi_msghandler.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/char/ipmi/ipmi_msghandler.c b/drivers/char/ipmi/ipmi_msghandler.c
index 0247079db185e..dc4704b067b94 100644
--- a/drivers/char/ipmi/ipmi_msghandler.c
+++ b/drivers/char/ipmi/ipmi_msghandler.c
@@ -3306,6 +3306,7 @@ static int __ipmi_bmc_register(struct ipmi_smi *intf,
 	list_del(&intf->bmc_link);
 	mutex_unlock(&bmc->dyn_mutex);
 	intf->bmc = &intf->tmp_bmc;
+	ida_free(&ipmi_bmc_ida, bmc->pdev.id);
 	put_device(&bmc->pdev.dev);
 	goto out;
 }
-- 
2.53.0

