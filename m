Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 849973ACF06;
	Mon, 20 Apr 2026 13:33:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776691980; cv=none; b=rQKeA5GtdcfRV4gRl6IyEddQa1iQNlqiqHT9Se2Ox0GD9pPdcpNUdwxneSaatS8hwIBiad8R91QRuLRt7RSPwH7QApbYgBBrY2HW415CTqRmiEvgSBkRjDX0nm+93azZ9qYCR45AJqmy+WMhaHePeM0jxSySMo0Pu5OjiXiAUuw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776691980; c=relaxed/simple;
	bh=G4wzPzy8muVNOXH8GZxNbaJADst6JlOxADlrHSIS5eY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IeGSJmqOXcDqmsgNFWRY0Xc6Ar0YYV4Ou0fCpStg/vz00Ff6VFSm5txGl00gTMwcjhptI8uAJz4920bGmgDPFjFgLEvW7Eq/R1f87q8M9KHfZI5qJMwwVSHoIo1NcyFQXEA7UFmRrhK9rxKxdzIxwa8DUXSMwZyt9X9+T5B41OU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HIhoFyyH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HIhoFyyH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8E2EC2BCB4;
	Mon, 20 Apr 2026 13:32:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776691980;
	bh=G4wzPzy8muVNOXH8GZxNbaJADst6JlOxADlrHSIS5eY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HIhoFyyHsOtEF66KTAxiIqeZYpaltfnZRN7je/nTUAZCJ+1EyGrItDIgfbi7xfq9s
	 mRCFelSdkwyPKrRbKNi8P4au7+75T5lYx7WDEsnpB3yyywbbCSMHekrWPsOvioMpm3
	 WNKf5d7HZ9ldWHLe+YKDuVELgtNCcUt0mybRsj5MXiO04LlNCyYXp0MdIkfq7AyenO
	 UCRC61CX3hHc1hXc0f+IYDwSjmEzKsPtk56bE4C7Rrr/R38NrwGZkOwk+GcmDlUjyR
	 SMK+Qep66cmEKxxP/9Tjrn4+2aBRkCDoKKV7HhkXa6FS/sNJKkJnaRao6plH1aqRX6
	 iLnw29+jgKnBg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: HyungJung Joo <jhj140711@gmail.com>,
	Mike Marshall <hubcap@omnibond.com>,
	Sasha Levin <sashal@kernel.org>,
	devel@lists.orangefs.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-5.10] orangefs: validate getxattr response length
Date: Mon, 20 Apr 2026 09:21:37 -0400
Message-ID: <20260420132314.1023554-303-sashal@kernel.org>
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
Content-Transfer-Encoding: 8bit

From: HyungJung Joo <jhj140711@gmail.com>

[ Upstream commit 092e0d0e964279feb9f43f81e8d1c52ef080d085 ]

orangefs_inode_getxattr() trusts the userspace-client-controlled
downcall.resp.getxattr.val_sz and uses it as a memcpy() length
both for the temporary user buffer and the cached xattr buffer.
Reject malformed negative or oversized lengths before copying
response bytes.

Reported-by: Hyungjung Joo <jhj140711@gmail.com>
Signed-off-by: HyungJung Joo <jhj140711@gmail.com>
Signed-off-by: Mike Marshall <hubcap@omnibond.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Based on my thorough investigation, let me provide the comprehensive
analysis.

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1: Parse the subject line**
Record: [orangefs] [validate - action verb implying defensive check
addition] [adding bounds validation for userspace-controlled xattr
response length]

**Step 1.2: Parse all commit message tags**
Record: Tags found:
- Reported-by: Hyungjung Joo <jhj140711@gmail.com>
- Signed-off-by: HyungJung Joo <jhj140711@gmail.com> (same person as
  reporter - self-reported)
- Signed-off-by: Mike Marshall <hubcap@omnibond.com> (orangefs subsystem
  maintainer - carries weight)
- No Fixes: tag (expected for candidates)
- No Cc: stable tag (expected for candidates)
- No Link: or syzbot tags

**Step 1.3: Analyze commit body**
Record: Body explains that `orangefs_inode_getxattr()` trusts
`downcall.resp.getxattr.val_sz`, a field controlled by the userspace
orangefs client, and uses it directly as `memcpy()` length for both a
temporary user buffer and the cached xattr buffer. The fix rejects
"malformed negative or oversized lengths" before copying bytes. The
mechanism is clear: untrusted input used as memory copy length = buffer
overflow / OOB read risk.

**Step 1.4: Detect hidden bug fixes**
Record: "validate" clearly signals a missing safety check - confirmed
bug fix, not cleanup or refactor. Language like "trusts the userspace-
client-controlled" confirms security framing.

## PHASE 2: DIFF ANALYSIS

**Step 2.1: Inventory**
Record: Single file (`fs/orangefs/xattr.c`), +4/-0 lines total. One
function modified: `orangefs_inode_getxattr()`. Scope: single-file
surgical fix.

**Step 2.2: Code flow change**
Record: BEFORE: `length = new_op->downcall.resp.getxattr.val_sz;` then
immediately used in comparisons and (conditionally) as memcpy size.
AFTER: Immediately after reading `val_sz` into `length`, the patch adds
`if (length < 0 || length > ORANGEFS_MAX_XATTR_VALUELEN) { ret = -EIO;
goto out_release_op; }`.

**Step 2.3: Identify bug mechanism**
Record: Memory safety fix (category d in the taxonomy). The bug
mechanism:
- `val_sz` is `__s32` (signed 32-bit) in `struct
  orangefs_getxattr_response` (see `fs/orangefs/downcall.h:60`).
- It is copied verbatim from `/dev/pvfs2-req` writes via
  `copy_from_iter_full(&op->downcall, ...)` in `fs/orangefs/devorangefs-
  req.c:423`.
- The kernel-side buffers `new_op->downcall.resp.getxattr.val[]` and
  `cx->val[]` are both fixed at `ORANGEFS_MAX_XATTR_VALUELEN = 8192`
  (protocol.h:187, orangefs-kernel.h:224).
- If a malicious/buggy userspace client returns `val_sz > 8192`, the
  unchecked `memcpy(cx->val, buffer, length)` overflows the cached xattr
  buffer (kernel heap overflow) and `memcpy(buffer,
  new_op->downcall.resp.getxattr.val, length)` reads past the 8192-byte
  source buffer (OOB read / info leak).
- The `length > size` check above the memcpy to `buffer` is NOT a
  substitute: if userspace supplies a buffer big enough (e.g.,
  `XATTR_SIZE_MAX=65536`) and val_sz is 20000, the check passes and
  memcpy reads 11808 bytes of adjacent kernel memory, and the subsequent
  cache store `memcpy(cx->val, buffer, length)` writes 11808 bytes past
  `cx->val[8192]`.
- For negative val_sz, `size == 0` path returns the negative value
  directly to userspace (incorrect errno-like return).

**Step 2.4: Fix quality**
Record: Fix is obviously correct - a simple range check (`< 0 || > MAX`)
returning `-EIO` matches the existing defensive pattern already present
in the same file's `orangefs_listxattr()` (lines 457-464: same `< 0 || >
MAX => -EIO` for `returned_count`). Additive check only; does not alter
behavior for valid inputs. No regression risk.

## PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1: Blame the changed area**
Record: The unchecked `length = new_op->downcall.resp.getxattr.val_sz;`
use dates back to the xattr cache implementation commit `fc2e2e9c43e3b`
"orangefs: implement xattr cache" by Martin Brandenburg, merged in
v5.2-rc1 (Dec 2017). The cache path `memcpy(cx->val, buffer, length)`
(where the heap overflow occurs) was introduced in that commit. Prior
code also used `val_sz` for the user-buffer memcpy but without the cache
overflow vector.

**Step 3.2: Follow Fixes: tag**
Record: No Fixes: tag present. The buggy code has been unchanged in this
area since fc2e2e9c43e3b (v5.2). All stable branches 5.10+ contain the
bug.

**Step 3.3: File history for related changes**
Record: Prior validation for the adjacent
`resp.listxattr.returned_count` was added in `62441fa53bccc` "Orangefs:
validate resp.listxattr.returned_count" (v4.5+) and `02a5cc537dfa2`
"orangefs: sanitize listxattr and return EIO on impossible values" -
establishing precedent for exactly this pattern. Also a recent security-
focused orangefs xattr fix: `025e880759c27` "orangefs: fix xattr related
buffer overflow..." (Sep 2025, Mike Marshall) addresses adjacent
vulnerabilities reported by Aisle Research - the file has been under
security scrutiny recently.

**Step 3.4: Author context**
Record: HyungJung Joo has submitted multiple small fs-subsystem bug
fixes in the same timeframe: `d227786ab1119` mb_cache UAF fix,
`baa4c4d1bfce1` omfs validation fix, `6fa253b38b9b2` affs bounds fix.
Pattern of a researcher doing responsible disclosure with fixes. Co-
signer Mike Marshall is the orangefs subsystem maintainer (MAINTAINERS
entry).

**Step 3.5: Dependencies**
Record: No dependencies. The check references only
`ORANGEFS_MAX_XATTR_VALUELEN` (defined in protocol.h since earliest
orangefs) and the existing `out_release_op` goto label. Standalone
patch.

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

**Step 4.1: Find original submission**
Record: `b4 dig -c 092e0d0e96427` returned "Nothing matching" for all
three match strategies (patch-id, author/subject, in-body From). Direct
lore.kernel.org searches via WebFetch/curl were blocked by Anubis anti-
bot protection. UNVERIFIED: cannot directly confirm review discussion on
lore. However, the two SoB chain (author -> maintainer) indicates the
patch traversed the orangefs maintainer tree before reaching fs-next.

**Step 4.2: Who reviewed**
Record: UNVERIFIED from lore, but SoB chain shows Mike Marshall
(orangefs maintainer) added his SoB - strong implicit endorsement by the
correct maintainer.

**Step 4.3: Bug report**
Record: Self-reported by the patch author - no external bug tracker
link. No syzbot involvement.

**Step 4.4: Related patches**
Record: `025e880759c27` (Sep 2025) is the immediate predecessor fixing
related xattr_key() infinite loop and cache hash collision issues in the
same function. The current patch addresses a different vulnerability in
the same function. No multi-patch series.

**Step 4.5: Stable mailing list**
Record: UNVERIFIED due to Anubis blocking. Cannot confirm stable-list
discussion.

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1: Key functions**
Record: `orangefs_inode_getxattr()` (the only modified function).

**Step 5.2: Callers**
Record: `orangefs_xattr_get_default()` (xattr.c:549) and
`orangefs_inode_get_acl()` (acl.c call site).
`orangefs_xattr_get_default()` is the `.get` handler registered in
`orangefs_xattr_default_handler` (xattr.c:555) for the default xattr
handler with `.prefix = ""` (matches any name). This means ALL xattr
reads on orangefs go through this path, reachable from `getxattr(2)`,
`listxattr(2)` consumers, and ACL lookups - very hot path for any
orangefs user.

**Step 5.3: Callees**
Record: `service_operation()` communicates with userspace client via
`/dev/pvfs2-req`; the response is copied directly with
`copy_from_iter_full(&op->downcall, ...)` in `devorangefs-req.c:423`
without per-field validation.

**Step 5.4: Reachability**
Record: Reachable from `getxattr`/`lgetxattr`/`fgetxattr` syscalls on
any file on an orangefs mount, by any user who can read the file (i.e.,
permissions already granted). Trust boundary: userspace orangefs client
daemon must be privileged, but a compromised/buggy client can trigger
this path.

**Step 5.5: Similar patterns**
Record: Confirmed - the sibling function `orangefs_listxattr()` in the
same file already does the exact same style of validation at lines
457-464 (for `returned_count`) and 470-478 (for `lengths[i]`), using the
same `< 0 || > MAX => -EIO` pattern. This patch brings
`orangefs_inode_getxattr()` to parity.

## PHASE 6: CROSS-REFERENCING AND STABLE TREE ANALYSIS

**Step 6.1: Buggy code in stable**
Record: Verified the exact vulnerable code pattern `length =
new_op->downcall.resp.getxattr.val_sz;` followed by unchecked `memcpy`
exists in:
- `stable-push/linux-5.10.y` xattr.c (checked)
- `stable-push/linux-5.15.y` xattr.c (checked)
- `stable-push/linux-6.1.y` xattr.c (checked)
- `stable-push/linux-6.6.y` xattr.c (checked)
- `stable-push/linux-6.12.y` xattr.c (checked)
- `stable-push/linux-6.19.y` xattr.c (checked)
All branches contain the bug.

**Step 6.2: Backport complications**
Record: Clean apply expected. The surrounding context lines (`length =
new_op->downcall.resp.getxattr.val_sz;` followed by the comment and `if
(size == 0)` block) are identical across all stable branches. The only
variation is superficial (`strcpy` vs `strscpy`, `kmalloc` vs
`kmalloc_obj`) in unrelated parts. `ORANGEFS_MAX_XATTR_VALUELEN` is
defined in all branches.

**Step 6.3: Related fixes already in stable**
Record: `025e880759c27` (the previous xattr buffer-overflow fix) has
been backported as `bc812574de633` (6.1.y), `15afebb959744` (5.15.y),
`ef892d2bf4f3f` (5.10.y), `c2ca015ac109f` (linux-rolling-stable), etc.
No fix for the val_sz issue is already in stable.

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

**Step 7.1: Subsystem criticality**
Record: fs/orangefs is a parallel/distributed filesystem driver.
PERIPHERAL at the user-population level (not every system uses
orangefs), but CRITICAL at the memory-safety level within its users (HPC
clusters, research facilities). The vulnerability is kernel heap
overflow - severe for any affected user.

**Step 7.2: Activity**
Record: Actively maintained by Mike Marshall (hubcap@omnibond.com).
Recent commits include security fixes (025e880759c27, 53e4efa470d5f,
f7c8484316325) - subsystem is under active security-hardening work.

## PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1: Who is affected**
Record: Filesystem-specific - users of OrangeFS parallel filesystem
(HPC, research computing). Every orangefs getxattr call (extremely
common - ACL checks, `security.*`, `trusted.*` xattrs) traverses this
path.

**Step 8.2: Trigger conditions**
Record: Requires a compromised/buggy/malicious userspace orangefs client
returning oversized `val_sz`. The client runs as root in normal
deployments, but the kernel should still validate its input (defense in
depth). An attacker with root on the orangefs client host, or a memory-
corrupted client process, can trigger OOB kernel access.

**Step 8.3: Failure mode severity**
Record: HIGH. Kernel heap buffer overflow on `memcpy(cx->val, buffer,
length)` when length > 8192 -> corrupts adjacent kmalloc slab memory ->
potential kernel panic or privilege escalation. OOB read on
`memcpy(buffer, new_op->downcall.resp.getxattr.val, length)` -> info
leak of kernel memory to userspace.

**Step 8.4: Risk-benefit**
Record: BENEFIT: HIGH - closes a kernel heap overflow / OOB read vector
in a path reachable via standard syscalls. RISK: VERY LOW - 4-line
additive bounds check, returning `-EIO` in a way that matches the
function's existing error contract and mirrors the listxattr precedent
in the same file. Net: strongly favors backport.

## PHASE 9: FINAL SYNTHESIS

**Step 9.1: Evidence compiled**

FOR:
- Small surgical fix (+4/-0 lines)
- Defensive bounds validation on userspace-controlled length used as
  memcpy size
- Prevents kernel heap overflow and OOB reads
- Pattern mirrors existing `orangefs_listxattr` validation in the same
  file
- Signed off by subsystem maintainer (Mike Marshall)
- Buggy code exists unchanged in all active stable trees (5.10+)
- Applies cleanly to all stable branches (context verified)
- No dependencies, self-contained
- Recent security focus on adjacent code (025e880759c27) shows this file
  is actively being hardened

AGAINST:
- Trust boundary is narrow (requires compromised/malicious userspace
  client which is typically root)
- No Fixes: tag (expected absence per problem statement)
- UNVERIFIED: mailing list discussion (Anubis blocked lore.kernel.org
  scraping)
- Self-reported (author = reporter), but maintainer SoB compensates

**Step 9.2: Stable rules checklist**
1. Obviously correct and tested? YES - trivially correct bounds check,
   maintainer-reviewed
2. Fixes real bug? YES - heap overflow + OOB read in kernel memcpy
3. Important issue? YES - memory safety (HIGH severity)
4. Small and contained? YES - 4 lines, single file, single function
5. No new features? YES - pure defensive check
6. Applies to stable? YES - verified identical context across
   5.10.y..6.19.y

**Step 9.3: Exception category**
Record: Not needed - passes general criteria. Closest category: memory-
safety bug fix.

**Step 9.4: Decision**
All stable-rule criteria met. Small, obviously-correct, defensive fix
that prevents real kernel memory corruption. Parallel pattern already in
the same file. Backport is low-risk, high-value.

## Verification

- [Phase 1] Parsed tags via `git show 092e0d0e96427`: Reported-by and
  SoB by same author, SoB by maintainer Mike Marshall. Confirmed no
  Fixes:/Cc: stable/Link:/syzbot tags.
- [Phase 2] Read full `fs/orangefs/xattr.c` at current state: verified
  the exact 4-line addition at the correct location and the existing
  vulnerable memcpy sites at lines 208 (user buffer) and 224/231 (cache
  buffer cx->val).
- [Phase 2] Read `fs/orangefs/protocol.h:187`: confirmed
  `ORANGEFS_MAX_XATTR_VALUELEN = 8192`.
- [Phase 2] Read `fs/orangefs/downcall.h:59-63`: confirmed `val_sz` is
  `__s32` and `val[ORANGEFS_MAX_XATTR_VALUELEN]`.
- [Phase 2] Read `fs/orangefs/orangefs-kernel.h:221-227`: confirmed
  `struct orangefs_cached_xattr` has `val[ORANGEFS_MAX_XATTR_VALUELEN]`.
- [Phase 2] Read `fs/orangefs/devorangefs-req.c:423`: confirmed
  `copy_from_iter_full(&op->downcall, ...)` copies userspace data
  directly into `downcall` without per-field validation.
- [Phase 3] `git log --oneline -- fs/orangefs/xattr.c`: verified
  fc2e2e9c43e3b introduced the cache path and `git describe --contains
  fc2e2e9c43e3b` = v5.2-rc1.
- [Phase 3] `git show 025e880759c27`: confirmed recent security fix
  precedent (Sep 2025).
- [Phase 3] `git show 62441fa53bccc`: confirmed listxattr validation
  precedent using the same `< 0 || > MAX => -EIO` pattern.
- [Phase 3] `git log --author="jhj140711"`: confirmed author has
  submitted multiple other fs bug fixes (mbcache UAF, omfs, affs).
- [Phase 4] `b4 dig -c 092e0d0e96427`: returned no match by patch-id /
  author+subject / in-body From. UNVERIFIED direct lore thread.
- [Phase 4] lore.kernel.org WebFetch/curl: blocked by Anubis anti-bot.
  UNVERIFIED lore discussion content.
- [Phase 5] `grep -rn "service_operation" fs/orangefs/`: traced the
  getxattr call flow.
- [Phase 5] Verified `orangefs_listxattr()` lines 457-478 contain the
  analogous `< 0 || > MAX => -EIO` pattern for `returned_count` and
  `lengths[i]`.
- [Phase 6] `git show stable-push/linux-5.10.y:fs/orangefs/xattr.c`:
  confirmed identical vulnerable pattern.
- [Phase 6] Same for `linux-5.15.y`, `linux-6.1.y`, `linux-6.6.y`,
  `linux-6.12.y`, `linux-6.19.y`: all contain the bug with essentially
  identical context for clean apply.
- [Phase 6] `git log --oneline stable-push/linux-*.y --grep="orangefs"`:
  confirmed no prior fix for the val_sz validation already backported.
- [Phase 7] `git log --oneline --author="hubcap" -- fs/orangefs/`:
  confirmed Mike Marshall is the active orangefs maintainer.
- [Phase 8] Bug severity derived from verified code analysis: heap
  overflow on fixed 8192-byte `cx->val` and OOB read on fixed 8192-byte
  `downcall.resp.getxattr.val`.
- UNVERIFIED: Whether the patch has a corresponding lore thread with
  explicit stable nomination or reviewer feedback; Anubis challenge
  prevented direct lore queries and b4 dig found no match. This does NOT
  drive the decision - the technical analysis is independently
  sufficient.

The fix is small, obviously correct, addresses a memory-safety bug in a
syscall-reachable path, mirrors an existing validation pattern in the
same file, was signed off by the subsystem maintainer, and applies
cleanly to all active stable branches that contain the vulnerable code.

**YES**

 fs/orangefs/xattr.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/orangefs/xattr.c b/fs/orangefs/xattr.c
index 1b372189cd10b..b6d116302de4e 100644
--- a/fs/orangefs/xattr.c
+++ b/fs/orangefs/xattr.c
@@ -188,6 +188,10 @@ ssize_t orangefs_inode_getxattr(struct inode *inode, const char *name,
 	 * Length returned includes null terminator.
 	 */
 	length = new_op->downcall.resp.getxattr.val_sz;
+	if (length < 0 || length > ORANGEFS_MAX_XATTR_VALUELEN) {
+		ret = -EIO;
+		goto out_release_op;
+	}
 
 	/*
 	 * Just return the length of the queried attribute.
-- 
2.53.0

