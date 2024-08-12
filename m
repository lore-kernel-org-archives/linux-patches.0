Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B25A4178CE4;
	Mon, 12 Aug 2024 16:17:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723479431; cv=none; b=qL8CMfkbEFAuzLCLAlVW9Kma1gj15H9NpfRkBxmLV1UTWj2Uek2D2rsR1gWJQguKU5Y4dwdcDwN972NilCsu/cZ71KYt1iTf7982AcoQk1QBhz1nq3L4D0Xc4w5jR3i3vQeT4eDaFQTCe94WopOloAfLvfZ6J0oS+EZ7T83f4P4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723479431; c=relaxed/simple;
	bh=fp1IT84kVGZgz9FngR4NShBUz48hZsO30WFENT1Bzl0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Sqqfkf/9pA1/DktGLBqySoR5cPk+tlIhV4ZuKOImMAD3N45wtxSbCq6RXqdJY9huajTaQ8sSv8kiKV5geo7VAW8cvn/3mAtPnRaQ9GAZ08V4gH7QT9X2Lb/nfJ9Vkn/dStGInohp1Nu3+jjqxEaDvnBBcWCwqZacB2vLPyLGAg0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tGryv49Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tGryv49Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3765CC32782;
	Mon, 12 Aug 2024 16:17:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723479431;
	bh=fp1IT84kVGZgz9FngR4NShBUz48hZsO30WFENT1Bzl0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tGryv49Qhe6YRPq1NpFH6TLizBWYoHKnQwm0HHoPlE7UwHNyffv0Kg7lFaJOL0nsa
	 21Lq4meKLDgafHIhVwS6H0J+b55paQuh2/zJoq04Lijucid1OHJTf6eA3NFVZn7ISo
	 YaugBtYImUj+dbISnXMSp3MxnbSHNZ7cyNr72LRw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Rutland <mark.rutland@arm.com>,
	James Morse <james.morse@arm.com>,
	Will Deacon <will@kernel.org>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 085/189] arm64: cputype: Add Cortex-A725 definitions
Date: Mon, 12 Aug 2024 18:02:21 +0200
Message-ID: <20240812160135.415249780@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160132.135168257@linuxfoundation.org>
References: <20240812160132.135168257@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Rutland <mark.rutland@arm.com>

[ Upstream commit 9ef54a384526911095db465e77acc1cb5266b32c ]

Add cputype definitions for Cortex-A725. These will be used for errata
detection in subsequent patches.

These values can be found in the Cortex-A725 TRM:

  https://developer.arm.com/documentation/107652/0001/

... in table A-247 ("MIDR_EL1 bit descriptions").

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: James Morse <james.morse@arm.com>
Cc: Will Deacon <will@kernel.org>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Link: https://lore.kernel.org/r/20240801101803.1982459-3-mark.rutland@arm.com
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
[ Mark: trivial backport ]
Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/include/asm/cputype.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/include/asm/cputype.h b/arch/arm64/include/asm/cputype.h
index 5dc68ace305e5..5fd7caea44193 100644
--- a/arch/arm64/include/asm/cputype.h
+++ b/arch/arm64/include/asm/cputype.h
@@ -93,6 +93,7 @@
 #define ARM_CPU_PART_CORTEX_X4		0xD82
 #define ARM_CPU_PART_NEOVERSE_V3	0xD84
 #define ARM_CPU_PART_CORTEX_X925	0xD85
+#define ARM_CPU_PART_CORTEX_A725	0xD87
 
 #define APM_CPU_PART_XGENE		0x000
 #define APM_CPU_VAR_POTENZA		0x00
@@ -173,6 +174,7 @@
 #define MIDR_CORTEX_X4 MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_X4)
 #define MIDR_NEOVERSE_V3 MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_NEOVERSE_V3)
 #define MIDR_CORTEX_X925 MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_X925)
+#define MIDR_CORTEX_A725 MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_A725)
 #define MIDR_THUNDERX	MIDR_CPU_MODEL(ARM_CPU_IMP_CAVIUM, CAVIUM_CPU_PART_THUNDERX)
 #define MIDR_THUNDERX_81XX MIDR_CPU_MODEL(ARM_CPU_IMP_CAVIUM, CAVIUM_CPU_PART_THUNDERX_81XX)
 #define MIDR_THUNDERX_83XX MIDR_CPU_MODEL(ARM_CPU_IMP_CAVIUM, CAVIUM_CPU_PART_THUNDERX_83XX)
-- 
2.43.0



