Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3B342C1A5;
	Mon, 12 Aug 2024 16:16:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723479403; cv=none; b=r1BnvR4x8EVQ9Qw6AAFnbWMardPiMcGkZMAEQa3PSlmFrGBdjSIKmXA6aV909Bek+ypyWx07uYxvgVFuaVhO1yxMci+DWip8ZQKixU7IKxvGTbZXXFxhoq2Pm+ENqTw/Qhs72gtBs83BgIRIQHPy7X9260yWBN66ERpLRjOtERY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723479403; c=relaxed/simple;
	bh=REI0A3Elre6r33BgVXGA52c0/vn0C7VDIUlHxgLIXuA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bL/JpsNOflRBHxDkdN/O3nnPeuVCau8L6PJIXCjxSYu8KMPGLaxYJsqJGOqmu1R27VgdLBks7XZiQ68L0sPwgXYcylpHHqKh3M9YG4LfxbxZq+/NazahYVBTBWVEFiFqw1+eWyE9WfBsg8tHA+FtIAfr6zm++W8nCBpqsIqiuys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CuYvFrIg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CuYvFrIg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16D93C32782;
	Mon, 12 Aug 2024 16:16:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723479403;
	bh=REI0A3Elre6r33BgVXGA52c0/vn0C7VDIUlHxgLIXuA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CuYvFrIgzRFb8jhB8iEGbhRwUBU5h8Kzws7VPEkQlzNFCnkCZUZPD5w4xHiz2lBmB
	 4nwjfB6BvhdmRZuwmW7tKW1t0qg1F6hIFXmOJBFRvlHsnA0xwtzmH29QebQrc+Ij+2
	 KZN6CThkwheCDV5rjN8zh7RoRhPAGvzLyflVFyZw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Rutland <mark.rutland@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	James Morse <james.morse@arm.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 077/189] arm64: cputype: Add Neoverse-V3 definitions
Date: Mon, 12 Aug 2024 18:02:13 +0200
Message-ID: <20240812160135.105353602@linuxfoundation.org>
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

[ Upstream commit 0ce85db6c2141b7ffb95709d76fc55a27ff3cdc1 ]

Add cputype definitions for Neoverse-V3. These will be used for errata
detection in subsequent patches.

These values can be found in Table B-249 ("MIDR_EL1 bit descriptions")
in issue 0001-04 of the Neoverse-V3 TRM, which can be found at:

  https://developer.arm.com/documentation/107734/0001/?lang=en

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: James Morse <james.morse@arm.com>
Cc: Will Deacon <will@kernel.org>
Link: https://lore.kernel.org/r/20240508081400.235362-4-mark.rutland@arm.com
Signed-off-by: Will Deacon <will@kernel.org>
[ Mark: trivial backport ]
Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/include/asm/cputype.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/include/asm/cputype.h b/arch/arm64/include/asm/cputype.h
index b810b1f03746c..7b32b99023a21 100644
--- a/arch/arm64/include/asm/cputype.h
+++ b/arch/arm64/include/asm/cputype.h
@@ -88,6 +88,7 @@
 #define ARM_CPU_PART_CORTEX_A78C	0xD4B
 #define ARM_CPU_PART_NEOVERSE_V2	0xD4F
 #define ARM_CPU_PART_CORTEX_X4		0xD82
+#define ARM_CPU_PART_NEOVERSE_V3	0xD84
 
 #define APM_CPU_PART_XGENE		0x000
 #define APM_CPU_VAR_POTENZA		0x00
@@ -163,6 +164,7 @@
 #define MIDR_CORTEX_A78C	MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_A78C)
 #define MIDR_NEOVERSE_V2 MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_NEOVERSE_V2)
 #define MIDR_CORTEX_X4 MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_X4)
+#define MIDR_NEOVERSE_V3 MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_NEOVERSE_V3)
 #define MIDR_THUNDERX	MIDR_CPU_MODEL(ARM_CPU_IMP_CAVIUM, CAVIUM_CPU_PART_THUNDERX)
 #define MIDR_THUNDERX_81XX MIDR_CPU_MODEL(ARM_CPU_IMP_CAVIUM, CAVIUM_CPU_PART_THUNDERX_81XX)
 #define MIDR_THUNDERX_83XX MIDR_CPU_MODEL(ARM_CPU_IMP_CAVIUM, CAVIUM_CPU_PART_THUNDERX_83XX)
-- 
2.43.0



