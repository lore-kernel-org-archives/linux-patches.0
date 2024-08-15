Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7B3B1B3F2A;
	Thu, 15 Aug 2024 14:02:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723730530; cv=none; b=mELF9RZ735dapM7z5GfGVwM1UuOp5YsuNWV+K0NJn8fZZ6lCYh411kUIiv/IH2V1yddAFElyxTAwShFzXOaU0S9L8iUNx6/eW/Bc0qNGVk67o8Cxdrj7WToyArEcJbOuj+0p3axtQNtZYkoVIilwBkqzHm9CM/hAEMO3NhiwHWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723730530; c=relaxed/simple;
	bh=ZTlKmO227NyARBAzhCv1tO359NOfvtyeUKOvOdVjMuc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sqxTXsBrQB2ynQeJud1kgdN+044bRXjn+UC1FfX///J5BO2tziu83FaolILP7WBgB9b6AtCUlm/X/LtpqGiVeG6c3yOuJzQzDbx9flh4JWLGIaXzRZ4U+Y/XV0lB69XzzUNyKz5jbF/XrHCk+hEQTCqU5FAisMNuHnTDQJkU+Zs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=do3bq2qI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="do3bq2qI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E3B4C4AF0D;
	Thu, 15 Aug 2024 14:02:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723730530;
	bh=ZTlKmO227NyARBAzhCv1tO359NOfvtyeUKOvOdVjMuc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=do3bq2qISx+e6jmG6Hs9nzs93bY3mpekzjP14xfVdSaa4Wm0rj6haDJoDwvo/MzHD
	 9w63v8olQgUAe2KERQY44Z9l/3+f3gxs+HF0SITi123w7pwAIwZ6TLZ+rIbzhO+mHO
	 PUTcKmthHz16ZP6oG9U/KrXfSJCIaTMKejXngT3M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Rutland <mark.rutland@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	James Morse <james.morse@arm.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 396/484] arm64: cputype: Add Neoverse-V3 definitions
Date: Thu, 15 Aug 2024 15:24:14 +0200
Message-ID: <20240815131956.745228877@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
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
index d222cd4983944..17fb978191d68 100644
--- a/arch/arm64/include/asm/cputype.h
+++ b/arch/arm64/include/asm/cputype.h
@@ -87,6 +87,7 @@
 #define ARM_CPU_PART_CORTEX_A78C	0xD4B
 #define ARM_CPU_PART_NEOVERSE_V2	0xD4F
 #define ARM_CPU_PART_CORTEX_X4		0xD82
+#define ARM_CPU_PART_NEOVERSE_V3	0xD84
 
 #define APM_CPU_PART_POTENZA		0x000
 
@@ -143,6 +144,7 @@
 #define MIDR_CORTEX_A78C	MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_A78C)
 #define MIDR_NEOVERSE_V2 MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_NEOVERSE_V2)
 #define MIDR_CORTEX_X4 MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_X4)
+#define MIDR_NEOVERSE_V3 MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_NEOVERSE_V3)
 #define MIDR_THUNDERX	MIDR_CPU_MODEL(ARM_CPU_IMP_CAVIUM, CAVIUM_CPU_PART_THUNDERX)
 #define MIDR_THUNDERX_81XX MIDR_CPU_MODEL(ARM_CPU_IMP_CAVIUM, CAVIUM_CPU_PART_THUNDERX_81XX)
 #define MIDR_THUNDERX_83XX MIDR_CPU_MODEL(ARM_CPU_IMP_CAVIUM, CAVIUM_CPU_PART_THUNDERX_83XX)
-- 
2.43.0



