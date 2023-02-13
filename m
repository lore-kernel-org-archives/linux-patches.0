Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 621FD8F57
	for <patches@lists.linux.dev>; Mon, 13 Feb 2023 15:01:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC502C433D2;
	Mon, 13 Feb 2023 15:01:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1676300508;
	bh=Wq7XP/5rXPr00TAp0Kl/fvlUuyHohjj4CMzCBbpExfo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kRi4bsftnGo6r+iGbMlmmVUcYjdvUhnPQNLOGODNaFn095Erq05aT9qNDjtbpUIYz
	 3vNRxQTeye9aEPtdwe1ansDcNU+VOtloXzKh4N9TVVK9BkDDlly4TXe3hYwT8nGvDM
	 j67k3NrR/XeuJMgj31FF3FTPLnpZI6OVQvcr0DvE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pierluigi Passaro <pierluigi.p@variscite.com>,
	Fabio Estevam <festevam@gmail.com>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 012/139] arm64: dts: imx8mm: Fix pad control for UART1_DTE_RX
Date: Mon, 13 Feb 2023 15:49:17 +0100
Message-Id: <20230213144746.313124098@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230213144745.696901179@linuxfoundation.org>
References: <20230213144745.696901179@linuxfoundation.org>
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
index a003e6af3353..56271abfb7e0 100644
--- a/arch/arm64/boot/dts/freescale/imx8mm-pinfunc.h
+++ b/arch/arm64/boot/dts/freescale/imx8mm-pinfunc.h
@@ -601,7 +601,7 @@
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



