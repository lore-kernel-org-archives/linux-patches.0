Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C68C55C1DE;
	Mon, 19 Oct 2026 13:59:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418363; cv=none; b=iHNnYA1Ag0dYgXm1HoBbl4zGJIGGvjJa4WiQF//UF/jewz6zqr5eeyykawX6S9Za7bEsLLsdLCe6tbOjZpXayWZ7pKr+UpDPmNE8lQKikBeLPF733V/SBrq03c8o1iTFsmlxxXaMPiWQG5QAhPmZX9jYlyNmovDk6WHq6iP3wvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418363; c=relaxed/simple;
	bh=Mg6NU+MaXQEfMcdUj6yXhYilS1aau4GsN7oMZ6MVR/0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pHCY7Cr03J99yoe1z84Bjai4We4Y6U5PGjfg1UvUHR+so9KhGmTgPUW8L5RNDNKMzOg0bxKfiMFhheSZFU/l3D4EEI3sydivVN9cjJY0PNPiUAxLWcAFSnc5XYwroQLPmfblhxNZ8wm2PiUzGN377nOnKjCs/0HIZyrRZDXjMyU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VwvIaG1I; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VwvIaG1I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF7B81F000C4;
	Mon, 19 Oct 2026 13:59:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418361;
	bh=85wczQUNKJcp+vhMiXU5psXp0nDM7kIiat58I+8aCGc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VwvIaG1ISkMdrZwxH06yWAw9Mj7iPMaC8ecqQHGc9oJxnEBvH5PmAEG/4ODy5esu/
	 +BYb1dm60xIEbyUT5owZ7jnOc6YSrtNS3H2fQPEv2bI8AZuaaXqrsZnmp2Q/Qr6wbi
	 3u4sHejZzIuiGCf9gl8i5V4KLl+CZQhXN2aBiScvSL4F7pe8jf697INfVVUXX7FIRp
	 3b7BbsnGUQ6kBWjnirFi0OrXn82prh++ibRKxeHOtrcEfyzWb4oAyooHdV577rhVBE
	 d42326OzXjgxkHEOVIfUg8AE17U0ecgPnogo0Ik4W+M88/yY75bo11r/1K+7GwvQKV
	 WgS14H3jz6LsQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Michail Tatas <michail.tatas@gmail.com>,
	syzbot+56962eb32ba0136cd330@syzkaller.appspotmail.com,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>,
	linux-usb@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] USB: misc: uss720: Fix leak in get_1284_register
Date: Mon, 19 Oct 2026 09:48:04 -0400
Message-ID: <20261019135441.1420968-193-sashal@kernel.org>
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

From: Michail Tatas <michail.tatas@gmail.com>

[ Upstream commit 15902712b9e2a46649cba2f22002d05faec2a990 ]

if wait_for_completion_timeout() times out in get_1284_register()
then we do not destroy the reference acquired via kref_get() in
submit_async_request. Add the missing kref_put in the timeout path.

link: https://syzkaller.appspot.com/bug?extid=56962eb32ba0136cd330

Reported-by: syzbot+56962eb32ba0136cd330@syzkaller.appspotmail.com
Signed-off-by: Michail Tatas <michail.tatas@gmail.com>
Link: https://patch.msgid.link/allaDTUua9n5DQ0a@michalis-linux
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The local tree is **7.3-rc4** (`v7.3-rc4-27-gf0100363d8c37`). The
candidate is a one-line kref leak fix in `drivers/usb/misc/uss720.c`.
The affected driver and timeout path are present in this tree, and the
bug dates to 2005.

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

**Step 1.1: PARSE THE SUBJECT LINE**
Record: **[USB: misc: uss720]** **[Fix]** **[missing kref_put on
get_1284_register() timeout]**

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**
Record:
- **Reported-by:**
  `syzbot+56962eb32ba0136cd330@syzkaller.appspotmail.com` (fuzzer-found,
  C repro)
- **Link:**
  `https://syzkaller.appspot.com/bug?extid=56962eb32ba0136cd330`
- **Link:** `https://patch.msgid.link/allaDTUua9n5DQ0a@michalis-linux`
- **Signed-off-by:** Michail Tatas (author)
- **Signed-off-by:** Greg Kroah-Hartman (USB maintainer; merged)
- **Fixes:** absent (expected)
- **Cc: stable:** absent (expected)
- Lowercase `link:` to syzbot (same report as Reported-by)

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**
Record:
- **Bug:** `wait_for_completion_timeout()` expiry in
  `get_1284_register()` does not drop the `uss720_async_request` kref
  taken by `submit_async_request()`.
- **Symptom:** kmemleak of the request, URB, control buffer, and `priv`
  (syzbot title: “memory leak in uss720_probe”).
- **Root cause:** success/`!val` paths call `kref_put()`; the timeout
  path only unlinks URBs and returns `-EIO`.
- **Version info in message:** none. Introduced with the async path in
  2005 (`0f36163d3abef`).

**Step 1.4: DETECT HIDDEN BUG FIXES**
Record: Not hidden. Explicit leak fix, plus syzbot/kmemleak evidence.

===============================================================
PHASE 2: DIFF ANALYSIS
===============================================================

**Step 2.1: INVENTORY THE CHANGES**
Record:
- File: `drivers/usb/misc/uss720.c` — **+1 / -0**
- Function: `get_1284_register()`
- Scope: single-file, one-line, timeout/error path only

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**
Record:
- **Before:** timeout prints a warning,
  `kill_all_async_requests_priv(priv)` (`usb_unlink_urb` only), `return
  -EIO`. Caller kref leaked.
- **After:** same unlink, then `kref_put(&rq->ref_count, destroy_async)`
  matching the completion path.

**Step 2.3: IDENTIFY THE BUG MECHANISM**
Record: **Reference-count / resource leak**
- `submit_async_request()`: `kref_init` (caller) + `kref_get`
  (URB/`async_complete`).
- `async_complete()` puts the URB ref.
- Timeout never puts the caller ref, so `destroy_async()` never runs:
  URB, `rq`, `rq->dr`, and a `priv` kref leak.
- Syzbot objects match: `uss720_probe` priv, `submit_async_request`
  `rq`, `usb_alloc_urb`, `rq->dr`.

**Step 2.4: ASSESS THE FIX QUALITY**
Record: Obviously correct; same `kref_put` as the success and `!val`
paths. Unlink does not drop the caller ref. Timeout means `complete()`
has not run, so the extra put cannot free `rq` while the URB still holds
a ref. No API/locking/structure changes. Regression risk: very low.

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

**Step 3.1: BLAME THE CHANGED LINES**
Record: Timeout path from **`0f36163d3abef`** (2005-09-12, “usb: fix
uss720 schedule with interrupts off”). Extra `kref_get` before
`usb_submit_urb` from **`adaa3c6342b249`** (2011, “USB: uss720 fixup
refcount position”). Bug is old, not 7.3-only.

**Step 3.2: FOLLOW THE FIXES: TAG**
Record: No `Fixes:` tag. Buggy code is the 2005 timeout path; that
commit is in this tree.

**Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**
Record: Nearby uss720 work is probe refcount/unregister
(`45dba8011efac`, `b4ecbdc4f8830`), not this timeout put. Standalone,
not `N/M`. After this commit on this file: none that revert or replace
it.

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**
Record: Only this uss720 commit from Michail Tatas in `drivers/usb/`.
Merged by Greg KH (USB maintainer).

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**
Record: None. Uses existing `kref_put` / `destroy_async`. Applies as a
one-line add.

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**
Record:
- `b4 dig -c 15902712b9e2a`:
  https://patch.msgid.link/allaDTUua9n5DQ0a@michalis-linux
- `b4 dig -a`: earlier “v1” by WenTao Liang (2026-06-11) same leak;
  syzbot forwards of this patch and a competing `usb_kill_urb` patch
  (Deepanshu Kartikey).
- Direct lore HTTP was 403; thread recovered with `b4 dig -m`.
- David Laight **questioned** the `usb_kill_urb` + unlock-while-
  iterating alternative; that patch was not merged. This one-line
  `kref_put` was.
- Syzbot `#syz test` of this patch: **OK**.
- No NAK on the merged patch. No reviewer `Cc: stable` in the saved mbox
  (syzbot thread, not Greg’s apply mail).

**Step 4.2: CHECK WHO REVIEWED THE PATCH**
Record (`b4 dig -w`): To/Cc included `gregkh@linuxfoundation.org`,
`oneukum@suse.com`, `linux-usb@vger.kernel.org`. Merged by Greg KH.

**Step 4.3: SEARCH FOR THE BUG REPORT**
Record: https://syzkaller.appspot.com/bug?extid=56962eb32ba0136cd330
- Title: memory leak in uss720_probe; **prio:high**; C and syz repros.
- Path: `uss720_probe` → `get_1284_register` → `submit_async_request`.
- Assessment: DoS via peripheral USB, not remote/unprivileged.
- Later dashboard crashes (Aug 2026) are on **7.2-rc** SHAs that are
  **not** ancestors of this fix (`d58772d8520c`, `0d8395707651`). They
  do not show the fix failing on 7.3.

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**
Record: Standalone. Competing `usb_kill_urb` rewrite not required and
not in this tree (`kill_all_async_requests_priv` still uses
`usb_unlink_urb`).

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**
Record: lore.kernel.org/stable WebFetch returned 403. **UNVERIFIED**
whether stable@ discussed it. No local `git log --grep` hit except this
commit itself.

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

**Step 5.1: KEY FUNCTIONS**
Record: `get_1284_register` (modified). Related: `submit_async_request`,
`destroy_async`, `async_complete`, `kill_all_async_requests_priv`,
`uss720_probe`.

**Step 5.2: TRACE CALLERS**
Record: `get_1284_register()` from `change_mode()`, parport
read/status/control/EPP/ECP helpers, and **`uss720_probe()`** (line 734,
Belkin/incompatible-cable check). Probe is a USB enumeration path;
syzbot reaches it with a matching fake device that does not complete the
control URB in 1s (`HZ`).

**Step 5.3: TRACE CALLEES**
Record: `submit_async_request` (alloc + URB submit),
`wait_for_completion_timeout`, `kill_all_async_requests_priv`,
`kref_put` → `destroy_async` (`usb_free_urb`, `kfree(dr)`, list_del,
`kfree(rq)`, `kref_put(priv)`).

**Step 5.4: FOLLOW THE CALL CHAIN**
Record: USB device add → `uss720_probe` → `get_1284_register(..., &reg,
GFP_KERNEL)` with non-NULL `val` (so it waits). Unprivileged USB
gadget/dummy matching IDs in `uss720_table[]` can trigger it (syzbot).
Real cables that NACK/timeout on that register read take the same path.

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**
Record: `set_1284_register()` fire-and-forget puts immediately (no
wait). Only `get_1284_register()` waits and had an unbalanced timeout
path. No sibling copy of this bug.

===============================================================
PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
===============================================================

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**
Record:
- Tree: **Linux 7.3.0-rc4** (mainline-lineage checkout, detached HEAD).
- Driver and `get_1284_register()` timeout path **exist**.
- Bug introduced **2005**, before this branch. Not a post-7.3 bug.
- Working copy already has the `kref_put` (commit `15902712b9e2a` is an
  ancestor of HEAD; first contained in **v7.3-rc1**). That is the
  original landing, not a reason to treat the leak as non-bugs.

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**
Record: Clean one-line add against the pre-fix function (parent blob
matches the candidate diff). No refactor of this path in 7.3. **Clean
apply.**

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**
Record: This is the fix for that syzbot leak. No alternate timeout-path
put. Probe unregister fixes are separate.

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

**Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY**
Record: **USB misc / USS720 USB-to-parallel** (`CONFIG_USB_USS720`,
depends on `PARPORT`). **PERIPHERAL** hardware, but probe is a standard
USB path and is fuzzable.

**Step 7.2: ASSESS SUBSYSTEM ACTIVITY**
Record: File is old and lightly touched; USB core is actively
maintained. Greg KH merged the fix.

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

**Step 8.1: DETERMINE WHO IS AFFECTED**
Record: **Driver-specific / config-specific** (`CONFIG_USB_USS720`).
Anyone probing a matching USB ID (real USS720/Belkin-class cables, or a
malicious/fuzzed USB device).

**Step 8.2: DETERMINE THE TRIGGER CONDITIONS**
Record: Control URB for register 0 does not complete within 1 second
during probe (or later parport ops that pass a non-NULL `val`). Syzbot
has a **C repro**. Not a theoretical race. Unprivileged local USB attach
can trigger it; not a remote syscall by itself.

**Step 8.3: DETERMINE THE FAILURE MODE SEVERITY**
Record: **Memory leak** of priv + async request + URB + setup packet on
each failed/timed-out probe. Repeated plug or syzbot-style enumeration
can grow leaks. **HIGH** (DoS / kmemleak), not an oops by itself.
Syzbot: prio:high, DoS.

**Step 8.4: CALCULATE RISK-BENEFIT RATIO**
Record:
- **Benefit:** high for this driver — stops a confirmed, reproducible
  leak on probe timeout; one-line; syzbot-tested.
- **Risk:** very low — one matching `kref_put`, error path only.
- **Ratio:** strongly in favor of including the fix in this tree.

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

**Step 9.1: COMPILE THE EVIDENCE**

FOR:
- Real kmemleak with syzbot C repro and prio:high
- Unbalanced kref on a path that already puts on success
- One line, obviously correct, maintainer-merged, syzbot test OK
- Bug present since 2005; driver exists in 7.3
- No prerequisites, no new API

AGAINST:
- Peripheral USB-parport driver, not core MM/VFS
- Timeout may be uncommon on healthy hardware
- Competing `usb_kill_urb` change was not taken (not a dependency)

UNRESOLVED:
- Stable@ lore search HTTP 403
- Full Greg apply-thread body not fetched (msgid.link 403); merge +
  patch-id match via b4 is verified

**Step 9.2: APPLY THE STABLE RULES CHECKLIST**
1. Obviously correct and tested? **PASS** (matches other puts; syzbot
   OK; Greg merged)
2. Fixes a real bug that affects users? **PASS** (kmemleak, C repro,
   probe of matching USB IDs)
3. Important issue? **PASS** (HIGH leak/DoS on USB probe; sanitizer-
   class resource leak)
4. Small and contained? **PASS** (+1 line, one function)
5. No new features or APIs? **PASS**
6. Can apply to the local tree? **PASS** (same file/function; clean one-
   line)

**Step 9.3: CHECK FOR EXCEPTION CATEGORIES**
Record: Not an ID/quirk/DT/build/docs exception. Ordinary small bug fix.

**Step 9.4: DECISION**
This tree has the USS720 driver and the 2005 timeout path. Missing
`kref_put` leaks the async request and keeps `priv` alive across a
failed probe. The fix is the same put used on every other
`get_1284_register()` exit. It meets stable rules for 7.3: real leak,
tiny, no deps.

===============================================================
What the commit solves for this tree
===============================================================

`get_1284_register()` waits up to 1s for a USB control URB. On timeout
it unlinked URBs but left the caller’s kref. `uss720_probe()` uses that
helper to reject incompatible cables; a non-responsive matching device
leaks `priv`, `uss720_async_request`, the URB, and the setup packet.
That is exactly the syzbot kmemleak. Adding `kref_put(...,
destroy_async)` closes the leak without changing success behavior.

Risk is negligible relative to stopping a reproducible probe leak.

===============================================================
Verification
===============================================================
- **[Phase 1]** Parsed subject/tags: syzbot Reported-by, two Links, Greg
  KH SOB; no Fixes/Cc stable
- **[Phase 2]** Diff: +1 line `kref_put` in `get_1284_register()`
  timeout path; parent blob confirmed missing put
- **[Phase 2]** kref model checked in current `uss720.c`: init + get in
  `submit_async_request`, put in `async_complete` and all other
  `get_1284_register` exits
- **[Phase 3]** `git blame`: timeout path `0f36163d3abef` (2005); extra
  get `adaa3c6342b249` (2011)
- **[Phase 3]** No Fixes tag; `git log` on file shows standalone commit
- **[Phase 3]** `git merge-base --is-ancestor 15902712b9e2a HEAD` → yes
  (original commit in this 7.3-rc4 checkout; first in v7.3-rc1)
- **[Phase 3]** Not in v7.1/v7.2 tags; post-fix syzbot crash SHAs are
  7.2-rc and do not contain this commit
- **[Phase 4]** `b4 dig -c/-w/-a/-m`: msgid allaDTUua9n5DQ0a; CC Greg KH
  + linux-usb; competing usb_kill_urb patch questioned by David Laight
- **[Phase 4]** WebFetch syzbot: prio:high, C repro, leak stacks through
  probe/get_1284_register
- **[Phase 4]** lore.kernel.org HTTP 403 — used b4 mbox instead; stable@
  search UNVERIFIED
- **[Phase 5]** Callers via grep: probe line 734 and parport ops;
  `CONFIG_USB_USS720` in `drivers/usb/misc/Kconfig`
- **[Phase 6]** `git describe HEAD` / Makefile: 7.3.0-rc4; driver
  present; apply would be clean
- **[Phase 8]** Failure mode: kmemleak/DoS on USB probe timeout,
  severity HIGH
- **UNVERIFIED:** stable@ mailing-list archive text (HTTP 403)

**YES**

 drivers/usb/misc/uss720.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/misc/uss720.c b/drivers/usb/misc/uss720.c
index 6ebcfaf525989..a405a36d8d42f 100644
--- a/drivers/usb/misc/uss720.c
+++ b/drivers/usb/misc/uss720.c
@@ -223,6 +223,7 @@ static int get_1284_register(struct parport *pp, unsigned char reg, unsigned cha
 	}
 	printk(KERN_WARNING "get_1284_register timeout\n");
 	kill_all_async_requests_priv(priv);
+	kref_put(&rq->ref_count, destroy_async);
 	return -EIO;
 }
 
-- 
2.53.0

