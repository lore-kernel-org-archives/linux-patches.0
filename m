Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38B71BA49
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 18:45:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1203C433D2;
	Tue,  7 Mar 2023 18:45:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678214712;
	bh=cFV60SkEvHVpsIwdkGAuYWg9mK1dXn4zdnyELwZyc28=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Orz0COm2kr14DpUAq+6TtPKHXEQLKweEZhJD8ZYFMSMKSEhxFlBYAAj0Q0hr9xA86
	 RUlkT4J4/3hr9VL2RT7XFOgKnybf81cH/fy5HhtUi3LjLbZG1jMpq92+VrrKCBPiA8
	 jyron14lfw7gBZ5s785AZCuEDgIYiHPFsU2IbNRo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peng Fan <peng.fan@nxp.com>,
	Marek Vasut <marex@denx.de>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 009/567] arm64: dts: imx8m: Align SoC unique ID node unit address
Date: Tue,  7 Mar 2023 17:55:45 +0100
Message-Id: <20230307165906.235008271@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307165905.838066027@linuxfoundation.org>
References: <20230307165905.838066027@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Marek Vasut <marex@denx.de>

[ Upstream commit ee0d68f219be8618f53d3f8808952e20525e3f30 ]

Align the SoC unique ID DT node unit address with its reg property.

Reviewed-by: Peng Fan <peng.fan@nxp.com>
Fixes: cbff23797fa1 ("arm64: dts: imx8m: add NVMEM provider and consumer to read soc unique ID")
Signed-off-by: Marek Vasut <marex@denx.de>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx8mm.dtsi | 2 +-
 arch/arm64/boot/dts/freescale/imx8mn.dtsi | 2 +-
 arch/arm64/boot/dts/freescale/imx8mp.dtsi | 2 +-
 arch/arm64/boot/dts/freescale/imx8mq.dtsi | 2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/boot/dts/freescale/imx8mm.dtsi b/arch/arm64/boot/dts/freescale/imx8mm.dtsi
index 67e91fdfaf526..2a67122c5624c 100644
--- a/arch/arm64/boot/dts/freescale/imx8mm.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mm.dtsi
@@ -530,7 +530,7 @@ ocotp: efuse@30350000 {
 				#address-cells = <1>;
 				#size-cells = <1>;
 
-				imx8mm_uid: unique-id@410 {
+				imx8mm_uid: unique-id@4 {
 					reg = <0x4 0x8>;
 				};
 
diff --git a/arch/arm64/boot/dts/freescale/imx8mn.dtsi b/arch/arm64/boot/dts/freescale/imx8mn.dtsi
index 6dcead5bae620..0c47ff2426410 100644
--- a/arch/arm64/boot/dts/freescale/imx8mn.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mn.dtsi
@@ -533,7 +533,7 @@ ocotp: efuse@30350000 {
 				#address-cells = <1>;
 				#size-cells = <1>;
 
-				imx8mn_uid: unique-id@410 {
+				imx8mn_uid: unique-id@4 {
 					reg = <0x4 0x8>;
 				};
 
diff --git a/arch/arm64/boot/dts/freescale/imx8mp.dtsi b/arch/arm64/boot/dts/freescale/imx8mp.dtsi
index 664177ed38d3e..ab670b5d641b1 100644
--- a/arch/arm64/boot/dts/freescale/imx8mp.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mp.dtsi
@@ -358,7 +358,7 @@ ocotp: efuse@30350000 {
 				#address-cells = <1>;
 				#size-cells = <1>;
 
-				imx8mp_uid: unique-id@420 {
+				imx8mp_uid: unique-id@8 {
 					reg = <0x8 0x8>;
 				};
 
diff --git a/arch/arm64/boot/dts/freescale/imx8mq.dtsi b/arch/arm64/boot/dts/freescale/imx8mq.dtsi
index fd38092bb247e..2a698c5b87bcd 100644
--- a/arch/arm64/boot/dts/freescale/imx8mq.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mq.dtsi
@@ -557,7 +557,7 @@ ocotp: efuse@30350000 {
 				#address-cells = <1>;
 				#size-cells = <1>;
 
-				imx8mq_uid: soc-uid@410 {
+				imx8mq_uid: soc-uid@4 {
 					reg = <0x4 0x8>;
 				};
 
-- 
2.39.2



