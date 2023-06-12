Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DFF3D512
	for <patches@lists.linux.dev>; Mon, 12 Jun 2023 10:39:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82D80C433EF;
	Mon, 12 Jun 2023 10:39:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686566361;
	bh=tEYLiiDxvgvBFRIGwXZxVL16iYVhMCH/ItnNbKhv9oE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uvRh5vEyAjg5grq2rn3ltXsMDAc2NRYTBEO7SygC3Z9YweAzhRx1bia/bC6PCyivk
	 WWhEkN8UscTfMv/+iMreqdjbsiAxHhWvRK8/MMAkxBq45qff9N1DdC2oE3iXqmww4t
	 Jyj4TLbF79m9mtonr5ewIH470uaa3Ddi344OyDJQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shenwei Wang <shenwei.wang@nxp.com>,
	Fabio Estevam <festevam@gmail.com>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 75/91] arm64: dts: imx8-ss-dma: assign default clock rate for lpuarts
Date: Mon, 12 Jun 2023 12:27:04 +0200
Message-ID: <20230612101705.196896067@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230612101702.085813286@linuxfoundation.org>
References: <20230612101702.085813286@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Shenwei Wang <shenwei.wang@nxp.com>

[ Upstream commit ca50d7765587fe0a8351a6e8d9742cfd4811d925 ]

Add the assigned-clocks and assigned-clock-rates properties for the
LPUARTx nodes. Without these properties, the default clock rate
used would be 0, which can cause the UART ports to fail when open.

Fixes: 35f4e9d7530f ("arm64: dts: imx8: split adma ss into dma and audio ss")
Signed-off-by: Shenwei Wang <shenwei.wang@nxp.com>
Reviewed-by: Fabio Estevam <festevam@gmail.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx8-ss-dma.dtsi | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/arm64/boot/dts/freescale/imx8-ss-dma.dtsi b/arch/arm64/boot/dts/freescale/imx8-ss-dma.dtsi
index 960a802b8b6ee..c33892711138f 100644
--- a/arch/arm64/boot/dts/freescale/imx8-ss-dma.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8-ss-dma.dtsi
@@ -26,6 +26,8 @@ lpuart0: serial@5a060000 {
 		clocks = <&uart0_lpcg IMX_LPCG_CLK_4>,
 			 <&uart0_lpcg IMX_LPCG_CLK_0>;
 		clock-names = "ipg", "baud";
+		assigned-clocks = <&clk IMX_SC_R_UART_0 IMX_SC_PM_CLK_PER>;
+		assigned-clock-rates = <80000000>;
 		power-domains = <&pd IMX_SC_R_UART_0>;
 		status = "disabled";
 	};
@@ -36,6 +38,8 @@ lpuart1: serial@5a070000 {
 		clocks = <&uart1_lpcg IMX_LPCG_CLK_4>,
 			 <&uart1_lpcg IMX_LPCG_CLK_0>;
 		clock-names = "ipg", "baud";
+		assigned-clocks = <&clk IMX_SC_R_UART_1 IMX_SC_PM_CLK_PER>;
+		assigned-clock-rates = <80000000>;
 		power-domains = <&pd IMX_SC_R_UART_1>;
 		status = "disabled";
 	};
@@ -46,6 +50,8 @@ lpuart2: serial@5a080000 {
 		clocks = <&uart2_lpcg IMX_LPCG_CLK_4>,
 			 <&uart2_lpcg IMX_LPCG_CLK_0>;
 		clock-names = "ipg", "baud";
+		assigned-clocks = <&clk IMX_SC_R_UART_2 IMX_SC_PM_CLK_PER>;
+		assigned-clock-rates = <80000000>;
 		power-domains = <&pd IMX_SC_R_UART_2>;
 		status = "disabled";
 	};
@@ -56,6 +62,8 @@ lpuart3: serial@5a090000 {
 		clocks = <&uart3_lpcg IMX_LPCG_CLK_4>,
 			 <&uart3_lpcg IMX_LPCG_CLK_0>;
 		clock-names = "ipg", "baud";
+		assigned-clocks = <&clk IMX_SC_R_UART_3 IMX_SC_PM_CLK_PER>;
+		assigned-clock-rates = <80000000>;
 		power-domains = <&pd IMX_SC_R_UART_3>;
 		status = "disabled";
 	};
-- 
2.39.2



