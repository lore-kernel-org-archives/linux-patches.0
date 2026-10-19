Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE1C353AEAE;
	Mon, 19 Oct 2026 13:56:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418179; cv=none; b=ZfoxEg+TDmczzAImdFFtIfs4BLdZHJTYGNJFcSg7dL2SJdwobznve9t1QqGhzzzcIoSi2qRyqvPFj3pBF719rf274L0pyNmZpEslfAkZgr6nk/ifYGhVpZUZ2EYqH0xk2C15erjMtgzbstNzN48Mhb4Gw9pB5dXDhBB4gP0PfAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418179; c=relaxed/simple;
	bh=I2TXrsw0dwPSGyIu9U7do2aj1JyZTXoV56b9WsmD+r8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=POGE0lo69a2TqMcN+tEYAYSOcks91rGwcHagVfWt5z2CZ8rQwPYOnSoQEAtgU1Y6SA2wsD70szEH/CsWXkYsxRBB/M9rDgfjq1g56XdSjoRpUuZezQT0jc1370CgW2Kw9Ei0CN8ms/bEXdjsykR20PP22AA6gRvoSD+VIyPqeY4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=f/UJYnUX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="f/UJYnUX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBFD21F000C4;
	Mon, 19 Oct 2026 13:56:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418175;
	bh=++C4Wsz8QikOVQXgFYChxoV4NuDK+ohvb+u2XY/cVT0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=f/UJYnUXXuXQM2k7DSJHtaYguc3SzGP84gXGYKhF1rYSCcEiUpHTJ1zs6BR0C17xW
	 QFFC9mmUqsN59z7cAd837VqHx3t9QYevjWOnrc2EKpZR/CpOQSbvYOkT3crKKwSka0
	 d7h0F1fsvgtYF26fP30zUg2Giy0CNwTKcIpV4zSuLMKesIoKOka5u9qid8ET9Cr78L
	 duApeSLfQpMlWQeTtXhVcJxhMBIkyr4k2tYzh6D0ld6QAh/8IubRaYhcx8ExQUSD/t
	 WLJR3Jntx1Td63IqwecvGMvhBNDlPISbWp2IkdiwzGjXnk5t30K9aIbsQFkTBeqYAG
	 wBfmavr5E5+Kw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>,
	jikos@kernel.org,
	bentiss@kernel.org,
	linux-input@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] HID: rmi: check report length before trimming sentinel bytes
Date: Mon, 19 Oct 2026 09:45:57 -0400
Message-ID: <20261019135441.1420968-66-sashal@kernel.org>
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

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit 28a3e326fad2451bdb66b747dd1f7ccbb900eed6 ]

rmi_check_sanity() trims trailing 0xff sentinel bytes, but its loop
reads data[valid_size - 1] before checking that valid_size is non-zero.

Reverse the condition so the length is proved before the last byte is
inspected.

Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The local tree is **pending-6.12** (`6.12.111`). The buggy
`rmi_check_sanity()` loop is still present, the one-line short-circuit
reorder is not an ancestor of HEAD, and the patch applies here with only
a line-number offset.

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

**Step 1.1: PARSE THE SUBJECT LINE**
Record: **[HID: rmi]** **[check]** check report length before trimming
sentinel bytes. Same class of wording as other HID length-check fixes:
the length must be proved before `data[valid_size - 1]` is read.

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**
Record:
- Signed-off-by: Pengpeng Hou \<pengpeng@iscas.ac.cn\> (author)
- Signed-off-by: Jiri Kosina \<jkosina@suse.com\> (HID maintainer)
- No Fixes:, Reported-by, Tested-by, Reviewed-by, Acked-by, Link:, or
  Cc: stable (absence is expected for this review pipeline)
- Ignore any pipeline “Upstream commit” / Sasha Levin SOB markers

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**
Record:
- Bug: `rmi_check_sanity()` trims trailing `0xff` sentinels but
  evaluates `data[valid_size - 1]` before `valid_size > 0`.
- Symptom: one-byte out-of-bounds read when the loop has already trimmed
  the buffer to length 0.
- Root cause: C `&&` is left-to-right; the original order does the index
  first.
- No stack traces, syzbot IDs, or version list in the message.
- Introducer (from git, not the message): `5b65c2a029664` (“HID: rmi:
  check sanity of the incoming report”, 2014-09-10), first tagged
  `v3.18-rc1`.

**Step 1.4: DETECT HIDDEN BUG FIXES**
Record: Not a disguised cleanup. It is an explicit short-circuit-order
OOB fix. The `valid_size > 0` test was already there; it was just on the
wrong side of `&&`.

===============================================================
PHASE 2: DIFF ANALYSIS - LINE BY LINE
===============================================================

**Step 2.1: INVENTORY THE CHANGES**
Record:
- File: `drivers/hid/hid-rmi.c` (1 insertion, 1 deletion)
- Function: `rmi_check_sanity()`
- Scope: single-file, one-line surgical fix

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**
Record:
- Before: `while ((data[valid_size - 1] == 0xff) && valid_size > 0)` —
  when `valid_size` is 0, `data[-1]` is still read.
- After: `while (valid_size > 0 && data[valid_size - 1] == 0xff)` — the
  subscript is not evaluated on an empty buffer.
- Path: runtime HID `raw_event` input, not probe/error-only.

**Step 2.3: IDENTIFY THE BUG MECHANISM**
Record: **Memory safety / OOB read.** HID core rejects a zero-length
report (`hid_input_report()` returns if `!size`), so the realistic
trigger is trimming an all-`0xff` (or fully trailing-`0xff`) report down
to 0, then doing one more iteration. That is the exact Dell XPS 13 9333
bus-sentinel case this helper was written for. One OOB byte is compared
to `0xff` and discarded; it is not copied to userspace, so this is not
an info leak, but it is still undefined-behavior / KASAN-class.

**Step 2.4: ASSESS THE FIX QUALITY**
Record: Obviously correct C short-circuit reorder. No API, locking, or
control-flow change beyond skipping the illegal index. Regression risk
is negligible. `rmi_raw_event()` already drops `size < 2` after this
call.

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

**Step 3.1: BLAME THE CHANGED LINES**
Record: Line 389 blamed to `5b65c2a029664` (Benjamin Tissoires,
2014-09-10). Present since **v3.18-rc1**. Long-lived in this 6.12 tree.

**Step 3.2: FOLLOW THE FIXES: TAG**
Record: No Fixes: tag. Introducer confirmed via blame: `5b65c2a029664`
is an ancestor of HEAD.

**Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**
Record:
- Candidate SHA on master: `28a3e326fad2451bdb66b747dd1f7ccbb900eed6`
  (author date 2026-06-30, committer 2026-08-03). `git merge-base --is-
  ancestor` vs HEAD: **not in this tree**.
- Related later commit already here: `ab2958e0c94ed` / upstream
  `183da103022ec` “HID: rmi: fix OOB access with undersized RMI reports”
  — probe-time report-size clamps and copy bounds. **Does not change
  this loop.**
- Standalone one-line patch, not “X/Y”.

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**
Record: Pengpeng Hou is not the HID maintainer. Jiri Kosina applied it.
No other hid-rmi commits from this author in this checkout.

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**
Record: None. Same `while` line exists here. `git apply --check` of
`28a3e326fad24` succeeded (hunk offset 21 from the later OOB patch).

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**
Record:
- `b4 dig -c 28a3e326fad24`:
  https://patch.msgid.link/2026063007016439.1-ccfa108-0006-HID-rmi-
  check-report-length-pengpeng@iscas.ac.cn
- `b4 dig -a`: **v1 only** (2026-06-30).
- Thread (3 messages): submission; Sashiko bot flagging **unrelated pre-
  existing** read/write OOB in `rmi_hid_{read,write}_block` (later the
  undersized-report patch already in this tree); Jiri Kosina “Applied,
  thanks.” (2026-08-03).
- No NAK. No reviewer asked for Cc: stable.

**Step 4.2: CHECK WHO REVIEWED THE PATCH**
Record (`b4 dig -w`): To Jiri Kosina and Benjamin Tissoires; Cc linux-
input and linux-kernel. HID maintainers were on the original To: line.

**Step 4.3: SEARCH FOR THE BUG REPORT**
Record: No syzbot/bugzilla link on this patch. The sentinel behavior
itself is documented in-tree and in `5b65c2a029664` (Red Hat bugzilla
1123584 for Dell XPS 13 9333). That is the hardware path that can fill a
report with `0xff` and drive this loop to length 0.

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**
Record: Standalone. Sibling OOB work (`HID: rmi: fix OOB access with
undersized RMI reports`) is already on pending-6.12 and does not subsume
this change.

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**
Record: **UNVERIFIED** — `lore.kernel.org/stable/?q=...` returned HTTP
403. No evidence in the linux-input thread that stable was discussed or
rejected.

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

**Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF**
Record: `rmi_check_sanity()` only.

**Step 5.2: TRACE CALLERS**
Record: Sole caller is `rmi_raw_event()` (`drivers/hid/hid-rmi.c`),
registered as `.raw_event`. HID core `hid_input_report()`
(`drivers/hid/hid-core.c`) calls it after rejecting empty reports and
resolving a valid `hid_report`. hid-rmi has no `report_table`, so
`hid_match_report()` matches all reports. `rmi_raw_event()` then
requires `RMI_DEVICE` (set after probe validates RMI report IDs).

**Step 5.3: TRACE CALLEES**
Record: The function only indexes `data[]` and decrements `valid_size`.
No alloc/lock/I/O.

**Step 5.4: FOLLOW THE CALL CHAIN**
Record: USB/i2c HID interrupt → `hid_input_report()` → `rmi_raw_event()`
→ `rmi_check_sanity()`. Reachable from Synaptics RMI touchpads
(`HID_GROUP_RMI` in `hid_scan_report()`, plus specific USB IDs: Razer
Blade, Lenovo X1 cover, Primax, Acer Switch). Unprivileged USB can also
feed HID reports. Userspace-reachable: **yes** (device I/O, not a
syscall that crafts the buffer directly).

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**
Record: Only this loop in hid-rmi. Same-tree HID length checks already
backported include `HID: lg4ff: validate report length before fixed
offsets` and `HID: wacom: validate report length in
wacom_intuos_pro2_bt_irq`.

===============================================================
PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
===============================================================

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**
Record: **Yes.** `drivers/hid/hid-rmi.c` lines 389–390:
`while ((data[valid_size - 1] == 0xff) && valid_size > 0)`. Introduced
v3.18, still here on 6.12.111. Candidate `28a3e326fad24` is **not** an
ancestor of HEAD.

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**
Record: Clean apply with +21 line offset. No refactor of this helper.

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**
Record: `ab2958e0c94ed` is a different OOB (report descriptor / copy
length). It does not reorder this condition. No earlier equivalent of
this one-liner.

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

**Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY**
Record: **HID / hid-rmi** (Synaptics RMI4 over i2c-hid/usbhid).
**IMPORTANT** for laptops with Synaptics HID touchpads; not mm/VFS core,
but not staging/obscure either.

**Step 7.2: ASSESS SUBSYSTEM ACTIVITY**
Record: hid-rmi is mature (2014+). Recent churn is security-style OOB
hardening, not a rewrite of this path.

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

**Step 8.1: DETERMINE WHO IS AFFECTED**
Record: Driver-specific: CONFIG_HID_RMI / Synaptics RMI HID devices
(common on some Dell/Lenovo/Acer laptops). Also any malicious HID gadget
bound as hid-rmi.

**Step 8.2: DETERMINE THE TRIGGER CONDITIONS**
Record: A report whose remaining bytes are all `0xff` (documented XPS 13
9333 bus glitch, or a device sending that pattern). After the last
decrement, `valid_size == 0` and the next condition still reads
`data[-1]`. Not every report; it is the sentinel path this function
exists to handle. Physical HID access required; not a random
unprivileged syscall.

**Step 8.3: DETERMINE THE FAILURE MODE SEVERITY**
Record: One-byte heap underflow read. Typical result: KASAN report;
crash only if that byte is unmapped (uncommon for kmalloc). Not data
corruption. **Severity: HIGH** for memory safety / HID attack surface,
not a guaranteed panic.

**Step 8.4: CALCULATE RISK-BENEFIT RATIO**
Record:
- Benefit: stops a real OOB on a long-lived, hardware-motivated path; 1
  line.
- Risk: very low (boolean operand swap).
- Ratio: strongly in favor of backport.

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

**Step 9.1: COMPILE THE EVIDENCE**

FOR:
- Real OOB; the `> 0` check was present but evaluated too late.
- Trigger matches the in-tree Dell XPS sentinel comment, not a
  hypothetical size=0 from HID core.
- Code has been in this tree since v3.18.
- 1-line, obviously correct; HID maintainer applied v1 as-is.
- Applies cleanly; no prerequisites.
- Same class as other HID length-check stable backports already on this
  branch.

AGAINST:
- No Fixes:/Cc: stable/syzbot (not a negative under these rules).
- Single-byte read, not a demonstrated oops or leak.
- Affects hid-rmi users, not every machine.

UNRESOLVED:
- Could not search lore.kernel.org/stable (HTTP 403).

**Step 9.2: APPLY THE STABLE RULES CHECKLIST**
1. Obviously correct and tested? **PASS** — C short-circuit; applied by
   Jiri Kosina.
2. Fixes a real bug that affects users? **PASS** — OOB on the sentinel-
   trim path this driver documents.
3. Important issue? **PASS** — memory-safety OOB on HID input (HIGH, not
   a guaranteed panic).
4. Small and contained? **PASS** — 1 line, one function.
5. No new features or APIs? **PASS**.
6. Can apply to the local tree? **PASS** — buggy line present; `git
   apply --check` succeeded.

**Step 9.3: CHECK FOR EXCEPTION CATEGORIES**
Record: None. Ordinary small bugfix.

**Step 9.4: MAKE YOUR DECISION**
This belongs on **this** 6.12 tree: the bug exists here, the later
undersized-report patch does not fix it, and the change is a one-line
operand swap with no API or locking impact.

===============================================================
What the commit solves for stable users
===============================================================
`rmi_check_sanity()` is supposed to strip trailing `0xff` filler from
Synaptics HID reports. Because `&&` evaluates left-to-right, an all-
sentinel report is trimmed to length 0 and then still reads `data[-1]`.
Laptop touchpads that hit that bus glitch, and USB HID devices that send
the same pattern, can fire a KASAN OOB on every such report. Reordering
the condition makes the existing length check actually protect the
index.

Risk vs benefit: benefit is a real memory-safety hole on a driver
already receiving other OOB backports; risk is a one-line boolean
reorder. No dependencies beyond code that has been here since v3.18.

===============================================================
Verification
===============================================================
- [Phase 1] Parsed subject/body/tags: no Fixes/Reported-by/Cc: stable;
  SOBs Hou + Kosina.
- [Phase 2] Diff: 1 line in `rmi_check_sanity()`; operand order only.
- [Phase 3] `git describe HEAD` / Makefile: **pending-6.12, 6.12.111**.
- [Phase 3] `git blame -L 379,410 -- drivers/hid/hid-rmi.c`: introducer
  `5b65c2a029664` (v3.18-rc1).
- [Phase 3] `git merge-base --is-ancestor 5b65c2a029664 HEAD`: yes;
  `28a3e326fad24`: **no**.
- [Phase 3] Current file still has `while ((data[valid_size - 1] ==
  0xff) && valid_size > 0)`.
- [Phase 3] Related `ab2958e0c94ed` already in tree; does not touch this
  loop.
- [Phase 3] `git show 28a3e326fad24 | git apply --check`: hunk succeeded
  at offset 21.
- [Phase 4] `b4 dig -c 28a3e326fad24`: lore msgid
  `2026063007016439.1-ccfa108-...`; To: Kosina + Tissoires.
- [Phase 4] `b4 dig -a`: v1 only; Kosina “Applied, thanks.”
- [Phase 4] Mbox: Sashiko comments are about other pre-existing OOBs,
  not this line.
- [Phase 5] Callers: `rmi_raw_event` ← `hid_input_report`; empty `size`
  rejected at hid-core.c:2111–2115.
- [Phase 6] Bug present; apply clean; no duplicate fix.
- [Phase 8] Failure mode: 1-byte OOB read on all-`0xff` reports; HID
  input path.
- UNVERIFIED: stable@ lore search (HTTP 403).

**YES**

 drivers/hid/hid-rmi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hid/hid-rmi.c b/drivers/hid/hid-rmi.c
index d55a0388895fb..ecc19387f6b05 100644
--- a/drivers/hid/hid-rmi.c
+++ b/drivers/hid/hid-rmi.c
@@ -386,7 +386,7 @@ static int rmi_check_sanity(struct hid_device *hdev, u8 *data, int size)
 	 * such reports here.
 	 */
 
-	while ((data[valid_size - 1] == 0xff) && valid_size > 0)
+	while (valid_size > 0 && data[valid_size - 1] == 0xff)
 		valid_size--;
 
 	return valid_size;
-- 
2.53.0

