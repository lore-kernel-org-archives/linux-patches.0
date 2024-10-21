Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F10CD1F1304;
	Mon, 21 Oct 2024 10:42:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729507337; cv=none; b=ZKx+1lSqHYaUTWUTleSHMBkrHQRWhrLGIQkvgrjUB7NXEZUjpitOY9CIqPb7tOfImqKTeCosInAIHUxx4/TtJd0Vd0B4NaQ0szjWDerqNJNHqGXMOXKYcrQbgUx9aeh54QAEfyRk7AoFSp4uvqfAWUw3+g2SAPq7ZDSqbTmhNKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729507337; c=relaxed/simple;
	bh=SqE6i7X+t1DzSd2hTCDnqql9KZhKewztMoQe9Iq8mBA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FbBzbBHF+NUor8kdpOyLfJzoo6/v5/wGsh61iURsGNpnqfvT/jaSb004DsPBTFcydpaaapxNAN0ErZhAsiQNd+lZ3maoqjkY6M0TCU5J0PBDZlvOKEvxJhLIcM+LNRcE2BsiXuZnwVU2MpgPIaTLC2vKusznyDWUGXcHRqpEvH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pQNiVio4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pQNiVio4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 337D4C4CEC3;
	Mon, 21 Oct 2024 10:42:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729507336;
	bh=SqE6i7X+t1DzSd2hTCDnqql9KZhKewztMoQe9Iq8mBA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pQNiVio46NhE1QLIUpsCu4nWV3qODQrnjrxZHOMn7G6kP2+MrEB7advdoz/eagWFl
	 cjXBInuu2HPf8uO/prltUOtwcEDzGrs7Ljb51z5Ya8at2CPuovfaviffuvtgtSsa8K
	 faQD2kcTh+7TV8i1ikInsgNmW9vU1l+f0o1cP6Jk=
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
Subject: [PATCH 6.1 43/91] x86/cpufeatures: Define X86_FEATURE_AMD_IBPB_RET
Date: Mon, 21 Oct 2024 12:24:57 +0200
Message-ID: <20241021102251.501521350@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241021102249.791942892@linuxfoundation.org>
References: <20241021102249.791942892@linuxfoundation.org>
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
 #define X86_FEATURE_ZEN			(7*32+28) /* "" CPU based on Zen microarchitecture */
 #define X86_FEATURE_L1TF_PTEINV		( 7*32+29) /* "" L1TF workaround PTE inversion */
@@ -332,6 +332,7 @@
 #define X86_FEATURE_AMD_SSB_NO		(13*32+26) /* "" Speculative Store Bypass is fixed in hardware. */
 #define X86_FEATURE_CPPC		(13*32+27) /* Collaborative Processor Performance Control */
 #define X86_FEATURE_BTC_NO		(13*32+29) /* "" Not vulnerable to Branch Type Confusion */
+#define X86_FEATURE_AMD_IBPB_RET	(13*32+30) /* "" IBPB clears return address predictor */
 #define X86_FEATURE_BRS			(13*32+31) /* Branch Sampling available */
 
 /* Thermal and Power Management Leaf, CPUID level 0x00000006 (EAX), word 14 */


