Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1770157E92;
	Mon, 29 Jan 2024 17:08:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548090; cv=none; b=RxFtCZjPBhRyMlYFDcK+sca73hOd9hUF+K1u8WMJiaiJA9VndcYH1ubB7Bb6qDO/R9Yiqhyyu33N2Oo8KxEp5e9Z/1EzWXSEwtkT9u3GBAmRobqQGY1T0rsI1WtpRweO4MfVG4qGEYMIXfrBC784S71C1hmN9B55Awtw0QOsRWk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548090; c=relaxed/simple;
	bh=op3jJcxnLdXn1Q5t7kEpqjSpq9XOja41c2yjO5BGHlQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KMEdhbBS1lT7GaOfJx15WPSm6mmCXEIRlavpniWGFEZ0V7gneAPpYyxX1LQYvpxuUzuX8yfNIAfRH7f2kZb5TdiMOD5Ntjy5c8G7nUHU4hGFkAZ+vy5ZPSf48CZDBe4Cy9gsFF93AH+nIZRfss4musMJjqShuIYG4bCiRkirCDk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V5hW4R/W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V5hW4R/W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 446A5C433B1;
	Mon, 29 Jan 2024 17:08:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548090;
	bh=op3jJcxnLdXn1Q5t7kEpqjSpq9XOja41c2yjO5BGHlQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V5hW4R/Wt26bova6cEIkenntBFbGnECaWWblk9UUMEW873cLzcHlYQ0UaPNElEAtZ
	 K5uKlXvGsDsTQ6n9sIOTE9b0lYwjidXGVoVED6H43oKMrw1AElvSDbBiWN9GaOquuW
	 2/K0Fv8nNLVv9T75bHiu1u/P7MZi0l9I3DVf2Ssg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rob Herring <robh@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Will Deacon <will@kernel.org>
Subject: [PATCH 6.7 105/346] arm64: Rename ARM64_WORKAROUND_2966298
Date: Mon, 29 Jan 2024 09:02:16 -0800
Message-ID: <20240129170019.486033946@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170016.356158639@linuxfoundation.org>
References: <20240129170016.356158639@linuxfoundation.org>
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
@@ -713,10 +713,10 @@ const struct arm64_cpu_capabilities arm6
 		MIDR_FIXED(MIDR_CPU_VAR_REV(1,1), BIT(25)),
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


