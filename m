Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81324373BEB;
	Wed, 20 May 2026 16:52:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295974; cv=none; b=k0UJl2+I/iIIPlJHbCkBU/j5aIMPIepZe/YOY/ObIDI4rCBGCrko4E4XnMUZ/fbhr8zUnIlK9HjfU2adQhBCYLm3gQTusi4RkPm+oVgiRpNYREmisU2/SGPNkHw0h6BxgluFlne9+eUfgFI2i6MKE10uhmV6HngLfu/Ka6Ojptg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295974; c=relaxed/simple;
	bh=BUKl2ch9K5jlBOo3RoAH3E/Z1f3+BzlcRBTRb/8OLWs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YrHTqgJyGsO+VycKQT4/ZoBmE/aXZga5pDfNbp3OysfmT0dluZcmXR+7QrwnmaadH2BXH311btDOYW5i2kOBKrfUzK2sI+d1+of/wni7OZTkjBaLte0DIDX3vKG7zr+1PL1kTNbUSDU4Jr4YhGiFIFqLFpE5GVS+ei93PvsaZlg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I2lFJHtb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I2lFJHtb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E60E61F000E9;
	Wed, 20 May 2026 16:52:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295973;
	bh=iYHwDpgoFJnWmLPy2AGmGZ8/hSp+KHG5y3G7KJIqelY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=I2lFJHtb4VYk9hg+8bB0FPgQ9sCFh9ZBEktT0/KSeSVhy16jxqMUgXvwX2z4aUrPN
	 0Zr7jmw8Mjqnk97e50Q5TcQQakCIw7lQ2teR0ZyevBotWNs6M2+Hd7+mITPHCVNuDw
	 ERdV5JZRKZL7g8gDDh7ta01XqE9W/xmO+8eLV+H8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gabor Juhos <j4g8y7@gmail.com>,
	Conor Dooley <conor.dooley@microchip.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0623/1146] dt-bindings: pinctrl: marvell,armada3710-xb-pinctrl: add missing items keyword
Date: Wed, 20 May 2026 18:14:33 +0200
Message-ID: <20260520162202.283501345@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gabor Juhos <j4g8y7@gmail.com>

[ Upstream commit a92b75100826b1ea27e6b8a678e53970ad4736d7 ]

Even though the type of the 'groups' property of a pinmux node is
specified as string-array in pinmux-node.yaml, but trying to use
multiple strings causes dtbs_check warnings.

For example, checking the following dts ...

  $ cat arch/arm64/boot/dts/marvell/armada-3720-test.dts
  /dts-v1/;

  #include "armada-372x.dtsi"

  &pinctrl_nb {
          pwm-gpio-pins {
                  groups = "pwm0", "pwm1", "pwm2", "pwm3";
                  function = "gpio";
          };
  };

... results in this warning:

  arch/arm64/boot/dts/marvell/armada-3720-test.dtb: pinctrl@13800 (marvell,armada3710-nb-pinctrl): pwm-gpio-pins:groups: ['pwm0', 'pwm1', 'pwm2', 'pwm3'] is too long
	  from schema $id: http://devicetree.org/schemas/pinctrl/marvell,armada3710-xb-pinctrl.yaml

Add the missing 'items' keyword to the schema to allow using multiple
strings without such warnings. Also adjust the indentation of the next
statements accordingly.

Signed-off-by: Gabor Juhos <j4g8y7@gmail.com>
Acked-by: Conor Dooley <conor.dooley@microchip.com>
Fixes: c1c9641a04e83 ("dt-bindings: pinctrl: Convert marvell,armada-3710-(sb|nb)-pinctrl to DT schema")
Reviewed-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Linus Walleij <linusw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../pinctrl/marvell,armada3710-xb-pinctrl.yaml        | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/Documentation/devicetree/bindings/pinctrl/marvell,armada3710-xb-pinctrl.yaml b/Documentation/devicetree/bindings/pinctrl/marvell,armada3710-xb-pinctrl.yaml
index 4f9013d368749..727da7fb490ce 100644
--- a/Documentation/devicetree/bindings/pinctrl/marvell,armada3710-xb-pinctrl.yaml
+++ b/Documentation/devicetree/bindings/pinctrl/marvell,armada3710-xb-pinctrl.yaml
@@ -84,11 +84,12 @@ patternProperties:
 
     properties:
       groups:
-        enum: [ emmc_nb, i2c1, i2c2, jtag, mii_col, onewire, pcie1,
-                pcie1_clkreq, pcie1_wakeup, pmic0, pmic1, ptp, ptp_clk,
-                ptp_trig, pwm0, pwm1, pwm2, pwm3, rgmii, sdio0, sdio_sb, smi,
-                spi_cs1, spi_cs2, spi_cs3, spi_quad, uart1, uart2,
-                usb2_drvvbus1, usb32_drvvbus0 ]
+        items:
+          enum: [ emmc_nb, i2c1, i2c2, jtag, mii_col, onewire, pcie1,
+                  pcie1_clkreq, pcie1_wakeup, pmic0, pmic1, ptp, ptp_clk,
+                  ptp_trig, pwm0, pwm1, pwm2, pwm3, rgmii, sdio0, sdio_sb,
+                  smi, spi_cs1, spi_cs2, spi_cs3, spi_quad, uart1, uart2,
+                  usb2_drvvbus1, usb32_drvvbus0 ]
 
       function:
         enum: [ drvbus, emmc, gpio, i2c, jtag, led, mii, mii_err, onewire,
-- 
2.53.0



