Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C03224FFA3B;
	Mon, 19 Oct 2026 13:57:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418253; cv=none; b=QL/1lcRr6uyPmIL5nh6Z/HZJEK6y9zLbqHgwGYLSOJizaaaQyu+qzkuuvZUM3IdncCM0J+Amzu3WByC582zavphvYc1/RnnZCRQm+ZJiWHp1GRdf4XEy1NGDtEMftVpMVB6StpW7seJDe2RpSa3JCkkCMzw5fQic3KbK6UBXD9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418253; c=relaxed/simple;
	bh=9I6Qj3KGzI3Rj55mhFNfIEuedzmI3EHxt3iNOaGDPXg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UYfIprTcE2ApHLbSmZdbA4syEEnUYpCg0c3fK48IcrGGLEQ6SemovqUMwSCFzedK8e0MuqasBz6wEXfEUeCTaP2OXoFEDpO7os3GJWyVSvlC7ET64H/O+tyJ6OufKYgsWeZc0dQELDD14jq/wW1/la7vjtTQtT/uVBK1Av44j8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Hb3TYJgw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Hb3TYJgw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E18F81F000C4;
	Mon, 19 Oct 2026 13:57:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418250;
	bh=qHCip7GAWu4TxX5S5wZLFFEX1xL5XSXXVwerPQCjQPw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Hb3TYJgwDyGSi2hw04c8QIjGFZ0KQXwm4cX9j95C5t46BvC6Q5ZEbiQAYlTCPpGX5
	 ij0Lm1Rv2uPU4JOFxEObkbkcq16sEerJRUBk/TO2cabtelJLOkggSj67Vi/U9fQMiX
	 ymNytKlmx4lUobPBgcpFuZPI5HZsGWYXX+IxL5nNgnUamLP5q2hPBowbbpTVbCJRyA
	 wNLRtkf70RGwpovIl4YS3MvI8/C0qYOQ1ssV9EtZHVi65s3EyX+tcuZYH5N0GJayCG
	 Zx876hNCzn5fDvsPGer2nHC5zRaBN7/1aP5KmmsyCvfxyel6QMOxzaZJG+3orG598V
	 2aUU9n4mlNJgg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Yousef Alhouseen <alhouseenyousef@gmail.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>,
	keng-yu.lin@hpe.com,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] misc: hpilo: validate device queue entries before use
Date: Mon, 19 Oct 2026 09:46:50 -0400
Message-ID: <20261019135441.1420968-119-sashal@kernel.org>
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

From: Yousef Alhouseen <alhouseenyousef@gmail.com>

[ Upstream commit 7bf6940d7cf41f1f0330a9bae4b7a886e18fd8e3 ]

ilo_pkt_dequeue() trusts descriptor IDs and lengths read from the shared
FIFO entry. A bad entry can select a descriptor outside the allocated
queue memory or report a packet length larger than one descriptor.

Reject entries whose descriptor index or packet length exceeds the queue
layout before deriving the packet pointer returned to read and write
paths.

Signed-off-by: Yousef Alhouseen <alhouseenyousef@gmail.com>
Link: https://patch.msgid.link/20260624190919.3432-1-alhouseenyousef@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The local checkout is mainline **v7.3-rc4**. The hpilo driver has been
here since 2008, and this is a small bounds check on device-shared FIFO
fields used as a pointer and a copy length.

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

**Step 1.1: PARSE THE SUBJECT LINE**
Record: **[misc: hpilo:] [validate] [reject out-of-range device FIFO
descriptor IDs and packet lengths before use]**

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**
Record:
- Signed-off-by: Yousef Alhouseen \<alhouseenyousef@gmail.com\> (author)
- Link: https://patch.msgid.link/20260624190919.3432-1-
  alhouseenyousef@gmail.com
- Signed-off-by: Greg Kroah-Hartman \<gregkh@linuxfoundation.org\> (misc
  maintainer; applied the patch)
- No Fixes:, Reported-by:, Tested-by:, Reviewed-by:, Acked-by:, or Cc:
  stable (absence of Fixes/Cc:stable is expected for this review)
- Pipeline markers (Sasha Levin SOB / Upstream commit) are not treated
  as selection evidence

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**
Record:
- Bug: `ilo_pkt_dequeue()` uses descriptor ID and length from a FIFO
  shared with the HP iLO device with no bounds check.
- Symptom/failure mode: a bad ID indexes a descriptor outside the
  allocated queue; a bad length is larger than one descriptor. Those
  values feed `ilo_read()`/`ilo_write()`
  `copy_to_user`/`copy_from_user`.
- Version info: none in the message. The unvalidated path is from the
  original 2008 driver.
- Root cause (author): device-provided FIFO fields are trusted; the fix
  rejects ID ≥ `NR_QENTRY` or length > one descriptor before forming the
  packet pointer.

**Step 1.4: DETECT HIDDEN BUG FIXES**
Record: Not a disguised cleanup. It is an explicit missing-validation /
OOB fix.

===============================================================
PHASE 2: DIFF ANALYSIS - LINE BY LINE
===============================================================

**Step 2.1: INVENTORY THE CHANGES**
Record:
- File: `drivers/misc/hpilo.c` (+6 / −1)
- Function: `ilo_pkt_dequeue()`
- Scope: single-file surgical fix

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**
Record: After a successful `fifo_dequeue()`, the old code took `pkt_id =
get_entry_id(entry)` and used it as `desc + desc_mem_sz(pkt_id)`, and
passed `get_entry_len(entry)` out as `*len`. The new code stores the
length, returns 0 (dequeue failed) if `pkt_id >= NR_QENTRY` or `pkt_len
> desc_mem_sz(1)`, and only then fills `*id`/`*len`/`*pkt`. Normal path
for in-range entries is unchanged.

**Step 2.3: IDENTIFY THE BUG MECHANISM**
Record: **Memory safety / OOB (category d)** plus **logic correctness
(category g)**.
- `get_entry_id()` is a 12-bit field (0–4095). `NR_QENTRY` is 4.
  `desc_mem_sz(id)` is `id << 12`, so an ID of 5 already walks off the
  4×4KiB descriptor array; 4095 is a ~16MiB miss.
- `get_entry_len()` is a 10-bit qword count shifted by 3, so up to 8184
  bytes. One descriptor is 4096 bytes (`L2_QENTRY_SZ` 12). Recv
  descriptors sit at the end of the DMA allocation; a length of 8184 on
  the last slot reads/writes past `dma_size`.
- Callers: `ilo_read()` does `copy_to_user(buf, pkt, min(len,
  pkt_len))`; `ilo_write()` does `copy_from_user(pkt, buf, min(len,
  pkt_len))`. That is a host kernel OOB read or write, not just a bad
  error code.

**Step 2.4: ASSESS THE FIX QUALITY**
Record: The checks match the layout from `ilo_ccb_setup()` (`NR_QENTRY`
descriptors of `desc_mem_sz(1)`). Open-time recv enqueue uses
`desc_mem_sz(1)` exactly, and `>` (not `>=`) still allows a full
4096-byte packet. Zero-length send packets used at open still pass.
Regression risk on working firmware is low: in-range entries are
unchanged. One caveat: `fifo_dequeue()` already advanced the head, so a
rejected entry is dropped and not re-queued; that can shrink the 4-slot
queue until close/reopen. That is acceptable fail-closed behavior, not a
behavior change for valid hardware.

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

**Step 3.1: BLAME THE CHANGED LINES**
Record: Unvalidated dequeue is from **89bcb05d9bbf8** (“HP iLO driver”,
David Altobelli, 2008-07-02). Present since v2.6.27-era. The validation
lines are this commit.

**Step 3.2: FOLLOW THE FIXES: TAG**
Record: No Fixes: tag. Not applicable. The introducing commit is the
original driver, which is an ancestor of this tree.

**Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**
Record: Recent `drivers/misc/hpilo.c` work is device-number, class, DMA
API, and blacklist changes. No prerequisite refactor of the FIFO. After
this commit only a treewide `*_device_id` style change
(`f06bae4ddc70d`). Standalone.

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**
Record: Author is not the hpilo maintainer (that is Keng-Yu Lin, HPE,
MAINTAINERS “Supported”). Same-day misc validation patches include
ibmvmc, xilinx_sdfec, bcm-vk, fastrpc — part of a large audit flood.
That is a quality-process note, not a substitute for reading this diff.
Greg Kroah-Hartman still applied this one.

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**
Record: Uses existing `NR_QENTRY`, `desc_mem_sz()`, `get_entry_id()`,
`get_entry_len()`. No new helpers. Applies standalone.

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**
Record: `b4 dig -c 7bf6940d7cf41` →
https://patch.msgid.link/20260624190919.3432-1-alhouseenyousef@gmail.com
- `b4 dig -a`: single v1, no later revisions
- lore.kernel.org fetches returned 403; body confirmed via openwall and
  lkml.iu.edu mirrors
- LKML index for late June 2026 lists the submission and **no** “Re:”
  for this hpilo patch (no NAK, no Cc: stable suggestion, no review
  thread)

**Step 4.2: CHECK WHO REVIEWED THE PATCH**
Record: `b4 dig -w` recipients: Keng-Yu Lin (hpilo maintainer), Arnd
Bergmann, Greg Kroah-Hartman, linux-kernel. No Reviewed-by/Acked-by on
the commit. Greg’s SOB is the apply-to-char-misc path.

**Step 4.3: SEARCH FOR THE BUG REPORT**
Record: No Reported-by, syzbot, bugzilla, or CVE in the commit or the
submission. Issue is identified by code inspection of the shared FIFO.

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**
Record: Standalone `[PATCH]`, not `n/m`. Same-day author flood of
similar bounds checks; this patch does not depend on those.

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**
Record: UNVERIFIED for stable@ lore (HTTP 403). No evidence in the v1
mail that anyone nominated or rejected it for stable.

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

**Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF**
Record: `ilo_pkt_dequeue()` only.

**Step 5.2: TRACE CALLERS**
Record (from `drivers/misc/hpilo.c`):
- `ilo_ccb_verify()` — open path, SENDQ, uses id only
- `ilo_read()` — `read(2)` on `/dev/hpilo/dXccbN`, RECVQ, uses id, len,
  pkt
- `ilo_write()` — `write(2)`, SENDQ, uses id, len, pkt

**Step 5.3: TRACE CALLEES**
Record: `fifo_dequeue()` (consumes a C-bit entry under `fifo_lock`),
`get_entry_id()`, `get_entry_len()`, `desc_mem_sz()`.

**Step 5.4: FOLLOW THE CALL CHAIN**
Record: Userspace `read`/`write` on the char device → dequeue → copy.
FIFO payload is written by iLO firmware in shared DMA memory, then
marked consumed. An unprivileged process cannot poke FIFO fields
directly; it needs the device node **and** a bad/malicious iLO entry. On
ProLiant this driver is used by host management agents. Reachable in
production, not a dead path.

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**
Record: This is the only dequeue that turns FIFO id/len into a host
pointer and copy size. No sibling copy of the same bug in this driver.

===============================================================
PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
===============================================================

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**
Record: Yes. Tree is **v7.3-rc4** (`7.3.0-rc4`, HEAD `f0100363d8c37`).
`drivers/misc/hpilo.c`/`hpilo.h` are present. `CONFIG_HP_ILO` exists.
Unvalidated dequeue is from 89bcb05d9bbf8 (2008). `git merge-base --is-
ancestor 7bf6940d7cf41 HEAD` is true — this checkout already contains
the fix because it is mainline after the char-misc merge, not because
the bug is absent.

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**
Record: Expected apply: **clean**. `ilo_pkt_dequeue()` around the
dequeue site matches the parent of 7bf6940d7cf41 aside from this hunk.
No conflicting local churn.

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**
Record: No earlier equivalent bounds check. This commit is the fix.

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

**Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY**
Record: **drivers/misc/hpilo** — HP iLO CHIF channel on ProLiant.
Criticality: **PERIPHERAL** for generic desktops, **IMPORTANT** for HP
enterprise servers that use `/dev/hpilo` (common on LTS/distro kernels).
Not mm/net/fs core.

**Step 7.2: ASSESS SUBSYSTEM ACTIVITY**
Record: Mature, low-churn driver (2008), still Supported by HPE. Bug is
long-standing, not a brand-new API.

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

**Step 8.1: DETERMINE WHO IS AFFECTED**
Record: **driver-specific / config-specific** (`CONFIG_HP_ILO`, PCI
iLO). HP ProLiant hosts running management userspace.

**Step 8.2: DETERMINE THE TRIGGER CONDITIONS**
Record: Dequeue of a FIFO entry whose id or length is out of layout. The
device is expected to update recv length; a firmware length bug is the
realistic trigger. Malicious/compromised BMC is the security trigger.
Not a hot every-syscall path for machines without iLO. Unprivileged
users cannot inject FIFO fields without the device and a bad iLO entry.

**Step 8.3: DETERMINE THE FAILURE MODE SEVERITY**
Record: Kernel OOB read (`copy_to_user` in `ilo_read`) or OOB write
(`copy_from_user` in `ilo_write`) → oops, info leak, or memory
corruption. **Severity: HIGH** (crash/corruption; security-relevant if
firmware is untrusted). Not a guaranteed unprivileged LPE by itself.

**Step 8.4: CALCULATE RISK-BENEFIT RATIO**
Record:
- Benefit: **high for iLO users** — prevents host OOB from a bad FIFO
  entry on a long-lived production driver.
- Risk: **very low** — 6 lines, fail-closed, no API/lock/structure
  change; valid packets unaffected.
- Ratio: benefit outweighs risk.

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

**Step 9.1: COMPILE THE EVIDENCE**

FOR:
- Real missing bounds check on device-shared FIFO id/len used as pointer
  and copy length (verified in `ilo_read`/`ilo_write`).
- Failure mode is kernel OOB, not cosmetic.
- Driver and bug exist in this tree since 2008.
- 6-line, obviously correct check matching `NR_QENTRY` and
  `desc_mem_sz(1)`.
- No prerequisites; clean apply.
- Greg KH applied it; HPE maintainer was on Cc.
- HP iLO is real hardware on enterprise stable kernels.

AGAINST:
- No user report, syzbot, or CVE.
- Author is not the subsystem maintainer; patch is from a large same-day
  “validate X” sweep.
- No mailing-list review comments found.
- Official stable text dislikes unexplained “this could be a problem”
  issues; trigger depends on firmware producing a bad entry.
- Rejected entries are consumed and not recycled (queue-slot leak until
  reopen) — only if the device already posted garbage.

UNRESOLVED:
- Full lore.kernel.org / stable@ thread fetch (403).
- Whether Keng-Yu Lin privately acked (no Acked-by on the commit).

**Step 9.2: APPLY THE STABLE RULES CHECKLIST**
1. Obviously correct and tested? **PASS** — layout math matches the
   allocator; Greg merged it. No extra Tested-by.
2. Fixes a real bug that affects users? **PASS** — unchecked device
   length/index on the read/write path. Not style.
3. Important issue (crash, security, corruption, deadlock)? **PASS** —
   OOB copy, oops/corruption; HIGH not a soft lockup.
4. Small and contained? **PASS** — +6/−1, one function.
5. No new features or APIs? **PASS**.
6. Can apply to the local tree? **PASS** — same `ilo_pkt_dequeue()`
   structure; driver present.

**Step 9.3: CHECK FOR EXCEPTION CATEGORIES**
Record: None (not a device ID, quirk, DT, build, or doc-only change).
Qualifies as a normal small memory-safety fix.

**Step 9.4: MAKE YOUR DECISION**
This tree has the hpilo char device and the long-standing unvalidated
dequeue. The patch stops a bad device FIFO entry from becoming a kernel
pointer/length for `copy_{to,from}_user`. That is a real, contained OOB
fix with negligible regression risk on working iLO firmware. It meets
the stable rules for this checkout.

Verification:
- [Phase 1] Tags: author SOB, Link msgid, Greg KH SOB; no
  Fixes/Reported-by/Cc:stable
- [Phase 2] Diff: +6/−1 in `ilo_pkt_dequeue()`; reject `pkt_id >= 4` or
  `pkt_len > 4096`
- [Phase 2] Callers: `ilo_read` copy_to_user, `ilo_write`
  copy_from_user, `ilo_ccb_verify`
- [Phase 2] Bitfields: ID 12 bits (0–4095), len up to 8184, descriptor
  4096, `NR_QENTRY` 4
- [Phase 3] git blame: buggy dequeue from 89bcb05d9bbf8 (2008)
- [Phase 3] git log -- drivers/misc/hpilo.c: no FIFO refactor
  prerequisite; no follow-up fix
- [Phase 3] Author also submitted ibmvmc/xilinx_sdfec/bcm-vk validation
  patches; not hpilo maintainer
- [Phase 4] b4 dig: v1 only, lore msgid 20260624190919.3432-1; To/Cc
  includes Keng-Yu Lin, Arnd, Greg
- [Phase 4] openwall + lkml.iu.edu: patch body matches commit; no public
  Re: for hpilo
- [Phase 4] lore.kernel.org WebFetch: 403 — UNVERIFIED beyond mirrors
- [Phase 5] Call chain: userspace read/write on `/dev/hpilo/dXccbN`
  after device marks FIFO consumed
- [Phase 6] git describe HEAD: v7.3-rc4-27-gf0100363d8c37; kernelversion
  7.3.0-rc4
- [Phase 6] merge-base --is-ancestor 7bf6940d7cf41 HEAD: yes (fix
  already on this mainline checkout)
- [Phase 6] Parent of fix: unvalidated `ilo_pkt_dequeue()` still in
  7bf6940d7cf41^
- [Phase 7] MAINTAINERS: HEWLETT PACKARD ENTERPRISE ILO CHIF DRIVER,
  Keng-Yu Lin, Supported
- [Phase 8] Failure mode: OOB read/write → oops/corruption, HIGH;
  trigger is bad iLO FIFO entry
- UNVERIFIED: stable@ mailing list discussion (fetch denied)

The fix is small, matches the queue layout in this tree, and prevents a
host OOB from a bad iLO FIFO entry.

**YES**

 drivers/misc/hpilo.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/misc/hpilo.c b/drivers/misc/hpilo.c
index 04bd34c8c5069..9368edf8c4a32 100644
--- a/drivers/misc/hpilo.c
+++ b/drivers/misc/hpilo.c
@@ -160,11 +160,16 @@ static int ilo_pkt_dequeue(struct ilo_hwinfo *hw, struct ccb *ccb,
 
 	ret = fifo_dequeue(hw, fifobar, &entry);
 	if (ret) {
+		int pkt_len;
+
 		pkt_id = get_entry_id(entry);
+		pkt_len = get_entry_len(entry);
+		if (pkt_id >= NR_QENTRY || pkt_len > desc_mem_sz(1))
+			return 0;
 		if (id)
 			*id = pkt_id;
 		if (len)
-			*len = get_entry_len(entry);
+			*len = pkt_len;
 		if (pkt)
 			*pkt = (void *)(desc + desc_mem_sz(pkt_id));
 	}
-- 
2.53.0

