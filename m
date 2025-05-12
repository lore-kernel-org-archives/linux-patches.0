Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC7451A08CA;
	Mon, 12 May 2025 17:51:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747072266; cv=none; b=W5QSZ10fwHbgoaZ2GaHVldLDydIvEclUw+sQWfaBZUWcxkbHvmiJRIBYR56TmkOODQab35h+mMyK0TPvGvanrHwKJ9ntGp5Xy98wDjKVL9n5rdym3oDJEpFwj0U7VLo4RHkgR5OEct9LXBkTU1IcDvHzLnvjXa2p2HtUjgRH1Ag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747072266; c=relaxed/simple;
	bh=8llxTid1F+l/05qhifo+jlCW2DffyMYw52Dz+S5brLs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TmX5Sl8vs50pDIvDfCN3UoINfwfbDCdVN9/evwF4lxbNCX+bEhyGvKMHQeEWQDA8R38KaTERkwEYrr7VfBtGrGIosb2IanhAcq/qRFSLuuaUi/iTkjQqpjEMvGKr4rDNARa9aTxmGPcBJFzhVKBCuNQdSkeylxo8M5JurfpNtUI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x8VkROSo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x8VkROSo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31DA4C4CEE7;
	Mon, 12 May 2025 17:51:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747072266;
	bh=8llxTid1F+l/05qhifo+jlCW2DffyMYw52Dz+S5brLs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x8VkROSo9Mzqf/VM3GDXPF7tnFFIovFn119em8GqthWnU/7JklH4tY0RzzrzlDHT0
	 nHQs3eYCRnPhQTtGXB2QlnOW45AOimD9IDVa9nwuDr8XjbxQ168BAdPcLDeCi1ZHo4
	 +k+N4ExO7zntkiFMUeZmFnGHZ7RmcNQlEsx3b6ak=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	James Morse <james.morse@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH 6.14 183/197] arm64: proton-pack: Add new CPUs k values for branch mitigation
Date: Mon, 12 May 2025 19:40:33 +0200
Message-ID: <20250512172051.838422552@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172044.326436266@linuxfoundation.org>
References: <20250512172044.326436266@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
@@ -167,6 +168,7 @@
 #define MIDR_CORTEX_A78AE	MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_A78AE)
 #define MIDR_CORTEX_X1	MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_X1)
 #define MIDR_CORTEX_A510 MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_A510)
+#define MIDR_CORTEX_X1C MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_X1C)
 #define MIDR_CORTEX_A520 MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_A520)
 #define MIDR_CORTEX_A710 MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_A710)
 #define MIDR_CORTEX_A715 MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_A715)
--- a/arch/arm64/kernel/proton-pack.c
+++ b/arch/arm64/kernel/proton-pack.c
@@ -891,6 +891,7 @@ static u8 spectre_bhb_loop_affected(void
 		MIDR_ALL_VERSIONS(MIDR_CORTEX_A78AE),
 		MIDR_ALL_VERSIONS(MIDR_CORTEX_A78C),
 		MIDR_ALL_VERSIONS(MIDR_CORTEX_X1),
+		MIDR_ALL_VERSIONS(MIDR_CORTEX_X1C),
 		MIDR_ALL_VERSIONS(MIDR_CORTEX_A710),
 		MIDR_ALL_VERSIONS(MIDR_CORTEX_X2),
 		MIDR_ALL_VERSIONS(MIDR_NEOVERSE_N2),


