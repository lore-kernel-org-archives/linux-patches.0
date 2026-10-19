Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B6AF4C849C;
	Mon, 19 Oct 2026 14:01:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418507; cv=none; b=cckh17aP0Oe3eoZzY1N7cHQmgddr3tpJWuqRogc3/7cidUHEKSyeKZFliFMpEJRcVVgwCipMMt3ig8Q5WQCLvppLNVNUzRd3bRDZx2mUgI0v6KGc0yZo/SuUPDk+ygit72X1x4g4ryU/zPpH+Q8ikr75bn16FZ2W/186M+vhYIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418507; c=relaxed/simple;
	bh=kV7yFWaOENvJAiS2+QB8brBG2WKQf5yWEXTagQ0DZs8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NLHEZ5s4cEcaF1d52/gt+eqXS0VUg/hpnLjaHefnrkEpBdl5k59Jy03uScx0qrPueJ4IXj4eZ5zZnn6Cgv/3AWWJqlrbOkX3fZl62eX614l5TzwsqUTPAidRmEcv7SnJGWWBG8f3xp0t4DvRHJy4dS1jNy0V1V60qSAo1kcuCJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=N/VsiP6g; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="N/VsiP6g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6C9A1F000C6;
	Mon, 19 Oct 2026 14:01:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418503;
	bh=okCUYOFMspLOvIxkErEVcE60lK4IZ2CWc1XVeXlJVuk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=N/VsiP6gMbYzXH46gevorM/NCDLyCl0AhQxlcYxfY7JLR7iYPig0cfHBrCgpKI6Qx
	 RuSwDpJJN4LNMoKaIeG2bHO3oOuIulo6O0/b47l2DHWM1nmzY31eppZ+vN7QgnDrjI
	 f1H0ECUczK3OJtk2x8tosDBbSQYNR0A1uFc6EzNUvAExMM7QZTttpMwy81+mhnhTjt
	 pVsNKRsUEsokKUQi6fLMgYC6+RPADLFEHOao0a01NQx9rL4Z0bpWKA+CF9TTmiIDC2
	 EfdOc8uK7jnYOhEO3xy4kgYChZZ0r2JCx3NIcdMar37mHkrFMqwVZewBdlgL5iIj6j
	 39ePKZ1wAnNng==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Devansh Soni <devanshsoni874@gmail.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>,
	linux-staging@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.15] staging: rtl8723bs: fix missing unregister_netdev on sdio_alloc_irq failure
Date: Mon, 19 Oct 2026 09:49:46 -0400
Message-ID: <20261019135441.1420968-295-sashal@kernel.org>
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

From: Devansh Soni <devanshsoni874@gmail.com>

[ Upstream commit 51b554f1a758570159a770983c7a0ccd7c761491 ]

In rtw_drv_init(), if rtw_drv_register_netdev() succeeds but
sdio_alloc_irq() fails, the error path jumps to free_if1 and calls
rtw_sdio_if1_deinit(). However, rtw_sdio_if1_deinit() calls
rtw_free_netdev() without a preceding unregister_netdev(), freeing a
still-registered netdev but leaving stale sysfs entries behind.

Signed-off-by: Devansh Soni <devanshsoni874@gmail.com>
Link: https://patch.msgid.link/20260619125724.12458-1-devanshsoni874@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

This checkout is **v7.3-rc4** (mainline 7.3). The patch is a 5-line
probe error-path fix: after `register_netdev()` succeeds, a failed
`sdio_claim_irq()` used to `free_netdev()` a still-registered netdev,
which hits `BUG_ON` in `free_netdev()`. The buggy path exists in this
tree (introduced by `618b4aec`, which is in v7.0+ and was already taken
to stable).

---

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1: PARSE THE SUBJECT LINE**
Record: **[staging/rtl8723bs] [fix] missing unregister_netdev on
sdio_alloc_irq failure**

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**
Record:
- `Signed-off-by: Devansh Soni <devanshsoni874@gmail.com>` (author)
- `Link: https://patch.msgid.link/20260619125724.12458-1-
  devanshsoni874@gmail.com`
- `Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>`
  (staging maintainer; applied)
- No `Fixes:`, no `Reported-by:`, no `Tested-by:`, no `Reviewed-by:`, no
  `Cc: stable` (absence of the last two is expected for this review)

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**
Record:
- **Bug:** `rtw_drv_init()` registers the netdev, then
  `sdio_alloc_irq()` fails, then `rtw_sdio_if1_deinit()` →
  `rtw_free_netdev()` without `unregister_netdev()`.
- **Symptom:** freeing a still-registered netdev; stale sysfs entries.
  The commit understates the real failure: `free_netdev()` does
  `BUG_ON(dev->reg_state != NETREG_UNREGISTERED)`.
- **Version info:** none in the message.
- **Root cause:** error path after successful
  `rtw_drv_register_netdev()` does not unregister before free.

**Step 1.4: DETECT HIDDEN BUG FIXES**
Record: Not hidden. Explicit error-path crash/UAF/sysfs leak fix.

---

## PHASE 2: DIFF ANALYSIS

**Step 2.1: INVENTORY THE CHANGES**
Record:
- File: `drivers/staging/rtl8723bs/os_dep/sdio_intf.c` (+4 / −1)
- Function: `rtw_drv_init()`
- Scope: single-file surgical error-path fix

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**
Record:
- **Before:** `sdio_alloc_irq()` failure → `goto free_if1` →
  `rtw_sdio_if1_deinit()` → `rtw_free_netdev()` while still registered.
- **After:** same failure → `goto free_netdev` →
  `rtw_unregister_netdevs(dvobj)` then fall through to deinit/free.
  Success path still falls through both labels, but both are guarded by
  `status != _SUCCESS`.

**Step 2.3: IDENTIFY THE BUG MECHANISM**
Record:
- **Category:** error-path resource teardown / memory safety (registered
  netdev freed).
- **Mechanism:** missing `unregister_netdev()` before `free_netdev()`.
  Fix matches the existing `rtw_dev_remove()` order.

**Step 2.4: ASSESS THE FIX QUALITY**
Record:
- Obviously correct: unregister-then-free is the same sequence as
  remove.
- Minimal; no API/data-structure changes.
- Regression risk is low: labels are status-guarded;
  `rtw_unregister_netdevs()` already exists and is used on remove.
- Fall-through on success is intentional and safe.

---

## PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1: BLAME THE CHANGED LINES**
Record:
- Probe skeleton: `554c0a3abf216` (Hans de Goede, 2017, “staging: Add
  rtl8723bs sdio wifi driver”).
- The crashy cleanup path was **activated** by `618b4aec12faa` (Liang
  Jie, 2025-12-08, “fix missing status update on sdio_alloc_irq()
  failure”): that commit started storing `sdio_alloc_irq()`’s return in
  `status`, so failure actually runs `free_if1`. Before that, failure
  left `status == _SUCCESS`, skipped cleanup, and returned 0 (wrong, but
  no unregister/free crash).
- First appeared as this crash: **v7.0** (`618b4aec` is in v7.0; not in
  v6.19).

**Step 3.2: FOLLOW THE FIXES: TAG**
Record: No `Fixes:` tag. The commit that made this path crash is
`618b4aec12faa`, which **is** an ancestor of this tree.

**Step 3.3: CHECK FILE HISTORY**
Record: Related: `618b4aec12faa` (status update). Later style/rename
commits on the same file. Standalone 1/1 patch, not “patch X/Y”.

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**
Record: Devansh Soni has two commits in this driver (this fix and an
unrelated unused-buffer cleanup). Not the maintainer. Greg applied it.

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**
Record: Needs `status = sdio_alloc_irq(dvobj)` from `618b4aec` and
existing `rtw_unregister_netdevs()`. Both are in this v7.3 tree. Applies
standalone here.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**
Record:
- `b4 dig -c 51b554f1a7585` → https://patch.msgid.link/20260619125724.12
  458-1-devanshsoni874@gmail.com
- `b4 dig -a`: **v1 only**, standalone.
- lore.kernel.org fetches returned **403**. lkml.iu.edu / openwall show
  the original mail only; **no replies, no NAK, no Cc: stable in
  review**.
- `b4 dig -m` matched the **wrong** thread (Alonso Garrigues style
  series). Treat that mbox as a tool miss, not discussion of this patch.

**Step 4.2: CHECK WHO REVIEWED THE PATCH**
Record: `b4 dig -w`: To/Cc were Greg KH, linux-staging, linux-kernel. No
extra reviewers. Greg’s commit SOB is the only maintainer ack.

**Step 4.3: SEARCH FOR THE BUG REPORT**
Record: No Reported-by, no syzbot, no bugzilla. Analysis-driven, not a
user report.

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**
Record: Completes `618b4aec`. That predecessor was sent to **6.19
stable** (`[PATCH 6.19 368/844] staging: rtl8723bs: fix missing status
update on sdio_alloc_irq() failure`, Upstream `618b4aec`). Trees that
took that incomplete fix now have this BUG_ON path.

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**
Record: No stable thread found for *this* unregister follow-up
(lore/stable search not usable here). Predecessor **was** selected for
6.19.y.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1: KEY FUNCTIONS**
Record: `rtw_drv_init()`; calls `rtw_unregister_netdevs()`,
`rtw_sdio_if1_deinit()`, `sdio_alloc_irq()`.

**Step 5.2: TRACE CALLERS**
Record: `rtw_drv_init` is `.probe` of `rtl8723bs_sdio_driver`
(`sdio_intf.c`). Runs on SDIO enumerate of IDs
0x024c:0523/0525/0623/0626. Module-only (`depends on m`).

**Step 5.3: TRACE CALLEES**
Record: `sdio_alloc_irq()` → `sdio_claim_irq()`.
`rtw_unregister_netdevs()` → `unregister_netdev()` +
`rtw_wdev_unregister()`. `rtw_sdio_if1_deinit()` → `rtw_free_netdev()` →
`free_netdev()`.

**Step 5.4: FOLLOW THE CALL CHAIN**
Record: Userspace cannot call this directly; it runs on device probe.
`sdio_claim_irq()` failure is uncommon (resource/hardware) but then the
kernel **BUGs**. Reachable whenever this module probes a card and IRQ
claim fails.

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**
Record: `rtw_dev_remove()` already unregisters then deinits.
`_rtw_drv_register_netdev()` failure still has a separate double-free
concern (later syzbot-style patch by Yi Cong); **not** this hunk.

Verified `free_netdev()`:

```12311:12311:net/core/dev.c
        BUG_ON(dev->reg_state != NETREG_UNREGISTERED);
```

`NETREG_REGISTERED` after `register_netdev()` makes that `BUG_ON` fire.

---

## PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**
Record:
- Tree: **v7.3-rc4** (`VERSION=7 PATCHLEVEL=3 SUBLEVEL=0
  EXTRAVERSION=-rc4`).
- Driver present: `drivers/staging/rtl8723bs/`.
- `618b4aec` is an ancestor (in v7.0, v7.1, v7.2, v7.3-rc1).
- Candidate `51b554f1` is already in **v7.3-rc1** (not used as “already
  selected for stable”; it is in this 7.3 base).
- Pre-fix parent of `51b554f1` still had `goto free_if1` on IRQ failure.

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**
Record: Clean apply on this tree. Context is the `status =
sdio_alloc_irq()` form from `618b4aec`. `rtw_unregister_netdevs()` has
existed since the driver was added.

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**
Record: `618b4aec` is here (creates the crash). This follow-up is the
missing unregister. No other equivalent unregister-on-IRQ-fail fix
besides `51b554f1`.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

**Step 7.1: SUBSYSTEM AND CRITICALITY**
Record: **staging/rtl8723bs** (Realtek SDIO WiFi). Criticality
**PERIPHERAL** as staging, but the chip is real (Kconfig: Intel Compute
Stick, Atom/ARM boards). Greg maintains staging.

**Step 7.2: SUBSYSTEM ACTIVITY**
Record: High churn (style + several OOB fixes). Still staging since 2017
(`TODO` still lists MAC80211 conversion, leftover chip code).

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1: WHO IS AFFECTED**
Record: Users with `CONFIG_RTL8723BS=m` and matching SDIO WiFi, only if
probe gets past `register_netdev()` and then `sdio_claim_irq()` fails.

**Step 8.2: TRIGGER CONDITIONS**
Record: Probe error path; not hot. Unprivileged users do not trigger it
except by plugging/having the device. Timing-independent.

**Step 8.3: FAILURE MODE SEVERITY**
Record: `BUG_ON` in `free_netdev()` → **kernel BUG / oops**. Also stale
sysfs. **Severity: CRITICAL** if it fires; trigger is uncommon.

**Step 8.4: RISK-BENEFIT RATIO**
Record:
- **Benefit:** high for this driver: prevents BUG on a path that
  `618b4aec` (already in this tree, and in 6.19.y) made live.
- **Risk:** very low (4 insertions, error path only, same order as
  remove).
- **Ratio:** favorable.

---

## PHASE 9: FINAL SYNTHESIS

**Step 9.1: COMPILE THE EVIDENCE**

**FOR:**
- Real bug: `free_netdev()` on `NETREG_REGISTERED` → `BUG_ON`.
- Small, obviously correct, matches `rtw_dev_remove()`.
- Completes `618b4aec`, which is in this tree and was already backported
  to 6.19.y — that incomplete stable fix **creates** this crash.
- No new API; error path only.
- `rtw_unregister_netdevs()` and the `status = sdio_alloc_irq()` form
  exist here.

**AGAINST:**
- Staging (usually not stable material).
- No user/syzbot report; rare IRQ-claim failure.
- No public review beyond Greg applying v1.
- This 7.3-rc4 checkout already contains `51b554f1` from v7.3-rc1 (not a
  reason to reject on merit).

**UNRESOLVED:**
- Full lore thread unreadable (403); no evidence of NAKs on IU/openwall
  mirrors.
- Whether every older LTS has `618b4aec` is not this tree’s question;
  **this** tree does.

**Step 9.2: STABLE RULES CHECKLIST**
1. Obviously correct and tested? **PASS** — logic matches remove; in
   mainline via Greg. No extra Tested-by.
2. Fixes a real bug that affects users? **PASS** — probe failure can
   BUG; hardware exists.
3. Important (crash/security/corruption/deadlock)? **PASS** — kernel
   `BUG_ON`.
4. Small and contained? **PASS** — 5 lines, one function.
5. No new features or APIs? **PASS**.
6. Can apply to the local tree? **PASS** — applies; helpers and
   prerequisite are here.

**Step 9.3: EXCEPTION CATEGORIES**
Record: None (not an ID/quirk/DT/build/doc patch). Ordinary bug fix.

**Step 9.4: DECISION**

Staging would normally count against, but it does not win here: this is
a crash fix on a path that a **already-stable** predecessor (`618b4aec`)
opened, the change is four guarded lines, and this v7.3 tree has the
buggy sequence. Benefit vs risk favors taking it.

---

### What the commit solves for this tree

`rtw_drv_init()` is the SDIO probe. After `618b4aec`, a failed
`sdio_claim_irq()` sets `status` to failure and tears down a
**registered** netdev via `rtw_free_netdev()` → `free_netdev()` →
`BUG_ON`. The patch unregisters first, same as remove.

### Stable rules / risk

Meets the written rules: small, no new API, real crash, applies here.
Risk is the usual staging caution; this is not a style patch.

### Concerns

Depends on `618b4aec` (present here). No reproducer. Staging. Those do
not outweigh the `BUG_ON`.

---

Verification:
- [Phase 1] Tags: author SOB, Greg SOB, msgid Link; no Fixes/Reported-
  by/Cc: stable
- [Phase 2] Diff: +4/−1 in `rtw_drv_init()`; `goto free_netdev` +
  `rtw_unregister_netdevs()`
- [Phase 2] `free_netdev()`: `BUG_ON(dev->reg_state !=
  NETREG_UNREGISTERED)` at `net/core/dev.c:12311`
- [Phase 3] Blame: crash path armed by `618b4aec12faa` (2025-12); driver
  added `554c0a3abf216` (2017)
- [Phase 3] `git merge-base --is-ancestor 618b4aec HEAD` → yes;
  `51b554f1` in v7.3-rc1, not in v7.2; `618b4aec` in v7.0+
- [Phase 3] Pre-fix parent still `goto free_if1` on IRQ failure
- [Phase 4] `b4 dig -c 51b554f1`: msgid
  20260619125724.12458-1-devanshsoni874@gmail.com; v1 only; To Greg +
  staging + lkml
- [Phase 4] lore 403; IU/openwall: patch only, no replies
- [Phase 4] `b4 dig -m` wrongly saved Alonso Garrigues style series —
  ignored
- [Phase 4] `618b4aec` appeared as stable `6.19` patch 368/844
- [Phase 5] `rtw_drv_init` is `rtl8723bs_sdio_driver.probe`
- [Phase 5] `rtw_unregister_netdevs()` in `os_intfs.c` calls
  `unregister_netdev()`
- [Phase 6] `git describe HEAD` = `v7.3-rc4-27-gf0100363d8c37`; Makefile
  7.3.0-rc4
- [Phase 6] Local `rtw_drv_init` already has the fix; prerequisite and
  helper present
- [Phase 7] `CONFIG_RTL8723BS` tristate, `depends on m`; hardware listed
  in Kconfig
- [Phase 8] Failure: kernel BUG on probe IRQ-claim failure; severity
  CRITICAL if triggered
- UNVERIFIED: complete lore review thread (403); whether every LTS has
  `618b4aec` (not required for this tree)

**YES**

 drivers/staging/rtl8723bs/os_dep/sdio_intf.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/rtl8723bs/os_dep/sdio_intf.c b/drivers/staging/rtl8723bs/os_dep/sdio_intf.c
index ae379e99736ad..e9bf6c3b18af0 100644
--- a/drivers/staging/rtl8723bs/os_dep/sdio_intf.c
+++ b/drivers/staging/rtl8723bs/os_dep/sdio_intf.c
@@ -379,10 +379,13 @@ static int rtw_drv_init(
 
 	status = sdio_alloc_irq(dvobj);
 	if (status != _SUCCESS)
-		goto free_if1;
+		goto free_netdev;
 
 	status = _SUCCESS;
 
+free_netdev:
+	if (status != _SUCCESS)
+		rtw_unregister_netdevs(dvobj);
 free_if1:
 	if (status != _SUCCESS && if1)
 		rtw_sdio_if1_deinit(if1);
-- 
2.53.0

