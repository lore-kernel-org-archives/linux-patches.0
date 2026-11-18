Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030287;
	b=qzjbyNvB8uXoSs8RShLhqdsROqNjzs7DEZ3VUX3Hmi9XyKjA+m0Byn7JgLRtu3zweLGy
	 qH0aMTH12/Eori3ZdvvZxQEDxmEW2GnQXPoDy5BGdVvEsCY9PUvSfoq/L/o23uErXtFLx
	 TXuZoiuHmekWtSVo7slldCfDvcO0kaX+qXGOLmVK83b8K8I5hxMv5mZTXjbEDauP9rKfZ
	 ZglsH7jBV6guo2esgdDrfZ9VZr2H3451zC8u5YMV1qowm+FGFcQFEItFg2lD4HUDzu3fB
	 5PrvRxLzHQODF5JOI5XpQpK36bHoenXlIyzqo8vVmbOkNKwLzxjM4zTSUrgJuwFP7/A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030287;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kNd8qoE3PufsPravOCLa4F8JuEmEb0hhm/MxCqqLqno=;
	b=X6kFK7mVp2WEX/20OhjEXgLfrR37n/o+CJ9y3q/sh8uOjqS1JfQDwMIfZ56JjC7q5EV4
	 LwnrpriKN+jZdCVuQULzKcIFrkVSYZCJ4j3gPpe4wdqxMBmU3/tGHW8CLBQxV5pSaKK7Q
	 JB0c1P7dQd4ZuYyumppBLDtiAlWu7XNz0+cE77KMqZM3AhvuUByhTTfknbQy7AIfXlI9T
	 /DYQJaiMU70WZgFWKxjL08MJtk+iEpBD5TycbUDPA2NiEO8wF1ZMlFTbYxIA2U6RdPG7d
	 nUVl7e0DcHoQafyDVaQEARRWVBEnF7o4wiXVNuk31gwrUvmvEdKQ5cu9LKIj6Kxti6Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lePkvVIQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03F3B606A909;
	Wed, 18 Nov 2026 19:31:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lePkvVIQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 564BA1F000C4;
	Wed, 18 Nov 2026 19:31:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030286;
	bh=kNd8qoE3PufsPravOCLa4F8JuEmEb0hhm/MxCqqLqno=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lePkvVIQJA9iDF4rBQrLxIYbKKY5+d+u+6H0ZJ5tmSWZzlAGJG9077pfELgSC49i0
	 nCw1bavsrxuWCa4Vy5EpINr4uIX7Aom+TKOx/zKAdKsVc0urLA462rwI7p1WMp/MQF
	 jvZZTNtEAP1AoSnyN8Mt5PPzWi8ynrX4FtSeIEPg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Orgad Shaneh <orgads@gmail.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0610/1756] MIPS: Octeon: size the swiotlb for a modular OHCI platform driver
Date: Wed, 18 Nov 2026 15:45:37 +0100
Message-ID: <20261118150033.235218370@linuxfoundation.org>
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

From: Orgad Shaneh <orgads@gmail.com>

[ Upstream commit f1dd1f0c8d595a019be503d40060d25721313b4a ]

plat_swiotlb_setup() raises the swiotlb to 64 MB on OCTEON II with
memory above 4 GB, because that OHCI can only DMA to 32 bits. The test
is "#ifdef CONFIG_USB_OHCI_HCD_PLATFORM", which is false when the driver
is a module - the usual way to build it - so the bump is silently
skipped.

What is left depends on the rest of the function: with PCI enabled the
"memory past the BAR1 hole" branch happens to ask for the same 64 MB,
but with CONFIG_PCI off - which is normal on these SoCs when no PCI
devices are wired - swiotlbsize stays at the PAGE_SIZE it was
initialised to. A full- or low-speed device on an OCTEON II board with
more than 4 GB of RAM then has no bounce buffer to speak of.

Use IS_ENABLED() so a modular OHCI gets the same sizing as a built-in
one. Seen on a CN6635 board with 8 GB of RAM and
CONFIG_USB_OHCI_HCD_PLATFORM=m.

Fixes: a8667d706dfa ("MIPS: OCTEON: dma-octeon: fix OHCI USB config check")
Assisted-by: Claude:claude-opus-5
Signed-off-by: Orgad Shaneh <orgads@gmail.com>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/cavium-octeon/dma-octeon.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/mips/cavium-octeon/dma-octeon.c b/arch/mips/cavium-octeon/dma-octeon.c
index 9fbba6a8fa4c5..c049632fbcc33 100644
--- a/arch/mips/cavium-octeon/dma-octeon.c
+++ b/arch/mips/cavium-octeon/dma-octeon.c
@@ -228,7 +228,7 @@ void __init plat_swiotlb_setup(void)
 		swiotlbsize = 64 * (1<<20);
 	}
 #endif
-#ifdef CONFIG_USB_OHCI_HCD_PLATFORM
+#if IS_ENABLED(CONFIG_USB_OHCI_HCD_PLATFORM)
 	/* OCTEON II ohci is only 32-bit. */
 	if (OCTEON_IS_OCTEON2() && max_addr >= 0x100000000ul)
 		swiotlbsize = 64 * (1<<20);
-- 
2.53.0



