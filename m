Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35C58379ED5
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:01:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301714; cv=none; b=Fg9KQlpURNFPfNARiGuC80MjgzdlXHYoaqgymXHU5i++mIIDw9b2jD2l7BJ8r4Fk04p+WGzx+QWMyb8NCztBeGguf0B63dMR0avMPph5zQtxLmlwjOhHW7ljsW3Edx3kTDLyRvCR3QxBdw+qdE12jnguEKh/q63jYggLJJ31Gwo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301714; c=relaxed/simple;
	bh=yptz+dZjhQtL2cr1U5UymTb+DvvTJqMtwTLEiKjX03k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YudrAf/Yrmmy3oJt83dtfXKwMGL8SiWsFV06ZNDRLRQzmHXEM76y+FPLyVEBDzZVxOY2g5s2UUibqA5po+8dcJ+fqGmbXphbcAzydp5FVeLhzGHm/92VyecKhNbeuGcetE8501l9yIrzeO0hdqguY4MePBwLkiCBjJF/eGbjgFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XkXGjFl+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XkXGjFl+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8583EC19423;
	Sat, 28 Feb 2026 18:01:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301714;
	bh=yptz+dZjhQtL2cr1U5UymTb+DvvTJqMtwTLEiKjX03k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XkXGjFl+9bO9dgtgqVTU+ZNRcjWIVzFz/NN8jOjYg7QD47Nlfb2URRDEQ4cVaTJ6l
	 EpH4KznD4T46IsxuaH5mi2R3JBX8YcA1GkkvtlF2mTojd7ESYjbWaAfMOMDzjL4KtS
	 gpusBg2GUKD3YIUlAtMzxCCT/v5v9ZGfnvxit0Cexga9O4dra4q8iXajsfbapOYy8n
	 vzR2MFP3mwRCDVX+zBxCpiHUdg/v/3yAyNdtFf1eyQUtwxv1prstJ6NUDQDPL72XYT
	 bO2FKJbA3U3WUa+BQjvXI3FxZNDiNXIyQ/0P6ozPkH0dHoUr2XZku8Ri/wGo2X/bgk
	 LTVYhv05ZRfOA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Vladimir Zapolskiy <vz@mleia.com>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@baylibre.com>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 109/385] ARM: dts: lpc32xx: Set motor PWM #pwm-cells property value to 3 cells
Date: Sat, 28 Feb 2026 12:55:31 -0500
Message-ID: <20260228180011.1568201-109-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
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

