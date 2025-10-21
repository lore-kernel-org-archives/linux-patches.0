Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 889D2274652;
	Tue, 21 Oct 2025 19:55:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761076555; cv=none; b=s5QXFO7fEy2SEmdBCPwJK9d8T9lr/RUb88y6DZTJEU60svWQUC1j1aeLaGQNfrsmMup1xh3ycJeXPp7Osal0dY7SKK4MZiKymh3ROF2qWjW/IBd4I6h4q4ubyKVjo84k3YE5FYTrUgooUS8MMxi3VZalysRdTWXgerikn10hxhA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761076555; c=relaxed/simple;
	bh=+9qrknr7PNJnMZk/7r5+CqgXnIWMpuaiCwi5JjwGzvI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OxI3GiLC2fCfpQI555kC55UMqxZ/s+b3HmvvL36cJwh2rqx/Z3fqBSCnOKwDqulD7V3HD+uB1bdtuciEcnylDhVTrJtxlXCin2/BPA0L93UxJP653SHgbBc78rsW6FQKb0E4yLHeA1KugSZY7Ufvo/DdHyjccjcE2G/YUZNmGh0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XRdBcLBO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XRdBcLBO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B7D4C4CEF1;
	Tue, 21 Oct 2025 19:55:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761076555;
	bh=+9qrknr7PNJnMZk/7r5+CqgXnIWMpuaiCwi5JjwGzvI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XRdBcLBOhsW5kDm6Y5yjiAkfAxTDpmR4nKNNXiDL+g35WYixw3RenFQf+cRj5DOi/
	 7J+LjHorgCdBl7AiI3xoxWr47yNcLEoknMHtJaBxkTjkvAAbW950eHyR60uogNXc9J
	 uhbzDGCLNNOaZ+tUT3sJStVNme6QMrkyt4kIdJqQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Rutland <mark.rutland@arm.com>,
	James Morse <james.morse@arm.com>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Ryan Roberts <ryan.roberts@arm.com>
Subject: [PATCH 6.6 072/105] arm64: cputype: Add Neoverse-V3AE definitions
Date: Tue, 21 Oct 2025 21:51:21 +0200
Message-ID: <20251021195023.369333967@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251021195021.492915002@linuxfoundation.org>
References: <20251021195021.492915002@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -180,6 +181,7 @@
 #define MIDR_NEOVERSE_V2 MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_NEOVERSE_V2)
 #define MIDR_CORTEX_A720 MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_A720)
 #define MIDR_CORTEX_X4 MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_X4)
+#define MIDR_NEOVERSE_V3AE	MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_NEOVERSE_V3AE)
 #define MIDR_NEOVERSE_V3 MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_NEOVERSE_V3)
 #define MIDR_CORTEX_X925 MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_X925)
 #define MIDR_CORTEX_A725 MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_A725)


