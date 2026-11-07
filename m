Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065527;
	b=V/B/YXlRrsVemNoN+QFFFMCQGQTF4QVaZhyhaqCpBDbH+P5TGvhs90arPRQk6iJqDsz6
	 HqYZ5tXZhpGFRWXVZRT6hegvD4o9XFnr1Jf5OjssIO015EyihftZ3J6/prdjoKAoAlB9t
	 duMHDf8IUDCPGAcfUGx9b9GIbpqoUE24OjNQ2OB6c6Joqo9zOc6jpQy7YshFGPrHcDnjW
	 KXo9U6WMPtGkrEhxli5KQhA6H6h9VX3m27vauL1bf75l1LIAybQr1aj7ypjucli2EnpW4
	 j/KRZkxUffNcNBktbisoOMtIR2Hq7d9Vuo/QHdXtxsdhDqYONosIymmkbAnVyM74ZGQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065527;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hX2wJ2f0IcNe7ZBBb9bMMTCgecYbWSlEkjy4PRuzLaA=;
	b=CbTyjuZVvP7K9sxrntk6ITbJpLp92PwBM1O/Mg5WhSdvSMSJp0eshx3fStC0B9v4+slt
	 d7XX8BLGk9JHeI9fcNOK78qbRSj72tHL6+z9c2uy0wfncYDDBHL7DhmX86Ho5ycO5Qp7F
	 M+Fqne9mAnro5JvGCKaalraVDC6AhXcWATnPdfCvzlg3sk2iqrfSZmAUPGud+ewXYRBmx
	 rL/O3i/moqQHEqF0qtDkUKgvU4h/KMJhLz3gtqZkaoOarXQQxLUesHbpEBK2oDFfqImWV
	 QFRAX+EfMx9KkQlFUlcGVowJX8x/dJnLL2cHQo+gwTAhRpJxAydiseK8XVisHBFIa+g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tJjcVPCW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2322E606D805;
	Sat,  7 Nov 2026 15:32:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tJjcVPCW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4D8D1F0089F;
	Sat,  7 Nov 2026 15:32:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065527;
	bh=hX2wJ2f0IcNe7ZBBb9bMMTCgecYbWSlEkjy4PRuzLaA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tJjcVPCWFbeUl+UsylKglTRWIRNCaXMrUVPtFn9Li0KkcUdyANX11OhZh4hXcEmY0
	 bfVKR74C/Bmu40l2l7v2MDaYAxfqvKcYBs6IMVrVZ0resbZU2P8Y+3TGuPsWGxyFx+
	 un9k3wTUVRpuaL8oPpYMAEiUv8ZPfJdCqfc7lWlA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tiezhu Yang <yangtiezhu@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1168/1257] LoongArch: Fix architectural naming typo for CSR_FWPS_SKIP
Date: Sat,  7 Nov 2026 08:57:44 -0500
Message-ID: <20261107135011.443747110@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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
index 2a6bc99177d8a..32bbff337c5c4 100644
--- a/arch/loongarch/include/asm/loongarch.h
+++ b/arch/loongarch/include/asm/loongarch.h
@@ -1130,8 +1130,8 @@
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
index 776523747ea38..c4d7e55fb3ea5 100644
--- a/arch/loongarch/kernel/traps.c
+++ b/arch/loongarch/kernel/traps.c
@@ -829,7 +829,7 @@ asmlinkage void noinstr do_watch(struct pt_regs *regs)
 			 * instruction. So don't clear llbit and reset CSR.FWPS.Skip until
 			 * the llsc execution is completed.
 			 */
-			csr_write32(CSR_FWPC_SKIP, LOONGARCH_CSR_FWPS);
+			csr_write32(CSR_FWPS_SKIP, LOONGARCH_CSR_FWPS);
 			csr_write32(CSR_LLBCTL_KLO, LOONGARCH_CSR_LLBCTL);
 			goto out;
 		}
@@ -846,7 +846,7 @@ asmlinkage void noinstr do_watch(struct pt_regs *regs)
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



