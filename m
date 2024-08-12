Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94E3716D9B8;
	Mon, 12 Aug 2024 16:30:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723480211; cv=none; b=XwLmAQ2dSJW9k4yytpLgM7ARgUaexAnTlzMrBB+Uxrcj4qLlLKYokJ4WSL9zqfMEQp1Ih4WaYSzq4I3PdWs4h9MBRjjNUCAKs66/To9ctVTjKQzvflYoReqeE9Pyn6QGCZE8A0A7uLZCjcKqoyq3gxZUzM+3ELiKKHOqpyZSIQY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723480211; c=relaxed/simple;
	bh=X9WkelJvSOTAFS80uK8LMoQ8ix3KwAYFBe4OmB7DoOY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WlorvrEKZS4yl0jViq8t29kRoxEP2nZ35TKcD+ydI0iqy+jHWRUI+rg8prZPgbM72u65NGfoWQtj0A7ms27Dl6MBMRgIf5MZGifrhrp4GsejkXb5MM3QlYiTFxVNsvIqej9n4QgHmnRnk0vgs92zZ7uxI+LhFxD8hPOdEyMe6bs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oQncYofq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oQncYofq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02CC9C32782;
	Mon, 12 Aug 2024 16:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723480211;
	bh=X9WkelJvSOTAFS80uK8LMoQ8ix3KwAYFBe4OmB7DoOY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oQncYofqCzrMzDdF5WBcUAxgbJ2fR+IzdYmXlLK+zXjTmb/H+Ah03brmTfHOj8ZXn
	 zJufoIASrWXJ7XCvxkqmcf3sdpA52bk+5ntugkTgLqnVbhMMjLuwHy5Bi3dgN+CHsC
	 pwSekLKOjmZCdM3HbS11oVNUGvfJPmoMr/xsQo7A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Rutland <mark.rutland@arm.com>,
	James Morse <james.morse@arm.com>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 129/263] arm64: cputype: Add Cortex-X3 definitions
Date: Mon, 12 Aug 2024 18:02:10 +0200
Message-ID: <20240812160151.488107760@linuxfoundation.org>
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

[ Upstream commit be5a6f238700f38b534456608588723fba96c5ab ]

Add cputype definitions for Cortex-X3. These will be used for errata
detection in subsequent patches.

These values can be found in Table A-263 ("MIDR_EL1 bit descriptions")
in issue 07 of the Cortex-X3 TRM, which can be found at:

  https://developer.arm.com/documentation/101593/0102/?lang=en

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: James Morse <james.morse@arm.com>
Cc: Will Deacon <will@kernel.org>
Link: https://lore.kernel.org/r/20240603111812.1514101-2-mark.rutland@arm.com
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
[ Mark: trivial backport ]
Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/include/asm/cputype.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/include/asm/cputype.h b/arch/arm64/include/asm/cputype.h
index 7b32b99023a21..72fe207403c83 100644
--- a/arch/arm64/include/asm/cputype.h
+++ b/arch/arm64/include/asm/cputype.h
@@ -86,6 +86,7 @@
 #define ARM_CPU_PART_CORTEX_X2		0xD48
 #define ARM_CPU_PART_NEOVERSE_N2	0xD49
 #define ARM_CPU_PART_CORTEX_A78C	0xD4B
+#define ARM_CPU_PART_CORTEX_X3		0xD4E
 #define ARM_CPU_PART_NEOVERSE_V2	0xD4F
 #define ARM_CPU_PART_CORTEX_X4		0xD82
 #define ARM_CPU_PART_NEOVERSE_V3	0xD84
@@ -162,6 +163,7 @@
 #define MIDR_CORTEX_X2 MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_X2)
 #define MIDR_NEOVERSE_N2 MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_NEOVERSE_N2)
 #define MIDR_CORTEX_A78C	MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_A78C)
+#define MIDR_CORTEX_X3 MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_X3)
 #define MIDR_NEOVERSE_V2 MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_NEOVERSE_V2)
 #define MIDR_CORTEX_X4 MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_X4)
 #define MIDR_NEOVERSE_V3 MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_NEOVERSE_V3)
-- 
2.43.0



