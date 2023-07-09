Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C554522E
	for <patches@lists.linux.dev>; Sun,  9 Jul 2023 11:27:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEFB1C433C7;
	Sun,  9 Jul 2023 11:27:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1688902050;
	bh=LZM33kUP+/Ll0wEzU/2r2CoeBP0VHvLPncE79xQWt0A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o6EfwaoRSBgatdIptHjE25sPRVaMLYbGDStZpmICjuChyPtHo6GmJSwuLxW6R4Vwt
	 iyvCdZnOonr38DNsCLWZ6BVYx/5/YGf87YcG9Alc4YNqwPenx5WoiiPRxQlGRP0f/c
	 GhtpB11LeSch6471Yflrh71pBtXhkY1v0gxVOOeA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 237/431] arm64: dts: qcom: sm8350: correct PCI phy unit address
Date: Sun,  9 Jul 2023 13:13:05 +0200
Message-ID: <20230709111456.718326596@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230709111451.101012554@linuxfoundation.org>
References: <20230709111451.101012554@linuxfoundation.org>
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
index f0453730ab59b..1a258a5461acf 100644
--- a/arch/arm64/boot/dts/qcom/sm8350.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8350.dtsi
@@ -1625,7 +1625,7 @@ pcie1: pci@1c08000 {
 			status = "disabled";
 		};
 
-		pcie1_phy: phy@1c0f000 {
+		pcie1_phy: phy@1c0e000 {
 			compatible = "qcom,sm8350-qmp-gen3x2-pcie-phy";
 			reg = <0 0x01c0e000 0 0x2000>;
 			clocks = <&gcc GCC_PCIE_1_AUX_CLK>,
-- 
2.39.2



