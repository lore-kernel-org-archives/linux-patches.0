Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39AAB3E51E9;
	Mon, 20 Apr 2026 13:24:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776691497; cv=none; b=KGKtv5km1TpdDARwrFDF6mpsR9uDp7X21yex7JlMWiWqbA3+odJ1ez/3/bsNQhjH6mE2/3cQ7NfPFFtl9pKBilqh/tF+iYbbpx+Fk/ujwzt+VME4CKc4QhETaVJgDfK/0aJxdu6My54odgcPx9EUuVNDYZMq1Pm7cV82nOHtSTE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776691497; c=relaxed/simple;
	bh=9RAmTz7wvWvUgXPQcRUcNryiMyjX9U3SxUuAT1803jQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Dbhk+ggHWQEn/rqqD+5MTWBRNtXlh6VrIWM0sHMHBbGcJPl0UaIfminwbPaCaBN+CwUypyOz9AFb2VjBrtwPWAJTZZFAC3PrbO0okkSZlxQ4YYHi3MMhdzs33hx1GNfpJ3sNG05UBJ8JGcFCmSxiafHV1t3G2Anxf2odxCcIWFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NBfwW7Tn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NBfwW7Tn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CE1CC19425;
	Mon, 20 Apr 2026 13:24:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776691497;
	bh=9RAmTz7wvWvUgXPQcRUcNryiMyjX9U3SxUuAT1803jQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NBfwW7Tng7uwRk0xPlO3M2x9tv4auUUZDbfCo2wYxC3EEGSL1ioy8nJ9zcC2i3nJr
	 5PGxuvXrGRaboYO547JqP+F83a7jiI+swR+xcoLbKTuRJ4x48ScBSYGrznjHb4vyUL
	 WjXbbfA9RBeF+7leNkRGMZL0VSaR7fEFslNQwaYX5Yfg0ZOPgNL8ug8J6zMVNbfVIW
	 YdPrf1kKO7j6BrD3+hGv/TgHqC+ITOc06HgiyhOeCoYKuJQZ5x+To8EUYQg8ft/knz
	 DlCWgL7W6GdCQEz9AwXSdyguSSfj+Quv9QhoNPUeAA9d51SGZKDg+bv5K2tsLIXkD0
	 vPhKtBF3T6u/A==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Yuto Ohnuki <ytohnuki@amazon.com>,
	Stefan Hajnoczi <stefanha@redhat.com>,
	Miklos Szeredi <mszeredi@redhat.com>,
	Sasha Levin <sashal@kernel.org>,
	gmaglione@redhat.com,
	vgoyal@redhat.com,
	miklos@szeredi.hu,
	virtualization@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-5.10] virtiofs: add FUSE protocol validation
Date: Mon, 20 Apr 2026 09:17:38 -0400
Message-ID: <20260420132314.1023554-64-sashal@kernel.org>
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

From: Yuto Ohnuki <ytohnuki@amazon.com>

[ Upstream commit 68b69fa0edb241a946cd4c850110990f30705164 ]

Add virtio_fs_verify_response() to validate that the server properly
follows the FUSE protocol by checking:

- Response length is at least sizeof(struct fuse_out_header).
- oh.len matches the actual response length.
- oh.unique matches the request's unique identifier.

On validation failure, set error to -EIO and normalize oh.len to prevent
underflow in copy_args_from_argbuf().

Addresses the TODO comment in virtio_fs_request_complete().

Signed-off-by: Yuto Ohnuki <ytohnuki@amazon.com>
Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have all the information needed for a comprehensive analysis. Let
me compile my findings.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1: Subject Line**
- Subsystem: virtiofs (fs/fuse)
- Action verb: "add" — but the body reveals this is actually a bug fix
  (prevents underflow in `copy_args_from_argbuf()`)
- Summary: Adds FUSE protocol response validation to prevent memory
  corruption from invalid server responses

**Step 1.2: Tags**
- Signed-off-by: Yuto Ohnuki (author)
- Reviewed-by: Stefan Hajnoczi (original virtiofs author, Red Hat)
- Signed-off-by: Miklos Szeredi (FUSE subsystem maintainer)
- No Fixes: tag (expected for autosel)
- No Cc: stable (expected)
- No Reported-by (proactive fix addressing long-standing TODO)

**Step 1.3: Commit Body**
- Explicitly states: "normalize oh.len to prevent underflow in
  copy_args_from_argbuf()"
- Addresses a known TODO since 2020 (commit bb737bbe48bea9)
- Three specific checks: minimum length, oh.len match, oh.unique match

**Step 1.4: Hidden Bug Fix Detection**
YES — this is a bug fix disguised as "add validation." The key phrase is
"prevent underflow in copy_args_from_argbuf()." Looking at line 732 of
`copy_args_from_argbuf()`:

```732:732:fs/fuse/virtio_fs.c
        remaining = req->out.h.len - sizeof(req->out.h);
```

If `req->out.h.len < sizeof(req->out.h)` (16 bytes), `remaining` is
`unsigned int` and underflows to ~4 billion. This `remaining` is then
used to control `memcpy` at line 746 — a buffer overflow.

## PHASE 2: DIFF ANALYSIS

**Step 2.1: Inventory**
- Files: fs/fuse/virtio_fs.c only
- Lines: +25 added, -4 removed (net +21)
- Functions modified: `virtio_fs_requests_done_work()` (4 lines added)
- Function added: `virtio_fs_verify_response()` (22 lines)
- TODO comment removed from `virtio_fs_request_complete()`
- Scope: single-file, surgical fix

**Step 2.2: Code Flow Change**
- BEFORE: No validation of server responses. `virtqueue_get_buf()`
  returns response → immediately processed by `copy_args_from_argbuf()`
  with no bounds checking on `oh.len` or `oh.unique`.
- AFTER: Each response is validated before processing. Invalid responses
  get `error = -EIO` and `oh.len = sizeof(struct fuse_out_header)`,
  preventing underflow.

**Step 2.3: Bug Mechanism**
Category: **Buffer overflow / memory safety fix** — specifically
preventing unsigned integer underflow leading to out-of-bounds memcpy.

Three failure modes without this fix:
1. `oh.len < sizeof(fuse_out_header)`: `remaining` underflows → massive
   memcpy → buffer overflow
2. `oh.len != actual_len`: `remaining` doesn't match actual buffer →
   over-read/over-write
3. `oh.unique` mismatch: response processed for wrong request → data
   corruption

**Step 2.4: Fix Quality**
- Obviously correct: simple comparisons against known-good values
- Minimal/surgical: only adds validation, no behavioral changes to valid
  responses
- No regression risk: valid responses pass through unchanged; invalid
  ones get -EIO (safe)
- Well-contained: single file, single subsystem

## PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1: Blame**
- `copy_args_from_argbuf()`: introduced by Stefan Hajnoczi in
  a62a8ef9d97da2 (2018-06-12) — the original virtiofs driver
- The TODO comment was added by Vivek Goyal in bb737bbe48bea9
  (2020-04-20) when refactoring the request completion path
- The buggy code (lack of validation) has existed since virtiofs was
  first introduced in 2018

**Step 3.2: Fixes tag**: None present (expected)

**Step 3.3: File History**: The file has 86 changes since v5.4. Recent
changes are unrelated (kzalloc_obj conversions, sysfs fixes, folio
conversions).

**Step 3.4: Author**: Yuto Ohnuki has 8 other commits in the tree (xfs,
ext4, igbvf, ixgbevf). Active kernel contributor at Amazon.

**Step 3.5: Dependencies**: None. The fix is entirely self-contained. It
uses existing structures (`fuse_out_header`, `fuse_req`) and doesn't
depend on any recent changes.

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

**Step 4.1: Original Discussion**
- Submitted: Feb 16, 2026 by Yuto Ohnuki
- Stefan Hajnoczi (original virtiofs author) gave Reviewed-by same day
  (Feb 17)
- Miklos Szeredi (FUSE maintainer) replied "Applied, thanks." same day
  (Feb 17)
- Single-version patch (no v2/v3), applied immediately
- A competing patch by Li Wang (March 18, 2026) was submitted later —
  Stefan noted this patch was already applied

**Step 4.2: Reviewers**
- Stefan Hajnoczi: original virtiofs author, Red Hat — provided
  Reviewed-by
- Miklos Szeredi: FUSE subsystem maintainer — applied the patch
- Proper mailing lists CC'd: virtualization, linux-fsdevel, linux-kernel

**Step 4.3: Bug Report**: No formal bug report. This was a proactive fix
addressing a known TODO in the code.

**Step 4.5: Stable Discussion**: No explicit stable nomination found.
The fact that another developer independently submitted the same fix (Li
Wang) shows the issue was recognized by multiple people.

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1: Functions Modified**
- `virtio_fs_verify_response()` (new)
- `virtio_fs_requests_done_work()` (caller of validation)

**Step 5.2: Callers**
- `virtio_fs_requests_done_work()` is the work function for ALL request
  completions off the virtqueue
- Called via `schedule_work()` from `virtio_fs_vq_done()`, the virtqueue
  interrupt handler
- Every FUSE response goes through this path

**Step 5.4: Call Chain**
```
virtio_fs_vq_done() [virtqueue interrupt]
  → schedule_work(&fsvq->done_work)
    → virtio_fs_requests_done_work()
      → virtqueue_get_buf(vq, &len)  [gets response from virtqueue]
      → **virtio_fs_verify_response(req, len)**  [NEW: validates
response]
      → ... → virtio_fs_request_complete()
             → copy_args_from_argbuf()  [contains the underflow
vulnerability]
```

The validation is placed correctly — before `copy_args_from_argbuf()` is
called through any path.

## PHASE 6: CROSS-REFERENCING AND STABLE TREE ANALYSIS

**Step 6.1: Buggy Code Exists in Stable**
- The original `copy_args_from_argbuf()` with the unvalidated
  `remaining` calculation was introduced in 2018 (a62a8ef9d97da2)
- virtiofs exists in all kernels since v5.4
- The vulnerability exists in ALL stable trees: 5.4.y, 5.10.y, 5.15.y,
  6.1.y, 6.6.y, 6.12.y, 7.0.y

**Step 6.2: Backport Complications**
- The code around the affected area is very stable — hasn't changed
  significantly
- The patch should apply cleanly or with trivial offset adjustments
- No conflicting refactors in the validation insertion point

**Step 6.3: Related Fixes**: No other fix for this issue exists in
stable.

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

**Step 7.1: Subsystem Criticality**
- virtiofs (fs/fuse): IMPORTANT — used in VM environments (QEMU, cloud)
- Used in containers, cloud workloads, development environments
- Security boundary: guest kernel trusting host FUSE server responses

**Step 7.2: Activity**: Active subsystem with 86 changes since v5.4.

## PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1: Affected Users**
- All users of virtiofs (VM guests mounting host filesystems via virtio-
  fs)
- Cloud users, container users, QEMU/KVM users

**Step 8.2: Trigger Conditions**
- A malicious or buggy virtiofs server (virtiofsd) sends a response
  with:
  - `oh.len < 16` (trigger underflow)
  - `oh.len != actual_response_len` (trigger buffer mismatch)
  - Wrong `oh.unique` (trigger data corruption)
- In a VM security context, this is security-relevant: a compromised
  host could exploit this to corrupt guest kernel memory

**Step 8.3: Failure Mode Severity**
- **CRITICAL**: unsigned integer underflow → massive memcpy → buffer
  overflow → kernel memory corruption
- This can lead to: kernel crash (oops/panic), data corruption, or
  potential code execution in the guest kernel

**Step 8.4: Risk-Benefit Ratio**
- BENEFIT: Prevents memory corruption from malicious/buggy FUSE server
  responses — HIGH
- RISK: 25 lines of simple validation logic, obviously correct — VERY
  LOW
- Ratio: Very favorable for backport

## PHASE 9: FINAL SYNTHESIS

**Step 9.1: Evidence Compilation**

FOR backport:
- Fixes real unsigned underflow → buffer overflow vulnerability in
  `copy_args_from_argbuf()`
- Security-relevant in VM environments (host→guest attack vector)
- Small, surgical fix (25 lines added, 4 removed)
- Obviously correct (simple comparisons)
- Reviewed by original virtiofs author (Stefan Hajnoczi)
- Applied by FUSE maintainer (Miklos Szeredi)
- No dependencies — completely standalone
- Bug exists in all stable trees since v5.4
- Another developer independently tried to fix the same issue (validates
  its importance)

AGAINST backport:
- Commit message says "add" not "fix" — but the body explicitly mentions
  preventing underflow
- No formal bug report or syzbot report — proactive fix
- Requires a malicious/buggy server to trigger (but this IS the threat
  model for VMs)

**Step 9.2: Stable Rules Checklist**
1. Obviously correct and tested? **YES** — simple bounds checking,
   reviewed by subsystem experts
2. Fixes a real bug? **YES** — unsigned underflow → buffer overflow
3. Important issue? **YES** — memory corruption (CRITICAL severity)
4. Small and contained? **YES** — 25 lines, single file
5. No new features or APIs? **YES** — only adds validation
6. Can apply to stable? **YES** — no dependencies, code unchanged since
   2018

**Step 9.3: Exception Categories**: N/A — this qualifies as a regular
bug fix

**Step 9.4: Decision**

This commit fixes a genuine memory safety vulnerability — an unsigned
integer underflow in `copy_args_from_argbuf()` that leads to a buffer
overflow via `memcpy`. The fix is small (25 lines), obviously correct
(simple comparison checks), reviewed by the original virtiofs author,
and applied by the FUSE maintainer. The vulnerable code has existed
since virtiofs was introduced in 2018, affecting all stable trees from
v5.4 onward.

## Verification

- [Phase 1] Parsed tags: Reviewed-by Stefan Hajnoczi, Signed-off-by
  Miklos Szeredi (FUSE maintainer)
- [Phase 2] Diff analysis: +25/-4 lines in fs/fuse/virtio_fs.c; adds
  `virtio_fs_verify_response()` and 4-line caller
- [Phase 2] Verified underflow: line 732 `remaining = req->out.h.len -
  sizeof(req->out.h)` — unsigned int subtraction with no bounds check →
  underflow when oh.len < 16
- [Phase 2] Verified memcpy consequence: line 746
  `memcpy(args->out_args[i].value, req->argbuf + offset, argsize)` uses
  the underflowed `remaining`
- [Phase 3] git blame: buggy code introduced in a62a8ef9d97da2
  (2018-06-12, Stefan Hajnoczi, virtiofs initial implementation)
- [Phase 3] git blame: TODO comment added by bb737bbe48bea9 (2020-04-20,
  Vivek Goyal)
- [Phase 3] git tag: original code exists since v5.4 (confirmed via git
  log v5.4 -- fs/fuse/virtio_fs.c)
- [Phase 4] Lore discussion: original patch at
  spinics.net/lists/kernel/msg6051405.html — single version, applied
  immediately
- [Phase 4] Stefan Hajnoczi provided Reviewed-by (Feb 17, 2026)
- [Phase 4] Miklos Szeredi replied "Applied, thanks." (Feb 17, 2026)
- [Phase 4] Competing fix by Li Wang (March 2026) confirms independent
  recognition of the issue
- [Phase 5] Traced call chain: virtqueue interrupt → done_work →
  virtio_fs_requests_done_work() → validation → copy_args_from_argbuf()
- [Phase 5] Confirmed all response processing paths go through the
  validation point
- [Phase 6] Code exists unchanged in stable 7.0 tree (verified by
  reading current file, lines 724-759)
- [Phase 6] No conflicting changes — patch should apply cleanly
- [Phase 8] Failure mode: unsigned underflow → buffer overflow → kernel
  memory corruption (CRITICAL)
- UNVERIFIED: Exact clean-apply status on older stable trees (5.10,
  5.15, 6.1) — minor offset adjustments may be needed due to folio
  conversions

**YES**

 fs/fuse/virtio_fs.c | 29 +++++++++++++++++++++++++----
 1 file changed, 25 insertions(+), 4 deletions(-)

diff --git a/fs/fuse/virtio_fs.c b/fs/fuse/virtio_fs.c
index 057e65b51b99d..2f7485ffac527 100644
--- a/fs/fuse/virtio_fs.c
+++ b/fs/fuse/virtio_fs.c
@@ -758,6 +758,27 @@ static void copy_args_from_argbuf(struct fuse_args *args, struct fuse_req *req)
 	req->argbuf = NULL;
 }
 
+/* Verify that the server properly follows the FUSE protocol */
+static bool virtio_fs_verify_response(struct fuse_req *req, unsigned int len)
+{
+	struct fuse_out_header *oh = &req->out.h;
+
+	if (len < sizeof(*oh)) {
+		pr_warn("virtio-fs: response too short (%u)\n", len);
+		return false;
+	}
+	if (oh->len != len) {
+		pr_warn("virtio-fs: oh.len mismatch (%u != %u)\n", oh->len, len);
+		return false;
+	}
+	if (oh->unique != req->in.h.unique) {
+		pr_warn("virtio-fs: oh.unique mismatch (%llu != %llu)\n",
+			oh->unique, req->in.h.unique);
+		return false;
+	}
+	return true;
+}
+
 /* Work function for request completion */
 static void virtio_fs_request_complete(struct fuse_req *req,
 				       struct virtio_fs_vq *fsvq)
@@ -767,10 +788,6 @@ static void virtio_fs_request_complete(struct fuse_req *req,
 	unsigned int len, i, thislen;
 	struct folio *folio;
 
-	/*
-	 * TODO verify that server properly follows FUSE protocol
-	 * (oh.uniq, oh.len)
-	 */
 	args = req->args;
 	copy_args_from_argbuf(args, req);
 
@@ -824,6 +841,10 @@ static void virtio_fs_requests_done_work(struct work_struct *work)
 		virtqueue_disable_cb(vq);
 
 		while ((req = virtqueue_get_buf(vq, &len)) != NULL) {
+			if (!virtio_fs_verify_response(req, len)) {
+				req->out.h.error = -EIO;
+				req->out.h.len = sizeof(struct fuse_out_header);
+			}
 			spin_lock(&fpq->lock);
 			list_move_tail(&req->list, &reqs);
 			spin_unlock(&fpq->lock);
-- 
2.53.0

