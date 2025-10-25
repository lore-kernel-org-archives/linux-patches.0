Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60BA2307AD4;
	Sat, 25 Oct 2025 16:20:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761409207; cv=none; b=XcAhUr1VKIpcdhz9fsMPy7I15A1gGmd2WOp9h+QWDffjukLaB5Qsku3BehUN7WjAJVWbc1a4AJ96FxHO4ZNIz5nzqbQBhggidYbnpHNfkXtiSfck9STwqtXmmXbikYZMk/NgvDOO2EpY4mWC/lrpo42cErZJkNG5FkuFt4TvH+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761409207; c=relaxed/simple;
	bh=CabJ/i8lS6gcqSEukAun0b0CXsxS9kItz3iD9vCFG0c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WYkEM/2VT/V3/Z+4G+YSQ8Rjkjl7fuTfb6PiR+m9t3PfCjHD8i2jksrGbCZrAHF5qx6YlalZR0I08K/gwFyEgOHwo1UQeCdyiranEF5QE03fIt7C7MLFvu0jtzw2k1mo/j6550rS3nzqoSAYbzGO7FEQlQcz1d7dGhohh0Sg01A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jPlOgAAg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jPlOgAAg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC2DBC4CEF5;
	Sat, 25 Oct 2025 16:20:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761409207;
	bh=CabJ/i8lS6gcqSEukAun0b0CXsxS9kItz3iD9vCFG0c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jPlOgAAgn0rI6xXApf6kDXv7WYIY7MQEYYYHXRzoEkg37NTDK4P1VHcfG9kiZ22Iv
	 +Oz5pMGp6OmC90saARVPFQPJiSXAh3k9n06RsIwWCS/l5Zl6prDDiwKDG3B0Ny3zZt
	 c3JbKoHNzlUO0RmvkyBIIQYZ6KlDmLAJXE5ZKki6OU5q0yMMWlwNztkd2jWOaHQz5s
	 Q7S+yTLYg/DkSTfz3UaalgAqvGP2dbZ9NI5jCflV0TCuch57mx15tWLYM20oHG9bOS
	 xp3MgCoDzAvCxGlSloNUjEAA9hdiGFkW/L+bhgPL6pVTLVdZJJEBwrYzmnLAWH9l67
	 TYQ39iVe7uJWg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Thomas Huth <thuth@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Andreas Larsson <andreas@gaisler.com>,
	sparclinux@vger.kernel.org,
	Sasha Levin <sashal@kernel.org>,
	nathan@kernel.org,
	alexandre.f.demers@gmail.com,
	alexander.deucher@amd.com,
	llvm@lists.linux.dev
Subject: [PATCH AUTOSEL 6.17-5.4] sparc: Replace __ASSEMBLY__ with __ASSEMBLER__ in uapi headers
Date: Sat, 25 Oct 2025 11:57:53 -0400
Message-ID: <20251025160905.3857885-242-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251025160905.3857885-1-sashal@kernel.org>
References: <20251025160905.3857885-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Thomas Huth <thuth@redhat.com>

[ Upstream commit d6fb6511de74bd0d4cb4cabddae9b31d533af1c1 ]

__ASSEMBLY__ is only defined by the Makefile of the kernel, so
this is not really useful for uapi headers (unless the userspace
Makefile defines it, too). Let's switch to __ASSEMBLER__ which
gets set automatically by the compiler when compiling assembly
code.

This is a completely mechanical patch (done with a simple "sed -i"
statement).

Cc: David S. Miller <davem@davemloft.net>
Cc: Andreas Larsson <andreas@gaisler.com>
Cc: sparclinux@vger.kernel.org
Signed-off-by: Thomas Huth <thuth@redhat.com>
Reviewed-by: Andreas Larsson <andreas@gaisler.com>
Signed-off-by: Andreas Larsson <andreas@gaisler.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES – Replacing the guard macro with `__ASSEMBLER__` in the SPARC UAPI
headers fixes a real user-space build break for assembly consumers with
negligible regression risk.
- `arch/sparc/include/uapi/asm/ptrace.h:18`,
  `arch/sparc/include/uapi/asm/signal.h:108`,
  `arch/sparc/include/uapi/asm/traps.h:13`, and
  `arch/sparc/include/uapi/asm/utrap.h:47` now test `__ASSEMBLER__`,
  which every assembler run by GCC/Clang defines automatically;
  previously the check keyed on `__ASSEMBLY__`, a macro only injected by
  the kernel’s own Makefiles.
- With the old guard, external SPARC assembly that includes these public
  headers would see the C struct/type definitions and fail to assemble;
  the new guard restores the intended split between C and assembly
  views, so this is a direct usability fix for real-world toolchains.
- Normal C compilation remains untouched because neither `__ASSEMBLY__`
  nor `__ASSEMBLER__` are defined there, so the change is behavior-
  neutral for existing C users.
- Kernel-internal headers already rely on `__ASSEMBLER__` (e.g.,
  `arch/sparc/include/asm/ptrace.h:8`), so this aligns the UAPI side
  with established SPARC practice and does not introduce new concepts.
- The patch is purely mechanical and localized to guard macros, touching
  no generated code or data layouts, which keeps regression risk
  extremely low while resolving the user-visible build failure.

 arch/sparc/include/uapi/asm/ptrace.h | 24 ++++++++++++------------
 arch/sparc/include/uapi/asm/signal.h |  4 ++--
 arch/sparc/include/uapi/asm/traps.h  |  4 ++--
 arch/sparc/include/uapi/asm/utrap.h  |  4 ++--
 4 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/arch/sparc/include/uapi/asm/ptrace.h b/arch/sparc/include/uapi/asm/ptrace.h
index abe640037a55d..2eb677f4eb6ab 100644
--- a/arch/sparc/include/uapi/asm/ptrace.h
+++ b/arch/sparc/include/uapi/asm/ptrace.h
@@ -15,7 +15,7 @@
  */
 #define PT_REGS_MAGIC 0x57ac6c00
 
-#ifndef __ASSEMBLY__
+#ifndef __ASSEMBLER__
 
 #include <linux/types.h>
 
@@ -88,7 +88,7 @@ struct sparc_trapf {
 	unsigned long _unused;
 	struct pt_regs *regs;
 };
-#endif /* (!__ASSEMBLY__) */
+#endif /* (!__ASSEMBLER__) */
 #else
 /* 32 bit sparc */
 
@@ -97,7 +97,7 @@ struct sparc_trapf {
 /* This struct defines the way the registers are stored on the
  * stack during a system call and basically all traps.
  */
-#ifndef __ASSEMBLY__
+#ifndef __ASSEMBLER__
 
 #include <linux/types.h>
 
@@ -125,11 +125,11 @@ struct sparc_stackf {
 	unsigned long xargs[6];
 	unsigned long xxargs[1];
 };
-#endif /* (!__ASSEMBLY__) */
+#endif /* (!__ASSEMBLER__) */
 
 #endif /* (defined(__sparc__) && defined(__arch64__))*/
 
-#ifndef __ASSEMBLY__
+#ifndef __ASSEMBLER__
 
 #define TRACEREG_SZ	sizeof(struct pt_regs)
 #define STACKFRAME_SZ	sizeof(struct sparc_stackf)
@@ -137,7 +137,7 @@ struct sparc_stackf {
 #define TRACEREG32_SZ	sizeof(struct pt_regs32)
 #define STACKFRAME32_SZ	sizeof(struct sparc_stackf32)
 
-#endif /* (!__ASSEMBLY__) */
+#endif /* (!__ASSEMBLER__) */
 
 #define UREG_G0        0
 #define UREG_G1        1
@@ -161,30 +161,30 @@ struct sparc_stackf {
 #if defined(__sparc__) && defined(__arch64__)
 /* 64 bit sparc */
 
-#ifndef __ASSEMBLY__
+#ifndef __ASSEMBLER__
 
 
-#else /* __ASSEMBLY__ */
+#else /* __ASSEMBLER__ */
 /* For assembly code. */
 #define TRACEREG_SZ		0xa0
 #define STACKFRAME_SZ		0xc0
 
 #define TRACEREG32_SZ		0x50
 #define STACKFRAME32_SZ		0x60
-#endif /* __ASSEMBLY__ */
+#endif /* __ASSEMBLER__ */
 
 #else /* (defined(__sparc__) && defined(__arch64__)) */
 
 /* 32 bit sparc */
 
-#ifndef __ASSEMBLY__
+#ifndef __ASSEMBLER__
 
 
-#else /* (!__ASSEMBLY__) */
+#else /* (!__ASSEMBLER__) */
 /* For assembly code. */
 #define TRACEREG_SZ       0x50
 #define STACKFRAME_SZ     0x60
-#endif /* (!__ASSEMBLY__) */
+#endif /* (!__ASSEMBLER__) */
 
 #endif /* (defined(__sparc__) && defined(__arch64__)) */
 
diff --git a/arch/sparc/include/uapi/asm/signal.h b/arch/sparc/include/uapi/asm/signal.h
index b613829247250..9c64d7cb85c2a 100644
--- a/arch/sparc/include/uapi/asm/signal.h
+++ b/arch/sparc/include/uapi/asm/signal.h
@@ -105,7 +105,7 @@
 #define __old_sigaction32	sigaction32
 #endif
 
-#ifndef __ASSEMBLY__
+#ifndef __ASSEMBLER__
 
 typedef unsigned long __old_sigset_t;            /* at least 32 bits */
 
@@ -176,6 +176,6 @@ typedef struct sigaltstack {
 } stack_t;
 
 
-#endif /* !(__ASSEMBLY__) */
+#endif /* !(__ASSEMBLER__) */
 
 #endif /* _UAPI__SPARC_SIGNAL_H */
diff --git a/arch/sparc/include/uapi/asm/traps.h b/arch/sparc/include/uapi/asm/traps.h
index 930db746f8bd7..43fe5b8fe8be1 100644
--- a/arch/sparc/include/uapi/asm/traps.h
+++ b/arch/sparc/include/uapi/asm/traps.h
@@ -10,8 +10,8 @@
 
 #define NUM_SPARC_TRAPS  255
 
-#ifndef __ASSEMBLY__
-#endif /* !(__ASSEMBLY__) */
+#ifndef __ASSEMBLER__
+#endif /* !(__ASSEMBLER__) */
 
 /* For patching the trap table at boot time, we need to know how to
  * form various common Sparc instructions.  Thus these macros...
diff --git a/arch/sparc/include/uapi/asm/utrap.h b/arch/sparc/include/uapi/asm/utrap.h
index d890b7fc6e835..a489b08b6a33d 100644
--- a/arch/sparc/include/uapi/asm/utrap.h
+++ b/arch/sparc/include/uapi/asm/utrap.h
@@ -44,9 +44,9 @@
 
 #define	UTH_NOCHANGE				(-1)
 
-#ifndef __ASSEMBLY__
+#ifndef __ASSEMBLER__
 typedef int utrap_entry_t;
 typedef void *utrap_handler_t;
-#endif /* __ASSEMBLY__ */
+#endif /* __ASSEMBLER__ */
 
 #endif /* !(__ASM_SPARC64_PROCESSOR_H) */
-- 
2.51.0

