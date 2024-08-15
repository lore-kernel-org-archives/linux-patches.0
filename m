Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3089D63D5;
	Thu, 15 Aug 2024 14:41:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723732896; cv=none; b=LyCLgEgaXVoPsiDGYmZcHpWDPUZJ8bn6skA8iNEbNt7KJjbJwx7Ww/ku7JIK21bIXYkYFsgDC2h8K0Z82j3qvRS7AQ5OO8jq1OAkY7T9AGc1KvafgJyHOHWDqg56EWLWPX7eUz+AxRRP2RLWI8jENYBThmrr8RrH1VtJ2cQoG+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723732896; c=relaxed/simple;
	bh=Tcfcwv3kS7nAA7VxdwEzxOi4Eje5w8fqrXqJDujILwo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qCeiFBGWLueVQzrTORRDYwf4+naCIle+yYhxda5oBOQy9yB4vCqlbeAwJG8BEWovW5eJrFu3hqCAKcr+bqw61TTaS9G5JlSZWKROF4CD5Zmgl5pt6qGZjPIvgGEIHnVnIAQsg0bl7Ha+/VlHkT6SvCFpA2Pp/ncrk7mILau7kCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jkwZor/X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jkwZor/X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52A73C32786;
	Thu, 15 Aug 2024 14:41:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723732895;
	bh=Tcfcwv3kS7nAA7VxdwEzxOi4Eje5w8fqrXqJDujILwo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jkwZor/X1Mh+Py/b19Tb3hlj3PMLrrXa2uTjR7Cu6Xn6lYZqpVe8Wc+n6sDvLmT4o
	 TYq4dtz5SseE0D0gI7o3EDhZ0b9WNys3D2f0MpkJq+9N83KzLOFjmJWe6btySdTMxJ
	 qbah/5Qxdqi4LBqFnK5KIir1Dh5zwzQWo8QIhB4o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Rutland <mark.rutland@arm.com>,
	James Morse <james.morse@arm.com>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 288/352] arm64: cputype: Add Cortex-X925 definitions
Date: Thu, 15 Aug 2024 15:25:54 +0200
Message-ID: <20240815131930.580714642@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131919.196120297@linuxfoundation.org>
References: <20240815131919.196120297@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Rutland <mark.rutland@arm.com>

[ Upstream commit fd2ff5f0b320f418288e7a1f919f648fbc8a0dfc ]

Add cputype definitions for Cortex-X925. These will be used for errata
detection in subsequent patches.

These values can be found in Table A-285 ("MIDR_EL1 bit descriptions")
in issue 0001-05 of the Cortex-X925 TRM, which can be found at:

  https://developer.arm.com/documentation/102807/0001/?lang=en

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: James Morse <james.morse@arm.com>
Cc: Will Deacon <will@kernel.org>
Link: https://lore.kernel.org/r/20240603111812.1514101-4-mark.rutland@arm.com
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
[ Mark: trivial backport ]
Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/include/asm/cputype.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/include/asm/cputype.h b/arch/arm64/include/asm/cputype.h
index 4f08438344e2a..35162c15ed6c6 100644
--- a/arch/arm64/include/asm/cputype.h
+++ b/arch/arm64/include/asm/cputype.h
@@ -89,6 +89,7 @@
 #define ARM_CPU_PART_CORTEX_A720	0xD81
 #define ARM_CPU_PART_CORTEX_X4		0xD82
 #define ARM_CPU_PART_NEOVERSE_V3	0xD84
+#define ARM_CPU_PART_CORTEX_X925	0xD85
 
 #define APM_CPU_PART_POTENZA		0x000
 
@@ -146,6 +147,7 @@
 #define MIDR_CORTEX_A720 MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_A720)
 #define MIDR_CORTEX_X4 MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_X4)
 #define MIDR_NEOVERSE_V3 MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_NEOVERSE_V3)
+#define MIDR_CORTEX_X925 MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_X925)
 #define MIDR_THUNDERX	MIDR_CPU_MODEL(ARM_CPU_IMP_CAVIUM, CAVIUM_CPU_PART_THUNDERX)
 #define MIDR_THUNDERX_81XX MIDR_CPU_MODEL(ARM_CPU_IMP_CAVIUM, CAVIUM_CPU_PART_THUNDERX_81XX)
 #define MIDR_THUNDERX_83XX MIDR_CPU_MODEL(ARM_CPU_IMP_CAVIUM, CAVIUM_CPU_PART_THUNDERX_83XX)
-- 
2.43.0



