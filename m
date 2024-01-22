Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A34513398C;
	Tue, 23 Jan 2024 00:21:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969306; cv=none; b=Cm2DMMu0lDDAB1v5SD8Q5z5hiURkM8IJsoSygj34JApWBAPMhdGMFtfBDJ2oXQ5krMwzHwy3ihi5/BpnBYgzj94P37evFivcDm8/rHQQLuZjoH2qTeI9apw+x9NCbSyXAVW11gZir61nhrhYPK4+oC0mSqGHCXyAS5oURgW3DpU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969306; c=relaxed/simple;
	bh=H7o0X3s3N6aR+dKY7MNWtqivKJHN9RXc2bBqEPX0ugM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ez0/7eRjaOVzBZOtNHNfh3eDykE8mIDFjtEFXL2Tu049VV7FczO2f1vDboxT1rnfbbQ3SW5GOmwLGuCnk6xKT2rL8kCnzBs7tbxwQNFTaAv8TX+86QNqbBpKN0u+0ijuH2CybAI9+GYz7KYYVqDRvBb9xhh4LDA9xviZyzweKnQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d9PwlpQJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d9PwlpQJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC669C43399;
	Tue, 23 Jan 2024 00:21:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969305;
	bh=H7o0X3s3N6aR+dKY7MNWtqivKJHN9RXc2bBqEPX0ugM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d9PwlpQJt97dmCuHKE9ow/yVGcSxb7lRMpNRP4eb2g80meSG/R5zKLpYkM+7PS/K0
	 Ff1juyAsLc7NgT1a9rBfqcRLl0ubNoH5No5LIeRAbvhTIrl7b0DfUOqprC1fg9Mqvl
	 DAjdd1xa1V0mi3sMMbSuNwMPvW19LPQTzW6RNPJ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 138/641] arm64: dts: qcom: sdm845-db845c: correct LED panic indicator
Date: Mon, 22 Jan 2024 15:50:42 -0800
Message-ID: <20240122235822.372354933@linuxfoundation.org>
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

[ Upstream commit 0c90c75e663246203a2b7f6dd9e08a110f4c3c43 ]

There is no "panic-indicator" default trigger but a property with that
name:

  sdm845-db845c.dtb: leds: led-0: Unevaluated properties are not allowed ('linux,default-trigger' was unexpected)

Fixes: 3f72e2d3e682 ("arm64: dts: qcom: Add Dragonboard 845c")
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Link: https://lore.kernel.org/r/20231111095617.16496-1-krzysztof.kozlowski@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sdm845-db845c.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sdm845-db845c.dts b/arch/arm64/boot/dts/qcom/sdm845-db845c.dts
index c7eba6c491be..7e7bf3fb3be6 100644
--- a/arch/arm64/boot/dts/qcom/sdm845-db845c.dts
+++ b/arch/arm64/boot/dts/qcom/sdm845-db845c.dts
@@ -67,8 +67,8 @@ led-0 {
 			function = LED_FUNCTION_INDICATOR;
 			color = <LED_COLOR_ID_GREEN>;
 			gpios = <&pm8998_gpios 13 GPIO_ACTIVE_HIGH>;
-			linux,default-trigger = "panic-indicator";
 			default-state = "off";
+			panic-indicator;
 		};
 
 		led-1 {
-- 
2.43.0



