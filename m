Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9047C3214;
	Thu, 15 Aug 2024 14:22:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723731728; cv=none; b=mk5V3ZWnJWbRIMANYGQ5ashLZI4qVw6cyVVf7CBvYB8j1Scv6pr7X1Ya1Drz7CZEIehpXC6wAgIE1EzXMfXTCRXnf/c+6/aTjhk+NQP5M5E6z+u4R1TunuCQiBIM9Ryx2CIpaGSEiYqLsgHpLEJKhzvBM712Fl2ZlGVDwNndMmA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723731728; c=relaxed/simple;
	bh=L1tulkwlTAOq6U3Lwtcy8y9BhT8TndwIrJmBZ6Bs5rw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DmmLfuCf+erT5jYLEHL3XN+/GzswA5CmSECcqEmEcTbGkCGl22EWqAbpTMJAF5aumbpz8IXOEGom7YW1u3zVqHZ0WW5DvCPPHEOqWCtTYhvpNe4z0HrgE4resxb04OZoRPdiKmo/2ssq3iFK/fr2NOUDnOyWaoRnqPT106jREg8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=la4gx9UW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="la4gx9UW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1253AC32786;
	Thu, 15 Aug 2024 14:22:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723731728;
	bh=L1tulkwlTAOq6U3Lwtcy8y9BhT8TndwIrJmBZ6Bs5rw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=la4gx9UWA8YlNTk9iaYnT2jKTvl17SLqncc4by9caaP6SMzPs8WuDk4a075ixK9L4
	 XOoYAh8EMBh06etz5nbj+wROEm7b1y36HKZWA7bB0ahkOJbk9jtUGvUlEoGoZiYs1c
	 QQuhMJ6QRyVE9neFVZx2WGEmR3kNK0Lzapf74p/Q=
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
Subject: [PATCH 5.4 219/259] arm64: cputype: Add Cortex-A725 definitions
Date: Thu, 15 Aug 2024 15:25:52 +0200
Message-ID: <20240815131911.226062905@linuxfoundation.org>
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
index bb8efde2c8b10..18b5267ff48e1 100644
--- a/arch/arm64/include/asm/cputype.h
+++ b/arch/arm64/include/asm/cputype.h
@@ -87,6 +87,7 @@
 #define ARM_CPU_PART_CORTEX_X4		0xD82
 #define ARM_CPU_PART_NEOVERSE_V3	0xD84
 #define ARM_CPU_PART_CORTEX_X925	0xD85
+#define ARM_CPU_PART_CORTEX_A725	0xD87
 
 #define APM_CPU_PART_POTENZA		0x000
 
@@ -135,6 +136,7 @@
 #define MIDR_CORTEX_X4 MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_X4)
 #define MIDR_NEOVERSE_V3 MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_NEOVERSE_V3)
 #define MIDR_CORTEX_X925 MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_X925)
+#define MIDR_CORTEX_A725 MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_A725)
 #define MIDR_THUNDERX	MIDR_CPU_MODEL(ARM_CPU_IMP_CAVIUM, CAVIUM_CPU_PART_THUNDERX)
 #define MIDR_THUNDERX_81XX MIDR_CPU_MODEL(ARM_CPU_IMP_CAVIUM, CAVIUM_CPU_PART_THUNDERX_81XX)
 #define MIDR_THUNDERX_83XX MIDR_CPU_MODEL(ARM_CPU_IMP_CAVIUM, CAVIUM_CPU_PART_THUNDERX_83XX)
-- 
2.43.0



