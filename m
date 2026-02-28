Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1614A39B94A
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:15:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302543; cv=none; b=Mhv3lsSnWWHEAi9gSgiqvK2BrmgvuEXeotoehdwB9Apav3VnWs9c+GxfWvfXitFgytdi4UDZ0zfTh8ItZLUqwbB7bOiIlwLMSwjSJ/EPzZyOwUQ4TXCFMueM5a5u8AGykQrsOs/+/cQJElP0Cy8YmSGNJaIi4+hycmXkHRQulis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302543; c=relaxed/simple;
	bh=HTs2UKhtJtm1q9IcGPf+4Mn+FgE04Gvfk+9g9eCCq00=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aXmQwoSZUBDUOf/6DUvkcv+2YXDZhD4JJh2DsZKwaBZoMNiJyNbinKzOrsdCtF9Ma8J5+bBrew0+Py+jR1FUSM/Owjzvg0C6z9l6ZjBT1QI9EpaQi/Iint9gURooMC5IBxbNpHKGJZmFSPYDvuCctMtZDULG2rOCC0evnrJ+c7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PzkXOEU6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PzkXOEU6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81B3FC116D0;
	Sat, 28 Feb 2026 18:15:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302542;
	bh=HTs2UKhtJtm1q9IcGPf+4Mn+FgE04Gvfk+9g9eCCq00=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PzkXOEU6H2C2g9i+qgZY+mhw29yBhpQUN1btEw/FwjmZM+fmwrG/Y76p9lK9HmoY7
	 6vaBJbUFQXouz3VHiDeDnZsPlaUvH8r/Ss4Q6mt2NZi9jkB+nQH3AQcbin0mQczGdL
	 R7arXNukJysDuIfOFxGasSET/ts1I1BFhR7OiLuvVecnoaCaT17fRXLHBn/TR4pO6X
	 XO+ypg37abympJGFP9gFgKSsW28jaFn2UMq16vEybL/lrRjbGZ23G4XGWn1liRl65P
	 p4uOC0gPbL5BUVJbijPawDC+FjFNYjmxkezsnnWT+qjADlzP9CE1o+c31OxPjMPq4k
	 QiLNML+RBYAsQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Vladimir Zapolskiy <vz@mleia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 044/164] arm: dts: lpc32xx: add clocks property to Motor Control PWM device tree node
Date: Sat, 28 Feb 2026 13:13:03 -0500
Message-ID: <20260228181505.1600663-44-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181505.1600663-1-sashal@kernel.org>
References: <20260228181505.1600663-1-sashal@kernel.org>
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
index 4fb5d9dae1850..0e856de14e49a 100644
--- a/arch/arm/boot/dts/lpc32xx.dtsi
+++ b/arch/arm/boot/dts/lpc32xx.dtsi
@@ -301,6 +301,7 @@ i2c2: i2c@400a8000 {
 			mpwm: mpwm@400e8000 {
 				compatible = "nxp,lpc3220-motor-pwm";
 				reg = <0x400e8000 0x78>;
+				clocks = <&clk LPC32XX_CLK_MCPWM>;
 				#pwm-cells = <3>;
 				status = "disabled";
 			};
-- 
2.51.0

