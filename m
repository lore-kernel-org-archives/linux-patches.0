Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 230E531B127;
	Mon, 27 Oct 2025 19:07:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761592021; cv=none; b=lvOnVtQIIRZEhQzy2dMcKyM2ZTSThMkkEkMtBn4r5UVqYAj5cwtVntLPJTNyApYs9WgAgsiAfHUxEYuetZf70Zasrqjr1cpiuG8mZz4nAU+gG3DOY2X0I1oD7uYbsFyBOOiAOa/OVwQNDES6058vHOTZqOM4UFYSaIBb7k7OAR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761592021; c=relaxed/simple;
	bh=J//MqgUmgsSnkMB7oiTnQwP9SOATx6sRDAycif+vMfM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rpYULF0OqOPxfPjX93/iGvJ98UCYyt3X2CT/rgQT0R+48X28NRcm4NruVNDX+e0etqN/kG6fNLi5syaWDqAIZplyxhcD4Uo/I5R6f5NrYGzouCQgKzpVrq+gXpscw8WBb6Zc2rE+Nm2vVJAxjc5SF3sfJ+2H/F+nueKC6bImWws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yq+AqYB0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yq+AqYB0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABC22C4CEF1;
	Mon, 27 Oct 2025 19:07:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761592021;
	bh=J//MqgUmgsSnkMB7oiTnQwP9SOATx6sRDAycif+vMfM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yq+AqYB0dCcMVfbxuIro+RLBxx0kAG5Nqy53pQ+k5AqecSMJzYbSzFkkfAi6iegg/
	 7oAhzcxhqDdA7LVOAH52eyRzj7GkFHs8swje2zG7Me0SvIZBl3Af298KNiiL7ZPRKx
	 UUvQ5yPm/LKH1lxcvbMQuxqqe5FmY6XeiMsQTxV8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Rutland <mark.rutland@arm.com>,
	James Morse <james.morse@arm.com>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Ryan Roberts <ryan.roberts@arm.com>
Subject: [PATCH 5.15 087/123] arm64: cputype: Add Neoverse-V3AE definitions
Date: Mon, 27 Oct 2025 19:36:07 +0100
Message-ID: <20251027183448.718776112@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183446.381986645@linuxfoundation.org>
References: <20251027183446.381986645@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Rutland <mark.rutland@arm.com>

commit 3bbf004c4808e2c3241e5c1ad6cc102f38a03c39 upstream.

Add cputype definitions for Neoverse-V3AE. These will be used for errata
detection in subsequent patches.

These values can be found in the Neoverse-V3AE TRM:

  https://developer.arm.com/documentation/SDEN-2615521/9-0/

... in section A.6.1 ("MIDR_EL1, Main ID Register").

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: James Morse <james.morse@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Will Deacon <will@kernel.org>
[ Ryan: Trivial backport ]
Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/include/asm/cputype.h |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/arm64/include/asm/cputype.h
+++ b/arch/arm64/include/asm/cputype.h
@@ -93,6 +93,7 @@
 #define ARM_CPU_PART_NEOVERSE_V2	0xD4F
 #define ARM_CPU_PART_CORTEX_A720	0xD81
 #define ARM_CPU_PART_CORTEX_X4		0xD82
+#define ARM_CPU_PART_NEOVERSE_V3AE	0xD83
 #define ARM_CPU_PART_NEOVERSE_V3	0xD84
 #define ARM_CPU_PART_CORTEX_X925	0xD85
 #define ARM_CPU_PART_CORTEX_A725	0xD87
@@ -160,6 +161,7 @@
 #define MIDR_NEOVERSE_V2 MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_NEOVERSE_V2)
 #define MIDR_CORTEX_A720 MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_A720)
 #define MIDR_CORTEX_X4 MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_X4)
+#define MIDR_NEOVERSE_V3AE	MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_NEOVERSE_V3AE)
 #define MIDR_NEOVERSE_V3 MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_NEOVERSE_V3)
 #define MIDR_CORTEX_X925 MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_X925)
 #define MIDR_CORTEX_A725 MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_A725)


