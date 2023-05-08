Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43F57168C9
	for <patches@lists.linux.dev>; Mon,  8 May 2023 11:07:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD9A1C433EF;
	Mon,  8 May 2023 11:07:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683544037;
	bh=IbA2kI44DiybcmENrfW6ndxjyPxEF2oKV1ME6S9IHSo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GGMPnPSMh2O01LIXn9z4/ZY3NEDKvLMKf8x509bFa36SPpeaiXYP/0MPU9rtvZWhf
	 qvt/KokOxheYV+G8t9r2sBTcsPYfIx96Qeq0kELwbVKi1AT/EU3r2HRRudukGjnvU5
	 W80kXoHbSv6xQHtXUV2IEA6kTQwdLRHP5rYb+DRg=
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
Subject: [PATCH 6.3 250/694] arm64: dts: qcom: sc7180-trogdor-pazquel: correct trackpad supply
Date: Mon,  8 May 2023 11:41:25 +0200
Message-Id: <20230508094440.415158356@linuxfoundation.org>
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

[ Upstream commit 24f39eec6a70768e7c2eb2f3d8158f45050ff75a ]

The hid-over-i2c takes VDD, not VCC supply.  Fix copy-pasta from other
boards which use elan,ekth3000 with valid VCC:

  sc7180-trogdor-pazquel360-lte.dtb: trackpad@15: 'vcc-supply' does not match any of the regexes: 'pinctrl-[0-9]+'

Fixes: fb69f6adaf88 ("arm64: dts: qcom: sc7180: Add pazquel dts files")
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Reviewed-by: Stephen Boyd <swboyd@chromium.org>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20230312183622.460488-4-krzysztof.kozlowski@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sc7180-trogdor-pazquel.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sc7180-trogdor-pazquel.dtsi b/arch/arm64/boot/dts/qcom/sc7180-trogdor-pazquel.dtsi
index d06cc4ea33756..8823edbb4d6e2 100644
--- a/arch/arm64/boot/dts/qcom/sc7180-trogdor-pazquel.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc7180-trogdor-pazquel.dtsi
@@ -39,7 +39,7 @@
 		interrupt-parent = <&tlmm>;
 		interrupts = <0 IRQ_TYPE_EDGE_FALLING>;
 
-		vcc-supply = <&pp3300_fp_tp>;
+		vdd-supply = <&pp3300_fp_tp>;
 		post-power-on-delay-ms = <100>;
 		hid-descr-addr = <0x0001>;
 
-- 
2.39.2



