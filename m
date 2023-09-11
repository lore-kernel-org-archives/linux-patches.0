Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 124811170E
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:04:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83B71C433C7;
	Mon, 11 Sep 2023 14:04:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694441040;
	bh=r5JkbOVkajtw21ouMhaxPtef1+tSsn4f11BecnqXj5Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q0Gna+dprt88Im5vwymLCP9PITziNI/o11htPfXNyt4KuPBAWFgvxHTyeq2GrpWnf
	 JlgJ+iuFIAht5IkUvw1f1syF5Ox/pa/0RMQUiWOoFfxdu5k9yv6kIFT07E6NcIALL3
	 RiW4PaPVQoPzQwDHEVk6NPlNsi4WDlPmdLcpTeLY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Vinod Koul <vkoul@kernel.org>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 274/739] arm64: dts: qcom: sc8180x-pmics: add missing qcom,spmi-gpio fallbacks
Date: Mon, 11 Sep 2023 15:41:13 +0200
Message-ID: <20230911134658.782133731@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.921299741@linuxfoundation.org>
References: <20230911134650.921299741@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

[ Upstream commit 0304fc1de3d930db83749cca6ccb3a4f89918fc4 ]

The GPIO children of PMICs should use qcom,spmi-gpio fallback:

  sc8180x-primus.dtb: pmic@0: gpio@c000:compatible: ['qcom,pmc8180-gpio'] is too short

Fixes: d3302290f59e ("arm64: dts: qcom: sc8180x: Add pmics")
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Reviewed-by: Vinod Koul <vkoul@kernel.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Link: https://lore.kernel.org/r/20230720083500.73554-1-krzysztof.kozlowski@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sc8180x-pmics.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sc8180x-pmics.dtsi b/arch/arm64/boot/dts/qcom/sc8180x-pmics.dtsi
index 8247af01c84a5..675cad1fc53ba 100644
--- a/arch/arm64/boot/dts/qcom/sc8180x-pmics.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc8180x-pmics.dtsi
@@ -142,7 +142,7 @@ rtc@6000 {
 		};
 
 		pmc8180_gpios: gpio@c000 {
-			compatible = "qcom,pmc8180-gpio";
+			compatible = "qcom,pmc8180-gpio", "qcom,spmi-gpio";
 			reg = <0xc000>;
 			gpio-controller;
 			#gpio-cells = <2>;
@@ -300,7 +300,7 @@ pmc8180c_adc_tm: adc-tm@3500 {
 		};
 
 		pmc8180c_gpios: gpio@c000 {
-			compatible = "qcom,pmc8180c-gpio";
+			compatible = "qcom,pmc8180c-gpio", "qcom,spmi-gpio";
 			reg = <0xc000>;
 			gpio-controller;
 			#gpio-cells = <2>;
-- 
2.40.1



