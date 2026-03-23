Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 822FA3B52E4;
	Mon, 23 Mar 2026 15:10:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774278656; cv=none; b=c5StmMN3lsgJZz+0aJRynBqsA7MwdsTMDuNd9Kb1wU39tL1z+2EKM95TeBapEpdgavy5pfdck6LYUSfPyuOlqUlnsKOg/jvJEVTzgW5icdHmGUcDJv8MGpjuUR+NOATcbSq8mSAmrPm2QsuRWmLbGeK3J1+9YQWCvXxl7df53p0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774278656; c=relaxed/simple;
	bh=l8UtLKpgtwcFrOxECRk+fRQ6oxHlpk9ExDLRcazXJ0A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ono8s62RJ7jX8x/Ac8fjY0kupE67jiFlfq8ArxfA8DE4DKgPRDblmJjdsaClV4JgeQfsdoaOCNJfIcO0z0TUR9jZDNSSTMiyVeEPmZmOx4IWgfYfkQLsx5FN7RUZKofDrddMSywesscariI1qKtiNdhQw24+bdFMXcIwRK+gQq8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Vgtg0qh1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Vgtg0qh1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1D17C4CEF7;
	Mon, 23 Mar 2026 15:10:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774278656;
	bh=l8UtLKpgtwcFrOxECRk+fRQ6oxHlpk9ExDLRcazXJ0A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Vgtg0qh1GIczu3+yFad6AckafvdovuHheuVXMiCtWfHiYK7usaTMTXPTKJc8nFKRZ
	 QwXozBR5eK29LOESj6EuRbTUIBkBbwli05XRZrAAc2CIdI5n7biSUQ78fgeu1qqNl2
	 Xdt/ZOBM5oEyi4O82QuBEzuClgPSkVXWK/O1agnM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kim Phillips <kim.phillips@amd.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Nikunj A Dadhania <nikunj@amd.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	stable@kernel.org,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 370/567] x86/sev: Allow IBPB-on-Entry feature for SNP guests
Date: Mon, 23 Mar 2026 14:44:50 +0100
Message-ID: <20260323134542.979372436@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134533.749096647@linuxfoundation.org>
References: <20260323134533.749096647@linuxfoundation.org>
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

From: Kim Phillips <kim.phillips@amd.com>

[ Upstream commit 9073428bb204d921ae15326bb7d4558d9d269aab ]

The SEV-SNP IBPB-on-Entry feature does not require a guest-side
implementation. It was added in Zen5 h/w, after the first SNP Zen
implementation, and thus was not accounted for when the initial set of SNP
features were added to the kernel.

In its abundant precaution, commit

  8c29f0165405 ("x86/sev: Add SEV-SNP guest feature negotiation support")

included SEV_STATUS' IBPB-on-Entry bit as a reserved bit, thereby masking
guests from using the feature.

Allow guests to make use of IBPB-on-Entry when supported by the hypervisor, as
the bit is now architecturally defined and safe to expose.

Fixes: 8c29f0165405 ("x86/sev: Add SEV-SNP guest feature negotiation support")
Signed-off-by: Kim Phillips <kim.phillips@amd.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Reviewed-by: Nikunj A Dadhania <nikunj@amd.com>
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
Cc: stable@kernel.org
Link: https://patch.msgid.link/20260203222405.4065706-2-kim.phillips@amd.com
[ No SECURE_AVIC ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/boot/compressed/sev.c   |    1 +
 arch/x86/include/asm/msr-index.h |    5 ++++-
 2 files changed, 5 insertions(+), 1 deletion(-)

--- a/arch/x86/boot/compressed/sev.c
+++ b/arch/x86/boot/compressed/sev.c
@@ -341,6 +341,7 @@ static void enforce_vmpl0(void)
 				 MSR_AMD64_SNP_VMSA_REG_PROTECTION |	\
 				 MSR_AMD64_SNP_RESERVED_BIT13 |		\
 				 MSR_AMD64_SNP_RESERVED_BIT15 |		\
+				 MSR_AMD64_SNP_RESERVED_BITS18_22 |	\
 				 MSR_AMD64_SNP_RESERVED_MASK)
 
 /*
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -632,11 +632,14 @@
 #define MSR_AMD64_SNP_IBS_VIRT			BIT_ULL(14)
 #define MSR_AMD64_SNP_VMSA_REG_PROTECTION	BIT_ULL(16)
 #define MSR_AMD64_SNP_SMT_PROTECTION		BIT_ULL(17)
+#define MSR_AMD64_SNP_IBPB_ON_ENTRY_BIT	23
+#define MSR_AMD64_SNP_IBPB_ON_ENTRY		BIT_ULL(MSR_AMD64_SNP_IBPB_ON_ENTRY_BIT)
 
 /* SNP feature bits reserved for future use. */
 #define MSR_AMD64_SNP_RESERVED_BIT13		BIT_ULL(13)
 #define MSR_AMD64_SNP_RESERVED_BIT15		BIT_ULL(15)
-#define MSR_AMD64_SNP_RESERVED_MASK		GENMASK_ULL(63, 18)
+#define MSR_AMD64_SNP_RESERVED_BITS18_22	GENMASK_ULL(22, 18)
+#define MSR_AMD64_SNP_RESERVED_MASK		GENMASK_ULL(63, 24)
 
 #define MSR_AMD64_VIRT_SPEC_CTRL	0xc001011f
 


