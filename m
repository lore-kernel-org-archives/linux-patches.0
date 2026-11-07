Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062665;
	b=Uukn0p4/tOBEA5GpOHS7mUZ1834D7b8zCEv+RDB6d7F6rBhLIE5OhYW/MSmK4dasNl6H
	 UrHYTnxi7wmu0Kg97ZjK4yI/mV8J2pb8ZmLGe9yD52HknBFtbTb/Ryqt+PtTLL25KG1aW
	 9uL5+bRyrXJUos/tsWfr+jYHHSAr+wP+m3CtRhnJR/7sCzUAcjRrqOHiVlKCxvwfc3IgZ
	 +xhkdmgYT3bP3NjNfgNm4R6TpSZkN6/0LkYQKgDxm/Icm/PMdYGGqGRC86uLE6f/HEdjD
	 Xrlnp9T+9E4le+3EtsJS3ZawX4uWHo5BoE4BKItUzR5tN9zgVJ+n1W7N01ju7WB19LA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062665;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=puhGiS5l8LrAvHYhBpZTRbJFnV2xJR2dBJup2vSRf7M=;
	b=c44Ry/UkkgTWxLhT5K/XYsShFlOrnpH1WvWIUO4gaa5CKACAB6Y6Hjqea1BOmUEeUib7
	 Y0BhO8S9ZFJlcL/BlM8Tt1aWdvbifPPEIph6qoL/dquqSV7huZNhW36yaWZcYL3tTh3HM
	 K2NuGcn+TdCFp8hQLJqepcKmJ8Dim9MTNfzV4gh5edv6wY/Y6nODr+QiIeTbqgBS0AOKx
	 TP72cR8XKR3OOysxVThuT2H7fvXdWx2aOkCIhPCl2bwxS0qDyOqmXjg2HcSTJgEajrzW3
	 GO7jOxz2rm6UjjaRNp1JdHw4/w66n/1vJwyZw4JcySOXVHoeBQGiZxqRHG5Ix4eKLWQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=igCbpx4u;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C825606A32C;
	Sat,  7 Nov 2026 14:44:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=igCbpx4u
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BDD41F0089F;
	Sat,  7 Nov 2026 14:44:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062665;
	bh=puhGiS5l8LrAvHYhBpZTRbJFnV2xJR2dBJup2vSRf7M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=igCbpx4unFqwWlK/zF7OUmRB8LV8nEMDxgNXTWPu/V6LAOUwCWY/8KexSiJFGnYZV
	 70Hm5RT3ik5HeEZABwBoRDx9Y/vZ5um9xO+xbH0+b8VZ7UAU37fslP1mh8h3VpB8fJ
	 V+jMa9H/8tS8zGaLy9AfM+lNFkwR5JmdCdem6Q0w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tiezhu Yang <yangtiezhu@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1490/1536] LoongArch: Fix architectural naming typo for CSR_FWPS_SKIP
Date: Sat,  7 Nov 2026 08:58:26 -0500
Message-ID: <20261107135039.707368402@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

From: Tiezhu Yang <yangtiezhu@loongson.cn>

[ Upstream commit f322ebfdfda2bce91fb1d3fb0072c735051fed85 ]

According to the LoongArch Reference Manual, the single-step 'Skip' bit
resides in the instruction breakpoint status register (CSR.FWPS), rather
than the configuration register (CSR.FWPC).

Furthermore, the kernel code comments also explicitly document it as
"CSR.FWPS.Skip", yet the macro was erroneously defined as CSR_FWPC_SKIP
and used as such in traps.c and hw_breakpoint.c. This mismatch creates
architectural naming confusion.

Fix this by renaming the macro from CSR_FWPC_SKIP to CSR_FWPS_SKIP to
precisely match the manual and comments. Also, update all call sites to
align with the rectified definition.

Cc: stable@vger.kernel.org
Fixes: 424421a7f34c ("LoongArch: ptrace: Add hardware single step support")
Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/loongarch/include/asm/loongarch.h | 4 ++--
 arch/loongarch/kernel/hw_breakpoint.c  | 2 +-
 arch/loongarch/kernel/traps.c          | 4 ++--
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/loongarch/include/asm/loongarch.h b/arch/loongarch/include/asm/loongarch.h
index aaa4ad6b85944..8e6366a21fdd8 100644
--- a/arch/loongarch/include/asm/loongarch.h
+++ b/arch/loongarch/include/asm/loongarch.h
@@ -1066,8 +1066,8 @@
 #define LOONGARCH_CSR_DERA		0x501	/* debug era */
 #define LOONGARCH_CSR_DESAVE		0x502	/* debug save */
 
-#define CSR_FWPC_SKIP_SHIFT		16
-#define CSR_FWPC_SKIP			(_ULCAST_(1) << CSR_FWPC_SKIP_SHIFT)
+#define CSR_FWPS_SKIP_SHIFT		16
+#define CSR_FWPS_SKIP			(_ULCAST_(1) << CSR_FWPS_SKIP_SHIFT)
 
 /*
  * CSR_ECFG IM
diff --git a/arch/loongarch/kernel/hw_breakpoint.c b/arch/loongarch/kernel/hw_breakpoint.c
index bd891b3808a6b..7f69cf361a5e2 100644
--- a/arch/loongarch/kernel/hw_breakpoint.c
+++ b/arch/loongarch/kernel/hw_breakpoint.c
@@ -550,7 +550,7 @@ void hw_breakpoint_thread_switch(struct task_struct *next)
 		addr = read_wb_reg(CSR_CFG_ADDR, 0, 0);
 		mask = read_wb_reg(CSR_CFG_MASK, 0, 0);
 		if (!((regs->csr_era ^ addr) & ~mask))
-			csr_write32(CSR_FWPC_SKIP, LOONGARCH_CSR_FWPS);
+			csr_write32(CSR_FWPS_SKIP, LOONGARCH_CSR_FWPS);
 		regs->csr_prmd |= CSR_PRMD_PWE;
 	} else {
 		/* Update breakpoints */
diff --git a/arch/loongarch/kernel/traps.c b/arch/loongarch/kernel/traps.c
index 40c162fb645a3..4fbb2d546c2fe 100644
--- a/arch/loongarch/kernel/traps.c
+++ b/arch/loongarch/kernel/traps.c
@@ -813,7 +813,7 @@ asmlinkage void noinstr do_watch(struct pt_regs *regs)
 			 * instruction. So don't clear llbit and reset CSR.FWPS.Skip until
 			 * the llsc execution is completed.
 			 */
-			csr_write32(CSR_FWPC_SKIP, LOONGARCH_CSR_FWPS);
+			csr_write32(CSR_FWPS_SKIP, LOONGARCH_CSR_FWPS);
 			csr_write32(CSR_LLBCTL_KLO, LOONGARCH_CSR_LLBCTL);
 			goto out;
 		}
@@ -830,7 +830,7 @@ asmlinkage void noinstr do_watch(struct pt_regs *regs)
 				 * current pc, If yes, then we should not set the CSR.FWPS.SKIP
 				 * bit to break the original instruction stream.
 				 */
-				csr_write32(CSR_FWPC_SKIP, LOONGARCH_CSR_FWPS);
+				csr_write32(CSR_FWPS_SKIP, LOONGARCH_CSR_FWPS);
 				goto out;
 			}
 		}
-- 
2.53.0



