Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040508;
	b=No2tc3CY2SVrdUeyzIq92cQeSGA1zbv968ml00vUoOX0IzL1LwLapJ2+ZPHisvDNz1HH
	 kWimxCD4Lv7WiI9TXf+ZxORS0aYhazUR3JCYgbTQVvAT9pGdIB8eVsvlp6pq+A56z+VAK
	 TPxKKdPc59SFDu9OLVf56+Gp3gCcjw/RNsR3SUSgz+4Qqh+y4x/Ye1I06g5z0PIzifmhk
	 fV/2nN1RGP3aSdkhnxK9MuKtWa+MZ5GKGffMzBJPtQ9uvaWlZqIilrLEiS6XwFoklsFuX
	 aZ600RGYaplZ/5lQtXM+8Tu44I5NmqGFl1tu44wNidiPCpf2tsL5AmcWir2DLbzdN0w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040508;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1MEdJbQgaHW5PcBgIsTcLzxSeKWemMbi8VCcrfrj9ng=;
	b=daCa48p3IzL3RAxbC4T6DD437/Eqj04SXDIKx69Ht4kkqh3h4PKpuu5DHpERYzhuG11A
	 RNvNh6EKwSqQfGZ0ZQ26wFd8DH6d9B7e7UJQ2cTwRirTXHsfUY2FzPsyHpYdE1+wd2VnF
	 FpfxRxxv00E4aGDfnidj4HltppcEuBs1s6r0QbGgeeSjofq7yxAohX308BkHb6fO6K48g
	 4E9J2OGqKyid4/lPnPaut9PhhY2fXwn8zw97B24oEVHOaoUgLZ1YkARyiHHxrfq8Kumou
	 xqdMig2vxDn0fAUc/1FMML6Ne5IyoBe2HaUpdHJsCyTCKHROP+TbX+ca6rFgXDEYo0A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dobmMquk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34A97606A31C;
	Wed, 18 Nov 2026 22:21:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dobmMquk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C2781F000C4;
	Wed, 18 Nov 2026 22:21:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040507;
	bh=1MEdJbQgaHW5PcBgIsTcLzxSeKWemMbi8VCcrfrj9ng=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dobmMquknSIRhAvaTSSaektqSih4gjz4MKTfLTWaDhw45jO2zV7r7XtAtP7MzaDl9
	 y1FewUHfPiCYzvwqwRciwmr4t0mbC8re0fcxAICOa+ZtylDHu6Xtt1fD0i/FTZiiT3
	 l+nfGbY+Q1feL5N5xuqUkbPieagRA9rxhPwMOtpI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qingfang Deng <qingfang.deng@linux.dev>,
	Gregory CLEMENT <gregory.clement@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2481/3318] ARM: mvebu: fix Cortex-A9 errata selection for Armada 38x
Date: Wed, 18 Nov 2026 15:51:43 +0100
Message-ID: <20261118150435.832977909@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 9f60a6fe0eafb..5203b5cfa4577 100644
--- a/arch/arm/mach-mvebu/Kconfig
+++ b/arch/arm/mach-mvebu/Kconfig
@@ -55,7 +55,9 @@ config MACH_ARMADA_375
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



