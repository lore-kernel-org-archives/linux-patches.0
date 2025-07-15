Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D1DB2EF64F;
	Tue, 15 Jul 2025 13:57:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752587823; cv=none; b=CR9kS0/wCesr7dpUpx0ko533o8fedy64j5JrCpUP6jKdY6lkpvJhQTOGehGsU0XxDBzJClfvI82hUr4vnUMS6zMBlGvPVA27Z+Eff1oRM4gMqc6RbNoPygmd+zbDZ7l12Un4JF3Fwta7MStHAg/O2qAsSodl+LWu2G74BLL3Jxk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752587823; c=relaxed/simple;
	bh=/53J0jQnCV6yD2Qpzh0sKpRiKIeMW7PC3GGzR66hqoA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cmxSBQN4sWMEDgEYt/2zJzcU4HLxwAe/Mr4d0xuyUkK5enMfR16KIoOLl7pNMnPLta/l3yIrVGCfW8qri3YLtzOC9Tmp7TwyJ1WikqgZmHmuZSXaUtp9p7dCJnzyvWBvGUo2EiIL9/2H4oDl1TtvcOKAHRSbdgjLkigZnfxm3C8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vFCvij/r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vFCvij/r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FE47C4CEE3;
	Tue, 15 Jul 2025 13:57:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752587822;
	bh=/53J0jQnCV6yD2Qpzh0sKpRiKIeMW7PC3GGzR66hqoA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vFCvij/r2O59Dqm3MShQHHa9uLru+N8LkaLtiTWgm9NF5KySokMKzMASu66bWoR6i
	 UsBcsptbFvKPiFsp7qvphctYcr/somdLMw4shpzMR6CWJ3Q+goI+SWYw5wO0cPVMGL
	 Ta7LrhmT0Uyx/Zz26d9WbSbN6nGRIngBCJPiacrM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Gleixner <tglx@linutronix.de>,
	Alexandre Chartre <alexandre.chartre@oracle.com>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Daniel Sneddon <daniel.sneddon@linux.intel.com>,
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Subject: [PATCH 5.10 156/208] x86/bhi: Define SPEC_CTRL_BHI_DIS_S
Date: Tue, 15 Jul 2025 15:14:25 +0200
Message-ID: <20250715130817.155455788@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130810.830580412@linuxfoundation.org>
References: <20250715130810.830580412@linuxfoundation.org>
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

From: Daniel Sneddon <daniel.sneddon@linux.intel.com>

commit 0f4a837615ff925ba62648d280a861adf1582df7 upstream.

Newer processors supports a hardware control BHI_DIS_S to mitigate
Branch History Injection (BHI). Setting BHI_DIS_S protects the kernel
from userspace BHI attacks without having to manually overwrite the
branch history.

Define MSR_SPEC_CTRL bit BHI_DIS_S and its enumeration CPUID.BHI_CTRL.
Mitigation is enabled later.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Alexandre Chartre <alexandre.chartre@oracle.com>
Reviewed-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Daniel Sneddon <daniel.sneddon@linux.intel.com>
Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/cpufeatures.h |    2 +-
 arch/x86/include/asm/msr-index.h   |    5 ++++-
 arch/x86/kernel/cpu/scattered.c    |    1 +
 3 files changed, 6 insertions(+), 2 deletions(-)

--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -289,7 +289,7 @@
 #define X86_FEATURE_FENCE_SWAPGS_KERNEL	(11*32+ 5) /* "" LFENCE in kernel entry SWAPGS path */
 #define X86_FEATURE_SPLIT_LOCK_DETECT	(11*32+ 6) /* #AC for split lock */
 #define X86_FEATURE_PER_THREAD_MBA	(11*32+ 7) /* "" Per-thread Memory Bandwidth Allocation */
-/* FREE!				(11*32+ 8) */
+#define X86_FEATURE_BHI_CTRL		(11*32+ 8) /* "" BHI_DIS_S HW control available */
 /* FREE!				(11*32+ 9) */
 #define X86_FEATURE_ENTRY_IBPB		(11*32+10) /* "" Issue an IBPB on kernel entry */
 #define X86_FEATURE_RRSBA_CTRL		(11*32+11) /* "" RET prediction control */
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -55,10 +55,13 @@
 #define SPEC_CTRL_SSBD			BIT(SPEC_CTRL_SSBD_SHIFT)	/* Speculative Store Bypass Disable */
 #define SPEC_CTRL_RRSBA_DIS_S_SHIFT	6	   /* Disable RRSBA behavior */
 #define SPEC_CTRL_RRSBA_DIS_S		BIT(SPEC_CTRL_RRSBA_DIS_S_SHIFT)
+#define SPEC_CTRL_BHI_DIS_S_SHIFT	10	   /* Disable Branch History Injection behavior */
+#define SPEC_CTRL_BHI_DIS_S		BIT(SPEC_CTRL_BHI_DIS_S_SHIFT)
 
 /* A mask for bits which the kernel toggles when controlling mitigations */
 #define SPEC_CTRL_MITIGATIONS_MASK	(SPEC_CTRL_IBRS | SPEC_CTRL_STIBP | SPEC_CTRL_SSBD \
-							| SPEC_CTRL_RRSBA_DIS_S)
+							| SPEC_CTRL_RRSBA_DIS_S \
+							| SPEC_CTRL_BHI_DIS_S)
 
 #define MSR_IA32_PRED_CMD		0x00000049 /* Prediction Command */
 #define PRED_CMD_IBPB			BIT(0)	   /* Indirect Branch Prediction Barrier */
--- a/arch/x86/kernel/cpu/scattered.c
+++ b/arch/x86/kernel/cpu/scattered.c
@@ -27,6 +27,7 @@ static const struct cpuid_bit cpuid_bits
 	{ X86_FEATURE_APERFMPERF,       CPUID_ECX,  0, 0x00000006, 0 },
 	{ X86_FEATURE_EPB,		CPUID_ECX,  3, 0x00000006, 0 },
 	{ X86_FEATURE_RRSBA_CTRL,	CPUID_EDX,  2, 0x00000007, 2 },
+	{ X86_FEATURE_BHI_CTRL,		CPUID_EDX,  4, 0x00000007, 2 },
 	{ X86_FEATURE_CQM_LLC,		CPUID_EDX,  1, 0x0000000f, 0 },
 	{ X86_FEATURE_CQM_OCCUP_LLC,	CPUID_EDX,  0, 0x0000000f, 1 },
 	{ X86_FEATURE_CQM_MBM_TOTAL,	CPUID_EDX,  1, 0x0000000f, 1 },


