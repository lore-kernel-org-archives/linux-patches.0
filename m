Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DC342528E6;
	Mon, 12 May 2025 17:55:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747072557; cv=none; b=cAyzp8R4Bl1PRo113BZskSVeNuWRx5zvVlI7cLjWRko32O4krZQOTbdDlnrhRQnR+Eymi/I8V+825WRIoSGW6dLTSqheG8QmQd0B3JnYP0zEKthmCPT09ZOcHxue7BiRkqbMENXc6TSt/A4Tn3LcHO3urU2NeiL6dy/HWnA6mIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747072557; c=relaxed/simple;
	bh=LOnogl68c8XOryeIYp1W/gMcMOBxq43Nq6I2rBw/DdE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cxoo5H6fDEhaQVt0e+j9xKacBEA85w40rJooslBip+8cX3j/T0tLi7YgwE5o1hCpuYFO0Mfzcblv4mC3n53M+giBF6AWiO6kz9yaYd8hnoQ0/rLmCrF/eDIOqQFbrvji/yOutmOdH2H8F/tUKzzJ398f+fHr6Q+n7Y8M2xq+ze8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wrhE4UGQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wrhE4UGQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CE07C4CEE7;
	Mon, 12 May 2025 17:55:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747072557;
	bh=LOnogl68c8XOryeIYp1W/gMcMOBxq43Nq6I2rBw/DdE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wrhE4UGQj5xLsulXNvF0JL79bBBbFWoXZhjrWjmSFVevIpu/m6Ye6k6nYGuYcFPlz
	 eqt3pUsZJ0E5Er/btq+8dYfofWg+E1LNN1Uu4Es5+zmdBKW/S/ZoWnEQ4MYhqkCmF4
	 9rIr+UZfFIl/Qti/KgnNODXKNhiOlvdrpk9Zm4lM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	James Morse <james.morse@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH 6.1 77/92] arm64: proton-pack: Add new CPUs k values for branch mitigation
Date: Mon, 12 May 2025 19:45:52 +0200
Message-ID: <20250512172026.261416394@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172023.126467649@linuxfoundation.org>
References: <20250512172023.126467649@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: James Morse <james.morse@arm.com>

commit efe676a1a7554219eae0b0dcfe1e0cdcc9ef9aef upstream.

Update the list of 'k' values for the branch mitigation from arm's
website.

Add the values for Cortex-X1C. The MIDR_EL1 value can be found here:
https://developer.arm.com/documentation/101968/0002/Register-descriptions/AArch>

Link: https://developer.arm.com/documentation/110280/2-0/?lang=en
Signed-off-by: James Morse <james.morse@arm.com>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/include/asm/cputype.h |    2 ++
 arch/arm64/kernel/proton-pack.c  |    1 +
 2 files changed, 3 insertions(+)

--- a/arch/arm64/include/asm/cputype.h
+++ b/arch/arm64/include/asm/cputype.h
@@ -81,6 +81,7 @@
 #define ARM_CPU_PART_CORTEX_A78AE	0xD42
 #define ARM_CPU_PART_CORTEX_X1		0xD44
 #define ARM_CPU_PART_CORTEX_A510	0xD46
+#define ARM_CPU_PART_CORTEX_X1C		0xD4C
 #define ARM_CPU_PART_CORTEX_A520	0xD80
 #define ARM_CPU_PART_CORTEX_A710	0xD47
 #define ARM_CPU_PART_CORTEX_A715	0xD4D
@@ -159,6 +160,7 @@
 #define MIDR_CORTEX_A78AE	MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_A78AE)
 #define MIDR_CORTEX_X1	MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_X1)
 #define MIDR_CORTEX_A510 MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_A510)
+#define MIDR_CORTEX_X1C MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_X1C)
 #define MIDR_CORTEX_A520 MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_A520)
 #define MIDR_CORTEX_A710 MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_A710)
 #define MIDR_CORTEX_A715 MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_A715)
--- a/arch/arm64/kernel/proton-pack.c
+++ b/arch/arm64/kernel/proton-pack.c
@@ -903,6 +903,7 @@ static u8 spectre_bhb_loop_affected(void
 		MIDR_ALL_VERSIONS(MIDR_CORTEX_A78AE),
 		MIDR_ALL_VERSIONS(MIDR_CORTEX_A78C),
 		MIDR_ALL_VERSIONS(MIDR_CORTEX_X1),
+		MIDR_ALL_VERSIONS(MIDR_CORTEX_X1C),
 		MIDR_ALL_VERSIONS(MIDR_CORTEX_A710),
 		MIDR_ALL_VERSIONS(MIDR_CORTEX_X2),
 		MIDR_ALL_VERSIONS(MIDR_NEOVERSE_N2),


