Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4750E46AA82;
	Tue, 21 Jul 2026 15:38:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648316; cv=none; b=ei2L9lKcuFruDWaWs/D9agL68OZhOBMH9yZ7t/7kaeRlw6hy1Wj4LCef4H7MQ+Uo9Un4k7m3A6B1YbCQrrVAN3fychDc60L2ZcGy0LbHnieWyjzMmeEbWkJnplwXWaBH+TdyZ5nO3+SGqQII+HuZGka5nKIzWH/ctWcWYf4vh7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648316; c=relaxed/simple;
	bh=zj8NQ/YNaW31t/PIStHuftOSy8SAHfxGDmHfqKXQQEY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P1kcbSQ665kVrQ9kP6gV3WbAhwCW6s209tDGy0S08A3K/vwec1uJ0KaLNNsDbkNVq+TNfcjOYasqg9hw7wnidk4SS+ZGPK/aPo+0wPSZ4RlLPKhP/RjVUg1ERiXc/cTXAtBDXA/7B1dcuDxcD3YPKv3hG+KLjQ5CVqjp1zuOy7E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NDOjEBOW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NDOjEBOW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE26C1F000E9;
	Tue, 21 Jul 2026 15:38:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648315;
	bh=/UEGyRvIqjasOJ3h4T2cxUlCNZgyWKI1V2M9fasafkA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NDOjEBOWxQJ1lubwVrFLS9fnh/zE+o81uov8m5uy5ZoY7TOWGnzkscPMAVSpkD+bI
	 uXL6u85pdp9dBba793ys9YtQPrr7meLmjM2CnBUSNK0BoRb88QViXowWXKK+pcUbRA
	 FameSBPVtY2puAYLMfomwN+lMdntxQNykDAMGU/A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Marek Vasut <marex@nabladev.com>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0153/2077] arm64: dts: imx8mn-vhip4-evalboard-v2: Correct interrupt flags
Date: Tue, 21 Jul 2026 16:57:06 +0200
Message-ID: <20260721152556.292482777@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>

[ Upstream commit 7263f1acdd33169e1558064ee9a98758921f3bec ]

GPIO_ACTIVE_x flags are not correct in the context of interrupt flags.
These are simple defines so they could be used in DTS but they will not
have the same meaning:
1. GPIO_ACTIVE_HIGH = 0 => IRQ_TYPE_NONE
2. GPIO_ACTIVE_LOW  = 1 => IRQ_TYPE_EDGE_RISING

Correct the interrupt flags, assuming the author of the code wanted the
same logical behavior behind the name "ACTIVE_xxx", this is:
ACTIVE_LOW  => IRQ_TYPE_LEVEL_LOW

Fixes: 5eb7405db99b ("arm64: dts: imx8mn: Add ifm VHIP4 EvalBoard v1 and v2")
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Reviewed-by: Marek Vasut <marex@nabladev.com>
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx8mn-vhip4-evalboard-v2.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/freescale/imx8mn-vhip4-evalboard-v2.dts b/arch/arm64/boot/dts/freescale/imx8mn-vhip4-evalboard-v2.dts
index 4dadfb7f78de27..43fd4d0041ef30 100644
--- a/arch/arm64/boot/dts/freescale/imx8mn-vhip4-evalboard-v2.dts
+++ b/arch/arm64/boot/dts/freescale/imx8mn-vhip4-evalboard-v2.dts
@@ -99,7 +99,7 @@ &i2c3 {
 
 &ifm_pmic {
 	interrupt-parent = <&gpio5>;
-	interrupts = <17 GPIO_ACTIVE_LOW>;
+	interrupts = <17 IRQ_TYPE_LEVEL_LOW>;
 };
 
 &iomuxc {
-- 
2.53.0



