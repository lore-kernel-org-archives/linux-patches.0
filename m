Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E42AF1170E
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:04:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B52CC433C8;
	Mon, 11 Sep 2023 14:04:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694441043;
	bh=jigvmVxwQaaIqSVHKG+bT6zGyBPu2EJHbtzFmlkQNTM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yl2QOA5eclGNUM9nmcagLrTrgJ0T1NZAbN9YpT8ngDdw+CE/D1Xr2KtjITPoxpXFu
	 XUZqNi1VAretcC28sNv7c3TONKKVrGyAikeUOBylCAqzjWK/OsyGpSGjzhtb1b+7Tx
	 N4/sRoCYdUQLhILCBfWYn00e48xTUVWCWYB4pr9M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Vinod Koul <vkoul@kernel.org>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 275/739] arm64: dts: qcom: sc8180x-pmics: add missing gpio-ranges
Date: Mon, 11 Sep 2023 15:41:14 +0200
Message-ID: <20230911134658.808240129@linuxfoundation.org>
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

[ Upstream commit 565951b1202e1984154abaae4567f16f8073fca3 ]

The GPIO children of PMICs should use gpio-ranges:

  sc8180x-primus.dtb: pmic@0: gpio@c000: 'gpio-ranges' is a required property

Fixes: d3302290f59e ("arm64: dts: qcom: sc8180x: Add pmics")
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Reviewed-by: Vinod Koul <vkoul@kernel.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Link: https://lore.kernel.org/r/20230720083500.73554-2-krzysztof.kozlowski@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sc8180x-pmics.dtsi | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/sc8180x-pmics.dtsi b/arch/arm64/boot/dts/qcom/sc8180x-pmics.dtsi
index 675cad1fc53ba..b96ae45cd2df4 100644
--- a/arch/arm64/boot/dts/qcom/sc8180x-pmics.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc8180x-pmics.dtsi
@@ -145,6 +145,7 @@ pmc8180_gpios: gpio@c000 {
 			compatible = "qcom,pmc8180-gpio", "qcom,spmi-gpio";
 			reg = <0xc000>;
 			gpio-controller;
+			gpio-ranges = <&pmc8180_gpios 0 0 10>;
 			#gpio-cells = <2>;
 			interrupt-controller;
 			#interrupt-cells = <2>;
@@ -303,6 +304,7 @@ pmc8180c_gpios: gpio@c000 {
 			compatible = "qcom,pmc8180c-gpio", "qcom,spmi-gpio";
 			reg = <0xc000>;
 			gpio-controller;
+			gpio-ranges = <&pmc8180c_gpios 0 0 12>;
 			#gpio-cells = <2>;
 			interrupt-controller;
 			#interrupt-cells = <2>;
-- 
2.40.1



