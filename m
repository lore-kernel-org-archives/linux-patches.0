Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2B521D4154;
	Tue, 15 Oct 2024 12:05:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728993939; cv=none; b=eKzlW1rWAQt+cZp0CBTai1nftVhPWLcS/+oks+huiTCS6DuKUFqPPCvSzFtbuT3Ui1mt47bu62IFwAhBR0qz3RyulsDvM1HvRpSHdI1aOGpK16paw7uX6q6/4ppN4zarP2u+r7VdzyRJn65iwGyGtfuo4ie5b/wbxovFRBXx+xQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728993939; c=relaxed/simple;
	bh=yJwBOsx2FFF5UUXvkJc0NErh+4E988PPOj2Fqwi7sDs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EwEfrlMlkOpkNxD2kz4AxRqyngmWNljhC56rjc5oo4k5aPqcXq8JYxrb4cVYNZ0zVqHuK3nLVKAF0dIH90Cmtk0r3ZfHyujqyo0CHtlKQyrdPtjFobhB+9nXSl9c7y/XsUMltYye2Zd1dVUhVbMSmSD65bW8AF4JN/QnVsqBd9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CluNCIld; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CluNCIld"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48ADCC4CECE;
	Tue, 15 Oct 2024 12:05:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728993939;
	bh=yJwBOsx2FFF5UUXvkJc0NErh+4E988PPOj2Fqwi7sDs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CluNCIldZhji3lGI/SK2Kb18QD1TEU+GPvQktLsoeBqqPc76U/iVjDgcK4JNfaVP5
	 toCkHhmG2fivPddpKoJUCOmwI48lQQEg2ENs84YI3QvW/nnWSJEdInuURZ11z03XVT
	 3KHjDKWXFgnzM+eTDos70WLjBSJhFinVjf2WBP8Q=
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
Subject: [PATCH 5.15 560/691] arm64: Add Cortex-715 CPU part definition
Date: Tue, 15 Oct 2024 13:28:28 +0200
Message-ID: <20241015112502.572209234@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 59f135b280a8a..75cbd3880b5c7 100644
--- a/arch/arm64/include/asm/cputype.h
+++ b/arch/arm64/include/asm/cputype.h
@@ -82,6 +82,7 @@
 #define ARM_CPU_PART_CORTEX_A510	0xD46
 #define ARM_CPU_PART_CORTEX_A520	0xD80
 #define ARM_CPU_PART_CORTEX_A710	0xD47
+#define ARM_CPU_PART_CORTEX_A715	0xD4D
 #define ARM_CPU_PART_CORTEX_X2		0xD48
 #define ARM_CPU_PART_NEOVERSE_N2	0xD49
 #define ARM_CPU_PART_CORTEX_A78C	0xD4B
@@ -144,6 +145,7 @@
 #define MIDR_CORTEX_A510 MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_A510)
 #define MIDR_CORTEX_A520 MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_A520)
 #define MIDR_CORTEX_A710 MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_A710)
+#define MIDR_CORTEX_A715 MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_A715)
 #define MIDR_CORTEX_X2 MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_X2)
 #define MIDR_NEOVERSE_N2 MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_NEOVERSE_N2)
 #define MIDR_CORTEX_A78C	MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_A78C)
-- 
2.43.0



