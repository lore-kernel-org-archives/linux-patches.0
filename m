Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060919;
	b=ZzZ6pFxX4mAe7lO3lD6iZB4sTS8xVazSn3oFlaHJ5rGxCrMeZRlQPdZQgufiDji4+R0Y
	 unFL/+TWurrkHZiMUUcGYw82PO271H5aZyh2y+Rcnxr2HJURoJBiqbb2Qr/XTQ/HCLGDa
	 /dEMIIP2WFeGRdz/53qhpfDw2z0vblVodx3/xkJydteUt9wN9j30JMFq0cQ1fg8fa/MAI
	 ZFZu7Mq1H5v2k+clOFXgvSe5I826X+iLaDaxG8b5ojFO9PcJnTIzoJ1iih9bbTQDO8XCD
	 UCekEwJcvtCvnt6b1cEhZh66ayQKshYW6N4OevjA9bQs0ZsoMrsA8W7SQCXMkAWIrEw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060919;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gbCDjQhgnJxnyk35sF6ljd/+lkYzjahQJgj6xOt3ieM=;
	b=HBib/Kb39zhsRQzFpmyw5cVIGiH+EnQ9jRV1UPv//jN0k04BGg88psIIbDa5eUljUVOF
	 7UQcBJxsSG2Mnj10aOB/x23vhR816jAdMbOpPpCxQ3xe9pqCrJlzLl+/lGwGrGe2qWBDZ
	 aCe6m6PgiyJSCiBK7c8OzAbQo4H3iyeYDIMRopcF+HI6ckdYcM1zVi2FWj/lfIFqhyV/Q
	 uRcDKZpLeQzlLBsYNj7mjPV9gslQT9+Gab+2Gnw7nJ2oBZcTriatUSpfpwrH+PZMQkVuH
	 dc1WR1C9Gzsgve1V0/Rgkz74A8zJj0FPcmYWX8H6yjtmUfYcygqc4bBfSvH+GEBfsig==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bR+FkboL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42414606A320;
	Thu, 19 Nov 2026 04:01:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bR+FkboL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9170A1F000C4;
	Thu, 19 Nov 2026 04:01:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060919;
	bh=gbCDjQhgnJxnyk35sF6ljd/+lkYzjahQJgj6xOt3ieM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bR+FkboLYoaOMZcDb0ZZBc9AY4RBnxq2V8Yx3vkhtkXaQW9gHA4LVH9ZnjXKRm3Wo
	 P+nnGJyAusJ2jWtrXlbKMlDwOvepPgaVdbTdGUWcLqP2xuEeyRn9hHatdBZqoh3UL3
	 o7rS7sidxmgzPVXPw6fMA8wBKXDsrw/2D6eZLJn0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Orgad Shaneh <orgads@gmail.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1369/1848] MIPS: Octeon: size the swiotlb for a modular OHCI platform driver
Date: Wed, 18 Nov 2026 15:56:47 +0100
Message-ID: <20261118150016.870924972@linuxfoundation.org>
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
index df70308db0e69..8a9bf803c84ae 100644
--- a/arch/mips/cavium-octeon/dma-octeon.c
+++ b/arch/mips/cavium-octeon/dma-octeon.c
@@ -231,7 +231,7 @@ void __init plat_swiotlb_setup(void)
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



