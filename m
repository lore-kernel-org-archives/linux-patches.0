Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017853;
	b=AokP1KtrgUSEDG4s+Pm/ha0f6Axx1dA1jgMPYaIDtzjkTwnrj1vtYVVC7nVBoh+SwVbZ
	 qhbiFGD7rsQQA+cC7quj3iAhY9POC4FSUFyrLYkylA9pOQrOSabkydzRIRho7h9Dlbw8N
	 s4BwGDS4He3GukLoXUOsacy82HtIEpdHD5AX+wjh4tZDjLLE0/xAOUtp0+0YmiBtsXW67
	 PNwFUMx5cQdogTckLHPsDZa5WUGOilX6ZTsmDH39ky8bXwDpreyB8vMX3aXUNsR97fFl0
	 GX6k3PeWghnVFDiELmYEx8dvISxhN8m7HEfuf9l18J/SyUUzmZeqbSHVk6hpffKZOtA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017853;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GbDkHa8Bp8zl70wWrzRrp/0TaMz3l6bOdEKauTFq9zg=;
	b=oUDkyY1YrOFjkhEseMCl9hRIIjFTzRbIQyUS5RHxEq0/x0ZAsLpM1JFuJPnyAnrJnXTP
	 ni3nGGC0GvGqsh7OLh9WNSvR1E2hvVDpIJNUmm/mzAOYL1EcxrO0BNwRaB6uartPgORfP
	 9zUddyDfs9MdrwN7fq+6NNkRh9Kmi8Z2yCmZW4JzrvlhJhgPwgmL3hg287Fr57lGx0zhM
	 nHrE0VSXtVBqeiXQr17SIe0W+k433XOJVVQOdVZEtrMTZ8UMM38YFKVEaVi+uAG7m9XKa
	 11wpcyH7uKDicvcOclr7dHy03B3SsA2/0vXbGz2ibSfuP+wuAWEiUzKmqz7HQcYbxog==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="xJR2M/5O";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B90A606A31C;
	Wed, 18 Nov 2026 16:04:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xJR2M/5O
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D3AF1F000C4;
	Wed, 18 Nov 2026 16:04:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017853;
	bh=GbDkHa8Bp8zl70wWrzRrp/0TaMz3l6bOdEKauTFq9zg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xJR2M/5ODNNYUX6Ym/EWZQkYSHiIXPYOPMXTsQokV0aokiDYoRngwcqzacB49MMxc
	 ZDNEj6hnGpqnlkt2MrDEbJbl0uo6uJuntQHszyF7HOAHsTXRoQ+q/F5N4oDTI/8oWM
	 866Lfp0aOeluJ+1M8mWPiIHBe21/adR5oiimEt0A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Venkat Rao Bagalkote <venkat88@linux.ibm.com>,
	Mukesh Kumar Chaurasiya <mkchauras@gmail.com>,
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1031/2651] powerpc/interrupt: Use early_radix_enabled() in NMI real-mode guard
Date: Wed, 18 Nov 2026 15:37:51 +0100
Message-ID: <20261118150325.081509352@linuxfoundation.org>
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

From: Venkat Rao Bagalkote <venkat88@linux.ibm.com>

[ Upstream commit 644ffb02746690c0ebfe143e066f81c9bde2975e ]

radix_enabled() uses a jump label which is only valid after
setup_feature_keys() is called. Before that point, on a pSeries
hash guest, early_check_vec5() clears MMU_FTR_TYPE_RADIX in
cur_cpu_spec->mmu_features, but the jump label has not yet been patched,
so radix_enabled() incorrectly returns true.

The dangerous usage window where it goes wrong in early_setup():

    early_setup:
        configure_exceptions();
        <exceptions can happen now, and handler enter/exit can be invoked>
        <those could use radix_enabled(), which returns stale true>
        setup_feature_keys();
        <jump labels set up; post this it is safe to use radix_enabled()>

If an NMI occurs in this window, !radix_enabled() evaluates to false in
DEFINE_INTERRUPT_HANDLER_NMI. The handler fails to skip NMI entry in real
mode and attempts to access memory outside the Real Mode Area (RMA),
hanging the boot.

Since common interrupt wrappers do not have the context of early or late,
using early_radix_enabled() is the safer option. It does a plain bitmask
check against cur_cpu_spec->mmu_features and is correct at all times.

Console logs from a pSeries HASH guest showing values across boot stages:

[    0.000000] DEBUG: after early_init_devtree: early_radix_enabled=0 radix_enabled=1 (mismatch means NMI real-mode check is unsafe!)
[    0.000000] DEBUG: after configure_exceptions (DANGEROUS WINDOW): early_radix_enabled=0 radix_enabled=1
[    0.000000] DEBUG: after setup_feature_keys (jump labels initialized): early_radix_enabled=0 radix_enabled=0 (should now match!)
[    0.057124] DEBUG: post secondary CPU bringup: early_radix_enabled=0 radix_enabled=0 (should match!)

Console logs from a RADIX guest showing values across boot stages:

[    0.000000] DEBUG: after early_init_devtree: early_radix_enabled=1 radix_enabled=1 (mismatch means NMI real-mode check is unsafe!)
[    0.000000] DEBUG: after configure_exceptions (DANGEROUS WINDOW): early_radix_enabled=1 radix_enabled=1
[    0.000000] DEBUG: after setup_feature_keys (jump labels initialized): early_radix_enabled=1 radix_enabled=1 (should now match!)
[    0.057016] DEBUG: post secondary CPU bringup: early_radix_enabled=1 radix_enabled=1 (should match!)

Add the missing #include <asm/mmu.h> in alphabetical order since
early_radix_enabled() is declared there.

Fixes: 8d0e21012743 ("powerpc/mce: Avoid nmi_enter/exit in real mode on pseries hash")
Signed-off-by: Venkat Rao Bagalkote <venkat88@linux.ibm.com>
Reviewed-by: Mukesh Kumar Chaurasiya <mkchauras@gmail.com>
Reviewed-by: Shrikanth Hegde <sshegde@linux.ibm.com>
Signed-off-by: Madhavan Srinivasan <maddy@linux.ibm.com>
Link: https://patch.msgid.link/20260909123240.58786-1-venkat88@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/include/asm/interrupt.h | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/include/asm/interrupt.h b/arch/powerpc/include/asm/interrupt.h
index 1b45a49e9bed5..355f6bbf9894d 100644
--- a/arch/powerpc/include/asm/interrupt.h
+++ b/arch/powerpc/include/asm/interrupt.h
@@ -70,6 +70,7 @@
 #include <linux/irq-entry-common.h>
 
 #include <asm/kprobes.h>
+#include <asm/mmu.h>
 #include <asm/runlatch.h>
 
 #ifdef CONFIG_PPC_IRQ_SOFT_MASK_DEBUG
@@ -290,7 +291,7 @@ interrupt_handler long func(struct pt_regs *regs)			\
 		state = irqentry_nmi_enter(regs);			\
 	} else if (IS_ENABLED(CONFIG_PPC_BOOK3S_64) &&			\
 		   firmware_has_feature(FW_FEATURE_LPAR) &&		\
-		   !radix_enabled()) {					\
+		   !early_radix_enabled()) {				\
 		/* no nmi_entry for a pseries hash guest		\
 		 * taking a real mode exception */			\
 	} else if (IS_ENABLED(CONFIG_KASAN)) {				\
@@ -307,7 +308,7 @@ interrupt_handler long func(struct pt_regs *regs)			\
 		irqentry_nmi_exit(regs, state);				\
 	} else if (IS_ENABLED(CONFIG_PPC_BOOK3S_64) &&			\
 		   firmware_has_feature(FW_FEATURE_LPAR) &&		\
-		   !radix_enabled()) {					\
+		   !early_radix_enabled()) {				\
 		/* no nmi_exit for a pseries hash guest			\
 		 * taking a real mode exception */			\
 	} else if (IS_ENABLED(CONFIG_KASAN)) {				\
-- 
2.53.0



