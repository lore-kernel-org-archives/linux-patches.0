Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDD083F0AB2;
	Mon, 20 Apr 2026 13:25:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776691534; cv=none; b=KbKRu2zJ9DG9vGoiW+L0Nh8ziFX8aO7TT84/CF2zK2rPMGrIO7+kaq3Um79JdoPOKhQ4zpeIXLfewORvi5dATmDsB7WWxhZD1L+iYs+YkaXTTClrX28VJpULD8OPoOOzmuUhcZxTnPGYwHBUmlDTjdWlyzn4Uu93O2S4XiU/aiU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776691534; c=relaxed/simple;
	bh=YMI67HKuWretZCevmdAbjY6VKTKWJNUBc2JnOlysQYI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ixfdMbot67IxU2ZexL/b1Yn7s7rWszI4mXSxMcmEblvcDvg60oQuhneiKN2aidptj0RYtU0rZaQjVBcMw/pNT+IU/e5pqrzbJPEOVvfiL6Ap4tSpj/bTQYReTE/D35OHHqDQEokw3LHO3QDm+6Qa5Oj6Pf7RIgkvcKTjhzURXOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=r/+AEnV5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="r/+AEnV5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B776BC2BCB7;
	Mon, 20 Apr 2026 13:25:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776691534;
	bh=YMI67HKuWretZCevmdAbjY6VKTKWJNUBc2JnOlysQYI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r/+AEnV5I1SDSpR6z9OzTz4EM+exlJNUB/n0DxjcR8oytbmw5i+AhIrlETmVG+ngg
	 X7UFTUQzSuy8LoSl8mUzuUIo5/n6QCxaSSl7U7DyZ0Kly6+NgByYMrEak3j03Gh/uH
	 Zp49JiDZn/19v7gN1v2DNrunP8XPqjwK7n1ISGn+fvoCDQ+RV4W7hqN4W+JF7YXOMR
	 TDUd1ycR8aLdi6Q9SNlJCi5QmShllsNnNGAQqGAjK8o+OeKsUPIn8mQDYfi/P3Q5dg
	 sZ2zWkTy4+KPOC254hBejoH4aq0aXJ8p7cGawzKjRaML1Fp4LZA3VY7rHw7hsACe6O
	 rzvVb/gHr2kAw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Igor Pylypiv <ipylypiv@google.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	linux-ide@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-5.10] ata: libata-eh: Do not retry reset if the device is gone
Date: Mon, 20 Apr 2026 09:18:00 -0400
Message-ID: <20260420132314.1023554-86-sashal@kernel.org>
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

From: Igor Pylypiv <ipylypiv@google.com>

[ Upstream commit 182caa17360dd48e6df08e18f00ebda0be87ab24 ]

If a device is hot-unplugged or otherwise disappears during error handling,
ata_eh_reset() may fail with -ENODEV. Currently, the error handler will
continue to retry the reset operation up to max_tries times.

Prevent unnecessary reset retries by exiting the loop early when
ata_do_reset() returns -ENODEV.

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Igor Pylypiv <ipylypiv@google.com>
Signed-off-by: Niklas Cassel <cassel@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have all the information needed for a comprehensive analysis. Let
me compile the full assessment.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject Line
- **Subsystem:** `ata: libata-eh`
- **Action verb:** "Do not retry" (preventing unnecessary behavior = bug
  fix)
- **Summary:** Prevents pointless reset retries when a SATA device has
  been hot-unplugged

### Step 1.2: Tags
- **Reviewed-by:** Damien Le Moal <dlemoal@kernel.org> — co-maintainer
  of LIBATA subsystem
- **Signed-off-by:** Igor Pylypiv <ipylypiv@google.com> — author, Google
  kernel engineer
- **Signed-off-by:** Niklas Cassel <cassel@kernel.org> — co-maintainer
  of LIBATA, committed the patch
- No Fixes: tag, no Cc: stable — expected for a candidate under manual
  review

### Step 1.3: Commit Body
The commit describes: when a device is hot-unplugged during error
handling, `ata_eh_reset()` fails with -ENODEV, but the error handler
keeps retrying resets up to `max_tries` times. The retry timeouts are
10s, 10s, 35s, and 5s — totaling up to **60 seconds** of pointless
retrying against a device that no longer exists.

### Step 1.4: Hidden Bug Fix Detection
This is explicitly described as preventing unnecessary behavior (wasted
retries), but it's a real behavior fix: the system hangs for up to 60
seconds unnecessarily during hot-unplug events. This directly causes
user-visible delays and effectively hangs the SCSI error recovery path.

Record: This IS a real bug fix — it prevents a ~60-second delay during
hot-unplug.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory
- **Files changed:** 1 (`drivers/ata/libata-eh.c`)
- **Lines changed:** 1 line modified (single condition addition)
- **Function modified:** `ata_eh_reset()`, specifically the `fail:`
  label handler
- **Scope:** Single-file, single-line surgical fix

### Step 2.2: Code Flow Change
**Before:** At the `fail:` label, the only way to exit the retry loop
was `try >= max_tries`.

```3174:3174:drivers/ata/libata-eh.c
        if (try >= max_tries) {
```

**After:** Also exit when `rc == -ENODEV`:

```diff
- if (try >= max_tries) {
+       if (try >= max_tries || rc == -ENODEV) {
```

When the condition is true, the code thaws the host port and jumps to
`out:`, completing the error handling without further retries.

### Step 2.3: Bug Mechanism
**Category:** Logic/correctness fix — missing early-exit condition
**Mechanism:** When `ata_do_reset()` returns -ENODEV (device gone / link
offline), the code falls through the retry path: waits for the deadline
timeout, calls `sata_down_spd_limit()`, then jumps back to `retry:`.
This repeats up to `max_tries` (4) times with timeouts of 10s + 10s +
35s + 5s = 60 seconds total.

### Step 2.4: Fix Quality
- **Obviously correct:** Yes — if the device is gone (-ENODEV), retrying
  is pointless.
- **Minimal:** Yes — single condition addition.
- **Regression risk:** Extremely low. The `ata_wait_ready()` function
  already handles transient -ENODEV internally (converting it to 0 when
  the link is still online). By the time -ENODEV escapes to the `fail:`
  label, the device is truly gone.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
The `fail:` label retry logic was introduced by commit `416dc9ed206bba`
(Tejun Heo, 2007-10-31) and the `max_tries` condition by
`7a46c0780babea` (Gwendal Grignou, 2011-10-19). This code has been
essentially unchanged for **15 years** and exists in **all** stable
kernel trees.

### Step 3.2: No Fixes: tag — expected for this candidate.

### Step 3.3: Related Changes
Commit `151cabd140322` ("ata: libata: avoid long timeouts on hot-
unplugged SATA DAS") from 2025-12-01 addresses a related but different
problem — it skips the entire EH handler when the PCI adapter is
offline. The current commit addresses the case where the EH handler runs
but resets fail with -ENODEV (device gone, but adapter may still be
alive — e.g., SATA port multiplier with one device removed).

### Step 3.4: Author Context
Igor Pylypiv is a Google kernel engineer with multiple accepted commits
in the SCSI/ATA subsystem. Niklas Cassel (committer) is a co-maintainer
of LIBATA.

### Step 3.5: Dependencies
None. The patch only adds `|| rc == -ENODEV` to an existing condition.
The surrounding code is unchanged since ~2011 and exists in all stable
trees.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Original Patch Discussion
Found via web search at `yhbt.net/lore/lkml/`:
- **Submitted:** 2026-04-02 by Igor Pylypiv
- **Damien Le Moal** (co-maintainer): "Looks good." + Reviewed-by
- **Niklas Cassel** (co-maintainer): Minor commit message wording
  suggestion (should say "ata_do_reset()" not "ata_eh_reset()"). No
  technical objections.
- The committed version incorporates Niklas's wording fix.

### Step 4.2: Reviewer Assessment
Both LIBATA co-maintainers reviewed and approved. Damien Le Moal
provided Reviewed-by. Niklas Cassel committed the patch.

### Step 4.3-4.5: No specific bug report or syzbot link, but this is
clearly a real-world issue for anyone hot-unplugging SATA devices
(docking stations, external drives, server hot-swap bays).

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1-5.2: Function Analysis
`ata_eh_reset()` is the central SATA/ATA error handler reset function,
called from `ata_eh_recover()` → `ata_eh_reset()`. It is called on every
SATA error recovery event across all ATA-based storage devices.

### Step 5.3: ENODEV Path
`ata_do_reset()` calls the driver's reset callback (e.g.,
`ahci_hardreset()` → `sata_link_hardreset()` → `ata_wait_ready()`). When
the link is offline and the device is gone, `ata_wait_ready()` returns
-ENODEV. `ata_wait_ready()` already handles transient -ENODEV internally
— by the time it escapes, the device is truly gone.

### Step 5.4: Reachability
This is the main reset path for ALL ATA/SATA devices. Any hot-unplug
triggers this path. High reachability — affects all SATA users.

---

## PHASE 6: STABLE TREE ANALYSIS

### Step 6.1: Buggy Code in Stable
The `fail:` label retry loop has existed since 2007-2011. It is present
in **all** active stable trees. The exact line being modified (`if (try
>= max_tries)`) exists unchanged in all versions.

### Step 6.2: Backport Complications
The patch should apply cleanly. The surrounding context (lines 3168-3186
in this tree) has been stable for many years. The only recent
refactoring (`a4daf088a7732` — "Simplify reset operation management")
changed the function signature but not the internal retry loop logic.

For older stable trees that don't have `a4daf088a7732`, the patch still
applies since the `fail:` label code is identical.

### Step 6.3: No related fixes already in stable for this specific
issue.

---

## PHASE 7: SUBSYSTEM CONTEXT

### Step 7.1: Subsystem
- **Path:** `drivers/ata/libata-eh.c` — ATA error handling, core libata
  code
- **Criticality:** IMPORTANT — affects all SATA storage users (majority
  of servers, laptops, and desktops)

### Step 7.2: Activity
Very actively maintained by Damien Le Moal and Niklas Cassel, with
frequent commits.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Affected Users
All users with SATA devices that can be hot-unplugged: laptops with
docking stations, external drive enclosures, server hot-swap bays,
Thunderbolt-connected SATA enclosures.

### Step 8.2: Trigger
Hot-unplugging a SATA device while error handling is active. This is a
common real-world scenario, especially with portable/external storage.

### Step 8.3: Failure Mode
Without the fix: system delays up to ~60 seconds per device during hot-
unplug, with repeated pointless reset retries. Each retry involves
freezing/thawing the port, waiting for timeouts, and printing warning
messages. The SCSI layer is blocked during this time.
**Severity:** MEDIUM-HIGH (system hangs for ~60 seconds on hot-unplug,
blocking I/O to the port)

### Step 8.4: Risk-Benefit
- **Benefit:** HIGH — eliminates 60 seconds of unnecessary delay during
  hot-unplug
- **Risk:** VERY LOW — single condition addition, -ENODEV at this point
  is permanent (transient cases already handled internally by
  `ata_wait_ready()`), reviewed by both subsystem maintainers
- **Ratio:** Very favorable

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence
**FOR backporting:**
- Fixes a real, user-visible bug (60-second delay during hot-unplug)
- Minimal change: 1 line, single condition addition
- Reviewed by both LIBATA co-maintainers
- Committed by the subsystem co-maintainer
- Buggy code exists in ALL stable trees (since 2007)
- No dependencies — applies standalone
- Zero regression risk: -ENODEV at the `fail:` label is always permanent
- Complements existing hot-unplug improvement (151cabd140322)

**AGAINST backporting:**
- No syzbot report or CVE
- Not a crash/corruption/security fix (it's a significant delay/hang)

### Step 9.2: Stable Rules Checklist
1. **Obviously correct and tested?** YES — adding early-exit on -ENODEV
   when device is gone is trivially correct. Reviewed by both
   maintainers.
2. **Fixes a real bug?** YES — unnecessary 60-second delay during hot-
   unplug.
3. **Important issue?** YES — system effectively hangs for ~60 seconds
   per device during hot-unplug. I/O to the port is blocked during this
   time.
4. **Small and contained?** YES — 1 line changed in 1 file.
5. **No new features/APIs?** Correct — no new features.
6. **Can apply to stable?** YES — the changed code is identical across
   all stable trees.

### Step 9.3: Exception Categories
Not an exception category — this is a straightforward bug fix.

---

## Verification

- [Phase 1] Parsed tags: Reviewed-by from Damien Le Moal (co-
  maintainer), committed by Niklas Cassel (co-maintainer)
- [Phase 2] Diff analysis: 1 line modified — adds `|| rc == -ENODEV` to
  existing early-exit condition at `fail:` label
- [Phase 3] git blame: confirmed `fail:` label retry loop unchanged
  since 2007-2011, exists in all stable trees
- [Phase 3] git log: confirmed 151cabd140322 is a related but different
  hot-unplug fix already in the tree
- [Phase 3] git log author: confirmed Igor Pylypiv has multiple accepted
  SCSI/ATA patches
- [Phase 3] MAINTAINERS: confirmed Damien Le Moal and Niklas Cassel are
  LIBATA co-maintainers
- [Phase 4] Found original submission at yhbt.net mirror of lore
  discussion (lore.kernel.org blocked by bot protection)
- [Phase 4] Damien Le Moal: "Looks good." + Reviewed-by. Niklas Cassel:
  minor wording fix only.
- [Phase 5] ata_eh_reset() is called for ALL ATA/SATA error recovery —
  high impact surface
- [Phase 5] Verified ata_wait_ready() already handles transient -ENODEV;
  permanent -ENODEV reaches the `fail:` label
- [Phase 5] Verified ata_eh_reset_timeouts[] = {10000, 10000, 35000,
  5000, UINT_MAX} — up to 60 seconds wasted
- [Phase 6] Code at `fail:` label is identical across all stable trees —
  clean apply expected
- [Phase 8] Failure mode: ~60-second hang per device during hot-unplug,
  severity MEDIUM-HIGH

The fix is small, surgical, obviously correct, reviewed by both
subsystem maintainers, and addresses a real-world hot-unplug delay that
affects all SATA users. It meets all stable kernel criteria.

**YES**

 drivers/ata/libata-eh.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
index 23be85418b3b1..e97a842005e98 100644
--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -3171,7 +3171,7 @@ int ata_eh_reset(struct ata_link *link, int classify,
 	    sata_scr_read(link, SCR_STATUS, &sstatus))
 		rc = -ERESTART;
 
-	if (try >= max_tries) {
+	if (try >= max_tries || rc == -ENODEV) {
 		/*
 		 * Thaw host port even if reset failed, so that the port
 		 * can be retried on the next phy event.  This risks
-- 
2.53.0

