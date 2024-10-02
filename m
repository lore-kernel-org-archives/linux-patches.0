Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCBFB1D0DCE;
	Wed,  2 Oct 2024 14:21:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727878902; cv=none; b=X9PKlWORWoUtfK1vyx6+PuYUHN8G/4pOdvU0jlndmkPYRyGwCectyoPq6Nw/gh2X/4LIu7Yx7/iugBImxQch+/KssWBhOG6tE6xvn1dnwUOPwgKMS0harZkLHdY1F4AHv3Z8SMdvzNBvtno70ENRSLR5NKZFB9NVq+sZYeo7qsI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727878902; c=relaxed/simple;
	bh=FjpizDC3vO5B9UymyD2fi/6tWBCCA1ZJXp2xMI5zGVg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sBkxWaoYvtsn2ZZk+SFWTT9eVANMqIiaaRY/OubNUC6gYycCf6mK+tItnKZI/dYpBfW442kC6jfuHtlxluWWIueO+r7oSg83Jgyr1NTt3Lx3WQXtqcC2izkUlF3TvgnXp4bSQbawxc+ZoP6wuhaXVxUFmCjvLVrAtLdX7dZjmyg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E9vyXwgC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E9vyXwgC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29A60C4CEC5;
	Wed,  2 Oct 2024 14:21:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727878902;
	bh=FjpizDC3vO5B9UymyD2fi/6tWBCCA1ZJXp2xMI5zGVg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E9vyXwgCYPJsEBQeVOPMXH83sp2a6DoxT3AOhB1DHQ7KjIC0H7siMJJwLX9O6gcor
	 mEjf6GpgQ6UKp+xHne+dkiTbjYmRUM6f47/+PGjUk1S7wBCZ7if9CFk5WQl7Q1WIEC
	 WNTb84W/0OedgnbO4jsdFaZ2rI3j1odmsuQ9Civ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	D Scott Phillips <scott@os.amperecomputing.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Will Deacon <will@kernel.org>
Subject: [PATCH 6.10 570/634] arm64: errata: Enable the AC03_CPU_38 workaround for ampere1a
Date: Wed,  2 Oct 2024 15:01:10 +0200
Message-ID: <20241002125833.614089763@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

From: D Scott Phillips <scott@os.amperecomputing.com>

commit db0d8a84348b876df7c4276f0cbce5df3b769f5f upstream.

The ampere1a cpu is affected by erratum AC04_CPU_10 which is the same
bug as AC03_CPU_38. Add ampere1a to the AC03_CPU_38 workaround midr list.

Cc: <stable@vger.kernel.org>
Signed-off-by: D Scott Phillips <scott@os.amperecomputing.com>
Acked-by: Oliver Upton <oliver.upton@linux.dev>
Link: https://lore.kernel.org/r/20240827211701.2216719-1-scott@os.amperecomputing.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/arch/arm64/silicon-errata.rst |    2 ++
 arch/arm64/Kconfig                          |    2 +-
 arch/arm64/include/asm/cputype.h            |    2 ++
 arch/arm64/kernel/cpu_errata.c              |   10 +++++++++-
 4 files changed, 14 insertions(+), 2 deletions(-)

--- a/Documentation/arch/arm64/silicon-errata.rst
+++ b/Documentation/arch/arm64/silicon-errata.rst
@@ -55,6 +55,8 @@ stable kernels.
 +----------------+-----------------+-----------------+-----------------------------+
 | Ampere         | AmpereOne       | AC03_CPU_38     | AMPERE_ERRATUM_AC03_CPU_38  |
 +----------------+-----------------+-----------------+-----------------------------+
+| Ampere         | AmpereOne AC04  | AC04_CPU_10     | AMPERE_ERRATUM_AC03_CPU_38  |
++----------------+-----------------+-----------------+-----------------------------+
 +----------------+-----------------+-----------------+-----------------------------+
 | ARM            | Cortex-A510     | #2457168        | ARM64_ERRATUM_2457168       |
 +----------------+-----------------+-----------------+-----------------------------+
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -422,7 +422,7 @@ config AMPERE_ERRATUM_AC03_CPU_38
 	default y
 	help
 	  This option adds an alternative code sequence to work around Ampere
-	  erratum AC03_CPU_38 on AmpereOne.
+	  errata AC03_CPU_38 and AC04_CPU_10 on AmpereOne.
 
 	  The affected design reports FEAT_HAFDBS as not implemented in
 	  ID_AA64MMFR1_EL1.HAFDBS, but (V)TCR_ELx.{HA,HD} are not RES0
--- a/arch/arm64/include/asm/cputype.h
+++ b/arch/arm64/include/asm/cputype.h
@@ -143,6 +143,7 @@
 #define APPLE_CPU_PART_M2_AVALANCHE_MAX	0x039
 
 #define AMPERE_CPU_PART_AMPERE1		0xAC3
+#define AMPERE_CPU_PART_AMPERE1A	0xAC4
 
 #define MICROSOFT_CPU_PART_AZURE_COBALT_100	0xD49 /* Based on r0p0 of ARM Neoverse N2 */
 
@@ -212,6 +213,7 @@
 #define MIDR_APPLE_M2_BLIZZARD_MAX MIDR_CPU_MODEL(ARM_CPU_IMP_APPLE, APPLE_CPU_PART_M2_BLIZZARD_MAX)
 #define MIDR_APPLE_M2_AVALANCHE_MAX MIDR_CPU_MODEL(ARM_CPU_IMP_APPLE, APPLE_CPU_PART_M2_AVALANCHE_MAX)
 #define MIDR_AMPERE1 MIDR_CPU_MODEL(ARM_CPU_IMP_AMPERE, AMPERE_CPU_PART_AMPERE1)
+#define MIDR_AMPERE1A MIDR_CPU_MODEL(ARM_CPU_IMP_AMPERE, AMPERE_CPU_PART_AMPERE1A)
 #define MIDR_MICROSOFT_AZURE_COBALT_100 MIDR_CPU_MODEL(ARM_CPU_IMP_MICROSOFT, MICROSOFT_CPU_PART_AZURE_COBALT_100)
 
 /* Fujitsu Erratum 010001 affects A64FX 1.0 and 1.1, (v0r0 and v1r0) */
--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -456,6 +456,14 @@ static const struct midr_range erratum_s
 };
 #endif
 
+#ifdef CONFIG_AMPERE_ERRATUM_AC03_CPU_38
+static const struct midr_range erratum_ac03_cpu_38_list[] = {
+	MIDR_ALL_VERSIONS(MIDR_AMPERE1),
+	MIDR_ALL_VERSIONS(MIDR_AMPERE1A),
+	{},
+};
+#endif
+
 const struct arm64_cpu_capabilities arm64_errata[] = {
 #ifdef CONFIG_ARM64_WORKAROUND_CLEAN_CACHE
 	{
@@ -772,7 +780,7 @@ const struct arm64_cpu_capabilities arm6
 	{
 		.desc = "AmpereOne erratum AC03_CPU_38",
 		.capability = ARM64_WORKAROUND_AMPERE_AC03_CPU_38,
-		ERRATA_MIDR_ALL_VERSIONS(MIDR_AMPERE1),
+		ERRATA_MIDR_RANGE_LIST(erratum_ac03_cpu_38_list),
 	},
 #endif
 	{


