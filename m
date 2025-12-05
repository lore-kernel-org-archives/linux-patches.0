Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32CBB1D6187;
	Fri,  5 Dec 2025 00:37:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764895050; cv=none; b=t6L6PFVQq+5PYQxQZ6VbUtd9nRI/KijAsgfNAjrWW3SbpZsC4qifBHUXoNXGnn6tbg1kTQAdrZs3/CllIUO1nyZJE1s6cr/WuEwCh2bKSipCyYePqOhe3YIiKMRUcUusvfBl8HpCYYXv576pROvnwgjzNSf/C0xsbhq7jhd5a7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764895050; c=relaxed/simple;
	bh=d/JdkQOrROvJEWTv7daI78o+wlt+53CAhIu914LQyLo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=N1SndWW8dpCj6rOUItb+OSo2TokpOhpo41lfubFP+iTkEOA6hU94RwGdtnDfNsYlneXVC5HA1xGfogtlLx7KO2DD7sfZ/HRHZQV5atV7GXwTOzYfDj1gfBqOJRnTnaLaU9VGc+ACdVcLlWmWv1ivQZglmBazetaSe8MeJ4kJzok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=p8JuYBEZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="p8JuYBEZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C5F6C4CEFB;
	Fri,  5 Dec 2025 00:37:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764895049;
	bh=d/JdkQOrROvJEWTv7daI78o+wlt+53CAhIu914LQyLo=;
	h=From:To:Cc:Subject:Date:From;
	b=p8JuYBEZi9bjmwn0ts8vP5CaAeaJanBBedphpmnbwUAW+YKHdiGO/pgv7eKw468ZR
	 uxXNTjx7uhYdHheF8CVgnmhaP5NPAxNq+JPDGLztSKSlmdtjzqa74/HDv9rPQf7X4w
	 GX/0vmYFFrsQOqAJWkPukX7tdGQuWKJalRZy6BgXMFQTsP19cPI5T8C4kdJaZogW7I
	 axnoDJeSNJXpU1/0/6puv9S4nqJXpmSrQZc1eyRFIk649qRXhcgQZ0T3taU5wQ8RJD
	 nTMRfMFOe/zqqu108VqpJ9ry7J3FyrUHG3EAlOr/PWUNZLqhANAV2DSG+KlNWjuWaH
	 80iRClD1xEF+Q==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	oleg@redhat.com
Subject: [PATCH AUTOSEL 6.18-5.10] x86/ptrace: Always inline trivial accessors
Date: Thu,  4 Dec 2025 19:37:26 -0500
Message-ID: <20251205003726.21504-1-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit 1fe4002cf7f23d70c79bda429ca2a9423ebcfdfa ]

A KASAN build bloats these single load/store helpers such that
it fails to inline them:

  vmlinux.o: error: objtool: irqentry_exit+0x5e8: call to instruction_pointer_set() with UACCESS enabled

Make sure the compiler isn't allowed to do stupid.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Link: https://patch.msgid.link/20251031105435.GU4068168@noisy.programming.kicks-ass.net
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Comprehensive Analysis: x86/ptrace: Always inline trivial accessors

### 1. COMMIT MESSAGE ANALYSIS

**Subject:** `x86/ptrace: Always inline trivial accessors`

**Key points from the commit message:**
- A **KASAN build** bloats these single load/store helpers such that
  they fail to inline
- The result is an **objtool ERROR**: `vmlinux.o: error: objtool:
  irqentry_exit+0x5e8: call to instruction_pointer_set() with UACCESS
  enabled`
- The commit ensures "the compiler isn't allowed to do stupid"

**Author:** Peter Zijlstra (Intel) - a highly respected kernel developer
and maintainer
**Committer:** Ingo Molnar - x86 subsystem maintainer

**Missing tags:**
- No `Cc: stable@vger.kernel.org` tag
- No `Fixes:` tag

### 2. CODE CHANGE ANALYSIS

The diff changes 8 trivial accessor functions from `static inline` to
`static __always_inline`:

| Function | Purpose | Complexity |
|----------|---------|------------|
| `regs_return_value()` | Returns `regs->ax` | 1 line |
| `regs_set_return_value()` | Sets `regs->ax = rc` | 1 line |
| `kernel_stack_pointer()` | Returns `regs->sp` | 1 line |
| `instruction_pointer()` | Returns `regs->ip` | 1 line |
| `instruction_pointer_set()` | Sets `regs->ip = val` | 1 line |
| `frame_pointer()` | Returns `regs->bp` | 1 line |
| `user_stack_pointer()` | Returns `regs->sp` | 1 line |
| `user_stack_pointer_set()` | Sets `regs->sp = val` | 1 line |

**Technical mechanism of the bug:**
1. KASAN adds memory sanitization instrumentation to functions
2. Even trivial one-liner functions get bloated with KASAN checks
3. The compiler decides the bloated functions are "too big" to inline
4. These functions get called from `irqentry_exit()` in contexts where
   UACCESS is enabled (SMAP disabled via STAC)
5. Objtool validates that no unexpected function calls happen with
   UACCESS enabled (security/correctness requirement)
6. Result: **BUILD FAILURE** (error, not warning)

**Why `__always_inline` fixes it:**
```c
#define __always_inline                 inline
__attribute__((__always_inline__))
```
This compiler attribute forces inlining regardless of any optimization
settings or instrumentation, ensuring these trivial accessors always
become inline code rather than function calls.

### 3. CLASSIFICATION

- **Category:** BUILD FIX
- **Type:** Fixes compilation error with KASAN on x86
- **Not a feature:** Simply enforces behavior that was intended
  (functions should always inline)
- **Not a quirk/device ID/DT:** N/A

### 4. SCOPE AND RISK ASSESSMENT

**Scope:**
- 1 file changed: `arch/x86/include/asm/ptrace.h`
- 10 insertions, 10 deletions (only adding `__always_` prefix)
- Changes are purely compile-time

**Risk: VERY LOW**
- Zero runtime functional change when compiler already inlines
- Only forces the compiler to do what it was supposed to do
- Same pattern already successfully applied to other functions in the
  same file:
  - `user_mode()` - already `__always_inline`
  - `v8086_mode()` - commit b008893b08dcc
  - `ip_within_syscall_gap()` - commit c6b01dace2cd7
  - `regs_irqs_disabled()` - already `__always_inline`

### 5. USER IMPACT

**Who is affected:**
- Anyone building x86 kernels with `CONFIG_KASAN=y`
- KASAN is used for memory debugging, commonly in development and CI
  systems
- Enterprise distributions often enable KASAN in debug/test builds

**Severity:** HIGH (build failure = kernel cannot be compiled)

### 6. STABILITY INDICATORS

- **Reviewed-by:** None explicit, but committed through tip tree
- **Tested-by:** None explicit, but the error message shows it was
  reproduced
- **Author credibility:** Peter Zijlstra is a top kernel maintainer
- **Committer credibility:** Ingo Molnar is the x86 maintainer

### 7. DEPENDENCY CHECK

**Dependencies:** NONE
- This is a standalone fix
- Does not depend on any other commits
- The affected code exists unchanged in all stable kernels (5.10, 5.15,
  6.1, 6.6)

**Backport applicability verified:**
```
v5.10: static inline void instruction_pointer_set(...) ✓
v5.15: static inline void instruction_pointer_set(...) ✓
v6.1:  static inline void instruction_pointer_set(...) ✓
v6.6:  static inline void instruction_pointer_set(...) ✓
```
The patch should apply cleanly to all stable trees.

### 8. HISTORICAL CONTEXT

Similar fixes have been applied to this same file and other kernel
files:

| Commit | Description | Pattern |
|--------|-------------|---------|
| c6b01dace2cd7 | x86: Always inline ip_within_syscall_gap() | Same |
| b008893b08dcc | x86/ptrace: Always inline v8086_mode() | Same |
| cb0ca08b326aa | kcov: mark in_softirq_really() as __always_inline |
Same (backported to stable) |

The KASAN + objtool UACCESS validation issue is a known pattern that has
been addressed multiple times with `__always_inline`.

### SUMMARY

**Strong YES signals:**
- ✅ Fixes a build failure (compilation error, not warning)
- ✅ Small, surgical fix with clear scope (only adds `__always_inline`)
- ✅ Obviously correct - trivial accessors should always inline
- ✅ Zero functional/runtime change
- ✅ No dependencies, applies cleanly to all stable trees
- ✅ Well-established fix pattern used elsewhere in kernel
- ✅ Authored by highly trusted maintainer (Peter Zijlstra)
- ✅ Committed through the proper channel (tip tree via Ingo Molnar)

**Weak NO signals:**
- ⚠️ No explicit `Cc: stable` tag
- ⚠️ No `Fixes:` tag

The absence of stable tags is not disqualifying for build fixes. The
stable kernel rules explicitly state that "build fixes that prevent
compilation" are acceptable. This is a clear-cut build fix that prevents
KASAN-enabled x86 kernels from compiling.

### CONCLUSION

This commit **should be backported** to stable kernel trees. It's a
textbook example of a build fix:
- Small, contained, obviously correct
- Fixes a real build failure affecting KASAN users
- Zero risk of regression (only forces intended behavior)
- No dependencies, clean backport
- Follows established patterns from similar successful fixes

**YES**

 arch/x86/include/asm/ptrace.h | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/arch/x86/include/asm/ptrace.h b/arch/x86/include/asm/ptrace.h
index 50f75467f73d0..b5dec859bc75a 100644
--- a/arch/x86/include/asm/ptrace.h
+++ b/arch/x86/include/asm/ptrace.h
@@ -187,12 +187,12 @@ convert_ip_to_linear(struct task_struct *child, struct pt_regs *regs);
 extern void send_sigtrap(struct pt_regs *regs, int error_code, int si_code);
 
 
-static inline unsigned long regs_return_value(struct pt_regs *regs)
+static __always_inline unsigned long regs_return_value(struct pt_regs *regs)
 {
 	return regs->ax;
 }
 
-static inline void regs_set_return_value(struct pt_regs *regs, unsigned long rc)
+static __always_inline void regs_set_return_value(struct pt_regs *regs, unsigned long rc)
 {
 	regs->ax = rc;
 }
@@ -277,34 +277,34 @@ static __always_inline bool ip_within_syscall_gap(struct pt_regs *regs)
 }
 #endif
 
-static inline unsigned long kernel_stack_pointer(struct pt_regs *regs)
+static __always_inline unsigned long kernel_stack_pointer(struct pt_regs *regs)
 {
 	return regs->sp;
 }
 
-static inline unsigned long instruction_pointer(struct pt_regs *regs)
+static __always_inline unsigned long instruction_pointer(struct pt_regs *regs)
 {
 	return regs->ip;
 }
 
-static inline void instruction_pointer_set(struct pt_regs *regs,
-		unsigned long val)
+static __always_inline
+void instruction_pointer_set(struct pt_regs *regs, unsigned long val)
 {
 	regs->ip = val;
 }
 
-static inline unsigned long frame_pointer(struct pt_regs *regs)
+static __always_inline unsigned long frame_pointer(struct pt_regs *regs)
 {
 	return regs->bp;
 }
 
-static inline unsigned long user_stack_pointer(struct pt_regs *regs)
+static __always_inline unsigned long user_stack_pointer(struct pt_regs *regs)
 {
 	return regs->sp;
 }
 
-static inline void user_stack_pointer_set(struct pt_regs *regs,
-		unsigned long val)
+static __always_inline
+void user_stack_pointer_set(struct pt_regs *regs, unsigned long val)
 {
 	regs->sp = val;
 }
-- 
2.51.0

