Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B34FC4A8A06;
	Mon, 31 Aug 2026 13:45:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183943; cv=none; b=TeddLG5eRm5hYMK4o1twytJ8YR9kCFF84Q8Nq7qKjs/60a/eEchX6uTCQJNG1a0/p1NytPXIMNA0nYN74wJBiovqN8VVkF1xkdggY18PU+z3msha8s7UorV7Qyu5+mj7QJcIClIURrTHS1d89n3fM111m6Pgq4klVuAitWuXnbM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183943; c=relaxed/simple;
	bh=RzRQe0czuJJCNEDFfAYZErCKIdLeXW6UnHOQzUUwDwk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aGAh7naH2A1jWQpxNK67KvZZ8HW4cewV2XSTEPFeD8ntaanp8s8VGUrmFGt322on7O3i9P3jXWkFVIaur+m9bArczFo9oMTeL2+sq83PAavw0FaXa+ZyUgO1E/1bNPkybgSqFsesl3vJ1034Rww3XVwLSlX0eI94a1iG30YRydI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=omkhpQA7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="omkhpQA7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30EB11F00A3E;
	Mon, 31 Aug 2026 13:45:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183940;
	bh=+bsTals5aQzg276KW5Vi/a4LSVQxt/HnEKRZN92zOPQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=omkhpQA7dNOWnf62XfC9AoxtK3AEprXo6pELMNvT/GvC86LmH+m0ghajQVZOYsGQ/
	 tlEKQI4hKxDbKHCPDNE9LiHNOn5X9aUJnokcyRHyDXp3pzFqIW4VLMPXEPhCOdi16k
	 JQsEsgRaXSdWkfg0Tq1hiDPVEZ9zjPjU/y/BU5nIPawQDAEkHgVyGcs6NN5mtF1dNH
	 bXTjlZ1P/jWMpkH3/emQvtCf5z4KuW2brCR9yCk3+6xP7c9+yGFyB96/b7HJvyDsu7
	 Dhjqt111f/+jeU3XbyMCCgZUSa3qhmJgdj+QK7Yc3sGK3BChH/G/J8vpL6VQ2S3L7E
	 FVkXqtYKUxxxw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	davem@davemloft.net,
	edumazet@google.com,
	pabeni@redhat.com,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.12] ipv6: use READ_ONCE() for bindv6only default in inet6_create()
Date: Mon, 31 Aug 2026 09:27:01 -0400
Message-ID: <20260831133314.4125787-393-sashal@kernel.org>
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

From: Runyu Xiao <runyu.xiao@seu.edu.cn>

[ Upstream commit 7a20eb54224ab7481c1f5a1619a6a5677be93eed ]

inet6_create() reads net->ipv6.sysctl.bindv6only locklessly.

Use READ_ONCE() for this sysctl access.

Signed-off-by: Runyu Xiao <runyu.xiao@seu.edu.cn>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Link: https://patch.msgid.link/20260602002414.1504106-1-runyu.xiao@seu.edu.cn
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: PARSE THE SUBJECT LINE
**Record:** `[ipv6]` `[use]` — Add `READ_ONCE()` around the lockless
read of `net->ipv6.sysctl.bindv6only` in `inet6_create()`.

### Step 1.2: PARSE ALL COMMIT MESSAGE TAGS
**Record:**
- **Reviewed-by:** Ido Schimmel \<idosch@nvidia.com\> — subsystem
  reviewer endorsement
- **Link:** https://patch.msgid.link/20260602002414.1504106-1-
  runyu.xiao@seu.edu.cn — original v2 submission
- **Signed-off-by:** Runyu Xiao \<runyu.xiao@seu.edu.cn\> — author
- **Signed-off-by:** Jakub Kicinski \<kuba@kernel.org\> — networking
  maintainer merge
- **No Fixes:, Reported-by:, Cc: stable@, Tested-by:** in the committed
  message (v2 dropped Fixes/stable trailers per review; v1 had both)

**Notable:** v1 (lkml archive) included `Cc: stable@vger.kernel.org` and
a KCSAN stack trace; v2 shortened the message per maintainer feedback.

### Step 1.3: ANALYZE THE COMMIT BODY TEXT
**Record:**
- **Bug:** `inet6_create()` reads `net->ipv6.sysctl.bindv6only` without
  synchronization while the sysctl can be written concurrently via
  `proc_dou8vec_minmax()`.
- **Symptom:** KCSAN data-race report (`inet6_create` read vs
  `proc_dou8vec_minmax` write); v1 stress test toggled
  `/proc/sys/net/ipv6/bindv6only` while creating AF_INET6 sockets.
- **Root cause:** Missing `READ_ONCE()` on a lockless per-net sysctl
  reader; inconsistent with adjacent sysctl reads in the same function.
- **Version info:** v1 reproduced on Linux v6.18.21 with QEMU+KCSAN.

### Step 1.4: DETECT HIDDEN BUG FIXES
**Record:** Yes — presented as annotation/correctness, but it fixes a
real KCSAN-detected data race. Not cosmetic cleanup.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: INVENTORY THE CHANGES
**Record:**
- **Files:** `net/ipv6/af_inet6.c` only (+1/−1)
- **Function:** `inet6_create()`
- **Scope:** Single-file, single-line surgical fix

### Step 2.2: UNDERSTAND THE CODE FLOW CHANGE
**Record:**
- **Before:** `sk->sk_ipv6only = net->ipv6.sysctl.bindv6only;` — plain
  load during socket creation.
- **After:** `sk->sk_ipv6only = READ_ONCE(net->ipv6.sysctl.bindv6only);`
  — annotated atomic load.
- **Path:** Normal socket creation via `socket(PF_INET6, ...)` →
  `__sock_create()` → `inet6_create()`.

### Step 2.3: IDENTIFY THE BUG MECHANISM
**Record:** **Category:** Synchronization / data-race fix (KCSAN).
**Mechanism:** Concurrent unsynchronized read in `inet6_create()` vs
write through IPv6 sysctl handler; `READ_ONCE()` documents intentional
lockless access and prevents problematic compiler behavior.

### Step 2.4: ASSESS THE FIX QUALITY
**Record:** Obviously correct — matches
`READ_ONCE(net->core.sysctl_txrehash)` and
`READ_ONCE(net->ipv6.sysctl.flowlabel_reflect)` on adjacent lines.
Minimal regression risk.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: BLAME THE CHANGED LINES
**Record:** `bindv6only` assignment introduced in **9fe516ba3fb29b**
(Eric Dumazet, 2014, "inet: move ipv6only in sock_common").
`flowlabel_reflect` got `READ_ONCE()` in **7d4c7533b632c** (Jan 2026,
already in this tree); `bindv6only` on the next line was left unchanged.

### Step 3.2: FOLLOW THE FIXES: TAG
**Record:** No `Fixes:` tag in committed message. v1 referenced `Fixes:
9fe516ba3fb2` — that commit is in this tree and introduced the
`sk_ipv6only` assignment pattern.

### Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES
**Record:** **7d4c7533b632c** — same function, same sysctl-read pattern,
already backported to v6.18.44 (Signed-off-by: Sasha Levin). This commit
completes the same pattern for the adjacent `bindv6only` read.
Standalone one-liner, not part of a multi-patch series.

### Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS
**Record:** Runyu Xiao has other small networking correctness fixes in
history; not the subsystem maintainer, but patch was reviewed by Ido
Schimmel and merged by Jakub Kicinski.

### Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS
**Record:** No dependencies. Applies standalone. `READ_ONCE` and
`bindv6only` sysctl infrastructure exist in this tree.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION
**Record:** Commit not in local tree; `b4 dig -c` unavailable. v1 at
https://lkml.iu.edu/2605.3/12693.html; v2 at
https://lists.openwall.net/linux-kernel/2026/06/02/11. v2 dropped
Fixes/stable trailers per review. v1 included KCSAN stack trace and `Cc:
stable@vger.kernel.org`.

### Step 4.2: CHECK WHO REVIEWED THE PATCH
**Record:** v2 CC'd davem, kuba, pabeni, dsahern, idosch, edumazet,
horms, netdev@, linux-kernel@. Final commit has **Reviewed-by: Ido
Schimmel**.

### Step 4.3: SEARCH FOR THE BUG REPORT
**Record:** v1 documents KCSAN report with full stack
(`proc_dou8vec_minmax` write vs `inet6_create` read). Stress test: 75313
sysctl toggles + 360000+ socket creations in 45s on v6.18.21. No syzbot
report.

### Step 4.4: CHECK FOR RELATED PATCHES AND SERIES
**Record:** v1→v2 only; no multi-patch series. Related: Eric Dumazet's
sysctl `READ_ONCE` annotations, including **7d4c7533b632c** already in
this tree.

### Step 4.5: CHECK STABLE MAILING LIST HISTORY
**Record:** Not searched separately. v1 explicitly nominated stable; v2
dropped that trailer (message cleanup, not a technical rejection).

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF
**Record:** `inet6_create()` — only modified function.

### Step 5.2: TRACE CALLERS
**Record:** `inet6_create` registered as `.create` in `inet6_family_ops`
(line 743). Called from generic socket creation (`__sock_create()` →
family `create` hook). Every `socket(PF_INET6, ...)` hits this path —
common, userspace-reachable.

### Step 5.3: TRACE CALLEES
**Record:** Reads per-net sysctl, assigns to `sk->sk_ipv6only` (1-bit
bitfield in `sock_common`). `bindv6only` is `u8` in
`include/net/netns/ipv6.h`, written via `proc_dou8vec_minmax` in
`sysctl_net_ipv6.c`.

### Step 5.4: FOLLOW THE CALL CHAIN
**Record:** `socket()` syscall → `__sys_socket` → `__sock_create` →
`inet6_create`. Concurrent writer: `write()` to
`/proc/sys/net/ipv6/bindv6only` (mode 0644). Userspace-reachable on both
sides.

### Step 5.5: SEARCH FOR SIMILAR PATTERNS
**Record:** Same function already uses `READ_ONCE()` for
`flowlabel_reflect`, `txrehash`, and `sysctl_ip_no_pmtu_disc`. Many
other IPv6 sysctl reads use `READ_ONCE()` in this tree. **Note:**
`drivers/infiniband/core/cma.c:4041` still reads `bindv6only` without
`READ_ONCE()` — out of scope for this commit.

---

## PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE

### Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?
**Record:** **Yes.** Local tree is **v6.18.44** (`git describe HEAD`).
Line 229 of `net/ipv6/af_inet6.c` still has the plain read:

```227:230:net/ipv6/af_inet6.c
        inet6_assign_bit(REPFLOW, sk,
READ_ONCE(net->ipv6.sysctl.flowlabel_reflect) &
                                      FLOWLABEL_REFLECT_ESTABLISHED);
        sk->sk_ipv6only = net->ipv6.sysctl.bindv6only;
        sk->sk_txrehash = READ_ONCE(net->core.sysctl_txrehash);
```

Bug present since 2014 in this tree. Fix not yet applied.

### Step 6.2: CHECK FOR BACKPORT COMPLICATIONS
**Record:** Clean apply expected — one-line change, no surrounding
churn. Adjacent `READ_ONCE()` lines already present from
**7d4c7533b632c**.

### Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE
**Record:** **7d4c7533b632c** fixed `flowlabel_reflect` in the same
function but left `bindv6only` unfixed. No other fix for this specific
race in this tree.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY
**Record:** **Subsystem:** `net/ipv6` — core networking.
**Criticality:** CORE (every IPv6 socket creation).

### Step 7.2: ASSESS SUBSYSTEM ACTIVITY
**Record:** Active — recent sysctl data-race annotation commits
(`7d4c7533b632c`, route.c, exthdrs.c, icmp.c annotations) show ongoing
lockless-sysctl hygiene work, with several already backported to 6.18.y.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: DETERMINE WHO IS AFFECTED
**Record:** All users creating AF_INET6 sockets while `bindv6only`
sysctl is being modified. Universal for IPv6-enabled systems; trigger
requires concurrent sysctl write.

### Step 8.2: DETERMINE THE TRIGGER CONDITIONS
**Record:** Concurrent `socket(PF_INET6,...)` and write to
`/proc/sys/net/ipv6/bindv6only`. Uncommon in production (sysctl rarely
toggled), but reproducible under stress. Unprivileged users can trigger
the read path; sysctl write requires appropriate permissions.

### Step 8.3: DETERMINE THE FAILURE MODE SEVERITY
**Record:** KCSAN data-race warning; possible wrong `sk_ipv6only`
default affecting IPv4-mapped address behavior (`IPV6_V6ONLY`). Not a
crash/UAF/corruption. **Severity: MEDIUM** (KCSAN-detected race with
functional misbehavior potential, not a security/crash issue).

### Step 8.4: CALCULATE RISK-BENEFIT RATIO
**Record:**
- **Benefit:** MEDIUM — eliminates KCSAN race, aligns with established
  sysctl reader contract, completes incomplete fix next to already-
  backported `flowlabel_reflect` change.
- **Risk:** VERY LOW — one-line `READ_ONCE()`, identical to proven
  pattern.
- **Ratio:** Favorable for stable, especially given direct precedent in
  this tree.

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: COMPILE THE EVIDENCE

**FOR backport:**
- KCSAN-reproducible data race with documented stack trace (v1)
- One-line, obviously correct fix matching adjacent lines
- Buggy code present in v6.18.44 since 2014
- Same-class fix (`flowlabel_reflect`) already backported to this tree
  in same function
- Reviewed-by subsystem reviewer; merged by networking maintainer
- Common code path (`socket()` for PF_INET6)
- Applies cleanly

**AGAINST backport:**
- No crash, corruption, or security impact demonstrated
- Race window is narrow (sysctl rarely changed at runtime)
- `u8` sysctl — torn reads impractical on normal architectures
- v2 dropped explicit stable nomination (likely message policy, not
  technical rejection)
- Functional impact (wrong default `IPV6_V6ONLY`) is low severity

**Unresolved:** No maintainer reply explicitly rejecting stable backport
found; patch.msgid.link blocked by bot protection.

### Step 9.2: STABLE RULES CHECKLIST
1. Obviously correct and tested? **PASS** — matches established pattern;
   v1 reports build + KCSAN runtime testing.
2. Fixes a real bug? **PASS** — KCSAN data race, reproducible.
3. Important issue? **PASS (borderline)** — KCSAN data race in core
   socket path; functional misbehavior possible, not crash-level.
4. Small and contained? **PASS** — 1 line, 1 file.
5. No new features or APIs? **PASS**.
6. Can apply to local tree? **PASS** — buggy code confirmed present;
   clean apply.

### Step 9.3: EXCEPTION CATEGORIES
**Record:** Not a device-ID/quirk/DT/build/doc exception. Standard
correctness fix following established sysctl `READ_ONCE()` convention.

### Step 9.4: DECISION RATIONALE

For **Linux 6.18.44**, this should be backported. The incomplete fix in
**7d4c7533b632c** (already in this stable tree) added `READ_ONCE()` for
`flowlabel_reflect` on the line immediately above but missed
`bindv6only`. This commit closes that gap with the same one-line
pattern, at negligible risk. While user-visible impact is low (wrong
`IPV6_V6ONLY` default under a rare race), the KCSAN-detected data race
is real, the fix is trivial and proven, and this tree's maintainers have
already accepted the identical class of fix in the same function.

---

## Verification

- **[Phase 1]** Parsed subject, tags, body; fetched v1 from lkml.iu.edu
  for KCSAN details and v1 stable nomination.
- **[Phase 2]** Confirmed single-line diff in `inet6_create()`.
- **[Phase 3]** `git describe HEAD` → v6.18.44; `git blame` → bindv6only
  line from 9fe516ba3fb29b (2014); `git show 7d4c7533b632c` →
  flowlabel_reflect READ_ONCE already backported with Sasha Levin SOB.
- **[Phase 3]** `git log --grep='bindv6only default'` → commit not in
  tree; fix not yet applied.
- **[Phase 4]** b4 dig requires commit hash (unavailable); used
  lkml.iu.edu and openwall archive for v1/v2 content.
- **[Phase 4]** v1 KCSAN stack trace and stress-test numbers verified
  from lkml archive.
- **[Phase 5]** `grep inet6_create` → registered at af_inet6.c:743;
  `grep READ_ONCE(net->` in net/ipv6/ → widespread pattern.
- **[Phase 5]** Verified `skc_ipv6only` is 1-bit bitfield; `bindv6only`
  is u8 sysctl.
- **[Phase 6]** Read af_inet6.c:227-230 — buggy plain read confirmed
  present.
- **[Phase 6]** `git diff HEAD -- net/ipv6/af_inet6.c` → no local diff;
  fix absent.
- **[Phase 7]** `git log --grep='annotate data-race' -- net/ipv6/` →
  multiple similar fixes in tree.
- **[Phase 8]** Documented trigger (socket + sysctl write) and MEDIUM
  severity assessment.

**YES**The background searches finished and match the earlier analysis:

- **Task 841606:** `b4 dig` on the related `flowlabel_reflect` commit
  (`7d4c7533b632c`) found its lore thread. A grep for
  `READ_ONCE.*bindv6only` returned no matches in this tree.
- **Task 841607:** The `bindv6only` READ_ONCE commit is **not** in
  v6.18.44 — `git log --grep='bindv6only default'` found nothing, and
  `net/ipv6/af_inet6.c` still has the plain read on line 229.

**Verdict unchanged: YES** for backport to this 6.18.y tree — it’s a
one-line KCSAN data-race fix that completes the same pattern already
applied to the adjacent `flowlabel_reflect` read in `inet6_create()`.

 net/ipv6/af_inet6.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv6/af_inet6.c b/net/ipv6/af_inet6.c
index f8e1dc4f3227f..1c45e1d15506c 100644
--- a/net/ipv6/af_inet6.c
+++ b/net/ipv6/af_inet6.c
@@ -226,7 +226,7 @@ static int inet6_create(struct net *net, struct socket *sock, int protocol,
 	np->pmtudisc	= IPV6_PMTUDISC_WANT;
 	inet6_assign_bit(REPFLOW, sk, READ_ONCE(net->ipv6.sysctl.flowlabel_reflect) &
 				      FLOWLABEL_REFLECT_ESTABLISHED);
-	sk->sk_ipv6only	= net->ipv6.sysctl.bindv6only;
+	sk->sk_ipv6only	= READ_ONCE(net->ipv6.sysctl.bindv6only);
 	sk->sk_txrehash = READ_ONCE(net->core.sysctl_txrehash);
 
 	/* Init the ipv4 part of the socket since we can have sockets
-- 
2.53.0

