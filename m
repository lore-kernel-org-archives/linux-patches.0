Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16C237F7CC;
	Mon,  8 Apr 2024 13:14:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712582081; cv=none; b=aSMzKHNHFRTSfm025ZkD0VHdZ3Za14R9uVGuE1PUsMYPp4r3W7o3WJNWCM+orKkFA9Jw9Qsz8phz18LX4mCQCuu0+wYQDjSFAsP7IpYM02FynLayLzjhSAP/5WOaDCk65YzgKowj5x9LByUo787lkZa0TrLNYYfpWVUhoKLISx0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712582081; c=relaxed/simple;
	bh=/RSCyDEfje7c6CRzogOVYhY8YKs5tJIHhrM3nV5pyhw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oxFEJlskVQc7iQG7Y/zJ6s6P1851twcHRCOpTrF9n9mj++nXcoSteJCvhCKTDLlQJEAt7S1aGNKxwDxG5QKW/lnQdjssEGB9TF6n3Y9xQkXJLrmdG8epWlHVixbtWYo4aDYaHT5c7shAnz2HoMeWwV5qEjLS5BETO0XvCs2jUqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0mmV68E5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0mmV68E5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91D4DC43390;
	Mon,  8 Apr 2024 13:14:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712582081;
	bh=/RSCyDEfje7c6CRzogOVYhY8YKs5tJIHhrM3nV5pyhw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0mmV68E5spZmbNvJtnFS/8LJ+iI2vQolJpdS3TrTLfumSkTNHkVwNoaK98y/brh8x
	 KlNUjXGwqYBJ5u+3RxvWPuR5YZFvm+w5TR63Vf3UG26t3P3ALDnI1YsdezYUDgkUKv
	 H1tkokuaoZkd6bYQGoyYgGQsHvrYCgzrhdTGj8QE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brian Gerst <brgerst@gmail.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 062/252] x86/CPU/AMD: Add X86_FEATURE_ZEN1
Date: Mon,  8 Apr 2024 14:56:01 +0200
Message-ID: <20240408125308.564384573@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125306.643546457@linuxfoundation.org>
References: <20240408125306.643546457@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Borislav Petkov (AMD) <bp@alien8.de>

[ Upstream commit 232afb557835d6f6859c73bf610bad308c96b131 ]

Add a synthetic feature flag specifically for first generation Zen
machines. There's need to have a generic flag for all Zen generations so
make X86_FEATURE_ZEN be that flag.

Fixes: 30fa92832f40 ("x86/CPU/AMD: Add ZenX generations flags")
Suggested-by: Brian Gerst <brgerst@gmail.com>
Suggested-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Link: https://lore.kernel.org/r/dc3835e3-0731-4230-bbb9-336bbe3d042b@amd.com
Stable-dep-of: c7b2edd8377b ("perf/x86/amd/core: Update and fix stalled-cycles-* events for Zen 2 and later")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/include/asm/cpufeatures.h       |  3 ++-
 arch/x86/kernel/cpu/amd.c                | 11 ++++++-----
 tools/arch/x86/include/asm/cpufeatures.h |  2 +-
 3 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index 1f9db287165ac..bc66aec9139ea 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -218,7 +218,7 @@
 #define X86_FEATURE_IBRS		( 7*32+25) /* Indirect Branch Restricted Speculation */
 #define X86_FEATURE_IBPB		( 7*32+26) /* Indirect Branch Prediction Barrier */
 #define X86_FEATURE_STIBP		( 7*32+27) /* Single Thread Indirect Branch Predictors */
-#define X86_FEATURE_ZEN			( 7*32+28) /* "" CPU based on Zen microarchitecture */
+#define X86_FEATURE_ZEN			( 7*32+28) /* "" Generic flag for all Zen and newer */
 #define X86_FEATURE_L1TF_PTEINV		( 7*32+29) /* "" L1TF workaround PTE inversion */
 #define X86_FEATURE_IBRS_ENHANCED	( 7*32+30) /* Enhanced IBRS */
 #define X86_FEATURE_MSR_IA32_FEAT_CTL	( 7*32+31) /* "" MSR IA32_FEAT_CTL configured */
@@ -315,6 +315,7 @@
 #define X86_FEATURE_ZEN2		(11*32+28) /* "" CPU based on Zen2 microarchitecture */
 #define X86_FEATURE_ZEN3		(11*32+29) /* "" CPU based on Zen3 microarchitecture */
 #define X86_FEATURE_ZEN4		(11*32+30) /* "" CPU based on Zen4 microarchitecture */
+#define X86_FEATURE_ZEN1		(11*32+31) /* "" CPU based on Zen1 microarchitecture */
 
 /* Intel-defined CPU features, CPUID level 0x00000007:1 (EAX), word 12 */
 #define X86_FEATURE_AVX_VNNI		(12*32+ 4) /* AVX VNNI instructions */
diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index 98fa23ef97df2..9fd91022d92d0 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -613,7 +613,7 @@ static void bsp_init_amd(struct cpuinfo_x86 *c)
 		switch (c->x86_model) {
 		case 0x00 ... 0x2f:
 		case 0x50 ... 0x5f:
-			setup_force_cpu_cap(X86_FEATURE_ZEN);
+			setup_force_cpu_cap(X86_FEATURE_ZEN1);
 			break;
 		case 0x30 ... 0x4f:
 		case 0x60 ... 0x7f:
@@ -1011,12 +1011,13 @@ void init_spectral_chicken(struct cpuinfo_x86 *c)
 
 static void init_amd_zn(struct cpuinfo_x86 *c)
 {
+	setup_force_cpu_cap(X86_FEATURE_ZEN);
 #ifdef CONFIG_NUMA
 	node_reclaim_distance = 32;
 #endif
 }
 
-static void init_amd_zen(struct cpuinfo_x86 *c)
+static void init_amd_zen1(struct cpuinfo_x86 *c)
 {
 	fix_erratum_1386(c);
 
@@ -1130,8 +1131,8 @@ static void init_amd(struct cpuinfo_x86 *c)
 	case 0x19: init_amd_zn(c); break;
 	}
 
-	if (boot_cpu_has(X86_FEATURE_ZEN))
-		init_amd_zen(c);
+	if (boot_cpu_has(X86_FEATURE_ZEN1))
+		init_amd_zen1(c);
 	else if (boot_cpu_has(X86_FEATURE_ZEN2))
 		init_amd_zen2(c);
 	else if (boot_cpu_has(X86_FEATURE_ZEN3))
@@ -1190,7 +1191,7 @@ static void init_amd(struct cpuinfo_x86 *c)
 	 * Counter May Be Inaccurate".
 	 */
 	if (cpu_has(c, X86_FEATURE_IRPERF) &&
-	    (boot_cpu_has(X86_FEATURE_ZEN) && c->x86_model > 0x2f))
+	    (boot_cpu_has(X86_FEATURE_ZEN1) && c->x86_model > 0x2f))
 		msr_set_bit(MSR_K7_HWCR, MSR_K7_HWCR_IRPERF_EN_BIT);
 
 	check_null_seg_clears_base(c);
diff --git a/tools/arch/x86/include/asm/cpufeatures.h b/tools/arch/x86/include/asm/cpufeatures.h
index 798e60b5454b7..845a4023ba44e 100644
--- a/tools/arch/x86/include/asm/cpufeatures.h
+++ b/tools/arch/x86/include/asm/cpufeatures.h
@@ -219,7 +219,7 @@
 #define X86_FEATURE_IBRS		( 7*32+25) /* Indirect Branch Restricted Speculation */
 #define X86_FEATURE_IBPB		( 7*32+26) /* Indirect Branch Prediction Barrier */
 #define X86_FEATURE_STIBP		( 7*32+27) /* Single Thread Indirect Branch Predictors */
-#define X86_FEATURE_ZEN			(7*32+28) /* "" CPU based on Zen microarchitecture */
+#define X86_FEATURE_ZEN			( 7*32+28) /* "" Generic flag for all Zen and newer */
 #define X86_FEATURE_L1TF_PTEINV		( 7*32+29) /* "" L1TF workaround PTE inversion */
 #define X86_FEATURE_IBRS_ENHANCED	( 7*32+30) /* Enhanced IBRS */
 #define X86_FEATURE_MSR_IA32_FEAT_CTL	( 7*32+31) /* "" MSR IA32_FEAT_CTL configured */
-- 
2.43.0



