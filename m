Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047223;
	b=G80xYNPQ1JF6gw1RxpJT4HR78trIScQSMQfhB4EbadjTfRZso8JRPC1EkaFav/MvKQtU
	 Rd1xJu7yYG6l3Gfmha18HfcQAfTY5gUPLZv4sziJNIZ2pcwkifnJvD9pROEqBxCNZAW74
	 EhvUD2UXCegYTvyT3LzyqE/31mnFq2QMc9tM1rnWyHCfIh8q0jUHufwwsRFVPvx/+5Z4Y
	 LgL3Pagi4sxc/utj8JE+7RcsPmVvE/fV+e6DUjhAD2ho7f3fJdJYcK+lBwgBAVJwH7pS8
	 ZUdlg08bIYKdKMyoYWvHcyECK8jIrzd4aUYtfZpYkuT5Ge9uDG2K9LXF95K6OTEM26A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047223;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=CrlnaNFstmMb/etWnh2rMRUEGlmfLF3BT0px5leJcw8=;
	b=lRvHdXpQtDiWjkrsAoBGilP3lFhDWJ/AQGE0/P+5jL0tcdMi3lAfOCBNMk0hf7xW6dol
	 NV8abXRnnfc2n06l5a1YPZ46vJ7MFRLaGnEM8Bo3HwySUmiTyeCZC5UqgJFDY0ppo8bGV
	 F8kBVFpftEFMcZqyfMZrygGyOwbG1k90+SD3pwByZmtb3kTNQw6PN1iSxLOL4X7xMNMOE
	 apC3ZYi2+fBS6WVb5SrQNvrXR6+PxywP5Xv1HafHOUSRpnmYGFc4MTS2aidilAq7z7yMl
	 wIW86Q/sTBi3LZOGDZFuSwXR1OPFaxYDVtj+KU7fEA/tV5VgjwlzdgNujDW4XwLMOzg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=h+91qOnW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2E3D606A33D;
	Thu, 19 Nov 2026 00:13:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=h+91qOnW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CC591F000C4;
	Thu, 19 Nov 2026 00:13:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047222;
	bh=CrlnaNFstmMb/etWnh2rMRUEGlmfLF3BT0px5leJcw8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h+91qOnW3JIW5tydtnMUs1n6OalEWRSKFoeXehaH48d1LrN5M+AfwhK9YwKoD61wr
	 gMrjv+u7jj6NJP6f3EzYsq8nszEujpnBdQoE/TGoNIIp1f6/Th+Z/yZ5rVk1nAqLkd
	 AjduG3xTuitFBSf5JhA+H/BbpcGzJIsJ8feRnpy0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Russell King <rmk+kernel@armlinux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1563/2857] ARM: 9488/1: smp: set current pointer in assembly before jumping into C
Date: Wed, 18 Nov 2026 15:43:17 +0100
Message-ID: <20261118150257.668073231@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: Adjusted context in arch_cpu_idle_dead() to accommodate the missing unreachable() call. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/include/asm/smp.h   |  2 +-
 arch/arm/kernel/head-nommu.S |  1 +
 arch/arm/kernel/head.S       |  1 +
 arch/arm/kernel/smp.c        | 15 ++-------------
 4 files changed, 5 insertions(+), 14 deletions(-)

diff --git a/arch/arm/include/asm/smp.h b/arch/arm/include/asm/smp.h
index 7c1c90d9f5827..e46a380a4bbb4 100644
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
index 950bef83339f5..9fe76c8d1d476 100644
--- a/arch/arm/kernel/head-nommu.S
+++ b/arch/arm/kernel/head-nommu.S
@@ -117,6 +117,7 @@ ENTRY(secondary_startup)
 	ldr	r7, __secondary_data		@ reload r7
 	ldr	sp, [r7, #12]			@ set up the stack pointer
 	ldr	r0, [r7, #16]			@ set up task pointer
+	set_current r0, r1
 	mov	fp, #0
 	b	secondary_start_kernel
 ENDPROC(secondary_startup)
diff --git a/arch/arm/kernel/head.S b/arch/arm/kernel/head.S
index 21930b9ac1c4c..85f3eab3eb393 100644
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
index 978db2d96b446..4b3cf4105a837 100644
--- a/arch/arm/kernel/smp.c
+++ b/arch/arm/kernel/smp.c
@@ -376,12 +376,9 @@ void arch_cpu_idle_dead(void)
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
 }
 #endif /* CONFIG_HOTPLUG_CPU */
 
@@ -400,23 +397,15 @@ static void smp_store_cpu_info(unsigned int cpuid)
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



