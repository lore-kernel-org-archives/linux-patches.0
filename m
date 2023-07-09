Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41086522E
	for <patches@lists.linux.dev>; Sun,  9 Jul 2023 11:27:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B351EC433C8;
	Sun,  9 Jul 2023 11:27:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1688902024;
	bh=moNWf2Cekf5gq3oISl9nlIKWeKhi1S8rYAXODb34hn4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T5kzD33wOstTQXewO7v+SDWRsBpOAEvy0JmlN4V/SDOku4Gi0dhtpzRxSxEhyx15R
	 2bp3lvoqu+WGR2Mh0Cem6Uc3fD0au9NFY37M+PAeIsTXLf41h7pybjHJ4ETLqxlpx4
	 r8CuK/gwlBxMLrEcV6tPpV1YRgQlnLRd9zRSiDw4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 229/431] arm64: dts: qcom: msm8953: correct IOMMU unit address
Date: Sun,  9 Jul 2023 13:12:57 +0200
Message-ID: <20230709111456.536797793@linuxfoundation.org>
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

[ Upstream commit 1c06b93461ec9df8a5878947db4a9d2d1cb72855 ]

Match unit-address to reg entry to fix dtbs W=1 warnings:

  Warning (simple_bus_reg): /soc@0/iommu@1e00000: simple-bus unit address format error, expected "1e20000"

Fixes: c0b9575a3606 ("arm64: dts: qcom: msm8953: add APPS IOMMU")
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20230419211856.79332-5-krzysztof.kozlowski@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/msm8953.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/msm8953.dtsi b/arch/arm64/boot/dts/qcom/msm8953.dtsi
index 610f3e3fc0c22..7001f6b0b9f9a 100644
--- a/arch/arm64/boot/dts/qcom/msm8953.dtsi
+++ b/arch/arm64/boot/dts/qcom/msm8953.dtsi
@@ -878,7 +878,7 @@ dsi1_phy: phy@1a96400 {
 			};
 		};
 
-		apps_iommu: iommu@1e00000 {
+		apps_iommu: iommu@1e20000 {
 			compatible = "qcom,msm8953-iommu", "qcom,msm-iommu-v1";
 			ranges  = <0 0x1e20000 0x20000>;
 
-- 
2.39.2



