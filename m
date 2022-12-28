Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98B861863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 14:56:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DD3BC433D2;
	Wed, 28 Dec 2022 14:56:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672239377;
	bh=i0sbboUH7sugM0nN0ENrAgkdSVcY/+my5b1FoJFG+gk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=toCueRiCIF5ezfjnxGMT5ATm1dtRqpMa4m9HWY922WDNaBB7UFjHJpgs+BFLes5zn
	 +A+rysHGSHEnnMQfdjrAbubAw6eFTioDNc9eyMtipOxa6k5XJ8q5YyuNu1JEG0wkm4
	 0GTx+hns3GCHt3ZlWqmdNsnVls3/GW0h8SQliDHU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Padmanabhan Rajanbabu <p.rajanbabu@samsung.com>,
	Alim Akhtar <alim.akhtar@samsung.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0019/1073] arm64: dts: fsd: fix drive strength macros as per FSD HW UM
Date: Wed, 28 Dec 2022 15:26:47 +0100
Message-Id: <20221228144328.677757224@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Padmanabhan Rajanbabu <p.rajanbabu@samsung.com>

[ Upstream commit 574d6c59daefb51729b0640465f007f6c9600358 ]

Drive strength macros defined for FSD platform is not reflecting actual
names and values as per HW UM. FSD SoC pinctrl has following four levels
of drive-strength and their corresponding values:
Level-1 <-> 0
Level-2 <-> 1
Level-4 <-> 2
Level-6 <-> 3

The commit 684dac402f21 ("arm64: dts: fsd: Add initial pinctrl support")
used drive strength macros defined for Exynos4 SoC family. For some IPs
the macros values of Exynos4 matched and worked well, but Exynos4 SoC
family drive-strength (names and values) is not exactly matching with
FSD SoC.

Fix the drive strength macros to reflect actual names and values given
in FSD HW UM.

Fixes: 684dac402f21 ("arm64: dts: fsd: Add initial pinctrl support")
Signed-off-by: Padmanabhan Rajanbabu <p.rajanbabu@samsung.com>
Reviewed-by: Alim Akhtar <alim.akhtar@samsung.com>
Link: https://lore.kernel.org/r/20221013104024.50179-2-p.rajanbabu@samsung.com
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/tesla/fsd-pinctrl.dtsi | 8 ++++----
 arch/arm64/boot/dts/tesla/fsd-pinctrl.h    | 6 +++---
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/boot/dts/tesla/fsd-pinctrl.dtsi b/arch/arm64/boot/dts/tesla/fsd-pinctrl.dtsi
index d0abb9aa0e9e..4e151d419909 100644
--- a/arch/arm64/boot/dts/tesla/fsd-pinctrl.dtsi
+++ b/arch/arm64/boot/dts/tesla/fsd-pinctrl.dtsi
@@ -55,14 +55,14 @@ ufs_rst_n: ufs-rst-n-pins {
 		samsung,pins = "gpf5-0";
 		samsung,pin-function = <FSD_PIN_FUNC_2>;
 		samsung,pin-pud = <FSD_PIN_PULL_NONE>;
-		samsung,pin-drv = <FSD_PIN_DRV_LV2>;
+		samsung,pin-drv = <FSD_PIN_DRV_LV4>;
 	};
 
 	ufs_refclk_out: ufs-refclk-out-pins {
 		samsung,pins = "gpf5-1";
 		samsung,pin-function = <FSD_PIN_FUNC_2>;
 		samsung,pin-pud = <FSD_PIN_PULL_NONE>;
-		samsung,pin-drv = <FSD_PIN_DRV_LV2>;
+		samsung,pin-drv = <FSD_PIN_DRV_LV4>;
 	};
 };
 
@@ -239,14 +239,14 @@ pwm0_out: pwm0-out-pins {
 		samsung,pins = "gpb6-1";
 		samsung,pin-function = <FSD_PIN_FUNC_2>;
 		samsung,pin-pud = <FSD_PIN_PULL_UP>;
-		samsung,pin-drv = <FSD_PIN_DRV_LV2>;
+		samsung,pin-drv = <FSD_PIN_DRV_LV4>;
 	};
 
 	pwm1_out: pwm1-out-pins {
 		samsung,pins = "gpb6-5";
 		samsung,pin-function = <FSD_PIN_FUNC_2>;
 		samsung,pin-pud = <FSD_PIN_PULL_UP>;
-		samsung,pin-drv = <FSD_PIN_DRV_LV2>;
+		samsung,pin-drv = <FSD_PIN_DRV_LV4>;
 	};
 
 	hs_i2c0_bus: hs-i2c0-bus-pins {
diff --git a/arch/arm64/boot/dts/tesla/fsd-pinctrl.h b/arch/arm64/boot/dts/tesla/fsd-pinctrl.h
index 6ffbda362493..c397d02208a0 100644
--- a/arch/arm64/boot/dts/tesla/fsd-pinctrl.h
+++ b/arch/arm64/boot/dts/tesla/fsd-pinctrl.h
@@ -16,9 +16,9 @@
 #define FSD_PIN_PULL_UP			3
 
 #define FSD_PIN_DRV_LV1			0
-#define FSD_PIN_DRV_LV2			2
-#define FSD_PIN_DRV_LV3			1
-#define FSD_PIN_DRV_LV4			3
+#define FSD_PIN_DRV_LV2			1
+#define FSD_PIN_DRV_LV4			2
+#define FSD_PIN_DRV_LV6			3
 
 #define FSD_PIN_FUNC_INPUT		0
 #define FSD_PIN_FUNC_OUTPUT		1
-- 
2.35.1



