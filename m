Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063384;
	b=zef/syPnZaN88/SpGuAI1mUV2nPmYFnwe0uVVy+zT9LUG9t/W/ZqU327kOSP9mwCSZg8
	 8u+Z90E5IzFg9d5p9f486wbJCE4fRgBcRlVybhU8hM/Oc3egZXbnqxhb0GUFWiYlJRdt3
	 PtCaE0/w177gsMQbacq8Rb8+sG5V6CAfQXfeciphXmeD6WxWth3hXU07ww9aXb29p7bvR
	 Q3nOvXjR1NNDnwM3HYAyaVBxAw/ftMjzA+PIf/lTUTwcQQS2XkCNL10kYhs0HS/W3Iy0J
	 iIswSARgSrTsIsXYTO8+8Css/ne8QQw/lRyQrGGert8hiE215mRrq1dohZaGNpAwu2A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063384;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6qIBvFGcnFO2hI16o+NwwKc8q4Bv5qCCqSa42ac3kWk=;
	b=KQzqdNyjYNb41rU+YtpsIK+U8/TK8AMfk2Lnf1HJhY0DA5XTl12ecZxCE7mgBoA+sRWF
	 x5QoGUysDeWuSDDPCVqp/l5ukP2lH7OQV5QlKuQRkFKfOWye26NdLj+KAtRaVsZoJaI19
	 upioz44eZdZuGARHB8hDjI4W5rczYNipzNQOG0p+8jGz+X9pyHtAkQPyKmgV5yRr56FWr
	 Xsmh4K644WB6HuYeIwofBu7xzztR5TlNDVaVyAxIUSNK1DC8PpTqhDblYXmvNTiytBTE/
	 C5ex9bFNRJ6vRpj5wrlZWb7v0w+6Yhe8U2HjxK1BhWnJcGlZhlSFOv6Aft/3j6BWDGg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fpaieytj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49DC0606D810;
	Sat,  7 Nov 2026 14:56:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fpaieytj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC1701F0089F;
	Sat,  7 Nov 2026 14:56:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063384;
	bh=6qIBvFGcnFO2hI16o+NwwKc8q4Bv5qCCqSa42ac3kWk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fpaieytjhPhDVcwVH3OnADnPYk+ELY16+sutvfAoYCqK2ZP7H5mu5EziRD77NTYDS
	 NbtdsmV4Z8C8vToMhXkzqOW70YlWEuKLKljxLIprlo440ULrZ1k+SrpDV3Yu+T14pW
	 3xZu337Awq5JMBH1RB6acWPPWwwjqX7GjyiS+k+U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Russell King <rmk+kernel@armlinux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 556/869] ARM: 9488/1: smp: set current pointer in assembly before jumping into C
Date: Sat,  7 Nov 2026 08:53:58 -0500
Message-ID: <20261107134912.189840864@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Karl Mehltretter <kmehltretter@gmail.com>

[ Upstream commit f6e551e7d515579b952422c93415470fb672d848 ]

With CONFIG_KCOV_INSTRUMENT_ALL=y, secondary CPUs fail to come online
on ARMv6K/ARMv7 SMP:

  CPU1: failed to boot: -38

The compiler inserts a call to __sanitizer_cov_trace_pc() at the entry
of secondary_start_kernel(), before set_current(task). The KCOV hook
dereferences current while TPIDRURO is still uninitialized, causing a
data abort before cpu_init() has installed the exception stacks. The
secondary CPU consequently never completes startup.

Initialize current in the secondary assembly handoff, as
__mmap_switched already does for the boot CPU.

With current set in assembly, the set_current() call in
secondary_start_kernel() is redundant. Drop it together with the
function and the task argument. The hotplug resuscitate path in
arch_cpu_idle_dead() needs no hand-off either, as smp_ops.cpu_die()
can only return if the CPU kept its register state, TPIDRURO included.

Assisted-by: Claude:claude-fable-5

Fixes: 50596b7559bf ("ARM: smp: Store current pointer in TPIDRURO register if available")
Cc: stable@vger.kernel.org
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Reviewed-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/include/asm/smp.h   |  2 +-
 arch/arm/kernel/head-nommu.S |  1 +
 arch/arm/kernel/head.S       |  1 +
 arch/arm/kernel/smp.c        | 15 ++-------------
 4 files changed, 5 insertions(+), 14 deletions(-)

diff --git a/arch/arm/include/asm/smp.h b/arch/arm/include/asm/smp.h
index 8c05a7f374d8b..84aa6a663e816 100644
--- a/arch/arm/include/asm/smp.h
+++ b/arch/arm/include/asm/smp.h
@@ -43,7 +43,7 @@ extern void set_smp_ipi_range(int ipi_base, int nr_ipi);
  * Called from platform specific assembly code, this is the
  * secondary CPU entry point.
  */
-asmlinkage void secondary_start_kernel(struct task_struct *task);
+asmlinkage void secondary_start_kernel(void);
 
 
 /*
diff --git a/arch/arm/kernel/head-nommu.S b/arch/arm/kernel/head-nommu.S
index b9d6818f1ee16..f80bbfbd3a6f8 100644
--- a/arch/arm/kernel/head-nommu.S
+++ b/arch/arm/kernel/head-nommu.S
@@ -116,6 +116,7 @@ ENTRY(secondary_startup)
 	ldr	r7, __secondary_data		@ reload r7
 	ldr	sp, [r7, #12]			@ set up the stack pointer
 	ldr	r0, [r7, #16]			@ set up task pointer
+	set_current r0, r1
 	mov	fp, #0
 	b	secondary_start_kernel
 ENDPROC(secondary_startup)
diff --git a/arch/arm/kernel/head.S b/arch/arm/kernel/head.S
index f22c50d4bd417..a22403a629efa 100644
--- a/arch/arm/kernel/head.S
+++ b/arch/arm/kernel/head.S
@@ -442,6 +442,7 @@ ENTRY(__secondary_switched)
 	adr_l	r7, secondary_data + 12		@ get secondary_data.stack
 	ldr	sp, [r7]
 	ldr	r0, [r7, #4]			@ get secondary_data.task
+	set_current r0, r1
 	mov	fp, #0
 	b	secondary_start_kernel
 ENDPROC(__secondary_switched)
diff --git a/arch/arm/kernel/smp.c b/arch/arm/kernel/smp.c
index 50999886a8b5c..e302063658779 100644
--- a/arch/arm/kernel/smp.c
+++ b/arch/arm/kernel/smp.c
@@ -371,12 +371,9 @@ void __noreturn arch_cpu_idle_dead(void)
 	 */
 	__asm__("mov	sp, %0\n"
 	"	mov	fp, #0\n"
-	"	mov	r0, %1\n"
 	"	b	secondary_start_kernel"
 		:
-		: "r" (task_stack_page(current) + THREAD_SIZE - 8),
-		  "r" (current)
-		: "r0");
+		: "r" (task_stack_page(current) + THREAD_SIZE - 8));
 
 	unreachable();
 }
@@ -397,23 +394,15 @@ static void smp_store_cpu_info(unsigned int cpuid)
 	check_cpu_icache_size(cpuid);
 }
 
-static void set_current(struct task_struct *cur)
-{
-	/* Set TPIDRURO */
-	asm("mcr p15, 0, %0, c13, c0, 3" :: "r"(cur) : "memory");
-}
-
 /*
  * This is the secondary CPU boot entry.  We're using this CPUs
  * idle thread stack, but a set of temporary page tables.
  */
-asmlinkage void secondary_start_kernel(struct task_struct *task)
+asmlinkage void secondary_start_kernel(void)
 {
 	struct mm_struct *mm = &init_mm;
 	unsigned int cpu;
 
-	set_current(task);
-
 	secondary_biglittle_init();
 
 	/*
-- 
2.53.0



