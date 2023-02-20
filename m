Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79D9063B8
	for <patches@lists.linux.dev>; Mon, 20 Feb 2023 13:44:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00BC1C4339B;
	Mon, 20 Feb 2023 13:44:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1676900642;
	bh=0MryqzIcmdk73KkVQ6Nzw4kxXl8Z0WczOCXMAw/9cU4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s4dOUyoxDsudo8gJiRz5jSDsqJBPgKTU5zVK18FNda/Hmxa6m+1aWiiusvocEqjmA
	 jzvslt3So8J9snB0LiH5KOZgP3ccTQCTot2Zr/+h5tjttJv9MxP80zt6bEljO+gfLY
	 tZPEMzv7m1Y0IzKgZjNck+crcIE6ZIOt/eHafBhw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pierluigi Passaro <pierluigi.p@variscite.com>,
	Fabio Estevam <festevam@gmail.com>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 005/156] arm64: dts: imx8mm: Fix pad control for UART1_DTE_RX
Date: Mon, 20 Feb 2023 14:34:09 +0100
Message-Id: <20230220133602.713102079@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133602.515342638@linuxfoundation.org>
References: <20230220133602.515342638@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Pierluigi Passaro <pierluigi.p@variscite.com>

[ Upstream commit 47123900f3e4a7f769631d6ec15abf44086276f6 ]

According section
    8.2.5.313 Select Input Register (IOMUXC_UART1_RXD_SELECT_INPUT)
of 
    i.MX 8M Mini Applications Processor Reference Manual, Rev. 3, 11/2020
the required setting for this specific pin configuration is "1"

Signed-off-by: Pierluigi Passaro <pierluigi.p@variscite.com>
Reviewed-by: Fabio Estevam <festevam@gmail.com>
Fixes: c1c9d41319c3 ("dt-bindings: imx: Add pinctrl binding doc for imx8mm")
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx8mm-pinfunc.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/freescale/imx8mm-pinfunc.h b/arch/arm64/boot/dts/freescale/imx8mm-pinfunc.h
index 93b44efdbc52..35a60b0d3a4f 100644
--- a/arch/arm64/boot/dts/freescale/imx8mm-pinfunc.h
+++ b/arch/arm64/boot/dts/freescale/imx8mm-pinfunc.h
@@ -585,7 +585,7 @@
 #define MX8MM_IOMUXC_UART1_RXD_GPIO5_IO22                                   0x234 0x49C 0x000 0x5 0x0
 #define MX8MM_IOMUXC_UART1_RXD_TPSMP_HDATA24                                0x234 0x49C 0x000 0x7 0x0
 #define MX8MM_IOMUXC_UART1_TXD_UART1_DCE_TX                                 0x238 0x4A0 0x000 0x0 0x0
-#define MX8MM_IOMUXC_UART1_TXD_UART1_DTE_RX                                 0x238 0x4A0 0x4F4 0x0 0x0
+#define MX8MM_IOMUXC_UART1_TXD_UART1_DTE_RX                                 0x238 0x4A0 0x4F4 0x0 0x1
 #define MX8MM_IOMUXC_UART1_TXD_ECSPI3_MOSI                                  0x238 0x4A0 0x000 0x1 0x0
 #define MX8MM_IOMUXC_UART1_TXD_GPIO5_IO23                                   0x238 0x4A0 0x000 0x5 0x0
 #define MX8MM_IOMUXC_UART1_TXD_TPSMP_HDATA25                                0x238 0x4A0 0x000 0x7 0x0
-- 
2.39.0



