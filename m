Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3A8444A3E9;
	Mon, 31 Aug 2026 13:40:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183653; cv=none; b=doyWcR+tyNR73Blc8S3B2Pz5Q9zwM7pitDw2qq585pBxDlXzA3T96YtgZkUvIscfpwEMPtamfo2dgRSao1vu7M78iovhtdZ2mNm7TonADe6Y1WMFADBaiS+8j6V055ODyJFgvWgfoc10OOvgVjwunFjc39KtMwSR5lyaUsRbO7Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183653; c=relaxed/simple;
	bh=6uvHIYZ0OuuYQhd/KiCiNVhaUg+VCHXAL47togkkXNQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UkCzUKIs/2neC7MAbFCwBV01O6iNIBCKvgwdqZa4db99YLy3D+1qQ66vgTx4wYN6TsZDjWyf+ytHeWEO2NLDP1/iUGzy+kS9kj/b97pWByXIOldsk0H75jghRbJwemjv8tg9g+yJ/2lnGwXwvVDynRf1ncbim/5BX5Cg0PnUtRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QEZpYE7q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QEZpYE7q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A9841F00ACA;
	Mon, 31 Aug 2026 13:40:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183650;
	bh=yFn7hFz+fOtKgGDmSp9TKQHGWgYyHAMSXyTmTS9UlHs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QEZpYE7qZkfK5Nmj86jt0giZ16M4WSbDr68Qhm1Bje4WeCyCORBV/S+u/0bQcZOVY
	 1TyoiZ65uc9mOgIh1t66YjpNxaFnVEFRTe+2CveLe87J0khcodmatpNTV/S5cuu7si
	 NTRjr3lSTMU1fe4WTsk//ehH85ocFU7B1V8KGQYIlNGXNInp5N7emDcfR8dqGK6grS
	 9NF5DA2xYd6Iex+21fdvPsLuv5hvRJs6OpJxOYICOwwaR4ObljTYHA2fvTpEoOHSKu
	 I6npjfJxePMdy/VCQUGs85ww/NepwLaw57sPeLK2NCOXzddluM1FdH3o2nFCWulzL6
	 hw7ZEW31Cg4vQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	jhs@mojatatu.com,
	jiri@resnulli.us,
	davem@davemloft.net,
	pabeni@redhat.com,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] net/sched: sch_drr: make cl->quantum lockless
Date: Mon, 31 Aug 2026 09:24:09 -0400
Message-ID: <20260831133314.4125787-221-sashal@kernel.org>
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

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit a4d880b85089e12a5f2e8e2fee386310cec5b99a ]

cl->quantum does not need to be protected by RTNL or qdisc spinlock.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20260519094618.2632073-3-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit Message Forensics

### Step 1.1: Parse the Subject Line
**Record:** `[net/sched] [make] sch_drr: make cl->quantum lockless` —
networking traffic-control subsystem; action is making `cl->quantum`
access lockless (concurrency/synchronization change, not labeled "fix").

### Step 1.2: Parse All Commit Message Tags
**Record:**
- **Signed-off-by:** Eric Dumazet `<edumazet@google.com>` (author)
- **Link:** `https://patch.msgid.link/20260519094618.2632073-3-
  edumazet@google.com` (patch 2/2 of series)
- **Signed-off-by:** Jakub Kicinski `<kuba@kernel.org>` (net maintainer
  merge)
- **No** Fixes:, Reported-by:, Tested-by:, Reviewed-by:, Acked-by:, or
  Cc: stable tags
- Notable: part of series titled **"net/sched: sch_drr: lockless
  cl->deficit and cl->quantum"** (patches 1/2 and 2/2)

### Step 1.3: Analyze Commit Body
**Record:**
- **Bug description:** `cl->quantum` does not need RTNL or qdisc
  spinlock protection; access should be lockless with proper
  annotations.
- **Symptom/failure mode:** Not described — no crash, corruption, or
  user report mentioned.
- **Version info:** None in message.
- **Root cause (author):** Quantum is read on fast paths without holding
  `sch_tree_lock`; locking on write is unnecessary and inconsistent.

### Step 1.4: Detect Hidden Bug Fixes
**Record:** **Yes, likely a hidden concurrency bug fix.** Removing
`sch_tree_lock()` around the write while fast-path readers
(`drr_enqueue`, `drr_dequeue`, `drr_dump_class`) access `cl->quantum`
without that lock means the old code had a writer-lock/reader-no-lock
pattern. The fix adds `WRITE_ONCE`/`READ_ONCE` to make lockless
concurrent access formally safe — same pattern as the already-backported
companion patch for `cl->deficit`.

---

## Phase 2: Diff Analysis

### Step 2.1: Inventory the Changes
**Record:**
- **File:** `net/sched/sch_drr.c` only
- **Scope:** ~4 insertions, ~6 deletions (net −2 lines)
- **Functions modified:** `drr_change_class`, `drr_dump_class`,
  `drr_enqueue`, `drr_dequeue`
- **Classification:** Single-file, surgical synchronization fix

### Step 2.2: Code Flow Change (per hunk)
**Record:**
1. **`drr_change_class`:** Before: update `cl->quantum` under
   `sch_tree_lock`/`sch_tree_unlock`. After: `WRITE_ONCE(cl->quantum,
   quantum)` with no tree lock.
2. **`drr_dump_class`:** Before: plain `cl->quantum` read. After:
   `READ_ONCE(cl->quantum)`.
3. **`drr_enqueue`:** Before: `WRITE_ONCE(cl->deficit, cl->quantum)`.
   After: `WRITE_ONCE(cl->deficit, READ_ONCE(cl->quantum))`.
4. **`drr_dequeue`:** Before: `WRITE_ONCE(cl->deficit, cl->deficit +
   cl->quantum)`. After: `WRITE_ONCE(cl->deficit, cl->deficit +
   READ_ONCE(cl->quantum))`.

### Step 2.3: Bug Mechanism
**Record:** **Category: synchronization / data-race fix.** Fast-path
enqueue/dequeue and `drr_dump_class` read `cl->quantum` without
`sch_tree_lock`, while `drr_change_class` wrote it under that lock —
ineffective protection against the actual concurrent readers. Fix uses
`READ_ONCE`/`WRITE_ONCE` for defined lockless u32 access.

### Step 2.4: Fix Quality
**Record:** Fix is minimal, obviously correct, and mirrors the already-
applied `cl->deficit` annotations. Regression risk is very low. Removing
`sch_tree_lock` from the quantum-update path also reduces lock
contention during `tc` class changes under load.

---

## Phase 3: Git History Investigation

### Step 3.1: Blame Changed Lines
**Record:**
- Quantum lock/unlock in `drr_change_class`: Patrick McHardy, 2008-11-20
  (original DRR code).
- `WRITE_ONCE` for deficit: Eric Dumazet, 2026-05-19 (`a88f6da618e8b`,
  already in this tree).
- Buggy pattern (lock on write, lockless reads on fast path) present
  since DRR introduction (~2.6 era).

### Step 3.2: Follow Fixes: Tag
**Record:** No Fixes: tag in this commit. N/A for direct lookup.
Companion patch 1/2 fixes `edb09eb17ed89` ("net: sched: do not acquire
qdisc spinlock in qdisc/class stats dump"), which **is** in this tree.

### Step 3.3: File History / Related Changes
**Record:**
- `a88f6da618e8b` — "annotate data-races around cl->deficit" (patch 1/2,
  **already in 6.18.y**)
- `edb09eb17ed89` — lockless stats dump infrastructure (prerequisite
  context, in tree since 2016)
- `f99a3fbf023e2` — double-list-add fix in DRR (unrelated)
- This is patch **2/2** of a 2-patch series; patch 1/2 is already
  backported here.

### Step 3.4: Author's Other Commits
**Record:** Eric Dumazet is a core networking maintainer. Related
sch_drr work in this tree includes the deficit annotation backport and
the 2016 lockless stats-dump series.

### Step 3.5: Dependencies / Prerequisites
**Record:** Patch 1/2 (`a88f6da618e8b`) is **already in this tree**.
This patch applies standalone on top of that state. No other
dependencies required. The tree currently has an **incomplete** 2-patch
series: deficit annotated, quantum not.

---

## Phase 4: Mailing List and External Research

### Step 4.1: Original Patch Discussion
**Record:** Series found via web search (lore fetch blocked by bot
protection):
- Cover: `[PATCH net-next 0/2] net/sched: sch_drr: lockless cl->deficit
  and cl->quantum`
- Patch 1/2: annotate data-races around `cl->deficit`
- Patch 2/2: make `cl->quantum` lockless (this commit)
- URL: https://www.spinics.net/lists/netdev/msg1188405.html
- `b4 dig -c` could not be run (commit not in local repo). No NAKs found
  in search results.

### Step 4.2: Reviewers
**Record:** CC list from syzbot CI series page includes `davem@`,
`kuba@`, `netdev@`, `pabeni@`, `jhs@`, `victor@`. Patchwork-bot reported
on cover letter (2026-05-21). Full reviewer thread not retrieved.

### Step 4.3: Bug Reports
**Record:** No Reported-by, no syzbot crash report, no bugzilla link.
Syzbot CI
(https://ci.syzbot.org/series/3c50e02b-b07f-4d23-a7d3-45d5a6e23096) ran
build/boot/fuzz — all **passed**; no bug was filed against this series.

### Step 4.4: Related Patches / Series
**Record:** 2-patch series. Patch 1/2 already backported to this 6.18.y
tree (July 2026). This commit completes the series.

### Step 4.5: Stable Mailing List
**Record:** Not searched (no stable-specific discussion found in
available sources). Absence of Cc: stable is expected per instructions.

---

## Phase 5: Code Semantic Analysis

### Step 5.1: Key Functions
**Record:** `drr_change_class`, `drr_dump_class`, `drr_enqueue`,
`drr_dequeue`

### Step 5.2: Callers / Context
**Record:**
- `drr_enqueue`/`drr_dequeue`: packet scheduling fast path
  (softirq/NAPI), high frequency.
- `drr_change_class`: netlink `tc` class configuration (administrative).
- `drr_dump_class`: `tc class show` dump via `cl_ops->walk` in
  `tc_dump_tclass_qdisc` — **without** qdisc spinlock (same pattern as
  stats dump after `edb09eb17ed89`).

### Step 5.3: Callees
**Record:** `WRITE_ONCE`, `READ_ONCE`, `sch_tree_lock`/`sch_tree_unlock`
(removed from quantum path), `nla_put_u32`, `list_add_tail`,
`qdisc_pkt_len`.

### Step 5.4: Reachability
**Record:** All paths reachable — packet forwarding (every enqueued
packet) and `tc` administration. Users with `CAP_NET_ADMIN` can trigger
quantum changes; any traffic through a DRR qdisc reads quantum on
enqueue/dequeue.

### Step 5.5: Similar Patterns
**Record:** Patch 1/2 applied the identical `READ_ONCE`/`WRITE_ONCE`
pattern to `cl->deficit` in the same functions. `sch_htb.c` and
`sch_ets.c` still use plain `cl->quantum` access (not part of this
commit).

---

## Phase 6: Cross-Referencing Against the Local Tree

### Step 6.1: Does the Buggy Code Exist?
**Record:** **Yes.** Local tree is **v6.18.44** (`linux-6.18.y` stable).
Current code at lines 100–103 still uses `sch_tree_lock` + plain
`cl->quantum = quantum`; lines 365/406 read `cl->quantum` without
`READ_ONCE` inside `WRITE_ONCE` deficit updates.
`READ_ONCE`/`WRITE_ONCE` for quantum: **not present** (verified via
grep).

### Step 6.2: Backport Complications
**Record:** **Clean apply expected.** Patch 1/2 already present; diff
applies directly on current `sch_drr.c`. Minor context differences
possible (e.g., `kzalloc` vs `kzalloc_obj`, `qstats_backlog_add` vs
direct `sch->qstats` — user's diff shows mainline variants; stable tree
may need trivial context adjustment only).

### Step 6.3: Related Fixes Already Present?
**Record:** Patch 1/2 (`a88f6da618e8b`, deficit annotations) **already
backported** (2026-07-24). This quantum patch is the **missing half** of
that series. No duplicate quantum fix found.

---

## Phase 7: Subsystem and Maintainer Context

### Step 7.1: Subsystem Criticality
**Record:** `net/sched` — **IMPORTANT** subsystem. DRR itself is a less-
common qdisc, but the code path is standard packet scheduling
infrastructure.

### Step 7.2: Subsystem Activity
**Record:** Moderately active; recent sch_drr changes include deficit
annotations (2026), qlen_notify idempotency (2025), extack support.

---

## Phase 8: Impact and Risk Assessment

### Step 8.1: Who Is Affected
**Record:** Users of DRR qdisc (`sch_drr`) with concurrent `tc` class
modification and traffic — config-specific, not universal. Google BwE-
scale `tc` dumps were the original motivation for the broader lockless-
stats work.

### Step 8.2: Trigger Conditions
**Record:** Concurrent `tc class change` (quantum update) while packets
are enqueued/dequeued, or while `tc class show` dumps quantum. Requires
DRR in use and concurrent admin + traffic. Not unprivileged-triggerable
for the write side; reads happen on every packet.

### Step 8.3: Failure Mode Severity
**Record:** Without fix: C11/KCSAN data race; in practice, reading a
slightly stale or mid-update `u32` quantum value. **Severity: LOW to
MEDIUM** — may cause transient scheduling inaccuracy, not kernel crash,
panic, memory corruption, or security escalation. No crash reports
exist.

### Step 8.4: Risk-Benefit
**Record:**
- **Benefit:** Completes data-race fix series already partially in tree;
  consistent lockless access; slightly less lock contention on `tc`
  changes; KCSAN-correct.
- **Risk:** Very low — 10-line change, established
  `READ_ONCE`/`WRITE_ONCE` idiom.
- **Ratio:** Moderate benefit for DRR users; very low risk. Strongest
  argument is **series completeness** after patch 1/2 was already
  accepted for this tree.

---

## Phase 9: Final Synthesis

### Step 9.1: Evidence Summary

**FOR backport:**
- Completes 2-patch series; patch 1/2 already in 6.18.y
- Fixes real data race on `cl->quantum` in fast path and dump path
- Same author, same rationale as already-backported deficit fix
- Small, surgical, obviously correct
- Syzbot CI passed on full series
- Prerequisites (`edb09eb17ed89`, patch 1/2) present in tree

**AGAINST backport:**
- No user crash reports, no syzbot bug, no CVE
- Failure mode is benign (stale quantum value), not crash/corruption
- Race existed since 2008; newly highlighted, not newly introduced
  catastrophic bug
- DRR is niche compared to HTB/fq_codel
- Partially a performance improvement (removing unnecessary
  `sch_tree_lock`)

**Unresolved:** Full lore reviewer thread not retrieved; no explicit
stable nomination found.

### Step 9.2: Stable Rules Checklist
1. Obviously correct and tested? **PASS** — idiomatic
   `READ_ONCE`/`WRITE_ONCE`; syzbot CI green.
2. Fixes a real bug? **PASS** — data race with concurrent lockless
   readers; same class as already-backported patch 1/2.
3. Important issue? **BORDERLINE PASS** — not crash/security level, but
   correctness under concurrent `tc` + traffic; series completion after
   partial backport.
4. Small and contained? **PASS** — single file, ~10 lines.
5. No new features/APIs? **PASS** — synchronization annotations only.
6. Can apply to local tree? **PASS** — code present; patch 1/2
   prerequisite satisfied.

### Step 9.3: Exception Categories
**Record:** None (not device ID, quirk, DT, build fix, or docs).

### Step 9.4: Decision Rationale

For **linux-6.18.y** specifically: patch 1/2 of this series is already
backported, leaving `cl->deficit` properly annotated but `cl->quantum`
still racy in the exact same functions (`drr_enqueue`, `drr_dequeue`,
dump paths). Backporting this commit completes a maintainer-intended,
already-half-applied concurrency fix with negligible risk. While the
user-visible severity is low (no crashes reported), the technical merit
and series consistency strongly favor inclusion in this tree.

---

## Verification

- [Phase 1] Parsed subject, tags, body from user-provided commit message
- [Phase 2] Analyzed full diff (4 hunks, 1 file); classified as data-
  race fix
- [Phase 3] `git describe HEAD` → v6.18.44; `git blame` on lines
  100–103, 365, 406
- [Phase 3] `git log --oneline -20 -- net/sched/sch_drr.c` — found
  `a88f6da618e8b` (patch 1/2)
- [Phase 3] `git show a88f6da618e8b` — deficit annotations, Fixes
  `edb09eb17ed89`, already in tree
- [Phase 3] `git log --grep='quantum lockless'` / `'make cl->quantum'` —
  **no results** (patch 2/2 absent)
- [Phase 3] `git merge-base --is-ancestor edb09eb17ed89 HEAD` →
  prerequisite present
- [Phase 4] Web search found spinics.net series page and syzbot CI page;
  lore fetch blocked
- [Phase 4] Syzbot CI: build/boot/fuzz passed, no bug filed
- [Phase 5] Read `net/sched/sch_drr.c` — confirmed current buggy state
  (plain `cl->quantum` reads)
- [Phase 5] `grep READ_ONCE(cl->quantum)` in `net/sched/` → **no
  matches**
- [Phase 5] Read `tc_dump_tclass_qdisc` in `sch_api.c` — dump walks
  classes without spinlock
- [Phase 6] Confirmed tree is 6.18.y stable; buggy code present; patch
  1/2 backported July 2026
- [Phase 8] Assessed severity as LOW-MEDIUM (scheduling inaccuracy, not
  crash)

**YES**The background check finished: **patch 1/2** (`a88f6da618e8b` —
deficit `READ_ONCE`/`WRITE_ONCE` annotations) is already in this
**6.18.44** tree, and **patch 2/2** (`make cl->quantum lockless`) is not
— `git log --grep='quantum lockless'` and `--grep='make cl->quantum'`
both came up empty.

That matches the earlier analysis: the series is only half-applied here,
and backporting this commit would complete it. Verdict remains **YES**.

 net/sched/sch_drr.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/net/sched/sch_drr.c b/net/sched/sch_drr.c
index 44686fd1c2749..faafb29056259 100644
--- a/net/sched/sch_drr.c
+++ b/net/sched/sch_drr.c
@@ -97,10 +97,8 @@ static int drr_change_class(struct Qdisc *sch, u32 classid, u32 parentid,
 			}
 		}
 
-		sch_tree_lock(sch);
 		if (tb[TCA_DRR_QUANTUM])
-			cl->quantum = quantum;
-		sch_tree_unlock(sch);
+			WRITE_ONCE(cl->quantum, quantum);
 
 		return 0;
 	}
@@ -251,7 +249,7 @@ static int drr_dump_class(struct Qdisc *sch, unsigned long arg,
 	nest = nla_nest_start_noflag(skb, TCA_OPTIONS);
 	if (nest == NULL)
 		goto nla_put_failure;
-	if (nla_put_u32(skb, TCA_DRR_QUANTUM, cl->quantum))
+	if (nla_put_u32(skb, TCA_DRR_QUANTUM, READ_ONCE(cl->quantum)))
 		goto nla_put_failure;
 	return nla_nest_end(skb, nest);
 
@@ -362,7 +360,7 @@ static int drr_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 
 	if (!cl_is_active(cl)) {
 		list_add_tail(&cl->alist, &q->active);
-		WRITE_ONCE(cl->deficit, cl->quantum);
+		WRITE_ONCE(cl->deficit, READ_ONCE(cl->quantum));
 	}
 
 	sch->qstats.backlog += len;
@@ -403,7 +401,7 @@ static struct sk_buff *drr_dequeue(struct Qdisc *sch)
 			return skb;
 		}
 
-		WRITE_ONCE(cl->deficit, cl->deficit + cl->quantum);
+		WRITE_ONCE(cl->deficit, cl->deficit + READ_ONCE(cl->quantum));
 		list_move_tail(&cl->alist, &q->active);
 	}
 out:
-- 
2.53.0

