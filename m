Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB06017C995;
	Thu, 15 Aug 2024 14:41:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723732908; cv=none; b=nWFQW7bHoXu6ujpV8t6E8M1zUSPk+iEQmcNIXer9pmZWHdYGwGmlOn0i7k/iELQa7aDufGfWnTIrLpG/cMFkczS4wtQ5cdIHjINuldSJbrv6OD0i1Mw/6lNloDxJBnVXNwPzlE1cl4vW7nc5afWDDHcTkmmaKQ1tGgDEJ2U6cPM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723732908; c=relaxed/simple;
	bh=i1l0jdXbAQ3uImk10UBYQrfBuxtawrG5R1V1EB/x5W0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OCv4xArSWh7LYSkilVCXwPs0afAKkMOEJVb7c+1qvkhtXXaH7PTQidMctZKnvPjeAp9rTcf5q+0WHwPx+R9SbUC27K0/zgN9Vx/6AbpEFXZkKei7H1Erlgm0LBYWliEjpH5NprwBYup5bcn2RQZIrau6dVJy132nSWkMThyo3XM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Zbyp5yqM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Zbyp5yqM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F9C0C32786;
	Thu, 15 Aug 2024 14:41:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723732908;
	bh=i1l0jdXbAQ3uImk10UBYQrfBuxtawrG5R1V1EB/x5W0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Zbyp5yqMezutRyOqymwpE1UHLaOCOOmBjGVG4H0AMhNm6G4NuKGhKELGwBZUcildw
	 bAt+2dL50qpxrJ53naMiVeOX6wgau1BSdZEpidirDsLq5/+vFYfoODOgIhKlPl9xqA
	 bxqRGfsKeOfx3HfTx+Cgs6NWtH++d7k5/Ag9ieW0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Besar Wicaksono <bwicaksono@nvidia.com>,
	James Clark <james.clark@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 282/352] arm64: Add Neoverse-V2 part
Date: Thu, 15 Aug 2024 15:25:48 +0200
Message-ID: <20240815131930.350819576@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131919.196120297@linuxfoundation.org>
References: <20240815131919.196120297@linuxfoundation.org>
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

From: Besar Wicaksono <bwicaksono@nvidia.com>

[ Upstream commit f4d9d9dcc70b96b5e5d7801bd5fbf8491b07b13d ]

Add the part number and MIDR for Neoverse-V2

Signed-off-by: Besar Wicaksono <bwicaksono@nvidia.com>
Reviewed-by: James Clark <james.clark@arm.com>
Link: https://lore.kernel.org/r/20240109192310.16234-2-bwicaksono@nvidia.com
Signed-off-by: Will Deacon <will@kernel.org>
[ Mark: trivial backport ]
Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/include/asm/cputype.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/include/asm/cputype.h b/arch/arm64/include/asm/cputype.h
index c2a1ccd5fd468..b772159a84b9c 100644
--- a/arch/arm64/include/asm/cputype.h
+++ b/arch/arm64/include/asm/cputype.h
@@ -84,6 +84,7 @@
 #define ARM_CPU_PART_CORTEX_X2		0xD48
 #define ARM_CPU_PART_NEOVERSE_N2	0xD49
 #define ARM_CPU_PART_CORTEX_A78C	0xD4B
+#define ARM_CPU_PART_NEOVERSE_V2	0xD4F
 
 #define APM_CPU_PART_POTENZA		0x000
 
@@ -136,6 +137,7 @@
 #define MIDR_CORTEX_X2 MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_X2)
 #define MIDR_NEOVERSE_N2 MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_NEOVERSE_N2)
 #define MIDR_CORTEX_A78C	MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_A78C)
+#define MIDR_NEOVERSE_V2 MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_NEOVERSE_V2)
 #define MIDR_THUNDERX	MIDR_CPU_MODEL(ARM_CPU_IMP_CAVIUM, CAVIUM_CPU_PART_THUNDERX)
 #define MIDR_THUNDERX_81XX MIDR_CPU_MODEL(ARM_CPU_IMP_CAVIUM, CAVIUM_CPU_PART_THUNDERX_81XX)
 #define MIDR_THUNDERX_83XX MIDR_CPU_MODEL(ARM_CPU_IMP_CAVIUM, CAVIUM_CPU_PART_THUNDERX_83XX)
-- 
2.43.0



