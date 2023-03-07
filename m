Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 507BCBA32
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 17:12:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9174C433D2;
	Tue,  7 Mar 2023 17:11:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678209120;
	bh=Eyw4/AAX1upy7ATTPOyAtsIXf9uvSc1IdxeAslwuS48=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YgaiXV0Y6V//XbgII0fquxkZmvhXwPlhMYqpLBHtYhMWzP74kp13jqDBdJttDq47d
	 5fSY1o+aFYMWam6LGW/uC7c58whRc60eI+XW9Qv9tqCyHJmr7djEKSkYbwfndY2lSy
	 YaGcUYJ+OPuSFVAjwogMT5pySho4e6HIJVeC5hhc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Luca Weiss <luca@z3ntu.xyz>,
	Linus Walleij <linus.walleij@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0116/1001] arm64: dts: qcom: msm8953: correct TLMM gpio-ranges
Date: Tue,  7 Mar 2023 17:48:08 +0100
Message-Id: <20230307170027.142751149@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
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

[ Upstream commit a4fb71497df23cb0d02d70fa2b8f8786328e325d ]

Correct the number of GPIOs in TLMM pin controller.

Fixes: 9fb08c801923 ("arm64: dts: qcom: Add MSM8953 device tree")
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Reviewed-by: Luca Weiss <luca@z3ntu.xyz>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20230202104452.299048-10-krzysztof.kozlowski@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/msm8953.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/msm8953.dtsi b/arch/arm64/boot/dts/qcom/msm8953.dtsi
index 32349174c4bd9..70f033656b555 100644
--- a/arch/arm64/boot/dts/qcom/msm8953.dtsi
+++ b/arch/arm64/boot/dts/qcom/msm8953.dtsi
@@ -455,7 +455,7 @@ tlmm: pinctrl@1000000 {
 			reg = <0x1000000 0x300000>;
 			interrupts = <GIC_SPI 208 IRQ_TYPE_LEVEL_HIGH>;
 			gpio-controller;
-			gpio-ranges = <&tlmm 0 0 155>;
+			gpio-ranges = <&tlmm 0 0 142>;
 			#gpio-cells = <2>;
 			interrupt-controller;
 			#interrupt-cells = <2>;
-- 
2.39.2



