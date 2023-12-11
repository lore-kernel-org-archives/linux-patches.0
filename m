Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60672FC06;
	Mon, 11 Dec 2023 18:44:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P0JqCpLm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D719EC433C8;
	Mon, 11 Dec 2023 18:44:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702320256;
	bh=ldaimszbesWT1MZFZhEk7npNjUt4KEJ5+1djyUIrFIc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P0JqCpLmNZoDDmjhxPhf5AheE+8pOexJ3YSM3a3N7IOz6B5VeK+Eg69TkmwKiP5lW
	 V7XGYbsho8VSSPoMzHQvYJ9vxqGgIsGQ2DY5oRXZj/JazXe8D/iL7YtkC+EDXBv0Ke
	 k89H6WqzxdosQ+/WRKqmzF99Xut0MdH9erz9k/h8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anson Huang <Anson.Huang@nxp.com>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 33/67] ARM: dts: imx: make gpt node name generic
Date: Mon, 11 Dec 2023 19:22:17 +0100
Message-ID: <20231211182016.492811768@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231211182015.049134368@linuxfoundation.org>
References: <20231211182015.049134368@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anson Huang <Anson.Huang@nxp.com>

[ Upstream commit 7c48b086965873c0aa93d99773cf64c033b76b2f ]

Node name should be generic, use "timer" instead of "gpt" for gpt node.

Signed-off-by: Anson Huang <Anson.Huang@nxp.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Stable-dep-of: 397caf68e2d3 ("ARM: dts: imx7: Declare timers compatible with fsl,imx6dl-gpt")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/imx6qdl.dtsi | 2 +-
 arch/arm/boot/dts/imx6sl.dtsi  | 2 +-
 arch/arm/boot/dts/imx6sx.dtsi  | 2 +-
 arch/arm/boot/dts/imx6ul.dtsi  | 4 ++--
 arch/arm/boot/dts/imx7s.dtsi   | 8 ++++----
 5 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/arch/arm/boot/dts/imx6qdl.dtsi b/arch/arm/boot/dts/imx6qdl.dtsi
index 861392ff70861..0150b2d5c534f 100644
--- a/arch/arm/boot/dts/imx6qdl.dtsi
+++ b/arch/arm/boot/dts/imx6qdl.dtsi
@@ -578,7 +578,7 @@
 				status = "disabled";
 			};
 
-			gpt: gpt@2098000 {
+			gpt: timer@2098000 {
 				compatible = "fsl,imx6q-gpt", "fsl,imx31-gpt";
 				reg = <0x02098000 0x4000>;
 				interrupts = <0 55 IRQ_TYPE_LEVEL_HIGH>;
diff --git a/arch/arm/boot/dts/imx6sl.dtsi b/arch/arm/boot/dts/imx6sl.dtsi
index 3cf1da06e7f04..fbbae0004e627 100644
--- a/arch/arm/boot/dts/imx6sl.dtsi
+++ b/arch/arm/boot/dts/imx6sl.dtsi
@@ -386,7 +386,7 @@
 				clock-names = "ipg", "per";
 			};
 
-			gpt: gpt@2098000 {
+			gpt: timer@2098000 {
 				compatible = "fsl,imx6sl-gpt";
 				reg = <0x02098000 0x4000>;
 				interrupts = <0 55 IRQ_TYPE_LEVEL_HIGH>;
diff --git a/arch/arm/boot/dts/imx6sx.dtsi b/arch/arm/boot/dts/imx6sx.dtsi
index 3dc1e97e145cd..1afeae14560ad 100644
--- a/arch/arm/boot/dts/imx6sx.dtsi
+++ b/arch/arm/boot/dts/imx6sx.dtsi
@@ -475,7 +475,7 @@
 				status = "disabled";
 			};
 
-			gpt: gpt@2098000 {
+			gpt: timer@2098000 {
 				compatible = "fsl,imx6sx-gpt", "fsl,imx6dl-gpt";
 				reg = <0x02098000 0x4000>;
 				interrupts = <GIC_SPI 55 IRQ_TYPE_LEVEL_HIGH>;
diff --git a/arch/arm/boot/dts/imx6ul.dtsi b/arch/arm/boot/dts/imx6ul.dtsi
index 5b677b66162ac..7037d2a45e60f 100644
--- a/arch/arm/boot/dts/imx6ul.dtsi
+++ b/arch/arm/boot/dts/imx6ul.dtsi
@@ -433,7 +433,7 @@
 				status = "disabled";
 			};
 
-			gpt1: gpt@2098000 {
+			gpt1: timer@2098000 {
 				compatible = "fsl,imx6ul-gpt", "fsl,imx6sx-gpt";
 				reg = <0x02098000 0x4000>;
 				interrupts = <GIC_SPI 55 IRQ_TYPE_LEVEL_HIGH>;
@@ -707,7 +707,7 @@
 				reg = <0x020e4000 0x4000>;
 			};
 
-			gpt2: gpt@20e8000 {
+			gpt2: timer@20e8000 {
 				compatible = "fsl,imx6ul-gpt", "fsl,imx6sx-gpt";
 				reg = <0x020e8000 0x4000>;
 				interrupts = <GIC_SPI 109 IRQ_TYPE_LEVEL_HIGH>;
diff --git a/arch/arm/boot/dts/imx7s.dtsi b/arch/arm/boot/dts/imx7s.dtsi
index 791530124fb0a..f774759af1aa3 100644
--- a/arch/arm/boot/dts/imx7s.dtsi
+++ b/arch/arm/boot/dts/imx7s.dtsi
@@ -446,7 +446,7 @@
 				fsl,input-sel = <&iomuxc>;
 			};
 
-			gpt1: gpt@302d0000 {
+			gpt1: timer@302d0000 {
 				compatible = "fsl,imx7d-gpt", "fsl,imx6sx-gpt";
 				reg = <0x302d0000 0x10000>;
 				interrupts = <GIC_SPI 55 IRQ_TYPE_LEVEL_HIGH>;
@@ -455,7 +455,7 @@
 				clock-names = "ipg", "per";
 			};
 
-			gpt2: gpt@302e0000 {
+			gpt2: timer@302e0000 {
 				compatible = "fsl,imx7d-gpt", "fsl,imx6sx-gpt";
 				reg = <0x302e0000 0x10000>;
 				interrupts = <GIC_SPI 54 IRQ_TYPE_LEVEL_HIGH>;
@@ -465,7 +465,7 @@
 				status = "disabled";
 			};
 
-			gpt3: gpt@302f0000 {
+			gpt3: timer@302f0000 {
 				compatible = "fsl,imx7d-gpt", "fsl,imx6sx-gpt";
 				reg = <0x302f0000 0x10000>;
 				interrupts = <GIC_SPI 53 IRQ_TYPE_LEVEL_HIGH>;
@@ -475,7 +475,7 @@
 				status = "disabled";
 			};
 
-			gpt4: gpt@30300000 {
+			gpt4: timer@30300000 {
 				compatible = "fsl,imx7d-gpt", "fsl,imx6sx-gpt";
 				reg = <0x30300000 0x10000>;
 				interrupts = <GIC_SPI 52 IRQ_TYPE_LEVEL_HIGH>;
-- 
2.42.0



