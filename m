Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 755772E63B
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 12:12:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBE5DC433C8;
	Wed, 20 Sep 2023 12:12:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695211923;
	bh=tD6QiMIQAKQXsKOkWDVZ2daNg92EO0YblZ68wITi4qk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q/BhuAYLwGn8j78o9+VGVp7f6TM0tFHznR/ASRUU8aWQSOqKkMoXAsE6AkrDivBpI
	 dCi3rfyTJtoXvUtsmIcfnZXdCLAllJLRCcrGg46J2OWXVzdYSRpeR3ERM2sKuz0wH4
	 Zs5l+TvGiiMcf1lxaZmEBq26XcrVkFWh/F8ngank=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 085/273] ARM: dts: BCM53573: Use updated "spi-gpio" binding properties
Date: Wed, 20 Sep 2023 13:28:45 +0200
Message-ID: <20230920112849.073378829@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230920112846.440597133@linuxfoundation.org>
References: <20230920112846.440597133@linuxfoundation.org>
User-Agent: quilt/0.67
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rafał Miłecki <rafal@milecki.pl>

[ Upstream commit 2c0fd6b3d0778ceab40205315ccef74568490f17 ]

Switch away from deprecated properties.

This fixes:
arch/arm/boot/dts/broadcom/bcm947189acdbmr.dtb: spi: gpio-sck: False schema does not allow [[3, 21, 0]]
        From schema: Documentation/devicetree/bindings/spi/spi-gpio.yaml
arch/arm/boot/dts/broadcom/bcm947189acdbmr.dtb: spi: gpio-miso: False schema does not allow [[3, 22, 0]]
        From schema: Documentation/devicetree/bindings/spi/spi-gpio.yaml
arch/arm/boot/dts/broadcom/bcm947189acdbmr.dtb: spi: gpio-mosi: False schema does not allow [[3, 23, 0]]
        From schema: Documentation/devicetree/bindings/spi/spi-gpio.yaml
arch/arm/boot/dts/broadcom/bcm947189acdbmr.dtb: spi: 'sck-gpios' is a required property
        From schema: Documentation/devicetree/bindings/spi/spi-gpio.yaml
arch/arm/boot/dts/broadcom/bcm947189acdbmr.dtb: spi: Unevaluated properties are not allowed ('gpio-miso', 'gpio-mosi', 'gpio-sck' were unexpected)
        From schema: Documentation/devicetree/bindings/spi/spi-gpio.yaml

Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
Link: https://lore.kernel.org/r/20230707114004.2740-4-zajec5@gmail.com
Signed-off-by: Florian Fainelli <florian.fainelli@broadcom.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/bcm947189acdbmr.dts | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm/boot/dts/bcm947189acdbmr.dts b/arch/arm/boot/dts/bcm947189acdbmr.dts
index ef263412fea51..02c916bedd281 100644
--- a/arch/arm/boot/dts/bcm947189acdbmr.dts
+++ b/arch/arm/boot/dts/bcm947189acdbmr.dts
@@ -61,9 +61,9 @@ wps {
 	spi {
 		compatible = "spi-gpio";
 		num-chipselects = <1>;
-		gpio-sck = <&chipcommon 21 0>;
-		gpio-miso = <&chipcommon 22 0>;
-		gpio-mosi = <&chipcommon 23 0>;
+		sck-gpios = <&chipcommon 21 0>;
+		miso-gpios = <&chipcommon 22 0>;
+		mosi-gpios = <&chipcommon 23 0>;
 		cs-gpios = <&chipcommon 24 0>;
 		#address-cells = <1>;
 		#size-cells = <0>;
-- 
2.40.1



