Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048885;
	b=r+fhWWcxj5ZsrlBltpMK6wi726CB7Byp4YrZyE5/CwTKrg3jXe03P30aBYhd+/Lja0IQ
	 A2Pav/xKJWBn/U6i9dy/BiPS1xuOGOk7bW3ljF1BkKFkU8jryFB42Q4wgpcFlRWiAoa8w
	 +JqzxhoNu/w0UEQ+4YBYOl6y32KbyIGT08JFG/OzlTQj3kIkD8FTzMyUzwJns2EVXUlVE
	 fnxxj5Ez9Rqwx7zoy3N2h+CWQ61kJVuJTGy67n7W0vnqiUqSKglt/n/o/BQ1kPQhWl2yj
	 DjBwaCBz3YwfeftaxV+UFcgM2sY5kx/8xb4d19QWtVQLkIxlKZWqYzXmq1NW1YTLclg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048885;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ARsL+x8p8F40VB25urBmy6K8AGGAw5ByQMUHmaElapU=;
	b=eh4Z6rGCQUaiBTJyOhaezc+BF7kySS5CgNgTwW1HwqinOM0wh1YDg2v/XE9tTSUmaeEz
	 dOzVLRVv3155bZhxv91XwK8xMOat92qeTAmIMaCrpRbhUrH9M3SNHc5jE9hPJaWElGs/a
	 SINkaQhSBsdp0tL6Ez0Q951P5y13s2gp5reDNxGO/ar3r2Lu9zBtnBZmnyy4Ahh64Uzmi
	 9/FKFgZt33mbCpnRNOKrH/vUcIGkELul3vEhuajhIewtX0u66q7FwYkHr2G2cAUmK1N7h
	 2uBNtUKVDzDkpg6ncAP5m5XwCXnVwH7rZbFn0UbZJtCGHMDqkJvSNISqwINHc0Zj/mg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ey1Wbt5U;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75579606A31C;
	Thu, 19 Nov 2026 00:41:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ey1Wbt5U
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA5021F000C4;
	Thu, 19 Nov 2026 00:41:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048885;
	bh=ARsL+x8p8F40VB25urBmy6K8AGGAw5ByQMUHmaElapU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ey1Wbt5UIpm6XSv0Gvkb4kH+2UkOchY1pFfFUl+1BnJu7nc2cN7SltfIXz50elKMB
	 LK7tCuOpSR6Ut447lvzqyOEbxgFbVUdUv497YZ1+vDlFdWXKbB8CnQfQHYXmj/57aA
	 rEqVk9RYa+gujTAGml+AUVPxM2AjBUTl/7CKq9pY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qingfang Deng <qingfang.deng@linux.dev>,
	Gregory CLEMENT <gregory.clement@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2153/2857] ARM: mvebu: fix Cortex-A9 errata selection for Armada 38x
Date: Wed, 18 Nov 2026 15:53:07 +0100
Message-ID: <20261118150318.915650200@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



