Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039069;
	b=w2R+TboViI0qECH+0GP4HV2Yx37BFfvBWi7p+sTlbewoTbyoD1VWJHS5ijX53lKj6VDZ
	 EpVTa6dhSWWJ4fhQfZ7PRkSoQkjqveiG//RBUjp+1krRb1LGJoX4AVNFhqGw2McV0lKKc
	 2PRnFJj7qS1Szm5R+5dtUuggr+kc8XRskInwR9hl8I1+vSMlrKtOdDsUFrfYlEHWFkkM/
	 0UBe3K0MOfaBDxco5K8ikP4P+ajkAzAywlowelQiqG9QPO4zJhlJfu0R9fGMfkQfVSrGX
	 nelLHdCdcWTUayznbvyvHsool5KomyEshuxbGpfSwE/26Pb2Guq78fSfymP6C3bYYPw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039069;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+NXln/sOexHLS6JFeU4WYeMUuXq19UBf9kFIz6tcqKY=;
	b=kzP8dI0CEzfcqhZ9iYHe7rtJHETVKjCxABLfqg+hxGm56YdKp9hBUMEMfhD6keZZaP/Z
	 dl8X12peo/rjD0B4nbBvP0lgIIgMbxrDP1gxMsOs7uvVlvCDtBIxUWAU4+SRw6vJa9RKd
	 R59R+wibkaTq9LbPn7mmrs5o7B83Pb/s/fMRxhSbTVmJMr2JLFjd/Afw6CIyu+KNq427k
	 /19sJQKyJ5wQB1a/WK1mH005T3xp8tWgp466sQ+4wvZhCwJD2lTJFzGPKytNGIEb3ciS8
	 RPDhOJNdamnk3ahM1ErBByXDziV22Th2E+W0OglB+h91jAAVupx2I8wuCfIntMTpfBw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IpjvfEkG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD72C606A339;
	Wed, 18 Nov 2026 21:57:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IpjvfEkG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DDB71F000C9;
	Wed, 18 Nov 2026 21:57:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039069;
	bh=+NXln/sOexHLS6JFeU4WYeMUuXq19UBf9kFIz6tcqKY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IpjvfEkGqqFMiMWNXES7IuRd92iigjy2Dw7OnuZgERc6Q6b9t41QTNWzxguVXfprv
	 Fjq1Z6UQ7yBiyEPVsa2eIBnJx2ThWBXwLzvpO8eGD1jROrUr7W+xFsTamF+R/Vn5wF
	 thV7fpBbIfX7ZZTGqoyZ/Jtl8pp3GYbnfs7b0ns4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yeoreum Yun <yeoreum.yun@arm.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Kevin Brodsky <kevin.brodsky@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1961/3318] arm64: Fix cleared E0POE bit after cpu_suspend()/resume()
Date: Wed, 18 Nov 2026 15:43:03 +0100
Message-ID: <20261118150420.917863870@linuxfoundation.org>
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

From: Yeoreum Yun <yeoreum.yun@arm.com>

[ Upstream commit bdf3f4176092df5281877cacf42f843063b4784d ]

TCR2_ELx.E0POE is set during smp_init().
However, this bit is not reprogrammed when the CPU enters suspension and
later resumes via cpu_resume(), as __cpu_setup() does not re-enable E0POE
and there is no save/restore logic for the TCR2_ELx system register.

As a result, the E0POE feature no longer works after cpu_resume().

To address this, save and restore TCR2_EL1 in the cpu_suspend()/cpu_resume()
path, rather than adding related logic to __cpu_setup(), taking into account
possible future extensions of the TCR2_ELx feature.

Fixes: bf83dae90fbc ("arm64: enable the Permission Overlay Extension for EL0")
Cc: <stable@vger.kernel.org> # 6.12.x
Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Reviewed-by: Kevin Brodsky <kevin.brodsky@arm.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Stable-dep-of: beeec0404622 ("arm64: suspend: Save and restore TPIDR2_EL0 across CPU suspend")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/include/asm/suspend.h | 2 +-
 arch/arm64/mm/proc.S             | 8 ++++++++
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/suspend.h b/arch/arm64/include/asm/suspend.h
index 0cde2f473971e..eb60c97355530 100644
--- a/arch/arm64/include/asm/suspend.h
+++ b/arch/arm64/include/asm/suspend.h
@@ -2,7 +2,7 @@
 #ifndef __ASM_SUSPEND_H
 #define __ASM_SUSPEND_H
 
-#define NR_CTX_REGS 13
+#define NR_CTX_REGS 14
 #define NR_CALLEE_SAVED_REGS 12
 
 /*
diff --git a/arch/arm64/mm/proc.S b/arch/arm64/mm/proc.S
index 14fdf645edc88..51c48ac29ad5d 100644
--- a/arch/arm64/mm/proc.S
+++ b/arch/arm64/mm/proc.S
@@ -102,6 +102,10 @@ SYM_FUNC_START(cpu_do_suspend)
 	 * call stack.
 	 */
 	str	x18, [x0, #96]
+alternative_if ARM64_HAS_TCR2
+	mrs	x2, REG_TCR2_EL1
+	str	x2, [x0, #104]
+alternative_else_nop_endif
 	ret
 SYM_FUNC_END(cpu_do_suspend)
 
@@ -144,6 +148,10 @@ SYM_FUNC_START(cpu_do_resume)
 	 */
 	disable_daif
 	msr	mdscr_el1, x10
+alternative_if ARM64_HAS_TCR2
+	ldr	x2, [x0, #104]
+	msr	REG_TCR2_EL1, x2
+alternative_else_nop_endif
 
 	msr	sctlr_el1, x12
 	set_this_cpu_offset x13
-- 
2.53.0



