Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7853DBA49
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 18:46:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2A94C433EF;
	Tue,  7 Mar 2023 18:46:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678214787;
	bh=u5bv5718quh7sauqTA9ZlkhxW/MbwIqa0JxHq8+TATU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XShl8ZFLeEfk4ppkgB/gwQgtFSzftoMQc8iaCdIB6oc6W4Mp1OM5yyJm4+X7NCPo2
	 p+EQUMcTn4qaCcymn1AwaZrbeqAF8QSuiEuxZ82ztMKF89XmWmHGHa6v6cCE9slt0L
	 6T/mQOFtAHnfqrC/fN8lffDuxrZeG1i/ca/dg2qo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adam Ford <aford173@gmail.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 048/567] arm64: dts: renesas: beacon-renesom: Fix gpio expander reference
Date: Tue,  7 Mar 2023 17:56:24 +0100
Message-Id: <20230307165908.011096584@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307165905.838066027@linuxfoundation.org>
References: <20230307165905.838066027@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Adam Ford <aford173@gmail.com>

[ Upstream commit d7f9492dfc03153ac56ab59066a196558748f575 ]

The board used to originally introduce the Beacon Embedded RZ/G2[M/N/H]
boards had a GPIO expander with address 20, but this was changed when
the final board went to production.

The production boards changed both the part itself and the address.
With the incorrect address, the LCD cannot come up.  If the LCD fails,
the rcar-du driver fails to come up, and that also breaks HDMI.

Pre-release board were not shipped to the general public, so it should
be safe to push this as a fix.  Anyone with a production board would
have video fail due to this GPIO expander change.

Fixes: a1d8a344f1ca ("arm64: dts: renesas: Introduce r8a774a1-beacon-rzg2m-kit")
Signed-off-by: Adam Ford <aford173@gmail.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://lore.kernel.org/r/20230114225647.227972-1-aford173@gmail.com
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../dts/renesas/beacon-renesom-baseboard.dtsi | 24 ++++++++-----------
 1 file changed, 10 insertions(+), 14 deletions(-)

diff --git a/arch/arm64/boot/dts/renesas/beacon-renesom-baseboard.dtsi b/arch/arm64/boot/dts/renesas/beacon-renesom-baseboard.dtsi
index 48e0c0494f6a0..f1ab4943c295c 100644
--- a/arch/arm64/boot/dts/renesas/beacon-renesom-baseboard.dtsi
+++ b/arch/arm64/boot/dts/renesas/beacon-renesom-baseboard.dtsi
@@ -432,20 +432,6 @@ wm8962_endpoint: endpoint {
 		};
 	};
 
-	/* 0 - lcd_reset */
-	/* 1 - lcd_pwr */
-	/* 2 - lcd_select */
-	/* 3 - backlight-enable */
-	/* 4 - Touch_shdwn */
-	/* 5 - LCD_H_pol */
-	/* 6 - lcd_V_pol */
-	gpio_exp1: gpio@20 {
-		compatible = "onnn,pca9654";
-		reg = <0x20>;
-		gpio-controller;
-		#gpio-cells = <2>;
-	};
-
 	touchscreen@26 {
 		compatible = "ilitek,ili2117";
 		reg = <0x26>;
@@ -477,6 +463,16 @@ hd3ss3220_out_ep: endpoint {
 			};
 		};
 	};
+
+	gpio_exp1: gpio@70 {
+		compatible = "nxp,pca9538";
+		reg = <0x70>;
+		gpio-controller;
+		#gpio-cells = <2>;
+		gpio-line-names = "lcd_reset", "lcd_pwr", "lcd_select",
+				  "backlight-enable", "Touch_shdwn",
+				  "LCD_H_pol", "lcd_V_pol";
+	};
 };
 
 &lvds0 {
-- 
2.39.2



