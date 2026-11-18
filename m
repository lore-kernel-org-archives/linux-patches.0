Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025030;
	b=pkKuJhHQX0H1FPCVnuq298Es5jM5cjSSic5D18C35aFMXpVimQO4pfcQg2yzwFJvMO9A
	 KqFnFhl3xcN9FMbFBGvF3rL/CgOA3KMIsAsKqH1gujCfg1Bb9E5IC8YDNjDD+zg7aOBkQ
	 RRpyuE94T8yLnV1I3pjt0r2mtdOH/0FFl79/lPfwLkX5bVv2wc0N0nnLfPDN+YCit9cmV
	 RA5LPP3QSbecr/6Qa2NpoJi5S6MADLE/jrFBQRcZto4y+sINLCJkrU45CUokAtLfbaPuN
	 mrnbn3TEDuWlmD/CJx6wRLHjTTgzfA/lPp7TeNdeRrYW0c+IGNkZkqdDOCwxdDXYcDw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025030;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FEYWv5JeMdVzEkwAnnyHIhGFT+YWB05NX39m4Hwdeqw=;
	b=UGo/1UXsNenUoZJ12juB5dSTE9XcRfdNWC+T4ZHbXszv/IEa1VJ2vpVmDaZ7PwE4evtw
	 7ozFvbbdO7Id0uBT4WTCRNUHSYXSzsAxaB8/Js5u4ZePnHcnG8nvpNeTdF4dYLdIzHv15
	 rpxGYgGJtWg49RGEtGX7FnB4IOCYZt42pSaey0BEK3OgJM2bB44w216KsrLU44A3fynz5
	 5qtxVlbfEC+789NEfz/Da0gv90XkmAX2yG+p4V4t6CDaJjaUrxuCbCAtATLwfSuHuraH9
	 lNphKfs9v7BPN9ZO8u8uZN7CKfKdBddveiWZYajMks03WIc6aaezU5QBbrt8Er2e/XQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Y4NI1fM8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93039606A330;
	Wed, 18 Nov 2026 18:03:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Y4NI1fM8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E45251F000C6;
	Wed, 18 Nov 2026 18:03:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025030;
	bh=FEYWv5JeMdVzEkwAnnyHIhGFT+YWB05NX39m4Hwdeqw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Y4NI1fM8xUJFA4rFObxaa1ljDSShjC+4FR2Hw56jE+jeaFQjrdG2Fc4g1F9W3qu5F
	 +dgUSdixCG6QspttoDnuWo1MW0Ntp02lMFjnlTTLpHjbUJS15VI08WBXK/M2l52ZeY
	 8ngf2Szsl3ncUzOf1WBUk5isWUZ4vPlNFZYS+nIs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qingfang Deng <qingfang.deng@linux.dev>,
	Gregory CLEMENT <gregory.clement@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0910/2151] ARM: mvebu: fix Cortex-A9 errata selection for Armada 38x
Date: Wed, 18 Nov 2026 15:44:05 +0100
Message-ID: <20261118150155.536437463@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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



