Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7C3F12CDA5;
	Mon, 23 Mar 2026 16:21:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774282885; cv=none; b=VtzgyaPAWRZKESC3W19f1iHd2/DAyte8YhjnDkT24jOxboykxWbIXqBwBoOS3lG0R+KKB3VeDUfbeMuK1INeMsgXTHx4psBQgAjFtmBmu+mwJfs4LJZTbKXynoU3V8h5+b2dfpPFT89iEVvUniAdGOUxI9BXwDO8EuBj8VqZ0dc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774282885; c=relaxed/simple;
	bh=HMO8nn4NjjEGGAIfPVbpRX3sq4aSnrQfOcdrrJtUJnc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dR4UDvjVumZJ82EcEcR1hn091jNQ5qStUKha1HSnrlFnFakWqEelV6cHB4mnDJEVDwNDR2L5ClICwn9HvZOiAhwfq+Qox4n2yO3fDeLPs+EJ8wfxtAGLuCGQSxK+2gayomO7N467Jrzhc7IiWD6KWgM9DXZELQ30D3qxuPd8eag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QtvTg6oB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QtvTg6oB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79C49C4CEF7;
	Mon, 23 Mar 2026 16:21:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774282884;
	bh=HMO8nn4NjjEGGAIfPVbpRX3sq4aSnrQfOcdrrJtUJnc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QtvTg6oBNou7IKC9iqp0R4CoGKsy3Zy1Y2heuLkrCJRz2aoifPmQCoksaP4ahOXQD
	 nFT1qSLa1183CrUX07qToOrMrR124YiJup92Cjcp+k8zVuz7H5N8rbKFA9KUNcubB2
	 E1eQk1N1E0GCjcAqUpe/uuTcwkuKXFunxCR0q1FE=
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
Subject: [PATCH 6.1 320/481] x86/sev: Allow IBPB-on-Entry feature for SNP guests
Date: Mon, 23 Mar 2026 14:45:02 +0100
Message-ID: <20260323134532.898783114@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134525.256603107@linuxfoundation.org>
References: <20260323134525.256603107@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -328,6 +328,7 @@ static void enforce_vmpl0(void)
 				 MSR_AMD64_SNP_VMSA_REG_PROTECTION |	\
 				 MSR_AMD64_SNP_RESERVED_BIT13 |		\
 				 MSR_AMD64_SNP_RESERVED_BIT15 |		\
+				 MSR_AMD64_SNP_RESERVED_BITS18_22 |	\
 				 MSR_AMD64_SNP_RESERVED_MASK)
 
 /*
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -630,11 +630,14 @@
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
 


