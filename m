Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9723336C9E0
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:12:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302343; cv=none; b=V6cwVolJLDIfKv96O12fcSpAdfp6yIfWqObzl/PAoUtTka8TL7gI2nNBgutXVD2YZtKUacXZ3HgYdxwAcdXqNs6Hsb2lKO38OMQlp196PPF2LlLfdvsWo3q1zSP3MYGE5tyaxBA2aaXh4CTtGTeN8w3m0/dyPs4bM11izMHszXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302343; c=relaxed/simple;
	bh=HTs2UKhtJtm1q9IcGPf+4Mn+FgE04Gvfk+9g9eCCq00=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=At0+OXhlgqcJPpxHHiUZbdLUq5RXKuA4npx/L0CQGcygUoU5+bZByv1LFxWyEp17jVgZa2qu+knxOuvZKD3Xp0kuEuTse7lhLezUsqylVU66wnhvNoi5vUpwL0KotCd8MUm2uzU8hbrNZ7qE6zXwE3gpnu6Rn3Tl9AGU7L9Mia0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=luqMNdGz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="luqMNdGz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19249C19424;
	Sat, 28 Feb 2026 18:12:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302343;
	bh=HTs2UKhtJtm1q9IcGPf+4Mn+FgE04Gvfk+9g9eCCq00=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=luqMNdGzWIzUpekTuOWSeIbbSaNgI+dDOA8+xU4esRgc5zhVsCKruhUNl34IH6akR
	 yCG0j4eBTfdeMZdGv+2FQZ8YsUK06/6UIkhinKFw/auYpubgSNZ9VJqlWBO7+EfxYm
	 raGTY7oQphC0UxgTsj+oxQV20yJspk4LUnhZ8PE01F0hSEdy7cCEH11tdu1XsoGNH2
	 y9pZ0jChhUOfzWKFqkAVQnn21tVzeSmY1BU6xBGx06LFw76utQulCy315oA0PGoLTF
	 vMdWUKdcBBB0TTVFusdm7ISqfed/N6F1owjQoSDrJ79pnunpgqrXq6E3JbQ+X4aCdv
	 PstijhwEXfwcg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Vladimir Zapolskiy <vz@mleia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 066/232] arm: dts: lpc32xx: add clocks property to Motor Control PWM device tree node
Date: Sat, 28 Feb 2026 13:08:39 -0500
Message-ID: <20260228181127.1592657-66-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181127.1592657-1-sashal@kernel.org>
References: <20260228181127.1592657-1-sashal@kernel.org>
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

