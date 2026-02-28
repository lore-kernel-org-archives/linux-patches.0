Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 551DB346772
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:08:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302089; cv=none; b=p2CNr78JIe2Xzh20m0bHwAT0l7WlTvVwHTIZmytToHo5ifrIqBbbHhvEhV9GmVscpTdmnfTvqOQAY5gizQlDJrXlKLXxrw49IKbJ0nyTO3Issgdkb8N5X0ax1FDaYEiwwUrDVjMzw6jBnuVx9osOV0pvhNXSLEKtATAHGYG5Vl0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302089; c=relaxed/simple;
	bh=yptz+dZjhQtL2cr1U5UymTb+DvvTJqMtwTLEiKjX03k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mNxy1rQYX4Yfed3Ydgulra83BbN+XkDriIim70fIh3vX1SJdRuoRjD7Zs1s3Fv6F+/rtO5Rsdwi32BsPNKdt9N9Gks4NRwFKKniW4kUOl2Gg2NGKZp33MrkT+HbiCzkE8yC4Q+/j0MkpzNhImXg2F4gxrRwRzjAyolEXf+WQ2A0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ou5FeREo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ou5FeREo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3F40C116D0;
	Sat, 28 Feb 2026 18:08:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302089;
	bh=yptz+dZjhQtL2cr1U5UymTb+DvvTJqMtwTLEiKjX03k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ou5FeREooy8PAagXUaiOQP3QW9G5aQNnayWYFRsUGYl6Y6CsfSLf3XHx0rykWMifZ
	 4arbzWNDetyUT6B4F/1DwPDUE7VHN48ADlg1tXwTjfV6gz74k4AEwmv+Bb7b29IOk8
	 HowAJ3xaJCCRCpBBL8Wa+p27cS+tNuuVQD4sOQ+tTeoN1eJMaIvWWb4ME6/5SOJmUO
	 fYQSmb99OSoS9P4AW4BjscIVDh0nWKqmjqa0intk7Tdka9hTz98+0olqDIr94y9GaJ
	 xL8wysj538UZa19F73kYQ2Ur/sYyNoFARJA8kElaJns4Ekz4BDorGVyLWTZIlZilGF
	 FURz7TSwwVQSQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Vladimir Zapolskiy <vz@mleia.com>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@baylibre.com>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 072/283] ARM: dts: lpc32xx: Set motor PWM #pwm-cells property value to 3 cells
Date: Sat, 28 Feb 2026 13:03:34 -0500
Message-ID: <20260228180709.1583486-72-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180709.1583486-1-sashal@kernel.org>
References: <20260228180709.1583486-1-sashal@kernel.org>
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
 arch/arm/boot/dts/nxp/lpc/lpc32xx.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/nxp/lpc/lpc32xx.dtsi b/arch/arm/boot/dts/nxp/lpc/lpc32xx.dtsi
index 974410918f35b..770e85b8268f3 100644
--- a/arch/arm/boot/dts/nxp/lpc/lpc32xx.dtsi
+++ b/arch/arm/boot/dts/nxp/lpc/lpc32xx.dtsi
@@ -301,8 +301,8 @@ i2c2: i2c@400a8000 {
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

