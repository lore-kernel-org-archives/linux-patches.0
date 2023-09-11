Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B10A511705
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:40:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E70EC433C8;
	Mon, 11 Sep 2023 14:40:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694443251;
	bh=6LjjJ51Ks5ySgcSDPnELUWcsupfOmJ1DddlTrljK6/Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rN9E7nEj7IeN9BwRMJjVLJYCGvFlaamLWXOxkGuy3Qcl4H1TOYuyk7ET1GtfYA0oP
	 uEdhJvzF75myqdoQ424pmiDJgcu8k70EU1aKHqtVnedSB90zx46Z64mtfUUmn4fPBH
	 sl8/ZmC4eGWpS9esWvhv+rtPgALYywQYVBGYC3j4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 312/737] ARM: dts: BCM53573: Use updated "spi-gpio" binding properties
Date: Mon, 11 Sep 2023 15:42:51 +0200
Message-ID: <20230911134659.283321735@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.286315610@linuxfoundation.org>
References: <20230911134650.286315610@linuxfoundation.org>
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

6.4-stable review patch.  If anyone has any objections, please let me know.

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
index 3709baa2376f5..0b8727ae6f16d 100644
--- a/arch/arm/boot/dts/bcm947189acdbmr.dts
+++ b/arch/arm/boot/dts/bcm947189acdbmr.dts
@@ -60,9 +60,9 @@ button-wps {
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



