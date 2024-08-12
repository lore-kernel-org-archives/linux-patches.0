Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E0EC4B5AE;
	Mon, 12 Aug 2024 16:16:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723479416; cv=none; b=qARWb3fLlcnVTtedq6EjiXJO3Zeto0kvVx3ZNvtBWxHhDnafbbPYWrK/0pz29igNkht3f9BccMqfvxlmJ6Fu1ufBTCazX/dAJx8N105sACcBpR8EU+1JxgLDOrmjNWYpRNalVINJdzhHWKX96BmiGHLkjIbybHdNjb4uVYay4y0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723479416; c=relaxed/simple;
	bh=wQqe5RuLhKTy216LXxPu5aNpeJgzL7oTod59FupmdUU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cuLmPHl54TH7I5jWVH2lSKdHknTHWXXz7ECwcP7jsLaswbkiN2tF4O6pbTF3Zg/LV+UI18SPvzmV5PPlV1j90VTFnjGkYnZ/DZ7cefwf9iUE7haslePTgJ105+ZuFn3pE23dDYxh7i7DiSLkHuo4C4FdJu/xo5t1LMHZpE4Wsmo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AVhmeH7x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AVhmeH7x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BD51C32782;
	Mon, 12 Aug 2024 16:16:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723479416;
	bh=wQqe5RuLhKTy216LXxPu5aNpeJgzL7oTod59FupmdUU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AVhmeH7xmd4vUspaolZGfIyI/qFXQl/9fVQsoysTc7+x4/qs/Nb8Ym87ugT28gYOG
	 dnoXadFxRiJ8pSwwH0d3/5qgE5nhLKAm5HYFPeQqy4job4vvN92/pqkMQBEFEZrYRo
	 Lo1nf/NyCrMWvSTP9QIc9Jf6zgeABj/Ep9NrHldM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Rutland <mark.rutland@arm.com>,
	James Morse <james.morse@arm.com>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 080/189] arm64: cputype: Add Cortex-A720 definitions
Date: Mon, 12 Aug 2024 18:02:16 +0200
Message-ID: <20240812160135.221825719@linuxfoundation.org>
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
index 72fe207403c83..dcbac1ce6c25c 100644
--- a/arch/arm64/include/asm/cputype.h
+++ b/arch/arm64/include/asm/cputype.h
@@ -88,6 +88,7 @@
 #define ARM_CPU_PART_CORTEX_A78C	0xD4B
 #define ARM_CPU_PART_CORTEX_X3		0xD4E
 #define ARM_CPU_PART_NEOVERSE_V2	0xD4F
+#define ARM_CPU_PART_CORTEX_A720	0xD81
 #define ARM_CPU_PART_CORTEX_X4		0xD82
 #define ARM_CPU_PART_NEOVERSE_V3	0xD84
 
@@ -165,6 +166,7 @@
 #define MIDR_CORTEX_A78C	MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_A78C)
 #define MIDR_CORTEX_X3 MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_X3)
 #define MIDR_NEOVERSE_V2 MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_NEOVERSE_V2)
+#define MIDR_CORTEX_A720 MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_A720)
 #define MIDR_CORTEX_X4 MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_X4)
 #define MIDR_NEOVERSE_V3 MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_NEOVERSE_V3)
 #define MIDR_THUNDERX	MIDR_CPU_MODEL(ARM_CPU_IMP_CAVIUM, CAVIUM_CPU_PART_THUNDERX)
-- 
2.43.0



