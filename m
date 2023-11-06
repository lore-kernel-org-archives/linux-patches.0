Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 388D4200BA
	for <patches@lists.linux.dev>; Mon,  6 Nov 2023 13:15:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BkX+R65L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA4F2C433C8;
	Mon,  6 Nov 2023 13:15:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1699276554;
	bh=4NzCPUAY30ahTZRzGIZKcga8avQo3QmZAi1VzBHs5G8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BkX+R65LTLuih2Utmm2GSA6iuTcPn+XhA0nH9T+E8fh4sqR2EiADVivElS9xxH1Ef
	 dw6m+kmVQlmRATwQlvvis3ICzzJjK9yYOj43zHuN2lTm7V4NOmEqoPU/23+2ldI9I7
	 aGWxlNaXOxhYep5r9ZYsrqJ3ajRSdkf8pChfukYE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haibo Chen <haibo.chen@nxp.com>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 08/88] arm64: dts: imx93: add the Flex-CAN stop mode by GPR
Date: Mon,  6 Nov 2023 14:03:02 +0100
Message-ID: <20231106130306.081314265@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231106130305.772449722@linuxfoundation.org>
References: <20231106130305.772449722@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haibo Chen <haibo.chen@nxp.com>

[ Upstream commit 23ed2be5404da7cee6a519fa69bf22d0f69da4e4 ]

imx93 A0 chip use the internal q-channel handshake signal in LPCG
and CCM to automatically handle the Flex-CAN stop mode. But this
method meet issue when do the system PM stress test. IC can't fix
it easily. So in the new imx93 A1 chip, IC drop this method, and
involve back the old way，use the GPR method to trigger the Flex-CAN
stop mode signal. Now NXP claim to drop imx93 A0, and only support
imx93 A1. So here add the stop mode through GPR.

This patch also fix a typo for aonmix_ns_gpr.

Signed-off-by: Haibo Chen <haibo.chen@nxp.com>
Link: https://lore.kernel.org/all/20230726112458.3524165-1-haibo.chen@nxp.com
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx93.dtsi | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/freescale/imx93.dtsi b/arch/arm64/boot/dts/freescale/imx93.dtsi
index 1d8dd14b65cfa..2a9b89bf52698 100644
--- a/arch/arm64/boot/dts/freescale/imx93.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx93.dtsi
@@ -146,7 +146,7 @@
 			#size-cells = <1>;
 			ranges;
 
-			anomix_ns_gpr: syscon@44210000 {
+			aonmix_ns_gpr: syscon@44210000 {
 				compatible = "fsl,imx93-aonmix-ns-syscfg", "syscon";
 				reg = <0x44210000 0x1000>;
 			};
@@ -280,6 +280,7 @@
 				assigned-clock-parents = <&clk IMX93_CLK_SYS_PLL_PFD1_DIV2>;
 				assigned-clock-rates = <40000000>;
 				fsl,clk-source = /bits/ 8 <0>;
+				fsl,stop-mode = <&aonmix_ns_gpr 0x14 0>;
 				status = "disabled";
 			};
 
@@ -532,6 +533,7 @@
 				assigned-clock-parents = <&clk IMX93_CLK_SYS_PLL_PFD1_DIV2>;
 				assigned-clock-rates = <40000000>;
 				fsl,clk-source = /bits/ 8 <0>;
+				fsl,stop-mode = <&wakeupmix_gpr 0x0c 2>;
 				status = "disabled";
 			};
 
-- 
2.42.0



