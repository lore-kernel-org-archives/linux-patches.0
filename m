Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F76D17AAD
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 11:39:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A43AAC433C8;
	Wed,  9 Aug 2023 11:39:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691581154;
	bh=Af9UUBQKmrryeTxboZKgCm1mF3PLFnu7BmC2G6IkQRI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wnoIGFbA23dw36bHOGqMUJeWh4OpQlUpZQkCWowwW4M9lWjLgouM611HhNI8EacQ0
	 J7vBOllru397PN7fVEBLIBUUcTzvS93c7UOgFyBtpfqtIo9CgMiH6dQwVt6XHT1Fbh
	 +ELibvyzM3pk+3gcHcIHOm2Xo36oMIQcC+13Za6U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hugo Villeneuve <hvilleneuve@dimonoff.com>,
	Fabio Estevam <festevam@gmail.com>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 125/201] arm64: dts: imx8mn-var-som: add missing pull-up for onboard PHY reset pinmux
Date: Wed,  9 Aug 2023 12:42:07 +0200
Message-ID: <20230809103647.925020954@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230809103643.799166053@linuxfoundation.org>
References: <20230809103643.799166053@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Hugo Villeneuve <hvilleneuve@dimonoff.com>

[ Upstream commit 253be5b53c2792fb4384f8005b05421e6f040ee3 ]

For SOMs with an onboard PHY, the RESET_N pull-up resistor is
currently deactivated in the pinmux configuration. When the pinmux
code selects the GPIO function for this pin, with a default direction
of input, this prevents the RESET_N pin from being taken to the proper
3.3V level (deasserted), and this results in the PHY being not
detected since it is held in reset.

Taken from RESET_N pin description in ADIN13000 datasheet:
    This pin requires a 1K pull-up resistor to AVDD_3P3.

Activate the pull-up resistor to fix the issue.

Fixes: ade0176dd8a0 ("arm64: dts: imx8mn-var-som: Add Variscite VAR-SOM-MX8MN System on Module")
Signed-off-by: Hugo Villeneuve <hvilleneuve@dimonoff.com>
Reviewed-by: Fabio Estevam <festevam@gmail.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx8mn-var-som.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/freescale/imx8mn-var-som.dtsi b/arch/arm64/boot/dts/freescale/imx8mn-var-som.dtsi
index 24f9e8fd0c8b8..9c6c21cc6c6c8 100644
--- a/arch/arm64/boot/dts/freescale/imx8mn-var-som.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mn-var-som.dtsi
@@ -351,7 +351,7 @@
 			MX8MN_IOMUXC_ENET_RXC_ENET1_RGMII_RXC		0x91
 			MX8MN_IOMUXC_ENET_RX_CTL_ENET1_RGMII_RX_CTL	0x91
 			MX8MN_IOMUXC_ENET_TX_CTL_ENET1_RGMII_TX_CTL	0x1f
-			MX8MN_IOMUXC_GPIO1_IO09_GPIO1_IO9		0x19
+			MX8MN_IOMUXC_GPIO1_IO09_GPIO1_IO9		0x159
 		>;
 	};
 
-- 
2.40.1



