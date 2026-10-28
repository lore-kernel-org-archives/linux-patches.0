Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213078;
	b=FiV06jQuu7Dz4LpHQibEFrOzB/ii511GY5HfgTjjMvmSSZfPKLpwM8Q8w+SWfVqNRfPb
	 0U8IUKISbqM3irBKaX4KcNhX9ZbDkZYiOc1R50lAn8ri1UcJPTjnaXsX5vKhixmQPq+Vu
	 TDX3LwyZhSH0XhX239oFRfxy/ijrROB3+fbjNX3ES4ajpnu9xiFHwcK04CFpZHOz9a7P5
	 eMUdq+KGmRjBKzAgARiXNZYDrRFMq37w1LhiM+6ll4jkHirpR2fbSrNabMhyt625V0WkV
	 FkG3RfM/dyqCqnrxGZVaCom7R0QhP0qG6xBZM3eSi4LdsA7x8zBLhCwGOp9nTHvfXBw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213078;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dSZ7rbxMfCLuUjqxn02W3CU1rV3Uc/SkRiRWqp1aaCA=;
	b=QfhPWe0GQ6ky/rKt9SgVT/oT8Bp8jH4BNvkzG6oWLFP4+k84fpKGOL7O1KASyrt5gjSq
	 XAUNh8TmDRVVzNobEexWxVYM6gJJGls0/Y3xpz4X5TV38EloodYtYQjt8+5f9OttQzQWv
	 yLlVpD919U9zCHwlNEmgA1eElfS7OiCJhL4NWNiGY2pN1zzZTPTPXp/fCanGURRboT6xL
	 ZFgNB/Ux+ckAjbd/noS+awr//s6T65pFTqWrU+K4DfTNqeDtBexuCcYioHQCXIDG+o1aF
	 E78wCsVYG90Hy5GVY/s9aTACqiXiO6zMhsjIE93mwLnFBI2mV7pl0s2UvpLOUZZOFaA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vmAkTm8g;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96830606A31D;
	Wed, 28 Oct 2026 18:44:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vmAkTm8g
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E44341F01828;
	Wed, 28 Oct 2026 18:44:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213078;
	bh=dSZ7rbxMfCLuUjqxn02W3CU1rV3Uc/SkRiRWqp1aaCA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vmAkTm8gWwoK25QX35Ot51NAuZOxvfg1Mugkq2yfGW7rWcMDLGpdJguF1VWNjLCa9
	 aWZLLXDTss1VKtQVK80tmekDhYe0HzixGwc1SNVpDVymhY2FF6I4sKIZ8enxAtqM+9
	 JqcneQEpdyhE05CphGaUJwoxx19uZww9gbx+Pv7g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Beata Michalska <beata.michalska@arm.com>,
	Vladimir Murzin <vladimir.murzin@arm.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0378/1887] arm64: errata: Add Cortex-A725 erratum 3821522 workaround
Date: Wed, 28 Oct 2026 17:41:14 +0100
Message-ID: <20261028170507.832894396@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Beata Michalska <beata.michalska@arm.com>

[ Upstream commit 45f7304679875eb000d67e194090ee7abd05c89c ]

Cortex-A725 erratum 3821522 affects the CNT_CYCLES event, which can
incur a significant increment error when a CPU enters and subsequently
exits WFE or WFI, and may no longer track the system counter
frequency.

The AMEVCNTR01_EL0 counter is used as the AMU constant counter for
frequency invariance and CPPC FFH feedback counters. Wire the affected
Cortex-A725 range into the shared broken AMU constant-counter capability
so the affected counter is treated as unavailable by returning zero in
the AMU counter paths. This prevents the broken counter from being used
as a reference source.

The erratum can also affect PMUv3 users of the CNT_CYCLES event,
but this workaround intentionally does not change PMU event handling.
Hiding or rejecting the PMU event from the erratum code would change
the perf-visible PMU event interface, including raw event selection,
and would need a separate PMU-specific approach rather than being
folded into the AMU reference-counter workaround.

Cc: stable@vger.kernel.org
Signed-off-by: Beata Michalska <beata.michalska@arm.com>
Reviewed-by: Vladimir Murzin <vladimir.murzin@arm.com>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Beata Michalska <beata.michalska@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/arm64/silicon-errata.rst |  2 ++
 arch/arm64/Kconfig                     | 22 ++++++++++++++++++++++
 arch/arm64/kernel/cpu_errata.c         |  4 ++++
 arch/arm64/kernel/topology.c           |  9 +++++----
 4 files changed, 33 insertions(+), 4 deletions(-)

diff --git a/Documentation/arm64/silicon-errata.rst b/Documentation/arm64/silicon-errata.rst
index fe7b90ac52d7b..74ae9e4f637a7 100644
--- a/Documentation/arm64/silicon-errata.rst
+++ b/Documentation/arm64/silicon-errata.rst
@@ -155,6 +155,8 @@ stable kernels.
 +----------------+-----------------+-----------------+-----------------------------+
 | ARM            | Cortex-A725     | #3456106        | ARM64_ERRATUM_3194386       |
 +----------------+-----------------+-----------------+-----------------------------+
+| ARM            | Cortex-A725     | #3821522        | ARM64_ERRATUM_3821522       |
++----------------+-----------------+-----------------+-----------------------------+
 | ARM            | Cortex-X1       | #3324344        | ARM64_ERRATUM_3194386       |
 +----------------+-----------------+-----------------+-----------------------------+
 | ARM            | Cortex-X1       | #4193791        | ARM64_ERRATUM_4118414       |
diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 370bde2b2b07b..1b8ee28f23830 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -991,6 +991,28 @@ config ARM64_ERRATUM_2457168
 
 	  If unsure, say Y.
 
+config ARM64_ERRATUM_3821522
+	bool "Cortex-A725: 3821522: workaround for possible CNT_CYCLES increment error due to WFE/WFI"
+	depends on ARM64_AMU_EXTN
+	select ARM64_WORKAROUND_BROKEN_AMU_CONSTCNT
+	default y
+	help
+	  This option adds the workaround for ARM Cortex-A725 erratum 3821522.
+
+	  On affected A725 cores, the CNT_CYCLES event may incur a significant
+	  increment error when entering and subsequently exiting WFx.
+	  As a result, the CNT_CYCLES may diverge from the system counter
+	  frequency at which it is expected to increment.
+	  This renders the AMU counter AMEVCNTR01, that implements CNT_CYCLES,
+	  being unreliable and unsuitable for use.
+
+	  Since there is no hardware workaround, reads of the affected CNT_CYCLES
+	  counter return 0 in the relevant paths. This causes users of the counter
+	  to treat it as unavailable and is functionally equivalent to firmware
+	  disabling the affected counter.
+
+	  If unsure, say Y.
+
 config ARM64_WORKAROUND_SPECULATIVE_UNPRIV_LOAD
 	bool
 
diff --git a/arch/arm64/kernel/cpu_errata.c b/arch/arm64/kernel/cpu_errata.c
index 518e3b6877b53..660b3ff16ebc6 100644
--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -280,6 +280,10 @@ static const struct midr_range workaround_amu_constcnt_list[] = {
 #ifdef CONFIG_ARM64_ERRATUM_2457168
 	/* Cortex-A510 r0p0-r1p1 */
 	MIDR_RANGE(MIDR_CORTEX_A510, 0, 0, 1, 1),
+#endif
+#ifdef CONFIG_ARM64_ERRATUM_3821522
+	/* Cortex-A725 r0p0 - r0p2 */
+	MIDR_RANGE(MIDR_CORTEX_A725, 0, 0, 0, 2),
 #endif
 	{}
 };
diff --git a/arch/arm64/kernel/topology.c b/arch/arm64/kernel/topology.c
index d61d1afdee158..61df0918585ba 100644
--- a/arch/arm64/kernel/topology.c
+++ b/arch/arm64/kernel/topology.c
@@ -268,10 +268,11 @@ static void cpu_read_corecnt(void *val)
 static void cpu_read_constcnt(void *val)
 {
 	/*
-	 * Return 0 if the current CPU is affected by erratum 2457168. A value
-	 * of 0 is also returned if the current CPU does not support AMUs or if
-	 * the counter is disabled. A return value of 0 at counter read is
-	 * properly handled as an error case by the users of the counter.
+	 * Return 0 if the current CPU is affected by a HW erratum.
+	 * A value of 0 is also returned if the current CPU does not
+	 * support AMUs or if the counter is disabled. A return
+	 * value of 0 at counter read is properly handled as an error
+	 * case by the users of the counter.
 	 */
 	*(u64 *)val = this_cpu_has_cap(ARM64_WORKAROUND_BROKEN_AMU_CONSTCNT) ?
 		      0UL : read_constcnt();
-- 
2.53.0



