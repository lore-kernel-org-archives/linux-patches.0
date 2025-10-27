Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C3F8324B24;
	Mon, 27 Oct 2025 18:49:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761590941; cv=none; b=mniO+WlERdEogYCqqo9zGti+sjEmkxtAm3j0y+jlq98/4fnwiauZA/KFLlsQIkMh+2SMjk8xtSNDQpYPcY5daKdtqN9+aEcz+ZzRmMtlcIR5aT7TRYHAWBYkniwT1aqVN0BQT9KwmD9rKsd4b0arbnEiyDozoQi+KdLleb2KO2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761590941; c=relaxed/simple;
	bh=bG9a4tWe2v0mNmHSW4H+CaE4AIUCmK3mEy5s2adXmM0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M6d22oPu5mocBovmCZ9YiAQ5Nx3o4ZMX2M0T2Kc7qa3knwL2U25yG1jVYTKbmC4WxqH+UYHuBwmyvL2UqKIqxamw37UFPTfSLbllVJV9Yx8tXYWHkqVe7vZNhk8gIKGbq1xmE6aLdo0o6w3Lkp+yGJPMsjR0EK98Tp2R0ZEYGmI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tfIOy0UH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tfIOy0UH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABEA9C4CEFD;
	Mon, 27 Oct 2025 18:49:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761590941;
	bh=bG9a4tWe2v0mNmHSW4H+CaE4AIUCmK3mEy5s2adXmM0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tfIOy0UHl8PjIoR92YUY2B+WE+JEuluyRob709tojgQlKLBDkyea7DqTLOqG2d7WT
	 D4fJPBo4Jb2dzwsKu8ThddKX+IyXLlpZjIkpB9z2Rz1bSOTnQO6K7CuebGXchub5Vq
	 O8NLb3vUmRCavKzMs5a5N4kNOKz6xfaKh6EYppUk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Rutland <mark.rutland@arm.com>,
	James Morse <james.morse@arm.com>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Ryan Roberts <ryan.roberts@arm.com>
Subject: [PATCH 5.4 207/224] arm64: cputype: Add Neoverse-V3AE definitions
Date: Mon, 27 Oct 2025 19:35:53 +0100
Message-ID: <20251027183514.313070308@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183508.963233542@linuxfoundation.org>
References: <20251027183508.963233542@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -87,6 +87,7 @@
 #define ARM_CPU_PART_NEOVERSE_V2	0xD4F
 #define ARM_CPU_PART_CORTEX_A720	0xD81
 #define ARM_CPU_PART_CORTEX_X4		0xD82
+#define ARM_CPU_PART_NEOVERSE_V3AE	0xD83
 #define ARM_CPU_PART_NEOVERSE_V3	0xD84
 #define ARM_CPU_PART_CORTEX_X925	0xD85
 #define ARM_CPU_PART_CORTEX_A725	0xD87
@@ -139,6 +140,7 @@
 #define MIDR_NEOVERSE_V2 MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_NEOVERSE_V2)
 #define MIDR_CORTEX_A720 MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_A720)
 #define MIDR_CORTEX_X4 MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_X4)
+#define MIDR_NEOVERSE_V3AE	MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_NEOVERSE_V3AE)
 #define MIDR_NEOVERSE_V3 MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_NEOVERSE_V3)
 #define MIDR_CORTEX_X925 MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_X925)
 #define MIDR_CORTEX_A725 MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_A725)


