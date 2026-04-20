Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C87303DEAE4;
	Mon, 20 Apr 2026 13:24:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776691462; cv=none; b=OBnjdagvZyQm6td9tCHOP6GVFHbpsDgEiyv1fooL7g3JOKWdOXjl7dr+CgpBJghA4OWPnGUuSQT4b5fqxFkm3/7J4Vu+iRbqndJEUa45yWPmQ73gOkvU4v12KDWYos4VsrH+qKFNdEyyui8+dMuk6ecGXQNUhKas9MlkvtgTNvs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776691462; c=relaxed/simple;
	bh=UjvABFKh4vOpX+wJoBCPDMZBcNXqY5zQd6sZzLMY1N4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gPPiBi4NnIL1k3COaZGwjLgROMVdh6yiuGqU4JkNcn8r/xxLpe+VIDAplCRwpUGv2Qxm4rnMBrydj0x1i6hd3Ra8ZI7o/TjO4RdC37eTM74j9CnUr4TFDCo+BAyBDWdPgjCnYiclynZTFBPUSknicsyLy8cqly2gdHmPC55ut8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mXPM/mES; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mXPM/mES"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0797C2BCC4;
	Mon, 20 Apr 2026 13:24:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776691462;
	bh=UjvABFKh4vOpX+wJoBCPDMZBcNXqY5zQd6sZzLMY1N4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mXPM/mESvLl6BKAZYTWQwBfFsEE5b/mOYvryEXTwavqlPYfDC+hbJFhOp6JUoUW3O
	 h2om/kdJct29lhantKKUrX4kw+rFxpaGyUy/dWgU1owUGXCMk5SwVvsKSAlv2UmXt7
	 5d4LUyAgFe9P3JNDn/kRQwHkKIPUUUPiX6znN/Y2V+Sg91PyGeEbbgpyC0jVYUedu/
	 WZ9OStZyWiZchacmbJGu5NU9KB3KW7ddL08Ij5YRejcIRRGx0J/sYjvd2obfTzB9cB
	 16VmPJCP2g0MWx4oH14bfmKoZWYsPjFXC2iSlmT1mxLH9R7V5XBu0j9fC+ddYUF+fQ
	 pvGpva/qGpGKA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: "Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	mingo@redhat.com,
	juri.lelli@redhat.com,
	vincent.guittot@linaro.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-6.18] sched/fair: Make hrtick resched hard
Date: Mon, 20 Apr 2026 09:17:17 -0400
Message-ID: <20260420132314.1023554-43-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420132314.1023554-1-sashal@kernel.org>
References: <20260420132314.1023554-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 7.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: "Peter Zijlstra (Intel)" <peterz@infradead.org>

[ Upstream commit 5d88e424ec1b3ea7f552bd14d932f510146c45c7 ]

Since the tick causes hard preemption, the hrtick should too.

Letting the hrtick do lazy preemption completely defeats the purpose, since
it will then still be delayed until a old tick and be dependent on
CONFIG_HZ.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://patch.msgid.link/20260224163428.933894105@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have all the information needed for a thorough analysis. Let me
compile the full assessment.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1: Subject Line**
- Subsystem: `sched/fair` (CFS scheduler)
- Action verb: "Make" (corrective - restoring proper behavior)
- Summary: Change hrtick reschedule from lazy to hard preemption

**Step 1.2: Tags**
- Signed-off-by: Peter Zijlstra (Intel) - scheduler maintainer, author
- Signed-off-by: Thomas Gleixner - core kernel maintainer
- Signed-off-by: Peter Zijlstra (Intel) - applied by PZ
- Link: `https://patch.msgid.link/20260224163428.933894105@kernel.org`
- No Fixes: tag (expected), no Reported-by, no Cc: stable

**Step 1.3: Commit Body**
The message explains: the tick causes hard preemption, so the hrtick
should too. Letting hrtick use lazy preemption completely defeats its
purpose because it will be delayed until the next periodic tick, making
hrtick behavior dependent on CONFIG_HZ rather than the high-resolution
timer.

**Step 1.4: Hidden Bug Fix Detection**
This IS a bug fix. The word "Make" disguises what is actually a fix for
a regression: the lazy preemption conversion (7c70cb94d29cd3)
incorrectly applied `resched_curr_lazy()` to the hrtick path, completely
defeating the purpose of hrtick scheduling.

Record: [sched/fair] [Make (fix regression)] [Restore hard preemption
for hrtick path defeated by lazy preemption]

## PHASE 2: DIFF ANALYSIS

**Step 2.1: Inventory**
- 1 file changed: `kernel/sched/fair.c`
- 1 line changed (−1, +1): `resched_curr_lazy()` → `resched_curr()`
- Function modified: `entity_tick()`
- Scope: single-line surgical fix

**Step 2.2: Code Flow Change**
Before: When hrtick fires (`queued=1`), `entity_tick()` calls
`resched_curr_lazy()`, which sets `TIF_NEED_RESCHED_LAZY`. With lazy
preemption, this does NOT trigger immediate rescheduling - it waits
until `scheduler_tick()` promotes it to `TIF_NEED_RESCHED`.

After: `entity_tick()` calls `resched_curr()`, which sets
`TIF_NEED_RESCHED` directly, causing immediate preemption.

**Step 2.3: Bug Mechanism**
Category: Logic/correctness fix (regression from lazy preemption
conversion).

The mechanism:
1. `hrtick()` callback (core.c:885) calls `task_tick()` with `queued=1`
2. `task_tick_fair()` calls `entity_tick()` with `queued=1`
3. `entity_tick()` calls `resched_curr_lazy()` → sets
   `TIF_NEED_RESCHED_LAZY`
4. Unlike `scheduler_tick()` (core.c:5570-5571) which promotes
   `TIF_NEED_RESCHED_LAZY` to `TIF_NEED_RESCHED`, the hrtick callback
   does NOT do this promotion
5. Result: preemption delayed until the next periodic tick, defeating
   hrtick entirely

**Step 2.4: Fix Quality**
- Obviously correct: the fix simply uses hard resched for hrtick,
  matching the intent
- Minimal: one line change
- Regression risk: essentially zero - this restores the pre-lazy-
  preemption behavior for this specific path
- The other two `resched_curr_lazy()` call sites in fair.c (update_curr
  and check_preempt_wakeup_fair) correctly use lazy, since those are
  normal CFS preemption decisions

Record: [1 file, 1 line change] [entity_tick] [Single-line surgical fix]
[resched_curr_lazy → resched_curr for queued hrtick only]

## PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1: Blame**
Git blame shows line 5603 was last changed by commit 7c70cb94d29cd3
("sched: Add Lazy preemption model", 2024-10-04) which converted
`resched_curr()` to `resched_curr_lazy()`. Before that, the code used
`resched_curr()` since 2008 (commit 8f4d37ec073c17).

**Step 3.2: Fixes Target**
No explicit Fixes: tag. However, the implicit target is 7c70cb94d29cd3
("sched: Add Lazy preemption model") which was merged in v6.13. This
commit exists in v6.13, v6.14, v6.15, and v7.0.

**Step 3.3: Related Changes**
- 95a0155224a65 ("sched/fair: Limit hrtick work") is a related commit in
  v7.0 that optimizes `task_tick_fair()` for hrtick, but it modifies
  `task_tick_fair()`, NOT `entity_tick()`. The current fix is
  independent.
- The fix applies inside `entity_tick()` regardless of
  `task_tick_fair()` changes.

**Step 3.4: Author**
Peter Zijlstra is THE scheduler maintainer. He's also the author of the
original lazy preemption commit that introduced this bug.

**Step 3.5: Dependencies**
The fix requires only that `resched_curr_lazy()` exists (introduced in
7c70cb94d29cd3). No other dependencies. Standalone fix.

Record: [Buggy code from 7c70cb94d29cd3 (v6.13)] [Fix is standalone, no
dependencies] [Author is subsystem maintainer]

## PHASE 4: MAILING LIST RESEARCH

**Step 4.1-4.5:** Lore.kernel.org is currently behind anti-bot
protection (Anubis). b4 dig could not find the commit by message-id. The
Link: tag points to
`https://patch.msgid.link/20260224163428.933894105@kernel.org` which is
also inaccessible.

From the commit metadata, the patch was signed by both Peter Zijlstra
and Thomas Gleixner, indicating it went through the tip tree with review
from two top-tier kernel maintainers.

Record: [Could not access lore due to anti-bot protection] [Two top
maintainer SOBs indicates proper review]

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1: Functions Modified**
- `entity_tick()` in `kernel/sched/fair.c`

**Step 5.2: Callers**
`entity_tick()` is called from `task_tick_fair()` (line 13435), which is
the CFS `task_tick` callback. It's called from:
1. `scheduler_tick()` (core.c:5573) with `queued=0` (periodic tick)
2. `hrtick()` (core.c:894) with `queued=1` (high-res timer tick)

The bug ONLY affects the hrtick path (`queued=1`).

**Step 5.3-5.4: Call Chain**
`hrtick()` → `task_tick_fair()` → `entity_tick()` →
`resched_curr_lazy()` (buggy) / `resched_curr()` (fixed)

The hrtick is triggered from hardirq context when a high-resolution
timer fires. The timer is programmed by `hrtick_start_fair()` to fire at
the exact point a task's time slice expires.

**Step 5.5: Similar Patterns**
The other two `resched_curr_lazy()` sites in fair.c (line 1329 in
`update_curr()` and line 8938 in `check_preempt_wakeup_fair()`) are
correct for lazy preemption - those are normal CFS scheduling decisions
where lazy preemption is intentional.

Record: [entity_tick called from scheduler_tick (queued=0) and hrtick
(queued=1)] [Only hrtick path affected] [Other lazy sites are correct]

## PHASE 6: STABLE TREE ANALYSIS

**Step 6.1: Buggy Code in Stable**
The lazy preemption model (7c70cb94d29cd3) was merged in v6.13. It is
NOT in v6.12 (the current LTS). Affected trees: v6.13.y, v6.14.y,
v6.15.y, v7.0.y.

**Step 6.2: Backport Complexity**
The fix is a single-line change in `entity_tick()`. The surrounding code
in this function has been stable since 2008. The fix should apply
cleanly to any tree with the lazy preemption model.

**Step 6.3: Related Fixes in Stable**
No related fixes found for this specific issue in any stable tree.

Record: [Bug exists in v6.13+] [Clean apply expected] [No related fixes
already in stable]

## PHASE 7: SUBSYSTEM CONTEXT

**Step 7.1: Subsystem**
- kernel/sched (scheduler) - CORE subsystem affecting all users
- Specifically CFS (Completely Fair Scheduler) with hrtick enabled

**Step 7.2: Activity**
Very active subsystem with frequent changes from Peter Zijlstra and
other scheduler developers.

Record: [CORE subsystem] [Very active]

## PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1: Who is Affected**
Users on v6.13+ who:
1. Use `CONFIG_PREEMPT_LAZY` or `dynamic_preempt_lazy()` (lazy
   preemption model)
2. Have `HRTICK` sched feature enabled (disabled by default, enabled via
   `/sys/kernel/debug/sched/features`)
3. `CONFIG_SCHED_HRTICK` is compiled in (auto-enabled with
   `HIGH_RES_TIMERS`)

This is a subset of users - those who explicitly enable HRTICK for low-
latency CFS scheduling.

**Step 8.2: Trigger Conditions**
The bug is triggered every time the hrtick fires on a system with lazy
preemption enabled and HRTICK sched feature enabled. It's deterministic,
not a race.

**Step 8.3: Failure Mode**
- hrtick preemption is delayed by up to one full periodic tick (1-10ms
  depending on CONFIG_HZ)
- This defeats the entire purpose of hrtick (sub-tick precision
  scheduling)
- Severity: MEDIUM (scheduling latency degradation, not
  crash/corruption)
- For latency-sensitive workloads relying on hrtick: HIGH (makes the
  feature useless)

**Step 8.4: Risk-Benefit Ratio**
- BENEFIT: Fixes a clear regression that makes hrtick completely useless
  under lazy preemption
- RISK: Essentially zero - 1 line change, restoring pre-regression
  behavior for this specific path
- Ratio: Excellent benefit-to-risk

Record: [Affects HRTICK users on lazy preemption v6.13+] [Deterministic
trigger] [MEDIUM severity - scheduling latency regression] [Excellent
risk-benefit ratio]

## PHASE 9: FINAL SYNTHESIS

**Step 9.1: Evidence Compilation**

FOR backporting:
- Fixes a clear regression from 7c70cb94d29cd3 (lazy preemption
  conversion)
- 1-line change, minimal, obviously correct
- From the subsystem maintainer (Peter Zijlstra) AND Thomas Gleixner
- Completely defeats the purpose of hrtick under lazy preemption
- Zero regression risk
- Standalone fix, no dependencies

AGAINST backporting:
- HRTICK sched feature is disabled by default (opt-in)
- Not a crash, data corruption, or security issue
- Bug only exists in v6.13+ (not in LTS v6.12.y or older)
- Impact limited to subset of users who enable HRTICK

**Step 9.2: Stable Rules Checklist**
1. Obviously correct? YES - restores pre-regression behavior for this
   path
2. Fixes a real bug? YES - hrtick is completely broken under lazy
   preemption
3. Important issue? MEDIUM - scheduling latency regression (not
   crash/security)
4. Small and contained? YES - 1 line, 1 file
5. No new features? YES - pure fix
6. Can apply to stable? YES - clean apply expected

**Step 9.3: Exception Categories**
Not an exception category. Standard bug fix.

**Step 9.4: Decision**
The fix is a 1-line surgical change by the subsystem maintainer that
corrects a clear regression from the lazy preemption model introduction.
While hrtick is not enabled by default, the bug completely breaks the
feature for anyone who uses it. The risk is essentially zero and the
benefit is restoring correct behavior for an important scheduling
mechanism.

## Verification

- [Phase 1] Parsed tags: SOBs from Peter Zijlstra and Thomas Gleixner,
  Link to patch.msgid.link
- [Phase 2] Diff: 1 line changed in `entity_tick()`:
  `resched_curr_lazy()` → `resched_curr()`
- [Phase 3] git blame: line 5603 changed by 7c70cb94d29cd3 (lazy
  preemption, 2024-10-04), previously `resched_curr()` since 2008
  (8f4d37ec073c17)
- [Phase 3] git merge-base: 7c70cb94d29cd3 is NOT in v6.12, IS in
  v6.13/v6.14/v6.15/v7.0
- [Phase 3] 95a0155224a65 ("Limit hrtick work") modifies
  `task_tick_fair()`, independent of this fix to `entity_tick()`
- [Phase 3] Author is Peter Zijlstra, THE scheduler maintainer
- [Phase 4] Lore inaccessible (Anubis anti-bot). b4 dig failed to find
  match by message-id
- [Phase 5] `entity_tick()` called from `hrtick()` (queued=1) and
  `scheduler_tick()` (queued=0)
- [Phase 5] `hrtick()` (core.c:885-898) does NOT promote
  TIF_NEED_RESCHED_LAZY, unlike `scheduler_tick()` (core.c:5570-5571)
- [Phase 5] Other `resched_curr_lazy()` sites in fair.c (lines 1329,
  8938) are correct
- [Phase 6] Bug exists only in v6.13+ (lazy preemption not in v6.12 LTS)
- [Phase 6] Fix applies cleanly - `entity_tick()` unchanged since 2008
  except for the lazy conversion
- [Phase 7] CONFIG_SCHED_HRTICK is `def_bool HIGH_RES_TIMERS` (compiled
  in commonly), but HRTICK sched feature defaults to false
- [Phase 8] Failure: scheduling latency degradation, hrtick completely
  defeated. Severity: MEDIUM
- UNVERIFIED: Mailing list discussion contents (lore inaccessible). Does
  not affect decision since fix is obviously correct from code analysis.

**YES**

 kernel/sched/fair.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index ab4114712be74..42051bdea3f17 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -5600,7 +5600,7 @@ entity_tick(struct cfs_rq *cfs_rq, struct sched_entity *curr, int queued)
 	 * validating it and just reschedule.
 	 */
 	if (queued) {
-		resched_curr_lazy(rq_of(cfs_rq));
+		resched_curr(rq_of(cfs_rq));
 		return;
 	}
 #endif
-- 
2.53.0

