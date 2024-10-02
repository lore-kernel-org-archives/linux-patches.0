Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6FF41D0E35;
	Wed,  2 Oct 2024 14:21:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727878899; cv=none; b=m4wBv919KcX1gA7QhYuWDmb/373NM346xd6lcvSpLvxaos2e/Hpj1u8QR0x5Uslj/3xzLmAJfyWnbeghzN15FkOzGGJkt0b4QlEXjfc5mlC+3Ig8UqadyGrRAbKmk0QiEtGE2KxS/+P97yJdkbrYDT/cNpuu+VnmfkQ8Cp1OkDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727878899; c=relaxed/simple;
	bh=YCUf02teDD330e1hN6u+t4Y2VMwfmY6P/jF3s2epV+8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IhL/8ntD9NGqvqdSJyYP8IcQhgKAWgoub5wphRZyAvTYqidC3/Vs8UpUaLeKOV7ZSCk0Fd/3D0zykVP+nx8A9Wxl1pCd7ooFLl+MrwcJ/5oNksDi5gytUpmOogff7dvsvn9ewg+rLN52ETZUSY3o72H02Ic49It5bIt/w3VJtNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A+9VY8zp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A+9VY8zp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43499C4CEC5;
	Wed,  2 Oct 2024 14:21:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727878899;
	bh=YCUf02teDD330e1hN6u+t4Y2VMwfmY6P/jF3s2epV+8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A+9VY8zpZ+WaGvtxoy2SmhbzmqGV/IlD82X/KQ1wj9uL0UpT207EG1I56Z8/n/lDY
	 pZvt5lnQguMN16ZV7tNAvrNCEFSsPAg25EB/iTlr3XnN4BzVgotEeKCaDAljxj4N0m
	 K7GBifsaxKkdgQDWzyd837E7K+ZdgP08vPdSeGV4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anastasia Belova <abelova@astralinux.ru>,
	Marc Zyngier <maz@kernel.org>,
	Will Deacon <will@kernel.org>
Subject: [PATCH 6.10 569/634] arm64: esr: Define ESR_ELx_EC_* constants as UL
Date: Wed,  2 Oct 2024 15:01:09 +0200
Message-ID: <20241002125833.575827406@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anastasia Belova <abelova@astralinux.ru>

commit b6db3eb6c373b97d9e433530d748590421bbeea7 upstream.

Add explicit casting to prevent expantion of 32th bit of
u32 into highest half of u64 in several places.

For example, in inject_abt64:
ESR_ELx_EC_DABT_LOW << ESR_ELx_EC_SHIFT = 0x24 << 26.
This operation's result is int with 1 in 32th bit.
While casting this value into u64 (esr is u64) 1
fills 32 highest bits.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Cc: <stable@vger.kernel.org>
Fixes: aa8eff9bfbd5 ("arm64: KVM: fault injection into a guest")
Signed-off-by: Anastasia Belova <abelova@astralinux.ru>
Acked-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/stable/20240910085016.32120-1-abelova%40astralinux.ru
Link: https://lore.kernel.org/r/20240910085016.32120-1-abelova@astralinux.ru
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/include/asm/esr.h |   88 +++++++++++++++++++++----------------------
 1 file changed, 44 insertions(+), 44 deletions(-)

--- a/arch/arm64/include/asm/esr.h
+++ b/arch/arm64/include/asm/esr.h
@@ -10,63 +10,63 @@
 #include <asm/memory.h>
 #include <asm/sysreg.h>
 
-#define ESR_ELx_EC_UNKNOWN	(0x00)
-#define ESR_ELx_EC_WFx		(0x01)
+#define ESR_ELx_EC_UNKNOWN	UL(0x00)
+#define ESR_ELx_EC_WFx		UL(0x01)
 /* Unallocated EC: 0x02 */
-#define ESR_ELx_EC_CP15_32	(0x03)
-#define ESR_ELx_EC_CP15_64	(0x04)
-#define ESR_ELx_EC_CP14_MR	(0x05)
-#define ESR_ELx_EC_CP14_LS	(0x06)
-#define ESR_ELx_EC_FP_ASIMD	(0x07)
-#define ESR_ELx_EC_CP10_ID	(0x08)	/* EL2 only */
-#define ESR_ELx_EC_PAC		(0x09)	/* EL2 and above */
+#define ESR_ELx_EC_CP15_32	UL(0x03)
+#define ESR_ELx_EC_CP15_64	UL(0x04)
+#define ESR_ELx_EC_CP14_MR	UL(0x05)
+#define ESR_ELx_EC_CP14_LS	UL(0x06)
+#define ESR_ELx_EC_FP_ASIMD	UL(0x07)
+#define ESR_ELx_EC_CP10_ID	UL(0x08)	/* EL2 only */
+#define ESR_ELx_EC_PAC		UL(0x09)	/* EL2 and above */
 /* Unallocated EC: 0x0A - 0x0B */
-#define ESR_ELx_EC_CP14_64	(0x0C)
-#define ESR_ELx_EC_BTI		(0x0D)
-#define ESR_ELx_EC_ILL		(0x0E)
+#define ESR_ELx_EC_CP14_64	UL(0x0C)
+#define ESR_ELx_EC_BTI		UL(0x0D)
+#define ESR_ELx_EC_ILL		UL(0x0E)
 /* Unallocated EC: 0x0F - 0x10 */
-#define ESR_ELx_EC_SVC32	(0x11)
-#define ESR_ELx_EC_HVC32	(0x12)	/* EL2 only */
-#define ESR_ELx_EC_SMC32	(0x13)	/* EL2 and above */
+#define ESR_ELx_EC_SVC32	UL(0x11)
+#define ESR_ELx_EC_HVC32	UL(0x12)	/* EL2 only */
+#define ESR_ELx_EC_SMC32	UL(0x13)	/* EL2 and above */
 /* Unallocated EC: 0x14 */
-#define ESR_ELx_EC_SVC64	(0x15)
-#define ESR_ELx_EC_HVC64	(0x16)	/* EL2 and above */
-#define ESR_ELx_EC_SMC64	(0x17)	/* EL2 and above */
-#define ESR_ELx_EC_SYS64	(0x18)
-#define ESR_ELx_EC_SVE		(0x19)
-#define ESR_ELx_EC_ERET		(0x1a)	/* EL2 only */
+#define ESR_ELx_EC_SVC64	UL(0x15)
+#define ESR_ELx_EC_HVC64	UL(0x16)	/* EL2 and above */
+#define ESR_ELx_EC_SMC64	UL(0x17)	/* EL2 and above */
+#define ESR_ELx_EC_SYS64	UL(0x18)
+#define ESR_ELx_EC_SVE		UL(0x19)
+#define ESR_ELx_EC_ERET		UL(0x1a)	/* EL2 only */
 /* Unallocated EC: 0x1B */
-#define ESR_ELx_EC_FPAC		(0x1C)	/* EL1 and above */
-#define ESR_ELx_EC_SME		(0x1D)
+#define ESR_ELx_EC_FPAC		UL(0x1C)	/* EL1 and above */
+#define ESR_ELx_EC_SME		UL(0x1D)
 /* Unallocated EC: 0x1E */
-#define ESR_ELx_EC_IMP_DEF	(0x1f)	/* EL3 only */
-#define ESR_ELx_EC_IABT_LOW	(0x20)
-#define ESR_ELx_EC_IABT_CUR	(0x21)
-#define ESR_ELx_EC_PC_ALIGN	(0x22)
+#define ESR_ELx_EC_IMP_DEF	UL(0x1f)	/* EL3 only */
+#define ESR_ELx_EC_IABT_LOW	UL(0x20)
+#define ESR_ELx_EC_IABT_CUR	UL(0x21)
+#define ESR_ELx_EC_PC_ALIGN	UL(0x22)
 /* Unallocated EC: 0x23 */
-#define ESR_ELx_EC_DABT_LOW	(0x24)
-#define ESR_ELx_EC_DABT_CUR	(0x25)
-#define ESR_ELx_EC_SP_ALIGN	(0x26)
-#define ESR_ELx_EC_MOPS		(0x27)
-#define ESR_ELx_EC_FP_EXC32	(0x28)
+#define ESR_ELx_EC_DABT_LOW	UL(0x24)
+#define ESR_ELx_EC_DABT_CUR	UL(0x25)
+#define ESR_ELx_EC_SP_ALIGN	UL(0x26)
+#define ESR_ELx_EC_MOPS		UL(0x27)
+#define ESR_ELx_EC_FP_EXC32	UL(0x28)
 /* Unallocated EC: 0x29 - 0x2B */
-#define ESR_ELx_EC_FP_EXC64	(0x2C)
+#define ESR_ELx_EC_FP_EXC64	UL(0x2C)
 /* Unallocated EC: 0x2D - 0x2E */
-#define ESR_ELx_EC_SERROR	(0x2F)
-#define ESR_ELx_EC_BREAKPT_LOW	(0x30)
-#define ESR_ELx_EC_BREAKPT_CUR	(0x31)
-#define ESR_ELx_EC_SOFTSTP_LOW	(0x32)
-#define ESR_ELx_EC_SOFTSTP_CUR	(0x33)
-#define ESR_ELx_EC_WATCHPT_LOW	(0x34)
-#define ESR_ELx_EC_WATCHPT_CUR	(0x35)
+#define ESR_ELx_EC_SERROR	UL(0x2F)
+#define ESR_ELx_EC_BREAKPT_LOW	UL(0x30)
+#define ESR_ELx_EC_BREAKPT_CUR	UL(0x31)
+#define ESR_ELx_EC_SOFTSTP_LOW	UL(0x32)
+#define ESR_ELx_EC_SOFTSTP_CUR	UL(0x33)
+#define ESR_ELx_EC_WATCHPT_LOW	UL(0x34)
+#define ESR_ELx_EC_WATCHPT_CUR	UL(0x35)
 /* Unallocated EC: 0x36 - 0x37 */
-#define ESR_ELx_EC_BKPT32	(0x38)
+#define ESR_ELx_EC_BKPT32	UL(0x38)
 /* Unallocated EC: 0x39 */
-#define ESR_ELx_EC_VECTOR32	(0x3A)	/* EL2 only */
+#define ESR_ELx_EC_VECTOR32	UL(0x3A)	/* EL2 only */
 /* Unallocated EC: 0x3B */
-#define ESR_ELx_EC_BRK64	(0x3C)
+#define ESR_ELx_EC_BRK64	UL(0x3C)
 /* Unallocated EC: 0x3D - 0x3F */
-#define ESR_ELx_EC_MAX		(0x3F)
+#define ESR_ELx_EC_MAX		UL(0x3F)
 
 #define ESR_ELx_EC_SHIFT	(26)
 #define ESR_ELx_EC_WIDTH	(6)


