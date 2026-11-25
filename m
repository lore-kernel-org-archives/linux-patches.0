Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625210;
	b=bIzxgNxhKj4zxgnP4oFgo6wrS2AGmwQ7B5OU9rVepaHjpSrIVZ0xZq5kp2I2mmpy5Zd/
	 mi0t/3ypsFEjaWkKU6NaPnEtiI5uW5XZwWBj3A24w7Xo4MW9OytnQ5+xBcwUBGJKqWGeg
	 VGIQw/UG+uN6LnHVaFiSqWVBKlOpv+I0WLyrEjZWY/tgCIOTMe/RgE+2z8RnY2AQMzv0y
	 xcrUDjxLjApjLDRQcBJISUk4X0nYSV8XKVDpJWJADjxfWZbiFdf3W4HCvAx1vCncsbqrY
	 aczF0JfvjtHQWR1ze7gCkW4m3sLChET+8u32OG+fKqgu7W5ptiWLq/CT/3K88LtePkQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625210;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VnotZzpvHyJMTMKvT52qivvGZm1oy56beyj5jokOAxA=;
	b=cBGPuQM9uX8Xt/h+OzLDn03124Chbm3JXaYV8E0IGVlZyvmfABlmOMVQiD4cVZU2X2TB
	 1oJdtmMcrYKRBMNC8Ul8ulX2HnegfIumwKpM88OFNMX6i2ly0J+rcoO8aSxVcQhUreowC
	 Cc6qAvs/yHbT7UR8cAne85lUSYQmRVSEmtewSJeSWRjrctZfYqH6ta3Sd/d1/obRNy+xB
	 IspN2iCnuWj29jZEcHxInYujpmBECe0kv6tn3fLh+rC0kbXFF/F5e107/K5/xuupjwfIC
	 qr+LbfmnrMd6TIC9V7/6seOk6jqlmW/a7dxXu49ed7UB0ZSCg554v5GqGhKmCXfClSA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FLhuCZBx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EAF6606A329;
	Wed, 25 Nov 2026 16:46:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FLhuCZBx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D34741F000C0;
	Wed, 25 Nov 2026 16:46:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625210;
	bh=VnotZzpvHyJMTMKvT52qivvGZm1oy56beyj5jokOAxA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FLhuCZBx810NGYQTRrXy2x/eImuAnbLz3/zDKvLfgT/dlx48hlrSxQkm/xwKGwn/3
	 mV2DiXokLPUSY9w1H3U0oMmsj8HyhyW9Mw72NOdy/NPXgvldg0jq+ud+p88Ba3BTgP
	 eKAF8lwHYyLHU8DeEZCu3yqWVeUYYSOBlej3n9E8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Venkat Rao Bagalkote <venkat88@linux.ibm.com>,
	Mukesh Kumar Chaurasiya <mkchauras@gmail.com>,
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 442/816] powerpc/interrupt: Use early_radix_enabled() in NMI real-mode guard
Date: Wed, 25 Nov 2026 15:33:10 +0100
Message-ID: <20261125143859.420654437@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: Moved the pseries-hash real-mode NMI guards from the upstream DEFINE_INTERRUPT_HANDLER_NMI macro to the two static inline functions interrupt_nmi_enter_prepare() and interrupt_nmi_exit_prepare(), with the include context adjusted. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/include/asm/interrupt.h | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/include/asm/interrupt.h b/arch/powerpc/include/asm/interrupt.h
index 23638d4e73ac0..bf25db6848ce8 100644
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



