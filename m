Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF09C1E22E6;
	Mon, 23 Jun 2025 22:07:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750716454; cv=none; b=RgeWLgK7Lh6tQ4WM7jWBYBwmNPmKijapZz+Z8XRkCRn+PlkMjl+7d2vkuwdxkmaI1ymdXTtFO8u1v8+1SoWEDBKmkDOzR4GttVkos+5r8vQMhw1y7iIccvj++f8heb297C5Kc/9xFXDo85zC41NgaGd6fVe1acWyM67y63xzpJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750716454; c=relaxed/simple;
	bh=7/q6oyqkLHANi/r9cbqyNhOLO5nJkFmBRVrXjkGNjs8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lfURcdpzpgoAj0Ca6RWoVFOBHOvGf7LonScF9XJBqOm6ievmWbKwHlA5rRvhzhaIhYOlnyBuv6mLw1KvZVRym5fSdQzUV2P9+D9Gpv6UFbqN03BgYdsdzeu0PtGZhnsrzqGMBZo2+NCfdhLJvcylFv19cglKusJP7YAAj4VFN3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2H3lsTI7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2H3lsTI7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83D14C4CEEA;
	Mon, 23 Jun 2025 22:07:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750716453;
	bh=7/q6oyqkLHANi/r9cbqyNhOLO5nJkFmBRVrXjkGNjs8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2H3lsTI7/O2QhYyXk558o5M6oUFxEJzeO/OGLFWy++2EkMHJfOWPeWkRHqiVu3/xo
	 eAMMsKL7+BsUCFJXDCgfHf1wx98WNyuPb/7iBMyPo/nFl1UMVeJbIa2nKxmFbBhfGo
	 SyzvfMaNDlilbBpfhS3DkP+/r55Jpl3ACDsceil4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	James Morse <james.morse@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Pu Lehui <pulehui@huawei.com>
Subject: [PATCH 5.10 335/355] arm64: proton-pack: Add new CPUs k values for branch mitigation
Date: Mon, 23 Jun 2025 15:08:56 +0200
Message-ID: <20250623130636.808301449@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.716971725@linuxfoundation.org>
References: <20250623130626.716971725@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: James Morse <james.morse@arm.com>

[ Upstream commit efe676a1a7554219eae0b0dcfe1e0cdcc9ef9aef ]

Update the list of 'k' values for the branch mitigation from arm's
website.

Add the values for Cortex-X1C. The MIDR_EL1 value can be found here:
https://developer.arm.com/documentation/101968/0002/Register-descriptions/AArch>

Link: https://developer.arm.com/documentation/110280/2-0/?lang=en
Signed-off-by: James Morse <james.morse@arm.com>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Pu Lehui <pulehui@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/include/asm/cputype.h |    2 ++
 arch/arm64/kernel/proton-pack.c  |    1 +
 2 files changed, 3 insertions(+)

--- a/arch/arm64/include/asm/cputype.h
+++ b/arch/arm64/include/asm/cputype.h
@@ -80,6 +80,7 @@
 #define ARM_CPU_PART_CORTEX_A78AE	0xD42
 #define ARM_CPU_PART_CORTEX_X1		0xD44
 #define ARM_CPU_PART_CORTEX_A510	0xD46
+#define ARM_CPU_PART_CORTEX_X1C		0xD4C
 #define ARM_CPU_PART_CORTEX_A520	0xD80
 #define ARM_CPU_PART_CORTEX_A710	0xD47
 #define ARM_CPU_PART_CORTEX_A715	0xD4D
@@ -144,6 +145,7 @@
 #define MIDR_CORTEX_A78AE	MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_A78AE)
 #define MIDR_CORTEX_X1	MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_X1)
 #define MIDR_CORTEX_A510 MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_A510)
+#define MIDR_CORTEX_X1C MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_X1C)
 #define MIDR_CORTEX_A520 MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_A520)
 #define MIDR_CORTEX_A710 MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_A710)
 #define MIDR_CORTEX_A715 MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_A715)
--- a/arch/arm64/kernel/proton-pack.c
+++ b/arch/arm64/kernel/proton-pack.c
@@ -899,6 +899,7 @@ static u8 spectre_bhb_loop_affected(void
 		MIDR_ALL_VERSIONS(MIDR_CORTEX_A78AE),
 		MIDR_ALL_VERSIONS(MIDR_CORTEX_A78C),
 		MIDR_ALL_VERSIONS(MIDR_CORTEX_X1),
+		MIDR_ALL_VERSIONS(MIDR_CORTEX_X1C),
 		MIDR_ALL_VERSIONS(MIDR_CORTEX_A710),
 		MIDR_ALL_VERSIONS(MIDR_CORTEX_X2),
 		MIDR_ALL_VERSIONS(MIDR_NEOVERSE_N2),


