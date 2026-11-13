Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590288;
	b=Psy+oIZAuLRIGmoRsO9SrXvjyFq0n2btJCeNgCBaEEO+o3XprhnBQ11chXjuA+NvxxUz
	 UMLhQlKsT9rweBps+nyiBtsW/uNs204CQUvEdHq/AtwDl1leQNAy/yGWOGk3vXRim5SKB
	 RvWqv5pOMLT5WODxw5y0n2YIsElmcNmfaOigCGFUTKsRu638vcrgeMplG9hwKOVQdcVe6
	 d2L6r0KAnsT8sqEaHnAhujT82fIfzQNkfg02+E681P07VdIffNe464lHBQRLpaBmS/yIg
	 2VWGBxmPlVvxziU3GQr4u8Hf03stca26p+YalITwcCd9ND4gqrGi/OS92T3IuvZ8Haw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590288;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=W9ulyVQp1YYF12BpfPHwPEOFOtmgQqIo9MVtRrJeJgA=;
	b=gz2LKuI7wRpeUU06M4ZkugwaYgLGG3/cJouGus5xijYo3D3zz/CgmvnHWVZxHyNPJ4vL
	 jPk6R/ka8V50po2n+8l7WMbWbGglIlqUm37kR7LdHrkyMKsIa6FQqYRXN11opq9R6O9Dq
	 81uFj/VXjjdFFyGtfDnbVmkeQ5JuI9NakJEYDuggXW4eLLe07zVL8vW6twBFkThdxdBOc
	 BO/7A9OIIv6Icw9O3fNKNe4J3XELArryF4cANopRWYc6W5DfKKL3GoYAXjw+mJdd6ct+V
	 WnrYx2sft/VUE3Syhg7WQ/S/tzJCw4A3Wx1eN8SoLMHZPKODgMeHC0p3Q7nhPBdiZPg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=c3yUnxkS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC967607A5E6;
	Fri, 13 Nov 2026 17:18:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=c3yUnxkS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 795BD1F000C6;
	Fri, 13 Nov 2026 17:18:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590288;
	bh=W9ulyVQp1YYF12BpfPHwPEOFOtmgQqIo9MVtRrJeJgA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=c3yUnxkSxqFjNS4J10f596oFofMIbWTUCh/1stvHzl1EIhatjOX39dCuxHtMMIZX0
	 r77OQJzkzgIHCFjm4nhgTkXfOnrCSl04ccCZBJITu8TaaibPOkUdYkj7VvDALIsU11
	 tbJg2UhbncORbad1jTI0TwsxQPeHhZQVAlQLJQyo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	David Kaplan <david.kaplan@amd.com>,
	stable@kernel.org,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 236/686] x86/bugs: Select the BHI mitigation based on the attack vector properly
Date: Fri, 13 Nov 2026 10:46:09 -0500
Message-ID: <20261113153829.037519055@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

From: Breno Leitao <leitao@debian.org>

[ Upstream commit 3457b3bcd344005af894876cab4e634cabdcbb62 ]

The BHI mitigation selection is inconsistent with the documentation
(attack_vector_controls.rst), which lists BHI under both the
user->kernel and guest->host attack vectors. bhi_select_mitigation()
only enables it when CPU_MITIGATE_GUEST_HOST is set; otherwise it
selects BHI_MITIGATION_OFF, even if CPU_MITIGATE_USER_KERNEL is set.

As a result, a kernel compiled with KVM disabled gets BHI automatically
disabled, since CPU_MITIGATE_GUEST_HOST defaults to off without KVM.
This is a bug, given that CPU_MITIGATE_USER_KERNEL still needs it: on
affected Intel CPUs these kernels lose BHI_DIS_S or the BHB clearing
loop by default. Booting with mitigations=auto,no_guest_host has the
same effect.

Select BHI_MITIGATION_ON whenever user->kernel is mitigated, and keep
BHI_MITIGATION_VMEXIT_ONLY for the guest->host-only case.

  [ bp: Clarify commit title. ]

Fixes: ddcd4d3cb37c ("x86/bugs: Add attack vector controls for BHI")
Signed-off-by: Breno Leitao <leitao@debian.org>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Acked-by: David Kaplan <david.kaplan@amd.com>
Cc: <stable@kernel.org>
Link: https://patch.msgid.link/20261029-bhi-attack-vector-v1-1-29cfa697efb6@debian.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/cpu/bugs.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index 90d0488d54c5c..cbf5c0ddd3b38 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -2233,14 +2233,12 @@ static void __init bhi_select_mitigation(void)
 	if (bhi_mitigation != BHI_MITIGATION_AUTO)
 		return;
 
-	if (cpu_attack_vector_mitigated(CPU_MITIGATE_GUEST_HOST)) {
-		if (cpu_attack_vector_mitigated(CPU_MITIGATE_USER_KERNEL))
-			bhi_mitigation = BHI_MITIGATION_ON;
-		else
-			bhi_mitigation = BHI_MITIGATION_VMEXIT_ONLY;
-	} else {
+	if (cpu_attack_vector_mitigated(CPU_MITIGATE_USER_KERNEL))
+		bhi_mitigation = BHI_MITIGATION_ON;
+	else if (cpu_attack_vector_mitigated(CPU_MITIGATE_GUEST_HOST))
+		bhi_mitigation = BHI_MITIGATION_VMEXIT_ONLY;
+	else
 		bhi_mitigation = BHI_MITIGATION_OFF;
-	}
 }
 
 static void __init bhi_update_mitigation(void)
-- 
2.53.0



