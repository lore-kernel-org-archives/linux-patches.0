Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E920436C9E0
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:12:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302343; cv=none; b=N632xjWhMbrPrzEvFsPrUczJiKDrUKMthAXrjz6pxFGb7vC7+bN1QLo9y9wucNjxf95DMJOp1isIrhaLSdnJx9fcgxGflLYkmJfcZIwpga/UAepZgcXmZGYLfMRaptN/+3PaxjMw1oDq58qK9HzUhybMAVWaHoBXL2AstLOQSWE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302343; c=relaxed/simple;
	bh=ilqB3x3lZTcyaQqNkmvOWNwYYMUQOrEoy7u7k92dKYk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=u+ynVxx+n3JXmoeoqcr6PfjA2tLqhRpembfeGzHUHsnXs/eyGIw7K/FNpZbAUdZwZFZ3ToQcJtzFBMLUUxK6+47o5yxRlES8nfN38wbRA/2dALkhh+BlbVec3Af6wELA8i8dVrds+AoQiL6jd1QeL1NZEJs7y18kmjRg5RqKO1c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ApzGybCg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ApzGybCg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C5C0C116D0;
	Sat, 28 Feb 2026 18:12:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302342;
	bh=ilqB3x3lZTcyaQqNkmvOWNwYYMUQOrEoy7u7k92dKYk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ApzGybCgeKFDKgSzmhhyxhU4UUZAmsuh53f/dXmuF64eSCVTraLnYIFZKxIpU4Hhw
	 mMvW/PZoE/WOvwbybrndFSJGJ1VlPArji9k/MgrPHiaWLmtH3rICKj6e01cACwiio2
	 7yd2pJbUf+YSQUMtNYPvWdgOZi8fTwZKNlicqABLy+xyP5D/eDleXii07OGoIk9Xab
	 P18aJtKJ5vBFQf0JOjxQEt9CJEIWAtmpETiKrHHwstGcFsCJqGfl6X4+bWnXfRAV1e
	 I/aScLSXVs1krYYBxczb2XT9XU6XmDmL05U6SOxxL0Yeia2NkwXzqzzaXJ0lumTjEB
	 V/Ft1mRgjUoaw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Vladimir Zapolskiy <vz@mleia.com>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@baylibre.com>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 065/232] ARM: dts: lpc32xx: Set motor PWM #pwm-cells property value to 3 cells
Date: Sat, 28 Feb 2026 13:08:38 -0500
Message-ID: <20260228181127.1592657-65-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181127.1592657-1-sashal@kernel.org>
References: <20260228181127.1592657-1-sashal@kernel.org>
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
index c87066d6c9950..4fb5d9dae1850 100644
--- a/arch/arm/boot/dts/lpc32xx.dtsi
+++ b/arch/arm/boot/dts/lpc32xx.dtsi
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

