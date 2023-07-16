Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D1718F74
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:08:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BE93C433C8;
	Sun, 16 Jul 2023 20:08:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689538094;
	bh=nI9mD7Tsyq6ezv9cXjjx/m5dpHoclwWtSBp/x/SXw4A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M90DVOVB9WFVzHZ9rNPIu8jGMdrclCQlDGXmsYeVMvI4227lFMIx+XNsPT65GBYmq
	 L9b6AthxEbNZpicAkwWzqYWP918FsT/+j2cEy4FSkA533sGR4TwlXTkbXbmvSr6cwC
	 GnpJ6Ii88NSimqLlO4FQjYzE3cpI9ADhev/F7M1M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 311/800] arm64: dts: qcom: sm6115: correct thermal-sensor unit address
Date: Sun, 16 Jul 2023 21:42:44 +0200
Message-ID: <20230716194956.298390225@linuxfoundation.org>
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

[ Upstream commit 2358b43256080459fcc5642265ed4fec75558f8c ]

Match unit-address to reg entry to fix dtbs W=1 warnings:

  Warning (simple_bus_reg): /soc@0/thermal-sensor@4410000: simple-bus unit address format error, expected "4411000"

Fixes: 7b74cba6b13f ("arm64: dts: qcom: sm6115: Add TSENS node")
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20230419211856.79332-12-krzysztof.kozlowski@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm6115.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sm6115.dtsi b/arch/arm64/boot/dts/qcom/sm6115.dtsi
index 43f31c1b9d5a7..ea71249bbdf3f 100644
--- a/arch/arm64/boot/dts/qcom/sm6115.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm6115.dtsi
@@ -700,7 +700,7 @@ spmi_bus: spmi@1c40000 {
 			#interrupt-cells = <4>;
 		};
 
-		tsens0: thermal-sensor@4410000 {
+		tsens0: thermal-sensor@4411000 {
 			compatible = "qcom,sm6115-tsens", "qcom,tsens-v2";
 			reg = <0x0 0x04411000 0x0 0x1ff>, /* TM */
 			      <0x0 0x04410000 0x0 0x8>; /* SROT */
-- 
2.39.2



