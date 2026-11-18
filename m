Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027795;
	b=qQ9ECZH2VzZCEjU4DqP+gyA9TvW5/BFuBLUDBfQ9i3o9OkGg9mPtxyCrn0Eexqi3Oape
	 lfeeIs5t8bTMyKyOu5P7iyEL/oXEo+nWnB9mLSan57Rjk8lrZB508T2T4d6xslJIfudj0
	 CJDDuoMcIB0VcJH0saLQCih9yKu4IyiGRdrrK/HZBWWdv9XHIVPBLxkwPDFi4OMahj6J6
	 fJE/9JvBNE/+p6n/R5kj52V+eeC4hugEqejEM046INtXhjtgNl3enX4nlTfjRFy7O+m7e
	 LsOcF2iAYTswktgGT1JRR2PY/Z45Pf30OKkfRkuujbIxpA7PErOQbYsTZ2/C4v2PG8g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027795;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fCGNRQ8PH0toC/5Sq/EO0ygQDv17aJiXAtsmCCj/aDI=;
	b=YuESLTIjyHiTuXkmin7+7ZsMaEjX7hd6s+7WNjyP9Rz+DYTo/ks4GcfVfMcpkicH9xG8
	 /5nfsdB/BowQyK3agujUs4P2OFOSGqOyAnyDjphpEjpvmleIzN3QRP+QPeaYZJPPQw7sT
	 cTuBfAj+3l+w+0Tc8lCeRPSl35OMCti8/rKd2BxvtpejQdh061aEDsLFyVEXutysexN9Y
	 0BZ7c5HE+NSYPO4tNYhlzB4iyE2LhYPmDTUKBpnNyEsz6c4ASIRRNPotLaGRR0tvoKX0Z
	 V3GubMTPRZy0gv+nhsX0FYRlpiYu8YUNAR/nctt4HkJ8CeF851KyRs2h2qp3VyHNStw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="Q/LNkO/s";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BEEC606A325;
	Wed, 18 Nov 2026 18:49:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Q/LNkO/s
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A7A41F000C4;
	Wed, 18 Nov 2026 18:49:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027795;
	bh=fCGNRQ8PH0toC/5Sq/EO0ygQDv17aJiXAtsmCCj/aDI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Q/LNkO/suVUNJdHVjmqiSMcKNmZjzkeWXTaqBaRJhcZ8szbvjfwBupjLS9wY2M33E
	 LTRxswtwMXvBSJvu/KXOZMg8vXAPoJj0MO2rFh6pduwAl6ouOvFr78h9bcxp1v/E9y
	 eR3ibUsRLBD1b55NRZTqvxcGQKq5A98WNPa4Lnmg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Catalin Marinas <catalin.marinas@arm.com>,
	Michael Kelley <mhklinux@outlook.com>,
	Shradha Gupta <shradhagupta@linux.microsoft.com>,
	Bradley Morgan <brads@mainlining.org>,
	Naman Jain <namjain@linux.microsoft.com>,
	Wei Liu <wei.liu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1865/2151] Drivers: hv: Run VMBus kexec cleanup from syscore shutdown
Date: Wed, 18 Nov 2026 16:00:00 +0100
Message-ID: <20261118150229.741172096@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

From: Shradha Gupta <shradhagupta@linux.microsoft.com>

[ Upstream commit 228e21764b389a71a05af6a356efa1bad0751b5e ]

ARM64 Hyper-V guests do not run the VMBus kexec cleanup before
secondary CPUs are stopped. Consequently, the old VMBus connection
and SynIC state remain active when the kexec kernel starts.

Run the VMBus kexec handler from the existing VMBus syscore shutdown
callback. syscore_shutdown() runs after device shutdown and before
machine shutdown, while all CPUs needed by the SynIC CPU hotplug
teardown are still available. Guard the callback with
kexec_is_in_progress() so normal restart, halt, and poweroff paths are
unchanged.

Use the same path on x86 and remove the architecture-specific handler
pointer and the weak setup/remove interfaces. VMBus teardown now
precedes hv_stimer_global_cleanup() on x86.

The new x86 ordering relies on commit be0cfab740e5 ("clocksource:
hyper-v: Remove support for stimer interrupts in message mode"), which
removed the synthetic timer's dependency on VMBus message delivery.
Older kernels that retain message-mode stimer interrupts must preserve
the existing x86 ordering and therefore require an ARM64-specific
backport.

Document the VMBus cleanup path and its position in shutdown ordering.

Fixes: 9bbb888824e3 ("arm64: hyperv: Initialize hypervisor on boot")
Link: https://lore.kernel.org/all/20260814093133.3191250-1-shradhagupta@linux.microsoft.com/
Suggested-by: Catalin Marinas <catalin.marinas@arm.com>
Suggested-by: Michael Kelley <mhklinux@outlook.com>
Signed-off-by: Shradha Gupta <shradhagupta@linux.microsoft.com>
Reviewed-by: Michael Kelley <mhklinux@outlook.com>
Reviewed-by: Bradley Morgan <brads@mainlining.org>
Reviewed-by: Naman Jain <namjain@linux.microsoft.com>
Signed-off-by: Wei Liu <wei.liu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/virt/hyperv/overview.rst | 12 +++++++-----
 arch/x86/kernel/cpu/mshyperv.c         | 27 ++++++--------------------
 drivers/hv/hv_common.c                 | 10 ----------
 drivers/hv/vmbus_drv.c                 | 22 +++++++++++++--------
 include/asm-generic/mshyperv.h         |  2 --
 5 files changed, 27 insertions(+), 46 deletions(-)

diff --git a/Documentation/virt/hyperv/overview.rst b/Documentation/virt/hyperv/overview.rst
index 77408a89d1a40..34a53ba7a1227 100644
--- a/Documentation/virt/hyperv/overview.rst
+++ b/Documentation/virt/hyperv/overview.rst
@@ -114,11 +114,13 @@ a shared page or remove an overlay page after the new kernel is
 using the page for a different purpose, corrupting the new kernel.
 Hyper-V does not provide a single "set everything" operation to
 guest VMs, so Linux code must individually revoke all sharing before
-doing kexec.   See hv_kexec_handler() and hv_crash_handler().  But
-the crash/panic path still has holes in cleanup because some shared
-pages are set using per-CPU synthetic registers and there's no
-mechanism to revoke the shared pages for CPUs other than the CPU
-running the panic path.
+doing kexec.  For a normal kexec reboot, the VMBus driver calls
+hv_kexec_handler() from its syscore shutdown callback, after device
+shutdown and before the architecture-specific machine shutdown.  The
+crash/panic path uses hv_crash_handler(), but still has holes in
+cleanup because some shared pages are set using per-CPU synthetic
+registers and there is no mechanism to revoke the shared pages for
+CPUs other than the CPU running the panic path.
 
 CPU Management
 --------------
diff --git a/arch/x86/kernel/cpu/mshyperv.c b/arch/x86/kernel/cpu/mshyperv.c
index 183301f27f080..b94fe65bc4b1b 100644
--- a/arch/x86/kernel/cpu/mshyperv.c
+++ b/arch/x86/kernel/cpu/mshyperv.c
@@ -107,7 +107,6 @@ EXPORT_SYMBOL_GPL(hv_set_msr);
 static void (*mshv_handler)(void);
 static void (*vmbus_handler)(void);
 static void (*hv_stimer0_handler)(void);
-static void (*hv_kexec_handler)(void);
 static void (*hv_crash_handler)(struct pt_regs *regs);
 
 DEFINE_IDTENTRY_SYSVEC(sysvec_hyperv_callback)
@@ -172,16 +171,6 @@ void hv_remove_stimer0_handler(void)
 	hv_stimer0_handler = NULL;
 }
 
-void hv_setup_kexec_handler(void (*handler)(void))
-{
-	hv_kexec_handler = handler;
-}
-
-void hv_remove_kexec_handler(void)
-{
-	hv_kexec_handler = NULL;
-}
-
 void hv_setup_crash_handler(void (*handler)(struct pt_regs *regs))
 {
 	hv_crash_handler = handler;
@@ -197,17 +186,13 @@ static void hv_machine_shutdown(void)
 {
 	if (kexec_in_progress) {
 		hv_stimer_global_cleanup();
-
-		if (hv_kexec_handler)
-			hv_kexec_handler();
-	}
-
-	/*
-	 * Call hv_cpu_die() on all the CPUs, otherwise later the hypervisor
-	 * corrupts the old VP Assist Pages and can crash the kexec kernel.
-	 */
-	if (kexec_in_progress)
+		/*
+		 * Call hv_cpu_die() on all the CPUs, otherwise later the
+		 * hypervisor corrupts the old VP Assist Pages and can crash
+		 * the kexec kernel.
+		 */
 		cpuhp_remove_state(CPUHP_AP_HYPERV_ONLINE);
+	}
 
 	/* The function calls stop_other_cpus(). */
 	native_machine_shutdown();
diff --git a/drivers/hv/hv_common.c b/drivers/hv/hv_common.c
index 71fd3ea4fa8bd..26dc2c1b1342f 100644
--- a/drivers/hv/hv_common.c
+++ b/drivers/hv/hv_common.c
@@ -681,16 +681,6 @@ void __weak hv_setup_mshv_handler(void (*handler)(void))
 }
 EXPORT_SYMBOL_GPL(hv_setup_mshv_handler);
 
-void __weak hv_setup_kexec_handler(void (*handler)(void))
-{
-}
-EXPORT_SYMBOL_GPL(hv_setup_kexec_handler);
-
-void __weak hv_remove_kexec_handler(void)
-{
-}
-EXPORT_SYMBOL_GPL(hv_remove_kexec_handler);
-
 void __weak hv_setup_crash_handler(void (*handler)(struct pt_regs *regs))
 {
 }
diff --git a/drivers/hv/vmbus_drv.c b/drivers/hv/vmbus_drv.c
index 1cc2c8695e0bb..11f6ec48db812 100644
--- a/drivers/hv/vmbus_drv.c
+++ b/drivers/hv/vmbus_drv.c
@@ -34,6 +34,7 @@
 #include <linux/efi.h>
 #include <linux/random.h>
 #include <linux/kernel.h>
+#include <linux/kexec.h>
 #include <linux/syscore_ops.h>
 #include <linux/dma-map-ops.h>
 #include <linux/pci.h>
@@ -2882,6 +2883,12 @@ static void hv_kexec_handler(void)
 	cpuhp_remove_state(hyperv_cpuhp_online);
 };
 
+static void hv_vmbus_syscore_shutdown(void *data)
+{
+	if (kexec_is_in_progress())
+		hv_kexec_handler();
+}
+
 static void hv_crash_handler(struct pt_regs *regs)
 {
 	int cpu;
@@ -2936,14 +2943,15 @@ static void hv_synic_resume(void *data)
 	 */
 }
 
-/* The callbacks run only on CPU0, with irqs_disabled. */
-static const struct syscore_ops hv_synic_syscore_ops = {
+/* The suspend and resume callbacks run only on CPU0, with irqs_disabled. */
+static const struct syscore_ops hv_vmbus_syscore_ops = {
 	.suspend = hv_synic_suspend,
 	.resume = hv_synic_resume,
+	.shutdown = hv_vmbus_syscore_shutdown,
 };
 
-static struct syscore hv_synic_syscore = {
-	.ops = &hv_synic_syscore_ops,
+static struct syscore hv_vmbus_syscore = {
+	.ops = &hv_vmbus_syscore_ops,
 };
 
 static int __init hv_acpi_init(void)
@@ -2992,10 +3000,9 @@ static int __init hv_acpi_init(void)
 	if (ret)
 		goto cleanup;
 
-	hv_setup_kexec_handler(hv_kexec_handler);
 	hv_setup_crash_handler(hv_crash_handler);
 
-	register_syscore(&hv_synic_syscore);
+	register_syscore(&hv_vmbus_syscore);
 
 	return 0;
 
@@ -3017,9 +3024,8 @@ static void __exit vmbus_exit(void)
 		 */
 		return;
 
-	unregister_syscore(&hv_synic_syscore);
+	unregister_syscore(&hv_vmbus_syscore);
 
-	hv_remove_kexec_handler();
 	hv_remove_crash_handler();
 	hv_stimer_global_cleanup();
 	vmbus_disconnect();
diff --git a/include/asm-generic/mshyperv.h b/include/asm-generic/mshyperv.h
index 8862f77241e6c..5acb50586fe97 100644
--- a/include/asm-generic/mshyperv.h
+++ b/include/asm-generic/mshyperv.h
@@ -223,8 +223,6 @@ void hv_remove_vmbus_handler(void);
 void hv_setup_stimer0_handler(void (*handler)(void));
 void hv_remove_stimer0_handler(void);
 
-void hv_setup_kexec_handler(void (*handler)(void));
-void hv_remove_kexec_handler(void);
 void hv_setup_crash_handler(void (*handler)(struct pt_regs *regs));
 void hv_remove_crash_handler(void);
 void hv_setup_mshv_handler(void (*handler)(void));
-- 
2.53.0



