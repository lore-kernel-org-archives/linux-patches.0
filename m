Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99C3F17C7C8;
	Mon, 12 Aug 2024 16:17:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723479428; cv=none; b=XlxtnlxCnB9179NUOOF0QEYGM2DV8HnOMeURWMXSQwulT2FKP8XZztXYRX41kFlX5LCHZm0c5athyVz+FaPFtaxPfjadHjR7mpegoYNwBLkrJvP3+5AtC1n7tSU+NHiX2OFsJxdGTw5CnIyOQJKC5hK4X6vVgQNbEs4UU6x+wfo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723479428; c=relaxed/simple;
	bh=l7vbSMAAW1RSjL3G33qTP2vnbbe0mnCtcKz9BEWeldY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PywADM0ALI4qt0BKBKbZfNTcyY/gpIvh/ITdB0MoMg1/BaXYxkkOx5Dxbn8+im3Tjcf9ICbVfJUczER+O+VnGYLT8aDYGwI4smYSrRR4ShAlTyJXhMhIO1EqWHwfDOdQPK/twS1uYDDjdNX11dvpP5Xc8s28E2gA+A627ajEdgg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eF5AclYM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eF5AclYM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AE80C4AF0D;
	Mon, 12 Aug 2024 16:17:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723479428;
	bh=l7vbSMAAW1RSjL3G33qTP2vnbbe0mnCtcKz9BEWeldY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eF5AclYM0D20EbOr6R3pUlr4Xe0sBJjvDdABFZhO23dn5129/BdA0aoR9Ai4L32oz
	 F6ylioqyw90vkSR4IF/jaGwUZRrEQonBs9fklXo0NRCaruOad/icrXEsd/y7/fbZ3y
	 zox33qU5QjdkyKXA3gmufyHT7AsGljsRXhcsJqmg=
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
Subject: [PATCH 6.6 084/189] arm64: cputype: Add Cortex-X1C definitions
Date: Mon, 12 Aug 2024 18:02:20 +0200
Message-ID: <20240812160135.377571902@linuxfoundation.org>
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

[ Upstream commit 58d245e03c324d083a0ec3b9ab8ebd46ec9848d7 ]

Add cputype definitions for Cortex-X1C. These will be used for errata
detection in subsequent patches.

These values can be found in the Cortex-X1C TRM:

  https://developer.arm.com/documentation/101968/0002/

... in section B2.107 ("MIDR_EL1, Main ID Register, EL1").

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: James Morse <james.morse@arm.com>
Cc: Will Deacon <will@kernel.org>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Link: https://lore.kernel.org/r/20240801101803.1982459-2-mark.rutland@arm.com
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
[ Mark: trivial backport ]
Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/include/asm/cputype.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/include/asm/cputype.h b/arch/arm64/include/asm/cputype.h
index 1cb0704c6163f..5dc68ace305e5 100644
--- a/arch/arm64/include/asm/cputype.h
+++ b/arch/arm64/include/asm/cputype.h
@@ -86,6 +86,7 @@
 #define ARM_CPU_PART_CORTEX_X2		0xD48
 #define ARM_CPU_PART_NEOVERSE_N2	0xD49
 #define ARM_CPU_PART_CORTEX_A78C	0xD4B
+#define ARM_CPU_PART_CORTEX_X1C		0xD4C
 #define ARM_CPU_PART_CORTEX_X3		0xD4E
 #define ARM_CPU_PART_NEOVERSE_V2	0xD4F
 #define ARM_CPU_PART_CORTEX_A720	0xD81
@@ -165,6 +166,7 @@
 #define MIDR_CORTEX_X2 MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_X2)
 #define MIDR_NEOVERSE_N2 MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_NEOVERSE_N2)
 #define MIDR_CORTEX_A78C	MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_A78C)
+#define MIDR_CORTEX_X1C	MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_X1C)
 #define MIDR_CORTEX_X3 MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_X3)
 #define MIDR_NEOVERSE_V2 MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_NEOVERSE_V2)
 #define MIDR_CORTEX_A720 MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_A720)
-- 
2.43.0



