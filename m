Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C84B1171A
	for <patches@lists.linux.dev>; Mon, 21 Aug 2023 20:08:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1900C433CA;
	Mon, 21 Aug 2023 20:08:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1692648486;
	bh=b7P2Dh/6FBa+I9pt3tckwToxnbbiYeXDocwr+u9Et1c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WvkqGfnTdnJdBKgy+saflQiLNlbtLmNj1ouctLmgFchSpVNnMeMVaNLDUWwPX6zwt
	 npCO6e/O8Vf459xXjMA6IKZIYI9lf+8nt6jQ4RTiRpd0JrZNiOwRfM+d2z5OULoiI0
	 evQKfnrlANDQAZx6FBnWRbBjttB//LIIneD5hMe4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Wahren <stefan.wahren@i2se.com>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 185/234] ARM: dts: imx: Adjust dma-apbh node name
Date: Mon, 21 Aug 2023 21:42:28 +0200
Message-ID: <20230821194137.020727434@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230821194128.754601642@linuxfoundation.org>
References: <20230821194128.754601642@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Stefan Wahren <stefan.wahren@i2se.com>

[ Upstream commit e9f5cd85f1f931bb7b64031492f7051187ccaac7 ]

Currently the dtbs_check generates warnings like this:

$nodename:0: 'dma-apbh@110000' does not match '^dma-controller(@.*)?$'

So fix all affected dma-apbh node names.

Signed-off-by: Stefan Wahren <stefan.wahren@i2se.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Stable-dep-of: be18293e47cb ("ARM: dts: imx: Set default tuning step for imx7d usdhc")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/imx23.dtsi   | 2 +-
 arch/arm/boot/dts/imx28.dtsi   | 2 +-
 arch/arm/boot/dts/imx6qdl.dtsi | 2 +-
 arch/arm/boot/dts/imx6sx.dtsi  | 2 +-
 arch/arm/boot/dts/imx6ul.dtsi  | 2 +-
 arch/arm/boot/dts/imx7s.dtsi   | 2 +-
 6 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/arm/boot/dts/imx23.dtsi b/arch/arm/boot/dts/imx23.dtsi
index d19508c8f9ed6..a3668a0827fc8 100644
--- a/arch/arm/boot/dts/imx23.dtsi
+++ b/arch/arm/boot/dts/imx23.dtsi
@@ -59,7 +59,7 @@
 				reg = <0x80000000 0x2000>;
 			};
 
-			dma_apbh: dma-apbh@80004000 {
+			dma_apbh: dma-controller@80004000 {
 				compatible = "fsl,imx23-dma-apbh";
 				reg = <0x80004000 0x2000>;
 				interrupts = <0 14 20 0
diff --git a/arch/arm/boot/dts/imx28.dtsi b/arch/arm/boot/dts/imx28.dtsi
index a8d3c3113e0f6..29e37b1fae66f 100644
--- a/arch/arm/boot/dts/imx28.dtsi
+++ b/arch/arm/boot/dts/imx28.dtsi
@@ -78,7 +78,7 @@
 				status = "disabled";
 			};
 
-			dma_apbh: dma-apbh@80004000 {
+			dma_apbh: dma-controller@80004000 {
 				compatible = "fsl,imx28-dma-apbh";
 				reg = <0x80004000 0x2000>;
 				interrupts = <82 83 84 85
diff --git a/arch/arm/boot/dts/imx6qdl.dtsi b/arch/arm/boot/dts/imx6qdl.dtsi
index b72ec745f6d12..bda182edc5891 100644
--- a/arch/arm/boot/dts/imx6qdl.dtsi
+++ b/arch/arm/boot/dts/imx6qdl.dtsi
@@ -150,7 +150,7 @@
 		interrupt-parent = <&gpc>;
 		ranges;
 
-		dma_apbh: dma-apbh@110000 {
+		dma_apbh: dma-controller@110000 {
 			compatible = "fsl,imx6q-dma-apbh", "fsl,imx28-dma-apbh";
 			reg = <0x00110000 0x2000>;
 			interrupts = <0 13 IRQ_TYPE_LEVEL_HIGH>,
diff --git a/arch/arm/boot/dts/imx6sx.dtsi b/arch/arm/boot/dts/imx6sx.dtsi
index 93ac2380ca1ec..4233943a1cca8 100644
--- a/arch/arm/boot/dts/imx6sx.dtsi
+++ b/arch/arm/boot/dts/imx6sx.dtsi
@@ -209,7 +209,7 @@
 			power-domains = <&pd_pu>;
 		};
 
-		dma_apbh: dma-apbh@1804000 {
+		dma_apbh: dma-controller@1804000 {
 			compatible = "fsl,imx6sx-dma-apbh", "fsl,imx28-dma-apbh";
 			reg = <0x01804000 0x2000>;
 			interrupts = <GIC_SPI 13 IRQ_TYPE_LEVEL_HIGH>,
diff --git a/arch/arm/boot/dts/imx6ul.dtsi b/arch/arm/boot/dts/imx6ul.dtsi
index 3d9d0f8235685..118764c50d921 100644
--- a/arch/arm/boot/dts/imx6ul.dtsi
+++ b/arch/arm/boot/dts/imx6ul.dtsi
@@ -164,7 +164,7 @@
 			      <0x00a06000 0x2000>;
 		};
 
-		dma_apbh: dma-apbh@1804000 {
+		dma_apbh: dma-controller@1804000 {
 			compatible = "fsl,imx6q-dma-apbh", "fsl,imx28-dma-apbh";
 			reg = <0x01804000 0x2000>;
 			interrupts = <0 13 IRQ_TYPE_LEVEL_HIGH>,
diff --git a/arch/arm/boot/dts/imx7s.dtsi b/arch/arm/boot/dts/imx7s.dtsi
index efe2525b62fa1..54026c2c93fac 100644
--- a/arch/arm/boot/dts/imx7s.dtsi
+++ b/arch/arm/boot/dts/imx7s.dtsi
@@ -1257,7 +1257,7 @@
 			};
 		};
 
-		dma_apbh: dma-apbh@33000000 {
+		dma_apbh: dma-controller@33000000 {
 			compatible = "fsl,imx7d-dma-apbh", "fsl,imx28-dma-apbh";
 			reg = <0x33000000 0x2000>;
 			interrupts = <GIC_SPI 12 IRQ_TYPE_LEVEL_HIGH>,
-- 
2.40.1



