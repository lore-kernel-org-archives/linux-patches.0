Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831706;
	b=K4nLegZIxyslhLiVRucum6+/wv+mTioLlvDPaDnL2w+wJCsq+wwEUTMsHrs9mVlo+0bz
	 lIIm/yM1eISymDUf0+99iCC2S4FBgH+1QfUPb3McPKChav+k46zyulmz2fCpxB+Sm6RKU
	 PcIQOU/QZmQsu8ZVOyxezIEHfLY/U0YeEKZaInDlP0ridXDpGSkNqK71wa/YzEilASmFL
	 SitSdFoltEm9bCf0W1Ppc7mUtBisjBykzoST6Fuf5m7o15CuL4DkOoZwtn3nMuLYuLCuF
	 S4bWGabjGrtEAUqcWCk1EzLzBiZ7xJHnzpECHy2YDbZnaYIzDQ3CD81vBTyqNTmcaMA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831706;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8uCRAk/uX7Rhs5ToHGLQfnc/sOOkukOEJ6ZnlGiwi7s=;
	b=ipibbbNbIkY/s+bDWdktx5/aXKOnDqjgQQq7HSai1c9FeRZql0QoGOF7pLnbSb8f1ybn
	 Kcy6uUZJnZ91tZQW42vEQoIXYHYsBtdCk4dQFOAtJKluHXZDuSK8sPZGEGvcyxb74MdhK
	 UiSe9MDO+hqLPXYLnlEegguzQuL9iSK/avIKc9BeVpwJ5hD0soaEBj0LjDwsaB+bEwhdJ
	 W88RXzqvdps1iAlMW07L/sr1Id38Xt4B1c1U1sTCTmMytxrcg74nAuMBiuoMWNcRMY20G
	 mFAfUH68Yu4ab80H4j9/hp+uLLCbsHmBCZPpkMdA5YLNQLyzzA60gsIGDUBK65vd6Bg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dfdCB4wO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A8C2606AB14;
	Wed,  4 Nov 2026 22:35:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dfdCB4wO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B6831F000C1;
	Wed,  4 Nov 2026 22:35:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831705;
	bh=8uCRAk/uX7Rhs5ToHGLQfnc/sOOkukOEJ6ZnlGiwi7s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dfdCB4wOmFdbYUf+4O3mDWLLQr63kUqwcfR20YQikxmAMSnSt7N/fKMU1AVSUkPhI
	 ko80BII4WV0BuEu/N/nNU1iUWo88e/UFISGhKB/xRNyCb7qY+757A46RBN+BlSc6wZ
	 7JQakgJjxlILhumV/7zkPp3mjYBmi0W/Qwk26UbU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Borislav Petkov (AMD)" <bp@alien8.de>
Subject: [PATCH 6.18 0865/1005] x86/bugs: Adapt SRSO mitigation to Zen6
Date: Wed,  4 Nov 2026 16:09:58 -0500
Message-ID: <20261104211107.505106260@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

From: Borislav Petkov (AMD) <bp@alien8.de>

commit ae1d2082d93bc04604dc08e9b7f9cdba5e0c28e6 upstream.

Zen6 has BTB protection which isolates the different contexts
(user/kernel, guest/host) from one another. This makes the SafeRET
mitigation there unnecessary leaving the user/user and guest/guest
attack vectors open, whose protection is handled by the Spectre v2
mitigation setting to do IBPB on a context switch.

Detect that setting and report it with a new mitigation string.

Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Link: https://patch.msgid.link/20260822013231.1109255-1-bp@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/cpufeatures.h |    1 +
 arch/x86/kernel/cpu/bugs.c         |   18 ++++++++++++++++--
 arch/x86/kernel/cpu/scattered.c    |    1 +
 3 files changed, 18 insertions(+), 2 deletions(-)

--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -411,6 +411,7 @@
 #define X86_FEATURE_OVERFLOW_RECOV	(17*32+ 0) /* "overflow_recov" MCA overflow recovery support */
 #define X86_FEATURE_SUCCOR		(17*32+ 1) /* "succor" Uncorrectable error containment and recovery */
 #define X86_FEATURE_SMCA		(17*32+ 3) /* "smca" Scalable MCA */
+#define X86_FEATURE_BTB_CTX_ISOLATION	(17*32+ 4) /* AMD: Branch predictions contexts isolated */
 
 /* Intel-defined CPU features, CPUID level 0x00000007:0 (EDX), word 18 */
 #define X86_FEATURE_AVX512_4VNNIW	(18*32+ 2) /* "avx512_4vnniw" AVX-512 Neural Network Instructions */
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -1320,6 +1320,7 @@ enum srso_mitigation {
 	SRSO_MITIGATION_IBPB,
 	SRSO_MITIGATION_IBPB_ON_VMEXIT,
 	SRSO_MITIGATION_BP_SPEC_REDUCE,
+	SRSO_MITIGATION_USER_IBPB,
 };
 
 static enum srso_mitigation srso_mitigation __ro_after_init = SRSO_MITIGATION_AUTO;
@@ -3055,7 +3056,8 @@ static const char * const srso_strings[]
 	[SRSO_MITIGATION_SAFE_RET]		= "Mitigation: Safe RET",
 	[SRSO_MITIGATION_IBPB]			= "Mitigation: IBPB",
 	[SRSO_MITIGATION_IBPB_ON_VMEXIT]	= "Mitigation: IBPB on VMEXIT only",
-	[SRSO_MITIGATION_BP_SPEC_REDUCE]	= "Mitigation: Reduced Speculation"
+	[SRSO_MITIGATION_BP_SPEC_REDUCE]	= "Mitigation: Reduced Speculation",
+	[SRSO_MITIGATION_USER_IBPB]		= "Mitigation: IBPB on context switch",
 };
 
 static int __init srso_parse_cmdline(char *str)
@@ -3095,7 +3097,9 @@ static void __init srso_select_mitigatio
 		 * required.  Otherwise the 'microcode' mitigation is sufficient
 		 * to protect the user->user and guest->guest vectors.
 		 */
-		if (cpu_attack_vector_mitigated(CPU_MITIGATE_GUEST_HOST) ||
+		if ((cpu_attack_vector_mitigated(CPU_MITIGATE_GUEST_HOST) &&
+		    !boot_cpu_has(X86_FEATURE_BTB_CTX_ISOLATION))
+					||
 		    (cpu_attack_vector_mitigated(CPU_MITIGATE_USER_KERNEL) &&
 		     !boot_cpu_has(X86_FEATURE_SRSO_USER_KERNEL_NO))) {
 			srso_mitigation = SRSO_MITIGATION_SAFE_RET;
@@ -3171,6 +3175,16 @@ static void __init srso_update_mitigatio
 	    boot_cpu_has(X86_FEATURE_IBPB_BRTYPE))
 		srso_mitigation = SRSO_MITIGATION_IBPB;
 
+	/*
+	 * See if IBPB on context switch is the only thing needed to address
+	 * GUEST/GUEST and USER/USER vectors.
+	 */
+	if (srso_mitigation == SRSO_MITIGATION_MICROCODE  &&
+	    boot_cpu_has(X86_FEATURE_SRSO_USER_KERNEL_NO) &&
+	    boot_cpu_has(X86_FEATURE_BTB_CTX_ISOLATION) &&
+	    spectre_v2_user_ibpb != SPECTRE_V2_USER_NONE)
+		srso_mitigation = SRSO_MITIGATION_USER_IBPB;
+
 	pr_info("%s\n", srso_strings[srso_mitigation]);
 }
 
--- a/arch/x86/kernel/cpu/scattered.c
+++ b/arch/x86/kernel/cpu/scattered.c
@@ -56,6 +56,7 @@ static const struct cpuid_bit cpuid_bits
 	{ X86_FEATURE_TSA_SQ_NO,		CPUID_ECX,  1, 0x80000021, 0 },
 	{ X86_FEATURE_TSA_L1_NO,		CPUID_ECX,  2, 0x80000021, 0 },
 	{ X86_FEATURE_AMD_WORKLOAD_CLASS,	CPUID_EAX, 22, 0x80000021, 0 },
+	{ X86_FEATURE_BTB_CTX_ISOLATION,	CPUID_ECX,  8, 0x80000021, 0 },
 	{ X86_FEATURE_PERFMON_V2,		CPUID_EAX,  0, 0x80000022, 0 },
 	{ X86_FEATURE_AMD_LBR_V2,		CPUID_EAX,  1, 0x80000022, 0 },
 	{ X86_FEATURE_AMD_LBR_PMC_FREEZE,	CPUID_EAX,  2, 0x80000022, 0 },


