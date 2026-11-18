Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030484;
	b=s0VsknTLOUjfmWSJdKVsQhcjYgYiTVxrjIFPafvSLDu1RbflDLymykAXH7UvMGDs1Zby
	 AlzKqNTkYpNYCc2x6kpvIAY+HLexmy8c6x3WdlSFBYKbM0OsIzdkgj3/xEcmr3W2MCWn/
	 xUC5lThHViEPBObdARu9/Z1hjtE6PdVgpS0p4GL0/x/paHmGgmVxeT8HDHIL7Gy+PIHFD
	 fdQLVlnszKYctozvtuNe7xQ6dyPrhW2SWXGqbTYFdth5QyHZp+IO75+1Xq4viiAoiMF4m
	 W+D9KAsiBRwiluWz3NWG8YuLlyIY+DeKBZTo5v0TNHCclBQqpv5Sn+CRDwOFI68rgQw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030484;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ApGUeHmtQmKilBG4kgjoGOdQQRtkXWqGrDHdcJ34dog=;
	b=LNXjiIx0DofwBPBQcqoPZKmcuOomKFvsrJ+K8Ug0QGPqbr8n9kCA3Wlp5OeCVbj0svNk
	 a8ygJjeK1GgnQlmgw/pfp9BsCH4cUAqip8aH+blFPOwWfA7ze5zD/wocLYg1441LsjOeH
	 0oNxFNg486/fCjFeUTjRi587nh+KneFnoql3BPpkwpEnyjSwlGy8fG9Zd3qG1xsKHh/18
	 CJWvNppx69jafCDDGurMHJz380Fni90hJBN0Q/Bzn18R7YMAPaT5BZf/P1X1CkH5Za9th
	 FwuWbj6BwtanSkJyFkRtxJHAfc49J/pVSr0YqQcpbFgtYlj3VfPYkc5Rr+JEWNBBnog==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=q6BUaisR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2237606BB4A;
	Wed, 18 Nov 2026 19:34:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=q6BUaisR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 061431F000C5;
	Wed, 18 Nov 2026 19:34:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030484;
	bh=ApGUeHmtQmKilBG4kgjoGOdQQRtkXWqGrDHdcJ34dog=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=q6BUaisRkjdVHLvbOBZdhGY53Be0ft0F++lRGDjCDGLJJFvH6HIzCJVKT6l7nniJL
	 k4qQJG8jE8d56A8MOC4jutmt/8fz1s77taKwEEs8qjVjzYHwOfgUTjqIsYVzhELky7
	 7shLEw/E55/NmOU5P3++wmqHjEWHRYVI8Iz+I4A8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qingfang Deng <qingfang.deng@linux.dev>,
	Gregory CLEMENT <gregory.clement@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0720/1756] ARM: mvebu: fix Cortex-A9 errata selection for Armada 38x
Date: Wed, 18 Nov 2026 15:47:27 +0100
Message-ID: <20261118150038.318943732@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



