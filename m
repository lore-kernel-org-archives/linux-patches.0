Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47F5515CAE
	for <patches@lists.linux.dev>; Tue,  8 Nov 2022 14:11:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7AB8C433D6;
	Tue,  8 Nov 2022 14:11:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667916706;
	bh=wsnulm1hAtM0vaFN5se61LzGPuXWg3+VzTwaL/3ZElo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Jv5jHboyoqgKffE9BOWvh8mT9dHM7hHvD6fM5sbKueAP732f45tBFneOY8JXooRBY
	 kKlvi60H4yv0seU+pdJbojVgVHtau6e9vBeoKiTfmiX+XNp/GVceeBaf6FVx9nhfjK
	 cDgF/AETv5LLN0qqyAe0F5HCPJ+Iq+ul2krv3sQg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ioana Ciornei <ioana.ciornei@nxp.com>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 107/197] arm64: dts: ls1088a: specify clock frequencies for the MDIO controllers
Date: Tue,  8 Nov 2022 14:39:05 +0100
Message-Id: <20221108133359.717078514@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133354.787209461@linuxfoundation.org>
References: <20221108133354.787209461@linuxfoundation.org>
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

[ Upstream commit d78a57426e64fc4c61e6189e450a0432d24536ca ]

Up until now, the external MDIO controller frequency values relied
either on the default ones out of reset or on those setup by u-boot.
Let's just properly specify the MDC frequency in the DTS so that even
without u-boot's intervention Linux can drive the MDIO bus.

Fixes: bbe75af7b092 ("arm64: dts: ls1088a: add external MDIO device nodes")
Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/fsl-ls1088a.dtsi | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/arm64/boot/dts/freescale/fsl-ls1088a.dtsi b/arch/arm64/boot/dts/freescale/fsl-ls1088a.dtsi
index 421d879013d7..260d045dbd9a 100644
--- a/arch/arm64/boot/dts/freescale/fsl-ls1088a.dtsi
+++ b/arch/arm64/boot/dts/freescale/fsl-ls1088a.dtsi
@@ -779,6 +779,9 @@ emdio1: mdio@8b96000 {
 			little-endian;
 			#address-cells = <1>;
 			#size-cells = <0>;
+			clock-frequency = <2500000>;
+			clocks = <&clockgen QORIQ_CLK_PLATFORM_PLL
+					    QORIQ_CLK_PLL_DIV(1)>;
 			status = "disabled";
 		};
 
@@ -788,6 +791,9 @@ emdio2: mdio@8b97000 {
 			little-endian;
 			#address-cells = <1>;
 			#size-cells = <0>;
+			clock-frequency = <2500000>;
+			clocks = <&clockgen QORIQ_CLK_PLATFORM_PLL
+					    QORIQ_CLK_PLL_DIV(1)>;
 			status = "disabled";
 		};
 
-- 
2.35.1



