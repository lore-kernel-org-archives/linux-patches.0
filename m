Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71CAE8F74
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:09:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B1BBC433C7;
	Sun, 16 Jul 2023 20:09:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689538149;
	bh=j4och7nCAkF13DV5Uw0/KIW4DGuQsKygYq1aIi/WC0w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wVQadmcgUqb8sAsEwbjckII9bn7+PKzQZJlE4r5/eR+gIaL1vNY2TdUnwxTU8ka7H
	 0FYr08gyoNI6Rsknrq6mGyD0/68nssNGi0lkjv/l9ays4QiTF3Z4fncpXG+b3d4IFq
	 Lice74Ka1RaVM2NB+7797CMDKkA+GJLYeLVwItVY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 314/800] arm64: dts: qcom: sm8350: correct USB phy unit address
Date: Sun, 16 Jul 2023 21:42:47 +0200
Message-ID: <20230716194956.366926241@linuxfoundation.org>
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

[ Upstream commit a560ab70c6e28ba784a824611d3f58969d8fadba ]

Match unit-address to reg entry to fix dtbs W=1 warnings:

  Warning (simple_bus_reg): /soc@0/phy@88e9000: simple-bus unit address format error, expected "88e8000"

Fixes: 2458a305e80e ("arm64: dts: qcom: sm8350: switch to combo usb3/dp phy")
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20230419211856.79332-15-krzysztof.kozlowski@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm8350.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sm8350.dtsi b/arch/arm64/boot/dts/qcom/sm8350.dtsi
index 5ca21cd1cbec6..425af2c38a37f 100644
--- a/arch/arm64/boot/dts/qcom/sm8350.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8350.dtsi
@@ -2140,7 +2140,7 @@ usb_2_hsphy: phy@88e4000 {
 			resets = <&gcc GCC_QUSB2PHY_SEC_BCR>;
 		};
 
-		usb_1_qmpphy: phy@88e9000 {
+		usb_1_qmpphy: phy@88e8000 {
 			compatible = "qcom,sm8350-qmp-usb3-dp-phy";
 			reg = <0 0x088e8000 0 0x3000>;
 
-- 
2.39.2



