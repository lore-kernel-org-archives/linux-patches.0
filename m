Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62080BA32
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 17:12:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA75BC433EF;
	Tue,  7 Mar 2023 17:12:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678209123;
	bh=D1RXHSyBNugUMbjzFdSlEhgSXSOV44lLHTee+kMtcSo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dZCi2eNdiEKwJy1+u2Dm0g8bzG4A/8wDQwTLd+vKMYQ6FsQQ+By1k/cs/6RoZvPDg
	 PdcQlMwURPgblxXpQ5hI4fmgvaYUBY0gxRai8FiuGqMTEaP4+vPX90MJyDOSpKydH3
	 3kG+MF2UGOS/qmlyiW8zR1wFhcuLu8LDY1OIzMjA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Christian Hewitt <christianshewitt@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0090/1001] arm64: dts: meson: bananapi-m5: switch VDDIO_C pin to OPEN_DRAIN
Date: Tue,  7 Mar 2023 17:47:42 +0100
Message-Id: <20230307170026.064406326@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Christian Hewitt <christianshewitt@gmail.com>

[ Upstream commit 856968e066bd77b113965f1a355ec7401edff65f ]

For proper warm (re)boot from SD card the BPI-M5 board requires TFLASH_VDD_EN
and VDDIO_C pins to be switched to high impedance mode. This can be achieved
using OPEN_DRAIN instead of ACTIVE_HIGH to leave the GPIO pins in input mode
and retain high state (pin has the pull-up).

This change is inspired by meson-sm1-odroid.dtsi where OPEN_DRAIN has been
used to resolve similar problems with the Odroid C4 board (TF_IO in the C4
dts is the equivalent regulator).

Fixes: 976e920183e4 ("arm64: dts: meson-sm1: add Banana PI BPI-M5 board dts")
Suggested-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Christian Hewitt <christianshewitt@gmail.com>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://lore.kernel.org/r/20230127142221.3718184-2-christianshewitt@gmail.com
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/amlogic/meson-sm1-bananapi-m5.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/amlogic/meson-sm1-bananapi-m5.dts b/arch/arm64/boot/dts/amlogic/meson-sm1-bananapi-m5.dts
index 6d0db667581fa..38ebe98ba9c6b 100644
--- a/arch/arm64/boot/dts/amlogic/meson-sm1-bananapi-m5.dts
+++ b/arch/arm64/boot/dts/amlogic/meson-sm1-bananapi-m5.dts
@@ -123,7 +123,7 @@ vddio_c: regulator-vddio_c {
 		regulator-min-microvolt = <1800000>;
 		regulator-max-microvolt = <3300000>;
 
-		enable-gpio = <&gpio_ao GPIOE_2 GPIO_ACTIVE_HIGH>;
+		enable-gpio = <&gpio_ao GPIOE_2 GPIO_OPEN_DRAIN>;
 		enable-active-high;
 		regulator-always-on;
 
-- 
2.39.2



