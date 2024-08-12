Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0869D183CD3;
	Mon, 12 Aug 2024 16:30:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723480235; cv=none; b=SS/4GBnTDsSTP0DUfa61YQw4jQ0nkA/dtByVbW2wfAvATsm2j0DRuiyKXuN3OX1xeQ3TwYBk+fAwkRf2vHTjTLuDg5ZwBWczr1/5VKjaa+mZ5EQmF2KCWq3rO8d40OQr7XLDsEJSt8J5Q1tGyjfyYfbGJJbb9bo/boPMml3/JVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723480235; c=relaxed/simple;
	bh=YdWkBOfaa+Px1hRvFs37l5oRcG2O0+yi0oAIIxef9tg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hfI0cx97faoee05XbKrEcQSp4theFDEskcl8AEyP4QoYxjX5HLDayRQ23fO/QHRsUav6t1lJu9XQAoPTdRX5Io7RunBv8dg6rp1029m3ImByl5QD40u2oN2mW09NAHFq+e+WPQAvsFeg9twVKrwHpL+HV6VUhJE1E+lBwXN7vtY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YvWlf+Z2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YvWlf+Z2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 828FDC32782;
	Mon, 12 Aug 2024 16:30:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723480234;
	bh=YdWkBOfaa+Px1hRvFs37l5oRcG2O0+yi0oAIIxef9tg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YvWlf+Z2WSgoHoeRpZArfBVx9MNXGTkZDroqUfNQhhFffiatJVu9HKEyMZv8sbVlj
	 qYMjtS1fC012XZqttrB9AFMNDyJ3WuBmheKli4psMrtLikid1lCEUoel+AYisDugk+
	 NmYvpOWqIvOxBsTv7rIOJfkbG1OazeUbLBeKoSCg=
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
Subject: [PATCH 6.10 135/263] arm64: cputype: Add Cortex-A725 definitions
Date: Mon, 12 Aug 2024 18:02:16 +0200
Message-ID: <20240812160151.716851554@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160146.517184156@linuxfoundation.org>
References: <20240812160146.517184156@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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



