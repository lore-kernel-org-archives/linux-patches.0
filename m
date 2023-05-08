Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B26E2168C9
	for <patches@lists.linux.dev>; Mon,  8 May 2023 11:03:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFAF3C433EF;
	Mon,  8 May 2023 11:03:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683543821;
	bh=stvT1wAyDHRyeKNqx6jb7bMr4DlrjWiXUTv1uHvuryQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r2V8mRgNxVNRhKrt/SowAvlswaqhqKnCV763KgSZs6GwsfCB5TXGGXU6NeOSaXo6d
	 OZzl7gDz3yQbw2mPgTey5CeMeyVJMEMaOv32SDHJdHT/YQdKGfmM+GF2Tiv1gPRree
	 aORKdQaJgDzGxFe0NzFnfDLlnIJvWW+msgC1NIq0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 181/694] arm64: dts: qcom: qdu1000: drop incorrect serial properties
Date: Mon,  8 May 2023 11:40:16 +0200
Message-Id: <20230508094438.311983851@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094432.603705160@linuxfoundation.org>
References: <20230508094432.603705160@linuxfoundation.org>
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

[ Upstream commit 9b8bfc443349c0c220438c6ac8839774210c9ba2 ]

The serial node does not use/allow address/size cells:

  qdu1000-idp.dtb: geniqup@9c0000: serial@99c000: Unevaluated properties are not allowed ('#address-cells', '#size-cells' were unexpected)

Fixes: 6bd20c54b589 ("arm64: dts: qcom: Add base QDU1000/QRU1000 DTSIs")
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20230308125906.236885-3-krzysztof.kozlowski@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/qdu1000.dtsi | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/qdu1000.dtsi b/arch/arm64/boot/dts/qcom/qdu1000.dtsi
index f234159d2060e..c72a51c32a300 100644
--- a/arch/arm64/boot/dts/qcom/qdu1000.dtsi
+++ b/arch/arm64/boot/dts/qcom/qdu1000.dtsi
@@ -412,8 +412,6 @@
 				pinctrl-0 = <&qup_uart0_default>;
 				pinctrl-names = "default";
 				interrupts = <GIC_SPI 601 IRQ_TYPE_LEVEL_HIGH>;
-				#address-cells = <1>;
-				#size-cells = <0>;
 				status = "disabled";
 			};
 
@@ -581,8 +579,6 @@
 				pinctrl-0 = <&qup_uart7_tx>, <&qup_uart7_rx>;
 				pinctrl-names = "default";
 				interrupts = <GIC_SPI 608 IRQ_TYPE_LEVEL_HIGH>;
-				#address-cells = <1>;
-				#size-cells = <0>;
 				status = "disabled";
 			};
 		};
-- 
2.39.2



