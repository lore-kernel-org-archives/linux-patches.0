Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC1EF1AC8BB;
	Thu, 15 Aug 2024 14:01:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723730461; cv=none; b=QmIeXSu3+3wr5vxo8x14Chd+HLAa0klyl1wt2FjFmjm9MSCBdf63+ZrAUwhUj+mN2mgtaUi8XhJ+e+xpOpXMOGCyuK9faD4PGo1xEi9PgaUeIFnc6aY9Hrh2v5occZRJ9A6UTeiHNGJmB1TRmos8j6PMWxuOT1z4xwAjOSXr3IE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723730461; c=relaxed/simple;
	bh=WpYXaOFN/HNzaG3nSRZM29on0Yc+YFFh/HfSpEp46+U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CLw0eE5FPvZrs+JhR7+b/Upkcm/wU4Adb1zeexuTRJvndJqNTA/PkwDWChtS+j67Jwrohy/PtiDXqz9gBN5+gLvZAYdxJqzeJ9bMXfW1RjVOv1wpH6LWeGautzSpwtNh/n3RwnvxNykT9V9u+WJ74zk34g2e8iGHYyKpMcb9wgo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TcNpI1R3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TcNpI1R3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40F86C32786;
	Thu, 15 Aug 2024 14:01:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723730461;
	bh=WpYXaOFN/HNzaG3nSRZM29on0Yc+YFFh/HfSpEp46+U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TcNpI1R3n4nXrlRfCrgLAEi3vWtaGAdfybIqe3mPu9e2eJw7xedjnc3i2dOmYaz3f
	 O9PFZltmP8ZUhE6rLWmIFY3b2qvozWq6IUW/Xk5TTdHRZcWVfUPx62I0tiERrWxND+
	 tqXRAt2ycviRFh+CbHCBuImzX/14BIqpM3KWLfWs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Rutland <mark.rutland@arm.com>,
	James Morse <james.morse@arm.com>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 398/484] arm64: cputype: Add Cortex-X3 definitions
Date: Thu, 15 Aug 2024 15:24:16 +0200
Message-ID: <20240815131956.823469458@linuxfoundation.org>
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
index 17fb978191d68..e246d7fad17a9 100644
--- a/arch/arm64/include/asm/cputype.h
+++ b/arch/arm64/include/asm/cputype.h
@@ -85,6 +85,7 @@
 #define ARM_CPU_PART_CORTEX_X2		0xD48
 #define ARM_CPU_PART_NEOVERSE_N2	0xD49
 #define ARM_CPU_PART_CORTEX_A78C	0xD4B
+#define ARM_CPU_PART_CORTEX_X3		0xD4E
 #define ARM_CPU_PART_NEOVERSE_V2	0xD4F
 #define ARM_CPU_PART_CORTEX_X4		0xD82
 #define ARM_CPU_PART_NEOVERSE_V3	0xD84
@@ -142,6 +143,7 @@
 #define MIDR_CORTEX_X2 MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_X2)
 #define MIDR_NEOVERSE_N2 MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_NEOVERSE_N2)
 #define MIDR_CORTEX_A78C	MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_A78C)
+#define MIDR_CORTEX_X3 MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_X3)
 #define MIDR_NEOVERSE_V2 MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_NEOVERSE_V2)
 #define MIDR_CORTEX_X4 MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_X4)
 #define MIDR_NEOVERSE_V3 MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_NEOVERSE_V3)
-- 
2.43.0



