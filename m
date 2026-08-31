Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8117439F83;
	Mon, 31 Aug 2026 13:33:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183219; cv=none; b=utmCBGYyuYe9g3lpiqBRwdT/BDq/L8GCFUJJaQXz+Ry/IjuKVUzf6ObHid90A8f1+UWEEXJCfljldeBoRUcmNJVoLrtCK7S8CA1zCp3dLe6dZv55U88QrxENohWA0D1DmYKJ0Q4Cq94qnIwvoGGo14yPMrBABPcorpMYYmGi8mA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183219; c=relaxed/simple;
	bh=AM8PKwI9A0Nx7pJTy2BhPnlvxqcGOVjc0qnmTKZ8RgI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eOaaH32ZRcduN90cAcuHaXLMzTonwAONve8ksWpoIm1hJkFnTcbEuVK3ox6xZG34vkF7f4HEkrz84LTkuUqviAwGSDHyAIIG5UJL/fCbY48HoE/VW0zEVQFSkt9WaCTVW4F5IgNJsa7QmAnfJqhwjC3s/ZtNh5i9ZspWiYxkH5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WUy5UOY3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WUy5UOY3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5773A1F000E9;
	Mon, 31 Aug 2026 13:33:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183217;
	bh=s2WzExxrbNaGa4Q4CVRnZE3JXWCu0m9Sj1QCKWehbB8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WUy5UOY3h+1/ZdSD2JYEOQ5E3GnsevExIG3tmXuYYea5nUUnJc4RQZ+medCKI+hxB
	 Fy4vj94zf1vZMJu0Sy/ZoYf7VsC4GVQ1YWi3lYMgfuoW7EK4zqC2WM1HoVV/S4zpiC
	 EuCtOYW+D7EEj6QA5gDmzlcvpni4PSI77TMdkND2qRRioWhJ+Yn7q9FnOciJ/tY99a
	 kHuVNY672ZkLjB1n5r1wM8kZeiN32D09FIhQoCuzJO8ThVhDnPnGIU2sYc6xaB4TTK
	 pv760pg6+fa8U9UOV86zPyugvf9oIOTNwNv/54pC6egDJHdcLozz6xA+2RgmsMWNaT
	 CEBA0m4DPCMTA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Ido Schimmel <idosch@nvidia.com>,
	Nikolay Aleksandrov <nikolay@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	razor@blackwall.org,
	davem@davemloft.net,
	edumazet@google.com,
	pabeni@redhat.com,
	bridge@lists.linux.dev,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.6] bridge: Add missing READ_ONCE() annotations around FDB destination port
Date: Mon, 31 Aug 2026 09:20:43 -0400
Message-ID: <20260831133314.4125787-15-sashal@kernel.org>
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

From: Ido Schimmel <idosch@nvidia.com>

[ Upstream commit bcdfd9fb109e0c9d76c345b2346b6b75ed1f476d ]

When roaming, the FDB destination port can change without holding the
bridge's hash lock. Therefore, add missing READ_ONCE() annotations in
both RCU readers and readers that hold the lock. In the latter case, the
annotation is not needed in places where the FDB entry was already
validated to be a local entry since such entries cannot roam.

Acked-by: Nikolay Aleksandrov <nikolay@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Link: https://patch.msgid.link/20260517115009.175163-1-idosch@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: `bridge: Add missing READ_ONCE() annotations
around FDB destination port`

**Local tree:** `v6.18.44` (Makefile: 6.18.44)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1 — Subject line**

Record: `[bridge]` `[add]` missing `READ_ONCE()` annotations around FDB
destination port during concurrent roaming updates.

**Step 1.2 — Tags**

Record:
- `Acked-by: Nikolay Aleksandrov <nikolay@nvidia.com>` — bridge
  maintainer ack
- `Signed-off-by: Ido Schimmel <idosch@nvidia.com>` — bridge
  maintainer/author
- `Signed-off-by: Jakub Kicinski <kuba@kernel.org>` — networking tree
  maintainer
- `Link:
  https://patch.msgid.link/20260517115009.175163-1-idosch@nvidia.com`
- No `Fixes:`, `Reported-by:`, `Cc: stable@vger.kernel.org`, `Tested-
  by:`, or syzbot tags

**Step 1.3 — Body analysis**

Record:
- **Bug:** `fdb->dst` can change during MAC roaming without holding
  `br->hash_lock`.
- **Symptom:** Readers can observe a changing destination port; without
  `READ_ONCE()`, loads are not paired with existing `WRITE_ONCE()`
  writers and may be inconsistent across a read/use sequence.
- **Root cause:** `br_fdb_update()` updates `fdb->dst` locklessly on the
  fast path (`WRITE_ONCE(fdb->dst, source)` at line 1030 in `br_fdb.c`),
  while several readers still used plain `f->dst` / `dst->dst` loads.
- **Version info:** None in the message.

**Step 1.4 — Hidden bug fix?**

Record: **Yes.** Although labeled as annotation work, this is a real
concurrency correctness fix in the bridge forwarding and FDB management
paths, completing an established `READ_ONCE`/`WRITE_ONCE` pattern for
`fdb->dst`.

---

## PHASE 2: DIFF ANALYSIS

**Step 2.1 — Inventory**

Record:
- `net/bridge/br_device.c`: 1 line changed (`br_dev_xmit`)
- `net/bridge/br_input.c`: 1 line changed (`br_handle_frame_finish`)
- `net/bridge/br_fdb.c`: 4 lines changed across 3 functions
- **Total:** ~6 functional lines, 3 files, surgical scope
- **Functions modified:** `br_dev_xmit`, `br_handle_frame_finish`,
  `br_fdb_changeaddr`, `br_fdb_delete_by_port`, `br_fdb_clear_offload`

**Step 2.2 — Code flow changes**

Record:
| Location | Before | After |
|---|---|---|
| `br_dev_xmit` | `br_forward(dst->dst, ...)` after RCU FDB lookup |
`br_forward(READ_ONCE(dst->dst), ...)` — single stable snapshot of
roaming port |
| `br_handle_frame_finish` | same pattern on receive/forward path | same
fix |
| `br_fdb_changeaddr` | `f->dst == p` under `hash_lock` |
`READ_ONCE(f->dst) == p` |
| `br_fdb_delete_by_port` | `f->dst != p` under `hash_lock` |
`READ_ONCE(f->dst) != p` |
| `br_fdb_clear_offload` | `f->dst == p` under `hash_lock` |
`READ_ONCE(f->dst) == p` |

**Step 2.3 — Bug mechanism**

Record: **Race condition / data-race correctness fix.** Category (b)
synchronization. `br_fdb_update()` changes `fdb->dst` without
`hash_lock`:

```1026:1031:net/bridge/br_fdb.c
                        /* fastpath: update of existing entry */
                        if (unlikely(source != READ_ONCE(fdb->dst) &&
                                     !test_bit(BR_FDB_STICKY,
&fdb->flags))) {
                                br_switchdev_fdb_notify(br, fdb,
RTM_DELNEIGH);
                                WRITE_ONCE(fdb->dst, source);
```

Readers on hot forwarding paths and FDB iterators could observe a
changing `dst` pointer. `br_forward()` handles `NULL` (`if
(unlikely(!to))`), but a stale non-NULL port causes mis-forwarding
during roam; FDB iterators can miss or mishandle entries during
concurrent updates.

**Step 2.4 — Fix quality**

Record: **High quality, minimal, obviously correct.** Matches the
existing subsystem convention from `3e19ae7c6fd62` and follow-up
`5424e678f9b30`. Regression risk is very low — only adds documented
single-load snapshots.

---

## PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1 — Blame**

Record:
- `br_device.c:110` and `br_input.c:226`: original code from 2016
  (Nikolay Aleksandrov), predating `READ_ONCE` annotations
- `br_fdb.c:473`: from 2019, also predating full annotation coverage
- Buggy plain loads have been present since before `3e19ae7c6fd62`
  (2021)

**Step 3.2 — Fixes: tag**

Record: Not applicable — no `Fixes:` tag.

**Step 3.3 — Related file history**

Record:
- `3e19ae7c6fd62` — introduced `READ_ONCE`/`WRITE_ONCE` for `fdb->dst`
  broadly (in tree)
- `5424e678f9b30` — “use a stable FDB dst snapshot in RCU readers”;
  fixed `br_fdb_fillbuf`, `fdb_delete_local` writers, etc.; `Cc:
  stable@vger.kernel.org` (in tree)
- `17071fb5cb9c2` — annotated `fdb->{updated,used}` races (in tree)
- This commit fills remaining gaps after those fixes
- **Standalone:** yes, no series dependency

**Step 3.4 — Author context**

Record: Ido Schimmel is an active bridge maintainer (`Reviewed-by` on
related stable-bound fix `5424e678`). Nikolay Aleksandrov acked.

**Step 3.5 — Prerequisites**

Record:
- Requires `WRITE_ONCE(fdb->dst, ...)` writers — present since
  `3e19ae7c6fd62`
- Requires roaming fast path in `br_fdb_update()` — present
- No additional commits required; patch dry-run applies cleanly

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

**Step 4.1 — Original discussion**

Record: **UNVERIFIED** — `b4 dig -c <commit>` could not be run (commit
not present locally); lore.kernel.org and patch.msgid.link blocked by
bot protection (Anubis).

**Step 4.2 — Reviewers**

Record: **UNVERIFIED** via `b4 dig -w`. Commit message shows maintainer
ack from Nikolay Aleksandrov and merge by Jakub Kicinski.

**Step 4.3 — Bug report**

Record: Not applicable — no `Reported-by:` or syzbot link.

**Step 4.4 — Related patches**

Record: Part of ongoing `fdb->dst` concurrency hardening; directly
complements in-tree `5424e678f9b30`.

**Step 4.5 — Stable list history**

Record: **UNVERIFIED** — lore stable search inaccessible.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1 — Key functions**

Record: `br_dev_xmit`, `br_handle_frame_finish`, `br_fdb_changeaddr`,
`br_fdb_delete_by_port`, `br_fdb_clear_offload`

**Step 5.2 — Callers / reachability**

Record:
- `br_dev_xmit` — bridge device transmit hot path (every locally
  originated unicast frame)
- `br_handle_frame_finish` — bridge receive/forward hot path (every
  forwarded unicast frame)
- `br_fdb_delete_by_port` — port removal/teardown
- `br_fdb_changeaddr` — MAC address change on port
- `br_fdb_clear_offload` — switchdev offload cleanup

All are reachable in normal bridge operation; forwarding paths are among
the hottest networking code paths.

**Step 5.3 — Callees**

Record: `br_forward()` dereferences port and forwards skb;
`br_fdb_find_rcu()` provides RCU-protected FDB entry; concurrent writer
is `br_fdb_update()`.

**Step 5.4 — User triggerability**

Record: **Yes.** Any bridge with learned MACs that roam between ports
triggers `br_fdb_update()` lockless `fdb->dst` changes while packets are
being forwarded.

**Step 5.5 — Similar patterns**

Record: Most other `fdb->dst` readers in this tree already use
`READ_ONCE()` — e.g. `br_fdb_fillbuf`, `br_fdb_test_addr`,
`br_switchdev_fdb_notify`, `br_arp_nd_proxy.c`. The patched sites are
the remaining outliers.

---

## PHASE 6: CROSS-REFERENCE AGAINST LOCAL TREE (v6.18.44)

**Step 6.1 — Buggy code present?**

Record: **Yes.** Verified missing annotations at:
- `br_device.c:110`: `br_forward(dst->dst, ...)`
- `br_input.c:226`: `br_forward(dst->dst, ...)`
- `br_fdb.c:473`, `881`, `1663`: plain `f->dst` comparisons

Roaming writer path is present (`br_fdb.c:1030`).

**Step 6.2 — Backport difficulty**

Record: **Clean apply** — `patch --dry-run` succeeded with no conflicts.

**Step 6.3 — Related fixes already present?**

Record: Partial fix `5424e678f9b30` is already in this tree; this commit
is the remaining coverage, not a duplicate.

---

## PHASE 7: SUBSYSTEM CONTEXT

**Step 7.1 — Subsystem / criticality**

Record: `net/bridge` — **IMPORTANT** (widely deployed in servers, VMs,
containers, embedded networking).

**Step 7.2 — Activity**

Record: Actively maintained; recent stable-relevant bridge fixes in this
tree (UAF, sleep-in-atomic, FDB snapshot).

---

## PHASE 8: IMPACT AND RISK

**Step 8.1 — Who is affected**

Record: All systems using Linux bridge forwarding with dynamic FDB
learning and MAC roaming.

**Step 8.2 — Trigger conditions**

Record: Host moves between bridge ports; concurrent forwarding while
`br_fdb_update()` roams `fdb->dst`. Common in Wi-Fi/Ethernet mobility,
VM migration, and active L2 networks.

**Step 8.3 — Failure mode / severity**

Record:
- **Forwarding paths:** packet delivered to wrong port (connectivity bug
  / potential traffic leakage) — **MEDIUM-HIGH**
- **FDB management paths:** missed or incorrect entry handling during
  concurrent roam — **MEDIUM**
- **Kernel crash:** unlikely on these specific hunks (`br_forward()`
  handles `NULL`); sibling fix `5424e678` addressed a confirmed NULL-
  deref in sysfs path
- **KCSAN/data-race:** definite without fix — **MEDIUM** for
  CI/sanitizer builds

**Step 8.4 — Risk/benefit**

Record:
- **Benefit:** HIGH for bridge users with roaming; completes an already-
  stable-nominated fix family
- **Risk:** VERY LOW — 6-line annotation-only change matching
  established pattern
- **Ratio:** strongly favors backport

---

## PHASE 9: FINAL SYNTHESIS

**Step 9.1 — Evidence summary**

**FOR:**
- Real concurrency bug in hot forwarding path
- Small, surgical, maintainer-acked
- Prerequisites and related stable fix already in v6.18.44
- Applies cleanly
- Follows established subsystem convention since 2021
- Complements already-backported `5424e678f9b30`

**AGAINST:**
- No syzbot/crash report for these exact sites
- Primary user impact is mis-forwarding rather than panic
- Mailing list/stable discussion not verified

**UNRESOLVED:**
- Full lore review thread content
- Whether reviewers explicitly nominated for stable

**Step 9.2 — Stable rules checklist**

| Criterion | Result |
|---|---|
| 1. Obviously correct and tested? | **PASS** — pattern proven in-tree;
maintainer ack |
| 2. Fixes a real user-affecting bug? | **PASS** — roaming race in
forwarding/FDB paths |
| 3. Important issue? | **PASS** — forwarding correctness on common
bridge deployments |
| 4. Small and contained? | **PASS** — 6 lines, 3 files |
| 5. No new features/APIs? | **PASS** — annotation only |
| 6. Can apply to local tree? | **PASS** — clean dry-run apply; code and
writers present |

**Step 9.3 — Exception category**

Record: Not a device-ID/quirk/DT/build/doc exception; qualifies as a
standard concurrency correctness bug fix.

**Step 9.4 — Problem statement for stable users**

When a MAC address roams between bridge ports, `fdb->dst` is updated
locklessly. The remaining unannotated readers in transmit/receive
forwarding and FDB cleanup paths can observe a changing destination
port, causing frames to be forwarded to the wrong port or FDB
maintenance to behave incorrectly. This patch completes the
`READ_ONCE`/`WRITE_ONCE` pairing already used throughout the rest of the
bridge FDB code and in the recently backported `5424e678` fix.

---

## Verification

- [Phase 1] Parsed commit message and tags from user-provided diff
- [Phase 2] Diff analysis: 6 lines across `br_device.c`, `br_input.c`,
  `br_fdb.c`
- [Phase 3] `git describe HEAD` → `v6.18.44`
- [Phase 3] `git blame` on lines 110/226/473 → pre-2021 code missing
  annotations
- [Phase 3] `git show 3e19ae7c6fd62` → original `READ_ONCE`/`WRITE_ONCE`
  introduction
- [Phase 3] `git show 5424e678f9b30` → related stable-nominated FDB dst
  snapshot fix, already in tree
- [Phase 3] `git merge-base --is-ancestor` → both `3e19ae7` and
  `5424e678` are ancestors of HEAD
- [Phase 4] **UNVERIFIED:** lore.kernel.org and patch.msgid.link
  blocked; `b4 dig` not usable without local commit hash
- [Phase 5] `grep READ_ONCE.*dst` → most readers annotated; patched
  sites are outliers
- [Phase 5] Read `br_fdb_update()` → confirmed lockless
  `WRITE_ONCE(fdb->dst, source)` roaming path
- [Phase 5] Read `br_forward()` → confirmed `NULL` port handled safely
- [Phase 6] Read current sources → buggy plain loads confirmed present
- [Phase 6] `patch --dry-run` → applies cleanly
- [Phase 8] Assessed failure mode as mis-forwarding during roam, not
  typical kernel oops

**YES**

 net/bridge/br_device.c | 2 +-
 net/bridge/br_fdb.c    | 7 ++++---
 net/bridge/br_input.c  | 2 +-
 3 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/net/bridge/br_device.c b/net/bridge/br_device.c
index 525d4eccd194a..966fac7017225 100644
--- a/net/bridge/br_device.c
+++ b/net/bridge/br_device.c
@@ -107,7 +107,7 @@ netdev_tx_t br_dev_xmit(struct sk_buff *skb, struct net_device *dev)
 		else
 			br_flood(br, skb, BR_PKT_MULTICAST, false, true, vid);
 	} else if ((dst = br_fdb_find_rcu(br, dest, vid)) != NULL) {
-		br_forward(dst->dst, skb, false, true);
+		br_forward(READ_ONCE(dst->dst), skb, false, true);
 	} else {
 		br_flood(br, skb, BR_PKT_UNICAST, false, true, vid);
 	}
diff --git a/net/bridge/br_fdb.c b/net/bridge/br_fdb.c
index 6eb3ab69a5140..fe85c8f197e67 100644
--- a/net/bridge/br_fdb.c
+++ b/net/bridge/br_fdb.c
@@ -470,7 +470,8 @@ void br_fdb_changeaddr(struct net_bridge_port *p, const unsigned char *newaddr)
 	spin_lock_bh(&br->hash_lock);
 	vg = nbp_vlan_group(p);
 	hlist_for_each_entry(f, &br->fdb_list, fdb_node) {
-		if (f->dst == p && test_bit(BR_FDB_LOCAL, &f->flags) &&
+		if (READ_ONCE(f->dst) == p &&
+		    test_bit(BR_FDB_LOCAL, &f->flags) &&
 		    !test_bit(BR_FDB_ADDED_BY_USER, &f->flags)) {
 			/* delete old one */
 			fdb_delete_local(br, p, f);
@@ -878,7 +879,7 @@ void br_fdb_delete_by_port(struct net_bridge *br,
 
 	spin_lock_bh(&br->hash_lock);
 	hlist_for_each_entry_safe(f, tmp, &br->fdb_list, fdb_node) {
-		if (f->dst != p)
+		if (READ_ONCE(f->dst) != p)
 			continue;
 
 		if (!do_all)
@@ -1660,7 +1661,7 @@ void br_fdb_clear_offload(const struct net_device *dev, u16 vid)
 
 	spin_lock_bh(&p->br->hash_lock);
 	hlist_for_each_entry(f, &p->br->fdb_list, fdb_node) {
-		if (f->dst == p && f->key.vlan_id == vid)
+		if (READ_ONCE(f->dst) == p && f->key.vlan_id == vid)
 			clear_bit(BR_FDB_OFFLOADED, &f->flags);
 	}
 	spin_unlock_bh(&p->br->hash_lock);
diff --git a/net/bridge/br_input.c b/net/bridge/br_input.c
index 2cbae0f9ae1f0..470615675bdc0 100644
--- a/net/bridge/br_input.c
+++ b/net/bridge/br_input.c
@@ -223,7 +223,7 @@ int br_handle_frame_finish(struct net *net, struct sock *sk, struct sk_buff *skb
 
 		if (now != READ_ONCE(dst->used))
 			WRITE_ONCE(dst->used, now);
-		br_forward(dst->dst, skb, local_rcv, false);
+		br_forward(READ_ONCE(dst->dst), skb, local_rcv, false);
 	} else {
 		if (!mcast_hit)
 			br_flood(br, skb, pkt_type, local_rcv, false, vid);
-- 
2.53.0

