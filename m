Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E437911703
	for <patches@lists.linux.dev>; Mon, 21 Aug 2023 19:57:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68910C433C8;
	Mon, 21 Aug 2023 19:57:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1692647841;
	bh=7+WTvDMP3OayobXOcibiXEZpzllZvhQnqYomzB9IhkU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ULUNTZY+x3sSvPsBqAQ6JBbamQTztgGJa7as0brsRHhjlbjesvoU8UZSGyaIop0AK
	 hkJpFuy+VjTHNiMEm1qsCXairKc5trgiSwJe7RanZHQqRIi5+iaDcCLSkLOm44IKYJ
	 RDgzQ1QLmw88bNHXpY0+Hcff9Z8PiuJZSb2c5EOc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yogesh Hegde <yogi.kernel@gmail.com>,
	Heiko Stuebner <heiko@sntech.de>
Subject: [PATCH 6.1 156/194] arm64: dts: rockchip: Fix Wifi/Bluetooth on ROCK Pi 4 boards
Date: Mon, 21 Aug 2023 21:42:15 +0200
Message-ID: <20230821194129.555507253@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230821194122.695845670@linuxfoundation.org>
References: <20230821194122.695845670@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yogesh Hegde <yogi.kernel@gmail.com>

commit ebceec271e552a2b05e47d8ef0597052b1a39449 upstream.

This patch fixes an issue affecting the Wifi/Bluetooth connectivity on
ROCK Pi 4 boards. Commit f471b1b2db08 ("arm64: dts: rockchip: Fix Bluetooth
on ROCK Pi 4 boards") introduced a problem with the clock configuration.
Specifically, the clock-names property of the sdio-pwrseq node was not
updated to 'lpo', causing the driver to wait indefinitely for the wrong clock
signal 'ext_clock' instead of the expected one 'lpo'. This prevented the proper
initialization of Wifi/Bluetooth chip on ROCK Pi 4 boards.

To address this, this patch updates the clock-names property of the
sdio-pwrseq node to "lpo" to align with the changes made to the bluetooth node.

This patch has been tested on ROCK Pi 4B.

Fixes: f471b1b2db08 ("arm64: dts: rockchip: Fix Bluetooth on ROCK Pi 4 boards")
Cc: stable@vger.kernel.org
Signed-off-by: Yogesh Hegde <yogi.kernel@gmail.com>
Link: https://lore.kernel.org/r/ZLbATQRjOl09aLAp@zephyrusG14
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/rockchip/rk3399-rock-pi-4.dtsi |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm64/boot/dts/rockchip/rk3399-rock-pi-4.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3399-rock-pi-4.dtsi
@@ -45,7 +45,7 @@
 	sdio_pwrseq: sdio-pwrseq {
 		compatible = "mmc-pwrseq-simple";
 		clocks = <&rk808 1>;
-		clock-names = "ext_clock";
+		clock-names = "lpo";
 		pinctrl-names = "default";
 		pinctrl-0 = <&wifi_enable_h>;
 		reset-gpios = <&gpio0 RK_PB2 GPIO_ACTIVE_LOW>;


