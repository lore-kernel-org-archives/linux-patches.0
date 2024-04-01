Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26D4548781;
	Mon,  1 Apr 2024 17:07:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711991246; cv=none; b=SJkEcV3/Dov2jXQpf9S0oCc9pZ+7d6uv78owtZCOujJEeLur3ahT3Bc+CTawGPo9DCz59SkOlylsQNQwf/Di0FoOTbc98as5llcFEG5+iA3AP5PXOfVREmhuCjndigLIeDjuBhuZKo8zFEYKHsKH3Jpob6QtDmiFPReTvvC3LXs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711991246; c=relaxed/simple;
	bh=GbGLm8dW6yv6ds6qXUbFGEn6J8RVW6dSnouyC+QDpRw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j5DKFr9TmjfhsAdDYTXiT3AdauDAVvkdUJ4hYY3DI7D8SBusJPhy5Fn3/EyLeutKIrhtS7XyDRxABXMtGo6UMV4q1qm6/sH8cWzB3VI0W4pKelpkix3/8Aj/WFOomCfxkqjB/SYrsu02uCWa3AOjM5kcwHd9H0VgFHvLOnyekg8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qIqrsPDB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qIqrsPDB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4498DC433F1;
	Mon,  1 Apr 2024 17:07:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711991244;
	bh=GbGLm8dW6yv6ds6qXUbFGEn6J8RVW6dSnouyC+QDpRw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qIqrsPDBFUZ1Ol9kUhuL74xYJ5Ez7C+DY3mNM1Hee0ksyhYvJNRkekYG9F3pHsLfn
	 48kyZxmCytCe//T/uhoaB1ps5f0xOKS5LU9yBX0AUxYG54+fyrQUSGiTfbJtbWzxT0
	 0nILOyjSEAwaj56lx878SCUrFhy3z09nxVb659Uo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH 6.1 206/272] x86/coco: Get rid of accessor functions
Date: Mon,  1 Apr 2024 17:46:36 +0200
Message-ID: <20240401152537.337960612@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152530.237785232@linuxfoundation.org>
References: <20240401152530.237785232@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Borislav Petkov (AMD) <bp@alien8.de>

commit da86eb9611840772a459693832e54c63cbcc040a upstream.

cc_vendor is __ro_after_init and thus can be used directly.

No functional changes.

Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Link: https://lore.kernel.org/r/20230508121957.32341-1-bp@alien8.de
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/coco/core.c               |    2 +-
 arch/x86/coco/tdx/tdx.c            |    2 +-
 arch/x86/include/asm/coco.h        |   19 +------------------
 arch/x86/kernel/cpu/mshyperv.c     |    2 +-
 arch/x86/mm/mem_encrypt_identity.c |    2 +-
 5 files changed, 5 insertions(+), 22 deletions(-)

--- a/arch/x86/coco/core.c
+++ b/arch/x86/coco/core.c
@@ -13,7 +13,7 @@
 #include <asm/coco.h>
 #include <asm/processor.h>
 
-enum cc_vendor cc_vendor __ro_after_init;
+enum cc_vendor cc_vendor __ro_after_init = CC_VENDOR_NONE;
 static u64 cc_mask __ro_after_init;
 
 static bool intel_cc_platform_has(enum cc_attr attr)
--- a/arch/x86/coco/tdx/tdx.c
+++ b/arch/x86/coco/tdx/tdx.c
@@ -793,7 +793,7 @@ void __init tdx_early_init(void)
 
 	setup_force_cpu_cap(X86_FEATURE_TDX_GUEST);
 
-	cc_set_vendor(CC_VENDOR_INTEL);
+	cc_vendor = CC_VENDOR_INTEL;
 	tdx_parse_tdinfo(&cc_mask);
 	cc_set_mask(cc_mask);
 
--- a/arch/x86/include/asm/coco.h
+++ b/arch/x86/include/asm/coco.h
@@ -11,30 +11,13 @@ enum cc_vendor {
 	CC_VENDOR_INTEL,
 };
 
-#ifdef CONFIG_ARCH_HAS_CC_PLATFORM
 extern enum cc_vendor cc_vendor;
 
-static inline enum cc_vendor cc_get_vendor(void)
-{
-	return cc_vendor;
-}
-
-static inline void cc_set_vendor(enum cc_vendor vendor)
-{
-	cc_vendor = vendor;
-}
-
+#ifdef CONFIG_ARCH_HAS_CC_PLATFORM
 void cc_set_mask(u64 mask);
 u64 cc_mkenc(u64 val);
 u64 cc_mkdec(u64 val);
 #else
-static inline enum cc_vendor cc_get_vendor(void)
-{
-	return CC_VENDOR_NONE;
-}
-
-static inline void cc_set_vendor(enum cc_vendor vendor) { }
-
 static inline u64 cc_mkenc(u64 val)
 {
 	return val;
--- a/arch/x86/kernel/cpu/mshyperv.c
+++ b/arch/x86/kernel/cpu/mshyperv.c
@@ -344,7 +344,7 @@ static void __init ms_hyperv_init_platfo
 		/* Isolation VMs are unenlightened SEV-based VMs, thus this check: */
 		if (IS_ENABLED(CONFIG_AMD_MEM_ENCRYPT)) {
 			if (hv_get_isolation_type() != HV_ISOLATION_TYPE_NONE)
-				cc_set_vendor(CC_VENDOR_HYPERV);
+				cc_vendor = CC_VENDOR_HYPERV;
 		}
 	}
 
--- a/arch/x86/mm/mem_encrypt_identity.c
+++ b/arch/x86/mm/mem_encrypt_identity.c
@@ -608,7 +608,7 @@ void __init sme_enable(struct boot_param
 out:
 	if (sme_me_mask) {
 		physical_mask &= ~sme_me_mask;
-		cc_set_vendor(CC_VENDOR_AMD);
+		cc_vendor = CC_VENDOR_AMD;
 		cc_set_mask(sme_me_mask);
 	}
 }


