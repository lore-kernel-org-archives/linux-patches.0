Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A198168C9
	for <patches@lists.linux.dev>; Mon,  8 May 2023 11:07:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4279C433D2;
	Mon,  8 May 2023 11:07:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683544034;
	bh=aHRk0qezGA9Wl1a3lQ4lKIOVMda2VzdL4zUAQ7eltqk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=18ccILrzsMIrKNCzipaYqdmD4tbCJKCfOCR0MpXJXwDHhezOBtVDkboFOjYCt+c7P
	 fQCv9vSSFljKmuiPD6Y/dnJl7tDhvogwYiDQDvA5lyKZFS/Y9RqWbbt2qF9x/0zHtq
	 Dg9pEMM5J7SZILyYvMPiVF8iOkTcXyyJbkndfuEk=
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
Subject: [PATCH 6.3 249/694] arm64: dts: qcom: sc7180-trogdor-lazor: correct trackpad supply
Date: Mon,  8 May 2023 11:41:24 +0200
Message-Id: <20230508094440.385913681@linuxfoundation.org>
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

[ Upstream commit 52e2996f253d82520011340d40dbc1c76ea79208 ]

The hid-over-i2c takes VDD, not VCC supply.  Fix copy-pasta from other
boards which use elan,ekth3000 with valid VCC:

  sc7180-trogdor-lazor-limozeen-nots-r4.dtb: trackpad@2c: 'vcc-supply' does not match any of the regexes: 'pinctrl-[0-9]+'

Fixes: 2c26adb8dbab ("arm64: dts: qcom: Add sc7180-lazor-limozeen skus")
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Reviewed-by: Stephen Boyd <swboyd@chromium.org>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20230312183622.460488-3-krzysztof.kozlowski@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../boot/dts/qcom/sc7180-trogdor-lazor-limozeen-nots-r4.dts     | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sc7180-trogdor-lazor-limozeen-nots-r4.dts b/arch/arm64/boot/dts/qcom/sc7180-trogdor-lazor-limozeen-nots-r4.dts
index 850776c5323d1..70d5a7aa88735 100644
--- a/arch/arm64/boot/dts/qcom/sc7180-trogdor-lazor-limozeen-nots-r4.dts
+++ b/arch/arm64/boot/dts/qcom/sc7180-trogdor-lazor-limozeen-nots-r4.dts
@@ -26,7 +26,7 @@
 		interrupt-parent = <&tlmm>;
 		interrupts = <58 IRQ_TYPE_EDGE_FALLING>;
 
-		vcc-supply = <&pp3300_fp_tp>;
+		vdd-supply = <&pp3300_fp_tp>;
 		hid-descr-addr = <0x20>;
 
 		wakeup-source;
-- 
2.39.2



