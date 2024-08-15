Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 215D21AC893;
	Thu, 15 Aug 2024 14:41:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723732893; cv=none; b=HlixoHstaFVf4lhn2od1Sl1q415fT/GTcDj4t2KebXsrBW+4AoYMaiBBo6S2gTBvPRE5b0fSJJNxpKDXRslq0pqmqE81q90Mta7zu30oFJofv3ufIUb7Uk+czh1jbYKK87o2WO99pk2A/ncVuXCPC1JM/7f+u6dGZX+g9Qsa7d8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723732893; c=relaxed/simple;
	bh=H9YD5wKnUHrqxJizJPFHMXLN1o7pcvq/0Gljl3j0fKY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jUKU3/gBf9AxHYsF8hl2t3xER638vVD61a4zbrH6g9jtCZuP8750GAB47leVN0Fgn/NSDmgp+X+k0YxzTQImXHRfFQZzUXaHdxz5GZGwFMvlHvuTkF6DHId5oKGrTPFWOjDLHlf3stnJbFazLSv4FRwxxcDv49qPiEDBX3eEdOw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YIuBEN4m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YIuBEN4m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A4F4C32786;
	Thu, 15 Aug 2024 14:41:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723732892;
	bh=H9YD5wKnUHrqxJizJPFHMXLN1o7pcvq/0Gljl3j0fKY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YIuBEN4mBEHkPbx9lQFqbRfmeDDHZfFgArjszDeZUu21Oj/A7+DmEKBvCibWAC2OX
	 IUapyds58PMYWft9S7jcmun4A2y/mQ+J08pXr53P9f40NXejwpJrLtQ/EkhlJFRsuN
	 dboNMoVD7lBscf601FxONRxLCu+bPTWaMqZKY4sI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Rutland <mark.rutland@arm.com>,
	James Morse <james.morse@arm.com>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 287/352] arm64: cputype: Add Cortex-A720 definitions
Date: Thu, 15 Aug 2024 15:25:53 +0200
Message-ID: <20240815131930.542260784@linuxfoundation.org>
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

From: Mark Rutland <mark.rutland@arm.com>

[ Upstream commit add332c40328cf06fe35e4b3cde8ec315c4629e5 ]

Add cputype definitions for Cortex-A720. These will be used for errata
detection in subsequent patches.

These values can be found in Table A-186 ("MIDR_EL1 bit descriptions")
in issue 0002-05 of the Cortex-A720 TRM, which can be found at:

  https://developer.arm.com/documentation/102530/0002/?lang=en

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: James Morse <james.morse@arm.com>
Cc: Will Deacon <will@kernel.org>
Link: https://lore.kernel.org/r/20240603111812.1514101-3-mark.rutland@arm.com
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
[ Mark: trivial backport ]
Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/include/asm/cputype.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/include/asm/cputype.h b/arch/arm64/include/asm/cputype.h
index e8ceddaba7a06..4f08438344e2a 100644
--- a/arch/arm64/include/asm/cputype.h
+++ b/arch/arm64/include/asm/cputype.h
@@ -86,6 +86,7 @@
 #define ARM_CPU_PART_CORTEX_A78C	0xD4B
 #define ARM_CPU_PART_CORTEX_X3		0xD4E
 #define ARM_CPU_PART_NEOVERSE_V2	0xD4F
+#define ARM_CPU_PART_CORTEX_A720	0xD81
 #define ARM_CPU_PART_CORTEX_X4		0xD82
 #define ARM_CPU_PART_NEOVERSE_V3	0xD84
 
@@ -142,6 +143,7 @@
 #define MIDR_CORTEX_A78C	MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_A78C)
 #define MIDR_CORTEX_X3 MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_X3)
 #define MIDR_NEOVERSE_V2 MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_NEOVERSE_V2)
+#define MIDR_CORTEX_A720 MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_A720)
 #define MIDR_CORTEX_X4 MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_X4)
 #define MIDR_NEOVERSE_V3 MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_NEOVERSE_V3)
 #define MIDR_THUNDERX	MIDR_CPU_MODEL(ARM_CPU_IMP_CAVIUM, CAVIUM_CPU_PART_THUNDERX)
-- 
2.43.0



