Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 866675AA67A;
	Mon, 31 Aug 2026 13:52:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184360; cv=none; b=oVLawjQNIsds4iTV866+idILWJWBkV/j1FiGhG5ZgnFL9s0UKbADcqBK4hyo3+kQ4LWmiwcj8d2iX78Y/kR4r7hDqyh+A+hYadbeIFr39kB4K8IcQpjp3IztMPK0Sg/YVMtuIWwNAB5POtzLXZiUNCyoHJ3mYADC6diDChQXJWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184360; c=relaxed/simple;
	bh=AFn9bC8Os6jWC3HSEWWWBcrgHp1xBy6uB2ZFyqpjx4U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VTjNvw4zeqSg495eBOGiwtThJt4fjOXZkS3OaJv8A0rfNSUXvE2XH8S6OU0Z2mwyT73HB+QqAgyPfdHdXvavzDWDO/ta8WQ3b7H7mBwJEqbLF3tRsu8LMJZPIXRuKLu2Q4sAA3Y7/1vs1Cvod1J3kVPAjfjfb5GqYXNhl1GO5FA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CkzC6SuG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CkzC6SuG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A3BC1F00A3E;
	Mon, 31 Aug 2026 13:52:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788184358;
	bh=wraiAU+Zeuec8evtgO3PwiEKpvLKzU7dNuEP1ckW7fY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CkzC6SuGI967Y7XT786LCzhxur0MXjgRf05WRW7z+6i6j0AFyZJKHTkgGxPPmBB1o
	 6xB2UoWxx+UDu02B1QwFyBoPz9ycNV0STPVfsfHbnxbYoFCfDMaaikDa9XcMrtpXXY
	 gBVV6OH5AhFIaUPUW2gsl0CdoV8H7SvJ/VhF2x9L9citgIaDnmZJavPdGalfkKXHb5
	 CZF/Atzvpcy89dgmPITtFNSEATxrdldeWP0SGwNx/4mi6yIb/E/2IWzsWfeY0zMi/S
	 vLHPRCe4o94PKFRK+goOJoFYsokPpjRFweqDSNXVOJXxLTU3KV3Yx59bBN8MUG6Por
	 TsMqLHALCdP6g==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>,
	andreas.noever@gmail.com,
	westeri@kernel.org,
	YehezkelShB@gmail.com,
	linux-usb@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] thunderbolt: Keep the domain reference while processing hotplug
Date: Mon, 31 Aug 2026 09:31:14 -0400
Message-ID: <20260831133314.4125787-646-sashal@kernel.org>
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

From: Mika Westerberg <mika.westerberg@linux.intel.com>

[ Upstream commit 138ec65b2c761f065b19d115aed2b8246fc272f5 ]

We process hotplug events in a workqueue that may run after the domain
has been removed by tb_domain_remove(). For example if user unloads the
driver while at the same time plugging  a device router we may have
scheduled tb_handle_hotplug() to run. Avoid possible UAF in this case by
taking the domain reference before scheduling the hotplug handler in
tb_queue_hotplug().

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit Message Forensics

**Step 1.1 — Subject line**

Record: `[thunderbolt] [keep] Keep the domain reference while processing
hotplug` — holds a domain reference during deferred hotplug handling.

**Step 1.2 — Tags**

Record:
- `Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>`
  (author)
- No `Fixes:`, `Reported-by:`, `Tested-by:`, `Reviewed-by:`, `Acked-
  by:`, `Link:`, or `Cc: stable@vger.kernel.org`

Notable: author is the Thunderbolt subsystem maintainer. No syzbot or
user reports in the message.

**Step 1.3 — Body**

Record:
- **Bug:** Hotplug runs on `tb->wq` via `tb_handle_hotplug()`; that work
  can still run after `tb_domain_remove()` if the driver is unloaded
  while a device is plugged.
- **Symptom:** Possible use-after-free on the `struct tb` domain object.
- **Root cause:** `tb_queue_hotplug()` stores a raw `tb` pointer with no
  refcount; removal can free the domain before the work item finishes.
- **Fix:** Take `tb_domain_get()` when queueing; release with
  `tb_domain_put()` when the handler completes.

**Step 1.4 — Hidden bug fix?**

Record: **Yes** — explicit UAF fix, not cosmetic cleanup.

---

## Phase 2: Diff Analysis

**Step 2.1 — Inventory**

Record:
- **File:** `drivers/thunderbolt/tb.c` only
- **Scope:** ~4 net lines (1 changed, 3 added)
- **Functions:** `tb_queue_hotplug()`, `tb_handle_hotplug()`
- **Classification:** Single-file, surgical fix

**Step 2.2 — Code flow**

Record:
- **Hunk 1 (`tb_queue_hotplug`):** `ev->tb = tb` → `ev->tb =
  tb_domain_get(tb)` — bumps device refcount before scheduling work.
- **Hunk 2 (`tb_handle_hotplug`):** Adds `tb_domain_put(tb)` on all exit
  paths through `out:` before `kfree(ev)` — balances the refcount from
  queue time.

**Step 2.3 — Bug mechanism**

Record:
- **Category:** Use-after-free / reference-counting bug
- **Mechanism:** Async hotplug work can outlive domain teardown.
  `tb_domain_remove()` calls `flush_workqueue()`, but a race remains:
  `tb_queue_hotplug()` can run after `flush_workqueue()` returns (e.g.
  concurrent unload + plug event). Without a refcount,
  `device_unregister()` → `tb_domain_release()` can `kfree(tb)` while
  `tb_handle_hotplug()` still dereferences `ev->tb`.

**Step 2.4 — Fix quality**

Record:
- Matches the existing pattern in `xdomain.c`
  (`tb_xdp_schedule_request()` uses `tb_domain_get()` /
  `tb_domain_put()`).
- Minimal, obviously correct refcount pairing.
- **Regression risk:** Very low — only extends domain lifetime for in-
  flight hotplug work.

---

## Phase 3: Git History Investigation

**Step 3.1 — Blame**

Record: In this tree, `tb_queue_hotplug()` and `tb_handle_hotplug()`
blame to `19eef1d98eeda` (squashed import). The hotplug workqueue design
is long-standing Thunderbolt infrastructure.

**Step 3.2 — Fixes: tag**

Record: N/A — no `Fixes:` tag.

**Step 3.3 — Related file history**

Record: Recent stable thunderbolt fixes on `stable/linux-6.18.y` include
XDomain validation and debugfs leaks; no duplicate fix for this UAF
found.

**Step 3.4 — Author context**

Record: Mika Westerberg is the Thunderbolt maintainer. No other commits
from this author found in this checkout’s history (squashed tree).

**Step 3.5 — Dependencies**

Record:
- Requires `tb_domain_get()` / `tb_domain_put()` — **present** in
  `drivers/thunderbolt/tb.h` (lines 796–806).
- Standalone; no series dependency.
- Backport note: mainline diff uses `kmalloc_obj(*ev)`; this tree uses
  `kmalloc(sizeof(*ev), GFP_KERNEL)` — trivial context adjustment only.

---

## Phase 4: Mailing List and External Research

**Step 4.1 — Original discussion**

Record: `b4 dig -c <commit>` not run — commit hash not present in this
checkout. Lore search blocked (Anubis bot protection). Web search did
not locate this specific patch thread.

**Step 4.2 — Reviewers**

Record: UNVERIFIED — could not retrieve thread via b4 or lore.

**Step 4.3 — Bug report**

Record: N/A — no `Reported-by:` or `Link:` tags.

**Step 4.4 — Series context**

Record: Standalone one-commit fix; no multi-patch series indicated.

**Step 4.5 — Stable list**

Record: UNVERIFIED — stable@ discussion not searched (lore blocked).

---

## Phase 5: Code Semantic Analysis

**Step 5.1 — Key functions**

Record: `tb_queue_hotplug()`, `tb_handle_hotplug()`, plus callers
`tb_handle_event()`, `tb_scan_port()`.

**Step 5.2 — Callers**

Record:
- `tb_handle_event()` — control-channel plug events (`handle_event`
  callback at line 3291)
- `tb_scan_port()` — DP HPD path (line 1302)

Both are reachable during normal Thunderbolt operation and driver
unload.

**Step 5.3 — Callees**

Record: `tb_handle_hotplug()` uses `pm_runtime_get_sync()`,
`mutex_lock(&tb->lock)`, switch/port lookups, `tb_scan_port()`,
tunnel/DP handling, `kfree(ev)`.

**Step 5.4 — Reachability**

Record: Triggerable by hardware hotplug and by `rmmod`/PCI remove during
concurrent plug — realistic on laptops/workstations with Thunderbolt.

**Step 5.5 — Similar patterns**

Record: `xdomain.c` already uses `tb_domain_get()` for deferred work.
`tb_queue_dp_bandwidth_request()` still uses a raw `ev->tb = tb` (line
2869) — same class of bug, but out of scope for this commit.

---

## Phase 6: Cross-Reference Against Local Tree

**Step 6.1 — Buggy code present?**

Record: **Yes.** Local tree is **6.18.43** (`git describe HEAD` →
`v6.18.43-1-gc7f0dac02d232`). Current code:

```101:106:drivers/thunderbolt/tb.c
        ev->tb = tb;
        ev->route = route;
        ev->port = port;
        ev->unplug = unplug;
        INIT_DELAYED_WORK(&ev->work, tb_handle_hotplug);
        queue_delayed_work(tb->wq, &ev->work, 0);
```

`tb_handle_hotplug()` ends with `kfree(ev)` and no `tb_domain_put()`.

**Step 6.2 — Backport difficulty**

Record: **Clean apply** with at most `kmalloc` vs `kmalloc_obj` context
difference.

**Step 6.3 — Fix already present?**

Record: **No** — fix not in this checkout.

---

## Phase 7: Subsystem and Maintainer Context

**Step 7.1 — Subsystem**

Record: `drivers/thunderbolt/` — **IMPORTANT** (PCI driver; common on
Intel/Apple laptops, docks, displays).

**Step 7.2 — Activity**

Record: Active maintenance on 6.18.y (recent thunderbolt
security/validation fixes in stable history).

---

## Phase 8: Impact and Risk Assessment

**Step 8.1 — Who is affected**

Record: Systems with `CONFIG_THUNDERBOLT` and the in-tree NHI driver —
Thunderbolt laptop/workstation users.

**Step 8.2 — Trigger conditions**

Record: Driver unload (`nhi_remove()` → `tb_domain_remove()`) concurrent
with device plug/hotplug event. Unprivileged users can unload modules if
permitted; root can always trigger via `rmmod`.

**Step 8.3 — Failure mode**

Record: **UAF on `struct tb`** → kernel oops/panic or memory corruption.
**Severity: CRITICAL/HIGH.**

**Step 8.4 — Risk vs benefit**

Record:
- **Benefit:** High — prevents crash/corruption on a realistic
  unload+hotplug race.
- **Risk:** Very low — 3-line refcount fix following an established in-
  driver pattern.
- **Ratio:** Strongly favors backport.

---

## Phase 9: Final Synthesis

**Step 9.1 — Evidence**

**FOR:**
- Real, well-described UAF race
- Subsystem maintainer fix
- Small, surgical, matches existing `xdomain.c` pattern
- Buggy code confirmed in 6.18.43
- `tb_domain_get/put` infrastructure already in tree
- Crash/corruption severity

**AGAINST:**
- No external reproducer (syzbot/user) in commit message
- Mailing-list review not verified
- Mainline merge not verified (torvalds/linux `tb.c` on GitHub still
  shows buggy `ev->tb = tb`)
- Related `tb_queue_dp_bandwidth_request()` has the same pattern
  (separate issue)

**UNRESOLVED:**
- Commit hash and lore review thread
- Whether fix is already in upstream mainline

**Step 9.2 — Stable rules checklist**

| Criterion | Result |
|-----------|--------|
| 1. Obviously correct and tested? | **PASS** — refcount pairing is
standard; no `Tested-by` in message |
| 2. Fixes a real user-affecting bug? | **PASS** — UAF on driver unload
+ hotplug |
| 3. Important issue? | **PASS** — crash/corruption (CRITICAL/HIGH) |
| 4. Small and contained? | **PASS** — ~4 lines, one file |
| 5. No new features/APIs? | **PASS** — refcount only |
| 6. Can apply to local tree? | **PASS** — infrastructure present, clean
apply |

**Step 9.3 — Exception category**

Record: N/A — not a quirk/DT/build/docs fix; standard bug fix.

**Step 9.4 — Decision rationale**

This is a textbook stable backport: a real UAF in deferred work during
driver teardown, fixed with a minimal refcount hold/release matching
code already used elsewhere in the same driver. The bug exists in the
local 6.18.43 tree, prerequisites are present, and the change is low
risk with high stability benefit.

---

## Verification

- [Phase 1] Parsed subject, body, tags from user-provided commit message
- [Phase 2] Analyzed provided diff: `tb_domain_get()` in
  `tb_queue_hotplug()`, `tb_domain_put()` in `tb_handle_hotplug()`
- [Phase 3] `git describe HEAD` → v6.18.43; `git blame` on
  `tb_queue_hotplug`/`tb_handle_hotplug`
- [Phase 3] `git log stable/linux-6.18.y --grep=thunderbolt` — no
  duplicate fix found
- [Phase 4] `b4 dig` — not run (no commit hash in tree)
- [Phase 4] Lore fetch — blocked by Anubis
- [Phase 4] Web search — no matching patch thread found
- [Phase 5] `grep tb_queue_hotplug` — callers at lines 1302, 2930
- [Phase 5] Read `tb_handle_event()`, `tb_domain_remove()`,
  `tb_domain_release()`
- [Phase 5] Verified `xdomain.c` refcount pattern (lines 879, 859)
- [Phase 6] Read current `tb.c` — buggy code present, fix absent
- [Phase 6] Verified `tb_domain_get/put` in `tb.h` lines 796–806
- [Phase 7] Confirmed thunderbolt driver path and recent stable activity
- [Phase 8] Traced `nhi_remove()` → `tb_domain_remove()` →
  `device_unregister()` → `tb_domain_release()` → `kfree(tb)`
- [UNVERIFIED] Mainline merge status
- [UNVERIFIED] Mailing-list review / stable@ nomination
- [UNVERIFIED] User or syzbot reproduction

**YES**The two background git searches (`build/master` and `fixes-next`)
didn’t finish — they hung and were killed, so they didn’t turn up a
commit hash or confirm mainline merge status.

That doesn’t change the earlier conclusion: the UAF is present in your
6.18.43 tree, the fix is small and correct, and it should be backported.

**YES**

 drivers/thunderbolt/tb.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/thunderbolt/tb.c b/drivers/thunderbolt/tb.c
index 4a94cb406bdfb..041a4c8e10fb9 100644
--- a/drivers/thunderbolt/tb.c
+++ b/drivers/thunderbolt/tb.c
@@ -98,7 +98,7 @@ static void tb_queue_hotplug(struct tb *tb, u64 route, u8 port, bool unplug)
 	if (!ev)
 		return;
 
-	ev->tb = tb;
+	ev->tb = tb_domain_get(tb);
 	ev->route = route;
 	ev->port = port;
 	ev->unplug = unplug;
@@ -2527,6 +2527,9 @@ static void tb_handle_hotplug(struct work_struct *work)
 	pm_runtime_mark_last_busy(&tb->dev);
 	pm_runtime_put_autosuspend(&tb->dev);
 
+	/* Undo the refcount increased in tb_queue_hotplug() */
+	tb_domain_put(tb);
+
 	kfree(ev);
 }
 
-- 
2.53.0

