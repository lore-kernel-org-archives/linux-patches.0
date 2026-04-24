Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEC8D3537DF;
	Fri, 24 Apr 2026 13:41:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777038073; cv=none; b=RaF+qmzw2MzWTdTmmyNtJ3/ea43w/rES+dtCp/eg5cBA8Ji2A5oxdy+//I58rXjiG06p1iPEb8LJDr5A3TU+WlL0js6A+6ITNtcVYEqol1PmDIl71WZBsh8URt5jVcwwTAhe4V9FH9Jo8Axy20nUxnHrwl2ZDaz+gLZccXDCh98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777038073; c=relaxed/simple;
	bh=+e+rCfvTskKmhyik1+FdSc7sIK8jAklnHLxBH30/jmc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MJjjEtRqAI7ggmkcmzLojX8k3Lz/YwfuNvBER/jnoesuANe2uPRdoki+G+MGsZI/2qv7lTT2TvRBh4SM7V0N2pzmdCx7VFA0VB/pQYKwSNs5pzG0wwy2MmYcB/uJpaPft67lgbqznT8vCH8yZtMm0E2nGugdowAOp+prbJN1ZPc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BwFLUtGR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BwFLUtGR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63563C19425;
	Fri, 24 Apr 2026 13:41:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777038073;
	bh=+e+rCfvTskKmhyik1+FdSc7sIK8jAklnHLxBH30/jmc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BwFLUtGRMcxPOP0a1PU6PpGtX+YllER5oylvrcEzN0yOU8G4S1aX1smOHgU4/gsP6
	 pZ390W+bcrV1+icgjQrxKplI9bn6zDi2orQ7joaerE5qY8de6PYRZvxHS1G8N93yKr
	 Np+Nf56BA8LtrLI3qHNdmT5tMt5ZB7i14AKHlfEQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Rutland <mark.rutland@arm.com>,
	Will Deacon <will@kernel.org>,
	James Morse <james.morse@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH 6.18 14/55] arm64: cputype: Add C1-Pro definitions
Date: Fri, 24 Apr 2026 15:30:53 +0200
Message-ID: <20260424132433.120125660@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260424132430.006424517@linuxfoundation.org>
References: <20260424132430.006424517@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Catalin Marinas <catalin.marinas@arm.com>

commit 2c99561016c591f4c3d5ad7d22a61b8726e79735 upstream.

Add cputype definitions for C1-Pro. These will be used for errata
detection in subsequent patches.

These values can be found in "Table A-303: MIDR_EL1 bit descriptions" in
issue 07 of the C1-Pro TRM:

  https://documentation-service.arm.com/static/6930126730f8f55a656570af

Acked-by: Mark Rutland <mark.rutland@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: James Morse <james.morse@arm.com>
Reviewed-by: Will Deacon <will@kernel.org>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/include/asm/cputype.h |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/arm64/include/asm/cputype.h
+++ b/arch/arm64/include/asm/cputype.h
@@ -98,6 +98,7 @@
 #define ARM_CPU_PART_CORTEX_A725	0xD87
 #define ARM_CPU_PART_CORTEX_A720AE	0xD89
 #define ARM_CPU_PART_NEOVERSE_N3	0xD8E
+#define ARM_CPU_PART_C1_PRO		0xD8B
 
 #define APM_CPU_PART_XGENE		0x000
 #define APM_CPU_VAR_POTENZA		0x00
@@ -189,6 +190,7 @@
 #define MIDR_CORTEX_A725 MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_A725)
 #define MIDR_CORTEX_A720AE MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_A720AE)
 #define MIDR_NEOVERSE_N3 MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_NEOVERSE_N3)
+#define MIDR_C1_PRO MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_C1_PRO)
 #define MIDR_THUNDERX	MIDR_CPU_MODEL(ARM_CPU_IMP_CAVIUM, CAVIUM_CPU_PART_THUNDERX)
 #define MIDR_THUNDERX_81XX MIDR_CPU_MODEL(ARM_CPU_IMP_CAVIUM, CAVIUM_CPU_PART_THUNDERX_81XX)
 #define MIDR_THUNDERX_83XX MIDR_CPU_MODEL(ARM_CPU_IMP_CAVIUM, CAVIUM_CPU_PART_THUNDERX_83XX)


