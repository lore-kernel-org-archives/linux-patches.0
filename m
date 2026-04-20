Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBB4143635C;
	Mon, 20 Apr 2026 13:29:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776691784; cv=none; b=qsAJahgM0diT+G6OC8VIzvJugz7fwTYtgtx/dfZyKIFpU7h/ffUlHbMIp4ubiitIBt/G4UI3uqwv5Mu8E28cTncJR9ZmBWtR4Li0n5gG6D8Zw+hqYQJnYONBoltCK9RzbCdEMD3nsdAJ4pj3WBpkYcUeXhdDo4TB89ast+F4xq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776691784; c=relaxed/simple;
	bh=r3PCGPvSaV2vt1Wuc1/AlbaQO34KfXtJYc7fBLLlMnA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MnywyDU2neFEgnqyB1C6Fb9/g8PdMe/7wZhWxaP1RPIbNIVF1XsDHJgQTjnGpoLHhQ03QiBiRiXbcoQy8ZgxY7VrcqpR31MMe3hmNI4yYEaO18u3Z503uQg40Z4CWIxv24qKU1ZAuk9BnRadAY5rFMlVt2EsazJuLbiq8B+Uc4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MP8CNhJ6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MP8CNhJ6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB598C2BCB4;
	Mon, 20 Apr 2026 13:29:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776691783;
	bh=r3PCGPvSaV2vt1Wuc1/AlbaQO34KfXtJYc7fBLLlMnA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MP8CNhJ6lpB5MvQI+N1cSWsCSlGqukz5hGcQML5S2hcgPtWCg4jowZjBV94+D9Kxp
	 z564Ddh74IHtYZY8Ys551F3/KcP8qzHWQKqXpDtrDXY1g7zRFahOUSN+0J2uLLCnPj
	 Zitc+oE/J9VdY+UtBRzj+kIFamU47dpNCrpDn2ZCDMmBL4FKDueJ49cnGcsY0uNwCP
	 EO0dA5lzb1bB3jKYyFxkF0I1LcZ8dV7MDha0qjT2K0titk92rFX5OUt/98QvhlOPLH
	 NKgQqKejVcuHAyoh9d6kzMLv1afBb1IUnKhjlEgMCMHXfs2ZDvGujy1d9DRgw5Bj7r
	 UL2fII9ZoB7Zg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Hari Bathini <hbathini@linux.ibm.com>,
	Ilya Leoshkevich <iii@linux.ibm.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	daniel@iogearbox.net,
	andrii@kernel.org,
	eddyz87@gmail.com,
	memxor@gmail.com,
	bpf@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-5.10] bpf: Do not increment tailcall count when prog is NULL
Date: Mon, 20 Apr 2026 09:19:45 -0400
Message-ID: <20260420132314.1023554-191-sashal@kernel.org>
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

From: Hari Bathini <hbathini@linux.ibm.com>

[ Upstream commit 3733f4be287029dad963534da3d91ac806df233d ]

Currently, tailcall count is incremented in the interpreter even when
tailcall fails due to non-existent prog. Fix this by holding off on
the tailcall count increment until after NULL check on the prog.

Suggested-by: Ilya Leoshkevich <iii@linux.ibm.com>
Signed-off-by: Hari Bathini <hbathini@linux.ibm.com>
Link: https://lore.kernel.org/r/20260220062959.195101-1-hbathini@linux.ibm.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have all the information needed for a thorough analysis. Let me
compile the findings.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject Line
- **Subsystem**: `bpf` (BPF subsystem, kernel core)
- **Action verb**: "Do not increment" — corrective action, clearly a bug
  fix
- **Summary**: Stop incrementing tailcall count when the target prog is
  NULL (non-existent)

Record: [bpf] [Do not increment / fix] [Correct tailcall count behavior
when prog is NULL]

### Step 1.2: Tags
- **Suggested-by**: Ilya Leoshkevich (s390 BPF maintainer) — strong
  credibility signal
- **Signed-off-by**: Hari Bathini (author, IBM powerpc BPF contributor)
- **Link**: `https://lore.kernel.org/r/20260220062959.195101-1-
  hbathini@linux.ibm.com`
- **Signed-off-by**: Alexei Starovoitov (BPF co-maintainer applied it)
- No Fixes: tag, no Cc: stable — expected for this review pipeline

Notable: The **sibling powerpc commit** (521bd39d9d28c) by the SAME
author DOES have `Cc: stable@vger.kernel.org` and `Fixes:` tags. This
interpreter fix was submitted separately to the BPF tree.

Record: Suggested by s390 BPF maintainer, signed off by BPF co-
maintainer. Sibling powerpc commit explicitly CC'd stable.

### Step 1.3: Commit Body
The commit explains: the BPF interpreter increments `tail_call_cnt` even
when the tail call fails because the program at the requested index is
NULL. The fix moves the increment after the NULL check.

Record: Bug = premature tail_call_cnt increment. Symptom = tail call
budget consumed by failed (NULL prog) tail calls, causing later
legitimate tail calls to fail prematurely.

### Step 1.4: Hidden Bug Fix Detection
This is **not** hidden — it's an explicit correctness fix. The
interpreter's behavior diverges from the JIT implementations (x86 JIT
already only increments after verifying the prog is non-NULL, as
confirmed in the code comment: "Inc tail_call_cnt if the slot is
populated").

Record: Explicit correctness fix. Not hidden.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory
- **Files changed**: 1 (`kernel/bpf/core.c`)
- **Lines**: 2 lines moved (net zero change in line count)
- **Functions modified**: `___bpf_prog_run()` — the BPF interpreter main
  loop
- **Scope**: Single-file, 2-line surgical fix

### Step 2.2: Code Flow Change
Before:
```c
tail_call_cnt++;
prog = READ_ONCE(array->ptrs[index]);
if (!prog)
    goto out;
```

After:
```c
prog = READ_ONCE(array->ptrs[index]);
if (!prog)
    goto out;
tail_call_cnt++;
```

The change simply reorders `tail_call_cnt++` to happen AFTER the NULL
check on `prog`. If `prog` is NULL, we now `goto out` WITHOUT
incrementing the count.

### Step 2.3: Bug Mechanism
**Category**: Logic/correctness bug.
When a BPF program attempts a tail call to an empty slot (NULL prog),
the tail_call_cnt was being incremented even though no actual tail call
occurred. This consumes the tail call budget for no-op operations,
potentially preventing later valid tail calls from succeeding.

### Step 2.4: Fix Quality
- **Obviously correct**: Yes — trivial reorder, clearly correct from
  both reading and comparison with JIT implementations
- **Minimal/surgical**: Yes — 2 lines moved, no other changes
- **Regression risk**: Extremely low — purely narrowing when the counter
  increments; the only behavior change is that failed tail calls no
  longer count against the budget

Record: Perfect fix quality. Minimal, obviously correct, zero regression
risk.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
The buggy code (`tail_call_cnt++` at line 2090) was introduced by commit
`04fd61ab36ec` ("bpf: allow bpf programs to tail-call other bpf
programs") by Alexei Starovoitov, dated 2015-05-19. This is from
**kernel v4.2**.

Record: Bug has been present since v4.2 (2015). Present in ALL active
stable trees.

### Step 3.2: Fixes Tag
No Fixes: tag in this commit. The sibling powerpc commit has `Fixes:
ce0761419fae ("powerpc/bpf: Implement support for tail calls")`.

### Step 3.3: File History
Recent changes to `kernel/bpf/core.c` (last 20 commits) show active
development but no modifications to the `JMP_TAIL_CALL` section. The
only changes to this section since v4.2 were:
- `2a36f0b92eb6` (Wang Nan, 2015): Added `READ_ONCE()` around
  `array->ptrs[index]`
- `ebf7f6f0a6cdc` (Tiezhu Yang, 2021): Changed `>` to `>=` for
  MAX_TAIL_CALL_CNT comparison

Record: The JMP_TAIL_CALL section is very stable. Fix will apply cleanly
to all stable trees.

### Step 3.4: Author
Hari Bathini is a regular powerpc/BPF contributor at IBM. The powerpc
sibling commit was accepted via the powerpc tree with Madhavan
Srinivasan's sign-off. The interpreter fix was accepted directly by
Alexei Starovoitov (BPF co-maintainer).

### Step 3.5: Dependencies
No dependencies. The fix is completely standalone — just a 2-line
reorder within the same block.

Record: Standalone, no dependencies. Will apply cleanly.

---

## PHASE 4: MAILING LIST RESEARCH

### Step 4.1: Original Discussion
b4 dig found the series went through **4 revisions** (v1 through v4).
The interpreter fix was submitted separately (Message-ID:
`20260220062959.195101-1-hbathini@linux.ibm.com`) and the powerpc fixes
were a 6-patch series. The powerpc v4 series explicitly CC'd
`stable@vger.kernel.org`.

### Step 4.2: Reviewers
From b4 dig -w: The patch was sent to BPF maintainers (Alexei
Starovoitov, Daniel Borkmann, Andrii Nakryiko), the linuxppc-dev list,
and bpf@vger.kernel.org. The right people reviewed it.

### Step 4.3: Bug Report
No syzbot or external bug report; this was found by the author during
code review while fixing the same issue in the powerpc64 JIT. Ilya
Leoshkevich (s390 BPF maintainer) suggested the fix.

### Step 4.4: Related Patches
Part of a broader effort to fix the "increment before NULL check"
pattern across BPF JIT backends. The x86 JIT already had this correct
since the tailcall hierarchy rework (commit `116e04ba1459f`).

### Step 4.5: Stable History
The sibling powerpc commit was explicitly sent to stable. Lore was not
accessible for deeper investigation (anti-bot protection).

Record: 4 revisions, reviewed by appropriate maintainers, sibling commit
CC'd stable.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key Functions
- `___bpf_prog_run()` — the main BPF interpreter dispatch loop

### Step 5.2: Callers
`___bpf_prog_run()` is called via the `DEFINE_BPF_PROG_RUN()` and
`DEFINE_BPF_PROG_RUN_ARGS()` macros, which are the entry points for BPF
program execution in interpreter mode. This is a HOT path when JIT is
disabled.

### Step 5.3-5.4: Call Chain
Any BPF program using tail calls that runs in interpreter mode (JIT
disabled, or CONFIG_BPF_JIT_ALWAYS_ON not set) will hit this code path.
This includes:
- XDP programs doing tail calls
- TC classifier programs
- Tracing programs
- Any BPF program type using `bpf_tail_call()`

Record: Core interpreter path, reachable from any BPF tail call when JIT
is disabled.

### Step 5.5: Similar Patterns
The x86 JIT already has the correct pattern:

```775:776:arch/x86/net/bpf_jit_comp.c
        /* Inc tail_call_cnt if the slot is populated. */
        EMIT4(0x48, 0x83, 0x00, 0x01);            /* add qword ptr
[rax], 1 */
```

This confirms the interpreter was the outlier with the incorrect
ordering.

---

## PHASE 6: STABLE TREE ANALYSIS

### Step 6.1: Buggy Code in Stable
The buggy code (from commit `04fd61ab36ec`, v4.2) exists in ALL active
stable trees (5.4, 5.10, 5.15, 6.1, 6.6, 6.12). The JMP_TAIL_CALL
section has been nearly unchanged since 2015.

### Step 6.2: Backport Complications
None. The code section is identical across all stable trees (only the
`>` vs `>=` comparison changed in 6.1+, which doesn't affect this fix).
The patch will apply cleanly.

### Step 6.3: Related Fixes in Stable
No similar fix for the interpreter has been applied to stable.

Record: Fix applies to all stable trees. Clean apply expected.

---

## PHASE 7: SUBSYSTEM CONTEXT

### Step 7.1: Subsystem Criticality
**BPF subsystem** (`kernel/bpf/`) — **CORE**. BPF is used extensively by
networking (XDP, TC), tracing, security (seccomp), and observability
tools (bpftrace, Cilium).

### Step 7.2: Activity
Very active subsystem with frequent changes, but the interpreter's tail
call section has been stable for years.

Record: CORE subsystem, very high user impact.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Affected Population
All users running BPF programs with tail calls in interpreter mode.
While most modern systems enable JIT, the interpreter is the fallback
and is used on architectures without JIT support or when JIT is
explicitly disabled.

### Step 8.2: Trigger Conditions
A BPF program attempts a tail call to an index in a prog_array map that
has no program loaded (NULL slot). This is a normal and expected usage
pattern — programs often check multiple slots.

### Step 8.3: Failure Mode Severity
**MEDIUM**: The bug causes incorrect behavior (premature exhaustion of
tail call budget) but doesn't cause crashes. It can cause BPF programs
to behave incorrectly — legitimate tail calls silently fail when they
shouldn't. This is a correctness issue that can lead to subtle, hard-to-
debug BPF program misbehavior.

### Step 8.4: Risk-Benefit
- **BENEFIT**: Fixes correctness of BPF interpreter tail call counting,
  consistent with JIT behavior. Affects all stable trees.
- **RISK**: Extremely low — 2 lines reordered within a single code
  block, obviously correct, matches JIT behavior.
- **Ratio**: Very favorable — high benefit, near-zero risk.

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence Summary

**FOR backporting:**
- Fixes a real correctness bug in the BPF interpreter present since v4.2
  (2015)
- Extremely small and obviously correct (2-line reorder)
- Makes interpreter consistent with JIT behavior (x86 JIT comment says
  "Inc tail_call_cnt if the slot is populated")
- Suggested by s390 BPF maintainer (Ilya Leoshkevich)
- Accepted by BPF co-maintainer (Alexei Starovoitov)
- Sibling powerpc commit explicitly CC'd stable@vger.kernel.org
- No dependencies, applies cleanly to all stable trees
- Zero regression risk
- Tested by Venkat Rao Bagalkote (sibling commit)

**AGAINST backporting:**
- No crash/security impact — correctness issue only
- Primarily affects interpreter mode (JIT is more commonly used)
- No Fixes: tag on this specific commit (though sibling has one)

### Step 9.2: Stable Rules Checklist
1. Obviously correct and tested? **YES** — trivially verifiable, tested
   in sibling
2. Fixes a real bug? **YES** — incorrect tail call count behavior
3. Important issue? **MEDIUM** — correctness bug causing silent
   misbehavior
4. Small and contained? **YES** — 2 lines in 1 file
5. No new features or APIs? **YES** — no new features
6. Can apply to stable trees? **YES** — clean apply expected

### Step 9.3: Exception Categories
Not an exception category — this is a standard correctness fix.

### Step 9.4: Decision
The fix is trivially small (2-line reorder), obviously correct, fixes a
real correctness bug that has existed since 2015, was suggested by a BPF
maintainer and accepted by the BPF co-maintainer, and the sibling commit
for the same bug in powerpc was explicitly CC'd to stable. The risk is
essentially zero.

---

## Verification

- [Phase 1] Parsed tags: Suggested-by Ilya Leoshkevich (s390 BPF
  maintainer), Signed-off-by Alexei Starovoitov (BPF co-maintainer)
- [Phase 1] Sibling powerpc commit 521bd39d9d28c has explicit `Cc:
  stable@vger.kernel.org` and `Fixes:` tag
- [Phase 2] Diff: 2 lines moved in `___bpf_prog_run()`,
  `tail_call_cnt++` moved after `if (!prog) goto out;`
- [Phase 3] git blame: buggy code from commit 04fd61ab36ec (v4.2,
  2015-05-19), present in all stable trees
- [Phase 3] git show ebf7f6f0a6cdc: confirmed only change to this
  section was `>` to `>=` in 2021
- [Phase 4] b4 dig -c 521bd39d9d28c: found series v1-v4, URL: `https://p
  atch.msgid.link/20260303181031.390073-2-hbathini@linux.ibm.com`
- [Phase 4] b4 dig -w: confirmed patch CC'd to stable@vger.kernel.org,
  BPF maintainers, and linuxppc-dev
- [Phase 5] x86 JIT at line 775 has comment "Inc tail_call_cnt if the
  slot is populated" — confirming interpreter was the outlier
- [Phase 5] Interpreter function `___bpf_prog_run()` is the core BPF
  execution path when JIT is disabled
- [Phase 6] JMP_TAIL_CALL section unchanged since v4.2 except for `>=`
  fix — clean apply to all stable trees
- [Phase 8] Failure mode: silent premature tail call budget exhaustion,
  severity MEDIUM
- UNVERIFIED: Lore discussion content (anti-bot protection blocked
  WebFetch), but mbox was partially read confirming stable CC

**YES**

 kernel/bpf/core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index 7b675a451ec8e..67eb12b637a5d 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -2087,12 +2087,12 @@ static u64 ___bpf_prog_run(u64 *regs, const struct bpf_insn *insn)
 		if (unlikely(tail_call_cnt >= MAX_TAIL_CALL_CNT))
 			goto out;
 
-		tail_call_cnt++;
-
 		prog = READ_ONCE(array->ptrs[index]);
 		if (!prog)
 			goto out;
 
+		tail_call_cnt++;
+
 		/* ARG1 at this point is guaranteed to point to CTX from
 		 * the verifier side due to the fact that the tail call is
 		 * handled like a helper, that is, bpf_tail_call_proto,
-- 
2.53.0

