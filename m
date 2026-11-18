Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015005;
	b=ApBzfsUC1W9uUG5WZthSU2XsRN8rs2zlafPw8ObcENiVqmo8dw9kXhbrsX6fxjzSTjkC
	 sCInv/ZKzSt8vBC8BOsZxyPe6Wq1P7ihF7PbflUMZxRwJ4bl3mzBkvZL1rGNvVAU0V24l
	 xbaTa8q6t4Oj8oUoohj0B8WXPMt8+ijbKA4AaPoC806ttz1bjaD7w0w47aYD2qJkObmWv
	 4GSPHOIj/NqQHHuROmF8Wm5+uAawQMPZgxdglNyYTOyL1HciWZwwmwyHIIVFouxeLBVkm
	 Pj1fvZxmN7jhvNyctUYFC4QQbSQ42Sv68AVhuDk59ZqNs1n6hcQNQCRNpsJpvzHiQIQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015005;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tdNSpVjcpOveHcMfQAcFtiUDlHIgllHFl/E/uOlxasw=;
	b=Y8y9LE6D2YKvWoe2O8mFSYHC+3rC+sHGlfbpt7BJKoZsVXhsPQypg6ajtwpvevn7LHvy
	 d6CxMamSmQS1htRC+ZLoUZVhcsH4rIC/IwdlkbgIzQlO/8dnHxzBk4L1t+t04AxuA4F05
	 XMbV+DhLoehZQtaVKhVnhpMX+2/2PnEb25w2C6UpHotqCTfVOXWZVyvJXDDd3ZfHg5iBq
	 hIFUYdU/o3YX/zyGCNT1oWT0gqGxKVIZVdOi9YT5f804hMf0sO79AzrhhUObjz/0M00T8
	 y1Ctmc2b0uSVhaui/DD8qDvk00yCqt3sxIcuCzIQ/zIFvkkv2luXZXYDXXX/HD55WuQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dFkTwHxL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEB50606A320;
	Wed, 18 Nov 2026 15:16:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dFkTwHxL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5DA41F000C5;
	Wed, 18 Nov 2026 15:16:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015005;
	bh=tdNSpVjcpOveHcMfQAcFtiUDlHIgllHFl/E/uOlxasw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dFkTwHxLsd0B9XzINWu4Y5swT5A9vyG4UFFRYgUJKMeUdkOBiZ+053HtvP8T57pn2
	 c9mPIxSciD2tS8i/FuPhjbc8FneaooBUa8aC/gMzb79YIi1k4PNYjhnEytYWKsDC3q
	 7jPy7hBDyU3K7yZfX2yXqkn1EotxrVq/mNZs9VD4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matt Turner <mattst88@gmail.com>,
	Magnus Lindholm <linmag7@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0019/2651] alpha: select SYSCTL_EXCEPTION_TRACE
Date: Wed, 18 Nov 2026 15:20:59 +0100
Message-ID: <20261118150248.682458349@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index e53ef2d884636..c9aba0ab96e5e 100644
--- a/arch/alpha/Kconfig
+++ b/arch/alpha/Kconfig
@@ -44,6 +44,7 @@ config ALPHA
 	select MMU_GATHER_NO_RANGE
 	select MMU_GATHER_RCU_TABLE_FREE
 	select SPARSEMEM_EXTREME if SPARSEMEM
+	select SYSCTL_EXCEPTION_TRACE
 	select ZONE_DMA
 	select TRACE_IRQFLAGS_SUPPORT
 	select ARCH_WANT_FRAME_POINTERS
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



