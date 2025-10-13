Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B626C3081AE;
	Mon, 13 Oct 2025 15:26:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369167; cv=none; b=n8YfodT+eeQLhlWD02uf69pcBnCCyemaXqhtx4gFoj72jAiydfcqwxan2ljHcdWIKTnV644eqgelMnnf8n93RsKyWaFP/qzu5pLh2vht+f8ItCpb+OCd5W//IAWwM2Ul5hxi/6CfbjkubeO0uLKlrgxoUDfLvrINPa+Hs1X9Zhc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369167; c=relaxed/simple;
	bh=XXbz+16kMYivWr9Co4C0RWGGS0dJwfHtCVurSqPOo+I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fnApJcvmnNhtg0zS2eJMVLJK5m9CmqYh9X8IVGfc73xsCEJiYpNtj8EmaTKO32lzNRqSB7jnzoPxGTAnA6cfk0h/YzPT85N5RFTmZYiDgrwYbTr5Y/g4aTEPEZ8KtpfmaMnGHiH+bJsj/wVvj6+QyaTsjN8zhltylYkunVY7ObU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OtH1PptN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OtH1PptN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F891C4CEE7;
	Mon, 13 Oct 2025 15:26:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369167;
	bh=XXbz+16kMYivWr9Co4C0RWGGS0dJwfHtCVurSqPOo+I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OtH1PptNT187wrYwfwqJUxaQhcZLoFEl5k44zdfn9Y6aINJpVmuqSksm+9jfnd2fe
	 Lj5speTAxGiWGB1WThBsWbQi1n1zYhSB1fz/la1+jr+ylBBAcd4w9E03sfbJG7ed4r
	 kOvkHTqHAyP2C/nUFf2V3SRJyl9wqRvNESasE9xQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jernej Skrabec <jernej.skrabec@gmail.com>,
	Chen-Yu Tsai <wens@csie.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 151/563] arm64: dts: allwinner: a527: cubie-a5e: Add LEDs
Date: Mon, 13 Oct 2025 16:40:12 +0200
Message-ID: <20251013144416.760817984@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

From: Chen-Yu Tsai <wens@csie.org>

[ Upstream commit 4184f0190792aea06553af963741a24cc9b47689 ]

The Radxa Cubie A5E has a 3-color LED. The green and blue LEDs are wired
to GPIO pins on the SoC, and the green one is lit by default to serve as
a power indicator. The red LED is wired to the M.2 slot.

Add device nodes for the green and blue LEDs.

A default "heartbeat" trigger is set for the green power LED, though in
practice it might be better if it were inverted, i.e. lit most of the
time.

Acked-by: Jernej Skrabec <jernej.skrabec@gmail.com>
Link: https://patch.msgid.link/20250812175927.2199219-1-wens@kernel.org
Signed-off-by: Chen-Yu Tsai <wens@csie.org>
Stable-dep-of: 9f01e1e14e71 ("arm64: dts: allwinner: a527: cubie-a5e: Drop external 32.768 KHz crystal")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../dts/allwinner/sun55i-a527-cubie-a5e.dts   | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/arch/arm64/boot/dts/allwinner/sun55i-a527-cubie-a5e.dts b/arch/arm64/boot/dts/allwinner/sun55i-a527-cubie-a5e.dts
index 43251042d1bd5..d4cee22221045 100644
--- a/arch/arm64/boot/dts/allwinner/sun55i-a527-cubie-a5e.dts
+++ b/arch/arm64/boot/dts/allwinner/sun55i-a527-cubie-a5e.dts
@@ -6,6 +6,7 @@
 #include "sun55i-a523.dtsi"
 
 #include <dt-bindings/gpio/gpio.h>
+#include <dt-bindings/leds/common.h>
 
 / {
 	model = "Radxa Cubie A5E";
@@ -27,6 +28,24 @@ ext_osc32k: ext-osc32k-clk {
 		clock-output-names = "ext_osc32k";
 	};
 
+	leds {
+		compatible = "gpio-leds";
+
+		power-led {
+			function = LED_FUNCTION_POWER;
+			color = <LED_COLOR_ID_GREEN>;
+			gpios = <&r_pio 0 4 GPIO_ACTIVE_LOW>; /* PL4 */
+			default-state = "on";
+			linux,default-trigger = "heartbeat";
+		};
+
+		use-led {
+			function = LED_FUNCTION_ACTIVITY;
+			color = <LED_COLOR_ID_BLUE>;
+			gpios = <&r_pio 0 5 GPIO_ACTIVE_LOW>; /* PL5 */
+		};
+	};
+
 	reg_vcc5v: vcc5v {
 		/* board wide 5V supply from the USB-C connector */
 		compatible = "regulator-fixed";
-- 
2.51.0



