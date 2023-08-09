Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53F3C17AA6
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 11:25:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C51C3C433C7;
	Wed,  9 Aug 2023 11:25:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691580351;
	bh=ptEUBx7NXouPTs9vL8NHlnPpdkt6EHNCSTVer9zT52c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YVZOZAxSqyJsSIYwS7XxUAPR+es/xg70xrR0yx8oYlVLw/m2tUU27jMdTFe4puYjH
	 1sr51NS/itDv6BiGMnWVt+ajzNlxiwloCejFXkO42mnteX6dL+CJCxaF4khwIiJNWN
	 1Tw67b/90vu04RMBD1KxRL4NUV0a9Y94gDxFxCk8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shengjiu Wang <shengjiu.wang@nxp.com>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 318/323] ARM: dts: imx6sll: Make ssi node name same as other platforms
Date: Wed,  9 Aug 2023 12:42:36 +0200
Message-ID: <20230809103712.625522815@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230809103658.104386911@linuxfoundation.org>
References: <20230809103658.104386911@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Shengjiu Wang <shengjiu.wang@nxp.com>

[ Upstream commit 5da1b522cf7dc51f7fde2cca8d90406b0291c503 ]

In imx6sll.dtsi, the ssi node name is different with other
platforms (imx6qdl, imx6sl, imx6sx), but the
sound/soc/fsl/fsl-asoc-card.c machine driver needs to check
ssi node name for audmux configuration, then different ssi
node name causes issue on imx6sll platform.

So we change ssi node name to make all platforms have same
name.

Signed-off-by: Shengjiu Wang <shengjiu.wang@nxp.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Stable-dep-of: ee70b908f77a ("ARM: dts: nxp/imx6sll: fix wrong property name in usbphy node")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/imx6sll.dtsi | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm/boot/dts/imx6sll.dtsi b/arch/arm/boot/dts/imx6sll.dtsi
index d7d092a5522a3..8197767de69d7 100644
--- a/arch/arm/boot/dts/imx6sll.dtsi
+++ b/arch/arm/boot/dts/imx6sll.dtsi
@@ -271,7 +271,7 @@ uart2: serial@2024000 {
 					status = "disabled";
 				};
 
-				ssi1: ssi-controller@2028000 {
+				ssi1: ssi@2028000 {
 					compatible = "fsl,imx6sl-ssi", "fsl,imx51-ssi";
 					reg = <0x02028000 0x4000>;
 					interrupts = <GIC_SPI 46 IRQ_TYPE_LEVEL_HIGH>;
@@ -284,7 +284,7 @@ ssi1: ssi-controller@2028000 {
 					status = "disabled";
 				};
 
-				ssi2: ssi-controller@202c000 {
+				ssi2: ssi@202c000 {
 					compatible = "fsl,imx6sl-ssi", "fsl,imx51-ssi";
 					reg = <0x0202c000 0x4000>;
 					interrupts = <GIC_SPI 47 IRQ_TYPE_LEVEL_HIGH>;
@@ -297,7 +297,7 @@ ssi2: ssi-controller@202c000 {
 					status = "disabled";
 				};
 
-				ssi3: ssi-controller@2030000 {
+				ssi3: ssi@2030000 {
 					compatible = "fsl,imx6sl-ssi", "fsl,imx51-ssi";
 					reg = <0x02030000 0x4000>;
 					interrupts = <GIC_SPI 48 IRQ_TYPE_LEVEL_HIGH>;
-- 
2.40.1



