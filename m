Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3A8E30C366;
	Fri,  4 Sep 2026 05:52:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788501157; cv=none; b=KlsB0Mc0jR96f+C1AMPZUcraAyGv+0nrLcIOFUAMk5WenPlwLOfy0JVYofWV2Z7QV6+R/eOkzVyw8cvkS2jVHhAwKI3HFNoy56czHcN/lxRcyp5iQRginNdVu1z0bOYNzEvMUOscd9YI80407qAytjjXYTi7xQVFu3vTbCidKMo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788501157; c=relaxed/simple;
	bh=Noywglgkc1AfZXgEynoH2X50iaRaLSyjpWE7ysJYsK4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=toWIZz4LkSzOylUaEo2FFoCBBWwEiD69DoHqTwFvZ7g2XnMupmND9rGcNfCzT94xVSMF0QwF+xoOFvgdsIHySk9yukVNczU7ZWBRWgMJ6u4Rch/xaJ+6w1l/J6cPua/Gy1X2xQHW2+CmeDxj91sYoiwfgVfF+2C6yhDpaZKOgP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mWk/liLk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mWk/liLk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A8E71F00A3D;
	Fri,  4 Sep 2026 05:52:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788501155;
	bh=D9LPX/NIW3YQpJO/EK4EFGx+MT698k9hXzNZ40LgQK0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mWk/liLkz9Td/5Vv4catD1hQQLbIqx/RGbPY5OORoIc1Cb3zhrI7b7M2VwnA6bcGk
	 Q3Yr82MDBwSdM+bZJWhIyMjkYr2nLQga5V6iLWXZjuP8GH3fjjBxbaNp4GAoY85Ev2
	 F8uE7vZYJe7gAdZ081SgOVL8N9itKn/LosJ1OyRw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Quentin Schulz <quentin.schulz@cherry.de>,
	Heiko Stuebner <heiko@sntech.de>
Subject: [PATCH 6.18 311/552] arm64: dts: rockchip: fix eMMC reset polarity on PP-1516
Date: Fri,  4 Sep 2026 06:57:48 +0200
Message-ID: <20260904045757.333343413@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Quentin Schulz <quentin.schulz@cherry.de>

commit 2a08921edcab6a462fa6ddb02c91b90b5ac92429 upstream.

According to the Jedec 5.1 specification, the device is held in reset
when RST_n is low, therefore the polarity of the line must be that, as
specified in the Device Tree binding (mmc/mmc-pwrseq-emmc.yaml).

Due to the wrong polarity, eMMC devices with RST_n_FUNCTION[162]
bitfield [1:0] set to 0x1 (the default is 0x0) will be held in reset
forever.

Cc: stable@vger.kernel.org
Fixes: 56198acdbf0d ("arm64: dts: rockchip: add px30-pp1516 base dtsi and board variants")
Signed-off-by: Quentin Schulz <quentin.schulz@cherry.de>
Link: https://patch.msgid.link/20260612-pp1516-emmc-polarity-v1-1-4816c1c909f7@cherry.de
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/rockchip/px30-pp1516.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/rockchip/px30-pp1516.dtsi b/arch/arm64/boot/dts/rockchip/px30-pp1516.dtsi
index 192791993f05..02200de695d3 100644
--- a/arch/arm64/boot/dts/rockchip/px30-pp1516.dtsi
+++ b/arch/arm64/boot/dts/rockchip/px30-pp1516.dtsi
@@ -33,7 +33,7 @@ emmc_pwrseq: emmc-pwrseq {
 		compatible = "mmc-pwrseq-emmc";
 		pinctrl-0 = <&emmc_reset>;
 		pinctrl-names = "default";
-		reset-gpios = <&gpio1 RK_PB3 GPIO_ACTIVE_HIGH>;
+		reset-gpios = <&gpio1 RK_PB3 GPIO_ACTIVE_LOW>;
 	};
 
 	gpio-leds {
-- 
2.55.0



