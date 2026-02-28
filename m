Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0489633A702
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:08:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302090; cv=none; b=WWGIOihmg5+KOS3f0sQVZsJzDj3LfqrVYwqzVEsbPRL0/iik25wjsSUWPpF7/YYjYxD1YjY900YsOR6ctzkDC/cO4UNLqluGXzNa8kMlowC1D8si+zH7/CmZEpMHjiRu09szcJCT88HnA7nBMXw/oCZowDvbxMoz9cvG5WPn6bE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302090; c=relaxed/simple;
	bh=9VEreTt5Aaygh9YK2NbK6mbbaAwpA9M7HdUIldQEY/c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sgAW2S03120jplsSH096QvGQL3xwgVpYx5oosoHl6NFdy+mTu/goOUilZ+zEoDEVyHuscRSaXVm4765Lo/JjTJqthe4O4MS5FZpQAyccorZ/AreupoA3anQ/pGfMKX/FdH7E8nHp7XdrglnMkY840dFUABNnyt2BfHItLRwNoDo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=O5OUaIfE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="O5OUaIfE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78BC5C19423;
	Sat, 28 Feb 2026 18:08:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302089;
	bh=9VEreTt5Aaygh9YK2NbK6mbbaAwpA9M7HdUIldQEY/c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O5OUaIfEY9ye6nBpVhCA7y5GyWzdBxjw182GXBv97nu2qN1DVm3ql4WqhUd4z8ZNj
	 d4n0EsRKzzVRAZ9OcPhJBMmE2N/Fv6kujxrPXFBNz7DAx6UQOPt33DwaW5eixAEjie
	 HOZfFqESkedtjKTgvsrQkr1wli9VwSBPei+jzSrzkxeIAiaGVswH+Z8Mg3CAydz4np
	 44tyXqJM5RsSxvJHLfEDPdeFvFUQS83BCuYvnn7a2uIbFSi545N1S2VV4Txx5mJrgE
	 UFSj5El0N7/74eVEus11aZWLcc/F3mMNKac6BvZG1/R1nuIYouUacFd4CmpLLscaNU
	 S6oVPM45mWUlw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Vladimir Zapolskiy <vz@mleia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 073/283] arm: dts: lpc32xx: add clocks property to Motor Control PWM device tree node
Date: Sat, 28 Feb 2026 13:03:35 -0500
Message-ID: <20260228180709.1583486-73-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180709.1583486-1-sashal@kernel.org>
References: <20260228180709.1583486-1-sashal@kernel.org>
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
 arch/arm/boot/dts/nxp/lpc/lpc32xx.dtsi | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/boot/dts/nxp/lpc/lpc32xx.dtsi b/arch/arm/boot/dts/nxp/lpc/lpc32xx.dtsi
index 770e85b8268f3..7503074d2877c 100644
--- a/arch/arm/boot/dts/nxp/lpc/lpc32xx.dtsi
+++ b/arch/arm/boot/dts/nxp/lpc/lpc32xx.dtsi
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

