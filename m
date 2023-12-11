Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6B7A5102A;
	Mon, 11 Dec 2023 18:48:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2g0Hm7Vb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D930C433C7;
	Mon, 11 Dec 2023 18:48:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702320523;
	bh=YMMEJvVrM0kXfQsfmG+5ZmQxs2EhhOlHnpUFIqMDtl8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2g0Hm7VbG0DMc2EEvgkRzRPailFDVCHOUqlLT/n7NKuPcQc5XG6tAw/9qVyeDRI+V
	 DBIf+g/+9EPsbB6wf/hoQg9O/gWJjfHwemLo1uuAdUUTkS2YhXTrrOVrT5yQiGwgrl
	 h30KnGTSA8UvWBjZgY6kTfwDf4HVcEOjtn8l9r8o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Roland Hieber <rhi@pengutronix.de>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 093/194] ARM: dts: imx7: Declare timers compatible with fsl,imx6dl-gpt
Date: Mon, 11 Dec 2023 19:21:23 +0100
Message-ID: <20231211182040.615878298@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231211182036.606660304@linuxfoundation.org>
References: <20231211182036.606660304@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Philipp Zabel <p.zabel@pengutronix.de>

[ Upstream commit 397caf68e2d36532054cb14ae8995537f27f8b61 ]

The timer nodes declare compatibility with "fsl,imx6sx-gpt", which
itself is compatible with "fsl,imx6dl-gpt". Switch the fallback
compatible from "fsl,imx6sx-gpt" to "fsl,imx6dl-gpt".

Fixes: 949673450291 ("ARM: dts: add imx7d soc dtsi file")
Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
Signed-off-by: Roland Hieber <rhi@pengutronix.de>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/imx7s.dtsi | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm/boot/dts/imx7s.dtsi b/arch/arm/boot/dts/imx7s.dtsi
index 667568aa4326a..45947707134b8 100644
--- a/arch/arm/boot/dts/imx7s.dtsi
+++ b/arch/arm/boot/dts/imx7s.dtsi
@@ -454,7 +454,7 @@
 			};
 
 			gpt1: timer@302d0000 {
-				compatible = "fsl,imx7d-gpt", "fsl,imx6sx-gpt";
+				compatible = "fsl,imx7d-gpt", "fsl,imx6dl-gpt";
 				reg = <0x302d0000 0x10000>;
 				interrupts = <GIC_SPI 55 IRQ_TYPE_LEVEL_HIGH>;
 				clocks = <&clks IMX7D_GPT1_ROOT_CLK>,
@@ -463,7 +463,7 @@
 			};
 
 			gpt2: timer@302e0000 {
-				compatible = "fsl,imx7d-gpt", "fsl,imx6sx-gpt";
+				compatible = "fsl,imx7d-gpt", "fsl,imx6dl-gpt";
 				reg = <0x302e0000 0x10000>;
 				interrupts = <GIC_SPI 54 IRQ_TYPE_LEVEL_HIGH>;
 				clocks = <&clks IMX7D_GPT2_ROOT_CLK>,
@@ -473,7 +473,7 @@
 			};
 
 			gpt3: timer@302f0000 {
-				compatible = "fsl,imx7d-gpt", "fsl,imx6sx-gpt";
+				compatible = "fsl,imx7d-gpt", "fsl,imx6dl-gpt";
 				reg = <0x302f0000 0x10000>;
 				interrupts = <GIC_SPI 53 IRQ_TYPE_LEVEL_HIGH>;
 				clocks = <&clks IMX7D_GPT3_ROOT_CLK>,
@@ -483,7 +483,7 @@
 			};
 
 			gpt4: timer@30300000 {
-				compatible = "fsl,imx7d-gpt", "fsl,imx6sx-gpt";
+				compatible = "fsl,imx7d-gpt", "fsl,imx6dl-gpt";
 				reg = <0x30300000 0x10000>;
 				interrupts = <GIC_SPI 52 IRQ_TYPE_LEVEL_HIGH>;
 				clocks = <&clks IMX7D_GPT4_ROOT_CLK>,
-- 
2.42.0



