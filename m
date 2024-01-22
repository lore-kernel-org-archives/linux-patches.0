Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3F7D13398C;
	Tue, 23 Jan 2024 00:21:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969305; cv=none; b=n/yR5AzPNAXkFggqbsM2IVMUGu5vRQULUA7zpsv7Sc+RYiOe2P05Zm+P38ymtWSqGFxUtY6TyYEyesHi+vs0RGrwLfDgL1wkdG5cWddWdDHM8nr+LazlwpJXPp7Iiu/EOTzhoiGgLTDY9xdth+pY2/KaWNu34iB+hZcR/oOUxt4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969305; c=relaxed/simple;
	bh=YVRBKVzVpTmDUUIsr3tkic4U0u//Gua6+VBFitjggx8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mYw4HljlZ4iNKcnYVbjBba+71AdtWHuYUVyWYSxXQmTys12QZycAlVp+shzzI4C/0PnTQyRDnBCfcQblm1ZGFOUPO2v5Lrn9MX3peuiwlxtJY0QHPfvZe6NE1Ms3PYlzPxuqzBFBBnWI5K4wptWd6/SVol+tz8/u718WfCAvh6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rDtbwSzK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rDtbwSzK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0527C43394;
	Tue, 23 Jan 2024 00:21:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969304;
	bh=YVRBKVzVpTmDUUIsr3tkic4U0u//Gua6+VBFitjggx8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rDtbwSzK/TIdtJPzoD+SaDpvFO0UnbnQmO8DYMns05kNpjWCkmXYJ56cwCA7AoA08
	 5fAWxByvHk/Bk0D7YcokIZkiRFSXRXV7ZZgUwaCwx2JTusFyWzUreKR6kKzrGlQRIV
	 g+1ILaBIbA/hp39aI6jQ65TyRv3uezKfrzzYXk8s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 137/641] arm64: dts: qcom: qrb5165-rb5: correct LED panic indicator
Date: Mon, 22 Jan 2024 15:50:41 -0800
Message-ID: <20240122235822.341555468@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

[ Upstream commit dc6b5562acbac0285ab3b2dad23930b6434bdfc6 ]

There is no "panic-indicator" default trigger but a property with that
name:

  qrb5165-rb5.dtb: leds: led-user4: Unevaluated properties are not allowed ('linux,default-trigger' was unexpected)

Fixes: b5cbd84e499a ("arm64: dts: qcom: qrb5165-rb5: Add onboard LED support")
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Link: https://lore.kernel.org/r/20231111094623.12476-1-krzysztof.kozlowski@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/qrb5165-rb5.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/qrb5165-rb5.dts b/arch/arm64/boot/dts/qcom/qrb5165-rb5.dts
index c8cd40a462a3..f9464caddacc 100644
--- a/arch/arm64/boot/dts/qcom/qrb5165-rb5.dts
+++ b/arch/arm64/boot/dts/qcom/qrb5165-rb5.dts
@@ -64,8 +64,8 @@ led-user4 {
 			function = LED_FUNCTION_INDICATOR;
 			color = <LED_COLOR_ID_GREEN>;
 			gpios = <&pm8150_gpios 10 GPIO_ACTIVE_HIGH>;
-			linux,default-trigger = "panic-indicator";
 			default-state = "off";
+			panic-indicator;
 		};
 
 		led-wlan {
-- 
2.43.0



