Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B80D120EA2D;
	Tue, 12 Nov 2024 10:23:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731407015; cv=none; b=Z5bT1Pr2rCW3cvDt5CIAQ01O58utuOVRxRGaKI1pPO4X2t8nS3pgHaBXRqUn/UWEUAVExpfQVwIm0yOrIUVHRDQbKpsGXr8RBNKWRfFsjpLQGeTExuS2/LOCCJjFkrBzi5VKQwJZImeA1kmtaa4jWt8MTMB4I/PN5cPVgs0DjlY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731407015; c=relaxed/simple;
	bh=PUy/vbsuSIasYfLGLIuazPIVEPsSbWfDPCJxLWYqBRw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c7xXjB7IwoLw09xxlPS8Jf5INoN+di1pqwKKJD92CIGmQU96HakYY/v+uL6o/lJJZEffpZXcomkUjM12usv5LrF5cvYvO/62b6zDXOlFgSDArOmndz+WxkuIEfaM8J1lRejn+ClxOG6FZZYVPtgnNPf9dZlsQDqX3by6Q13WJHs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b7mbU3tz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b7mbU3tz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD837C4CECD;
	Tue, 12 Nov 2024 10:23:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731407015;
	bh=PUy/vbsuSIasYfLGLIuazPIVEPsSbWfDPCJxLWYqBRw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b7mbU3tz8IOEx4SH+edesRNnYbzNX6HhuGQ6qCdd8G2w4TDEW3L3eOIqUdlviRzow
	 BpTRqk/YwbZ7pFxB0FRR+wVrcv15RIlfe8CBuKwZsOHtbFG7PGK2qiRUrD6DyTD0h3
	 HwvyWD3YeuisIBU0d81ryMnR3UpYrBxt4zoqbABU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Dragan Simic <dsimic@manjaro.org>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 03/76] arm64: dts: rockchip: Fix bluetooth properties on Rock960 boards
Date: Tue, 12 Nov 2024 11:20:28 +0100
Message-ID: <20241112101839.913581816@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101839.777512218@linuxfoundation.org>
References: <20241112101839.777512218@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heiko Stuebner <heiko@sntech.de>

[ Upstream commit ea74528aaea5a1dfc8e3de09ef2af37530eca526 ]

The expected clock-name is different, and extclk also is deprecated
in favor of txco for clocks that are not crystals.

So fix it to match the binding.

Fixes: c72235c288c8 ("arm64: dts: rockchip: Add on-board WiFi/BT support for Rock960 boards")
Cc: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Reviewed-by: Dragan Simic <dsimic@manjaro.org>
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Link: https://lore.kernel.org/r/20241008203940.2573684-5-heiko@sntech.de
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3399-rock960.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3399-rock960.dtsi b/arch/arm64/boot/dts/rockchip/rk3399-rock960.dtsi
index 25dc61c26a943..68d59394a9304 100644
--- a/arch/arm64/boot/dts/rockchip/rk3399-rock960.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3399-rock960.dtsi
@@ -574,7 +574,7 @@
 	bluetooth {
 		compatible = "brcm,bcm43438-bt";
 		clocks = <&rk808 1>;
-		clock-names = "ext_clock";
+		clock-names = "txco";
 		device-wakeup-gpios = <&gpio2 RK_PD3 GPIO_ACTIVE_HIGH>;
 		host-wakeup-gpios = <&gpio0 RK_PA4 GPIO_ACTIVE_HIGH>;
 		shutdown-gpios = <&gpio0 RK_PB1 GPIO_ACTIVE_HIGH>;
-- 
2.43.0



