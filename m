Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E426128D834;
	Wed, 23 Apr 2025 15:11:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421063; cv=none; b=X5wuK0Z/2tMSYe76KtCvtSR9d2mq6G+KFZqW8s7ouCqiLbRajb+8wt2YpKHwC/wDroNO4VSRtTJxC1fzS1ADMKxSXqODeyHzGX5rphMY6VKefewHUfdTOwwy4u90Rhf2+GIbotlWYOOTNpDYI23NMRynJxyquWr6DGOh52eTit4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421063; c=relaxed/simple;
	bh=7TEleGxbEJn7prT/0GaBIA9i7LcsvDvF4q110NQkt4E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XnaHvMqKwwrZM+nIcFoAwNz63M4tX182JRyeg+pFuCC9ubYykBGEn0iSKGGWgiAj96GwAuQREQNtMgeh+ChYp85z59+AD2lq9YnYxCOlpaarC5WuWM65Te7gypggxF+nzEZVZ9ybdc57L8cgTxzi8xwwMQ+DVJA6wyJ3yxQRAOM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o4Y78+uH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o4Y78+uH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 755B4C4CEE2;
	Wed, 23 Apr 2025 15:11:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745421062;
	bh=7TEleGxbEJn7prT/0GaBIA9i7LcsvDvF4q110NQkt4E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o4Y78+uHzcLZcWWiA0pCETa4VulTXdu+05z3/81rtiDKn3VoRdPyob6My0l7rELvU
	 IRVmcdlFc2JNquMfIkOnSHFrfKIVMyxxtTibHhcY9czWOk+NKCgELp8nRbFKARkLo6
	 HujdJEou36YhSo32hfAPJemKktBgL7ZUVCnPhaOE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Will Deacon <will@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Eric Auger <eric.auger@redhat.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH 6.12 188/223] arm64/sysreg: Add register fields for HDFGWTR2_EL2
Date: Wed, 23 Apr 2025 16:44:20 +0200
Message-ID: <20250423142624.831640003@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142617.120834124@linuxfoundation.org>
References: <20250423142617.120834124@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anshuman Khandual <anshuman.khandual@arm.com>

commit 2f1f62a1257b9d5eb98a8e161ea7d11f1678f7ad upstream.

This adds register fields for HDFGWTR2_EL2 as per the definitions based
on DDI0601 2024-12.

Cc: Will Deacon <will@kernel.org>
Cc: Mark Brown <broonie@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Reviewed-by: Eric Auger <eric.auger@redhat.com>
Reviewed-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Link: https://lore.kernel.org/r/20250203050828.1049370-4-anshuman.khandual@arm.com
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/tools/sysreg |   28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

--- a/arch/arm64/tools/sysreg
+++ b/arch/arm64/tools/sysreg
@@ -2494,6 +2494,34 @@ Field	1	nPMIAR_EL1
 Field	0	nPMECR_EL1
 EndSysreg
 
+Sysreg HDFGWTR2_EL2	3	4	3	1	1
+Res0	63:25
+Field	24	nPMBMAR_EL1
+Field	23	nMDSTEPOP_EL1
+Field	22	nTRBMPAM_EL1
+Field	21	nPMZR_EL0
+Field	20	nTRCITECR_EL1
+Field	19	nPMSDSFR_EL1
+Res0	18:17
+Field	16	nSPMSCR_EL1
+Field	15	nSPMACCESSR_EL1
+Field	14	nSPMCR_EL0
+Field	13	nSPMOVS
+Field	12	nSPMINTEN
+Field	11	nSPMCNTEN
+Field	10	nSPMSELR_EL0
+Field	9	nSPMEVTYPERn_EL0
+Field	8	nSPMEVCNTRn_EL0
+Field	7	nPMSSCR_EL1
+Res0	6
+Field	5	nMDSELR_EL1
+Field	4	nPMUACR_EL1
+Field	3	nPMICFILTR_EL0
+Field	2	nPMICNTR_EL0
+Field	1	nPMIAR_EL1
+Field	0	nPMECR_EL1
+EndSysreg
+
 Sysreg HDFGRTR_EL2	3	4	3	1	4
 Field	63	PMBIDR_EL1
 Field	62	nPMSNEVFR_EL1


