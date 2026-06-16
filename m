Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 809DC4657D0;
	Tue, 16 Jun 2026 17:18:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781630314; cv=none; b=fgiZw6c9as68G0PxmhRxr1GjvoQNqxn66qLPbFwviYJIqVq5G1ifKt9OBn/LccRUMP8eoLwaccVU/PTU620U0vaz7ysi/kJqFflc8iAfKVYotwvMXbPGqTPOzB1+JSXHv6vrSH4YM/pxL6GVXXEMKnHrKW1MZUZebjVCRJ34rnU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781630314; c=relaxed/simple;
	bh=ixLNc2U9WfxLqZX7YJnKze21Ly+o77Zz/MuHHIUDAqg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tahB9u3R9AhJ+OEzHwKsNFaslYhF8lNeqfbZ7hjop5/LpsBZaH+zczQe+pmex3dsJMB5z4xvaVRVK3yt6g9PKxcOEoYK0g1rrydcSrbrnGLKfW/Rqzks20Ie36D64Vm2/O/sA+X1E1RCv08+vKGQIhHJQmKMURISr2+EcfEnu9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PHODQUM6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PHODQUM6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DD151F000E9;
	Tue, 16 Jun 2026 17:18:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781630313;
	bh=o1zoFjfXu+lJDPJLq//GyY3enKm+xU2QL9gj3HoZ5xQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PHODQUM65ZZIc4zG+YHQWEQPqXLrZm87WUUZ5h9UolvU/jjIaz4CXbkdNqi6t560v
	 NDEj1ITJRphj2gDBK40/hqLU3LHNPt8/+rflogs05Tp7oJ09jUDfk4e4CgtpowFAf8
	 tJAQiE0Vx1TnvXnZU//GGoqlJEnJeOdwOJR2wJ18=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Nikolay Borisov <nik.borisov@suse.com>
Subject: [PATCH 6.6 452/452] x86/CPU/AMD: Rename init_amd_zn() to init_amd_zen_common()
Date: Tue, 16 Jun 2026 20:31:19 +0530
Message-ID: <20260616145140.220414169@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145117.796205997@linuxfoundation.org>
References: <20260616145117.796205997@linuxfoundation.org>
User-Agent: quilt/0.69
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

commit 7c81ad8e8bc28a1847e87c5afe1bae6bffb2f73e upstream.

Call it from all Zen init functions.

Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Reviewed-by: Nikolay Borisov <nik.borisov@suse.com>
Link: http://lore.kernel.org/r/20231120104152.13740-7-bp@alien8.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/amd.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -1070,7 +1070,7 @@ void init_spectral_chicken(struct cpuinf
 #endif
 }
 
-static void init_amd_zn(struct cpuinfo_x86 *c)
+static void init_amd_zen_common(void)
 {
 	setup_force_cpu_cap(X86_FEATURE_ZEN);
 #ifdef CONFIG_NUMA
@@ -1080,6 +1080,7 @@ static void init_amd_zn(struct cpuinfo_x
 
 static void init_amd_zen1(struct cpuinfo_x86 *c)
 {
+	init_amd_zen_common();
 	fix_erratum_1386(c);
 
 	/* Fix up CPUID bits, but only if not virtualised. */
@@ -1143,10 +1144,12 @@ static void zen2_zenbleed_check(struct c
 	} else {
 		msr_clear_bit(MSR_AMD64_DE_CFG, MSR_AMD64_DE_CFG_ZEN2_FP_BACKUP_FIX_BIT);
 	}
+
 }
 
 static void init_amd_zen2(struct cpuinfo_x86 *c)
 {
+	init_amd_zen_common();
 	init_spectral_chicken(c);
 	fix_erratum_1386(c);
 	zen2_zenbleed_check(c);
@@ -1164,6 +1167,8 @@ static void init_amd_zen2(struct cpuinfo
 
 static void init_amd_zen3(struct cpuinfo_x86 *c)
 {
+	init_amd_zen_common();
+
 	if (!cpu_has(c, X86_FEATURE_HYPERVISOR)) {
 		/*
 		 * Zen3 (Fam19 model < 0x10) parts are not susceptible to
@@ -1177,6 +1182,7 @@ static void init_amd_zen3(struct cpuinfo
 
 static void init_amd_zen4(struct cpuinfo_x86 *c)
 {
+	init_amd_zen_common();
 }
 
 static void init_amd(struct cpuinfo_x86 *c)
@@ -1212,9 +1218,6 @@ static void init_amd(struct cpuinfo_x86
 	case 0x12: init_amd_ln(c); break;
 	case 0x15: init_amd_bd(c); break;
 	case 0x16: init_amd_jg(c); break;
-	case 0x17:
-		   fallthrough;
-	case 0x19: init_amd_zn(c); break;
 	}
 
 	if (boot_cpu_has(X86_FEATURE_ZEN1))


