Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619782;
	b=iztOYZIJVMfvnwZ5bLC78qolUxXxmiK9QonaIkHWc3BYeFz88gpcg6rp5ksd2MCa1g79
	 gxMa3yev4HJ2gXxKb+9pfDQV1LynO159dCLQsm98AMxgP2E6WzUIC6XenBsDrjIheRevh
	 7mURJ4GEGbmE0iqb7BMM8dCWyUeJsQvF3cv3vCpDAWeIGXGsjhZQkPcW1Q2aQq5CEqm1m
	 bv7bGiZ7HUyAlNDlH5U4+a0zusxabTc39xPbGyPMoprZ4dhks5HHaEbFqS7zshmfXsEpq
	 AIviu/h/WEyLdbXJqsq2ztmWRZr60ETfmrh2ST7M228fcRERDNoBi/821ckFnb5vydw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619782;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=yIquymBxr8dV5egLyyBIpBs1JJxHVKXWrsovD0X/1Ks=;
	b=p9Cwxez0RP9idpcJ60sr0iYoTRUl8mlsXVaSk7h2HJWPCrcYVaa33rRzA3PSgHdBx6zi
	 Tlari3xml+veOa/9mqcPPQymywb3qKY66AapJDxKm5pIlC1Igfk628nFllltMT8n1MFs7
	 IhE7ycuIiQ2JFXmgxWLT0qx5kajrKHweSMqiaQz66w30vz8zo5x1H3x9OBZcQdWzfCgv6
	 J7OAchTxkDcADknqnMyMbVvK13+qqpoEdacbIwjQYHYYigM5QNoe9iuEwmPeysBV22zB2
	 ZViq2eha536VDynT9jqiZ6FOx4avJGCWsRd1IA22BDGX+5D2ioK7l5c9UITAvxt9/CQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dTMt8D6E;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39991606A31E;
	Wed, 25 Nov 2026 15:16:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dTMt8D6E
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64BA81F000C4;
	Wed, 25 Nov 2026 15:16:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619781;
	bh=yIquymBxr8dV5egLyyBIpBs1JJxHVKXWrsovD0X/1Ks=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dTMt8D6EGqzXOFG/7aTjhR9yBpHl/7GdxUt3w+QF72wcbVtdZGd0KfbT8mKGGfGeF
	 pXOx/CaER651Ir/5qnZ+6pmnp4BL/5LEddt+3H8k2Mvqmjd9RyCEXU8jRVtAMem8z+
	 I4KecV9EYBxLRDXS4TOZHNOeBkappLEUfn83WbsU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Beata Michalska <beata.michalska@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH 7.3 0707/1005] arm64: errata: Add Cortex-A715/A720 AMU core counter workaround
Date: Wed, 25 Nov 2026 15:34:05 +0100
Message-ID: <20261125143838.321348667@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Beata Michalska <beata.michalska@arm.com>

commit be777145858218f591b4d9d19f3d40d3ecea9de3 upstream.

On Cortex-A715 (erratum 2738462) and Cortex-A720 (erratum 2738461),
the AMEVCNTR00 counter may continue incrementing while the core
remains in WFE with the clocks being enabled. The resulting core
cycle count may become unreliable.

Add a workaround that effectively treats the AMU counter
as unavailable.

Cc: <stable@vger.kernel.org>
Signed-off-by: Beata Michalska <beata.michalska@arm.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/arch/arm64/silicon-errata.rst |    4 +++
 arch/arm64/Kconfig                          |   32 ++++++++++++++++++++++++++++
 arch/arm64/kernel/cpu_errata.c              |   20 +++++++++++++++++
 arch/arm64/kernel/cpufeature.c              |    3 +-
 arch/arm64/kernel/topology.c                |    3 +-
 arch/arm64/tools/cpucaps                    |    1 
 6 files changed, 61 insertions(+), 2 deletions(-)

--- a/Documentation/arch/arm64/silicon-errata.rst
+++ b/Documentation/arch/arm64/silicon-errata.rst
@@ -168,8 +168,12 @@ stable kernels.
 +----------------+-----------------+-----------------+-----------------------------+
 | ARM            | Cortex-A715     | #2645198        | ARM64_ERRATUM_2645198       |
 +----------------+-----------------+-----------------+-----------------------------+
+| ARM            | Cortex-A715     | #2738462        | ARM64_ERRATUM_2738461       |
++----------------+-----------------+-----------------+-----------------------------+
 | ARM            | Cortex-A715     | #3456084        | ARM64_ERRATUM_3194386       |
 +----------------+-----------------+-----------------+-----------------------------+
+| ARM            | Cortex-A720     | #2738461        | ARM64_ERRATUM_2738461       |
++----------------+-----------------+-----------------+-----------------------------+
 | ARM            | Cortex-A720     | #3456091        | ARM64_ERRATUM_3194386       |
 +----------------+-----------------+-----------------+-----------------------------+
 | ARM            | Cortex-A720     | #4689339        | ARM64_ERRATUM_3821522       |
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -1048,6 +1048,38 @@ config ARM64_WORKAROUND_BROKEN_AMU_CONST
 	# making it unreliable. As a result, AMU users should treat it as
 	# unavailable rather than relying on misleading counter values.
 
+config ARM64_WORKAROUND_BROKEN_AMU_CORECNT
+	bool
+	# Targeting errata affecting AMEVCNTR00, the AMU core cycle counter.
+	# On affected CPUs the counter may continue incrementing while core
+	# remains in WFE with the clocks enabled.
+	# This may lead to readings of said counter being unreliable.
+	# How much though depends on the sampling intervals.
+
+config ARM64_ERRATUM_2738461
+	bool "Cortex-A715/Cortex-A720: workaround for AMEVCNTR00 incrementing incorrectly"
+	depends on ARM64_AMU_EXTN
+	select ARM64_WORKAROUND_BROKEN_AMU_CORECNT
+	default y
+	help
+	  This option adds the workaround for the following errata:
+
+	  * ARM Cortex-A715 erratum 2738462
+	  * ARM Cortex-A720 erratum 2738461
+
+	  On affected cores the AMEVCNTR00 counter (AMU core frequency cycles
+	  counter) may continue incrementing while the core remains in WFE
+	  with the clocks being enabled.
+	  This may result in inaccurate counter readings, with the magnitude
+	  of the discrepancy depending on the sampling interval.
+
+	  With this workaround, reads of the affected counter return 0 in
+	  the relevant paths. This causes users of the counter to treat it
+	  as unavailable and is functionally equivalent to firmware disabling
+	  the affected counter.
+
+	  If unsure, say Y.
+
 config ARM64_ERRATUM_2457168
 	bool "Cortex-A510: 2457168: workaround for AMEVCNTR01 incrementing incorrectly"
 	depends on ARM64_AMU_EXTN
--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -406,6 +406,18 @@ static const struct midr_range workaroun
 };
 #endif /* CONFIG_ARM64_WORKAROUND_BROKEN_AMU_CONSTCNT */
 
+#ifdef CONFIG_ARM64_WORKAROUND_BROKEN_AMU_CORECNT
+static const struct midr_range workaround_amu_corecnt_list[] = {
+#ifdef CONFIG_ARM64_ERRATUM_2738461
+	/* Cortex-A715 r0p0 - r1p3 */
+	MIDR_RANGE(MIDR_CORTEX_A715, 0, 0, 1, 3),
+	/* Cortex-A720 r0p0 - r0p1 */
+	MIDR_RANGE(MIDR_CORTEX_A720, 0, 0, 0, 1),
+#endif
+	{}
+};
+#endif /* CONFIG_ARM64_WORKAROUND_BROKEN_AMU_CORECNT */
+
 #ifdef CONFIG_CAVIUM_ERRATUM_23154
 static const struct midr_range cavium_erratum_23154_cpus[] = {
 	MIDR_ALL_VERSIONS(MIDR_THUNDERX),
@@ -949,6 +961,14 @@ const struct arm64_cpu_capabilities arm6
 		CAP_MIDR_RANGE_LIST(workaround_amu_constcnt_list)
 	},
 #endif
+#ifdef CONFIG_ARM64_WORKAROUND_BROKEN_AMU_CORECNT
+	{
+		.desc = "Broken AMU AMEVCNTR00 (core cycle counter)",
+		.capability = ARM64_WORKAROUND_BROKEN_AMU_CORECNT,
+		.type = ARM64_CPUCAP_WEAK_LOCAL_CPU_FEATURE,
+		CAP_MIDR_RANGE_LIST(workaround_amu_corecnt_list)
+	},
+#endif
 #ifdef CONFIG_ARM64_ERRATUM_2038923
 	{
 		.desc = "ARM erratum 2038923",
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -2089,7 +2089,8 @@ static void cpu_amu_enable(struct arm64_
 		cpumask_set_cpu(smp_processor_id(), &amu_cpus);
 
 		/* 0 reference values signal broken/disabled counters */
-		if (!this_cpu_has_cap(ARM64_WORKAROUND_BROKEN_AMU_CONSTCNT))
+		if (!this_cpu_has_cap(ARM64_WORKAROUND_BROKEN_AMU_CONSTCNT) &&
+		    !this_cpu_has_cap(ARM64_WORKAROUND_BROKEN_AMU_CORECNT))
 			update_freq_counters_refs();
 	}
 }
--- a/arch/arm64/kernel/topology.c
+++ b/arch/arm64/kernel/topology.c
@@ -389,7 +389,8 @@ static void cpu_read_corecnt(void *val)
 	 * counter read is properly handled as an error case by the users of the
 	 * counter.
 	 */
-	*(u64 *)val = read_corecnt();
+	*(u64 *)val = this_cpu_has_cap(ARM64_WORKAROUND_BROKEN_AMU_CORECNT) ?
+		      0UL : read_corecnt();
 }
 
 static void cpu_read_constcnt(void *val)
--- a/arch/arm64/tools/cpucaps
+++ b/arch/arm64/tools/cpucaps
@@ -132,3 +132,4 @@ WORKAROUND_SPECULATIVE_AT
 WORKAROUND_SPECULATIVE_SSBS
 WORKAROUND_SPECULATIVE_UNPRIV_LOAD
 WORKAROUND_BROKEN_AMU_CONSTCNT
+WORKAROUND_BROKEN_AMU_CORECNT


