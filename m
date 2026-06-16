Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05BBC3DDDD5;
	Tue, 16 Jun 2026 19:08:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781636931; cv=none; b=dDCIeCDc2/pJxnAwLuZBcY+/B+a6++ioHmisPXFtDpe8A6HDI9jxLlnM1dEOBS9HGPiSv49nMr4jLyoTghw5UMRq161WlXqOlHvK55Qjw5/tQyYSg3KBNEciUg29sqZ/AbHlzCpKl/7Zku1ztPJkCCiNH9W7MPsZg3kB6V66RYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781636931; c=relaxed/simple;
	bh=lWGHJNCFcHUtimLclq5ie4IUeteOK+tqvf/0/cc9zp8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rqXTCiviagPLLSvUm02hhS3WJUHMWed3r/2LaMzg007xA5q7IKl3fbsU18uDhfNcvLUap/nAdYhJZk2W6Bt5W9Cr9QMwTmCQvELSZ7Wj2Gq8mkXCYYE0YRzfgnQg0HNDTxLeY02OwD9VbK3zyoc0vSAWcR2GGkNF/1IWB3u/l6s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q+fBh3eR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q+fBh3eR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CFD31F000E9;
	Tue, 16 Jun 2026 19:08:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781636929;
	bh=iw1Ddu5yYRbMX6sKIIi8SsyCWcI2BxVQokF49SOyTOk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Q+fBh3eRS62ZGMtZzq15MYaevUrxO5zsGENNPkYis/cQpZWQOmZqGLlenevCuMX6A
	 QhvYQcyn/KrmqWYBGRUpYjGQLkP3fhg5EtKwlm3Xy31jDFmGg/OMKBJvQhyfX/vm2T
	 B3reFFx85wdjJpu5ShHJSkNf16NDR6mvsmVFxQuw=
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
Subject: [PATCH 5.10 333/342] arm64: Subscribe Microsoft Azure Cobalt 100 to ARM Neoverse N2 errata
Date: Tue, 16 Jun 2026 20:30:29 +0530
Message-ID: <20260616145104.124777926@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145048.348037099@linuxfoundation.org>
References: <20260616145048.348037099@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Easwar Hariharan <eahariha@linux.microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[Mark: backport to v5.10.y; only the MIDR is relevant to v5.10.y]
Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/include/asm/cputype.h |    4 ++++
 1 file changed, 4 insertions(+)

--- a/arch/arm64/include/asm/cputype.h
+++ b/arch/arm64/include/asm/cputype.h
@@ -61,6 +61,7 @@
 #define ARM_CPU_IMP_HISI		0x48
 #define ARM_CPU_IMP_APPLE		0x61
 #define ARM_CPU_IMP_AMPERE		0xC0
+#define ARM_CPU_IMP_MICROSOFT		0x6D
 
 #define ARM_CPU_PART_AEM_V8		0xD0F
 #define ARM_CPU_PART_FOUNDATION		0xD00
@@ -130,6 +131,8 @@
 
 #define AMPERE_CPU_PART_AMPERE1		0xAC3
 
+#define MICROSOFT_CPU_PART_AZURE_COBALT_100	0xD49 /* Based on r0p0 of ARM Neoverse N2 */
+
 #define MIDR_CORTEX_A53 MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_A53)
 #define MIDR_CORTEX_A57 MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_A57)
 #define MIDR_CORTEX_A72 MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_A72)
@@ -185,6 +188,7 @@
 #define MIDR_APPLE_M1_ICESTORM MIDR_CPU_MODEL(ARM_CPU_IMP_APPLE, APPLE_CPU_PART_M1_ICESTORM)
 #define MIDR_APPLE_M1_FIRESTORM MIDR_CPU_MODEL(ARM_CPU_IMP_APPLE, APPLE_CPU_PART_M1_FIRESTORM)
 #define MIDR_AMPERE1 MIDR_CPU_MODEL(ARM_CPU_IMP_AMPERE, AMPERE_CPU_PART_AMPERE1)
+#define MIDR_MICROSOFT_AZURE_COBALT_100 MIDR_CPU_MODEL(ARM_CPU_IMP_MICROSOFT, MICROSOFT_CPU_PART_AZURE_COBALT_100)
 
 /* Fujitsu Erratum 010001 affects A64FX 1.0 and 1.1, (v0r0 and v1r0) */
 #define MIDR_FUJITSU_ERRATUM_010001		MIDR_FUJITSU_A64FX


