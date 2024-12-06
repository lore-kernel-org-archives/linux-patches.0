Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCBEA1442E8;
	Fri,  6 Dec 2024 14:55:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733496911; cv=none; b=gFoOhrGAJFJkLHPuSGTWUehJpM1XeukXGJFV8ssq5pj/64GH73e86AoKPJrxhZYK/5anrfb9WCQmjY6iXJcgSGzXhIR3JpQG3GGSsoxxjtDDx4IEoUeDY4vp+BNEEi69OuY5OZcOX0eeIBlyVCYEmqjq/ETqjs95RNwylezbjVI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733496911; c=relaxed/simple;
	bh=yi+aO/yOefc9GDd0K298wxVKPlUx2SlhdA54B1mUeFs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WejpJGszNdShr5wAAIDOK7Mcr9IaeK9WGQ9NNtfkzeJj/T1Ko89/MLrc0bueCsrC9YFHfAoNReqTjVSM8M3ExnbcIxCRDeilGd8uehHZ6lPv4uZ6xwXZIyoEj58Cq9KNfd7C/BkgK7eT6VM2KqkJ6/AjAEKcA11fVKVbfAicS5w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m5eBjH89; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m5eBjH89"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49737C4CED1;
	Fri,  6 Dec 2024 14:55:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733496910;
	bh=yi+aO/yOefc9GDd0K298wxVKPlUx2SlhdA54B1mUeFs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m5eBjH893IKilE2+CZD/lQUXJ5mSPMQrtIh1SHdQH+nvmieZZvNbXyXW1AYKdnLj1
	 Ndx0+FB0Y5BgsAiduArR7foeBpBM+N1uIxy/olNBwJL7vn7BF9VgohJ6765FNpkBM5
	 Q26xTpDyYuPN2KvhSBYJt96kPmMu5LtPBYViDSIo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anurag Dutta <a-dutta@ti.com>,
	Aniket Limaye <a-limaye@ti.com>,
	Vignesh Raghavendra <vigneshr@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 140/676] arm64: dts: ti: k3-j7200: Fix clock ids for MCSPI instances
Date: Fri,  6 Dec 2024 15:29:19 +0100
Message-ID: <20241206143658.823846772@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anurag Dutta <a-dutta@ti.com>

[ Upstream commit 3a47e381670f130870caef6e1155ac531b17b032 ]

The clock IDs for multiple MCSPI instances across wakeup as
well as main domain in J7200 are incorrect when compared with
documentation [1]. This results in kernel crashes when the said
instances are enabled. Fix the clock ids to their appropriate
values.

[1]https://software-dl.ti.com/tisci/esd/latest/5_soc_doc/j7200/clocks.html

Fixes: 8f6c475f4ca7 ("arm64: dts: ti: k3-j7200: Add MCSPI nodes")

Signed-off-by: Anurag Dutta <a-dutta@ti.com>
Reviewed-by: Aniket Limaye <a-limaye@ti.com>
Link: https://lore.kernel.org/r/20241023104532.3438851-2-a-dutta@ti.com
Signed-off-by: Vignesh Raghavendra <vigneshr@ti.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/ti/k3-j7200-main.dtsi       | 16 ++++++++--------
 arch/arm64/boot/dts/ti/k3-j7200-mcu-wakeup.dtsi |  6 +++---
 2 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/arch/arm64/boot/dts/ti/k3-j7200-main.dtsi b/arch/arm64/boot/dts/ti/k3-j7200-main.dtsi
index 6a221a50d7006..e5ff6f038a9ac 100644
--- a/arch/arm64/boot/dts/ti/k3-j7200-main.dtsi
+++ b/arch/arm64/boot/dts/ti/k3-j7200-main.dtsi
@@ -915,7 +915,7 @@ main_spi0: spi@2100000 {
 		#address-cells = <1>;
 		#size-cells = <0>;
 		power-domains = <&k3_pds 266 TI_SCI_PD_EXCLUSIVE>;
-		clocks = <&k3_clks 266 1>;
+		clocks = <&k3_clks 266 4>;
 		status = "disabled";
 	};
 
@@ -926,7 +926,7 @@ main_spi1: spi@2110000 {
 		#address-cells = <1>;
 		#size-cells = <0>;
 		power-domains = <&k3_pds 267 TI_SCI_PD_EXCLUSIVE>;
-		clocks = <&k3_clks 267 1>;
+		clocks = <&k3_clks 267 4>;
 		status = "disabled";
 	};
 
@@ -937,7 +937,7 @@ main_spi2: spi@2120000 {
 		#address-cells = <1>;
 		#size-cells = <0>;
 		power-domains = <&k3_pds 268 TI_SCI_PD_EXCLUSIVE>;
-		clocks = <&k3_clks 268 1>;
+		clocks = <&k3_clks 268 4>;
 		status = "disabled";
 	};
 
@@ -948,7 +948,7 @@ main_spi3: spi@2130000 {
 		#address-cells = <1>;
 		#size-cells = <0>;
 		power-domains = <&k3_pds 269 TI_SCI_PD_EXCLUSIVE>;
-		clocks = <&k3_clks 269 1>;
+		clocks = <&k3_clks 269 4>;
 		status = "disabled";
 	};
 
@@ -959,7 +959,7 @@ main_spi4: spi@2140000 {
 		#address-cells = <1>;
 		#size-cells = <0>;
 		power-domains = <&k3_pds 270 TI_SCI_PD_EXCLUSIVE>;
-		clocks = <&k3_clks 270 1>;
+		clocks = <&k3_clks 270 2>;
 		status = "disabled";
 	};
 
@@ -970,7 +970,7 @@ main_spi5: spi@2150000 {
 		#address-cells = <1>;
 		#size-cells = <0>;
 		power-domains = <&k3_pds 271 TI_SCI_PD_EXCLUSIVE>;
-		clocks = <&k3_clks 271 1>;
+		clocks = <&k3_clks 271 4>;
 		status = "disabled";
 	};
 
@@ -981,7 +981,7 @@ main_spi6: spi@2160000 {
 		#address-cells = <1>;
 		#size-cells = <0>;
 		power-domains = <&k3_pds 272 TI_SCI_PD_EXCLUSIVE>;
-		clocks = <&k3_clks 272 1>;
+		clocks = <&k3_clks 272 4>;
 		status = "disabled";
 	};
 
@@ -992,7 +992,7 @@ main_spi7: spi@2170000 {
 		#address-cells = <1>;
 		#size-cells = <0>;
 		power-domains = <&k3_pds 273 TI_SCI_PD_EXCLUSIVE>;
-		clocks = <&k3_clks 273 1>;
+		clocks = <&k3_clks 273 4>;
 		status = "disabled";
 	};
 
diff --git a/arch/arm64/boot/dts/ti/k3-j7200-mcu-wakeup.dtsi b/arch/arm64/boot/dts/ti/k3-j7200-mcu-wakeup.dtsi
index e5c35a53bb499..8e9d0a25e2366 100644
--- a/arch/arm64/boot/dts/ti/k3-j7200-mcu-wakeup.dtsi
+++ b/arch/arm64/boot/dts/ti/k3-j7200-mcu-wakeup.dtsi
@@ -481,7 +481,7 @@ mcu_spi0: spi@40300000 {
 		#address-cells = <1>;
 		#size-cells = <0>;
 		power-domains = <&k3_pds 274 TI_SCI_PD_EXCLUSIVE>;
-		clocks = <&k3_clks 274 0>;
+		clocks = <&k3_clks 274 4>;
 		status = "disabled";
 	};
 
@@ -492,7 +492,7 @@ mcu_spi1: spi@40310000 {
 		#address-cells = <1>;
 		#size-cells = <0>;
 		power-domains = <&k3_pds 275 TI_SCI_PD_EXCLUSIVE>;
-		clocks = <&k3_clks 275 0>;
+		clocks = <&k3_clks 275 4>;
 		status = "disabled";
 	};
 
@@ -503,7 +503,7 @@ mcu_spi2: spi@40320000 {
 		#address-cells = <1>;
 		#size-cells = <0>;
 		power-domains = <&k3_pds 276 TI_SCI_PD_EXCLUSIVE>;
-		clocks = <&k3_clks 276 0>;
+		clocks = <&k3_clks 276 2>;
 		status = "disabled";
 	};
 
-- 
2.43.0



