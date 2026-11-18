Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029509;
	b=aEbg0lFwO9AehFimf+TTDs58iZyrV77CC+V2y6USXTrMk6URTR37ImSDURqa6Ed2yJHo
	 oQS/AuQUDnUFncy1uEKISXJbqJsB/ChXFXw5YZt991bTswpXvZSohyONtNMeNQ86gSuXI
	 aFfyhfhnpmUUY1izPHmeXk3sowxmVCDrvVBAAnHIoBBhcVF7MOA6jC4nI8eH2aXhwPPtY
	 NSlkFEHqTrPWAXTG4nZz1wxRqdJhToBhGOzJ3dtaTNa7zGlZR1T3/EYdPSPXtLJ1SCk6c
	 UWFJz3a1r8V3nAucU1b+KSwQxhMbCQFlBoa1ie+QosPQHKaimoEqJ/umrUhtqylZS0Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029509;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8wO7z9qhlEPTr39CNVqi/x81zGBx2lBW81RnRNxZF1Q=;
	b=hBBih8HWg91nVRAk1F/6n/iOlOZSdxXI+MgwmXnASxBL2/FWgvh3IsZDolEw8D6CBqgg
	 pcK0ydjdB70XZGTbXCFJYRXyxEXqPUCfwPd5pUe+ce5YIlc4BRuCA0SlyLRMh6Z7HC7G9
	 Tl2XNkAwDXC4tcOUXJwVawapP6A3sXEQru/t8N+SwKr9h/+9lNVx52S6VoYFKGs3nRdbs
	 PquvBkzOl+krf0jYMGYIpNdaMNpfTaoeSRPmXli7JbxTqcLtfEujBd2KwobRutz6kS4rK
	 2IQvHVD8HGcgHBT9AbyLo+wIMRw28Bt+dstaMZveUZcV1fwI3Z6/KGXIQNgAJRT0hRg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=K2mY24Bc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6EFF606A31C;
	Wed, 18 Nov 2026 19:18:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=K2mY24Bc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4594F1F000C5;
	Wed, 18 Nov 2026 19:18:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029508;
	bh=8wO7z9qhlEPTr39CNVqi/x81zGBx2lBW81RnRNxZF1Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K2mY24BcRdGzBOoduOBr9T7Fn8OGHrBL5MZKDf3nCdqGABmtOvEC57wPlm4sOD7Ao
	 79GWy8Zn9OvIMIuOiRbN7BzhiZIS0QHm8NmegvK6zAK13/4arnLmRwRnv+DLjTg1Hz
	 +logC1rfDDGJksxt7rWjb98hNcMCEeYAvjXDk46E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Vasut <marex@nabladev.com>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0372/1756] ARM: dts: stm32: Drop bias-disable from STM32MP15xx DHCOM SoM sdmmc1_b4_pins_a
Date: Wed, 18 Nov 2026 15:41:39 +0100
Message-ID: <20261118150023.292557921@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marek Vasut <marex@nabladev.com>

[ Upstream commit 3572825773791f4258b553391f4e2187df321731 ]

Drop bias-disable property from STM32MP15xx DHCOM SoM sdmmc1_b4_pins_a
to fix the following DT checker warning. The bias-pull-up property is
the only bias-related property that has to be present in those pinctrl
node subnodes.

"
arch/arm/boot/dts/st/stm32mp153c-dhcom-drc02.dtb: pinctrl@50002000 (st,stm32mp157-pinctrl): sdmmc1-b4-0:pins1: {'pinmux': [10253, 10509, 10765, 11021, 12813], 'slew-rate': 1, 'drive-push-pull': True, 'bias-disable': True, 'bias-pull-up': True} is valid under each of {'required': ['bias-pull-up']}, {'required': ['bias-disable']}
"

Fixes: 7cd8567d988a ("ARM: dts: stm32: Enable internal pull-ups for SDMMC1 on DHCOM SoM")
Signed-off-by: Marek Vasut <marex@nabladev.com>
Link: https://lore.kernel.org/r/20260828150111.173089-1-marex@nabladev.com
Signed-off-by: Alexandre Torgue <alexandre.torgue@foss.st.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/st/stm32mp15xx-dhcom-som.dtsi | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm/boot/dts/st/stm32mp15xx-dhcom-som.dtsi b/arch/arm/boot/dts/st/stm32mp15xx-dhcom-som.dtsi
index 142d4a8731f8d..65f81c0c233d2 100644
--- a/arch/arm/boot/dts/st/stm32mp15xx-dhcom-som.dtsi
+++ b/arch/arm/boot/dts/st/stm32mp15xx-dhcom-som.dtsi
@@ -507,9 +507,11 @@ &sdmmc1_b4_pins_a {
 	 * - mandatory on SoMs without SD voltage translator
 	 */
 	pins1 {
+		/delete-property/ bias-disable;
 		bias-pull-up;
 	};
 	pins2 {
+		/delete-property/ bias-disable;
 		bias-pull-up;
 	};
 };
-- 
2.53.0



