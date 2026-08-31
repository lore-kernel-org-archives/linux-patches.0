Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CC28471262;
	Mon, 31 Aug 2026 13:49:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184178; cv=none; b=RdNYcL6boEayJ0RNMt9q7tNmrGIC7CV7J0u2uWul84uiZfxAPt2ynMamc19tQL4N8iu652SCXq+320KO6IQFr30prUfvVgIzU1ZdR5BcME166qzqVHBZJQ9uf4Pyk62bTHw0opCRK5hCdBpfdLD45vHiYv3LzHoiGEFvy9kCif4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184178; c=relaxed/simple;
	bh=1VC++xhgOwM/A4VEfI93327+5T+sAsK8RpjKviwg+pk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RdVVplGz94LRrRK6qhn2SIumqr9hJP0H0a1VybJ4EUlhflHCpJI+yZ++urH6+HH5q8OBY3x2f8hu/IFLR60klsQiy+UuyDBA2/5hDOis2jzq8O2B41galtiu4ULDxHpFf2YAoNniV+qa3pTQhavp2fHuXcOGdf1lyxPzinammI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HshEqUI3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HshEqUI3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BD5E1F00ACF;
	Mon, 31 Aug 2026 13:49:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788184175;
	bh=KDaLhjKX41Tg25z6gG+3NrlCdZc+83Qolv1fP8EUB4c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HshEqUI3QKmRbfwLq9luSez4h8oImNdesJ6lslooH1QmQZzdd2NkMswJHJGrk8d8B
	 9cput6kfNCLcEg9swlOWqiPP6RXyQlUKswwSMvrSaa/vr8whzu5515RnWt9xav5nc8
	 f2/0Vj/M5pTQRT3HdNVbVK75jjgFr6xq2sOZFL0LmBQZpdquBGvAGNlM4keXEvmaoc
	 LFwNgR7qg8h+qZvNrb8Gzk8rZnq49BlTyJwlpTmBXmD9xByFBYKWrJuMAyC+bdPaRF
	 IjtsDic2xTKovqosmNoC06ZJOurlGSCfl9446NhnzCCf+5vg5AOl/8yRAi9Sg+Npka
	 3ryrEIQad53lA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Vineeth Vijayan <vneethv@linux.ibm.com>,
	Peter Oberparleiter <oberpar@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>,
	hca@linux.ibm.com,
	gor@linux.ibm.com,
	linux-s390@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.15] s390/cio: Purge based on the cdev's online status
Date: Mon, 31 Aug 2026 09:29:24 -0400
Message-ID: <20260831133314.4125787-536-sashal@kernel.org>
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

From: Vineeth Vijayan <vneethv@linux.ibm.com>

[ Upstream commit 58d50cad63e85daae032924ecc3d457fb1ec02fb ]

Ensure that all devices currently offline are purged correctly.

Previously, purging logic relied on the internal FSM state to
determine whether a device was offline. However, devices with a
target state of offline could be skipped if CIO internal
processing was still ongoing during the purge operation.

Update the purge decision logic to rely on the online variable
in the cdev structure instead of the internal FSM state,
providing a more reliable indication of actual device
availability.

Signed-off-by: Vineeth Vijayan <vneethv@linux.ibm.com>
Reviewed-by: Peter Oberparleiter <oberpar@linux.ibm.com>
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit Message Forensics

### Step 1.1: Subject Line
**Record:** `[s390/cio]` `[Purge]` — Change purge eligibility to use the
cdev's `online` flag instead of internal FSM state.

### Step 1.2: Commit Message Tags
**Record:**
- **Fixes:** — none
- **Reported-by:** — none
- **Tested-by:** — none
- **Reviewed-by:** Peter Oberparleiter `<oberpar@linux.ibm.com>`
  (s390/cio maintainer)
- **Acked-by:** — none
- **Link:** — none
- **Cc: stable:** — none (expected for this review pipeline)
- **Signed-off-by:** Vineeth Vijayan, Alexander Gordeev (ignore
  pipeline-added SOBs)

Notable: maintainer review, no fuzzer/user bug report.

### Step 1.3: Commit Body Analysis
**Record:**
- **Bug:** `purge_fn()` used `cdev->private->state == DEV_STATE_OFFLINE`
  to decide purge eligibility. Devices targeted for offline can still be
  in transitional FSM states during CIO processing, so purge skips them.
- **Symptom:** `echo purge > /proc/cio_ignore` does not remove all
  blacklisted, offline devices.
- **Root cause:** FSM state lags behind the user-visible offline state;
  `cdev->online` is cleared earlier and is the authoritative "in use"
  indicator.
- **Version info:** none in message.

### Step 1.4: Hidden Bug Fix Detection
**Record:** Yes — described as a purge correctness fix, not cosmetic
cleanup. It fixes incorrect device-unregistration behavior in an admin
path.

---

## Phase 2: Diff Analysis

### Step 2.1: Change Inventory
**Record:**
- **Files:** `drivers/s390/cio/device.c` (+1/−1 effective logic line)
- **Function:** `purge_fn()`
- **Scope:** Single-file, surgical fix

### Step 2.2: Code Flow Change
**Record:**
- **Before:** If cdev exists and `state != DEV_STATE_OFFLINE`, skip
  purge (`goto unlock`).
- **After:** If cdev exists and `cdev->online`, skip purge.
- **Path affected:** `/proc/cio_ignore` purge via
  `ccw_purge_blacklisted()` → `purge_fn()`.

### Step 2.3: Bug Mechanism
**Record:** **Logic/correctness fix.** Purge used internal FSM state
instead of the user-visible online flag.

In `ccw_device_set_offline()`, `cdev->online = 0` is set at line 289
before FSM reaches `DEV_STATE_OFFLINE`. During that window, old logic
incorrectly skips purge. The same applies to other non-OFFLINE FSM
states (e.g. `DEV_STATE_BOXED`, `DEV_STATE_NOT_OPER`) where `online ==
0` but state ≠ `DEV_STATE_OFFLINE`.

### Step 2.4: Fix Quality
**Record:** Obviously correct and minimal. Aligns with kernel docs and
`sch_get_action()` (line 1443), which also keys off `cdev->online`.
Protected by existing `onoff` atomic during online/offline sysfs ops.
Very low regression risk.

---

## Phase 3: Git History Investigation

### Step 3.1: Blame
**Record:** `purge_fn()` and the `DEV_STATE_OFFLINE` check are present
in this tree (blame shows flattened history under `19eef1d98eeda`). The
purge refactor using `for_each_subchannel_staged(purge_fn, ...)` is
present.

### Step 3.2: Fixes: Tag
**Record:** N/A — no `Fixes:` tag.

### Step 3.3: Related File History
**Record:** Related stable backport exists for the Oct 2025 purge
refactor ("Update purge function to unregister the unused subchannels",
spinics stable list). That refactor introduced the `DEV_STATE_OFFLINE`
check this commit corrects. This appears to be a standalone follow-up
fix, not part of a multi-patch series.

### Step 3.4: Author Context
**Record:** Vineeth Vijayan has prior s390/cio purge work (e.g.
subchannel unregister during purge, 2021). Peter Oberparleiter
originally introduced purge in 2008 and reviewed this patch.

### Step 3.5: Dependencies
**Record:** Requires the refactored `purge_fn()` using
`for_each_subchannel_staged()` — present in this 6.18.43 tree. Requires
`cdev->online` in `struct ccw_device` — present in
`arch/s390/include/asm/ccwdev.h`. Standalone, no other commits needed.

---

## Phase 4: Mailing List and External Research

### Step 4.1: Original Patch Discussion
**Record:** `b4 dig -c <commit>` could not be run — commit hash not in
this checkout. Lore/spinics search for exact subject returned no match.
Related Oct 2025 purge refactor discussion found on spinics stable list.

### Step 4.2: Reviewers
**Record:** Reviewed-by Peter Oberparleiter (subsystem maintainer). Full
recipient list unverified (no commit hash for `b4 dig -w`).

### Step 4.3: Bug Report
**Record:** N/A — no Reported-by or Link tags.

### Step 4.4: Related Patches
**Record:** Follow-up to the Oct 2025 purge refactor that was backported
to stable 6.17. Same functional area, same author/maintainer.

### Step 4.5: Stable List History
**Record:** Prior purge fix in this area was nominated/backported to
stable (6.17 series). No stable-list discussion found for this specific
commit.

---

## Phase 5: Code Semantic Analysis

### Step 5.1: Key Functions
**Record:** `purge_fn()`, `ccw_purge_blacklisted()`,
`blacklist_parse_proc_parameters()` (purge trigger).

### Step 5.2: Callers
**Record:**
- `ccw_purge_blacklisted()` ← `blacklist_parse_proc_parameters()` on
  `"purge"` via `/proc/cio_ignore`
- Triggered by root/admin: `echo purge > /proc/cio_ignore`

### Step 5.3: Callees
**Record:** `sch_get_cdev()`, `atomic_cmpxchg(&onoff)`,
`ccw_device_sched_todo(CDEV_TODO_UNREG)`,
`css_sched_sch_todo(SCH_TODO_UNREG)`.

### Step 5.4: Reachability
**Record:** Reachable from procfs by privileged users during device
management. Documented admin workflow on IBM Z/s390.

### Step 5.5: Similar Patterns
**Record:** `sch_get_action()` at line 1443 uses `if (cdev->online)` for
the same semantic distinction. `ccw_device_notify()` checks
`!cdev->online` before notifying drivers.

---

## Phase 6: Cross-Reference Against Local Tree (6.18.43)

### Step 6.1: Buggy Code Present?
**Record:** **Yes.** At line 1332:

```1331:1333:drivers/s390/cio/device.c
        if (cdev) {
                if (cdev->private->state != DEV_STATE_OFFLINE)
                        goto unlock;
```

`purge_fn()` with `for_each_subchannel_staged()` is present. Bug is
reachable in this tree.

### Step 6.2: Backport Complications
**Record:** **Clean apply.** Verified with `git apply --check` — hunk
applies with 1-line offset only.

### Step 6.3: Related Fixes Already Present?
**Record:** Oct 2025 purge refactor is present; this specific online-
status fix is **not** yet applied.

---

## Phase 7: Subsystem Context

### Step 7.1: Subsystem and Criticality
**Record:** `drivers/s390/cio/` — s390 Channel I/O layer. **IMPORTANT**
for s390/IBM Z platforms; **PERIPHERAL** globally.

### Step 7.2: Subsystem Activity
**Record:** Active — recent stable backports in this tree include
`6715560527e34` (lifecycle fix) and `600ad63124dea` (CHSC GFP_DMA).

---

## Phase 8: Impact and Risk Assessment

### Step 8.1: Who Is Affected
**Record:** s390/IBM Z administrators using `cio_ignore` purge to remove
blacklisted offline devices. Config/platform-specific, not universal.

### Step 8.2: Trigger Conditions
**Record:** Running `echo purge > /proc/cio_ignore` while blacklisted
devices are offline (`online == 0`) but FSM state is not yet
`DEV_STATE_OFFLINE` (during offline transition, or in states like
BOXED/NOT_OPER). Requires root. Moderately common in dynamic device
management workflows.

### Step 8.3: Failure Mode Severity
**Record:** **MEDIUM** — documented admin operation silently fails to
deregister some devices. No crash, corruption, deadlock, or security
issue. Leaves stale device/subchannel registrations; workaround is to
re-run purge after FSM settles.

### Step 8.4: Risk-Benefit
**Record:**
- **Benefit:** Restores documented purge semantics ("not online" devices
  removed); aligns with maintainer intent and prior stable precedent for
  purge fixes.
- **Risk:** Very low — one-line logic change, maintainer-reviewed,
  protected by `onoff` atomic.
- **Ratio:** Moderate benefit for s390 admins, very low risk.

---

## Phase 9: Final Synthesis

### Step 9.1: Evidence Summary

**FOR backport:**
- Real functional bug in documented admin interface
- Maintainer-reviewed (Peter Oberparleiter)
- Minimal, obviously correct, applies cleanly to 6.18.43
- Buggy code confirmed present in this tree
- Aligns with `cdev->online` semantics used elsewhere in same file
- Prior purge fix in same area was backported to stable

**AGAINST backport:**
- No crash, security, corruption, or deadlock
- No user/fuzzer reports
- s390-specific, narrow audience
- Workaround exists (retry purge after offline completes)
- Does not meet strictest interpretation of "important issue"

**Unresolved:** Original lore thread and mainline commit hash not found;
no explicit stable nomination found.

### Step 9.2: Stable Rules Checklist
1. Obviously correct and tested? **PASS** — logic verified against
   `ccw_device_set_offline()` and `sch_get_action()`; maintainer
   reviewed; no runtime test tag.
2. Fixes a real bug affecting users? **PASS** — breaks documented
   `cio_ignore` purge behavior on s390.
3. Important issue? **BORDERLINE PASS** — functional/admin correctness,
   not crash-level; prior purge fixes in this area were deemed stable-
   worthy.
4. Small and contained? **PASS** — 1-line logic change.
5. No new features or APIs? **PASS**.
6. Can apply to local tree? **PASS** — verified clean apply.

### Step 9.3: Exception Categories
**Record:** None (not device ID, quirk, DT, build, or docs fix).

### Step 9.4: Decision Rationale
This is a small, maintainer-reviewed correctness fix for a long-standing
s390 admin feature (`cio_ignore` purge). The bug is present in 6.18.43,
the fix applies cleanly, and it restores behavior explicitly documented
since 2008: remove blacklisted devices that are "not online." While not
crash-level, the s390 maintainers have previously backported purge fixes
to stable, and this is a direct follow-up correcting the same feature.
The low risk and clear correctness outweigh the moderate (non-critical)
severity.

---

## Verification

- **[Phase 1]** Parsed subject, tags, body; no Reported-by/syzbot;
  Reviewed-by Peter Oberparleiter confirmed.
- **[Phase 2]** Diff: 1-line change in `purge_fn()` from FSM state check
  to `cdev->online` check.
- **[Phase 3]** `git describe HEAD`: v6.18.43; buggy code at line 1332
  confirmed; `for_each_subchannel_staged(purge_fn)` present.
- **[Phase 3]** `git blame -L 1319,1350`: purge_fn with
  DEV_STATE_OFFLINE check present.
- **[Phase 4]** `b4 dig -c`: failed — no commit hash in tree. Spinics
  search: related Oct 2025 purge backport found; exact patch thread not
  found.
- **[Phase 4]** Spinics stable msg884366: prior purge refactor backport
  documented.
- **[Phase 5]** `grep ccw_purge_blacklisted`: called from `blacklist.c`
  on `"purge"` proc command.
- **[Phase 5]** Read `ccw_device_set_offline()`: `cdev->online = 0` at
  line 289 before FSM final state.
- **[Phase 5]** Read `sch_get_action()`: uses `cdev->online` at line
  1443 for same semantic.
- **[Phase 6]** `git describe HEAD`: 6.18.43 tree; buggy code present.
- **[Phase 6]** `git apply --check`: patch applies cleanly.
- **[Phase 6]** `struct ccw_device.online` confirmed in
  `arch/s390/include/asm/ccwdev.h` line 96.
- **[Phase 8]** Failure mode: silent purge failure, severity MEDIUM (not
  CRITICAL).
- **UNVERIFIED:** Mainline commit hash; full lore review thread;
  explicit stable nomination for this specific commit.

**YES**

 drivers/s390/cio/device.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/s390/cio/device.c b/drivers/s390/cio/device.c
index 4b2dae6eb3760..7f8f78b1f8aea 100644
--- a/drivers/s390/cio/device.c
+++ b/drivers/s390/cio/device.c
@@ -1329,7 +1329,7 @@ static int purge_fn(struct subchannel *sch, void *data)
 
 	cdev = sch_get_cdev(sch);
 	if (cdev) {
-		if (cdev->private->state != DEV_STATE_OFFLINE)
+		if (cdev->online)
 			goto unlock;
 
 		if (atomic_cmpxchg(&cdev->private->onoff, 0, 1) != 0)
-- 
2.53.0

