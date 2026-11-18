Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061142;
	b=bqP1nKo9H8Og77dY4fm8mQyjrIRFbGPGenlGxl/Uw1M1YlWx+KfPh1pXpGIoiD9r7Eft
	 He5TFo2YhV8xDmp692LwxJ7MOo36X5uwfxqGHjE8/Ol16vrzMfv2+BLg0BagUSWwD0LDc
	 JGeVMDLULhpE21M1I4oNwG+bNDWDMxNNLC8l+bJjivG2yQ4dRb3yYBqt3xn6ltpPyDgCN
	 6XpqTXBaWnvF4gjIJ1/2OOLVvQTpYQ6ts88TyZ6I1zCmusfNujRql7+lW0wJN+p0x4jhH
	 4NHDheoToa5kPXVacMessoc3Vfkc/RTtptZC5ODvfqIuVRWc75NA5AWaoykKLIJ11sg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061142;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=87BpxMWLo5E8M2OpIf1s9qM7I52E2MzDs4xGM/h5/WY=;
	b=XDZsGezwdA7Pd0zyAa84j6mQYLUGbMEcZ60hrM6nyoNLnyPHcNA3q7BPPqE69eK6JwwC
	 LIEbodBsOa/8lPbRFNnK8prgCrGWMJbYanILTtYh4m+r1TSpOSokngtaDUFu0glbCwa5n
	 wO5xU0rS0D2DFNcNiSJ6RBwXibHJquV+f7HIaq4cbwuAUubGRASC6nUEuOWWCogTZ9+eS
	 1LVwCJNzJfKfBVWB0pTSAClLbXWmh5Llh3Ax9lq+EpZ+voiGR4V+xY+FQkLnUaWgp5CA/
	 IaonRtL9e/n5p6XjltQGZSx9cVpOm/ngt87pUHCi6xoqppU39QzEN5XzxjiU3MTwE9g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=niRxMxrF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9325D606A320;
	Thu, 19 Nov 2026 04:05:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=niRxMxrF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2BA71F000C5;
	Thu, 19 Nov 2026 04:05:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061142;
	bh=87BpxMWLo5E8M2OpIf1s9qM7I52E2MzDs4xGM/h5/WY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=niRxMxrF43yWyjRBKlLgzi0g2P7pCRzRNEddJzQ0p4iHGS2ykAgRJXj3FBCYm3Uf6
	 IJZnok2UuKnVK74unr+qF34BsiHxYirWMk+Nmgn9wCPciqswcaC0/f58tYxvi6J/TI
	 /VE6NuOg1M71s93Y/yW6PJCoLQ6GcRquXv4VfSrY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qingfang Deng <qingfang.deng@linux.dev>,
	Gregory CLEMENT <gregory.clement@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1420/1848] ARM: mvebu: fix Cortex-A9 errata selection for Armada 38x
Date: Wed, 18 Nov 2026 15:57:38 +0100
Message-ID: <20261118150018.919360507@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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



