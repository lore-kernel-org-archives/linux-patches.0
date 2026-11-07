Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063750;
	b=NIoM/P5Y0Foo05oMtxPD6635DDgr+tGFgsGrOwfbYo0kZhBmM/DKTM/scmxVF+NIu6/a
	 k43MnGSIkGCcL6IBvKlTBMB8v2sJuUgirVWZHJQVGnucU4XyA4T/S4RLJDD7OWS6OTw2a
	 XgX8eMesBYDbDXcHmdVjYWGOpIg4Um7gbzsdSYFnpua3YFy0VU/7AvD7oYx41aoK4r6dV
	 tzp234TBPVPuLMSCC/4Ibee4+kD297S6shrldzRCGP0CiaAOYHDyZQjtzU1utRdW1ehIe
	 /oFWZv8p6LF5gJBJHuAW2qF7a69oXfCwsEGJF/18yAmEaUywm9uyfKCtI8cZaN7ma5Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063750;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZYgw0zdJsQN1lO84kFyvQkkdaQRfIVJENHuZ85bSLsk=;
	b=HpCerevJv+MAz30nCJ431IhX78u4iFmtdt1ieBadpQbIcl3lN5qQOMtqEN1i/Xo2T2c0
	 jmAoSfqB5LpFFUN8WTVg98UOF2naQI8kA5W8xKrRoenO2NdL91DMpHviw2LoZbrLtW0XZ
	 8wx75MEFMC2tafnf1E3EPJUaRSTXnhLE+WX7h69WBKNyYP0IvdnLK2gamwnXA87pUdkWV
	 IthSttVbkf8Hddglec+KtQ1jmkfK1PDpDz8Tr+xiuU6/FUpE4DCqUCDEaBw/z9jDcnqBB
	 UryBHhkbkrqI2ZdVaDH1sOhhp64zcm9fIjwVM69lIvZsG26mtZIBnzg4wAc0Ba3n8nQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RU3wm8Y5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 534E7606D809;
	Sat,  7 Nov 2026 15:02:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RU3wm8Y5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8E911F0089F;
	Sat,  7 Nov 2026 15:02:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063750;
	bh=ZYgw0zdJsQN1lO84kFyvQkkdaQRfIVJENHuZ85bSLsk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RU3wm8Y5H9+C6thfQUOwQGkgH57bOcLKvXlVGEP3sGPUam7b1hFrvtPN0TqiS/7K2
	 n4geRi72S7YR6Ju3SGrCi2DD0XCmrO5hrof3rsMh5mAWgGXRNpoeqkpHh62Vz+nWGi
	 YdSd1F3Y0U2Pp265pYFfpH34je+HWnCQnfVcNydM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tiezhu Yang <yangtiezhu@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 807/869] LoongArch: Fix architectural naming typo for CSR_FWPS_SKIP
Date: Sat,  7 Nov 2026 08:58:09 -0500
Message-ID: <20261107134920.359854798@linuxfoundation.org>
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
index 58a4a3b6b035d..642dc9adddceb 100644
--- a/arch/loongarch/include/asm/loongarch.h
+++ b/arch/loongarch/include/asm/loongarch.h
@@ -1090,8 +1090,8 @@
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
index 8e51ce004572c..4c2e5a13f07e4 100644
--- a/arch/loongarch/kernel/traps.c
+++ b/arch/loongarch/kernel/traps.c
@@ -821,7 +821,7 @@ asmlinkage void noinstr do_watch(struct pt_regs *regs)
 			 * instruction. So don't clear llbit and reset CSR.FWPS.Skip until
 			 * the llsc execution is completed.
 			 */
-			csr_write32(CSR_FWPC_SKIP, LOONGARCH_CSR_FWPS);
+			csr_write32(CSR_FWPS_SKIP, LOONGARCH_CSR_FWPS);
 			csr_write32(CSR_LLBCTL_KLO, LOONGARCH_CSR_LLBCTL);
 			goto out;
 		}
@@ -838,7 +838,7 @@ asmlinkage void noinstr do_watch(struct pt_regs *regs)
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



