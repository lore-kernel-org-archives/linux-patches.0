Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C22C3168AD
	for <patches@lists.linux.dev>; Mon,  8 May 2023 10:29:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27A02C433D2;
	Mon,  8 May 2023 10:29:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683541747;
	bh=4kb1BVsR6tuyS6MnzcNohYsuXbtHG2c5YLYRErzwmtg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DW5dB2k67Cf4VJuyAtdWtC4ztPyEMDLnw4b8EI1HJGEP94ufSHlV9Dr95e4VW8ILz
	 O1psyMF09UfRnCOQ7hIlN59Mk6UH4NizYGTUlxFFp1OYNldEaHttm2W5gY0ljL/xZG
	 Xb8HRr3QyvszdXqM4OHT1nqD7ALRvMexuwOMDt4g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Stephen Boyd <swboyd@chromium.org>,
	Douglas Anderson <dianders@chromium.org>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 215/663] arm64: dts: qcom: sc7280-herobrine-villager: correct trackpad supply
Date: Mon,  8 May 2023 11:40:41 +0200
Message-Id: <20230508094435.328867433@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094428.384831245@linuxfoundation.org>
References: <20230508094428.384831245@linuxfoundation.org>
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

[ Upstream commit de88b1759b35086d5e63736fb604ea2d06486b1a ]

The hid-over-i2c takes VDD, not VCC supply.  Fix copy-pasta from other
Herobrine boards which use elan,ekth3000 with valid VCC:

  sc7280-herobrine-villager-r1-lte.dtb: trackpad@2c: 'vcc-supply' does not match any of the regexes: 'pinctrl-[0-9]+'

Fixes: ee2a62116015 ("arm64: dts: qcom: sc7280: Add device tree for herobrine villager")
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Reviewed-by: Stephen Boyd <swboyd@chromium.org>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20230312183622.460488-2-krzysztof.kozlowski@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sc7280-herobrine-villager.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sc7280-herobrine-villager.dtsi b/arch/arm64/boot/dts/qcom/sc7280-herobrine-villager.dtsi
index 17553e0fd6fd9..43d76ea8869fb 100644
--- a/arch/arm64/boot/dts/qcom/sc7280-herobrine-villager.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc7280-herobrine-villager.dtsi
@@ -33,7 +33,7 @@ ap_tp_i2c: &i2c0 {
 		interrupts = <7 IRQ_TYPE_EDGE_FALLING>;
 
 		hid-descr-addr = <0x20>;
-		vcc-supply = <&pp3300_z1>;
+		vdd-supply = <&pp3300_z1>;
 
 		wakeup-source;
 	};
-- 
2.39.2



