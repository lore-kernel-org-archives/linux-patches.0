Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2A4051DB03;
	Mon, 19 Oct 2026 13:57:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418274; cv=none; b=Fvo9feuSNJyGN1asAREFYLZpXDIDAAXegxbKcJWDNCYoe3pFADeM4itPf9xOtTBfUXDD6ztOHYqnw63AXPP7oapCxYJfKCLgMiDNH7RvtNcG1oQWzqF2ln6qdhGTvWA9JlauOMiNhcSqaTm8BudsD1//PlUERf4VuDvqV6mvte4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418274; c=relaxed/simple;
	bh=oipH0fkPpp6h9xLNpimbUPkFvsscbiMNxy0i7qVIpJU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Dni7sfZJMC4Nmx7MMp8/9lI8SuU/wBxVA6cuyMrUa4r2odDQAl4WoroH3M+9QfY65ME48PXlUGH5Z3DU7rg1GDbywRFgKIzkF2oNqhUNtiiI3d2SxVge/PB30QIi/kZ9ET4A1UghN2tsrnp5NedPc8Yguro/IFae+T8hUBA9jxw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CLPjSU4H; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CLPjSU4H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32AAC1F000C8;
	Mon, 19 Oct 2026 13:57:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418272;
	bh=O4hRn3SQYZZrHAsz7o5XGYnMoS2dA97NZLEhgQkHGkY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CLPjSU4H6G8N/SADFhc1hqKj2RvtF0qJlUBfrBqtiDakWuXZ05Bkeri/u+67xjG7R
	 peokyLtp3/znOhAnJLwvCMdIpkD0zB8zG4TLUPuFPJ5oF1Wudn7Upg1ochGbzkBVnZ
	 wcGVH71CCYSUj+t94P9zEskwqO/Mk8DQ/fTBk1l43ZCRCy5b7hwjvNpdGEJaG5Z3Kl
	 7tP59xI9spi3at4emhy6Q2ANKNgwUS1vMwqK5elg7UsMdu5HZPX3UD/KjY/CfO8UcZ
	 fD6AV5wKZ+B3x1ZzykfF3UZO/iaDKQqiqq5Ivr4fJML5+wDQtJjwDJfiN04TgMixJW
	 WpZK8MPLEkF2g==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Yuyang Huang <yuyanghuang@google.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	enachman@marvell.com,
	andrew+netdev@lunn.ch,
	davem@davemloft.net,
	edumazet@kernel.org,
	pabeni@redhat.com,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.1] net: prestera: ignore duplicate RIF destruction events
Date: Mon, 19 Oct 2026 09:47:01 -0400
Message-ID: <20261019135441.1420968-130-sashal@kernel.org>
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

From: Yuyang Huang <yuyanghuang@google.com>

[ Upstream commit 3cbbc9fa33382d03f2813118e672eb318eba9cde ]

During address teardown, the inetaddr notifier may be called multiple
times for the same interface. Ignore NETDEV_DOWN events if the RIF has
already been destroyed, rather than returning -EEXIST, which aborts the
notifier chain.

Cc: Ido Schimmel <idosch@nvidia.com>
Cc: Kuniyuki Iwashima <kuniyu@google.com>
Signed-off-by: Yuyang Huang <yuyanghuang@google.com>
Link: https://patch.msgid.link/20260711005405.2861680-2-yuyanghuang@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

I have enough to decide: this tree already has the IPv4 teardown change
that makes prestera abort the inetaddr chain, so the two-line companion
fix belongs here.

## Local tree

This checkout is **v7.3-rc4-27** (`7.3.0-rc4`, `VERSION=7 PATCHLEVEL=3
SUBLEVEL=0`). The candidate is `3cbbc9fa33382` (“net: prestera: ignore
duplicate RIF destruction events”), already an ancestor of HEAD (merged
for 7.3-rc1). The verdict is whether this tree’s code needs that fix on
technical merit, not whether a pipeline already picked it.

---

### PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1 — Subject**
Record: **[net: prestera]** **[ignore]** duplicate RIF destruction
events. “Ignore” here means treat a second destroy as success instead of
failing.

**Step 1.2 — Tags**
Record:
- `Cc: Ido Schimmel <idosch@nvidia.com>`
- `Cc: Kuniyuki Iwashima <kuniyu@google.com>`
- `Signed-off-by: Yuyang Huang <yuyanghuang@google.com>` (author)
- `Link: https://patch.msgid.link/20260711005405.2861680-2-
  yuyanghuang@google.com`
- `Signed-off-by: Jakub Kicinski <kuba@kernel.org>` (netdev maintainer)
- No `Fixes:`, no `Reported-by:`, no `Cc: stable` (expected for this
  review)
- Ignore any Sasha Levin SOB (none on the real commit)

Later trailers (mbox): `Acked-by: Elad Nachman <enachman@marvell.com>`
(Marvell prestera).

**Step 1.3 — Body**
Record: During address teardown the inetaddr notifier can run more than
once for the same interface. Returning `-EEXIST` when the RIF is already
gone **aborts the notifier chain**. Symptom: later `inetaddr` listeners
miss `NETDEV_DOWN`. Root cause: destroy is not idempotent.

**Step 1.4 — Hidden bug fix?**
Record: Not hidden. It is a real error-path fix: missing RIF on
`NETDEV_DOWN` was treated as a hard error.

---

### PHASE 2: DIFF ANALYSIS

**Step 2.1 — Inventory**
Record: `drivers/net/ethernet/marvell/prestera/prestera_router.c` — **+2
/ −4** (6 lines net). Function: `__prestera_inetaddr_port_event()`.
Surgical, single-file.

**Step 2.2 — Flow**
Before (`NETDEV_DOWN`, RIF already gone): set extack `"Can't find RIF"`,
return `-EEXIST`.
After: `if (!re) return 0;` then only destroy/put when the RIF still
exists.

**Step 2.3 — Bug category**
Record: **Logic / correctness** (idempotent teardown). Secondary:
**notifier-chain abort**. Not UAF/leak/lock.

Mechanism: `__prestera_inetaddr_cb` uses `notifier_from_errno(err)`.
Non-zero errno becomes `NOTIFY_STOP_MASK`, so
`blocking_notifier_call_chain()` stops. Confirmed in
`include/linux/notifier.h`.

**Step 2.4 — Fix quality**
Record: Obviously correct: destroy should be idempotent. No new
locks/APIs. Regression risk is low: a true “RIF missing on first DOWN”
is now silent success instead of `-EEXIST`. That matches mlxsw-style
handling Ido sketched on v1.

---

### PHASE 3: GIT HISTORY

**Step 3.1 — Blame**
Record: Buggy `-EEXIST` on missing RIF came from `15fa9e8c5ffbe0`
(“Implement initial inetaddr notifiers”, 2021-12-27) / `32d098bb2e494c`
(refactor, 2022-01-11). Prestera router dates to `da3c16398602a` /
`69204174cc5cb` (~v5.17). Long-lived driver code.

**Step 3.2 — Fixes: tag**
Record: None. Trigger is **not** that old RIF code alone; it is
companion series patch 3:

`aa22336b76b73` — `net: ipv4: clear dev->ip_ptr before destroying
inetdev`

That commit **is in this tree** (`git merge-base --is-ancestor`
succeeded). It moves `RCU_INIT_POINTER(dev->ip_ptr, NULL)` **before**
the `ifa_list` teardown loop in `inetdev_destroy()`.

**Step 3.3 — File history**
Record: Recent prestera_router.c churn is unrelated (kmalloc_obj, IPv4
nhid, NULL vs IS_ERR). Standalone vs the series: this is **patch 1/3**,
ordered so drivers are fixed **before** the core IPv4 change for
bisectability.

**Step 3.4 — Author**
Record: Yuyang Huang (Google); two commits in this series. Not the
prestera maintainer. Elad Nachman (Marvell) acked patch 1. Ido Schimmel
**wrote the exact diff** in v1 review.

**Step 3.5 — Dependencies**
Record: Applies standalone on the 2022 RIF code. **Semantically
required** once `aa22336b76b73` is present. Patch 2 (`e5b14e9ae82b`,
mac80211) is a sibling, not a prereq for prestera.

Without patch 3, `__prestera_inetaddr_cb` still uses
`__in_dev_get_rtnl(dev)` and skips unless `ifa_list` is empty, so
duplicate destroy on inetdev teardown does not happen. **This tree has
patch 3**, so the duplicate path is live.

---

### PHASE 4: MAILING LIST

**Step 4.1 — Original thread**
Record: `b4 dig -c 3cbbc9fa33382` →
https://patch.msgid.link/20260711005405.2861680-2-yuyanghuang@google.com
v1: single net-next patch only moving `ip_ptr` clear.
v2: `[PATCH net-next v2 0/3] align IPv4 teardown with IPv6 and fix
driver regressions`.

Ido (v1): sashiko was right; prestera must ignore missing-RIF
`NETDEV_DOWN`; he pasted this exact hunk; mlxsw already OK; audit other
listeners.

Cover letter: clearing `ip_ptr` early makes `__in_dev_get_rtnl()` NULL
in the destroy loop → prestera/mac80211 regressions. Drivers first, then
core, for bisectability.

No NAKs. Applied to net-next by Kicinski (2026-07-21). Elad Acked-by
after merge.

**Step 4.2 — Recipients (`b4 dig -w`)**
Record: davem, kuba, pabeni, dsahern, horms, edumazet, Ido, Elad
Nachman, Johannes Berg, netdev, linux-wireless. Right lists/maintainers.

**Step 4.3 — Bug report**
Record: No syzbot/bugzilla. Found in review of the IPv4 teardown change.

**Step 4.4 — Series**
1. This prestera fix
2. mac80211: use `ifa->ifa_dev`
3. IPv4 `ip_ptr` clear

All three are in this tree.

**Step 4.5 — stable@**
Record: lore.kernel.org returned 403 via HTTP; `b4` did get the netdev
thread. No `Cc: stable` in the series (sent to **net-next**, not
**net**). No evidence it was rejected for stable.

---

### PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1 — Functions**
Record: `__prestera_inetaddr_port_event()` only.

**Step 5.2 — Callers**
`__prestera_inetaddr_event()` → `__prestera_inetaddr_cb` (`NETDEV_DOWN`,
last-address intent) and `__prestera_inetaddr_valid_cb` (`NETDEV_UP`
only). Registered via `register_inetaddr_notifier()` in
`prestera_router_init()`.

**Step 5.3 — Callees**
`prestera_rif_entry_find/create/destroy`, `dev_hold`/`dev_put`.

**Step 5.4 — Reachability**
Yes, from normal IPv4 teardown: `inetdev_destroy()` (`NETDEV_UNREGISTER`
or invalid MTU) → `inet_del_ifa()` → `inetaddr_chain` `NETDEV_DOWN`.

After patch 3, `__in_dev_get_rtnl(dev)` is NULL, so the “not last
address” skip is false and **every** remaining address generates a
destroy attempt. First succeeds; later ones hit missing RIF.

`inetaddr_chain` also includes `fib_inetaddr_event`, SCTP, nf_nat
masquerade, nfsd, lockd, mac80211, RDMA GID, ipvlan, etc. Default
notifier priority 0: boot-time FIB typically runs before prestera;
later-registered listeners after prestera **do not run** if prestera
returns `-EEXIST`.

**Step 5.5 — Similar patterns**
mlxsw already treats missing RIF as “no config”
(`mlxsw_sp_rif_should_config`). Ido: “mlxsw is OK.” No remaining `"Can't
find RIF"` in prestera.

---

### PHASE 6: THIS TREE

**Step 6.1 — Buggy code**
The pre-fix `return -EEXIST` is in `3cbbc9fa33382^`. Trigger
`aa22336b76b73` is in HEAD. Without this patch, 7.3-rc4 prestera would
abort the chain. Current HEAD already has the idempotent `return 0`.

**Step 6.2 — Backport difficulty**
Clean: same function shape since 2022. This tree already contains the
result.

**Step 6.3 — Other fixes**
No earlier equivalent. This is the fix.

---

### PHASE 7: SUBSYSTEM CONTEXT

**Step 7.1**
Record: Marvell Prestera switchdev Ethernet (`CONFIG_PRESTERA`).
**PERIPHERAL** hardware, but the failure is on the **global inetaddr
chain** (IMPORTANT impact surface).

**Step 7.2**
Record: Mature driver (v5.17+). This change is a companion to 7.3 IPv4
teardown, not random refactor.

---

### PHASE 8: IMPACT AND RISK

**Step 8.1 — Who**
Prestera switch users with IPv4 on ports, especially **multiple
addresses**, during unregister / inetdev destroy. Other `inetaddr`
listeners on those events.

**Step 8.2 — Trigger**
`inetdev_destroy()` after `ip_ptr` is cleared, more than one IPv4
address. Unprivileged users typically cannot unload the switch; admin
teardown/unregister can. Not a race; deterministic.

**Step 8.3 — Failure mode**
Not an oops/UAF. `-EEXIST` → notifier stop → later listeners miss
`NETDEV_DOWN` (SCTP local addrs, nfsd/lockd, RDMA GIDs, etc.).
`inet_del_ifa()` ignores the chain return, so teardown continues, but
**sidecar state can go stale**. Severity: **HIGH** for correctness of
address teardown, not CRITICAL crash.

**Step 8.4 — Risk/benefit**
Benefit: high for this tree (trigger commit is present). Risk: very low
(2 lines, maintainer-supplied, Acked). Ratio: strongly in favor.

---

### PHASE 9: SYNTHESIS

**For backporting**
- Real bug once `aa22336b76b73` is present (this tree).
- Aborts `inetaddr_chain`; not cosmetic.
- 2-line, obviously correct, Ido-authored hunk, Elad ack, Kicinski
  merge.
- Applies cleanly; no new API.
- Patch 2 is not required for this file.

**Against**
- Niche `CONFIG_PRESTERA`.
- net-next companion, not a crash/CVE.
- No production `Reported-by`.
- Independent value is weak **without** the IPv4 `ip_ptr` move — but
  that move **is here**.

**Unresolved**
- HTTP 403 on lore/stable search; thread recovered via `b4`. No sign of
  a stable NAK.

**Stable rules**
1. Obviously correct and tested? **PASS** (Ido diff + Elad ack + net-
   next)
2. Real user-visible bug? **PASS** (notifier abort on port teardown)
3. Important? **PASS** (broken global `NETDEV_DOWN` delivery; not a
   panic)
4. Small/contained? **PASS** (+2/−4, one function)
5. No new features/APIs? **PASS**
6. Applies to this tree? **PASS** (same code; trigger present)

Exception category: none (not an ID/quirk/DT/build/doc add). Still a
contained correctness fix.

This tree is 7.3-rc4 **with** the IPv4 teardown change. Without this
patch, prestera turns duplicate RIF destroy into `-EEXIST` and stops the
inetaddr chain. The fix is minimal and already reviewed. It should be in
this tree.

Verification:
- [Phase 1] Tags: Cc Ido/Kuniyuki, Link msgid `...2861680-2`, SOB Huang
  + Kicinski; no Fixes/syzbot
- [Phase 2] Diff: `NETDEV_DOWN` `!re` path `-EEXIST` → `return 0` in
  `__prestera_inetaddr_port_event`
- [Phase 3] Blame: RIF notifier from `15fa9e8c5ffbe0` / `32d098bb2e494c`
  (~v5.17)
- [Phase 3] `git merge-base --is-ancestor aa22336b76b73 HEAD` → trigger
  **in tree**; same for `e5b14e9ae82b` and `3cbbc9fa33382`
- [Phase 3] `git describe HEAD` → `v7.3-rc4-27-gf0100363d8c37`; `make
  kernelversion` → `7.3.0-rc4`
- [Phase 3] `git show aa22336b76b73`: `ip_ptr` cleared **before** `ifa`
  loop
- [Phase 4] `b4 dig -c 3cbbc9fa33382`: v2 1/3 net-next; v1 was core-only
- [Phase 4] Ido v1: exact prestera hunk; Elad Acked-by
- [Phase 4] lore HTTP 403; mbox via b4 succeeded
- [Phase 5] Callers: `__prestera_inetaddr_cb` → `notifier_from_errno`;
  chain includes fib, sctp, nfsd, rdma, mac80211
- [Phase 5] `notifier_from_errno` sets `NOTIFY_STOP_MASK` on any errno
- [Phase 6] Pre-image at `3cbbc9fa33382^` still has `-EEXIST`; HEAD has
  `return 0`
- [Phase 8] Failure: notifier abort, not oops; trigger = inetdev_destroy
  + multiple IPv4 addrs after `ip_ptr` clear
- UNVERIFIED: whether anyone asked for this on stable@ (lore 403)

**YES**

 drivers/net/ethernet/marvell/prestera/prestera_router.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/marvell/prestera/prestera_router.c b/drivers/net/ethernet/marvell/prestera/prestera_router.c
index de317179a7dcc..e36d023fe9c30 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_router.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_router.c
@@ -1302,10 +1302,8 @@ static int __prestera_inetaddr_port_event(struct net_device *port_dev,
 		dev_hold(port_dev);
 		break;
 	case NETDEV_DOWN:
-		if (!re) {
-			NL_SET_ERR_MSG_MOD(extack, "Can't find RIF");
-			return -EEXIST;
-		}
+		if (!re)
+			return 0;
 		prestera_rif_entry_destroy(port->sw, re);
 		dev_put(port_dev);
 		break;
-- 
2.53.0

