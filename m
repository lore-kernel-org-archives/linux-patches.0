Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D1BF347FFB
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:18:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302688; cv=none; b=HoFxDNOXoesN4C7R7DFyWn9x05GZv2GF1w4Y9czf1oXB169vlp9BECHZH9Yd6fyw9q299+v3XSpIUK3Ghm54wTclT0edQ9E7eXdxW0LlLAYLcq6aPI+iRXLwA3pb6gxhd0v59rQrvyySEI+TFS8Vq8BQ5P7uVt1/8wPF8F4f5/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302688; c=relaxed/simple;
	bh=G0+3GSFMNoQniZFzP2sry8RSazQpQ7GapZsABi+YPIQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BNrzTF9XB6kmUpORCaDmSBsKbLeemN5dBBCMOeLao/8U0MVE8aEwYiMdAmTUOWOFzpJ/manCLmbQy+Q5fo1Bxblsl38AhzFVsDJBiaLjcobYZm3ZPf7L77C4TaYqAWz8OCWBs8mFiSF5RPZHC1IlMikWuAMsJnm+PfS7oD7xkjY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Kihzd3MA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Kihzd3MA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D8AEC19423;
	Sat, 28 Feb 2026 18:18:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302688;
	bh=G0+3GSFMNoQniZFzP2sry8RSazQpQ7GapZsABi+YPIQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Kihzd3MASZQddG/yI3xeSt4QTOoYUV3Lznjv4C7US0JngM41/54tg+91HvmscYZPa
	 siZtJjZn5ZNZ4Y/SjeRy0CEbZwVkUybKz3qFdtAgsBfvjUarksbMuhspGegqLps1f9
	 ELTbAaI2HrNgG0a4tiUPoX6u1uo/jNTo7s1atJLI1PKMOPdNVwBdEY6m2Mt389wmPz
	 rSg7ZRbmqpd7ocU0OtJbQu4vLLaKKDLuAbxDcK4/jNsgtkWF+L2kCWiYX2rS+F2VBV
	 rSfDbqeDLAwIKgDVZ1DP9uOCO5jk6DI3/fB8Kx5lV5lkhclU3gupUThYtqd7PCqczd
	 Gjj45ZmEAZ/PA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Vladimir Zapolskiy <vz@mleia.com>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@baylibre.com>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 040/147] ARM: dts: lpc32xx: Set motor PWM #pwm-cells property value to 3 cells
Date: Sat, 28 Feb 2026 13:15:48 -0500
Message-ID: <20260228181736.1605592-40-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181736.1605592-1-sashal@kernel.org>
References: <20260228181736.1605592-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Vladimir Zapolskiy <vz@mleia.com>

[ Upstream commit 65ae9ea77e1f2a20ad2866f99596df7ccdbd3b95 ]

Since commit 4cd2f417a0ac ("dt-bindings: pwm: Convert lpc32xx-pwm.txt
to yaml format") both types of PWM controlles on NXP LPC32xx SoC
fairly gained 3 cells, reflect it in the platform dtsi file.

The change removes a dt binding checker warning:

    mpwm@400e8000: #pwm-cells:0:0: 3 was expected

Cc: Uwe Kleine-König <u.kleine-koenig@baylibre.com>
Acked-by: Uwe Kleine-König <u.kleine-koenig@baylibre.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Vladimir Zapolskiy <vz@mleia.com>
Stable-dep-of: 71630e581a0e ("arm: dts: lpc32xx: add clocks property to Motor Control PWM device tree node")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/lpc32xx.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/lpc32xx.dtsi b/arch/arm/boot/dts/lpc32xx.dtsi
index 824393e1bcfb7..da9a891b38c5e 100644
--- a/arch/arm/boot/dts/lpc32xx.dtsi
+++ b/arch/arm/boot/dts/lpc32xx.dtsi
@@ -304,8 +304,8 @@ i2c2: i2c@400a8000 {
 			mpwm: mpwm@400e8000 {
 				compatible = "nxp,lpc3220-motor-pwm";
 				reg = <0x400e8000 0x78>;
+				#pwm-cells = <3>;
 				status = "disabled";
-				#pwm-cells = <2>;
 			};
 		};
 
-- 
2.51.0

