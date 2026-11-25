Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619779;
	b=FgUqiFbTtLyKaB7icFn49AOlg51TAXBj4fG0AEhk/43b/B+G98Zq/WPhdQAJHegkbfDY
	 tM2qj4dbcQzqqc9nZZbgXscKJY9kiO7FOkC+4ZCQO9vubXoBiCOndo+xli3Htp9vlEsSq
	 UjfKqnGoqCdrXRSBIfvQMt++GdckLUS6hgZGmvl3zZdO670NgbxPr060RIOVyMSeQrNSe
	 le4ixTP2eGLuNjioVWUYaBq0OHITorGZ+3SU6kqpwQMjU70xLuNVyZa51Tg7+Bh6a2JYE
	 r4eKaCi+sdAg+FSCQ8WGExUUCKTFE43hZ+3VzWSuqWY+JMnpVpvfKMviUkmpJqLG3Tw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619779;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=yhf1NiNLQjmgjFGBa3EWZBNssIi/QG0O+lYxh+JaFzs=;
	b=re/3pkS0OkoPzOJ6O5fV0y2zwo28/o52oHJpZJCPrBEGs4P2fiHU7MYVLY7I2OGdI5D8
	 RIUmIMPKur5tUqyGtD9T7v75JpgIyQC8tP+8u+Y0OyMKlP9K3kTifIcLEb7TjbmhOoJq1
	 WiTGanW2MZDl/WZdPuNnhRQ7s3sY5TmxVrktLYyurbrD/2CcpxOabfdZRXbyHpqTbkmOb
	 iyv+MWkr/kpQldAb7n4SXp4AvAML4S95IDKr9l5U1GLmmjnBaFLn+OzpLhrZoK1ilxB1J
	 Ro1rrLZeyk0JO+NjRH4ZAzL0dhfZ3DMtpXZAQVMpSNMPDgICJ8zThGswGIJOl7XLgYw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=itWzyYfj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 762FB606A326;
	Wed, 25 Nov 2026 15:16:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=itWzyYfj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FAE81F000CA;
	Wed, 25 Nov 2026 15:16:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619778;
	bh=yhf1NiNLQjmgjFGBa3EWZBNssIi/QG0O+lYxh+JaFzs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=itWzyYfjmweB78CC9BhQ0DEsGdudQ9p8IRkvh0lrJ7avMzQprDKBE3cCXmxBu3gAu
	 8EAvGkwKQBOWZgLu2NBQK1atK2go2qrRGB1WMyStDmhFIXiyOKtH5D7kv5THwjgfsJ
	 vCZSAMakgOv/FwNtIbezQG9uUE4G0J8CyZ3npbEA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Beata Michalska <beata.michalska@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH 7.3 0706/1005] arm64: errata: Extend the workaround for broken AMEVCNTR01 counter
Date: Wed, 25 Nov 2026 15:34:04 +0100
Message-ID: <20261125143838.297646584@linuxfoundation.org>
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

commit 139a9b7d5a07a570d5f636db02105025ece99e16 upstream.

The erratum causing significant inaccuracies in the AMU CNT_CYCLES
counter due to WFI/WFE has been identified in additional
microarchitectures.
Extend the existing workaround to cover these implementations,
which are affected by the following errata:

 - ARM Cortex-A725 erratum 3821522 (SDEN-2832921)
 - ARM Cortex-A720 erratum 4689339 (SDEN-2439421)
 - ARM Cortex-A720AE erratum 4689340 (SDEN-3090091)
 - ARM Neoverse N3 erratum 4689341 (SDEN-3050973)
 - ARM C1-Pro erratum 4689344 (SDEN-3273080)

Cc: <stable@vger.kernel.org>
Signed-off-by: Beata Michalska <beata.michalska@arm.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/arch/arm64/silicon-errata.rst |    8 ++++++++
 arch/arm64/Kconfig                          |   12 +++++++++---
 arch/arm64/kernel/cpu_errata.c              |    8 ++++++++
 3 files changed, 25 insertions(+), 3 deletions(-)

--- a/Documentation/arch/arm64/silicon-errata.rst
+++ b/Documentation/arch/arm64/silicon-errata.rst
@@ -172,6 +172,10 @@ stable kernels.
 +----------------+-----------------+-----------------+-----------------------------+
 | ARM            | Cortex-A720     | #3456091        | ARM64_ERRATUM_3194386       |
 +----------------+-----------------+-----------------+-----------------------------+
+| ARM            | Cortex-A720     | #4689339        | ARM64_ERRATUM_3821522       |
++----------------+-----------------+-----------------+-----------------------------+
+| ARM            | Cortex-A720AE   | #4689340        | ARM64_ERRATUM_3821522       |
++----------------+-----------------+-----------------+-----------------------------+
 | ARM            | Cortex-A725     | #3456106        | ARM64_ERRATUM_3194386       |
 +----------------+-----------------+-----------------+-----------------------------+
 | ARM            | Cortex-A725     | #3821522        | ARM64_ERRATUM_3821522       |
@@ -230,6 +234,8 @@ stable kernels.
 +----------------+-----------------+-----------------+-----------------------------+
 | ARM            | Neoverse-N3     | #3456111        | ARM64_ERRATUM_3194386       |
 +----------------+-----------------+-----------------+-----------------------------+
+| ARM            | Neoverse-N3     | #4689341        | ARM64_ERRATUM_3821522       |
++----------------+-----------------+-----------------+-----------------------------+
 | ARM            | Neoverse-V1     | #1619801        | N/A                         |
 +----------------+-----------------+-----------------+-----------------------------+
 | ARM            | Neoverse-V1     | #3324341        | ARM64_ERRATUM_3194386       |
@@ -254,6 +260,8 @@ stable kernels.
 +----------------+-----------------+-----------------+-----------------------------+
 | ARM            | C1-Pro          | #4193714        | ARM64_ERRATUM_4193714       |
 +----------------+-----------------+-----------------+-----------------------------+
+| ARM            | C1-Pro          | #4689344        | ARM64_ERRATUM_3821522       |
++----------------+-----------------+-----------------+-----------------------------+
 | ARM            | C1-Ultra        | #3683289        | N/A                         |
 +----------------+-----------------+-----------------+-----------------------------+
 | ARM            | C1-Ultra        | #4193780        | ARM64_ERRATUM_4118414       |
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -1083,14 +1083,20 @@ config ARM64_ERRATUM_2645198
 	  If unsure, say Y.
 
 config ARM64_ERRATUM_3821522
-	bool "Cortex-A725: 3821522: workaround for possible CNT_CYCLES increment error due to WFE/WFI"
+	bool "Cortex-*/Neoverse-*/C1-*: workaround for possible CNT_CYCLES increment error due to WFE/WFI"
 	depends on ARM64_AMU_EXTN
 	select ARM64_WORKAROUND_BROKEN_AMU_CONSTCNT
 	default y
 	help
-	  This option adds the workaround for ARM Cortex-A725 erratum 3821522.
+	  This option adds the workaround for the following errata:
 
-	  On affected A725 cores, the CNT_CYCLES event may incur a significant
+	  * ARM Cortex-A725 erratum 3821522
+	  * ARM Cortex-A720 erratum 4689339
+	  * ARM Cortex-A720AE erratum 4689340
+	  * ARM Neoverse N3 erratum 4689341
+	  * ARM C1-Pro erratum 4689344
+
+	  On affected cores, the CNT_CYCLES event may incur a significant
 	  increment error when entering and subsequently exiting WFx.
 	  As a result, the CNT_CYCLES may diverge from the system counter
 	  frequency at which it is expected to increment.
--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -391,8 +391,16 @@ static const struct midr_range workaroun
 	MIDR_RANGE(MIDR_CORTEX_A510, 0, 0, 1, 1),
 #endif
 #ifdef CONFIG_ARM64_ERRATUM_3821522
+	/* Cortex-A720 r0p0 - r0p2 */
+	MIDR_RANGE(MIDR_CORTEX_A720, 0, 0, 0, 2),
+	/* Cortex-A720AE r0p0 - r0p1 */
+	MIDR_RANGE(MIDR_CORTEX_A720AE, 0, 0, 0, 1),
 	/* Cortex-A725 r0p0 - r0p2 */
 	MIDR_RANGE(MIDR_CORTEX_A725, 0, 0, 0, 2),
+	/* Neoverse N3 r0p0 - r0p1 */
+	MIDR_RANGE(MIDR_NEOVERSE_N3, 0, 0, 0, 1),
+	/* C1-Pro r0p0 - r1p3 */
+	MIDR_RANGE(MIDR_C1_PRO, 0, 0, 1, 3),
 #endif
 	{}
 };


