Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9904F28D8E8;
	Thu, 27 Nov 2025 15:00:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764255601; cv=none; b=Pzkz3YaoZjVX5QVZQV8Nhxb5jIPfFkJFTlRCjU3b9REhzqD/xpMHs00G1YLD4cGQkj1v+kHL/bQjDE7DyBKmEqz3EAxL9vzYMuuaGz3c3P2s9DYm/vJZfA6R6yy0VmfuQIkNDc/gc/LX+TU25INBKpwLw34T+nNPMDPQEU7yYyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764255601; c=relaxed/simple;
	bh=nhNtqsMPwwJt1J1PvAzhjtc0dLfS/SyDvQYDXrECWMY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZB3m0/sZAEutlgfbEzwHlJFghv77FYhC+0LZjjzYEApfEltgAD5whBSMdomZI/ZN9m/ud+b2WRgZwOrHimzDrgSXORNjxlLx0eGs4jeT3sgTMnt6R8qsxv7/QXZ2ugGB8TsfMv8Dr1fikb+b+4SlqiH4S5OU68nskCd9u3gVzj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DrmJhCw2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DrmJhCw2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25762C4CEF8;
	Thu, 27 Nov 2025 15:00:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764255601;
	bh=nhNtqsMPwwJt1J1PvAzhjtc0dLfS/SyDvQYDXrECWMY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DrmJhCw2710uOZbBfitLOe+e+HjI4XLJaiuejj68MNtjf8G4JRfWPoAtKpkKURNse
	 iOlNlIpdggbLg0gBA5kQVymKE5ttTWkkeFAvMcDbsnhqBmgeZ5tH1V2fw4Djk09Pcq
	 sFNmL41sZhZMh+5xzb7iWeD9iNAFN0XTRrhKNyKg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Conor Dooley <conor.dooley@microchip.com>,
	Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 6.17 049/175] dt-bindings: pinctrl: toshiba,visconti: Fix number of items in groups
Date: Thu, 27 Nov 2025 15:45:02 +0100
Message-ID: <20251127144044.758230653@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251127144042.945669935@linuxfoundation.org>
References: <20251127144042.945669935@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

commit 316e361b5d2cdeb8d778983794a1c6eadcb26814 upstream.

The "groups" property can hold multiple entries (e.g.
toshiba/tmpv7708-rm-mbrc.dts file), so allow that by dropping incorrect
type (pinmux-node.yaml schema already defines that as string-array) and
adding constraints for items.  This fixes dtbs_check warnings like:

  toshiba/tmpv7708-rm-mbrc.dtb: pinctrl@24190000 (toshiba,tmpv7708-pinctrl):
    pwm-pins:groups: ['pwm0_gpio16_grp', 'pwm1_gpio17_grp', 'pwm2_gpio18_grp', 'pwm3_gpio19_grp'] is too long

Fixes: 1825c1fe0057 ("pinctrl: Add DT bindings for Toshiba Visconti TMPV7700 SoC")
Cc: stable@vger.kernel.org
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Acked-by: Conor Dooley <conor.dooley@microchip.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/devicetree/bindings/pinctrl/toshiba,visconti-pinctrl.yaml |   26 +++++-----
 1 file changed, 14 insertions(+), 12 deletions(-)

--- a/Documentation/devicetree/bindings/pinctrl/toshiba,visconti-pinctrl.yaml
+++ b/Documentation/devicetree/bindings/pinctrl/toshiba,visconti-pinctrl.yaml
@@ -50,18 +50,20 @@ patternProperties:
       groups:
         description:
           Name of the pin group to use for the functions.
-        $ref: /schemas/types.yaml#/definitions/string
-        enum: [i2c0_grp, i2c1_grp, i2c2_grp, i2c3_grp, i2c4_grp,
-               i2c5_grp, i2c6_grp, i2c7_grp, i2c8_grp,
-               spi0_grp, spi0_cs0_grp, spi0_cs1_grp, spi0_cs2_grp,
-               spi1_grp, spi2_grp, spi3_grp, spi4_grp, spi5_grp, spi6_grp,
-               uart0_grp, uart1_grp, uart2_grp, uart3_grp,
-               pwm0_gpio4_grp, pwm0_gpio8_grp, pwm0_gpio12_grp,
-               pwm0_gpio16_grp, pwm1_gpio5_grp, pwm1_gpio9_grp,
-               pwm1_gpio13_grp, pwm1_gpio17_grp, pwm2_gpio6_grp,
-               pwm2_gpio10_grp, pwm2_gpio14_grp, pwm2_gpio18_grp,
-               pwm3_gpio7_grp, pwm3_gpio11_grp, pwm3_gpio15_grp,
-               pwm3_gpio19_grp, pcmif_out_grp, pcmif_in_grp]
+        items:
+          enum: [i2c0_grp, i2c1_grp, i2c2_grp, i2c3_grp, i2c4_grp,
+                 i2c5_grp, i2c6_grp, i2c7_grp, i2c8_grp,
+                 spi0_grp, spi0_cs0_grp, spi0_cs1_grp, spi0_cs2_grp,
+                 spi1_grp, spi2_grp, spi3_grp, spi4_grp, spi5_grp, spi6_grp,
+                 uart0_grp, uart1_grp, uart2_grp, uart3_grp,
+                 pwm0_gpio4_grp, pwm0_gpio8_grp, pwm0_gpio12_grp,
+                 pwm0_gpio16_grp, pwm1_gpio5_grp, pwm1_gpio9_grp,
+                 pwm1_gpio13_grp, pwm1_gpio17_grp, pwm2_gpio6_grp,
+                 pwm2_gpio10_grp, pwm2_gpio14_grp, pwm2_gpio18_grp,
+                 pwm3_gpio7_grp, pwm3_gpio11_grp, pwm3_gpio15_grp,
+                 pwm3_gpio19_grp, pcmif_out_grp, pcmif_in_grp]
+        minItems: 1
+        maxItems: 8
 
       drive-strength:
         enum: [2, 4, 6, 8, 16, 24, 32]


