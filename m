Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4230F49F105;
	Mon, 31 Aug 2026 13:41:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183662; cv=none; b=c1VCTGRBA+XkMzD7o02i+9imJGpG5kCyWF8LmEiOw9GbRPCSZkbeVUzqbxCbNIQRH9EZHTkxEIbJvESViou9GS2KgWVI/Nzn7yiw6w6tjdi0B0qlXj6rAY9+Isw+se29adMzJNyNjJoaizdLPM0f8aFdMguHNhduc14AxgSiWno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183662; c=relaxed/simple;
	bh=5mVFXDDwRIFrktlJtdmQdRepNZhRf8RXk1psKbpzzbY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=F9hgOU5cVEv6XVzWkquvsthgHks+BimJ0/hP1XJbyM3r9YkDc9IokdbIm97oVKUi7HUGbyf/x9KxcB2ds9hZ7FoB8RbwyU1s4EmJH3/GOc8AD6A6YWQD7TrO0z20b/q14H/tSnQJle7GF5nfGEjUHlPo1ZXx4OIPOfi/sdXZaNQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EMiXLHUB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EMiXLHUB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 130361F00ACF;
	Mon, 31 Aug 2026 13:40:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183660;
	bh=Vf6+54o0ux6cYkoKwDlPwqpXYnzXiEexW51rM9YxfuI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EMiXLHUBz7h4PnJKCwdgBmN/x0TSdhDpng+2bp5AzjdZbr36TnJYv7C8AoevCgNaG
	 vBq44NoOaGiN6xKg5vk+A7bH8wPlOdO3TIhDLhcz1gygEsBGh0+uPAJOOwXewi2rHU
	 xlap627wrmPz9EcyCOmx+iMI1IErKtJoQGhQhWvpqZNhLv1DXv5IJdhuBWkvjzoW/I
	 JNw6P+bGiu2sTIuSDeRgIxllZPoW3qeDs1mvXd4JbMBde/gqMlZ8tOZrPGf3SMOoi2
	 g/m2fjijmyk9RUx9Q4B3rCdu89dL4wAeEQ4Ip2NeqL41ofU5usSj+gOMjk94qa5EQx
	 NxhUfXcbki+KQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Peter Zijlstra <peterz@infradead.org>,
	Lee Jia Jie <jiajie.lee@starlabs.sg>,
	Sasha Levin <sashal@kernel.org>,
	mingo@redhat.com,
	acme@kernel.org,
	namhyung@kernel.org,
	linux-perf-users@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.12] perf: Fix addr_filter_ranges lifetime
Date: Mon, 31 Aug 2026 09:24:15 -0400
Message-ID: <20260831133314.4125787-227-sashal@kernel.org>
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

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit e62d4192e593630f355094adc467058a05bdc935 ]

Lee Jia Jie reported that since event::addr_filter_ranges is used
under RCU, it should be RCU freed.

Reported-by: Lee Jia Jie <jiajie.lee@starlabs.sg>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit Message Forensics

### Step 1.1: Parse Subject Line
**Record:** `[perf]` `[Fix]` — correct the lifetime of
`event::addr_filter_ranges` so it is freed only after RCU readers are
done.

### Step 1.2: Parse All Commit Message Tags
**Record:**
- **Reported-by:** Lee Jia Jie \<jiajie.lee@starlabs.sg\> — single
  reporter; indicates a real review/testing finding
- **Signed-off-by:** Peter Zijlstra (Intel) \<peterz@infradead.org\> —
  perf subsystem maintainer
- No Fixes:, Link:, Tested-by:, Reviewed-by:, Acked-by:, or Cc: stable
  tags (absence of Cc: stable is expected per review pipeline)

### Step 1.3: Analyze Commit Body
**Record:**
- **Bug:** `event::addr_filter_ranges` is accessed under RCU but was
  freed synchronously in `__free_event()` before the RCU grace period
  ended.
- **Symptom:** Use-after-free when RCU readers still access the array
  (crash, KASAN report, or memory corruption).
- **Root cause:** `kfree(event->addr_filter_ranges)` ran in
  `__free_event()` while `call_rcu(&event->rcu_head, free_event_rcu)`
  deferred only the `perf_event` struct itself — not the separately
  allocated array.
- **Version info:** None in the commit message.

### Step 1.4: Detect Hidden Bug Fixes
**Record:** Not disguised — this is an explicit lifetime/UAF fix. The
one-line move of `kfree()` from synchronous teardown to the RCU callback
is a classic deferred-free pattern.

---

## Phase 2: Diff Analysis

### Step 2.1: Inventory the Changes
**Record:**
- **File:** `kernel/events/core.c` (+1 / −2 lines)
- **Functions modified:** `free_event_rcu()`, `__free_event()`
- **Scope:** Single-file, surgical fix (2-line net change)

### Step 2.2: Code Flow Change
**Record:**
- **Hunk 1 (`free_event_rcu`):** Before → frees only `perf_event` struct
  (after filter cleanup). After → also
  `kfree(event->addr_filter_ranges)` here, after RCU grace period.
- **Hunk 2 (`__free_event`):** Before →
  `kfree(event->addr_filter_ranges)` synchronously, then `call_rcu()`.
  After → array is not freed here; only the event struct is deferred via
  `call_rcu()`.

### Step 2.3: Bug Mechanism
**Record:** **Memory safety / use-after-free.** Category (d).
`addr_filter_ranges` is a separately `kcalloc()`'d array accessed from
RCU-protected iterators while the parent `perf_event` may still be
visible to RCU readers until `free_event_rcu()` runs.

### Step 2.4: Fix Quality
**Record:** Obviously correct — mirrors how the `perf_event` struct
itself is already RCU-freed. Minimal change. `kfree(NULL)` is safe for
events without address filters. No meaningful regression risk.

---

## Phase 3: Git History Investigation

### Step 3.1: Blame Changed Lines
**Record:** `kfree(event->addr_filter_ranges)` in `__free_event()` was
placed there by **c70ca298036c5** ("perf/core: Simplify the
perf_event_alloc() error path", Nov 2024). The same premature-free
pattern existed in `_free_event()` since **c60f83b813e5b** (Feb 2019)
when `addr_filter_ranges` was introduced.

### Step 3.2: Follow Fixes: Tag
**Record:** No Fixes: tag present — N/A.

### Step 3.3: File History for Related Changes
**Record:** Related commits in this tree:
- **c60f83b813e5b** (2019) — introduced `addr_filter_ranges`
- **c70ca298036c5** (2024) — refactored into `__free_event()`, kept
  premature `kfree`
- **0fe8813baf4b2** (Jan 2025) — restored RCU read-lock around
  `perf_iterate_ctx()` in `perf_event_exec()` (Cc: stable)
- **e62d4192e5936** (Jun 2026) — this fix; on `master`, **not** in
  current HEAD

Standalone fix, not part of a series.

### Step 3.4: Author's Other Commits
**Record:** Peter Zijlstra is the perf core maintainer. He authored
c70ca298 (which organized the buggy path) and e62d4192 (this fix).
Multiple recent perf UAF/lifetime fixes exist on this stable branch
(e.g. c27dea9f50ed5 perf_mmap UAF, c8b7e113f7b61 perf/aux page UAF).

### Step 3.5: Prerequisites
**Record:** No dependencies. `git apply --check` on e62d4192 against
current tree succeeds cleanly. Self-contained.

---

## Phase 4: Mailing List and External Research

### Step 4.1: Original Patch Discussion
**Record:** `b4 dig -c e62d4192e5936` →
https://patch.msgid.link/178186383722.1650852.13407085310329360626.tip-
bot2@tip-bot2 (tip-bot commit notification). `b4 dig -a` returned no
additional revisions (single-shot fix). Lore fetch blocked by bot
protection — could not read thread content.

### Step 4.2: Reviewers
**Record:** `b4 dig -w` returned only the tip-bot link; no expanded
recipient list available.

### Step 4.3: Bug Report
**Record:** Reported-by Lee Jia Jie only; no syzbot, no Link: to
external tracker. Reporter is also credited on c8b7e113f7b61 (another
perf UAF fix in this tree), suggesting active perf security review.

### Step 4.4: Related Patches/Series
**Record:** Standalone; no series.

### Step 4.5: Stable Mailing List
**Record:** Lore stable search blocked. UNVERIFIED whether stable
maintainers already discussed this specific fix.

---

## Phase 5: Code Semantic Analysis

### Step 5.1: Key Functions
**Record:** `free_event_rcu()`, `__free_event()`, `_free_event()`,
`perf_iterate_ctx()`, `__perf_addr_filters_adjust()`,
`perf_event_addr_filters_exec()`, `perf_addr_filters_adjust()`,
`perf_event_exec()`.

### Step 5.2: Trace Callers
**Record:** RCU readers accessing `addr_filter_ranges`:
- `perf_addr_filters_adjust()` → `rcu_read_lock()` →
  `perf_iterate_ctx()` → `__perf_addr_filters_adjust()` — triggered from
  `perf_event_mmap()` on every executable `mmap()`
- `perf_event_exec()` → `scoped_guard(rcu)` → `perf_iterate_ctx()` →
  `perf_event_addr_filters_exec()` — triggered on every `execve()`

Teardown path: `perf_release` / `perf_event_exit_task` → `_free_event()`
→ `__free_event()` → `kfree(addr_filter_ranges)` [buggy] →
`call_rcu(free_event_rcu)`.

### Step 5.3: Key Callees
**Record:** `kcalloc()` allocates the array (line 13103);
`list_for_each_entry_rcu()` in `perf_iterate_ctx()` (line 8604);
`list_del_rcu(&event->event_entry)` in `list_del_event()` (line 2136)
removes the event from the RCU list but does not wait for grace period
before the array is freed.

### Step 5.4: Call Chain / Reachability
**Record:** Reachable from normal process activity (`mmap` of executable
mappings, `execve`) concurrent with `perf_event` close/exit. Affects
processes using perf events with address filters on PMUs that expose
`nr_addr_filters` (Intel PT at `arch/x86/events/intel/pt.c`, CoreSight
ETM at `drivers/hwtracing/coresight/coresight-etm-perf.c`).

### Step 5.5: Similar Patterns
**Record:** Same file has multiple recent RCU/lifetime fixes (perf_mmap
UAF, aux page UAF). The fix pattern (move free into RCU callback)
matches `free_event_rcu()`'s existing role for the event struct.

---

## Phase 6: Cross-Referencing Against Local Tree

### Step 6.1: Does Buggy Code Exist?
**Record:** **YES.** Tree is **linux-6.18.y** at
`v6.18.44-1-g2736c32da98b9` (Makefile: 6.18.44). Buggy
`kfree(event->addr_filter_ranges)` is at line 5610 in `__free_event()`.
`free_event_rcu()` at lines 5157–5165 does not yet free the array. Fix
commit e62d4192e5936 is **not** an ancestor of HEAD.

### Step 6.2: Backport Complications
**Record:** `git apply --check` passes cleanly. Line numbers differ
slightly from the patch context but structure matches. Expected: clean
apply.

### Step 6.3: Related Fixes Already Present?
**Record:** No equivalent fix found. The premature `kfree` is still
present.

---

## Phase 7: Subsystem and Maintainer Context

### Step 7.1: Subsystem Criticality
**Record:** **perf core** (`kernel/events/core.c`) — **CORE/IMPORTANT**.
Not universal like the scheduler, but widely used for profiling/tracing;
bugs are memory-safety issues in kernel code reachable from syscalls.

### Step 7.2: Subsystem Activity
**Record:** Highly active — 106 commits to `kernel/events/core.c` since
c70ca298; multiple UAF fixes landed on this stable branch in 2025–2026.

---

## Phase 8: Impact and Risk Assessment

### Step 8.1: Who Is Affected
**Record:** Users of perf events with address filters — Intel Processor
Trace and Arm CoreSight ETM tracing with file-based or kernel address
filters. Config-dependent on `CONFIG_PERF_EVENTS` and PMU drivers with
`nr_addr_filters > 0`.

### Step 8.2: Trigger Conditions
**Record:** Concurrent perf event teardown (`close(2)` on perf fd, task
exit) with `mmap()` of executable mappings or `execve()` in the same
process context while address-filter events exist. Timing-dependent but
realistic. Unprivileged users can trigger via normal perf usage.

### Step 8.3: Failure Mode Severity
**Record:** **Use-after-free** on kernel heap → kernel oops, KASAN
splat, or exploitable memory corruption. **Severity: HIGH** (potential
security impact via UAF).

### Step 8.4: Risk-Benefit
**Record:**
- **Benefit:** HIGH — prevents UAF in perf core on realistic concurrent
  paths
- **Risk:** VERY LOW — 2-line move, no API/behavior change, maintainer-
  authored
- **Ratio:** Strongly favors backport

---

## Phase 9: Final Synthesis

### Step 9.1: Evidence Compile

**FOR backport:**
- Real UAF: `addr_filter_ranges` freed before RCU grace period while RCU
  iterators access it
- RCU access paths verified in `perf_addr_filters_adjust()` and
  `perf_event_exec()`
- Small, surgical, maintainer fix; applies cleanly to 6.18.y
- Bug present since 2019; still unfixed in this tree
- Reported by active perf security reviewer
- Same class of fix as other accepted stable perf UAF fixes on this
  branch

**AGAINST backport:**
- Niche hardware (PT/CoreSight address filters) — not every user
- No syzbot reproducer or crash log in commit message
- Lore discussion content unverified

**UNRESOLVED:**
- Full mailing-list review thread content (lore blocked)
- Whether Lee Jia Jie's report included a concrete reproducer/crash log

### Step 9.2: Stable Rules Checklist
1. Obviously correct and tested? **PASS** — standard RCU deferred-free;
   maintainer fix; no logic ambiguity
2. Fixes a real bug? **PASS** — UAF verified by code path analysis
3. Important issue? **PASS** — UAF / potential crash or security issue
   (HIGH)
4. Small and contained? **PASS** — 3 lines, one file
5. No new features or APIs? **PASS** — lifetime fix only
6. Can apply to local tree? **PASS** — `git apply --check` succeeds;
   buggy code confirmed present

### Step 9.3: Exception Categories
**Record:** None (not device ID, quirk, DT, build, or docs). Qualifies
on straight bug-fix criteria.

### Step 9.4: Problem Summary for Stable Users

When a perf event with address filters is torn down, `__free_event()`
immediately frees `addr_filter_ranges` but defers freeing the
`perf_event` struct via RCU. Meanwhile, `mmap()` and `execve()` paths
iterate events under `rcu_read_lock()` and read/write
`event->addr_filter_ranges[]`. A concurrent close/exit can free the
array while an RCU reader still uses it — a classic use-after-free.

The fix moves `kfree(event->addr_filter_ranges)` into
`free_event_rcu()`, ensuring the array outlives all RCU readers,
consistent with how the event struct itself is freed.

---

## Verification

- [Phase 1] Parsed subject, tags, body from `git show e62d4192e5936`
- [Phase 2] Diff: +1 line in `free_event_rcu`, −1 line in
  `__free_event`; net 3 lines changed
- [Phase 3] `git describe HEAD`: v6.18.44 on linux-6.18.y
- [Phase 3] `git blame -L 5608,5612`: kfree placed by c70ca298036c5
- [Phase 3] `git log -S 'kfree(event->addr_filter_ranges)'`:
  c60f83b813e5b, c70ca298036c5
- [Phase 3] `git merge-base --is-ancestor e62d4192e5936 HEAD`: fix NOT
  in tree
- [Phase 3] `git merge-base --is-ancestor c70ca298036c5 HEAD`: bug-
  introducing refactor IS in tree
- [Phase 4] `b4 dig -c e62d4192e5936`: tip-bot lore link found
- [Phase 4] `b4 dig -a`, `b4 dig -w`: no extra revisions; minimal
  recipient info
- [Phase 4] Lore fetch: BLOCKED by bot protection — thread content
  UNVERIFIED
- [Phase 5] `grep addr_filter_ranges kernel/events/core.c`: RCU access
  at lines 8690–8691, 9566, 11514–11520
- [Phase 5] `perf_iterate_ctx` uses `list_for_each_entry_rcu` at line
  8604
- [Phase 5] `perf_addr_filters_adjust` uses `rcu_read_lock` at line 9594
- [Phase 5] `perf_event_exec` uses `scoped_guard(rcu)` at line 8716
- [Phase 5] PMUs with address filters: `arch/x86/events/intel/pt.c`,
  `drivers/hwtracing/coresight/coresight-etm-perf.c`
- [Phase 6] Buggy `kfree` at line 5610 confirmed in working tree
- [Phase 6] `git apply --check` of e62d4192: PASSES cleanly
- [Phase 6] `free_event_rcu` at lines 5157–5165 lacks
  `kfree(addr_filter_ranges)` — confirms fix needed
- [Phase 8] Failure mode: UAF, severity HIGH

**YES****Backport recommendation: YES** for linux-6.18.y (v6.18.44).

This is a small perf-core UAF fix: `event->addr_filter_ranges` was freed
in `__free_event()` before the RCU grace period ended, while `mmap()`
and `execve()` paths still access it under RCU via `perf_iterate_ctx()`.
The fix moves `kfree()` into `free_event_rcu()`, matching how the event
struct itself is freed.

The buggy code is present in your checkout; commit `e62d4192e5936` is on
`master` but not in HEAD. The patch applies cleanly with `git apply
--check`.

 kernel/events/core.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index f3bd7c97c3aab..99810cfecfd8c 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -5161,6 +5161,7 @@ static void free_event_rcu(struct rcu_head *head)
 	if (event->ns)
 		put_pid_ns(event->ns);
 	perf_event_free_filter(event);
+	kfree(event->addr_filter_ranges);
 	kmem_cache_free(perf_event_cache, event);
 }
 
@@ -5607,8 +5608,6 @@ static void __free_event(struct perf_event *event)
 	if (event->attach_state & PERF_ATTACH_CALLCHAIN)
 		put_callchain_buffers();
 
-	kfree(event->addr_filter_ranges);
-
 	if (event->attach_state & PERF_ATTACH_EXCLUSIVE)
 		exclusive_event_destroy(event);
 
-- 
2.53.0

