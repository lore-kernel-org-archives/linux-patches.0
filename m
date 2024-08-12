Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B86F4186295;
	Mon, 12 Aug 2024 16:07:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723478878; cv=none; b=GeywBOx0rhnxzqxVsm8fGSbXKgGvTqrFaRrpWY947b/SdFTQjpbclJDESt/bN+4G5TRaBo/lbT9GlskNTPmboWZu7VIY8i4/pkNHiSXQCfaHMIgdTUUi5vaqdvHRnPemHNENsFQxH3TEzYUXavCjuKRPVzWJqZuM8WXZHLoaCEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723478878; c=relaxed/simple;
	bh=P2UL7ldGITs/9Zvu7xKVJEjnH63pLscVCnYYam10lvE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YSztnL/8f9Yi1uEPp6y/wzB1L79J95LAI+tP4N6vb7CD1JYEZwBXEi+x/VEJW7dHexL74h3aA9CGv4vJcg77NgksTlh51hDsnJ9afiSw3idWGrczHU/pZ32FJQpGyPYB9XdP5vQFg0ioYjVotH2a814edTeDs65puVGUj6Aw6d4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T6GuiaR4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T6GuiaR4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26D7EC32782;
	Mon, 12 Aug 2024 16:07:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723478878;
	bh=P2UL7ldGITs/9Zvu7xKVJEjnH63pLscVCnYYam10lvE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T6GuiaR4EPc/OOnqcflyISFUF+9sEVJrPj8POY+l79I6oI8vd+p88qRisBHh5WyEm
	 DcUr/6oxUrt5r5LCSy9CGTYxa2MtXwCaHl7ZdyiB9Sgy2PZD2GNjCQiyTOnnO3ILmc
	 YeOj7JQh5prSqTMxse2P/C8v+p/8l46PXUzR3FzY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Rutland <mark.rutland@arm.com>,
	James Morse <james.morse@arm.com>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 065/150] arm64: cputype: Add Cortex-X925 definitions
Date: Mon, 12 Aug 2024 18:02:26 +0200
Message-ID: <20240812160127.683141177@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160125.139701076@linuxfoundation.org>
References: <20240812160125.139701076@linuxfoundation.org>
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

From: Mark Rutland <mark.rutland@arm.com>

[ Upstream commit fd2ff5f0b320f418288e7a1f919f648fbc8a0dfc ]

Add cputype definitions for Cortex-X925. These will be used for errata
detection in subsequent patches.

These values can be found in Table A-285 ("MIDR_EL1 bit descriptions")
in issue 0001-05 of the Cortex-X925 TRM, which can be found at:

  https://developer.arm.com/documentation/102807/0001/?lang=en

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: James Morse <james.morse@arm.com>
Cc: Will Deacon <will@kernel.org>
Link: https://lore.kernel.org/r/20240603111812.1514101-4-mark.rutland@arm.com
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
[ Mark: trivial backport ]
Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/include/asm/cputype.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/include/asm/cputype.h b/arch/arm64/include/asm/cputype.h
index 1e3dbfc81d432..b52d974da8283 100644
--- a/arch/arm64/include/asm/cputype.h
+++ b/arch/arm64/include/asm/cputype.h
@@ -90,6 +90,7 @@
 #define ARM_CPU_PART_CORTEX_A720	0xD81
 #define ARM_CPU_PART_CORTEX_X4		0xD82
 #define ARM_CPU_PART_NEOVERSE_V3	0xD84
+#define ARM_CPU_PART_CORTEX_X925	0xD85
 
 #define APM_CPU_PART_XGENE		0x000
 #define APM_CPU_VAR_POTENZA		0x00
@@ -161,6 +162,7 @@
 #define MIDR_CORTEX_A720 MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_A720)
 #define MIDR_CORTEX_X4 MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_X4)
 #define MIDR_NEOVERSE_V3 MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_NEOVERSE_V3)
+#define MIDR_CORTEX_X925 MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_X925)
 #define MIDR_THUNDERX	MIDR_CPU_MODEL(ARM_CPU_IMP_CAVIUM, CAVIUM_CPU_PART_THUNDERX)
 #define MIDR_THUNDERX_81XX MIDR_CPU_MODEL(ARM_CPU_IMP_CAVIUM, CAVIUM_CPU_PART_THUNDERX_81XX)
 #define MIDR_THUNDERX_83XX MIDR_CPU_MODEL(ARM_CPU_IMP_CAVIUM, CAVIUM_CPU_PART_THUNDERX_83XX)
-- 
2.43.0



