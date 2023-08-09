Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 694D617AAD
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 11:33:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D76C6C433C8;
	Wed,  9 Aug 2023 11:33:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691580808;
	bh=vymIiQPiC+ZheR4SGZ9/OtZWUbS0CfwJSSBinSlp4Ac=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oPF7I3hDtBiDmNy3e0wEsZy5AxaAxiFuSrve5I7BK8r7sAEgMhWYS3/2jdcziAfe4
	 EDg61J5oNoxxzK/LJpcMhEB5J4jpMmQFwmpUp5AjANSjLioRNNothPLun3ZifdqLO4
	 SeZWGHSiQzuWzbO/3Ju+ad4GtNZlM6jFrEZ6jocI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzk@kernel.org>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 147/154] ARM: dts: imx: Align L2 cache-controller nodename with dtschema
Date: Wed,  9 Aug 2023 12:42:58 +0200
Message-ID: <20230809103641.719143652@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230809103636.887175326@linuxfoundation.org>
References: <20230809103636.887175326@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Krzysztof Kozlowski <krzk@kernel.org>

[ Upstream commit 69cc1502a87f5ed12e27dbe5fe2bfdd5540826c7 ]

Fix dtschema validator warnings like:
    l2-cache@a02000: $nodename:0:
        'l2-cache@a02000' does not match '^(cache-controller|cpu)(@[0-9a-f,]+)*$'

Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Stable-dep-of: ee70b908f77a ("ARM: dts: nxp/imx6sll: fix wrong property name in usbphy node")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/imx35.dtsi   | 2 +-
 arch/arm/boot/dts/imx6qdl.dtsi | 2 +-
 arch/arm/boot/dts/imx6sl.dtsi  | 2 +-
 arch/arm/boot/dts/imx6sll.dtsi | 2 +-
 arch/arm/boot/dts/imx6sx.dtsi  | 2 +-
 5 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/arm/boot/dts/imx35.dtsi b/arch/arm/boot/dts/imx35.dtsi
index 9cbdc1a15cda2..d326b18333d15 100644
--- a/arch/arm/boot/dts/imx35.dtsi
+++ b/arch/arm/boot/dts/imx35.dtsi
@@ -59,7 +59,7 @@ soc {
 		interrupt-parent = <&avic>;
 		ranges;
 
-		L2: l2-cache@30000000 {
+		L2: cache-controller@30000000 {
 			compatible = "arm,l210-cache";
 			reg = <0x30000000 0x1000>;
 			cache-unified;
diff --git a/arch/arm/boot/dts/imx6qdl.dtsi b/arch/arm/boot/dts/imx6qdl.dtsi
index e9955ef12e02d..9105e614fe5c6 100644
--- a/arch/arm/boot/dts/imx6qdl.dtsi
+++ b/arch/arm/boot/dts/imx6qdl.dtsi
@@ -255,7 +255,7 @@ intc: interrupt-controller@a01000 {
 			interrupt-parent = <&intc>;
 		};
 
-		L2: l2-cache@a02000 {
+		L2: cache-controller@a02000 {
 			compatible = "arm,pl310-cache";
 			reg = <0x00a02000 0x1000>;
 			interrupts = <0 92 IRQ_TYPE_LEVEL_HIGH>;
diff --git a/arch/arm/boot/dts/imx6sl.dtsi b/arch/arm/boot/dts/imx6sl.dtsi
index 852f66944c7d4..452a77552e3d0 100644
--- a/arch/arm/boot/dts/imx6sl.dtsi
+++ b/arch/arm/boot/dts/imx6sl.dtsi
@@ -136,7 +136,7 @@ intc: interrupt-controller@a01000 {
 			interrupt-parent = <&intc>;
 		};
 
-		L2: l2-cache@a02000 {
+		L2: cache-controller@a02000 {
 			compatible = "arm,pl310-cache";
 			reg = <0x00a02000 0x1000>;
 			interrupts = <0 92 IRQ_TYPE_LEVEL_HIGH>;
diff --git a/arch/arm/boot/dts/imx6sll.dtsi b/arch/arm/boot/dts/imx6sll.dtsi
index cf81c7b949e62..27c253d0fdde2 100644
--- a/arch/arm/boot/dts/imx6sll.dtsi
+++ b/arch/arm/boot/dts/imx6sll.dtsi
@@ -137,7 +137,7 @@ intc: interrupt-controller@a01000 {
 			interrupt-parent = <&intc>;
 		};
 
-		L2: l2-cache@a02000 {
+		L2: cache-controller@a02000 {
 			compatible = "arm,pl310-cache";
 			reg = <0x00a02000 0x1000>;
 			interrupts = <GIC_SPI 92 IRQ_TYPE_LEVEL_HIGH>;
diff --git a/arch/arm/boot/dts/imx6sx.dtsi b/arch/arm/boot/dts/imx6sx.dtsi
index b3e24d8bd2994..072d5fc9c6db9 100644
--- a/arch/arm/boot/dts/imx6sx.dtsi
+++ b/arch/arm/boot/dts/imx6sx.dtsi
@@ -187,7 +187,7 @@ intc: interrupt-controller@a01000 {
 			interrupt-parent = <&intc>;
 		};
 
-		L2: l2-cache@a02000 {
+		L2: cache-controller@a02000 {
 			compatible = "arm,pl310-cache";
 			reg = <0x00a02000 0x1000>;
 			interrupts = <GIC_SPI 92 IRQ_TYPE_LEVEL_HIGH>;
-- 
2.40.1



