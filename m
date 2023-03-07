Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68F0ABA45
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 18:02:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4127C433EF;
	Tue,  7 Mar 2023 18:02:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678212144;
	bh=bGgurPUCjy0O/9Wxec9PC85cWH6gJYQ+YaLoeHzIUxE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Lm6DdI3MVmTUnQs/2vqRglFOUlnVnZP4Uko5jfi04KzMXlpbu1bMDQnhKCGYuevGT
	 6vaVU8FuCshkZkZcu2yDfOO14XVtJ0xB4Ttm7NktpBwf1an3EZGvKKdNlt3pcQCjma
	 spblopbHW9B8MbnO5lFbaCNDPbo1RlXmTXqEFsbw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 092/885] arm64: dts: qcom: sm8350: drop incorrect cells from serial
Date: Tue,  7 Mar 2023 17:50:26 +0100
Message-Id: <20230307170005.824411410@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
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

[ Upstream commit 6027331e6eae9eb957d1b73a7e3255f4151d6163 ]

The serial/UART device node does not have children with unit addresses,
so address/size cells are not correct.

Fixes: cf03cd7e12bd ("arm64: dts: qcom: sm8350: Set up WRAP0 QUPs")
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20230124084951.38195-2-krzysztof.kozlowski@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm8350.dtsi | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sm8350.dtsi b/arch/arm64/boot/dts/qcom/sm8350.dtsi
index a6270d97a3192..ca7c428a741d4 100644
--- a/arch/arm64/boot/dts/qcom/sm8350.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8350.dtsi
@@ -1043,8 +1043,6 @@ uart2: serial@98c000 {
 				interrupts = <GIC_SPI 604 IRQ_TYPE_LEVEL_HIGH>;
 				power-domains = <&rpmhpd SM8350_CX>;
 				operating-points-v2 = <&qup_opp_table_100mhz>;
-				#address-cells = <1>;
-				#size-cells = <0>;
 				status = "disabled";
 			};
 
-- 
2.39.2



