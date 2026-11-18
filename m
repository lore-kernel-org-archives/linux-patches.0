Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795037000;
	b=l6ZsEl/C8ElA5WJvwsl9rWwdEu1Tz2YD2IfyeH9ZaNa2L0PyYjLyA5kLeUwbY3N3zyZR
	 k11xGVE1VgVmohY2d0ZEbKacupTCpv36nWkg1lBRBc+Mcjnue0XeWl4lc0IITAEDFli3x
	 hP+9cNZpndPCUnUk5qYVcVxsbRTomyssJYcK9+fvjlpWhXVQvEBIG0AzDjiufzW8einfE
	 l/J1K7c0tWuuYulWaDH7C5fnvbSAn2Kd4Ou9Q2nBNQ4mW0ZwYejymYyhLIC1uOAnGwsQt
	 LDobNOWsY5iIxshwGNOI7l6bDL4aKZHXe/pbbraFVquLYDIq3J7txI4S+ls95YD4viQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795037000;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KYML7KG8kLdnM67gLxX907RxgaqLR0iS4jKNsrIzTRc=;
	b=tJEHgLvYbXXSxghByupHYe+0kHoHaOBAcf0BvzCIGYnGagTlgwPJt/UDrRb1+BPf9+Ob
	 +AsmBYiAeKySvbNQazL+kDuIJhOm5mZYTQmYGPi12B0nhbIUGCZkQj13Scv6D+Iy8Ym3A
	 o5gZ2vIITlGtvND9C5HQq4+tWo9prQQ3c52SYeMueTbHb5mB72UqcqCOk5xSh+TI23vRr
	 wsJDeTcoy0cinjJkL2TIM2Dd0ID5AweoWRSlBWgChRBtRBBmkv3OVz/QnAvuUxJEH0Tcb
	 gosiqVqOCqzxf57WnduNUoF21hXv+5vdR/nR4iwx1JQEmnQYilx//aQaVYRG3xC74tw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HPnZdpL6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8469E606A31C;
	Wed, 18 Nov 2026 21:23:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HPnZdpL6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 902091F000C5;
	Wed, 18 Nov 2026 21:23:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795037000;
	bh=KYML7KG8kLdnM67gLxX907RxgaqLR0iS4jKNsrIzTRc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HPnZdpL6oUqfqWWWKYSjWK1fdegMlRnqF0xC3viG/HxS/Wib70LxiZ1W7v5rGSJs/
	 S1KP3PXL4vnj4MjBnKGBVjp+mnRXr0iqbjUC0Mjox86Ttc89zhM6oE7fz/E7vcwqOB
	 W3Z21/s1xdEMj5LrdJJ+2Dv66PtckKG8MgT/Qia4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tiezhu Yang <yangtiezhu@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1259/3318] LoongArch: Fix architectural naming typo for CSR_FWPS_SKIP
Date: Wed, 18 Nov 2026 15:31:21 +0100
Message-ID: <20261118150357.971788016@linuxfoundation.org>
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
index ce3fc1666868e..e0072b0e28652 100644
--- a/arch/loongarch/include/asm/loongarch.h
+++ b/arch/loongarch/include/asm/loongarch.h
@@ -1043,8 +1043,8 @@
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
index 0529bd32c1f17..fd1921718fefc 100644
--- a/arch/loongarch/kernel/traps.c
+++ b/arch/loongarch/kernel/traps.c
@@ -787,7 +787,7 @@ asmlinkage void noinstr do_watch(struct pt_regs *regs)
 			 * instruction. So don't clear llbit and reset CSR.FWPS.Skip until
 			 * the llsc execution is completed.
 			 */
-			csr_write32(CSR_FWPC_SKIP, LOONGARCH_CSR_FWPS);
+			csr_write32(CSR_FWPS_SKIP, LOONGARCH_CSR_FWPS);
 			csr_write32(CSR_LLBCTL_KLO, LOONGARCH_CSR_LLBCTL);
 			goto out;
 		}
@@ -804,7 +804,7 @@ asmlinkage void noinstr do_watch(struct pt_regs *regs)
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



