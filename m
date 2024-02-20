Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1E4F612D7;
	Tue, 20 Feb 2024 21:39:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708465192; cv=none; b=X0+oJAbIBt5DLBseYDMc13L9Gu4avX5FRUPv2+btFSEdU+0AluzDb9Zj9xsmCB12V12HD01yGOfphwIlEUaAf/khhZtl41N5x7WNzbdcyx7ws4c6YnrtSZRZZLy/PUu3N2/oCxFj+1zc1w2fG1M3mUBreUKWrOrr50O7pabcN7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708465192; c=relaxed/simple;
	bh=mao4dfjSxSziLg3GdUEQpL/a77rhYPfhwyDb2h1IUpQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hsf5eD20amGG89JmxdQzOW3JYjtWVUCmqKM0jCSBt4UNuzKT5nUzvj87K9Vs7d75lH5Ge/xUiprsoFJ9YXVSGhcId8aboH9d/ywpSjEbrN/Pz1Q94S/zlTjpEqMgBoszI5+kK/dOrS1hqS/rllscEu/N7veKHbDwWQ6Fqcjt7V4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ykLNJbq4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ykLNJbq4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27F31C433F1;
	Tue, 20 Feb 2024 21:39:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708465192;
	bh=mao4dfjSxSziLg3GdUEQpL/a77rhYPfhwyDb2h1IUpQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ykLNJbq4tM6WRB6HkmyUObUS67uuASyyHGJcM4ZgOhTVEolaOdomzqpfK7hsX1FOj
	 vE8cEIFmF7AGwlZ5dD8Mfy1r/D8AzoahdV5evEiGZ1OQAX+E29YbfoRZMF1mz/rZfz
	 QmqadOGsbzGgsgwpCKdRKTe+V+nbuuSHjvaMojyk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Easwar Hariharan <eahariha@linux.microsoft.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Will Deacon <will@kernel.org>
Subject: [PATCH 6.7 266/309] arm64: Subscribe Microsoft Azure Cobalt 100 to ARM Neoverse N2 errata
Date: Tue, 20 Feb 2024 21:57:05 +0100
Message-ID: <20240220205641.473062799@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205633.096363225@linuxfoundation.org>
References: <20240220205633.096363225@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Easwar Hariharan <eahariha@linux.microsoft.com>

commit fb091ff394792c018527b3211bbdfae93ea4ac02 upstream.

Add the MIDR value of Microsoft Azure Cobalt 100, which is a Microsoft
implemented CPU based on r0p0 of the ARM Neoverse N2 CPU, and therefore
suffers from all the same errata.

CC: stable@vger.kernel.org # 5.15+
Signed-off-by: Easwar Hariharan <eahariha@linux.microsoft.com>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Acked-by: Mark Rutland <mark.rutland@arm.com>
Acked-by: Marc Zyngier <maz@kernel.org>
Reviewed-by: Oliver Upton <oliver.upton@linux.dev>
Link: https://lore.kernel.org/r/20240214175522.2457857-1-eahariha@linux.microsoft.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/arch/arm64/silicon-errata.rst |    7 +++++++
 arch/arm64/include/asm/cputype.h            |    4 ++++
 arch/arm64/kernel/cpu_errata.c              |    3 +++
 3 files changed, 14 insertions(+)

--- a/Documentation/arch/arm64/silicon-errata.rst
+++ b/Documentation/arch/arm64/silicon-errata.rst
@@ -235,3 +235,10 @@ stable kernels.
 +----------------+-----------------+-----------------+-----------------------------+
 | ASR            | ASR8601         | #8601001        | N/A                         |
 +----------------+-----------------+-----------------+-----------------------------+
++----------------+-----------------+-----------------+-----------------------------+
+| Microsoft      | Azure Cobalt 100| #2139208        | ARM64_ERRATUM_2139208       |
++----------------+-----------------+-----------------+-----------------------------+
+| Microsoft      | Azure Cobalt 100| #2067961        | ARM64_ERRATUM_2067961       |
++----------------+-----------------+-----------------+-----------------------------+
+| Microsoft      | Azure Cobalt 100| #2253138        | ARM64_ERRATUM_2253138       |
++----------------+-----------------+-----------------+-----------------------------+
--- a/arch/arm64/include/asm/cputype.h
+++ b/arch/arm64/include/asm/cputype.h
@@ -61,6 +61,7 @@
 #define ARM_CPU_IMP_HISI		0x48
 #define ARM_CPU_IMP_APPLE		0x61
 #define ARM_CPU_IMP_AMPERE		0xC0
+#define ARM_CPU_IMP_MICROSOFT		0x6D
 
 #define ARM_CPU_PART_AEM_V8		0xD0F
 #define ARM_CPU_PART_FOUNDATION		0xD00
@@ -135,6 +136,8 @@
 
 #define AMPERE_CPU_PART_AMPERE1		0xAC3
 
+#define MICROSOFT_CPU_PART_AZURE_COBALT_100	0xD49 /* Based on r0p0 of ARM Neoverse N2 */
+
 #define MIDR_CORTEX_A53 MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_A53)
 #define MIDR_CORTEX_A57 MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_A57)
 #define MIDR_CORTEX_A72 MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_A72)
@@ -193,6 +196,7 @@
 #define MIDR_APPLE_M2_BLIZZARD_MAX MIDR_CPU_MODEL(ARM_CPU_IMP_APPLE, APPLE_CPU_PART_M2_BLIZZARD_MAX)
 #define MIDR_APPLE_M2_AVALANCHE_MAX MIDR_CPU_MODEL(ARM_CPU_IMP_APPLE, APPLE_CPU_PART_M2_AVALANCHE_MAX)
 #define MIDR_AMPERE1 MIDR_CPU_MODEL(ARM_CPU_IMP_AMPERE, AMPERE_CPU_PART_AMPERE1)
+#define MIDR_MICROSOFT_AZURE_COBALT_100 MIDR_CPU_MODEL(ARM_CPU_IMP_MICROSOFT, MICROSOFT_CPU_PART_AZURE_COBALT_100)
 
 /* Fujitsu Erratum 010001 affects A64FX 1.0 and 1.1, (v0r0 and v1r0) */
 #define MIDR_FUJITSU_ERRATUM_010001		MIDR_FUJITSU_A64FX
--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -374,6 +374,7 @@ static const struct midr_range erratum_1
 static const struct midr_range trbe_overwrite_fill_mode_cpus[] = {
 #ifdef CONFIG_ARM64_ERRATUM_2139208
 	MIDR_ALL_VERSIONS(MIDR_NEOVERSE_N2),
+	MIDR_ALL_VERSIONS(MIDR_MICROSOFT_AZURE_COBALT_100),
 #endif
 #ifdef CONFIG_ARM64_ERRATUM_2119858
 	MIDR_ALL_VERSIONS(MIDR_CORTEX_A710),
@@ -387,6 +388,7 @@ static const struct midr_range trbe_over
 static const struct midr_range tsb_flush_fail_cpus[] = {
 #ifdef CONFIG_ARM64_ERRATUM_2067961
 	MIDR_ALL_VERSIONS(MIDR_NEOVERSE_N2),
+	MIDR_ALL_VERSIONS(MIDR_MICROSOFT_AZURE_COBALT_100),
 #endif
 #ifdef CONFIG_ARM64_ERRATUM_2054223
 	MIDR_ALL_VERSIONS(MIDR_CORTEX_A710),
@@ -399,6 +401,7 @@ static const struct midr_range tsb_flush
 static struct midr_range trbe_write_out_of_range_cpus[] = {
 #ifdef CONFIG_ARM64_ERRATUM_2253138
 	MIDR_ALL_VERSIONS(MIDR_NEOVERSE_N2),
+	MIDR_ALL_VERSIONS(MIDR_MICROSOFT_AZURE_COBALT_100),
 #endif
 #ifdef CONFIG_ARM64_ERRATUM_2224489
 	MIDR_ALL_VERSIONS(MIDR_CORTEX_A710),


