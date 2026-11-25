Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622501;
	b=3hAMVGgD+W/nNmeDDhJCb+GsJ6uaDI4T1Ac3zA67ncEVHCxmn4Dfvqy1DQWLOJiutt/X
	 L4Lg2o/RoS8DCnRxAZL+W9LMbrm+to9mLyUDAwHu5l5R1tFRn12WCCEaR9eHtSIpaKq8P
	 tr4ttHYHXxtLtF1HgtoFTmEfqGsaNCjJMxlgIPOt7ePxBLbNWZZUZ/IEssiuzIXM3W8mR
	 GjAlOR7Jjsv5mVwyyPGWrE4XHTb3PZQmQ4RX9HctuMT8V4+23JiYJxDmvD3DeUf0rpQn9
	 Jx6pVx9N0bJFavgbMdTzPVUFsGgsCaoY9pFZADLTIkdfCBWq6M4Ui8FNGru7Ibca4Vw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622501;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xiu2cEAhd2AfjxW0+IUNEgZ9we94uEEkQrMdO8zZISs=;
	b=vSbWZgtorwdTGifAQzUZzYJL4B7fuisBmTGD98ApUICuQT23fzW0ae2ThLoEHTf0IJmE
	 rbYN056LxH6ZT9KcvMHBy/dVy+c+QBVCZszAz/BxBMLJnuhy9gfRvZB9I15HeK56nRAb4
	 6+BRkoZ9+uAICb6QoMuKV9Osy7mB4TIve0ZfQ6TxJI+S3jE7/imi83ilSqR7ARTD2ZPwn
	 JDU8yLu5CU2BXl1moiM/Ag+Je2nW7tMm1nZt600lv/gv8OKJM6MktnHfwxJ6rcQKyucSy
	 B/3lUjJHfrq3CJ2XNsXGBQZPS3F3LUzy48O02b+4I31b+Fd06VMkEsA3/RY6jEUQyew==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1MRoBE6d;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 832DC606A323;
	Wed, 25 Nov 2026 16:01:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1MRoBE6d
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADCBE1F000CF;
	Wed, 25 Nov 2026 16:01:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622501;
	bh=xiu2cEAhd2AfjxW0+IUNEgZ9we94uEEkQrMdO8zZISs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1MRoBE6d4lsRVYy3sdhO0JcXHq1hoFMu+XvuhIOFgI/Lkv7Ych0j4C61ecqIPtblp
	 JTisSas8zFfCjPz4u21o+RdOuRQehirCK4yK8hhXkBoKNjn8NJG1VOSV/d0aV8O5jS
	 3a+ajysAvrrlWjkAI7aTdTY98AuZU8fiGzFwNNQY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Venkat Rao Bagalkote <venkat88@linux.ibm.com>,
	Mukesh Kumar Chaurasiya <mkchauras@gmail.com>,
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 559/990] powerpc/interrupt: Use early_radix_enabled() in NMI real-mode guard
Date: Wed, 25 Nov 2026 15:32:06 +0100
Message-ID: <20261125143835.190929518@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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
[ sashal: Applied the early_radix_enabled() change in the interrupt_nmi_enter_prepare() and interrupt_nmi_exit_prepare() helpers instead of the DEFINE_INTERRUPT_HANDLER_NMI macro body, since the logic was already refactored there. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/include/asm/interrupt.h | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/include/asm/interrupt.h b/arch/powerpc/include/asm/interrupt.h
index eb0e4a20b8188..af8c7df0ab9d0 100644
--- a/arch/powerpc/include/asm/interrupt.h
+++ b/arch/powerpc/include/asm/interrupt.h
@@ -72,6 +72,7 @@
 #include <asm/firmware.h>
 #include <asm/ftrace.h>
 #include <asm/kprobes.h>
+#include <asm/mmu.h>
 #include <asm/runlatch.h>
 
 #ifdef CONFIG_PPC_IRQ_SOFT_MASK_DEBUG
@@ -326,7 +327,7 @@ static inline void interrupt_nmi_enter_prepare(struct pt_regs *regs, struct inte
 	 */
 	if (IS_ENABLED(CONFIG_PPC_BOOK3S_64) &&
 	    firmware_has_feature(FW_FEATURE_LPAR) &&
-	    !radix_enabled())
+	    !early_radix_enabled())
 		return;
 
 	/*
@@ -355,7 +356,7 @@ static inline void interrupt_nmi_exit_prepare(struct pt_regs *regs, struct inter
 		nmi_exit();
 	} else if (IS_ENABLED(CONFIG_PPC_BOOK3S_64) &&
 		   firmware_has_feature(FW_FEATURE_LPAR) &&
-		   !radix_enabled()) {
+		   !early_radix_enabled()) {
 		// no nmi_exit for a pseries hash guest taking a real mode exception
 	} else if (IS_ENABLED(CONFIG_KASAN)) {
 		// no nmi_exit for KASAN in real mode
-- 
2.53.0



