Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED86352F8E;
	Mon, 11 Dec 2023 18:35:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xs4Clf1n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70180C433CA;
	Mon, 11 Dec 2023 18:35:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702319714;
	bh=auAvBpS2tTNEueOpySwOx8SR5n3luSX35AF8Oy4w2oI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xs4Clf1neEV2n3kWnPXCuah5U6ynUqHxIFK6yulxL2aDj4xHk8EZS0XknwLlQ7Rb3
	 g2gKq95mhVd07IV3qQ43/IymBZwmMPSxw7o6wr95Qx5PrKN7uZgOKIqwOIHLTysPjg
	 /GGWNm6KGUdJ/8aCmpNY+ibGyNA4+41xuMpA+UDY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Wunderlich <frank-w@public-files.de>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Subject: [PATCH 6.6 177/244] arm64: dts: mt7986: define 3W max power to both SFP on BPI-R3
Date: Mon, 11 Dec 2023 19:21:10 +0100
Message-ID: <20231211182053.873792534@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231211182045.784881756@linuxfoundation.org>
References: <20231211182045.784881756@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Frank Wunderlich <frank-w@public-files.de>

commit 6413cbc17f89b3a160f3a6f3fad1232b1678fe40 upstream.

All SFP power supplies are connected to the system VDD33 which is 3v3/8A.
Set 3A per SFP slot to allow SFPs work which need more power than the
default 1W.

Cc: stable@vger.kernel.org
Fixes: 8e01fb15b815 ("arm64: dts: mt7986: add Bananapi R3")
Signed-off-by: Frank Wunderlich <frank-w@public-files.de>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://lore.kernel.org/r/20231025170832.78727-3-linux@fw-web.de
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/mediatek/mt7986a-bananapi-bpi-r3.dts | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/boot/dts/mediatek/mt7986a-bananapi-bpi-r3.dts b/arch/arm64/boot/dts/mediatek/mt7986a-bananapi-bpi-r3.dts
index af4a4309bda4..f9702284607a 100644
--- a/arch/arm64/boot/dts/mediatek/mt7986a-bananapi-bpi-r3.dts
+++ b/arch/arm64/boot/dts/mediatek/mt7986a-bananapi-bpi-r3.dts
@@ -126,6 +126,7 @@ sfp1: sfp-1 {
 		compatible = "sff,sfp";
 		i2c-bus = <&i2c_sfp1>;
 		los-gpios = <&pio 46 GPIO_ACTIVE_HIGH>;
+		maximum-power-milliwatt = <3000>;
 		mod-def0-gpios = <&pio 49 GPIO_ACTIVE_LOW>;
 		tx-disable-gpios = <&pio 20 GPIO_ACTIVE_HIGH>;
 		tx-fault-gpios = <&pio 7 GPIO_ACTIVE_HIGH>;
@@ -137,6 +138,7 @@ sfp2: sfp-2 {
 		i2c-bus = <&i2c_sfp2>;
 		los-gpios = <&pio 31 GPIO_ACTIVE_HIGH>;
 		mod-def0-gpios = <&pio 47 GPIO_ACTIVE_LOW>;
+		maximum-power-milliwatt = <3000>;
 		tx-disable-gpios = <&pio 15 GPIO_ACTIVE_HIGH>;
 		tx-fault-gpios = <&pio 48 GPIO_ACTIVE_HIGH>;
 	};
-- 
2.43.0



