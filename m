Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EBDA44CAF5;
	Tue, 16 Jun 2026 16:14:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781626470; cv=none; b=rwgRfK5Tg7JpaPVMUBKtIEqsFlR06gQXg0G26Ny5n3xb/vg1jSKc5Xd7hQ/rBIcu/Aho4pnkXa1V59RpERc24L0a3XJZH78tV6wuHJd1kmhr5SgOij9m+Y6YWmarXpq5G7P/whNX913zUZ++4Jl0zKsT+2SGbJ77CjPA6TuSNzc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781626470; c=relaxed/simple;
	bh=BXTLQvJi7VA0l/D06PcZvf92zUYJhFYTV2CFd7kyx30=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Sd4xXue8jr1e9qJc0g8taWJqJT6ug1PXLtWjmi2Q1N/ndfdaCv1jcBkpUf4jlQzRgBZlLGhzFY8l2LqaABIOzGKN4IT2p7jFoy7+brDriPfLU0YmTA6/4t+XyENv8e3oo3Ah4AG6SRWD03P+RuMu46A9btNdb2hTjQ71H05NNZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ekmYZcVb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ekmYZcVb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB9251F000E9;
	Tue, 16 Jun 2026 16:14:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781626469;
	bh=MXfNiBc0s6GrRJ+JcrY6J3L+sGnEIzpConwNyL9sZvk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ekmYZcVbHOQ8G5jvlh8mnqkbSFAXNa9MdLCkZaPup3EooOscliY9s7B3pLZ06ei1i
	 PeVmTWjk77dDhHxqqAPf0Yc5/jgViCzfl9eY/QTvP4hn8bLt0xrBETtzQPdAgUgbVP
	 8rJEYVAhJtKQibA/hMFsPHUuDPuUYlcycHvZHquI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Rutland <mark.rutland@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>
Subject: [PATCH 6.18 320/325] arm64: cputype: Add C1-Ultra definitions
Date: Tue, 16 Jun 2026 20:31:56 +0530
Message-ID: <20260616145115.028687570@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145057.827196531@linuxfoundation.org>
References: <20260616145057.827196531@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Rutland <mark.rutland@arm.com>

commit 60349e64a6c65f9f0aa118af711b3c7e137f07ff upstream.

Add cputype definitions for C1-Ultra. These will be used for errata
detection in subsequent patches.

These values can be found in the C1-Ultra TRM:

  https://developer.arm.com/documentation/108014/0100/

... in section A.5.1 ("MIDR_EL1, Main ID Register").

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Will Deacon <will@kernel.org>
[Mark: backport to v6.18.y]
Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/include/asm/cputype.h |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/arm64/include/asm/cputype.h
+++ b/arch/arm64/include/asm/cputype.h
@@ -97,6 +97,7 @@
 #define ARM_CPU_PART_CORTEX_X925	0xD85
 #define ARM_CPU_PART_CORTEX_A725	0xD87
 #define ARM_CPU_PART_CORTEX_A720AE	0xD89
+#define ARM_CPU_PART_C1_ULTRA		0xD8C
 #define ARM_CPU_PART_NEOVERSE_N3	0xD8E
 #define ARM_CPU_PART_C1_PRO		0xD8B
 
@@ -189,6 +190,7 @@
 #define MIDR_CORTEX_X925 MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_X925)
 #define MIDR_CORTEX_A725 MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_A725)
 #define MIDR_CORTEX_A720AE MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_A720AE)
+#define MIDR_C1_ULTRA MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_C1_ULTRA)
 #define MIDR_NEOVERSE_N3 MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_NEOVERSE_N3)
 #define MIDR_C1_PRO MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_C1_PRO)
 #define MIDR_THUNDERX	MIDR_CPU_MODEL(ARM_CPU_IMP_CAVIUM, CAVIUM_CPU_PART_THUNDERX)


