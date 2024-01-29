Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53FBE15B2FA;
	Mon, 29 Jan 2024 17:10:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548252; cv=none; b=qKyRUjG9fnbiu4Yn858mNpo4LRHXUb+iVFmB/kNzZvnowTxTSBxf20Hfg1Wn5Y9Uyvp7WgPu94aQcInSZqoW5vFkBXfAm+imXw5KUMsoJZKyfc5fu4etjGi2IEFK29foJ1hvBHedW6VEf3q0XE3t9HQLvFVRE8m0+B8DE+0f8Wg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548252; c=relaxed/simple;
	bh=QFvhgMdhNAg4c09MDhcOLnlmmJn6jW2ZD1KLN2kSKGo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UWMYlBZ6myB9h0FUlC5r5aHt4tHAU/F7WSX8aIJW8VaIgn0XTymz+aXc2RdRnO8VP7vLwm/Ji4MB+UwW9MVfy7aKaqkhZM63ajOtJKmy7oLOuSOi84RXheyGLn5O+HXNViMlROZYA0oduujxo+Dc2vMIOXbYFlZDrXzLeqpggaM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dH7westV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dH7westV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DA0DC43390;
	Mon, 29 Jan 2024 17:10:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548252;
	bh=QFvhgMdhNAg4c09MDhcOLnlmmJn6jW2ZD1KLN2kSKGo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dH7westVPZqVDMUpsFsJS6AUDPvl/Lx+lbboPnPPEvGSIOLMQYkMq3cS9l3u3FVl6
	 0kM14GMFkfzmcYpQHilAX9Z72JSyNFkoV6miA7CkJUs8yUuLOUA8ZpaMC9d0+MZyu3
	 QRddZqvYcIAA1gXt8qjYcw9M/nH16HRf9vkcgy8g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rob Herring <robh@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Will Deacon <will@kernel.org>
Subject: [PATCH 6.1 047/185] arm64: Rename ARM64_WORKAROUND_2966298
Date: Mon, 29 Jan 2024 09:04:07 -0800
Message-ID: <20240129170000.100100939@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129165958.589924174@linuxfoundation.org>
References: <20240129165958.589924174@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -983,8 +983,12 @@ config ARM64_ERRATUM_2457168
 
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
@@ -723,10 +723,10 @@ const struct arm64_cpu_capabilities arm6
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
@@ -419,7 +419,7 @@ alternative_else_nop_endif
 	ldp	x28, x29, [sp, #16 * 14]
 
 	.if	\el == 0
-alternative_if ARM64_WORKAROUND_2966298
+alternative_if ARM64_WORKAROUND_SPECULATIVE_UNPRIV_LOAD
 	tlbi	vale1, xzr
 	dsb	nsh
 alternative_else_nop_endif
--- a/arch/arm64/tools/cpucaps
+++ b/arch/arm64/tools/cpucaps
@@ -71,7 +71,6 @@ WORKAROUND_2064142
 WORKAROUND_2077057
 WORKAROUND_2457168
 WORKAROUND_2658417
-WORKAROUND_2966298
 WORKAROUND_AMPERE_AC03_CPU_38
 WORKAROUND_TRBE_OVERWRITE_FILL_MODE
 WORKAROUND_TSB_FLUSH_FAILURE
@@ -87,3 +86,4 @@ WORKAROUND_NVIDIA_CARMEL_CNP
 WORKAROUND_QCOM_FALKOR_E1003
 WORKAROUND_REPEAT_TLBI
 WORKAROUND_SPECULATIVE_AT
+WORKAROUND_SPECULATIVE_UNPRIV_LOAD


