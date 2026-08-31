Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 367584B7144;
	Mon, 31 Aug 2026 13:58:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184681; cv=none; b=A8YkP7ladjnf/5AshYX1GtTATafBiZCnBp6CrjdaWClrEkIoH8SVrA4Z/BrItvXgqUS9FPSr6KTVGDwvf3ok/t2rVbZ7cTeshpC/aWU6ZHbCMioJm6LL/TvpBJLekf80HwQagwMgayySpBum5kmvSOz8kxU/a53ch9O42TjKbu0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184681; c=relaxed/simple;
	bh=YS5lkk5R9cxDu9GpGRfRMCa6A+8jx3YYzj2mMQ28d1w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bLBr0FxfzJdPtQ1aQvuVky7YXmbQdIimny6KOA/8JN5T+axobnLjKfE2oSRqWKetQkcewp06CWc/s1sMNoY7pkYhaYI3Py0frQ/BJa6N7p5z6rL98oP8MEsU9FXNV0a5Mfy2fYN9VeiUoPaA5qIg/AstyuNKdIuVievRP0VBfjk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hAMQvQ7o; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hAMQvQ7o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B80F51F00A3D;
	Mon, 31 Aug 2026 13:57:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788184680;
	bh=Bl3dLR7mJY2tvrPQ2Nip8071HiYs/BpysAkC8+JPM7s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hAMQvQ7oCA+xm3Rt5Jv73+OYzH267wxEOTXdLz2PbadTDMPhOefoUsFaBNEKkj2gW
	 077MWdRutLUD7z4+xVDSCvLr/QwvRn1+6tBoIPAL2CNpj6nfjPodrEU0DMhfto//cW
	 mYWHiDdbCGxok6GJTLcvGYLGpBmSSp8S+BrfL/9I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Borislav Petkov (AMD)" <bp@alien8.de>
Subject: [PATCH 6.6 67/91] x86/CPU/AMD: Add X86_FEATURE_ZEN5
Date: Mon, 31 Aug 2026 15:34:55 +0200
Message-ID: <20260831133403.165450313@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133359.468089036@linuxfoundation.org>
References: <20260831133359.468089036@linuxfoundation.org>
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

commit 3e4147f33f8b647775357bae0248b9a2aeebfcd2 upstream.

Add a synthetic feature flag for Zen5.

Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Link: https://lore.kernel.org/r/20240104201138.5072-1-bp@alien8.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/cpufeatures.h |    4 +---
 arch/x86/kernel/cpu/amd.c          |   25 +++++++++++++++++++++----
 2 files changed, 22 insertions(+), 7 deletions(-)

--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -81,10 +81,8 @@
 #define X86_FEATURE_K6_MTRR		( 3*32+ 1) /* AMD K6 nonstandard MTRRs */
 #define X86_FEATURE_CYRIX_ARR		( 3*32+ 2) /* Cyrix ARRs (= MTRRs) */
 #define X86_FEATURE_CENTAUR_MCR		( 3*32+ 3) /* Centaur MCRs (= MTRRs) */
-
-/* CPU types for specific tunings: */
 #define X86_FEATURE_K8			( 3*32+ 4) /* "" Opteron, Athlon64 */
-/* FREE, was #define X86_FEATURE_K7			( 3*32+ 5) "" Athlon */
+#define X86_FEATURE_ZEN5		( 3*32+ 5) /* "" CPU based on Zen5 microarchitecture */
 #define X86_FEATURE_P3			( 3*32+ 6) /* "" P3 */
 #define X86_FEATURE_P4			( 3*32+ 7) /* "" P4 */
 #define X86_FEATURE_CONSTANT_TSC	( 3*32+ 8) /* TSC ticks at a constant rate */
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -669,7 +669,7 @@ static void bsp_init_amd(struct cpuinfo_
 
 	/* Figure out Zen generations: */
 	switch (c->x86) {
-	case 0x17: {
+	case 0x17:
 		switch (c->x86_model) {
 		case 0x00 ... 0x2f:
 		case 0x50 ... 0x5f:
@@ -685,8 +685,8 @@ static void bsp_init_amd(struct cpuinfo_
 			goto warn;
 		}
 		break;
-	}
-	case 0x19: {
+
+	case 0x19:
 		switch (c->x86_model) {
 		case 0x00 ... 0x0f:
 		case 0x20 ... 0x5f:
@@ -700,7 +700,17 @@ static void bsp_init_amd(struct cpuinfo_
 			goto warn;
 		}
 		break;
-	}
+
+	case 0x1a:
+		switch (c->x86_model) {
+		case 0x00 ... 0x0f:
+			setup_force_cpu_cap(X86_FEATURE_ZEN5);
+			break;
+		default:
+			goto warn;
+		}
+		break;
+
 	default:
 		break;
 	}
@@ -1185,6 +1195,11 @@ static void init_amd_zen4(struct cpuinfo
 	init_amd_zen_common();
 }
 
+static void init_amd_zen5(struct cpuinfo_x86 *c)
+{
+	init_amd_zen_common();
+}
+
 static void init_amd(struct cpuinfo_x86 *c)
 {
 	early_init_amd(c);
@@ -1228,6 +1243,8 @@ static void init_amd(struct cpuinfo_x86
 		init_amd_zen3(c);
 	else if (boot_cpu_has(X86_FEATURE_ZEN4))
 		init_amd_zen4(c);
+	else if (boot_cpu_has(X86_FEATURE_ZEN5))
+		init_amd_zen5(c);
 
 	/*
 	 * Enable workaround for FXSAVE leak on CPUs


