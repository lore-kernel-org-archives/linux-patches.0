Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D82BA344D9A
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:01:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301714; cv=none; b=i7k5nyLmdIarvxzBs4ZVQk2nYJqG7S/fpIL3CezZX2RubtvXw14H7t8akVcMCz9nAuP1BE2ZSpduAMwV/AXaGkyuWisA+HgmdE1eYMI+f+1wQYxmat8o4jXEf2ts3mm9Ns3quxbwVZfI/2mXK8GLtu2BihqCAAWARd1Lkmm/qJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301714; c=relaxed/simple;
	bh=9VEreTt5Aaygh9YK2NbK6mbbaAwpA9M7HdUIldQEY/c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VESZOK4tMNw7T/Fip4Krwhhh1Ig3nfi6niAcyKnH+MC0s/zef7b7KFe7KVxsNGmiJtNAvWbA4J0jQGrdDjLvbouyU7cTWo1ug64faMbuwQax2cPUGPRFY+P3vE/m+vLf844QYy6Z4rmyBe1nCiUL5da9BzZZ+PQbnc/BRqAHNVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FADKPfoJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FADKPfoJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BF3FC19423;
	Sat, 28 Feb 2026 18:01:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301714;
	bh=9VEreTt5Aaygh9YK2NbK6mbbaAwpA9M7HdUIldQEY/c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FADKPfoJgunM+JyK21Yr/uSQmEQehuwIW0wX+x/ee50YDj8OvyMiV4LZ7ZpiFC1iX
	 YMDxlsNZPLJzflhWOj90PHYasul4eFi30mmXIkzLKf4m7VM6o2KfqdFeltxgp6hHs6
	 IcvLGETE/VzDJOiPsd5V3TuQE67sKAEHvJUvEDoX5IlvLCbVoZzAbZxZdVF5JBA6Lz
	 r1PbYMRztZ6mU4ByD60Po7kepDea75UswrEvpbAh1QP7kouFViAIlWH9Fvy0++1TDa
	 yisjrm6/LG97U4H+lvmEy+TfLtI21qTE2UBDjCloBT8I/4O2ALYkbMa5cte0vjE7pc
	 Ci47GYWoIDmUg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Vladimir Zapolskiy <vz@mleia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 110/385] arm: dts: lpc32xx: add clocks property to Motor Control PWM device tree node
Date: Sat, 28 Feb 2026 12:55:32 -0500
Message-ID: <20260228180011.1568201-110-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
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

