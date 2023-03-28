Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B60D8474
	for <patches@lists.linux.dev>; Tue, 28 Mar 2023 14:44:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC875C433EF;
	Tue, 28 Mar 2023 14:44:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1680014669;
	bh=4PmghaiQzSnprY71YjOHpZQd8m/rxGKANb7/JxO9T8Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kVwjyRC4N772/pLGrCTAiAZDC6GgTHI/BKrqpMJ9VqzRzUyPzYD+tp+Vsi1mTM3qg
	 QSKLTq66+zajwGwiIvNDRbGWhNxDV37DGVzr+unPvJAmJqTU5Fqs0m3UdJU7ZGKlAv
	 0VZCFdUnPr/vwwnEuaBngG6cAHB14rZOFlEJ8cIo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Stein <alexander.stein@ew.tq-group.com>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 010/240] arm64: dts: freescale: imx8-ss-lsio: Fix flexspi clock order
Date: Tue, 28 Mar 2023 16:39:33 +0200
Message-Id: <20230328142620.082821620@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142619.643313678@linuxfoundation.org>
References: <20230328142619.643313678@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Alexander Stein <alexander.stein@ew.tq-group.com>

[ Upstream commit fd4334a06d452ce89a0bb831b03130c51331d927 ]

The correct clock order is "fspi_en" and "fspi". As they are identical
just reordering the names is sufficient.

Fixes: 6276d66984e9 ("arm64: dts: imx8dxl: add flexspi0 support")
Signed-off-by: Alexander Stein <alexander.stein@ew.tq-group.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx8-ss-lsio.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/freescale/imx8-ss-lsio.dtsi b/arch/arm64/boot/dts/freescale/imx8-ss-lsio.dtsi
index 1f3d225e64ece..06b94bbc2b97d 100644
--- a/arch/arm64/boot/dts/freescale/imx8-ss-lsio.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8-ss-lsio.dtsi
@@ -117,7 +117,7 @@ flexspi0: spi@5d120000 {
 		interrupts = <GIC_SPI 92 IRQ_TYPE_LEVEL_HIGH>;
 		clocks = <&clk IMX_SC_R_FSPI_0 IMX_SC_PM_CLK_PER>,
 			 <&clk IMX_SC_R_FSPI_0 IMX_SC_PM_CLK_PER>;
-		clock-names = "fspi", "fspi_en";
+		clock-names = "fspi_en", "fspi";
 		power-domains = <&pd IMX_SC_R_FSPI_0>;
 		status = "disabled";
 	};
-- 
2.39.2



