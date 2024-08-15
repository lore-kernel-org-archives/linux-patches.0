Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B66A1E526;
	Thu, 15 Aug 2024 14:21:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723731697; cv=none; b=H9OjgO7t3OLBucH7fH5CL8gTyyy4Wc0+zWvwV+EWzKPhDHjZ+TWsnEQYmnU33N1wfI1/+jcsJJJQ6fsJiIH8VsYzmwzBIzUZgPOs25iJh44b6CsbUTNjjaE4NYQQms1T8YJwK0Nh4ypNQhojzOhNLebAbp0OCEMopCYlATAMgH4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723731697; c=relaxed/simple;
	bh=3LMhezjp7iFpRh/orrTUaLhaIWcdJhixGBAffS3BOBU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uuk5brixGcYQDs++aK9G6XgqPhWscqXH305QQnEPJIrfaFbAwDUOtgbot7bCNgzL5Z8P23W8DJH/2h4QtVG8LHzYsLbUVArbkaKgxoJrOzZnsNRrF1Vo1mKzFtrGBL95C4FAX+RzJ1G4mVWA/DLArHbBm/SR6HlCH9ExGQs7aGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qg1DUOTr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qg1DUOTr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B75BFC32786;
	Thu, 15 Aug 2024 14:21:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723731697;
	bh=3LMhezjp7iFpRh/orrTUaLhaIWcdJhixGBAffS3BOBU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qg1DUOTrfwBRDecFO4G/47dxSLoitP9FRsuitBxtLuPiM7b0gwyFHDGUS/2nKbF/Y
	 Dh/CF78dwudczrkNDGlqRV8cSETj6YoqkETv65k77JPs1HMi+2cSTIYpI4QMHFHRqF
	 Q+RmGCdw20+qZ9yPDOpUrtHCRVc8Ohmk7Nb03Ufw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Rutland <mark.rutland@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	James Morse <james.morse@arm.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 210/259] arm64: cputype: Add Cortex-X4 definitions
Date: Thu, 15 Aug 2024 15:25:43 +0200
Message-ID: <20240815131910.881223140@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131902.779125794@linuxfoundation.org>
References: <20240815131902.779125794@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Rutland <mark.rutland@arm.com>

[ Upstream commit 02a0a04676fa7796d9cbc9eb5ca120aaa194d2dd ]

Add cputype definitions for Cortex-X4. These will be used for errata
detection in subsequent patches.

These values can be found in Table B-249 ("MIDR_EL1 bit descriptions")
in issue 0002-05 of the Cortex-X4 TRM, which can be found at:

  https://developer.arm.com/documentation/102484/0002/?lang=en

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: James Morse <james.morse@arm.com>
Cc: Will Deacon <will@kernel.org>
Link: https://lore.kernel.org/r/20240508081400.235362-3-mark.rutland@arm.com
Signed-off-by: Will Deacon <will@kernel.org>
[ Mark: fix conflict (dealt with upstream via a later merge) ]
Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/include/asm/cputype.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/include/asm/cputype.h b/arch/arm64/include/asm/cputype.h
index 852cecbe68218..75deab44560d3 100644
--- a/arch/arm64/include/asm/cputype.h
+++ b/arch/arm64/include/asm/cputype.h
@@ -81,6 +81,7 @@
 #define ARM_CPU_PART_NEOVERSE_N2	0xD49
 #define ARM_CPU_PART_CORTEX_A78C	0xD4B
 #define ARM_CPU_PART_NEOVERSE_V2	0xD4F
+#define ARM_CPU_PART_CORTEX_X4		0xD82
 
 #define APM_CPU_PART_POTENZA		0x000
 
@@ -123,6 +124,7 @@
 #define MIDR_NEOVERSE_N2 MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_NEOVERSE_N2)
 #define MIDR_CORTEX_A78C	MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_A78C)
 #define MIDR_NEOVERSE_V2 MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_NEOVERSE_V2)
+#define MIDR_CORTEX_X4 MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_X4)
 #define MIDR_THUNDERX	MIDR_CPU_MODEL(ARM_CPU_IMP_CAVIUM, CAVIUM_CPU_PART_THUNDERX)
 #define MIDR_THUNDERX_81XX MIDR_CPU_MODEL(ARM_CPU_IMP_CAVIUM, CAVIUM_CPU_PART_THUNDERX_81XX)
 #define MIDR_THUNDERX_83XX MIDR_CPU_MODEL(ARM_CPU_IMP_CAVIUM, CAVIUM_CPU_PART_THUNDERX_83XX)
-- 
2.43.0



