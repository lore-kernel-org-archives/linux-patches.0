Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618573;
	b=d7hiMeYoMxuDfITBtOOQoI0TQWSqtEcB/qmHvRGYfyoaJotdvupQYu51L4H35hHEfQGD
	 Bfw37UaN+97JY0/SMKOLxR3ZQjlGzSJlthCcHk2gODvW1/dp3KILI8uYBYokUbAFqDlOv
	 6HtHBqEpCyKL6xBum2Fz+0dcd9xTbxiKjWXjgCRNS74A776gMf1V+NB+Kr40mku5huhAS
	 7IK8+iaZTtphSMeqIH93pmNQwOPNMiBRKSuisKw7ODT/eGK4gRZPB3D396N2wNXcLXF7D
	 CvXCqzpvW1rK7RnViCSGDKrH8J3fw5CwyPn2Hno6rAUSOaHIyWDZz6dmI9aHyB6z+Dg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618573;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=MfgerO7GST83Uf1E/tFaR9EIiHFxfghobsQf2dKRSaA=;
	b=Vey+JolH7XGFYgyXjPdMfKcbpGnF8bbHFG9W15xNSub4YeC5IvXjGTH29JIdxJO1JO2E
	 /L+93+BPDfXYQ8ipalKDpGmCVSccdw5QZKqn58nT9zye5nLkWIN/P7I3iefyZUeWmdhbA
	 iUK/1b0cTL7S2l9SgrI3kDCrmv8/ZoZ3CL+oxd9TRoftIk91KFceYslDZlIRG+79mSaRc
	 dCtKFFrrLvuCUG9jWCTCljwhoq06yKyu37xpuopt+lPFPHLyFeFIq5WwiloLt4ih8mUZM
	 uQZevsS1WPnRlXcMC3lvEZ5C5O7BHEetUJo60qj2MHK0gOMqNXxmG0ZVsONyVyHTpJg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tMbErdMt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4168D606A687;
	Wed, 25 Nov 2026 14:56:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tMbErdMt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 098311F01802;
	Wed, 25 Nov 2026 14:56:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618572;
	bh=MfgerO7GST83Uf1E/tFaR9EIiHFxfghobsQf2dKRSaA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tMbErdMtjvJyiCMPOC0BYWd8oslhboPMofdQebgRMR3uKr2dEj1TM0Jmw8vuClu6F
	 AK6rYgOspMTiFdIq+0XLC38gnirzb9LBdU3olQbEJEsuBzhx+YP5fyO8UDsao3dMcD
	 2O/zDVvuLHgYWAg9LoXOrKZo6OPuMNRw9TKQO5QE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0323/1005] MIPS: Avoid dead code/data elimination when using recordmcount
Date: Wed, 25 Nov 2026 15:27:41 +0100
Message-ID: <20261125143829.300543239@linuxfoundation.org>
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

From: Rosen Penev <rosenp@gmail.com>

[ Upstream commit 255d9dbd936f7db8b963e82429f6e57cd9d48999 ]

CONFIG_LD_DEAD_CODE_DATA_ELIMINATION builds with -ffunction-sections,
placing every function in its own section. recordmcount refuses to use
weak symbols as section bases, as a strong definition could override
them, so a weak function alone in its section, such as the generic
pcibios_fixup_bus() stub, breaks the build:

  Cannot find symbol for section 88: .text.pcibios_fixup_bus.
  drivers/pci/probe.o: failed

MIPS always records mcount locations with recordmcount, so this hits
any config with the function tracer and dead code elimination enabled,
e.g. malta_defconfig built with LLVM=1.

Only offer dead code elimination when recordmcount is not used, as
powerpc does since commit f8b2336f15f3 ("powerpc: Avoid dead code/data
elimination when using recordmcount"). In practice this makes it
unavailable together with the function tracer on MIPS.

Fixes: c0436b503591 ("MIPS: Enable dead code elimination")
Signed-off-by: Rosen Penev <rosenp@gmail.com>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
index d7c67cebe065f..5538c8ef82250 100644
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -79,7 +79,7 @@ config MIPS
 	select HAVE_IRQ_TIME_ACCOUNTING
 	select HAVE_KPROBES
 	select HAVE_KRETPROBES
-	select HAVE_LD_DEAD_CODE_DATA_ELIMINATION
+	select HAVE_LD_DEAD_CODE_DATA_ELIMINATION if !FTRACE_MCOUNT_USE_RECORDMCOUNT
 	select HAVE_MOD_ARCH_SPECIFIC
 	select HAVE_NMI
 	select HAVE_PAGE_SIZE_4KB if !CPU_LOONGSON2EF && !CPU_LOONGSON64
-- 
2.53.0



