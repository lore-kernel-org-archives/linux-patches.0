Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 558EC4B0C91;
	Mon, 31 Aug 2026 13:50:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184222; cv=none; b=ia3jralvctgKs61j1NWOcp2AXDTMS9zb2GjQWkxRPzI2o9jr/oXA3jmgPix/BcgjcgBCIJ1vuRER4NM9HJzl7bXcDvAVJeupj71x5ItDKe4s7VTYC1Tp7JCamLpKT6t/q+TJyKuJr3Q8AhyXAaytf6GG1HAVJKgzFeQY1JmmKlg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184222; c=relaxed/simple;
	bh=4KM+PYNLyzQDwrF8zl8OBuQ5r4fniUnOVFNeumpvvWA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RDjqqt3YYlMRlMjH0hRw7oH0vkt7RNAmFpTfN66MNlSSaCeCIZnfIPaortYkReuUylHHpO8CmMO7xuqpu7cAyZuOqt8SrTVl7opQ5kOCUbdRm1bgDkxDQBZWS0m3X53MTvkBNG9zKdPBxhsC0oP5vVd4MFn3G8AgQZLul9HykRI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iOuBULCt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iOuBULCt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E556B1F000E9;
	Mon, 31 Aug 2026 13:50:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788184220;
	bh=fc5qTj3syDPxMop/aAFnkl6kzYSQTlumzf/vs9duMlQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iOuBULCtIxjK1NA0sjizX5gPBVMSlw4NLVokuMRDA0lHg5zfVhZK+B0aDXs2xz1Z6
	 0aWX0Mfu37cvp5sf0rHn6muLnFwYZ23cKmdTTRJCKWQrRZGr/Unlp/hA9rhC+a/dVv
	 bx3jdyGC8iDAmhOORoa9lM97HfQ05lReXDZOrTWuv9YQMpCbaP/k9lN9ocaoShMIR2
	 taqz3JPXsugNg5aYvDk3gTc0+RJavZ17DINQOnIJchR6DSw85LAQgCWXYt26OogYg3
	 SzTq7wHdM3CiB89JGXFrxdYhgFVcllIwQerUY1r4/XGHRCZjSk1UVXs+y4wI8t2q8P
	 oLc0Ric2GyWMQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Yousef Alhouseen <alhouseenyousef@gmail.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	pavel@kernel.org,
	linux-leds@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] leds: uleds: Return -EFAULT on copy_to_user() failure
Date: Mon, 31 Aug 2026 09:29:51 -0400
Message-ID: <20260831133314.4125787-563-sashal@kernel.org>
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

From: Yousef Alhouseen <alhouseenyousef@gmail.com>

[ Upstream commit 61ed78f55a46e12afd4b464c4ba736f55ff33c5e ]

uleds_read() copies the current brightness value to userspace but
ignores copy_to_user() failures. It then clears the pending update and
reports a successful full read even when no data was copied.

Return -EFAULT when the copy fails and leave the update pending so a
later read can retry.

Signed-off-by: Yousef Alhouseen <alhouseenyousef@gmail.com>
Link: https://patch.msgid.link/20260521181205.15130-1-alhouseenyousef@gmail.com
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit Message Forensics

### Step 1.1: Subject Line
**Record:** `[leds: uleds]` `[Return]` — Return `-EFAULT` on
`copy_to_user()` failure in `uleds_read()`.

### Step 1.2: Tags
**Record:**
- **Link:** `https://patch.msgid.link/20260521181205.15130-1-
  alhouseenyousef@gmail.com`
- **Signed-off-by:** Yousef Alhouseen `<alhouseenyousef@gmail.com>`
  (author)
- **Signed-off-by:** Lee Jones `<lee@kernel.org>` (LED subsystem
  maintainer)
- No `Fixes:`, `Reported-by:`, `Tested-by:`, `Reviewed-by:`, `Acked-
  by:`, or `Cc: stable@vger.kernel.org`
- Notable: maintainer (Lee Jones) sign-off; no syzbot/user reports

### Step 1.3: Body Analysis
**Record:**
- **Bug:** `uleds_read()` calls `copy_to_user()` but ignores its return
  value, then unconditionally clears `new_data` and returns
  `sizeof(udev->brightness)` as success.
- **Symptom:** On `copy_to_user()` failure, userspace gets a successful
  read (positive return) with no data copied; the pending brightness
  update is discarded.
- **Root cause:** Return value overwritten; state cleared regardless of
  copy outcome.
- **Fix:** Return `-EFAULT` on failure; leave `new_data` set so a later
  read can retry.
- **Version info:** None in message.

### Step 1.4: Hidden Bug Fix?
**Record:** No — this is an explicit error-handling bug fix, not
disguised cleanup.

---

## Phase 2: Diff Analysis

### Step 2.1: Inventory
**Record:**
- **Files:** `drivers/leds/uleds.c` only (+6 / -3 net)
- **Function:** `uleds_read()`
- **Scope:** Single-file surgical fix in one function

### Step 2.2: Code Flow Change
**Record:**
- **Hunk (lines 150–155):**
  - **Before:** `copy_to_user()` → always `new_data = false` → always
    `retval = sizeof(brightness)` (success).
  - **After:** On `copy_to_user()` failure → `retval = -EFAULT`,
    `new_data` stays true. On success → clear `new_data`, return byte
    count.
- **Path affected:** Read path when `udev->new_data` is true (brightness
  update delivery to userspace).

### Step 2.3: Bug Mechanism
**Record:**
- **Category:** Logic / correctness — ignored error return + incorrect
  state transition.
- **Mechanism:** `copy_to_user()` returns bytes-not-copied (0 =
  success). Old code stored this in `retval` then overwrote it. Failed
  copies still cleared `new_data`, losing the event.

### Step 2.4: Fix Quality
**Record:**
- **Quality:** Obviously correct; matches `uleds_write()`
  (`copy_from_user` → `-EFAULT`) and `uinput.c` patterns.
- **Risk:** Very low — only changes the error path; success path
  unchanged.
- **Red flags:** None.

---

## Phase 3: Git History Investigation

### Step 3.1: Blame
**Record:** Buggy lines introduced in `e381322b0190c` ("leds: Introduce
userspace LED class driver", Sep 2016). Present unchanged in this tree.

### Step 3.2: Fixes: Tag
**Record:** N/A — no `Fixes:` tag.

### Step 3.3: File History
**Record:** Recent `uleds.c` changes in this tree:
- `6dd51d84a9502` — buffer overread fix (stable backport, `Cc: stable`)
- `cb787f4ac0c2e` — `stream_open` conversion
- `a916d720ab5b4` — `module_misc_device` macro
- Original `e381322b0190c` — driver introduction

Standalone fix; not part of a series.

### Step 3.4: Author Context
**Record:** Yousef Alhouseen has no other commits in `drivers/leds/` in
this tree. Lee Jones committed the related stable backport
`6dd51d84a9502`.

### Step 3.5: Dependencies
**Record:** None. Applies directly to existing `uleds_read()` code.
Standalone.

---

## Phase 4: Mailing List and External Research

### Step 4.1: Original Discussion
**Record:** `b4 dig -c 470015e3f8020` failed (commit not in tree).
Lore/patch.msgid.link blocked by bot protection. **UNVERIFIED:** full
review thread, stable nominations, NAKs.

### Step 4.2: Reviewers
**Record:** **UNVERIFIED** (`b4 dig -w` unavailable without commit
hash).

### Step 4.3: Bug Report
**Record:** No `Reported-by:` or bugzilla/syzbot links. Code-review
finding, not a user crash report.

### Step 4.4: Related Patches
**Record:** Related stable-worthy fix in same file: `6dd51d84a9502`
(buffer overread). Independent issue.

### Step 4.5: Stable List History
**Record:** **UNVERIFIED** — lore stable search inaccessible.

---

## Phase 5: Code Semantic Analysis

### Step 5.1: Key Functions
**Record:** `uleds_read()` modified.

### Step 5.2: Callers
**Record:** `uleds_read` is the `.read` handler in `uleds_fops` (line
201). Invoked via `read()` syscall on `/dev/uleds` by userspace (e.g.
`tools/leds/uledmon.c`).

### Step 5.3: Callees
**Record:** `mutex_lock_interruptible`, `copy_to_user`, `mutex_unlock`,
`wait_event_interruptible`.

### Step 5.4: Reachability
**Record:** Userspace opens `/dev/uleds`, writes device registration,
then reads brightness updates. Reachable from unprivileged userspace if
device node permissions allow (standard misc device). `copy_to_user()`
fails on invalid/unmapped userspace buffers.

### Step 5.5: Similar Patterns
**Record:** `uleds_write()` correctly returns `-EFAULT` on
`copy_from_user()` failure (lines 97–100). `uinput.c` consistently
returns `-EFAULT` on `copy_to_user()` failure. `uleds_read()` is the
outlier.

---

## Phase 6: Cross-Reference Against Local Tree

### Step 6.1: Buggy Code Present?
**Record:** **YES.** Local tree is **6.18.44** (`git describe HEAD` →
`v6.18.44-1-g2736c32da98b9`). Buggy code at lines 151–154:

```151:154:drivers/leds/uleds.c
                        retval = copy_to_user(buffer, &udev->brightness,
                                              sizeof(udev->brightness));
                        udev->new_data = false;
                        retval = sizeof(udev->brightness);
```

Present since driver introduction (2016).

### Step 6.2: Backport Complications
**Record:** Clean apply expected — surrounding code unchanged since
introduction. No conflicts identified.

### Step 6.3: Related Fixes Already Present?
**Record:** Buffer overread fix (`6dd51d84a9502`) is present. This
`copy_to_user` fix is **not** present (`git log --grep` found no match).

---

## Phase 7: Subsystem and Maintainer Context

### Step 7.1: Subsystem
**Record:** `drivers/leds/` — **PERIPHERAL** (optional
`CONFIG_LEDS_USER` module). Not core kernel, but used for
virtual/userspace LEDs and testing.

### Step 7.2: Activity
**Record:** LEDs subsystem actively maintained; recent `uleds` stable
backport in this tree.

---

## Phase 8: Impact and Risk Assessment

### Step 8.1: Who Is Affected
**Record:** Users of `/dev/uleds` with `CONFIG_LEDS_USER` enabled
(module or built-in). Enabled in some RISC-V defconfigs
(`nommu_k210_defconfig`, `nommu_k210_sdcard_defconfig`). Driver-
specific, not universal.

### Step 8.2: Trigger Conditions
**Record:** `copy_to_user()` failure — typically invalid/unmapped
userspace buffer. Uncommon with well-behaved apps; possible with signal
interruption edge cases or buggy userspace. Unprivileged users can
trigger via `read()` on `/dev/uleds`.

### Step 8.3: Failure Mode Severity
**Record:**
- Wrong success return (positive byte count instead of `-EFAULT`) —
  **MEDIUM** for API correctness
- Lost brightness update (`new_data` cleared on failure) — **MEDIUM**
  functional data loss
- No kernel crash, oops, memory corruption, or deadlock — not
  **CRITICAL**

### Step 8.4: Risk-Benefit
**Record:**
- **Benefit:** Correct error reporting; preserves pending updates for
  retry; aligns read path with write path and kernel conventions.
- **Risk:** Very low — 6-line change, error-path only.
- **Ratio:** Modest benefit, negligible risk. Appropriate for stable
  given trivial scope and clear correctness bug.

---

## Phase 9: Final Synthesis

### Step 9.1: Evidence Summary

**FOR backport:**
- Real, verifiable bug (ignored `copy_to_user`, wrong return, lost
  state)
- Obviously correct, minimal fix
- Bug present since 2016 in this 6.18.y tree
- Maintainer sign-off (Lee Jones)
- Consistent with sibling code (`uleds_write`, `uinput.c`)
- Same driver recently received a stable backport (`6dd51d84a9502`)
- Applies cleanly

**AGAINST backport:**
- Niche optional driver (`CONFIG_LEDS_USER`)
- No user reports, syzbot, or crash reports
- `copy_to_user` failure is rare (mostly bad userspace buffers)
- Does not meet highest-severity bar (crash/security/corruption)
- Mailing list review unverified

**UNRESOLVED:**
- Full lore review thread and any explicit stable nomination

### Step 9.2: Stable Rules Checklist
1. Obviously correct and tested? **PASS** — logic is clear; no `Tested-
   by` but pattern is standard.
2. Fixes a real bug? **PASS** — incorrect return value and lost update
   state.
3. Important issue? **PASS (borderline)** — not crash/security, but
   functional API bug with data loss on error path.
4. Small and contained? **PASS** — ~6 lines, one function.
5. No new features/APIs? **PASS**
6. Can apply to local tree? **PASS** — buggy code confirmed present.

### Step 9.3: Exception Categories
**Record:** None (not device ID, quirk, DT, build, or docs fix).

### Step 9.4: Decision Rationale

For **linux-6.18.y** at 6.18.44: the bug exists, the fix is trivial and
obviously correct, and the functional impact (false success + discarded
brightness update) is a real defect in the userspace interface. While
the driver is peripheral and failures are uncommon, the fix has
essentially zero regression risk and corrects longstanding incorrect
behavior. The same file was recently deemed stable-worthy for a separate
`uleds` fix. This meets stable criteria.

---

## Verification

- **[Phase 1]** Parsed subject, tags, body from user-provided commit
  message
- **[Phase 2]** Diff analysis: 6 lines in `uleds_read()` error path;
  verified against `drivers/leds/uleds.c`
- **[Phase 3]** `git blame -L 150,155`: buggy code from `e381322b0190c`
  (2016)
- **[Phase 3]** `git show e381322b0190c`: original driver had same bug
- **[Phase 3]** `git log --oneline -20 -- drivers/leds/uleds.c`: file
  history reviewed
- **[Phase 3]** `git log --grep="uleds: Return -EFAULT"`: no match — fix
  not in tree
- **[Phase 4]** `b4 dig -c 470015e3f8020`: failed (commit not in tree)
- **[Phase 4]** WebFetch lore/patch.msgid.link: blocked by bot
  protection — **UNVERIFIED** review thread
- **[Phase 5]** Read `uleds_fops`: `.read = uleds_read`
- **[Phase 5]** Grep `uinput.c`: confirmed `-EFAULT` pattern on
  `copy_to_user` failure
- **[Phase 5]** Read `tools/leds/uledmon.c`: userspace consumer of
  `read()` on `/dev/uleds`
- **[Phase 6]** `git describe HEAD`: v6.18.44; `make kernelversion`:
  6.18.44
- **[Phase 6]** Read lines 151–154: buggy code confirmed present
- **[Phase 6]** `git branch`: detached from `stable/linux-6.18.y`
- **[Phase 6]** `git show 6dd51d84a9502`: related stable backport
  present; different bug
- **[Phase 7]** Read `drivers/leds/Kconfig`: `CONFIG_LEDS_USER` optional
  module
- **[Phase 7]** Grep defconfigs: `CONFIG_LEDS_USER=y` in two RISC-V
  configs
- **[Phase 8]** Compared `uleds_write()` lines 97–100: correct `-EFAULT`
  handling on copy failure

**YES**

 drivers/leds/uleds.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/leds/uleds.c b/drivers/leds/uleds.c
index 48ca73c106bc0..8e250838a15e5 100644
--- a/drivers/leds/uleds.c
+++ b/drivers/leds/uleds.c
@@ -148,10 +148,13 @@ static ssize_t uleds_read(struct file *file, char __user *buffer, size_t count,
 		} else if (!udev->new_data && (file->f_flags & O_NONBLOCK)) {
 			retval = -EAGAIN;
 		} else if (udev->new_data) {
-			retval = copy_to_user(buffer, &udev->brightness,
-					      sizeof(udev->brightness));
-			udev->new_data = false;
-			retval = sizeof(udev->brightness);
+			if (copy_to_user(buffer, &udev->brightness,
+					 sizeof(udev->brightness))) {
+				retval = -EFAULT;
+			} else {
+				udev->new_data = false;
+				retval = sizeof(udev->brightness);
+			}
 		}
 
 		mutex_unlock(&udev->mutex);
-- 
2.53.0

