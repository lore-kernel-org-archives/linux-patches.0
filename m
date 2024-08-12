Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52B7A187844;
	Mon, 12 Aug 2024 16:09:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723478967; cv=none; b=am5GWFdQvDxStvEODvOW+lO2h9nKM8mn//XMcy9/6lW2Yiy3tZV+u3h4B8JUIYemy1jaHCPQ3cIh+MWPNypk811E2oVKaM1WHufohNgy7I4ZIWw62RP9Y6Gp6vvkqtpxU5VgE5FLIN16aEypKz8m0CukmiIlVy4ENYPYZ2XTem8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723478967; c=relaxed/simple;
	bh=A/wKnGHsHLieuKq+XWGVGNvJrInxPRNmWEAihktgCCA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n09foqzmvBImdxhKmtmYzI57KsBxYf6sRwAI/tdbYuNH514MOWY6F5qQ90DHue5Ek3hnt7lH1gkGsdLIwnABQ3aPyw7LYiHJ23hyHjSIEmGRYpcrZEVJWvsw+xkmgBP01PLSWjkbHIzgmkrwTuOLEv+8BXCvzTmXRQIr0L1JA/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gS1/bDAs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gS1/bDAs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81DA3C32782;
	Mon, 12 Aug 2024 16:09:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723478966;
	bh=A/wKnGHsHLieuKq+XWGVGNvJrInxPRNmWEAihktgCCA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gS1/bDAsgTeX9309DPCSwlWKL5C2OLwldrr3bbOXC1NQdlEuLwcxpgXlAk5CiTxPq
	 JX7Cm/jSFk7Xi+ysuYE96s0q4XKsTb0jCdVISwPlnCtlcTnhQXiIqOhdEZd5saTEk8
	 jmDK6yMn9KOx9SqPMj3kV8WsiF071aHnVaA0+Y+Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Rutland <mark.rutland@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	James Morse <james.morse@arm.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 060/150] arm64: cputype: Add Cortex-X4 definitions
Date: Mon, 12 Aug 2024 18:02:21 +0200
Message-ID: <20240812160127.490418900@linuxfoundation.org>
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

[ Upstream commit 02a0a04676fa7796d9cbc9eb5ca120aaa194d2dd ]

Add cputype definitions for Cortex-X4. These will be used for errata
detection in subsequent patches.

These values can be found in Table B-249 ("MIDR_EL1 bit descriptions")
in issue 0002-05 of the Cortex-X4 TRM, which can be found at:

  https://developer.arm.com/documentation/102484/0002/?lang=en

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: James Morse <james.morse@arm.com>
Cc: Will Deacon <will@kernel.org>
Link: https://lore.kernel.org/r/20240508081400.235362-3-mark.rutland@arm.com
Signed-off-by: Will Deacon <will@kernel.org>
[ Mark: fix conflict (dealt with upstream via a later merge) ]
Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/include/asm/cputype.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/include/asm/cputype.h b/arch/arm64/include/asm/cputype.h
index 29fe8b5c938a4..f1fc64900f4e4 100644
--- a/arch/arm64/include/asm/cputype.h
+++ b/arch/arm64/include/asm/cputype.h
@@ -86,6 +86,7 @@
 #define ARM_CPU_PART_NEOVERSE_N2	0xD49
 #define ARM_CPU_PART_CORTEX_A78C	0xD4B
 #define ARM_CPU_PART_NEOVERSE_V2	0xD4F
+#define ARM_CPU_PART_CORTEX_X4		0xD82
 
 #define APM_CPU_PART_XGENE		0x000
 #define APM_CPU_VAR_POTENZA		0x00
@@ -153,6 +154,7 @@
 #define MIDR_NEOVERSE_N2 MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_NEOVERSE_N2)
 #define MIDR_CORTEX_A78C	MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_A78C)
 #define MIDR_NEOVERSE_V2 MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_NEOVERSE_V2)
+#define MIDR_CORTEX_X4 MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_X4)
 #define MIDR_THUNDERX	MIDR_CPU_MODEL(ARM_CPU_IMP_CAVIUM, CAVIUM_CPU_PART_THUNDERX)
 #define MIDR_THUNDERX_81XX MIDR_CPU_MODEL(ARM_CPU_IMP_CAVIUM, CAVIUM_CPU_PART_THUNDERX_81XX)
 #define MIDR_THUNDERX_83XX MIDR_CPU_MODEL(ARM_CPU_IMP_CAVIUM, CAVIUM_CPU_PART_THUNDERX_83XX)
-- 
2.43.0



