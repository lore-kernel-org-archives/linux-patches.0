Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038860;
	b=vIFRPMukBWLzqks3+y0v8RmjKg2hT1x8xOGAjZm6F0i9KQcbnkYw5scHRIelgfqkO5VG
	 nAdLN3rDW/YiCrmoWFi/NYKRKH5Mb3n3K88ubHInZUWzY2VZ7HOMuYak/k/LUvhUS4yaq
	 xwLr+WLz0i23cCBDGFbq7vyn36ALX+xMy9HSvhAgNZk6GTSpNqWNURKdPGRWDC/zzf5/G
	 suzEolQAz/c6uFlt6t11MTuEfFOcklTwWDjnwjP5yU/w7VNVZR3/Y1PwPLKTi/tHTr+06
	 YOTqNBBoBrjFiGj9bV2cr0JUp4MZufv4BxLQHQGJbp60C3W+tDza5vK7xOEvTfJecHQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038860;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=f3mH+PNPBD3qo29R8Fn3lj1+sF0kSEerwIjXlYa5EnA=;
	b=KSRq0erNz/Q8ZqMgtnJisGw8ryTCOXp298R9LwjqMhsZmlwjJPU8yUUSft0HfIH5rF7x
	 g1pdvz+AShKehYa9GtD7GXjnOiRIhRdrW9krgI2qAIkYWFxGIUZtvXuEMr2KK3OrN7weE
	 KQxTr8J3x5YpMmpWdDuP1Evkbubd0xyFXSfy1/lf11HEinpxW6sYdLmfE8Cm9svZlhDI/
	 5KbfREKIgK8rGSa/jz3GgwC97IMvxEqS0vUaKnUersqcNCddfGYt2vfJZXFHXCmo91we4
	 aCupOmWvzUWrEUvLJ3i3lJlRHxfCpfcxlxCkpcYghbOOLZdvIB6YBrP1SQyjUS0o8jw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=teUEDNyb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF1FB606A32A;
	Wed, 18 Nov 2026 21:54:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=teUEDNyb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D10E1F000C4;
	Wed, 18 Nov 2026 21:54:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795038859;
	bh=f3mH+PNPBD3qo29R8Fn3lj1+sF0kSEerwIjXlYa5EnA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=teUEDNybPeC+fXLXVL26o6omeuqlFsPzyt/ez0am8knsEQt2is1K+hC6in/GyXIci
	 k4R+fnguCE2nHp6q92q9xahDKFbTrdmA+k8q+9SEWy1Vnp8Hthwt5C+a9YYXkjLzj/
	 JyGjG49rCU1OaJEUqQuLcjiLh25Y6M/0N1+Fwsd0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matt Turner <mattst88@gmail.com>,
	Magnus Lindholm <linmag7@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1893/3318] alpha: select SYSCTL_EXCEPTION_TRACE
Date: Wed, 18 Nov 2026 15:41:55 +0100
Message-ID: <20261118150418.795245110@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matt Turner <mattst88@gmail.com>

[ Upstream commit e517a172b77601839e1c52ac4303602e285804bb ]

Report unhandled user faults the way other architectures do, and hook up
the debug.exception-trace sysctl that controls the reporting.

The message gives the faulting address, the PC and the user stack
pointer, and is rate limited.

Assisted-by: Claude:claude-opus-5
Signed-off-by: Matt Turner <mattst88@gmail.com>
Tested-by: Magnus Lindholm <linmag7@gmail.com>
Reviewed-by: Magnus Lindholm <linmag7@gmail.com>
Link: https://lore.kernel.org/r/20260905-arch-kconfig-options-v2-v2-17-83e8245761a2@gmail.com
Signed-off-by: Magnus Lindholm <linmag7@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/alpha/Kconfig    |  1 +
 arch/alpha/mm/fault.c | 29 +++++++++++++++++++++++++++++
 2 files changed, 30 insertions(+)

diff --git a/arch/alpha/Kconfig b/arch/alpha/Kconfig
index d6968d090d49a..f4b12c6e9ddbb 100644
--- a/arch/alpha/Kconfig
+++ b/arch/alpha/Kconfig
@@ -37,6 +37,7 @@ config ALPHA
 	select CPU_NO_EFFICIENT_FFS if !ALPHA_EV67
 	select MMU_GATHER_NO_RANGE
 	select SPARSEMEM_EXTREME if SPARSEMEM
+	select SYSCTL_EXCEPTION_TRACE
 	select ZONE_DMA
 	help
 	  The Alpha is a 64-bit general-purpose processor designed and
diff --git a/arch/alpha/mm/fault.c b/arch/alpha/mm/fault.c
index 53e170e965915..63a24afa7a155 100644
--- a/arch/alpha/mm/fault.c
+++ b/arch/alpha/mm/fault.c
@@ -28,8 +28,32 @@
 #include <linux/uaccess.h>
 #include <linux/perf_event.h>
 
+#include <asm/pal.h>
+
 extern void die_if_kernel(char *,struct pt_regs *,long, unsigned long *);
 
+int show_unhandled_signals = 1;
+
+static void
+show_signal_msg(struct pt_regs *regs, unsigned long address, int signo,
+		const char *desc)
+{
+	const char *level;
+
+	if (!show_unhandled_signals || !unhandled_signal(current, signo))
+		return;
+	if (!printk_ratelimit())
+		return;
+
+	/* Losing init is fatal, so shout about it.  */
+	level = task_pid_nr(current) > 1 ? KERN_INFO : KERN_EMERG;
+
+	printk("%s%s[%d]: %s at %016lx pc %016lx sp %016lx\n",
+	       level, current->comm, task_pid_nr(current), desc,
+	       address, regs->pc, rdusp());
+	print_vma_addr(KERN_CONT "  in ", regs->pc);
+	printk(KERN_CONT "\n");
+}
 
 /*
  * Force a new ASN for a task.
@@ -223,6 +247,8 @@ do_page_fault(unsigned long address, unsigned long mmcsr,
 	mmap_read_unlock(mm);
 	/* Send a sigbus, regardless of whether we were in kernel
 	   or user mode.  */
+	if (user_mode(regs))
+		show_signal_msg(regs, address, SIGBUS, "bus error");
 	force_sig_fault(SIGBUS, BUS_ADRERR, (void __user *) address);
 	if (!user_mode(regs))
 		goto no_context;
@@ -244,6 +270,9 @@ do_page_fault(unsigned long address, unsigned long mmcsr,
 	return;
 
  do_sigsegv:
+	show_signal_msg(regs, address, SIGSEGV,
+			si_code == SEGV_MAPERR ? "unmapped access"
+					       : "access violation");
 	force_sig_fault(SIGSEGV, si_code, (void __user *) address);
 	return;
 
-- 
2.53.0



