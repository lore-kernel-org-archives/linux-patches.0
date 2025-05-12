Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACEB81E505;
	Mon, 12 May 2025 18:11:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747073503; cv=none; b=n/YlHvjj6q52YYNDRMr12CuqI49E9uFoBRZ+5orA8TZCC19Jt5z3BXpAns0ZxJwwvjy1kEEQJMImGPc/rEdHWWISYesmf3sH5LNDZl99pRD5mklohzkStyO5OYpEiyN7cCPMpy6F82W0ronp1dioBwCnoRo2eJClkVj1nygfe6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747073503; c=relaxed/simple;
	bh=d8lit27Lm4G67sSrmCvml+jeuZGbV+bs8kZOazoKf/4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bPx5gPCZd1aptJWCtubCYd9H1lxJ1gEZDgqCA9/uKXeQ1O/Q6TWHMJX0oUeRHgqtQ/RV2Rcx8HVqIVotXOhbqt0s+POezPhCqR6cZ60ERO8+NJ6e4zo4qz16AOcliiGIggvE3gEy5j9Y2UoM8+bVR1pZJDtmB9zO+AD0vzuhxmA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TLkyWWDn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TLkyWWDn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 071A1C4CEF8;
	Mon, 12 May 2025 18:11:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747073503;
	bh=d8lit27Lm4G67sSrmCvml+jeuZGbV+bs8kZOazoKf/4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TLkyWWDnBlfrVHSZz5clVQ7mtvB7TqwrxDbGYd+3JuAgAlrn7cQkxom8x0TNkLeWC
	 V/nDbqfrb8zI29iUOTnVnJe/l9zI2U6OZXgRj/dVQXgs6/fMzXoVx8VzxYe/Z8th+5
	 JDZoYvkFO0LNiUv95+0W+C5+/wlUjN29/kaqZXFY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	James Morse <james.morse@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH 6.6 097/113] arm64: proton-pack: Add new CPUs k values for branch mitigation
Date: Mon, 12 May 2025 19:46:26 +0200
Message-ID: <20250512172031.626643183@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172027.691520737@linuxfoundation.org>
References: <20250512172027.691520737@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -166,6 +167,7 @@
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


