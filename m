Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99A0111711
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:04:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09444C433C8;
	Mon, 11 Sep 2023 14:04:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694441049;
	bh=gs7hxhKO1DMTVC1WMVz9z5/9Imj35MB2VlGsUTjPH+8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=up4ib8CZW1V4c1WqtuDuX6vGasIWjhBqEO7PIJl/ztmlFKKegf+0VbgrDVgzB02xf
	 SPSyjGIc8pfdUve9TQbbmXQKQhyXqGFVoH5omCQWodzZ5JyfEyCRke6KEqncGEQAco
	 G7ivXqX8CHoht+5L/Ks5ykuDq+Liw8iHHrJn/Dcw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Vinod Koul <vkoul@kernel.org>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 277/739] arm64: dts: qcom: sc8180x-pmics: align LPG node name with dtschema
Date: Mon, 11 Sep 2023 15:41:16 +0200
Message-ID: <20230911134658.861530254@linuxfoundation.org>
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

[ Upstream commit 4af302a7e29e70bd930e80ab8f967da48a99a31a ]

Bindings expect the LPG node name to be "pwm":

  sc8180x-lenovo-flex-5g.dtb: pmic@5: 'lpg' does not match any of the regexes:

Fixes: d3302290f59e ("arm64: dts: qcom: sc8180x: Add pmics")
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Reviewed-by: Vinod Koul <vkoul@kernel.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Link: https://lore.kernel.org/r/20230720083500.73554-4-krzysztof.kozlowski@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sc8180x-pmics.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sc8180x-pmics.dtsi b/arch/arm64/boot/dts/qcom/sc8180x-pmics.dtsi
index ffd374b9b3158..925047af734fc 100644
--- a/arch/arm64/boot/dts/qcom/sc8180x-pmics.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc8180x-pmics.dtsi
@@ -315,7 +315,7 @@ pmic@5 {
 		compatible = "qcom,pmc8180c", "qcom,spmi-pmic";
 		reg = <0x5 SPMI_USID>;
 
-		pmc8180c_lpg: lpg {
+		pmc8180c_lpg: pwm {
 			compatible = "qcom,pmc8180c-lpg";
 
 			#address-cells = <1>;
-- 
2.40.1



