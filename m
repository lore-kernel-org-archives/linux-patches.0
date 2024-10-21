Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AA621E573A;
	Mon, 21 Oct 2024 10:49:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729507781; cv=none; b=dxQzzvertJA/J7np4XVs8s9hUTx5m7yz1jegbhm/YD7gb21eB3AyzOGhcSKTv/uIwoHQeQYlOcj0iL3ajrCKygXKK2nGhhoi+eQ10S6ReNMlga9QitQ5eFZbRKsMPtlpjdkBwq0C55BGNH+/ZIslGh1QRWkrNKd84xu1tnFhGV4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729507781; c=relaxed/simple;
	bh=ce1RPFsfsMgcPkjnqpoI0i2w/a78nekwmeYB1QxUy4Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dZTfITSC1/ZSSLzfPZ9begQZQmp9hJcy326p8+fvl4AWfBULR9cO8aYlOgHbxIZ2wKSXkuOEdpgxrohA7eiGEHjgd8RSD9aSm0vpoHZdcyUU21qpO7LOkFETImOXcqmBXR5pOAiBqdCP7YZYGHSDr4kG2zkXcaT09zYGV55k+8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TghOY+hM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TghOY+hM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B007C4CEC3;
	Mon, 21 Oct 2024 10:49:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729507780;
	bh=ce1RPFsfsMgcPkjnqpoI0i2w/a78nekwmeYB1QxUy4Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TghOY+hMHEDQ+GJ7WdB6Abna3DGmIExD6/rXOBhvPX++75H1zKC7L6wJWCE9UpLYW
	 i+xAQp+JFgzDZFS7NL+owYibR5+mNIFFRMOmpPdSPUmeu7StGfFwM+ferGfVYwaZhc
	 E+juDsAaNdwRSyTSGgB5APLqqkjczPzA50FfF6Fo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Venkatesh Srinivas <venkateshs@chromium.org>,
	Jim Mattson <jmattson@google.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	stable@kernel.org
Subject: [PATCH 5.10 17/52] x86/cpufeatures: Define X86_FEATURE_AMD_IBPB_RET
Date: Mon, 21 Oct 2024 12:25:38 +0200
Message-ID: <20241021102242.300792216@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241021102241.624153108@linuxfoundation.org>
References: <20241021102241.624153108@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jim Mattson <jmattson@google.com>

commit ff898623af2ed564300752bba83a680a1e4fec8d upstream.

AMD's initial implementation of IBPB did not clear the return address
predictor. Beginning with Zen4, AMD's IBPB *does* clear the return address
predictor. This behavior is enumerated by CPUID.80000008H:EBX.IBPB_RET[30].

Define X86_FEATURE_AMD_IBPB_RET for use in KVM_GET_SUPPORTED_CPUID,
when determining cross-vendor capabilities.

Suggested-by: Venkatesh Srinivas <venkateshs@chromium.org>
Signed-off-by: Jim Mattson <jmattson@google.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
Cc: <stable@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/cpufeatures.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -217,7 +217,7 @@
 #define X86_FEATURE_SPEC_STORE_BYPASS_DISABLE	( 7*32+23) /* "" Disable Speculative Store Bypass. */
 #define X86_FEATURE_LS_CFG_SSBD		( 7*32+24)  /* "" AMD SSBD implementation via LS_CFG MSR */
 #define X86_FEATURE_IBRS		( 7*32+25) /* Indirect Branch Restricted Speculation */
-#define X86_FEATURE_IBPB		( 7*32+26) /* Indirect Branch Prediction Barrier */
+#define X86_FEATURE_IBPB		( 7*32+26) /* "ibpb" Indirect Branch Prediction Barrier without a guaranteed RSB flush */
 #define X86_FEATURE_STIBP		( 7*32+27) /* Single Thread Indirect Branch Predictors */
 #define X86_FEATURE_ZEN			( 7*32+28) /* "" CPU is AMD family 0x17 or above (Zen) */
 #define X86_FEATURE_L1TF_PTEINV		( 7*32+29) /* "" L1TF workaround PTE inversion */
@@ -324,6 +324,7 @@
 #define X86_FEATURE_VIRT_SSBD		(13*32+25) /* Virtualized Speculative Store Bypass Disable */
 #define X86_FEATURE_AMD_SSB_NO		(13*32+26) /* "" Speculative Store Bypass is fixed in hardware. */
 #define X86_FEATURE_BTC_NO		(13*32+29) /* "" Not vulnerable to Branch Type Confusion */
+#define X86_FEATURE_AMD_IBPB_RET	(13*32+30) /* "" IBPB clears return address predictor */
 
 /* Thermal and Power Management Leaf, CPUID level 0x00000006 (EAX), word 14 */
 #define X86_FEATURE_DTHERM		(14*32+ 0) /* Digital Thermal Sensor */


