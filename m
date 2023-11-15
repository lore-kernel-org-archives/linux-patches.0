Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF5B93A8E1
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:56:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bo0P+z3R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D094C433C7;
	Wed, 15 Nov 2023 19:56:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700078205;
	bh=hVd7HQs4OYcseiHrCPbRJNVIg2QiqhQLaVQFxiAVwyQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bo0P+z3R9ijcSydLYfBXOVyHyvM2JwRd745tiN5HxZnNd6LuWn6jbIJwpXu8z9Srp
	 zluhL9J3ZIFIufxd9GI9USsRhUvCGzMmOYq+Nm7Qgq7PdUoqlhvs9NYSslQhIxXL2y
	 M1HaccDkK/VPGU32xyXUOKJu1YNKPjbC4Sd49+Jk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adam Ford <aford173@gmail.com>,
	Tony Lindgren <tony@atomide.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 177/379] ARM: dts: am3517-evm: Fix LED3/4 pinmux
Date: Wed, 15 Nov 2023 14:24:12 -0500
Message-ID: <20231115192655.580624099@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115192645.143643130@linuxfoundation.org>
References: <20231115192645.143643130@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Adam Ford <aford173@gmail.com>

[ Upstream commit 2ab6b437c65233f06bdd2988fd5913baeca5f159 ]

The pinmux for LED3 and LED4 are incorrectly attached to the
omap3_pmx_core when they should be connected to the omap3_pmx_wkup
pin mux.  This was likely masked by the fact that the bootloader
used to do all the pinmuxing.

Fixes: 0dbf99542caf ("ARM: dts: am3517-evm: Add User LEDs and Pushbutton")
Signed-off-by: Adam Ford <aford173@gmail.com>
Message-ID: <20231005000402.50879-1-aford173@gmail.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/am3517-evm.dts |   16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

--- a/arch/arm/boot/dts/am3517-evm.dts
+++ b/arch/arm/boot/dts/am3517-evm.dts
@@ -271,13 +271,6 @@
 		>;
 	};
 
-	leds_pins: pinmux_leds_pins {
-		pinctrl-single,pins = <
-			OMAP3_WKUP_IOPAD(0x2a24, PIN_OUTPUT_PULLUP | MUX_MODE4)	/* jtag_emu0.gpio_11 */
-			OMAP3_WKUP_IOPAD(0x2a26, PIN_OUTPUT_PULLUP | MUX_MODE4)	/* jtag_emu1.gpio_31 */
-		>;
-	};
-
 	mmc1_pins: pinmux_mmc1_pins {
 		pinctrl-single,pins = <
 			OMAP3_CORE1_IOPAD(0x2144, PIN_INPUT_PULLUP | MUX_MODE0)	/* sdmmc1_clk.sdmmc1_clk */
@@ -355,3 +348,12 @@
 		>;
 	};
 };
+
+&omap3_pmx_wkup {
+	leds_pins: pinmux_leds_pins {
+		pinctrl-single,pins = <
+			OMAP3_WKUP_IOPAD(0x2a24, PIN_OUTPUT_PULLUP | MUX_MODE4)	/* jtag_emu0.gpio_11 */
+			OMAP3_WKUP_IOPAD(0x2a26, PIN_OUTPUT_PULLUP | MUX_MODE4)	/* jtag_emu1.gpio_31 */
+		>;
+	};
+};


