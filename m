Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208883;
	b=4t7wdMTBk3MA/m3AclW9m1dDSQgiC9hd6P/Sdr182pp1IL7/d4jDlVnDSAbKpqz3FPZK
	 8qhjMOLybb19ZBnejMedbQwlVvb5DCWqFSwttjhuJNsznnOXNnvkS/1+lIiAMuejt34Ps
	 dTytNhiLeKOB88T/uFRdq6UIc/m+ZYvf8+w18pX+d/tkbKxt4OSRHPVopsviCrWm8h7hy
	 frjqH7BM8PIAwo5AqvvPW0V4lXZvgMRZshRksMzATXEYdi8y2F7gAZnQReXJtfox2x/DQ
	 HiAoinDi/qlao4V4sjLBRNRBNz8xf81vL95Swzblgrk8/5YE6Qeh/cde8c8HFWKrR6Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208883;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=s9Kj+ZBdIzm6kCPV0mm74Q1HFoA1vMKq/BL9MlvCN4o=;
	b=F6hsVoGRpVjWS3yenUn0H6Gdx/4SQ4Cal1ns0mFe5xt4ErX//1xWMvHE/ecls1z5dbfq
	 RypWn40dQpWAw8aJju4iJaCiZCI33XkmHkWStBsmi9a4/t6pPptmX9VYRkYCtEf2r0LVz
	 UU7OfaRndBOfeG4PrQL7u9k/XCciW3vWvK63IB5314ihrDORinB9BrHsgnVhLsgrwQ8U6
	 KIaq9sgNMnyY1/LnazKSWyo2+3AybejrcDez68v4h5jZL7QLp3K0rnhYd9ZjcT72v9u4E
	 0tutAmQOeHD7Pte1dW7GfH+un/bx3MCHWo0bHBZPW6lfz09BKK4Z4yXrl9hLpK7c9eQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rIUV4Daf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 780C4606A31D;
	Wed, 28 Oct 2026 17:34:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rIUV4Daf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3F351F01825;
	Wed, 28 Oct 2026 17:34:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208883;
	bh=s9Kj+ZBdIzm6kCPV0mm74Q1HFoA1vMKq/BL9MlvCN4o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rIUV4Daf9TpiOspxIghNOl9V0IyK2ckb8G+sS1Xxp/m148Mq+JE1oAwO5Fr83o7Ec
	 Qb2TtkcHRH9WtkbJXdFkKn3XgvU9wQBoOIQF1iSbE08YBqPx0lhmtTMXf8WroQsWlZ
	 wqOZVEaiRw/qD0GaO5xTRqqpRreqXiAVzPhhq/98=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Beata Michalska <beata.michalska@arm.com>,
	Vladimir Murzin <vladimir.murzin@arm.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 274/516] arm64: errata: Add Cortex-A725 erratum 3821522 workaround
Date: Wed, 28 Oct 2026 17:57:06 +0100
Message-ID: <20261028170009.983896760@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
[ Beata: Drop the changes to CPPC/FFH support as those are not available here. ]
Signed-off-by: Beata Michalska <beata.michalska@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/arm64/silicon-errata.rst |  2 ++
 arch/arm64/Kconfig                     | 22 ++++++++++++++++++++++
 arch/arm64/kernel/cpu_errata.c         |  4 ++++
 3 files changed, 28 insertions(+)

diff --git a/Documentation/arm64/silicon-errata.rst b/Documentation/arm64/silicon-errata.rst
index 98d794cc16d73..01676230ee174 100644
--- a/Documentation/arm64/silicon-errata.rst
+++ b/Documentation/arm64/silicon-errata.rst
@@ -128,6 +128,8 @@ stable kernels.
 +----------------+-----------------+-----------------+-----------------------------+
 | ARM            | Cortex-A725     | #3456106        | ARM64_ERRATUM_3194386       |
 +----------------+-----------------+-----------------+-----------------------------+
+| ARM            | Cortex-A725     | #3821522        | ARM64_ERRATUM_3821522       |
++----------------+-----------------+-----------------+-----------------------------+
 | ARM            | Cortex-X1       | #3324344        | ARM64_ERRATUM_3194386       |
 +----------------+-----------------+-----------------+-----------------------------+
 | ARM            | Cortex-X1       | #4193791        | ARM64_ERRATUM_4118414       |
diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index ae4036d549fc9..086d2cd505264 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -699,6 +699,28 @@ config ARM64_ERRATUM_2457168
 
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
 config ARM64_ERRATUM_3194386
 	bool "Cortex-*/Neoverse-*: workaround for MSR SSBS not self-synchronizing"
 	default y
diff --git a/arch/arm64/kernel/cpu_errata.c b/arch/arm64/kernel/cpu_errata.c
index df83ff9a767d0..77ad3421d6923 100644
--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -265,6 +265,10 @@ static const struct midr_range workaround_amu_constcnt_list[] = {
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
-- 
2.53.0



