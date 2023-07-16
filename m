Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CA7D8F74
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:09:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF502C433C8;
	Sun, 16 Jul 2023 20:09:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689538147;
	bh=aTl0MXn4GPxo76BDtJG5k+ywGJNbShqLJvGBLe2qhgY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z2RsCdKx6znVdhhtZoRnt5KsANE8warUq22lkYYNO5521mdLgISZJ/n0oA3nIufgQ
	 ZCNAdbXN0xm4UKvuFlmdNxjWFvPmHmeGmRagq3dv575ox1wwbiu+1aIswY5H1ypXNU
	 xS9Va2tB+HtRyYzZBhiJ4UlygjWDeqSy8mGkjzvw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 313/800] arm64: dts: qcom: sm8350: correct PCI phy unit address
Date: Sun, 16 Jul 2023 21:42:46 +0200
Message-ID: <20230716194956.343968057@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194949.099592437@linuxfoundation.org>
References: <20230716194949.099592437@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

[ Upstream commit ab98c21bc9246f421a6ae70e69f1b73cea6f85e3 ]

Match unit-address to reg entry to fix dtbs W=1 warnings:

  Warning (simple_bus_reg): /soc@0/phy@1c0f000: simple-bus unit address format error, expected "1c0e000"

Fixes: 6daee40678a0 ("arm64: dts: qcom: sm8350: add PCIe devices")
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20230419211856.79332-14-krzysztof.kozlowski@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm8350.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sm8350.dtsi b/arch/arm64/boot/dts/qcom/sm8350.dtsi
index a9af730e0b1c0..5ca21cd1cbec6 100644
--- a/arch/arm64/boot/dts/qcom/sm8350.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8350.dtsi
@@ -1638,7 +1638,7 @@ pcie1: pci@1c08000 {
 			status = "disabled";
 		};
 
-		pcie1_phy: phy@1c0f000 {
+		pcie1_phy: phy@1c0e000 {
 			compatible = "qcom,sm8350-qmp-gen3x2-pcie-phy";
 			reg = <0 0x01c0e000 0 0x2000>;
 			clocks = <&gcc GCC_PCIE_1_AUX_CLK>,
-- 
2.39.2



