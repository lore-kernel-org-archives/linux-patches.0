Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017477;
	b=GMO50F0708O5HP5RhwXvsfGn9X3hp/L088GWeMxtL/XPzIb8HlTdYBagIEYk3VpwbhEl
	 LR1gjyrYLXc/P52FF6ptuqn48flYvIkCj0Kqff/k+8+CAiVOuCffZMb9avKKZb5ukq1sN
	 Pcd3SJ1t8PFWAa1qsNzguI2B9YuTbupo+Iqh//yZeVVwLYnB2DbUNVdy6UDDs6mqDKaXy
	 nLtIdfXE4fXZtSWFvkwb+OLdtbjW68qkVow1nTBdPHKQaMfkYVjra2jYyEwyXum0hmaPq
	 JWLwmgZSmE51YCG/FIsTjifP6AkYEQg6kNf1GBv79x5eqS3b5bU3qSHy2y1De6/EATQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017477;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=V8FbX6u7oycJ1B0ugbk7LOQn9i7OSsoAIm6L6MbxlN8=;
	b=2fyTDe5asBGmBwMEHgLkwS3NT5KrZhsl1Eeu0TY3JnbcKk6w/21GSFD/YVj6yUtY7//1
	 +B/Gwp434F26QWYsQ0fhZkmuLLKmw6i8yDQLYVXccYP5srZ3jitj073u3mp+OJ4EXP5ad
	 SYwQmo2OGgabKjCWIrBj5mf5HS5Idn/BefRsglBY0LSe6BxDq2q60O4sGRKb7nCZeE7kX
	 drzm3cjvneWbIPEdZp8p55VeCzIra9uVXLyVlIeXwZrciJLhKyttqGaCql64BGNAec3Il
	 8yUsrrKS4CPvtfpf/WRnFSHkJQ/qXL3Dl99NK6HWiWZozC7uGPHcR64N/YdjRwwloEw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XMFaHlRl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 618F3606A338;
	Wed, 18 Nov 2026 15:57:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XMFaHlRl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B34B81F000C4;
	Wed, 18 Nov 2026 15:57:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017477;
	bh=V8FbX6u7oycJ1B0ugbk7LOQn9i7OSsoAIm6L6MbxlN8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XMFaHlRls3P+k63CnyQ8YUIsz+p7g4sK7nlAzhwJ2B1vP0QVcB8FheSCz8oEGMCyw
	 RRtdhRUvvtukCpsR21Wg/6OTkXBg75mApz8WnyvuKGEJy2U04VDQ+MlWBEVfBOFN9E
	 CHdwyAM3yRTtzngwjpy2aqPc9AXx9BP8KvPO+huM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Orgad Shaneh <orgads@gmail.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0897/2651] MIPS: Octeon: size the swiotlb for a modular OHCI platform driver
Date: Wed, 18 Nov 2026 15:35:37 +0100
Message-ID: <20261118150320.158982355@linuxfoundation.org>
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



