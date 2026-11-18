Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017987;
	b=yt67NgC2KB9lr86ZlOwBRNM0VQaOviENYfqDaYp3CatCm9lThLcma4KUYx/3B4im5cRd
	 9aInDQPxQ6zqPZa/8x555naWOff6YHfJNwXfXN0CVpGPB0lgm9LAdSxCAI2khKaD4FKOb
	 0er+x/IRDkLs/DUxUgkjNDqTdqKyrQt+gRIZumWR4dsevlcX2r3xhKrJDWq4u/lgN+/A+
	 v8PxcmL7vJQgP3BcooFf143mr8nmChpN7X0MWCtofsSQ+Yw3FSzqkuVQQyOP9eyATUDJM
	 D4cUEWlTysu74bFANzQqWm3LetcoNxO3/mluC3FozbGi7vlbpng+e0rs2QEEXyHrq1Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017987;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=TZXuHyxDsDSVoCxXWL5MLWYGoA4/aA7Y/49lwMzYsZs=;
	b=epPdifZ3h2yfSI8/S/jm/b5lizmSw301ZsIPSwkDqUZJZSqFpYfUbQv+tndryFQTfjid
	 SZnqrCIn6tBLKpdUvPtEkHhcRWZq++35csJKuhibXKrQh66LFNNcPsmhpef2Zdoiq8Ias
	 CuSkbFY6N6IQkmIGLYl6hwlF7FAUjHFSEpnunhOqrN0eAxxll3Njw4k5q5b09S4vE2fRv
	 HjQjZ6xlLIkubnDvNbdG8cUn6i4FwFEk4gaGX3mgTEvfdsMAIA6y7mnNwwHV5+1exw9/y
	 dgNHAJcwTyuuq3PTVkPw81yXUe9/sVvb19GvFzHqtlVp4Zs9KwDNkIjmhaQWO+xQOoA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TO25c+X4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6254B606A31C;
	Wed, 18 Nov 2026 16:06:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TO25c+X4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B42021F000C4;
	Wed, 18 Nov 2026 16:06:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017987;
	bh=TZXuHyxDsDSVoCxXWL5MLWYGoA4/aA7Y/49lwMzYsZs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TO25c+X4xmHQKsYGET24towwbel4ZVFnxZK+iN283RC6126bzqu/EvF6Yis5i92rd
	 caBSEVUMh3frZsPj8DXVVqukTwbPiGGQY2lsKvJIwkGFGdK85348ao53Ef6/yRb54T
	 BOMFyohH8Bow6RuFXQwi+/6BK0wsRgaFHI6pGpsE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qingfang Deng <qingfang.deng@linux.dev>,
	Gregory CLEMENT <gregory.clement@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1079/2651] ARM: mvebu: fix Cortex-A9 errata selection for Armada 38x
Date: Wed, 18 Nov 2026 15:38:39 +0100
Message-ID: <20261118150326.841356277@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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



