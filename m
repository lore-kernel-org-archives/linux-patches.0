Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022758;
	b=U5TBQiBYdrxwyK0cJ38kVE+uWax2qPxLlQ51TjI1ZSlmg+QcwCQkTIlM1XRMkpDuXTI/
	 KDid2Uz45XFBO+wjmPYJT7f/eFQSdTkpayG46SR91Pa90qMV+3EhgKxB8YUuwOuN1a4ss
	 s7D64b+f118rh5LxMYW5yFlSr7XahlshQ/q0Svb9v427RyVCwnzQXGwc+Z7JmQM56I2LD
	 kgjgFJhlWILc13C7jFCHx/e3LFYuKvmO7CXXmbhIErq1ewe+qIOoIBo/Lm9fM8ZTuETws
	 3iuYUEkk408IGj25nPrMpe8kgZY4qD+XKJrD5E4jMu7aAJ/gSuSv2CWmRNL/hr/Twzw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022758;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ggLKoM6DJlP6e/oYo05lN680DFNugnwPMCBfv0d4RmA=;
	b=D2pKbXOEQbv+y7r1ifxUHRcjN+XgRmjXAaA0k0mMddVbzxbpaVvZJmRW5gV3GZy5T75/
	 bD5CGrMSPLWG7CnzUC+oK5UrbF+U/N/UmCIzE2HTXz76IWjf91p0v1CqahE78tLrO2k1L
	 SGh7UdBedYIkdosAdU1wY65kHGfYHKsQ/Ro0eEf14Ir34eChsr1UKu2xZyVKlQRpOaPoz
	 NFiwK9NrsO4aOGBNw7Wf8QaYBUF2G3wagXEMnR7VnG+NUyP0b3EbnhMH9rUjuMPxrht/5
	 LR+iDfG/maQ80rhuGCszymP4USGD0Ld3YPtW/zS/kaAsYJff9DyVi48y5gAInkjBY9w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YGhcr+IZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60650606CA63;
	Wed, 18 Nov 2026 17:25:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YGhcr+IZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 654331F0092B;
	Wed, 18 Nov 2026 17:25:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022757;
	bh=ggLKoM6DJlP6e/oYo05lN680DFNugnwPMCBfv0d4RmA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YGhcr+IZni3EDekfJoRGu/DdJsx954OugjfyoMyQulq0rxLIS1FX664yVjvHlLeZ0
	 i0bRs3xhTCTNvTePrZBvJ7+/2p/yAOWj5CeeJIEgwX8ceGCQXE6MjbK5NzV7u+WfxT
	 szsrWPcZ8KYnBpGO21xKckiYDltbHACV25KutpH0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Breno Leitao <leitao@debian.org>
Subject: [PATCH 6.18 0126/2151] x86/cpufeatures: Make X86_FEATURE leaf 17 Linux-specific
Date: Wed, 18 Nov 2026 15:31:01 +0100
Message-ID: <20261118150126.379451060@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

commit ddde4abaa0ecc8395e0fcfa3e92f65d481890cc8 upstream.

That cpuinfo_x86.x86_capability[] element was supposed to mirror CPUID flags
from CPUID_0x80000007_EBX but that leaf has still to this day only three bits
defined in it. So move those bits to scattered.c and free the capability
element for synthetic flags.

No functional changes.

Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Signed-off-by: Breno Leitao <leitao@debian.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/cpufeature.h        |    2 +-
 arch/x86/include/asm/cpufeatures.h       |    5 ++++-
 arch/x86/kernel/cpu/common.c             |    8 ++------
 arch/x86/kernel/cpu/scattered.c          |    3 +++
 arch/x86/kvm/reverse_cpuid.h             |    1 -
 tools/arch/x86/include/asm/cpufeatures.h |    5 ++++-
 6 files changed, 14 insertions(+), 10 deletions(-)

--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -30,7 +30,7 @@ enum cpuid_leafs
 	CPUID_6_EAX,
 	CPUID_8000_000A_EDX,
 	CPUID_7_ECX,
-	CPUID_8000_0007_EBX,
+	CPUID_LNX_6,
 	CPUID_7_EDX,
 	CPUID_8000_001F_EAX,
 	CPUID_8000_0021_EAX,
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -407,9 +407,12 @@
 #define X86_FEATURE_ENQCMD		(16*32+29) /* "enqcmd" ENQCMD and ENQCMDS instructions */
 #define X86_FEATURE_SGX_LC		(16*32+30) /* "sgx_lc" Software Guard Extensions Launch Control */
 
-/* AMD-defined CPU features, CPUID level 0x80000007 (EBX), word 17 */
+/*
+ * Linux-defined word for use with scattered/synthetic bits.
+ */
 #define X86_FEATURE_OVERFLOW_RECOV	(17*32+ 0) /* "overflow_recov" MCA overflow recovery support */
 #define X86_FEATURE_SUCCOR		(17*32+ 1) /* "succor" Uncorrectable error containment and recovery */
+
 #define X86_FEATURE_SMCA		(17*32+ 3) /* "smca" Scalable MCA */
 #define X86_FEATURE_BTB_CTX_ISOLATION	(17*32+ 4) /* AMD: Branch predictions contexts isolated */
 
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1025,12 +1025,8 @@ void get_cpu_cap(struct cpuinfo_x86 *c)
 		c->x86_capability[CPUID_8000_0001_EDX] = edx;
 	}
 
-	if (c->extended_cpuid_level >= 0x80000007) {
-		cpuid(0x80000007, &eax, &ebx, &ecx, &edx);
-
-		c->x86_capability[CPUID_8000_0007_EBX] = ebx;
-		c->x86_power = edx;
-	}
+	if (c->extended_cpuid_level >= 0x80000007)
+		c->x86_power = cpuid_edx(0x80000007);
 
 	if (c->extended_cpuid_level >= 0x80000008) {
 		cpuid(0x80000008, &eax, &ebx, &ecx, &edx);
--- a/arch/x86/kernel/cpu/scattered.c
+++ b/arch/x86/kernel/cpu/scattered.c
@@ -44,6 +44,9 @@ static const struct cpuid_bit cpuid_bits
 	{ X86_FEATURE_SGX1,			CPUID_EAX,  0, 0x00000012, 0 },
 	{ X86_FEATURE_SGX2,			CPUID_EAX,  1, 0x00000012, 0 },
 	{ X86_FEATURE_SGX_EDECCSSA,		CPUID_EAX, 11, 0x00000012, 0 },
+	{ X86_FEATURE_OVERFLOW_RECOV,		CPUID_EBX,  0, 0x80000007, 0 },
+	{ X86_FEATURE_SUCCOR,			CPUID_EBX,  1, 0x80000007, 0 },
+	{ X86_FEATURE_SMCA,			CPUID_EBX,  3, 0x80000007, 0 },
 	{ X86_FEATURE_HW_PSTATE,		CPUID_EDX,  7, 0x80000007, 0 },
 	{ X86_FEATURE_CPB,			CPUID_EDX,  9, 0x80000007, 0 },
 	{ X86_FEATURE_PROC_FEEDBACK,		CPUID_EDX, 11, 0x80000007, 0 },
--- a/arch/x86/kvm/reverse_cpuid.h
+++ b/arch/x86/kvm/reverse_cpuid.h
@@ -79,7 +79,6 @@ static const struct cpuid_reg reverse_cp
 	[CPUID_6_EAX]         = {         6, 0, CPUID_EAX},
 	[CPUID_8000_000A_EDX] = {0x8000000a, 0, CPUID_EDX},
 	[CPUID_7_ECX]         = {         7, 0, CPUID_ECX},
-	[CPUID_8000_0007_EBX] = {0x80000007, 0, CPUID_EBX},
 	[CPUID_7_EDX]         = {         7, 0, CPUID_EDX},
 	[CPUID_7_1_EAX]       = {         7, 1, CPUID_EAX},
 	[CPUID_12_EAX]        = {0x00000012, 0, CPUID_EAX},
--- a/tools/arch/x86/include/asm/cpufeatures.h
+++ b/tools/arch/x86/include/asm/cpufeatures.h
@@ -407,9 +407,12 @@
 #define X86_FEATURE_ENQCMD		(16*32+29) /* "enqcmd" ENQCMD and ENQCMDS instructions */
 #define X86_FEATURE_SGX_LC		(16*32+30) /* "sgx_lc" Software Guard Extensions Launch Control */
 
-/* AMD-defined CPU features, CPUID level 0x80000007 (EBX), word 17 */
+/*
+ * Linux-defined word for use with scattered/synthetic bits.
+ */
 #define X86_FEATURE_OVERFLOW_RECOV	(17*32+ 0) /* "overflow_recov" MCA overflow recovery support */
 #define X86_FEATURE_SUCCOR		(17*32+ 1) /* "succor" Uncorrectable error containment and recovery */
+
 #define X86_FEATURE_SMCA		(17*32+ 3) /* "smca" Scalable MCA */
 
 /* Intel-defined CPU features, CPUID level 0x00000007:0 (EDX), word 18 */


