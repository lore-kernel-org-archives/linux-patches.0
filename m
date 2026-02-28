Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA721347FFB
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:18:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302688; cv=none; b=eOZI2WxNwXPdEt+viT6/jV2mthm/LEwrLaKA9VVhEWi+LsIRzS6clqIGwHP0rQ+RW2YVvSu4QlJjr1r7UnddFPoN2ViTDVbnfqtepSyVd0SFLy9qrL38o3zSTk0Z1CVcUswt4C4puiuLcH9365AHv/UZKA0WJ1VJN+8Hj4dh+zQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302688; c=relaxed/simple;
	bh=fD9wV7ECDMZI5rO+l0FP4ttZX3TXLitrTs2tKbDRBJA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rV2KWFJni1sU/smwW+Nie8Zs8ERftU2TGFZw/BHR3Pw5LXeMeE4Pzct1bxOTzS4Ir5I/Z2hUvHW2fv8+6lf43y2hf/TNUYItNtfT32jhOQH0yf5NXJw3ZiFe/oS84+Y3PHgrxMgE0cCE05w9hC9OFF+XPn8p03G9S2NuF+4MS8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=T9ePgShJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="T9ePgShJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43038C19423;
	Sat, 28 Feb 2026 18:18:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302688;
	bh=fD9wV7ECDMZI5rO+l0FP4ttZX3TXLitrTs2tKbDRBJA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T9ePgShJ7MtVwGT7rRH/Uz/tnKZWrfCs3KUVcZ2twmoC5uSf5f0IyhX41cYPnsFn7
	 jE/inN1+zDduJmZCpbhLG+Hv/vrv3gjp8YAtLkTTEnxu2h5LVIk4Xd1X/8J3zVS/rD
	 A7isIBlU8ESD98VYSfTq2+jLCftiXKHIjLTs3xFzHT54bRK2Ji8UQxrksMg2YorqWR
	 gTcAQPpEEeImj0trvWJNbKQAIcHmHrzZF0YFPwPa2rktCuxvKrQ2CSL2r8PVSqERuy
	 0hOk4nNU1Aj7eo24fiAGh2jOW+OqdRkzDVOGdvsKEE0fAgnXx24jNxkk1FYzNYGKVh
	 Y1seIN+6EJ+ig==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Vladimir Zapolskiy <vz@mleia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 041/147] arm: dts: lpc32xx: add clocks property to Motor Control PWM device tree node
Date: Sat, 28 Feb 2026 13:15:49 -0500
Message-ID: <20260228181736.1605592-41-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181736.1605592-1-sashal@kernel.org>
References: <20260228181736.1605592-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Vladimir Zapolskiy <vz@mleia.com>

[ Upstream commit 71630e581a0e34c03757f5c1706f57c853b92555 ]

Motor Control PWM depends on its own supply clock, the clock gate control
is present in TIMCLK_CTRL1 register.

Fixes: b7d41c937ed7 ("ARM: LPC32xx: Add the motor PWM to base dts file")
Signed-off-by: Vladimir Zapolskiy <vz@mleia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/lpc32xx.dtsi | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/boot/dts/lpc32xx.dtsi b/arch/arm/boot/dts/lpc32xx.dtsi
index da9a891b38c5e..bb99c09fca96a 100644
--- a/arch/arm/boot/dts/lpc32xx.dtsi
+++ b/arch/arm/boot/dts/lpc32xx.dtsi
@@ -304,6 +304,7 @@ i2c2: i2c@400a8000 {
 			mpwm: mpwm@400e8000 {
 				compatible = "nxp,lpc3220-motor-pwm";
 				reg = <0x400e8000 0x78>;
+				clocks = <&clk LPC32XX_CLK_MCPWM>;
 				#pwm-cells = <3>;
 				status = "disabled";
 			};
-- 
2.51.0

