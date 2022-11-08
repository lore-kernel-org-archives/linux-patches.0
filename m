Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83F1615CAD
	for <patches@lists.linux.dev>; Tue,  8 Nov 2022 13:55:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D72A3C433C1;
	Tue,  8 Nov 2022 13:55:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667915717;
	bh=GLQcgC5VbMKfgl9xxiOSfizBCMTatscPqQc/KmgeTz0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dy6OAQEXD+v2QzxDIs3HsF+d8SC1J4A52+yB6auqrpZGD2CfWtMr1mwgEjx5QIVWV
	 NidIcBC+BCv9FXZ2vcR30YzLWLsuV0dMqN9hCSTd6abyZg9KCXezI2gs/kPqZsIJkW
	 LZlxcKp2azlsN6ijwoCOnM6ZGlh5dEKvAiWzgnXk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ioana Ciornei <ioana.ciornei@nxp.com>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 071/118] arm64: dts: lx2160a: specify clock frequencies for the MDIO controllers
Date: Tue,  8 Nov 2022 14:39:09 +0100
Message-Id: <20221108133343.835969612@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133340.718216105@linuxfoundation.org>
References: <20221108133340.718216105@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ioana Ciornei <ioana.ciornei@nxp.com>

[ Upstream commit c126a0abc5dadd7df236f20aae6d8c3d103f095c ]

Up until now, the external MDIO controller frequency values relied
either on the default ones out of reset or on those setup by u-boot.
Let's just properly specify the MDC frequency in the DTS so that even
without u-boot's intervention Linux can drive the MDIO bus.

Fixes: 6e1b8fae892d ("arm64: dts: lx2160a: add emdio1 node")
Fixes: 5705b9dcda57 ("arm64: dts: lx2160a: add emdio2 node")
Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/fsl-lx2160a.dtsi | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/arm64/boot/dts/freescale/fsl-lx2160a.dtsi b/arch/arm64/boot/dts/freescale/fsl-lx2160a.dtsi
index 83072da6f6c6..8115cdcb4574 100644
--- a/arch/arm64/boot/dts/freescale/fsl-lx2160a.dtsi
+++ b/arch/arm64/boot/dts/freescale/fsl-lx2160a.dtsi
@@ -1292,6 +1292,9 @@ emdio1: mdio@8b96000 {
 			#address-cells = <1>;
 			#size-cells = <0>;
 			little-endian;
+			clock-frequency = <2500000>;
+			clocks = <&clockgen QORIQ_CLK_PLATFORM_PLL
+					    QORIQ_CLK_PLL_DIV(2)>;
 			status = "disabled";
 		};
 
@@ -1302,6 +1305,9 @@ emdio2: mdio@8b97000 {
 			little-endian;
 			#address-cells = <1>;
 			#size-cells = <0>;
+			clock-frequency = <2500000>;
+			clocks = <&clockgen QORIQ_CLK_PLATFORM_PLL
+					    QORIQ_CLK_PLL_DIV(2)>;
 			status = "disabled";
 		};
 
-- 
2.35.1



