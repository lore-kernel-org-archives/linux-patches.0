Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048802;
	b=KMYdl/qC9fLoNiDJ8Ke/xkvG/gunnNy0iRhTmY8p7/OpH4mN3gqSkskdM7Rzc4q3a+pn
	 MvxRRtxzJSg6TbA/jLHmOskWSFtcWLVR9F+Uw8tlkDJeoV84dxP3vi6KaywowyEzjjMGL
	 Rbn4955jtE6Ruj0q7AjPJNoC8lpgNGEw6rgyDhhnV5qgRCJmVaL0OWkx1IE/4BP4zg04j
	 QE4Ly3tBTeOFDdplnWOKL/RAGjVieoTpH6K2wjOtK4JAbrGU/AV1duOpydkZ8+a/fLkzv
	 h8OZBSXrtMHBtRkVcMkfhqvIsAMJz9nhKg76HQ4nsWcSUPzNHcdJtbUWKRBm8nW8xFQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048802;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=M49+LQH33HoNirQEdWaKEoKmNabqeom+W4geLns9bWk=;
	b=Mn0m1UuSPC1dDLAG3iY+TE+H4a5bpdM4BpDoChpBsnj1FgiT7IhVy/zWn1YV6JLsIWvT
	 WKK9qfC3OBhgSQ2faLWrT9soYvFmgsvzqp6DYiXXOuQYeXA4jy3RviXw056YxnWGW8O1h
	 wB38hIG721j1ges3iiJ+gn7F5G1DdhBNmvqWVBiqCcSPe24DIIF8ruIkmU5jL0Hxzi9cu
	 gfO0XzxY4HEMZuCCuA+64ytyJbM9U8RcdQqSzKNOnEj2FCQnKePniaKEucAl2LqZl1Mf4
	 YGqlviy0OE49eg6gXCCLAsyH2khtnjDl1a46I9GchNY4Yi/PzPqPMdILrWD2ZiF8sQA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EmdUzBtM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5EA7606A320;
	Thu, 19 Nov 2026 00:40:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EmdUzBtM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 578561F000C4;
	Thu, 19 Nov 2026 00:40:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048802;
	bh=M49+LQH33HoNirQEdWaKEoKmNabqeom+W4geLns9bWk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EmdUzBtMqaVjUgcmBDdRfmg3Qet2D9ugFIMxtWGpjW/2kCJn27O7XLTOm1aZzRBiz
	 3a9WRPYxKNWiE3RUn/MK7pw8FgPVPtA/vCeVbVLP/90/DM68E5a3IuV5O9CdlDliJ0
	 dKVmy+oCe7venG+Fs+eSvtTMR97fxJ/nlK0/QZ78=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Orgad Shaneh <orgads@gmail.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2074/2857] MIPS: Octeon: size the swiotlb for a modular OHCI platform driver
Date: Wed, 18 Nov 2026 15:51:48 +0100
Message-ID: <20261118150316.089100477@linuxfoundation.org>
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



