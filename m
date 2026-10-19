Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B68986031AE;
	Mon, 19 Oct 2026 14:03:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418589; cv=none; b=WKg9gkbW99OOVj+1lYpW1dtqZEl3But12wAzOQfJ2gY5iGdIla+3g950uE+ECI+BMhxhdjCblSQDOw4RdsIYLY7lOLRfDXL5/3IlzWRr7sZ7wljymECLQ/HbQ4JddAkU5tuKIzMjgI6GV3HddBCSLKWXBX7oxXNdcwsfBf8Ij10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418589; c=relaxed/simple;
	bh=uZZktAR7v7UA3PVr5ZWZytbVS+DohQChro9MPtbC6Ss=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gx6S/vtNA8c9+WpgK5p7PnynJjGAe1NDluubrP24nKlkY8ZnAlzOzKJnzJ5XXR2RN9m5BcAJhlqiiE3eWbS2KD0ceR9hrSx0uVYc7aUtsFlB6hr+2/4W+UQDTjxKHIuYKcoC9j2+xDcfAWkoJuvV61CenRofaK0xeQBzylwdUzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CnGC6lE+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CnGC6lE+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D36171F000C5;
	Mon, 19 Oct 2026 14:03:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418586;
	bh=UrBoKXgdFjbvBi2S4ldc/8m0a8SdpCOAMv6qxac9ozI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CnGC6lE++FOrkhZGyA/2fgTb16i9QPkYBjcB/qGDZIv+Btx9V119Rv7J0s5mVyBXx
	 KZ3tmoT6zQVoSpnHDwmvScVu2SfDRP2VdfziH+85m/IzHhd77QEw0gzqh/1j7If38x
	 PSvN6xVZr4IoiL+5tYmgGFHxNnYZXGmJl14bZp4CL9hz/LShnPpAGheCAUTusYggUg
	 KAdQ3oMbHNsTn6ShqOZ/g74bdgy2UcoW2II9ImuyNpaNJ37wQVSPcmMC+jLGeNwZ2/
	 1UKJahzNNXU9B7gaxTSQqyfVw31haoZV77GC0DelNV1MsnnUJaxoXS5oU1Atf/l4L/
	 /JtpeF+m9sMrg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Oliver Neukum <oneukum@suse.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>,
	linux-usb@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] usb: misc: cypress_cy7c63: check result of IO
Date: Mon, 19 Oct 2026 09:50:44 -0400
Message-ID: <20261019135441.1420968-353-sashal@kernel.org>
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

From: Oliver Neukum <oneukum@suse.com>

[ Upstream commit 0673b919e0933541ae56bb3f0253853f696d3773 ]

If the device returns a bogus short read, treat it as EIO.
Actually check for IO errors.

Signed-off-by: Oliver Neukum <oneukum@suse.com>
Link: https://patch.msgid.link/20260710095523.1646308-1-oneukum@suse.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The local tree is mainline **7.3.0-rc4** (`v7.3-rc4-27-gf0100363d8c37`).
The Cypress driver and the incomplete short-transfer check are present
here; the follow-up I/O-error handling is a real, small correctness fix.

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

Step 1.1: PARSE THE SUBJECT LINE
Record: **[usb/misc/cypress_cy7c63] [check] check result of IO**
- Subsystem: `usb: misc: cypress_cy7c63`
- Verb: “check” — correctness / missing return-value handling, not a
  refactor

Step 1.2: PARSE ALL COMMIT MESSAGE TAGS
Record:
- `Signed-off-by: Oliver Neukum <oneukum@suse.com>` (author; known USB
  developer)
- `Link:
  https://patch.msgid.link/20260710095523.1646308-1-oneukum@suse.com`
- `Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>` (USB
  maintainer)
- No `Fixes:`, `Reported-by:`, `Tested-by:`, `Reviewed-by:`, `Acked-
  by:`, or `Cc: stable` (absence of the last two is expected for this
  review)
- Not syzbot, not a user crash report

Step 1.3: ANALYZE THE COMMIT BODY TEXT
Record:
- Bug: a short USB control read is not treated as failure; I/O errors
  are not checked on the sysfs read path
- Symptom: userspace can see a successful sysfs write, or a stale port
  value on sysfs read, after a failed/short transfer
- Root cause: `usb_control_msg()` may return `0`/`1` (short success) or
  a negative errno; `vendor_command()` used to return those short
  lengths as success, and `read_port()` never tested the result
- No version range given

Step 1.4: DETECT HIDDEN BUG FIXES
Record: Not hidden. The subject and body state the bug. It completes the
earlier short-transfer check (`49cd2f4d747ee`, which *was* `CC:
stable`).

===============================================================
PHASE 2: DIFF ANALYSIS - LINE BY LINE
===============================================================

Step 2.1: INVENTORY THE CHANGES
Record:
- File: `drivers/usb/misc/cypress_cy7c63.c` — **+6 / −2** (8 lines in
  the diff)
- Functions: `vendor_command()`, `read_port()`
- Scope: single-file surgical fix

Step 2.2: UNDERSTAND THE CODE FLOW CHANGE
Record:
1. `vendor_command()`: after `usb_control_msg()`, `if (retval < 2) goto
   err_buf` already skipped storing `iobuf[1]`, but still returned `0`
   or `1`. Now a non-negative short result becomes `-EIO`.
2. `read_port()`: used to `sprintf()` `cyp->port[port_num]` even when
   `vendor_command()` failed. Now `result < 0` is returned to sysfs.

`write_port()` already did `return result < 0 ? result : count`, so the
`-EIO` conversion is what makes short writes fail instead of reporting
`count`.

Step 2.3: IDENTIFY THE BUG MECHANISM
Record:
- Category: **logic / correctness** (USB I/O result handling; short
  transfer → `-EIO`)
- Mechanism: `usb_control_msg()` returns transferred byte count on
  success (kernel-doc in `drivers/usb/core/message.c`). A 0- or 1-byte
  IN was treated as success. `read_port()` ignored errors and returned
  the last cached port byte (or 0).

Step 2.4: ASSESS THE FIX QUALITY
Record:
- Obviously correct and the usual USB pattern (same shape as other
  short-control-msg fixes)
- Minimal; no API/lock/structure changes
- Regression risk: **very low** (error path only; successful ≥2-byte
  transfers unchanged)

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

Step 3.1: BLAME THE CHANGED LINES
Record:
- Driver added **2006-06-22**, `9189bfc2df0fd` (Oliver Bock)
- Short-transfer skip: **2024-09-12**, `49cd2f4d747ee` (Oliver Neukum),
  contained in `v6.12-rc1`, **`CC: stable@vger.kernel.org`**
- `read_port()` never checked `result` from 2006 until this commit
- This follow-up: `0673b919e0933` (2026-07-10 / applied 2026-07-17)

Step 3.2: FOLLOW THE FIXES: TAG
Record: No `Fixes:` tag. Related buggy/incomplete commit is
`49cd2f4d747ee`, which **is** an ancestor of this HEAD (`git merge-base
--is-ancestor` exit 0). That patch stopped using a short buffer but
still returned a positive short length.

Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES
Record: Recent file history is this I/O-check pair plus unrelated
alloc/ref cleanups. Standalone follow-up to `49cd2f4d747ee`, not patch
2/N of a larger series. No later commits on this file after
`0673b919e0933`.

Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS
Record: Oliver Neukum is a regular USB contributor; he wrote both
Cypress I/O checks. Other `drivers/usb/misc/` work is race/error
handling in iowarrior/yurex/chaoskey. USB subsystem maintainer who
applied this is Greg Kroah-Hartman.

Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS
Record: Depends on the `if (retval < 2) goto err_buf` block from
`49cd2f4d747ee`. That commit is in this tree. The patch applies as a
small edit of that check plus two lines in `read_port()`. Standalone on
this tree.

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION
Record:
- `b4 dig -c 0673b919e0933` →
  https://patch.msgid.link/20260710095523.1646308-1-oneukum@suse.com
- `b4 dig -a`: single **v1**, 2026-07-10; no v2/v3
- Saved mbox: **one message** (the patch). No replies, no NAK, no
  reviewer `Cc: stable`
- Direct lore fetch returned HTTP 403; discussion is from the mbox
  instead

Step 4.2: CHECK WHO REVIEWED THE PATCH
Record (`b4 dig -w`): To/Cc included Greg Kroah-Hartman, linux-usb,
Johan Hovold (`johan@kernel.org`), Kees Cook, original driver contacts.
No on-list review comments; Greg applied it.

Step 4.3: SEARCH FOR THE BUG REPORT
Record: No `Reported-by` / bugzilla / syzbot. Author-driven completeness
of the 2024 short-transfer fix.

Step 4.4: CHECK FOR RELATED PATCHES AND SERIES
Record: Same-week USB work by the author is unrelated (`USB: core:
ratelimit cabling message`). Related historical patch is `49cd2f4d747ee`
only.

Step 4.5: CHECK STABLE MAILING LIST HISTORY
Record: lore.kernel.org/stable search was not readable (403). Unverified
whether stable@ already discussed this SHA. The 2024 sibling *was*
explicitly nominated for stable.

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

Step 5.1: IDENTIFY KEY FUNCTIONS
Record: `vendor_command()`, `read_port()` (callers of the latter:
`port0_show` / `port1_show`). `write_port()` is not edited but consumes
the new `-EIO`.

Step 5.2: TRACE CALLERS
Record:
- `vendor_command()` ← `write_port()` (sysfs store port0/port1),
  `read_port()` (sysfs show)
- `read_port()` ← `port0_show`, `port1_show`
- Context: process / sysfs, not IRQ. Reachable from userspace on a bound
  device.

Step 5.3: TRACE CALLEES
Record: `kzalloc`, `usb_rcvctrlpipe`, `usb_control_msg`, `kfree`;
`read_port` also `sprintf`. Control pipeline 0, vendor IN, 8-byte max.

Step 5.4: FOLLOW THE CALL CHAIN
Record: userspace `cat`/`echo` on sysfs `port0`/`port1` → show/store →
`vendor_command` → `usb_control_msg`. Yes, userspace-reachable. Requires
`CONFIG_USB_CYPRESS_CY7C63` and device `0x0a2c:0x0008`.

Step 5.5: SEARCH FOR SIMILAR PATTERNS
Record: Same short-read → `-EIO` pattern used elsewhere in USB (e.g.
historical `legousbtower` get-version check). This driver had the length
check without converting short success to an error.

===============================================================
PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
===============================================================

Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?
Record: Yes. File and functions exist; driver since 2006. Incomplete
`retval < 2` path from `49cd2f4d747ee` is an ancestor. `git merge-base
--is-ancestor 0673b919e0933 HEAD` is true (the candidate is already in
this mainline checkout). Pre-fix behavior is confirmed via `git show
0673b919e0933^:drivers/usb/misc/cypress_cy7c63.c`.

Step 6.2: CHECK FOR BACKPORT COMPLICATIONS
Record: **Clean apply** on this tree (already applied). Context matches
a typical stable driver file aside from unrelated later `kzalloc_obj` in
probe.

Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE
Record: `49cd2f4d747ee` is here; it is incomplete without this commit.
No other equivalent error-propagation fix.

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY
Record: **USB misc driver** (`drivers/usb/misc/cypress_cy7c63.c`),
`CONFIG_USB_CYPRESS_CY7C63`. Criticality: **PERIPHERAL** (AK Modul-Bus
CY7C63xxx I/O). USB core is not changed.

Step 7.2: ASSESS SUBSYSTEM ACTIVITY
Record: File is mature/low-churn (2006 driver; occasional USB-wide
cleanups). USB misc as a whole is actively maintained by Greg KH.

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

Step 8.1: DETERMINE WHO IS AFFECTED
Record: **Driver-specific / config-specific** — only users of this
Cypress device with the driver enabled.

Step 8.2: DETERMINE THE TRIGGER CONDITIONS
Record: Trigger is a failed or short vendor control IN while
reading/writing sysfs ports (disconnect, stall, timeout, non-compliant
firmware). Unprivileged users who can open the sysfs attrs of that
device can hit it. Not a boot-critical path.

Step 8.3: DETERMINE THE FAILURE MODE SEVERITY
Record:
- Failure: sysfs read returns stale/zero port data; sysfs write can
  return success on a short IN
- Not oops/UAF/deadlock
- Severity: **MEDIUM** — wrong userspace-visible I/O / false success,
  not kernel memory unsafety (buffer is `kzalloc`’d; `49cd2f4d747ee`
  already skipped storing a short payload)

Step 8.4: CALCULATE RISK-BENEFIT RATIO
Record:
- Benefit: medium for this hardware (correct errors instead of silent
  wrong GPIO-like values); low globally
- Risk: **very low** (6 lines, error paths only)
- Ratio: favorable — small completion of a prior stable-nominated fix

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

Step 9.1: COMPILE THE EVIDENCE
FOR:
- Real I/O-error bug: short `usb_control_msg` success (`0`/`1`) and
  ignored negative results on read
- `write_port()` already treats any non-negative result as success —
  without `-EIO`, a short transfer is a false success
- Completes `49cd2f4d747ee`, which went to stable with `CC: stable`
- Tiny (+6/−2), obviously correct, standard USB pattern
- Code has existed since 2006; prerequisite is in this tree
- Authored by a USB regular, applied by the USB maintainer

AGAINST:
- Niche driver, no user/syzbot report
- Not a crash, UAF, or security hole
- Author did not `Cc: stable` this time (not a veto per the rules above)

UNRESOLVED:
- lore HTTP 403; no on-list review text beyond the v1 patch
- Whether stable@ already queued this SHA

Step 9.2: APPLY THE STABLE RULES CHECKLIST
1. Obviously correct and tested? **PASS** — matches `usb_control_msg`
   semantics; applied by Greg KH
2. Fixes a real bug that affects users? **PASS** — sysfs can report
   success/stale port data after failed USB I/O
3. Important issue? **PASS** (medium) — incorrect device I/O / false
   success, in the “oh, that's not good” class; not a panic
4. Small and contained? **PASS** — 6 insertions, one file
5. No new features or APIs? **PASS**
6. Can apply to the local tree? **PASS** — prerequisite and target code
   are here

Step 9.3: CHECK FOR EXCEPTION CATEGORIES
Record: None (not an ID/quirk/DT/build/docs exception). It is a normal
small driver bugfix.

Step 9.4: MAKE YOUR DECISION
This should be backported. The 2024 short-transfer patch left callers
treating a short IN as success and left `read_port()` returning cached
data on any error. That is user-visible wrong I/O on a long-lived
driver, the fix is six lines, and the only dependency is already in this
tree.

What it solves for stable users: failed or truncated vendor control
transfers no longer look like a successful port read/write.

Risk vs benefit: very low risk, clear correctness gain on the error
path.

Concerns: niche hardware; no crash. That does not outweigh completing an
incomplete stable fix with a trivial, standard `-EIO` conversion.

Verification:
- [Phase 1] Parsed tags: Oliver Neukum SOB, Greg KH SOB, msgid Link; no
  Fixes/Reported-by/Cc:stable
- [Phase 1] Body: short read → EIO; actually check I/O errors
- [Phase 2] Diff: `vendor_command` maps `0 <= retval < 2` to `-EIO`;
  `read_port` returns `result` if `< 0`
- [Phase 2] Confirmed `write_port` uses `result < 0 ? result : count`
  (pre-patch parent file)
- [Phase 3] `git describe HEAD` / `make kernelversion`: **v7.3-rc4 /
  7.3.0-rc4**
- [Phase 3] `git merge-base --is-ancestor 0673b919e0933 HEAD`: yes
  (commit already in this tree)
- [Phase 3] blame: driver 2006 (`9189bfc2df0fd`); short check 2024
  (`49cd2f4d747ee`, CC:stable, v6.12-rc1)
- [Phase 3] `git show 49cd2f4d747ee`: added `if (retval < 2) goto
  err_buf` without `-EIO`
- [Phase 3] `git merge-base --is-ancestor 49cd2f4d747ee HEAD`: yes
- [Phase 3] `git log --oneline -20 --
  drivers/usb/misc/cypress_cy7c63.c`: this commit is latest on the file
- [Phase 4] `b4 dig -c/-a/-w/-m`: v1 only; recipients gregkh, linux-usb,
  johan, kees; mbox has no replies
- [Phase 4] WebFetch lore/msgid: 403 — discussion taken from b4 mbox
- [Phase 5] Callers: only `write_port`/`read_port` sysfs paths in this
  file (`rg vendor_command`)
- [Phase 5] `usb_control_msg` kernel-doc: success = byte count, else
  negative errno
- [Phase 6] Pre-image of `0673b919e0933^` matches the submitted hunk
  context
- [Phase 7] Kconfig `USB_CYPRESS_CY7C63`; MAINTAINERS USB SUBSYSTEM →
  Greg KH
- [Phase 8] Failure mode: stale sysfs port value / false write success,
  not oops
- UNVERIFIED: stable@ mailing-list archive (HTTP 403)

**YES**

 drivers/usb/misc/cypress_cy7c63.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/misc/cypress_cy7c63.c b/drivers/usb/misc/cypress_cy7c63.c
index 75f5a740cba39..e1a0c1ae93f2b 100644
--- a/drivers/usb/misc/cypress_cy7c63.c
+++ b/drivers/usb/misc/cypress_cy7c63.c
@@ -89,8 +89,11 @@ static int vendor_command(struct cypress *dev, unsigned char request,
 				 address, data, iobuf, CYPRESS_MAX_REQSIZE,
 				 USB_CTRL_GET_TIMEOUT);
 	/* we must not process garbage */
-	if (retval < 2)
+	if (retval < 2) {
+		if (retval >= 0)
+			retval = -EIO;
 		goto err_buf;
+	}
 
 	/* store returned data (more READs to be added) */
 	switch (request) {
@@ -175,8 +178,9 @@ static ssize_t read_port(struct device *dev, struct device_attribute *attr,
 	dev_dbg(&cyp->udev->dev, "READ_PORT%d called\n", port_num);
 
 	result = vendor_command(cyp, CYPRESS_READ_PORT, read_id, 0);
-
 	dev_dbg(&cyp->udev->dev, "Result of vendor_command: %d\n\n", result);
+	if (result < 0)
+		return result;
 
 	return sprintf(buf, "%d", cyp->port[port_num]);
 }
-- 
2.53.0

