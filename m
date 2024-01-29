Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79C8F157052;
	Mon, 29 Jan 2024 17:15:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548501; cv=none; b=hmKBI5eEmkxJv3RWi43rt+hsqQamPUOe0psGJhfCRvu9dOZb0lKI66c6sjtbY+wX+j5QhfzowzAbV1aBZvlEguqnmJz4bDusfC0zW3TFEKYewr5TI2w4lMr8CzuyHaIkMwsSlcU9d6t5sGrCQCiB4CG/6m8TeKd88Rk0clZ1zkQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548501; c=relaxed/simple;
	bh=iduBKstbPd/WSxeGnRQ7tZUFT27dq1dkPnqC6eanUSg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HkxONA3m0beV/9RD5l8VOK+WMsmEDgE1Vop1qXmXEZ4HksH6Q1LRBaMBvsMGCd964m0QuX0neqYyrXEvjG/W3hskSq/dXOmH0xZj1+Bb8Vgk3/tAOCtYD0684F+hvPzSy1e1A3fky7KOYEk5SFF5JAHPB3hyZPjnLQjEkQCt/AI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SN25+kzb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SN25+kzb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D687C433C7;
	Mon, 29 Jan 2024 17:15:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548501;
	bh=iduBKstbPd/WSxeGnRQ7tZUFT27dq1dkPnqC6eanUSg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SN25+kzbob4ZpiaW6QOLttdisifqO3Mzzdoav67T77jZwqsRvqDUZxXONfh3mzGTB
	 u0tZG4JpgPIAvs/ORh36kEmNIffrIOdPeHyqaSCyzIf3NB4Mrx4fHGxX5yf19hyfy7
	 kI+iJ/WCDyIAv+lA1+/DVk0CvVxEAyASBqBl23Ps=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rob Herring <robh@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Will Deacon <will@kernel.org>
Subject: [PATCH 6.6 111/331] arm64: Rename ARM64_WORKAROUND_2966298
Date: Mon, 29 Jan 2024 09:02:55 -0800
Message-ID: <20240129170018.168928059@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170014.969142961@linuxfoundation.org>
References: <20240129170014.969142961@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rob Herring <robh@kernel.org>

commit 546b7cde9b1dd36089649101b75266564600ffe5 upstream.

In preparation to apply ARM64_WORKAROUND_2966298 for multiple errata,
rename the kconfig and capability. No functional change.

Cc: stable@vger.kernel.org
Signed-off-by: Rob Herring <robh@kernel.org>
Reviewed-by: Mark Rutland <mark.rutland@arm.com>
Link: https://lore.kernel.org/r/20240110-arm-errata-a510-v1-1-d02bc51aeeee@kernel.org
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/Kconfig             |    4 ++++
 arch/arm64/kernel/cpu_errata.c |    4 ++--
 arch/arm64/kernel/entry.S      |    2 +-
 arch/arm64/tools/cpucaps       |    2 +-
 4 files changed, 8 insertions(+), 4 deletions(-)

--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -1037,8 +1037,12 @@ config ARM64_ERRATUM_2645198
 
 	  If unsure, say Y.
 
+config ARM64_WORKAROUND_SPECULATIVE_UNPRIV_LOAD
+	bool
+
 config ARM64_ERRATUM_2966298
 	bool "Cortex-A520: 2966298: workaround for speculatively executed unprivileged load"
+	select ARM64_WORKAROUND_SPECULATIVE_UNPRIV_LOAD
 	default y
 	help
 	  This option adds the workaround for ARM Cortex-A520 erratum 2966298.
--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -730,10 +730,10 @@ const struct arm64_cpu_capabilities arm6
 		.cpu_enable = cpu_clear_bf16_from_user_emulation,
 	},
 #endif
-#ifdef CONFIG_ARM64_ERRATUM_2966298
+#ifdef CONFIG_ARM64_WORKAROUND_SPECULATIVE_UNPRIV_LOAD
 	{
 		.desc = "ARM erratum 2966298",
-		.capability = ARM64_WORKAROUND_2966298,
+		.capability = ARM64_WORKAROUND_SPECULATIVE_UNPRIV_LOAD,
 		/* Cortex-A520 r0p0 - r0p1 */
 		ERRATA_MIDR_REV_RANGE(MIDR_CORTEX_A520, 0, 0, 1),
 	},
--- a/arch/arm64/kernel/entry.S
+++ b/arch/arm64/kernel/entry.S
@@ -428,7 +428,7 @@ alternative_else_nop_endif
 	ldp	x28, x29, [sp, #16 * 14]
 
 	.if	\el == 0
-alternative_if ARM64_WORKAROUND_2966298
+alternative_if ARM64_WORKAROUND_SPECULATIVE_UNPRIV_LOAD
 	tlbi	vale1, xzr
 	dsb	nsh
 alternative_else_nop_endif
--- a/arch/arm64/tools/cpucaps
+++ b/arch/arm64/tools/cpucaps
@@ -84,7 +84,6 @@ WORKAROUND_2077057
 WORKAROUND_2457168
 WORKAROUND_2645198
 WORKAROUND_2658417
-WORKAROUND_2966298
 WORKAROUND_AMPERE_AC03_CPU_38
 WORKAROUND_TRBE_OVERWRITE_FILL_MODE
 WORKAROUND_TSB_FLUSH_FAILURE
@@ -100,3 +99,4 @@ WORKAROUND_NVIDIA_CARMEL_CNP
 WORKAROUND_QCOM_FALKOR_E1003
 WORKAROUND_REPEAT_TLBI
 WORKAROUND_SPECULATIVE_AT
+WORKAROUND_SPECULATIVE_UNPRIV_LOAD


