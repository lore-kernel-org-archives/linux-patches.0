Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C33A522E
	for <patches@lists.linux.dev>; Sun,  9 Jul 2023 11:28:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9069EC433C8;
	Sun,  9 Jul 2023 11:28:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1688902114;
	bh=sRe831DrJdiIgE09fwtktx67qKztkVDTNsm/VW7LuN0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LkJ9Ekki/ygHGhHV7i5c84D/QsYkNUEoamUzR+Muc0vvFw0e1jaK3ELSbQS9fOP39
	 3NkxP/52e934wCn46UA/w1m6lS6PN0ypfrpCLHrI9POnOWzzCo+Tu2tgwPbotvCE2L
	 RKMts7V6wIK2JK3yM+ZEdwDOCBRk/vDSwloAQ5t8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 261/431] ARM: dts: iwg20d-q7-common: Fix backlight pwm specifier
Date: Sun,  9 Jul 2023 13:13:29 +0200
Message-ID: <20230709111457.269242787@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230709111451.101012554@linuxfoundation.org>
References: <20230709111451.101012554@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit 0501fdec106a291c43b3c1b525cf22ab4c24b2d8 ]

make dtbs_check:

    arch/arm/boot/dts/renesas/r8a7743-iwg20d-q7.dtb: backlight: pwms: [[58, 0, 5000000], [0]] is too long
	    From schema: Documentation/devicetree/bindings/leds/backlight/pwm-backlight.yaml
    arch/arm/boot/dts/renesas/r8a7743-iwg20d-q7-dbcm-ca.dtb: backlight: pwms: [[67, 0, 5000000], [0]] is too long
	    From schema: Documentation/devicetree/bindings/leds/backlight/pwm-backlight.yaml
    arch/arm/boot/dts/renesas/r8a7744-iwg20d-q7-dbcm-ca.dtb: backlight: pwms: [[67, 0, 5000000], [0]] is too long
	    From schema: Documentation/devicetree/bindings/leds/backlight/pwm-backlight.yaml
    arch/arm/boot/dts/renesas/r8a7744-iwg20d-q7.dtb: backlight: pwms: [[58, 0, 5000000], [0]] is too long
	    From schema: Documentation/devicetree/bindings/leds/backlight/pwm-backlight.yaml

PWM specifiers referring to R-Car PWM Timer Controllers should contain
only two cells.

Fix this by dropping the bogus third cell.

Fixes: 6f89dd9e9325d05b ("ARM: dts: iwg20d-q7-common: Add LCD support")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://lore.kernel.org/r/6e5c3167424a43faf8c1fa68d9667b3d87dc86d8.1684855911.git.geert+renesas@glider.be
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/iwg20d-q7-common.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/iwg20d-q7-common.dtsi b/arch/arm/boot/dts/iwg20d-q7-common.dtsi
index 03caea6fc6ffa..4351c5a02fa59 100644
--- a/arch/arm/boot/dts/iwg20d-q7-common.dtsi
+++ b/arch/arm/boot/dts/iwg20d-q7-common.dtsi
@@ -49,7 +49,7 @@ audio_clock: audio_clock {
 	lcd_backlight: backlight {
 		compatible = "pwm-backlight";
 
-		pwms = <&pwm3 0 5000000 0>;
+		pwms = <&pwm3 0 5000000>;
 		brightness-levels = <0 4 8 16 32 64 128 255>;
 		default-brightness-level = <7>;
 		enable-gpios = <&gpio5 14 GPIO_ACTIVE_HIGH>;
-- 
2.39.2



