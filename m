Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AB743CE4B2;
	Thu, 17 Sep 2026 18:58:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789671517; cv=none; b=mJZCy/Dvw/rJ/VS0nPFv7e/T+tvqjmWKTNl7gD71DyuY3hrNYJQ9pXDTfsIuoEVSTaEBr38gCyojGHVI1XgFYz7osagmHRKC2mcY+jLm93ADo/bMXLdh10FuqgAEH9UBGJE1/SVs8KPgg4m1c8OX17CKEnH0NrEs7cvr3EEDYtY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789671517; c=relaxed/simple;
	bh=Cy1TtjjZ/rkbUK1/LZwCfMDiIHPCf1JhwU6q0RvP3gA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YrgcWE7lUgDLdCriy/cqAIpqRYGLqTVo2mRew93eZWisk0rI0F3GPRd+RP4aCYM0LldTfuzSjQSuVjWPLUuGjeNLlygf9hrjcfkK+NpuLk53h5qtc1hyj8Xt/EeNL2V9eA4YlF+qjoHr2k35eFUz3AOumGzdBJC7QqM6OViQ1Yo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DefO6L5q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DefO6L5q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5467D1F000FF;
	Thu, 17 Sep 2026 18:58:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789671515;
	bh=Iq0bu50Tfu7b/DqEYfHNxBw81XJT1pkQKTkhp3GwdJQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DefO6L5qCGH/1Ut7VPCUPRVYizPbJY2sY3cFe12paGEj6ldZzHnMG8jtVD3qzslSs
	 p50z2hm3xC1pyQWdFi6cWiFFNz/h4bLt31VehVxO5V2pum36fV036otpmr5nRS2yW/
	 7p2qxize3PhsE+8Tyjsi+NFgIlk7eJXZ7zz2zaDM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Uros Bizjak <ubizjak@gmail.com>,
	Ingo Molnar <mingo@kernel.org>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1001/1102] x86/locking: Remove semicolon from "lock" prefix
Date: Thu, 17 Sep 2026 16:15:44 +0100
Message-ID: <20260917151605.872279037@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Uros Bizjak <ubizjak@gmail.com>

[ Upstream commit 023f3290b02552ea006c1a2013e373750d2cbff6 ]

Minimum version of binutils required to compile the kernel is 2.25.
This version correctly handles the "lock" prefix, so it is possible
to remove the semicolon, which was used to support ancient versions
of GNU as.

Due to the semicolon, the compiler considers "lock; insn" as two
separate instructions. Removing the semicolon makes asm length
calculations more accurate, consequently making scheduling and
inlining decisions of the compiler more accurate.

Removing the semicolon also enables assembler checks involving lock
prefix. Trying to assemble e.g. "lock andl %eax, %ebx" results in:

  Error: expecting lockable instruction after `lock'

Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lore.kernel.org/r/20250228085149.2478245-1-ubizjak@gmail.com
Stable-dep-of: d824ed130768 ("x86/locking: Use sfence for wmb() if SSE is available")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/alternative.h |    2 +-
 arch/x86/include/asm/barrier.h     |    8 ++++----
 arch/x86/include/asm/cmpxchg.h     |    4 ++--
 arch/x86/include/asm/cmpxchg_32.h  |    4 ++--
 arch/x86/include/asm/edac.h        |    2 +-
 arch/x86/include/asm/sync_bitops.h |   12 ++++++------
 6 files changed, 16 insertions(+), 16 deletions(-)

--- a/arch/x86/include/asm/alternative.h
+++ b/arch/x86/include/asm/alternative.h
@@ -48,7 +48,7 @@
 		".popsection\n"				\
 		"671:"
 
-#define LOCK_PREFIX LOCK_PREFIX_HERE "\n\tlock; "
+#define LOCK_PREFIX LOCK_PREFIX_HERE "\n\tlock "
 
 #else /* ! CONFIG_SMP */
 #define LOCK_PREFIX_HERE ""
--- a/arch/x86/include/asm/barrier.h
+++ b/arch/x86/include/asm/barrier.h
@@ -12,11 +12,11 @@
  */
 
 #ifdef CONFIG_X86_32
-#define mb() asm volatile(ALTERNATIVE("lock; addl $0,-4(%%esp)", "mfence", \
+#define mb() asm volatile(ALTERNATIVE("lock addl $0,-4(%%esp)", "mfence", \
 				      X86_FEATURE_XMM2) ::: "memory", "cc")
-#define rmb() asm volatile(ALTERNATIVE("lock; addl $0,-4(%%esp)", "lfence", \
+#define rmb() asm volatile(ALTERNATIVE("lock addl $0,-4(%%esp)", "lfence", \
 				       X86_FEATURE_XMM2) ::: "memory", "cc")
-#define wmb() asm volatile(ALTERNATIVE("lock; addl $0,-4(%%esp)", "sfence", \
+#define wmb() asm volatile(ALTERNATIVE("lock addl $0,-4(%%esp)", "sfence", \
 				       X86_FEATURE_XMM2) ::: "memory", "cc")
 #else
 #define __mb()	asm volatile("mfence":::"memory")
@@ -50,7 +50,7 @@
 #define __dma_rmb()	barrier()
 #define __dma_wmb()	barrier()
 
-#define __smp_mb()	asm volatile("lock; addl $0,-4(%%" _ASM_SP ")" ::: "memory", "cc")
+#define __smp_mb()	asm volatile("lock addl $0,-4(%%" _ASM_SP ")" ::: "memory", "cc")
 
 #define __smp_rmb()	dma_rmb()
 #define __smp_wmb()	barrier()
--- a/arch/x86/include/asm/cmpxchg.h
+++ b/arch/x86/include/asm/cmpxchg.h
@@ -134,7 +134,7 @@ extern void __add_wrong_size(void)
 	__raw_cmpxchg((ptr), (old), (new), (size), LOCK_PREFIX)
 
 #define __sync_cmpxchg(ptr, old, new, size)				\
-	__raw_cmpxchg((ptr), (old), (new), (size), "lock; ")
+	__raw_cmpxchg((ptr), (old), (new), (size), "lock ")
 
 #define __cmpxchg_local(ptr, old, new, size)				\
 	__raw_cmpxchg((ptr), (old), (new), (size), "")
@@ -222,7 +222,7 @@ extern void __add_wrong_size(void)
 	__raw_try_cmpxchg((ptr), (pold), (new), (size), LOCK_PREFIX)
 
 #define __sync_try_cmpxchg(ptr, pold, new, size)			\
-	__raw_try_cmpxchg((ptr), (pold), (new), (size), "lock; ")
+	__raw_try_cmpxchg((ptr), (pold), (new), (size), "lock ")
 
 #define __try_cmpxchg_local(ptr, pold, new, size)			\
 	__raw_try_cmpxchg((ptr), (pold), (new), (size), "")
--- a/arch/x86/include/asm/cmpxchg_32.h
+++ b/arch/x86/include/asm/cmpxchg_32.h
@@ -103,7 +103,7 @@ static __always_inline bool __try_cmpxch
 
 static __always_inline u64 arch_cmpxchg64(volatile u64 *ptr, u64 old, u64 new)
 {
-	return __arch_cmpxchg64_emu(ptr, old, new, LOCK_PREFIX_HERE, "lock; ");
+	return __arch_cmpxchg64_emu(ptr, old, new, LOCK_PREFIX_HERE, "lock ");
 }
 #define arch_cmpxchg64 arch_cmpxchg64
 
@@ -136,7 +136,7 @@ static __always_inline u64 arch_cmpxchg6
 
 static __always_inline bool arch_try_cmpxchg64(volatile u64 *ptr, u64 *oldp, u64 new)
 {
-	return __arch_try_cmpxchg64_emu(ptr, oldp, new, LOCK_PREFIX_HERE, "lock; ");
+	return __arch_try_cmpxchg64_emu(ptr, oldp, new, LOCK_PREFIX_HERE, "lock ");
 }
 #define arch_try_cmpxchg64 arch_try_cmpxchg64
 
--- a/arch/x86/include/asm/edac.h
+++ b/arch/x86/include/asm/edac.h
@@ -13,7 +13,7 @@ static inline void edac_atomic_scrub(voi
 	 * are interrupt, DMA and SMP safe.
 	 */
 	for (i = 0; i < size / 4; i++, virt_addr++)
-		asm volatile("lock; addl $0, %0"::"m" (*virt_addr));
+		asm volatile("lock addl $0, %0"::"m" (*virt_addr));
 }
 
 #endif /* _ASM_X86_EDAC_H */
--- a/arch/x86/include/asm/sync_bitops.h
+++ b/arch/x86/include/asm/sync_bitops.h
@@ -31,7 +31,7 @@
  */
 static inline void sync_set_bit(long nr, volatile unsigned long *addr)
 {
-	asm volatile("lock; " __ASM_SIZE(bts) " %1,%0"
+	asm volatile("lock " __ASM_SIZE(bts) " %1,%0"
 		     : "+m" (ADDR)
 		     : "Ir" (nr)
 		     : "memory");
@@ -49,7 +49,7 @@ static inline void sync_set_bit(long nr,
  */
 static inline void sync_clear_bit(long nr, volatile unsigned long *addr)
 {
-	asm volatile("lock; " __ASM_SIZE(btr) " %1,%0"
+	asm volatile("lock " __ASM_SIZE(btr) " %1,%0"
 		     : "+m" (ADDR)
 		     : "Ir" (nr)
 		     : "memory");
@@ -66,7 +66,7 @@ static inline void sync_clear_bit(long n
  */
 static inline void sync_change_bit(long nr, volatile unsigned long *addr)
 {
-	asm volatile("lock; " __ASM_SIZE(btc) " %1,%0"
+	asm volatile("lock " __ASM_SIZE(btc) " %1,%0"
 		     : "+m" (ADDR)
 		     : "Ir" (nr)
 		     : "memory");
@@ -82,7 +82,7 @@ static inline void sync_change_bit(long
  */
 static inline bool sync_test_and_set_bit(long nr, volatile unsigned long *addr)
 {
-	return GEN_BINARY_RMWcc("lock; " __ASM_SIZE(bts), *addr, c, "Ir", nr);
+	return GEN_BINARY_RMWcc("lock " __ASM_SIZE(bts), *addr, c, "Ir", nr);
 }
 
 /**
@@ -95,7 +95,7 @@ static inline bool sync_test_and_set_bit
  */
 static inline int sync_test_and_clear_bit(long nr, volatile unsigned long *addr)
 {
-	return GEN_BINARY_RMWcc("lock; " __ASM_SIZE(btr), *addr, c, "Ir", nr);
+	return GEN_BINARY_RMWcc("lock " __ASM_SIZE(btr), *addr, c, "Ir", nr);
 }
 
 /**
@@ -108,7 +108,7 @@ static inline int sync_test_and_clear_bi
  */
 static inline int sync_test_and_change_bit(long nr, volatile unsigned long *addr)
 {
-	return GEN_BINARY_RMWcc("lock; " __ASM_SIZE(btc), *addr, c, "Ir", nr);
+	return GEN_BINARY_RMWcc("lock " __ASM_SIZE(btc), *addr, c, "Ir", nr);
 }
 
 #define sync_test_bit(nr, addr) test_bit(nr, addr)


