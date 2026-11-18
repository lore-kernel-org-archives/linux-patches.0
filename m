Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795014395;
	b=3QFHFcw9H/L/JVqPho3G3y5p/xkPMkv1FO0K/4e9LVAGXH7cC2/QUx3ovRPK7upQ4Z7g
	 K94e3e1eMkZ/bEwV98x9tpnkQcgyAvCMfFNI0zF8BDcbHBiOO5niRioaG/zEJHo44dGim
	 AUz203GZJngP98gpCyCcNAGveolUz/0EcpgzxkOb7b/fiqc7bZajnbZHPNygFAYVoOnZz
	 k4jUsfT7326aicogAt21hcmr0v3EVqnoy+IDW8lh6RgwJVQTCy+LtdPQHDDJuzKjzRD17
	 InBw8YsrVlbtJREllZ86QG3HMa6uLGjlVL+Ka8veD+rBdq2WGP9kd+tNQFS4QuostSA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795014395;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=itvMFU6nWBEWJLXBDMfT4Lx1k+PgK9eqt2edNFvb6iA=;
	b=GEGmedA7MiNXL5r5YK46BYZiqZ9lnmFs0RZK7zOFcj862CFEBIt3JHx2oR9U3RdaxF8P
	 bmAMKYxXQ1eGVYW6dDzzdkgrsEsEArt9gJev03kWo7h8HOBCCv25JSM4gF1HFqVl1loli
	 BBRTheJCiw1mdE4aWEDE2fsEP1tekVdjYnDbJq0wYc+p7NZF4e6AIYvxc+1tSQhcaFRsY
	 T/0SadmcxVCFudAfckiASgi89OT22KydZuuBuNklchan8NBndOves4fQLYMcqTziNm3oF
	 LRz8fn2/XJnZli93L8Dwk67Wf/wGDAHl7/+zgUiygtzHwWl+9KNKAyhGOi9t7QfRqqQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HmraQneK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48DCA606A31C;
	Wed, 18 Nov 2026 15:06:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HmraQneK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B2EF1F000C5;
	Wed, 18 Nov 2026 15:06:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795014395;
	bh=itvMFU6nWBEWJLXBDMfT4Lx1k+PgK9eqt2edNFvb6iA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HmraQneKlnUNNN3yPkDkzH65vNxq5MOhv1xqezWrNaostYBYIvvU5S/EWjLid1sUh
	 iGEhyGFzN2N031jFNwBSCnc3TVDI3Jw28Max3mK494e4kJ/0y2O6dEdptJvxykMcv1
	 6wHnAxIjZCpgpeWlV648N5fBkB3rz0lzoA7oeKzc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Borislav Petkov (AMD)" <bp@alien8.de>
Subject: [PATCH 6.6 0001/3318] x86/bugs: Mitigate TSA on AMD Zen5
Date: Wed, 18 Nov 2026 15:10:23 +0100
Message-ID: <20261118150313.635843521@linuxfoundation.org>
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

From: "Borislav Petkov (AMD)" <bp@alien8.de>

Commit cf27412f19c9cc5909b9107cd1b3f4ab7608e362 upstream.

Zen5 is affected by TSA too, along with a third variant called TSA_FILL.
Detect the vuln there and mitigate it. For Zen5, a table of microcode
revisions is not needed because appropriate microcode sets the VERW_CLEAR
CPUID bit, which simplifies mitigation detection considerably.

Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/cpufeatures.h |    2 ++
 arch/x86/kernel/cpu/amd.c          |    9 +++++++--
 arch/x86/kernel/cpu/common.c       |    4 +++-
 arch/x86/kernel/cpu/scattered.c    |    1 +
 arch/x86/kvm/cpuid.c               |    3 ++-
 arch/x86/kvm/reverse_cpuid.h       |    2 ++
 6 files changed, 17 insertions(+), 4 deletions(-)

--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -475,6 +475,8 @@
 #define X86_FEATURE_CLEAR_CPU_BUF_VM   (21*32+13) /* "" Clear CPU buffers using VERW before VMRUN */
 #define X86_FEATURE_IBPB_EXIT_TO_USER  (21*32+14) /* Use IBPB on exit-to-userspace, see VMSCAPE bug */
 
+#define X86_FEATURE_TSA_FILL_NO		(21*32+17) /* AMD CPU not vulnerable to TSA-FILL */
+
 /*
  * BUG word(s)
  */
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -594,9 +594,14 @@ static void tsa_init(struct cpuinfo_x86
 		if (amd_check_tsa_microcode())
 			setup_force_cpu_cap(X86_FEATURE_VERW_CLEAR);
 	} else {
-		setup_force_cpu_cap(X86_FEATURE_TSA_SQ_NO);
-		setup_force_cpu_cap(X86_FEATURE_TSA_L1_NO);
+		if (!cpu_has(c, X86_FEATURE_ZEN5)) {
+			setup_force_cpu_cap(X86_FEATURE_TSA_SQ_NO);
+			setup_force_cpu_cap(X86_FEATURE_TSA_L1_NO);
+		}
 	}
+
+	if (!cpu_has(c, X86_FEATURE_ZEN5))
+		setup_force_cpu_cap(X86_FEATURE_TSA_FILL_NO);
 }
 
 static void bsp_init_amd(struct cpuinfo_x86 *c)
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1341,6 +1341,7 @@ static const struct x86_cpu_id cpu_vuln_
 	VULNBL_AMD(0x17, RETBLEED | SMT_RSB | SRSO | VMSCAPE),
 	VULNBL_HYGON(0x18, RETBLEED | SMT_RSB | SRSO | VMSCAPE),
 	VULNBL_AMD(0x19, SRSO | TSA | VMSCAPE),
+	VULNBL_AMD(0x1a, SRSO | TSA | VMSCAPE),
 	{}
 };
 
@@ -1547,7 +1548,8 @@ static void __init cpu_set_bug_bits(stru
 
 	if (c->x86_vendor == X86_VENDOR_AMD) {
 		if (!cpu_has(c, X86_FEATURE_TSA_SQ_NO) ||
-		    !cpu_has(c, X86_FEATURE_TSA_L1_NO)) {
+		    !cpu_has(c, X86_FEATURE_TSA_L1_NO) ||
+		    !cpu_has(c, X86_FEATURE_TSA_FILL_NO)) {
 			if (cpu_matches(cpu_vuln_blacklist, TSA) ||
 			    /* Enable bug on Zen guests to allow for live migration. */
 			    (cpu_has(c, X86_FEATURE_HYPERVISOR) && cpu_has(c, X86_FEATURE_ZEN)))
--- a/arch/x86/kernel/cpu/scattered.c
+++ b/arch/x86/kernel/cpu/scattered.c
@@ -51,6 +51,7 @@ static const struct cpuid_bit cpuid_bits
 	{ X86_FEATURE_BMEC,		CPUID_EBX,  3, 0x80000020, 0 },
 	{ X86_FEATURE_TSA_SQ_NO,	CPUID_ECX,  1, 0x80000021, 0 },
 	{ X86_FEATURE_TSA_L1_NO,	CPUID_ECX,  2, 0x80000021, 0 },
+	{ X86_FEATURE_TSA_FILL_NO,	CPUID_ECX,  7, 0x80000021, 0 },
 	{ X86_FEATURE_PERFMON_V2,	CPUID_EAX,  0, 0x80000022, 0 },
 	{ X86_FEATURE_AMD_LBR_V2,	CPUID_EAX,  1, 0x80000022, 0 },
 	{ X86_FEATURE_AMD_LBR_PMC_FREEZE,	CPUID_EAX,  2, 0x80000022, 0 },
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -794,11 +794,12 @@ void kvm_set_cpu_caps(void)
 	kvm_cpu_cap_check_and_set(X86_FEATURE_VERW_CLEAR);
 
 	kvm_cpu_cap_init_kvm_defined(CPUID_8000_0021_ECX,
-		F(TSA_SQ_NO) | F(TSA_L1_NO)
+		F(TSA_SQ_NO) | F(TSA_L1_NO) | F(TSA_FILL_NO)
 	);
 
 	kvm_cpu_cap_check_and_set(X86_FEATURE_TSA_SQ_NO);
 	kvm_cpu_cap_check_and_set(X86_FEATURE_TSA_L1_NO);
+	kvm_cpu_cap_check_and_set(X86_FEATURE_TSA_FILL_NO);
 
 	/*
 	 * Synthesize "LFENCE is serializing" into the AMD-defined entry in
--- a/arch/x86/kvm/reverse_cpuid.h
+++ b/arch/x86/kvm/reverse_cpuid.h
@@ -65,6 +65,7 @@ enum kvm_only_cpuid_leafs {
 /* CPUID level 0x80000021 (ECX) */
 #define KVM_X86_FEATURE_TSA_SQ_NO	KVM_X86_FEATURE(CPUID_8000_0021_ECX, 1)
 #define KVM_X86_FEATURE_TSA_L1_NO	KVM_X86_FEATURE(CPUID_8000_0021_ECX, 2)
+#define KVM_X86_FEATURE_TSA_FILL_NO	KVM_X86_FEATURE(CPUID_8000_0021_ECX, 7)
 
 struct cpuid_reg {
 	u32 function;
@@ -137,6 +138,7 @@ static __always_inline u32 __feature_tra
 	KVM_X86_TRANSLATE_FEATURE(BHI_CTRL);
 	KVM_X86_TRANSLATE_FEATURE(TSA_SQ_NO);
 	KVM_X86_TRANSLATE_FEATURE(TSA_L1_NO);
+	KVM_X86_TRANSLATE_FEATURE(TSA_FILL_NO);
 	default:
 		return x86_feature;
 	}


