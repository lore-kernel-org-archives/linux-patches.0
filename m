Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35BCC4219E9;
	Fri,  4 Sep 2026 06:16:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788502603; cv=none; b=tBuqOus+xutGlHQRoWnGh/e3670ED9phwim2yiYu1pfvmH1+e5e3yf7tMaNd9COJnvOnPEZhYtHvQPTezOsAbcRzI8485EqPN7lGOr58OJ/IcUIIbWEXgrtxrZj5XiNWx+/os3qbwZ4MaUJ5DY8uIEODFKsGNg8MD6SH9JB8qq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788502603; c=relaxed/simple;
	bh=LlDEFSwt/BL5zrzC5KPDBEnF0kFqVE7kFb8ii1qea1U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VSobgnumL0li1Wodq1rWNuZUUN1RXUu2w9sBcnuQHZszMT6+yNLSX4QUevHowENU+nzmLScx7819E1KWHYdywwBEpNv/Ya67UOTHPxPzS0fIwEuVcZp+rpJa0XadqYcfpAJMNDJK2ywviMgTro97sVbn4qLqrYF9n2uBQx94bgQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SonydE+B; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SonydE+B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 858D11F00A3D;
	Fri,  4 Sep 2026 06:16:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788502602;
	bh=RoiwOacmaU5tIIfVSh/adEa+JqvyD7WdhPzuDMxRXfo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SonydE+BokZ5+9b8thR6ReyJo01riC8MFikbk6tZV7hdolQFXWuib9BggXEL2bAlg
	 hD2hDjO1m2amDFbfpSA8QUfkzFjOp4dIGAKf3sYkcfLG/vppFSNrO772zMTSsOdWEk
	 ZmoI1EgcGNh3tH9H16srLDuzPqaq4jzFaXP7Z4vs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Quentin Schulz <quentin.schulz@cherry.de>,
	Heiko Stuebner <heiko@sntech.de>
Subject: [PATCH 6.12 228/403] arm64: dts: rockchip: fix eMMC reset polarity on PX30 Ringneck
Date: Fri,  4 Sep 2026 07:00:31 +0200
Message-ID: <20260904045740.049415062@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045734.806166532@linuxfoundation.org>
References: <20260904045734.806166532@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Quentin Schulz <quentin.schulz@cherry.de>

commit dfe078755706ed50651ebbe0442843ecd4ae8389 upstream.

According to the Jedec 5.1 specification, the device is held in reset
when RST_n is low, therefore the polarity of the line must be that, as
specified in the Device Tree binding (mmc/mmc-pwrseq-emmc.yaml).

Due to the wrong polarity, eMMC devices with RST_n_FUNCTION[162]
bitfield [1:0] set to 0x1 (the default is 0x0) will be held in reset
forever.

Cc: stable@vger.kernel.org
Fixes: c484cf93f61b ("arm64: dts: rockchip: add PX30-µQ7 (Ringneck) SoM with Haikou baseboard")
Signed-off-by: Quentin Schulz <quentin.schulz@cherry.de>
Link: https://patch.msgid.link/20260626-ringneck-emmc-polarity-v1-1-90cefe57b316@cherry.de
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/rockchip/px30-ringneck.dtsi |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm64/boot/dts/rockchip/px30-ringneck.dtsi
+++ b/arch/arm64/boot/dts/rockchip/px30-ringneck.dtsi
@@ -19,7 +19,7 @@
 		compatible = "mmc-pwrseq-emmc";
 		pinctrl-0 = <&emmc_reset>;
 		pinctrl-names = "default";
-		reset-gpios = <&gpio1 RK_PB3 GPIO_ACTIVE_HIGH>;
+		reset-gpios = <&gpio1 RK_PB3 GPIO_ACTIVE_LOW>;
 	};
 
 	leds {


