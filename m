Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7587C1DF249;
	Wed,  6 Nov 2024 12:17:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730895433; cv=none; b=QJpm6dWVV0gua8+0zNDBTnfllOtEPUMmk13x0IP7GzzQCdv4hAWDNqvijiH4dYPWdz8LSbEI0/yIG1Yf7hUTgXxxFado3WIAvc2iCTF/nlJScP0oZqjCbH7oWxcNOuV8E545XZVltLXYE5FYwgVrTb0OKkuSAQn7B4Gek/ZyVGQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730895433; c=relaxed/simple;
	bh=pJIrqatPnOw7XqObTRvFo0WUaSlOHeEOSZGEOHIsQJE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MYwWLdCOuS4W+dN+CiLxUeh+bT6vyCcz6zMGZfa4/KlbXYDTN8HusLHA94CDcjuTEBcZMVbUvjps8xnfxrOeGuowgWtU1KwC60xfNAExVyAGMkNGJa1isgqVPO4ylnjioJAPw/D3KWWTDgDDumB7u68WF3tr++FiYYmXL0s/0g8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=on/Ign6v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="on/Ign6v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0F19C4CECD;
	Wed,  6 Nov 2024 12:17:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730895433;
	bh=pJIrqatPnOw7XqObTRvFo0WUaSlOHeEOSZGEOHIsQJE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=on/Ign6v7qp3qcyA7qE6EPNBVX5EjVSgX9tiQl04bz2E5RTxCL3JArUntsjDo4TWl
	 U3gsriO+FAMP2eYyv0opJUHnUNKeDB6iIE37SoWnQJCyo9BfNVIeC1jJmI+BQAABG8
	 1Y3WEVLUOkvqPs+4WmZhFkaq9k4ni3+1MQiBRwnA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	James Morse <james.morse@arm.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 217/350] arm64: Add Cortex-715 CPU part definition
Date: Wed,  6 Nov 2024 13:02:25 +0100
Message-ID: <20241106120326.359631125@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120320.865793091@linuxfoundation.org>
References: <20241106120320.865793091@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anshuman Khandual <anshuman.khandual@arm.com>

[ Upstream commit 07e39e60bbf0ccd5f895568e1afca032193705c0 ]

Add the CPU Partnumbers for the new Arm designs.

Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: James Morse <james.morse@arm.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Link: https://lore.kernel.org/r/20221116140915.356601-2-anshuman.khandual@arm.com
Signed-off-by: Will Deacon <will@kernel.org>
[ Mark: Trivial backport ]
Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/include/asm/cputype.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/include/asm/cputype.h b/arch/arm64/include/asm/cputype.h
index f8be4d7ecde28..e3df8b0c067bf 100644
--- a/arch/arm64/include/asm/cputype.h
+++ b/arch/arm64/include/asm/cputype.h
@@ -86,6 +86,7 @@
 #define ARM_CPU_PART_CORTEX_A78		0xD41
 #define ARM_CPU_PART_CORTEX_X1		0xD44
 #define ARM_CPU_PART_CORTEX_A710	0xD47
+#define ARM_CPU_PART_CORTEX_A715	0xD4D
 #define ARM_CPU_PART_CORTEX_X2		0xD48
 #define ARM_CPU_PART_NEOVERSE_N2	0xD49
 #define ARM_CPU_PART_CORTEX_A78C	0xD4B
@@ -130,6 +131,7 @@
 #define MIDR_CORTEX_A78	MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_A78)
 #define MIDR_CORTEX_X1	MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_X1)
 #define MIDR_CORTEX_A710 MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_A710)
+#define MIDR_CORTEX_A715 MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_A715)
 #define MIDR_CORTEX_X2 MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_X2)
 #define MIDR_NEOVERSE_N2 MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_NEOVERSE_N2)
 #define MIDR_CORTEX_A78C	MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_A78C)
-- 
2.43.0



