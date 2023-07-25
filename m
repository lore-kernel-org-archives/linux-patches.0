Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 874AE14263
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 10:54:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 077FFC433C8;
	Tue, 25 Jul 2023 10:54:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690282499;
	bh=+T2APAff6FBhsswG1DGZLYN6qJb84D8IgwdNqPq2n9g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0uBMNtaQGwTseTJK4yGpFVw2Ln3g0aDpTVBGf9zJbNdHwAcMj5ca6DrtdyWwkIUUE
	 7cQ1Mnoq5kDDD2U1E4a4wZ959XkT31mFpYedEwth6BiLiNBUr4S8xU6GlHOx3+qPP7
	 T1izDhJmusnxQoJnT4x3VkfVIzILEiPsl8PUcVXI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marc Zyngier <maz@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 151/227] arm64: Fix HFGxTR_EL2 field naming
Date: Tue, 25 Jul 2023 12:45:18 +0200
Message-ID: <20230725104521.161399602@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725104514.821564989@linuxfoundation.org>
References: <20230725104514.821564989@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Marc Zyngier <maz@kernel.org>

[ Upstream commit 55b87b74996383230586f4f9f801ae304c70e649 ]

The HFGxTR_EL2 fields do not always follow the naming described
in the spec, nor do they match the name of the register they trap
in the rest of the kernel.

It is a bit sad that they were written by hand despite the availability
of a machine readable version...

Fixes: cc077e7facbe ("arm64/sysreg: Convert HFG[RW]TR_EL2 to automatic generation")
Signed-off-by: Marc Zyngier <maz@kernel.org>
Cc: Mark Brown <broonie@kernel.org>
Cc: Will Deacon <will@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Reviewed-by: Mark Brown <broonie@kernel.org>
Link: https://lore.kernel.org/r/20230703130416.1495307-1-maz@kernel.org
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/tools/sysreg | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
index c9a0d1fa32090..930c8cc0812fc 100644
--- a/arch/arm64/tools/sysreg
+++ b/arch/arm64/tools/sysreg
@@ -1890,7 +1890,7 @@ Field	0	SM
 EndSysreg
 
 SysregFields	HFGxTR_EL2
-Field	63	nAMIAIR2_EL1
+Field	63	nAMAIR2_EL1
 Field	62	nMAIR2_EL1
 Field	61	nS2POR_EL1
 Field	60	nPOR_EL1
@@ -1905,9 +1905,9 @@ Field	52	nGCS_EL0
 Res0	51
 Field	50	nACCDATA_EL1
 Field	49	ERXADDR_EL1
-Field	48	EXRPFGCDN_EL1
-Field	47	EXPFGCTL_EL1
-Field	46	EXPFGF_EL1
+Field	48	ERXPFGCDN_EL1
+Field	47	ERXPFGCTL_EL1
+Field	46	ERXPFGF_EL1
 Field	45	ERXMISCn_EL1
 Field	44	ERXSTATUS_EL1
 Field	43	ERXCTLR_EL1
@@ -1922,8 +1922,8 @@ Field	35	TPIDR_EL0
 Field	34	TPIDRRO_EL0
 Field	33	TPIDR_EL1
 Field	32	TCR_EL1
-Field	31	SCTXNUM_EL0
-Field	30	SCTXNUM_EL1
+Field	31	SCXTNUM_EL0
+Field	30	SCXTNUM_EL1
 Field	29	SCTLR_EL1
 Field	28	REVIDR_EL1
 Field	27	PAR_EL1
-- 
2.39.2



