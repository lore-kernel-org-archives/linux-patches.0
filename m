Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12E3D48BD48;
	Mon, 20 Apr 2026 13:32:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776691927; cv=none; b=WoMLtEdArYa+4ydv4ZYUtAOERopxznQ8UrYsAe6KSoalAgLD5PzTvYTG3gIacW+OYMRnKXZEqVX0KUjmjebwM0Mb97MAecJcd3WgmwBQ00tebVUNfXl7+tjF/cUtWMPsyKTA5m62dXZyrVuXjj7SneczTznw7owCIJpRTEdY/+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776691927; c=relaxed/simple;
	bh=h9tjCZoVldCf5QqHQiQrVeBhiBHOghvULaEsYcChqyg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lkkUHWGhHFPaMy50Rxu5+gLhogVxRFp5DDsU5nc8CELuON6rBXl85QMDyaigcEmBlBdXWRricw9Uvqal0WHFdS2CGTxNtx+yl3NdCPoAcRr6/KxoYmAI0Mchxer0H63eeY1IIjiXR2TX4TyQZrfnPzHV31OJV9ttBCA2InFB6Gk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LWoulMZn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LWoulMZn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D45EC19425;
	Mon, 20 Apr 2026 13:32:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776691927;
	bh=h9tjCZoVldCf5QqHQiQrVeBhiBHOghvULaEsYcChqyg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LWoulMZnSnqLl37Jc7jfViwe2zPgBn25RlD8wrt0CwR4yZrSj7ygAMJURUrPBXEbq
	 LSR5HmgyrKHs7Kc7QfsSeORCgEkSPHCTxrz3LFaUre3VenpS3TlbyxBW6m+dJfByOR
	 d/zOw9be1PKwkj35oPxTPHO0+vVrIcRwseFcFJm/Zt5ocIBKWvODPxIwi+a8RirsDT
	 Jb8RGdOqx1HK1D8KwCGQ+hIfV0LczMgj4QAxZyt//diJ8P3X+pxKtmqMjcXm/WHz9P
	 VXIZEYSTh+8weH2Nv8B+pJ1Mur+9+H8ulba/So5ShTk79L2OQYgvXMAlvUJCCwzda+
	 p4SjAn0eUKEyA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Weixie Cui <cuiweixie@gmail.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	daniel@iogearbox.net,
	andrii@kernel.org,
	eddyz87@gmail.com,
	memxor@gmail.com,
	bpf@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-6.18] bpf: propagate kvmemdup_bpfptr errors from bpf_prog_verify_signature
Date: Mon, 20 Apr 2026 09:21:07 -0400
Message-ID: <20260420132314.1023554-273-sashal@kernel.org>
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

From: Weixie Cui <cuiweixie@gmail.com>

[ Upstream commit ad2f7ed0ee91d63792cbe52f2b38325918ae3daa ]

kvmemdup_bpfptr() returns -EFAULT when the user pointer cannot be
copied, and -ENOMEM on allocation failure. The error path always
returned -ENOMEM, misreporting bad addresses as out-of-memory.

Return PTR_ERR(sig) so user space gets the correct errno.

Signed-off-by: Weixie Cui <cuiweixie@gmail.com>
Acked-by: Jiri Olsa <jolsa@kernel.org>
Link: https://lore.kernel.org/r/tencent_C9C5B2B28413D6303D505CD02BFEA4708C07@qq.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have all the information needed. Let me compile the full analysis.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1: Subject Line**
- Subsystem: `bpf`
- Action verb: "propagate" (indicating a correctness fix for error
  handling)
- Summary: Propagate correct errno from `kvmemdup_bpfptr()` in
  `bpf_prog_verify_signature()`

**Step 1.2: Tags**
- `Signed-off-by: Weixie Cui <cuiweixie@gmail.com>` - author
- `Acked-by: Jiri Olsa <jolsa@kernel.org>` - well-known BPF developer,
  regular contributor
- `Link:` to lore.kernel.org
- `Signed-off-by: Alexei Starovoitov <ast@kernel.org>` - BPF co-
  maintainer applied the patch
- No `Fixes:` tag, no `Cc: stable`, no `Reported-by:` (all expected for
  autosel review)

**Step 1.3: Body Text**
The commit message clearly describes: `kvmemdup_bpfptr()` can return
either `-EFAULT` (bad user pointer) or `-ENOMEM` (allocation failure),
but the error path always returned `-ENOMEM`, misreporting bad addresses
as out-of-memory. The fix returns `PTR_ERR(sig)` to propagate the
correct errno.

**Step 1.4: Hidden Bug Fix?**
This is an explicit correctness fix for error reporting. Not hidden.

Record: [bpf] [propagate/correct] [fixes incorrect errno returned to
userspace from kvmemdup_bpfptr failure]

## PHASE 2: DIFF ANALYSIS

**Step 2.1: Inventory**
- Single file: `kernel/bpf/syscall.c`
- 1 line changed: `-ENOMEM` → `PTR_ERR(sig)`
- Function modified: `bpf_prog_verify_signature()`
- Classification: single-file, single-line surgical fix

**Step 2.2: Code Flow Change**
Before: When `kvmemdup_bpfptr()` returns an error (either `-EFAULT` or
`-ENOMEM`), the function unconditionally returns `-ENOMEM`.
After: The function returns the actual error code from the failed call.

**Step 2.3: Bug Mechanism**
Category: Logic/correctness fix - incorrect error code returned to
userspace. When a user passes a bad pointer for the BPF program
signature, they get `ENOMEM` instead of `EFAULT`.

Verified from `include/linux/bpfptr.h`:

```68:79:include/linux/bpfptr.h
static inline void *kvmemdup_bpfptr_noprof(bpfptr_t src, size_t len)
{
        void *p = kvmalloc_node_align_noprof(len, 1, GFP_USER |
__GFP_NOWARN, NUMA_NO_NODE);

        if (!p)
                return ERR_PTR(-ENOMEM);
        if (copy_from_bpfptr(p, src, len)) {
                kvfree(p);
                return ERR_PTR(-EFAULT);
        }
        return p;
}
```

Other call sites in the same file (`___bpf_copy_key` at line 1700,
`map_update_elem` at line 1806-1808) already correctly propagate
`PTR_ERR()`. This fix brings `bpf_prog_verify_signature` into
consistency.

**Step 2.4: Fix Quality**
- Obviously correct: trivial `PTR_ERR()` idiom, standard kernel pattern
- Minimal: 1 line
- Zero regression risk: only changes which errno is returned, cannot
  break any functionality
- No API changes, no structure changes

## PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1: Blame**
The buggy line was introduced by commit `34927156830369` (KP Singh,
2025-09-21) - "bpf: Implement signature verification for BPF programs".
This was a v7 patch series for signed BPF programs. The incorrect
`-ENOMEM` has been present since the function's introduction.

**Step 3.2: Fixes tag**
No Fixes: tag present. The bug was introduced in `34927156830369`
(v6.18).

**Step 3.3: File History**
The file is actively maintained (many recent commits). No related fixes
for this specific issue found.

**Step 3.4: Author**
Weixie Cui is not a frequent BPF contributor (no other commits found in
the tree). However, the patch was acked by Jiri Olsa (major BPF
developer) and applied by Alexei Starovoitov (BPF co-maintainer).

**Step 3.5: Dependencies**
None. This is a completely standalone one-line fix.

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

**Step 4.1-4.2:** Lore.kernel.org is behind Anubis PoW protection, so
WebFetch fails. b4 dig found the original series that introduced the
function (v1 through v7 of the "Signed BPF programs" series). The fix
commit itself is not yet in the tree being analyzed (it's a candidate
for backport).

**Step 4.3:** No Reported-by tag. This is a code-review-found bug
(author noticed incorrect error propagation).

**Step 4.4-4.5:** Could not access lore due to bot protection. No series
dependencies for the fix.

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1-5.4: Call Chain**
`__sys_bpf()` (syscall handler) → `bpf_prog_load()` →
`bpf_prog_verify_signature()` → `kvmemdup_bpfptr()`

This is directly reachable from the BPF syscall (`BPF_PROG_LOAD`
command) when `attr->signature` is set. Any userspace program loading a
signed BPF program can trigger this code path.

**Step 5.5: Similar Patterns**
The other two `kvmemdup_bpfptr()` callsites in the same file correctly
use `PTR_ERR()`. This is the only inconsistent callsite.

## PHASE 6: STABLE TREE ANALYSIS

**Step 6.1:** The `bpf_prog_verify_signature` function was introduced in
commit `34927156830369` which first appeared in v6.18. Verified:
- NOT in v6.12, v6.13, v6.14, v6.15 (exit code 1 from `merge-base --is-
  ancestor`)
- IS in v6.18, v6.19, v7.0

So only 6.18.y, 6.19.y, and 7.0.y stable trees are affected (if active).

**Step 6.2:** The fix would apply cleanly to 7.0.y. For 6.18.y/6.19.y,
the context differs slightly (missing the `KMALLOC_MAX_CACHE_SIZE` check
from `ea1535e28bb377` which is only in v7.0), but the changed line
itself is identical.

**Step 6.3:** No related fixes already in stable.

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

**Step 7.1:** BPF subsystem (`kernel/bpf/`) - IMPORTANT level. BPF is
widely used for networking, security, tracing, etc. The signature
verification feature specifically serves security use cases.

**Step 7.2:** Actively maintained subsystem with frequent commits.

## PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1:** Affected users: those loading signed BPF programs
(security-conscious environments using BPF program signature
verification).

**Step 8.2:** Trigger: pass an invalid signature pointer via
`BPF_PROG_LOAD`. Unprivileged users can trigger this (if they have BPF
access). Not a crash path - just wrong errno.

**Step 8.3:** Failure mode: Incorrect errno returned to userspace
(`ENOMEM` instead of `EFAULT`). Severity: **LOW**. No crash, no data
corruption, no security vulnerability. But misleading error codes can
cause tools to take incorrect recovery actions (e.g., backing off for
memory pressure instead of reporting a programming error).

**Step 8.4:**
- Benefit: LOW-MEDIUM (correct errno for BPF signature verification
  users)
- Risk: NEAR-ZERO (1 line, standard `PTR_ERR()` pattern, cannot regress)
- Ratio: Favorable - benefit > risk

## PHASE 9: FINAL SYNTHESIS

**Evidence FOR backporting:**
- Fixes a real bug (incorrect errno to userspace)
- Trivially correct one-line fix using standard kernel idiom
- Zero regression risk
- Acked by major BPF developer (Jiri Olsa), applied by BPF maintainer
  (Alexei Starovoitov)
- Brings code into consistency with other `kvmemdup_bpfptr()` callsites
- Directly reachable from syscall path
- Standalone, no dependencies

**Evidence AGAINST backporting:**
- Low severity: incorrect errno, not a crash/corruption/security issue
- Only affects relatively new code (v6.18+), limited to a few stable
  trees
- No Reported-by, no evidence users have been affected in practice
- Stable rules ask for "important issues" - wrong errno is debatable

**Stable Rules Checklist:**
1. Obviously correct and tested? YES
2. Fixes a real bug? YES (incorrect errno)
3. Important issue? BORDERLINE - incorrect errno is a real bug but low
   severity
4. Small and contained? YES (1 line)
5. No new features or APIs? YES
6. Can apply to stable trees? YES (clean apply to 7.0.y)

## Verification

- [Phase 1] Parsed tags: Acked-by Jiri Olsa, SOB by Alexei Starovoitov
- [Phase 2] Diff analysis: 1 line changed, `-ENOMEM` -> `PTR_ERR(sig)`
  in `bpf_prog_verify_signature()`
- [Phase 2] Verified `kvmemdup_bpfptr` returns `-EFAULT` or `-ENOMEM`
  from `include/linux/bpfptr.h:68-79`
- [Phase 2] Verified other callsites (lines 1700, 1806-1808) already use
  `PTR_ERR()` correctly
- [Phase 3] git blame: buggy code introduced in `34927156830369` (KP
  Singh, 2025-09-21, v6.18)
- [Phase 3] Verified `34927156830369` NOT in v6.12 (exit 1), IS in v6.18
  (exit 0)
- [Phase 4] b4 dig found original series at lore (v7, "Signed BPF
  programs" series)
- [Phase 4] lore.kernel.org inaccessible via WebFetch (Anubis
  protection)
- [Phase 5] Call chain: `__sys_bpf()` -> `bpf_prog_load()` (line 6249)
  -> `bpf_prog_verify_signature()` (line 3034) - verified via grep
- [Phase 6] Bug exists only in v6.18+, NOT in v6.12 or earlier LTS trees
- [Phase 8] Severity: LOW (incorrect errno, no crash/corruption)
- UNVERIFIED: Could not access lore discussion to check if stable was
  discussed by reviewers

This is a borderline case. The fix is a trivially correct one-line
change with zero regression risk, fixing a genuine incorrect errno bug
in the BPF syscall path. While the severity is low (wrong error code,
not a crash), the near-zero risk makes the risk-benefit ratio favorable.
The incorrect errno could mislead BPF tools into treating a bad pointer
as a memory pressure issue.

**YES**

 kernel/bpf/syscall.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 700938782bed2..cbb8696c04b59 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -2832,7 +2832,7 @@ static int bpf_prog_verify_signature(struct bpf_prog *prog, union bpf_attr *attr
 	sig = kvmemdup_bpfptr(usig, attr->signature_size);
 	if (IS_ERR(sig)) {
 		bpf_key_put(key);
-		return -ENOMEM;
+		return PTR_ERR(sig);
 	}
 
 	bpf_dynptr_init(&sig_ptr, sig, BPF_DYNPTR_TYPE_LOCAL, 0,
-- 
2.53.0

