Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30A50168C9
	for <patches@lists.linux.dev>; Mon,  8 May 2023 11:05:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 721B9C433EF;
	Mon,  8 May 2023 11:05:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683543952;
	bh=iX5XMkUFMuDygRfGBIV87vdQ/RiHLP+Gyj2ti7No77Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2bwpm4Pz7CWPL93QMFROS/4jeKK2K0bCWAJOGXee+sFp7Tpyz9yVD7bwX9I29gUmC
	 Ax5UK8rnjzIJWPWf8SzHkw9Ri7jObNwqb77i4S6GN6gXfB5negKkrKOhfgXzEj2H40
	 ZKOM/eLAwqN9PDcWG+T+W3SN7dxRTXNn1Bx/ygoc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 255/694] arm64: dts: qcom: sc8280xp: correct Soundwire wakeup interrupt name
Date: Mon,  8 May 2023 11:41:30 +0200
Message-Id: <20230508094440.579371830@linuxfoundation.org>
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

[ Upstream commit 894e258b6a38922f9860a20ca07cf2f745e3b090 ]

The bindings expect second Soundwire interrupt to be "wakeup" (Linux
driver takes by index):

  sc8280xp-crd.dtb: soundwire-controller@3330000: interrupt-names:1: 'wakeup' was expected

Fixes: c18773d162a6 ("arm64: dts: qcom: sc8280xp: add SoundWire and LPASS")
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20230403132328.61414-1-krzysztof.kozlowski@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sc8280xp.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sc8280xp.dtsi b/arch/arm64/boot/dts/qcom/sc8280xp.dtsi
index 80401834bb063..03b679b75201d 100644
--- a/arch/arm64/boot/dts/qcom/sc8280xp.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc8280xp.dtsi
@@ -2598,7 +2598,7 @@
 			reg = <0 0x03330000 0 0x2000>;
 			interrupts-extended = <&intc GIC_SPI 959 IRQ_TYPE_LEVEL_HIGH>,
 					      <&intc GIC_SPI 520 IRQ_TYPE_LEVEL_HIGH>;
-			interrupt-names = "core", "wake";
+			interrupt-names = "core", "wakeup";
 
 			clocks = <&txmacro>;
 			clock-names = "iface";
-- 
2.39.2



