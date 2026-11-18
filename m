Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055597;
	b=y9T1DjnBAX4bDPolU6FvJwBeJLl3lxRNuBtCLNjGyhgAJ6UwJkocc+n1ZKNv/HiTcWAW
	 65qs2iw1IKXL6WKb7A0XHvsA334NapEAElUPFi/c6jRoqSVf+DyFBKanssCAV0Y4AzCem
	 2OTbzZsbh5kiU/Kc+Q64e3YPU5dqfNavFG6BoXLU8ne4OGnOPbDHkqsfwnz6UG7qhQvVC
	 OZhEbN/yZGCXB0KXGuFZ/znpEXSko/wTJgjhr+LVfZEhy5/BTJwGqlo4cDviRVldh77PS
	 NnHovXjZ4Ra0R1rsQSrFQkSTMpBL3OEPMsM98u1P98gc5Juv98uRvz5rVMngxnCKjxA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055597;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=TOfb0w8NmwtiZ4Qo66H9pukIh3H+f0WPKxjGUnps5TU=;
	b=SJNIG/O0FEiTSijAcKmCRv+DA2G4GrC0slK263aCL9aVTL+iJmbXjF8OawOzMlej9fCT
	 6y0T4rQ+3Pd8c4sXok7e+TZM56H7/t5MITrwJ1JibxGIyDFxogrMa0olqQ2DVYERyX6v1
	 xVKwHohPq4MZgzDxjs60NeIaVSUoLe0vV5SDJPgPLFJhuthLli0CKlanedTErrIbBq5j8
	 kF8ybdWMqEslbWXn5qSm8Y98eg7fbD70VNSpHwEBCs2hKKmFVICrAgYKHTyoxUw9cXITI
	 ZwzJMxZ/Fh+8AfBmK9zk3p2bXXXNo/46XwtODOoJvE4Rcjvxm6O2a+ZLLP9+EgaQ4XQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="eyP/0N/c";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0C72606A332;
	Thu, 19 Nov 2026 02:33:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eyP/0N/c
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA8661F000C8;
	Thu, 19 Nov 2026 02:33:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055597;
	bh=TOfb0w8NmwtiZ4Qo66H9pukIh3H+f0WPKxjGUnps5TU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eyP/0N/cvlBd2tSTK0Ssn1Oj3XlJ4dp78ohLelgQAesvR15eyMsBEwAT8F9UGYFUi
	 CFzMwFzSguizdbSGOPSTlG4kZkWqdeX3LmVHCFyBFzGxavEtZ9gTeEfI+WTudnhAHl
	 iqfQjAT/Km6jEFrC28z2ZBEKMxJ8R0WRFIsp1U+Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qingfang Deng <qingfang.deng@linux.dev>,
	Gregory CLEMENT <gregory.clement@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1689/2214] ARM: mvebu: fix Cortex-A9 errata selection for Armada 38x
Date: Wed, 18 Nov 2026 15:56:05 +0100
Message-ID: <20261118150119.391914004@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qingfang Deng <qingfang.deng@linux.dev>

[ Upstream commit 76e67df8bc1cb72157368c3669119e64cdb0a6a6 ]

Armada 38x uses Cortex-A9 r4p1, but MACH_ARMADA_38X selects the
workaround for erratum 720789, which was fixed in r2p0, and omits
workarounds for errata that still affect r4p1.

Drop ARM_ERRATA_720789 and select ARM_ERRATA_754322 for faulty MMU
translations following an ASID switch and ARM_ERRATA_764319 for
unexpected undefined instruction exceptions when reading debug
registers. Also select ARM_ERRATA_764369 when SMP is enabled to work
around cache maintenance by MVA failing to reach other agents.

The Cortex-A9 r4 Software Developers Errata Notice (ARM UAN 0009D)
lists these errata in sections 2.3.3, 2.5.10 and 2.3.4, respectively.

Link: https://documentation-service.arm.com/static/608118675e70d934bc69f143
Fixes: 9aa30f1c13d1 ("ARM: mvebu: add initial support for the Armada 380/385 SOCs")
Signed-off-by: Qingfang Deng <qingfang.deng@linux.dev>
Signed-off-by: Gregory CLEMENT <gregory.clement@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mach-mvebu/Kconfig | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/arm/mach-mvebu/Kconfig b/arch/arm/mach-mvebu/Kconfig
index 34dbeaab94b07..a986c1b2bdf95 100644
--- a/arch/arm/mach-mvebu/Kconfig
+++ b/arch/arm/mach-mvebu/Kconfig
@@ -56,7 +56,9 @@ config MACH_ARMADA_375
 config MACH_ARMADA_38X
 	bool "Marvell Armada 380/385 boards"
 	depends on ARCH_MULTI_V7
-	select ARM_ERRATA_720789
+	select ARM_ERRATA_754322
+	select ARM_ERRATA_764319
+	select ARM_ERRATA_764369 if SMP
 	select PL310_ERRATA_753970
 	select ARM_GIC
 	select ARM_GLOBAL_TIMER
-- 
2.53.0



