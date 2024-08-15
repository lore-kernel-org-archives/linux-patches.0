Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEBD01714DD;
	Thu, 15 Aug 2024 14:01:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723730497; cv=none; b=GRECu39GbjGGS32+RycLZ52efPxUmCLhBfM+SmBzJ2wRowEg84CwHjqpmel/PWgow4xYZ0P42XUhw6OTm+NGrpeFNE5+sdTlhpJ+mJ8a0pZPBgwAqW4e7QPFTZB8h60JUejVxjKYGFKqARWAbbgmCW/fekPp7VVAhTw9dDAyD3o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723730497; c=relaxed/simple;
	bh=f1BX3UcMfjAcfNivEBOgiUfI0m27PZCkwlTdrcE+51Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uwQTgYj+C/8yXrtEA/PLn0yog77uJxTWJJa3NqjFtTqzP4fBdGvg1bvvoffbwyQyEsJzFqQvKQDSYFBlyDbQMBdf+dIu8hHJbO0mF6pfF6BjWSLn5kmXM090f1JCzsvhdknP98jY4pRZGL8hEkJpzsnyX4Qn9b0Eq3LaIRsO0Io=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gmuPKVoz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gmuPKVoz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16471C32786;
	Thu, 15 Aug 2024 14:01:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723730496;
	bh=f1BX3UcMfjAcfNivEBOgiUfI0m27PZCkwlTdrcE+51Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gmuPKVoz+dLmcIKS9U2VwdI4fiS8cr0rtYznPW9n2sp4NHfOuP592QAk0us7S7lCZ
	 qzmucyaDjMSICG8umPxQp7XIqSd6PbpZhguJjno0Bk6H9XMDoRKt2hyhz5gPrtta2+
	 wxMd19PyMXbKcUUvFX7gsE6VcQBMs6QQK0Br3LgA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Rutland <mark.rutland@arm.com>,
	James Morse <james.morse@arm.com>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 399/484] arm64: cputype: Add Cortex-A720 definitions
Date: Thu, 15 Aug 2024 15:24:17 +0200
Message-ID: <20240815131956.862532954@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Rutland <mark.rutland@arm.com>

[ Upstream commit add332c40328cf06fe35e4b3cde8ec315c4629e5 ]

Add cputype definitions for Cortex-A720. These will be used for errata
detection in subsequent patches.

These values can be found in Table A-186 ("MIDR_EL1 bit descriptions")
in issue 0002-05 of the Cortex-A720 TRM, which can be found at:

  https://developer.arm.com/documentation/102530/0002/?lang=en

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: James Morse <james.morse@arm.com>
Cc: Will Deacon <will@kernel.org>
Link: https://lore.kernel.org/r/20240603111812.1514101-3-mark.rutland@arm.com
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
[ Mark: trivial backport ]
Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/include/asm/cputype.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/include/asm/cputype.h b/arch/arm64/include/asm/cputype.h
index e246d7fad17a9..edfd6ac14a127 100644
--- a/arch/arm64/include/asm/cputype.h
+++ b/arch/arm64/include/asm/cputype.h
@@ -87,6 +87,7 @@
 #define ARM_CPU_PART_CORTEX_A78C	0xD4B
 #define ARM_CPU_PART_CORTEX_X3		0xD4E
 #define ARM_CPU_PART_NEOVERSE_V2	0xD4F
+#define ARM_CPU_PART_CORTEX_A720	0xD81
 #define ARM_CPU_PART_CORTEX_X4		0xD82
 #define ARM_CPU_PART_NEOVERSE_V3	0xD84
 
@@ -145,6 +146,7 @@
 #define MIDR_CORTEX_A78C	MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_A78C)
 #define MIDR_CORTEX_X3 MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_X3)
 #define MIDR_NEOVERSE_V2 MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_NEOVERSE_V2)
+#define MIDR_CORTEX_A720 MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_A720)
 #define MIDR_CORTEX_X4 MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_X4)
 #define MIDR_NEOVERSE_V3 MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_NEOVERSE_V3)
 #define MIDR_THUNDERX	MIDR_CPU_MODEL(ARM_CPU_IMP_CAVIUM, CAVIUM_CPU_PART_THUNDERX)
-- 
2.43.0



