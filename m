Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E42353612D2;
	Wed,  3 Dec 2025 16:43:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764780193; cv=none; b=mCBa41Ofy5ILTRnzNLWhENx0G7Tmz2sHgjoBJmCLiobNQPPKm5DNvlUIXMrL50c24HS8i1Xf2rKVXN6aOdH8BgVQjdEElftBox6NA0lyoO0Y0b6EYK76raUHgIZ3T2coKq/HOI3def3x9j4fql39bseohpU+/KteOSdHkwziWE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764780193; c=relaxed/simple;
	bh=0xifiuOjRqLzvcBLTK0FNiaqxK/Vl2RGiTY6xz7cCew=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jfrM2YqvBqzHytjufHc1NUygq9q1657FMb6RUk2KyW4zdPdz2Oxg5IdwkwdzjBrieXU12pP9KNSh3T09UIexhCUNENY1r1AtObUbAHbwb5WdUwGRpIY86YpIJKMbUSQQN23AuT3lf5kq01JtHKTCIrn0b6AFeVCc5mWT9zMOI1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F5ufxXbW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F5ufxXbW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27808C4CEF5;
	Wed,  3 Dec 2025 16:43:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764780192;
	bh=0xifiuOjRqLzvcBLTK0FNiaqxK/Vl2RGiTY6xz7cCew=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F5ufxXbWwb202+iFyy3LqW/naVHw+rEtBZtisVgDp00VenDfqxbKNjQFD3YaTdtj9
	 hDFHy6HPm2VzcQhba3GuO8dYSlt7DH4bkKaIby9V536KXDEtLrEF0MeBI2f2YNIWLF
	 G4MfH6/wpfD0YV6CcVxB1kuwPCgfMh9aJaB219eM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Conor Dooley <conor.dooley@microchip.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 483/568] dt-bindings: pinctrl: toshiba,visconti: Fix number of items in groups
Date: Wed,  3 Dec 2025 16:28:05 +0100
Message-ID: <20251203152458.392487727@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

[ Upstream commit 316e361b5d2cdeb8d778983794a1c6eadcb26814 ]

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
[ adjusted $ref context ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
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
-        $ref: "/schemas/types.yaml#/definitions/string"
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


