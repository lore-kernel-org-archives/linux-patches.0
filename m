Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41E2112BF27;
	Tue, 23 Jan 2024 00:57:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705971438; cv=none; b=pp8hCQdqPsbC3z1fLoNvOrEwmaVBbAY/Sk77U1rh+P6Hk/l0Iz33W6sfB6yE1aSk1vCFzToeUIdoUtsKieGSTYikNnZJU369MCvRONzLXelg/zpaimf8F0o2Lsd69rRkrt6APOGwLgURdvqIlHxydtrrjJvze3TcrHLjF1MOJDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705971438; c=relaxed/simple;
	bh=TGQIm0DKWK+7JDmvZnL70SaypLIhU0kuW/SKdQVHdt0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oWDutIpUXoEizHScaG9otqXZVX4Oza45wl0NYl0jPgmzxvGHd41d7IlDopoT9u/RSTBgG5CTtfAZN+LbFsYokJGAG29dJP/rLHEjh3z/C+lmEsOzjjWaCYtkYCbToJxxy4SDj0dkSup5WMT6dIs1KtiFKOsSEGbbwlz8H8Aqh8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zbmbEsJc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zbmbEsJc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 413A2C433F1;
	Tue, 23 Jan 2024 00:57:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705971437;
	bh=TGQIm0DKWK+7JDmvZnL70SaypLIhU0kuW/SKdQVHdt0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zbmbEsJcLyRinSNZjpAIb1aVgW52hSITSG2ugI4LM9InLU4+9uleEEq/ZfOVaYqnR
	 /fwCThG/uOBF2MEZd24tf/UiLuaRXX5rd74rffrrc0bKmZnct+3tnLcDdIaY5ruxg7
	 Mii4KjVNGUWZp3fDswe0m4aCrfzYolCQmJjrIYC0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 122/286] arm64: dts: qcom: qrb5165-rb5: correct LED panic indicator
Date: Mon, 22 Jan 2024 15:57:08 -0800
Message-ID: <20240122235736.838014271@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235732.009174833@linuxfoundation.org>
References: <20240122235732.009174833@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 949fee6949e6..5516d2067c82 100644
--- a/arch/arm64/boot/dts/qcom/qrb5165-rb5.dts
+++ b/arch/arm64/boot/dts/qcom/qrb5165-rb5.dts
@@ -38,8 +38,8 @@ leds {
 		user4 {
 			label = "green:user4";
 			gpios = <&pm8150_gpios 10 GPIO_ACTIVE_HIGH>;
-			linux,default-trigger = "panic-indicator";
 			default-state = "off";
+			panic-indicator;
 		};
 
 		wlan {
-- 
2.43.0



