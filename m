Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 040FB11706
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:44:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78B3FC433C8;
	Mon, 11 Sep 2023 14:44:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694443452;
	bh=eB8l9yyz+WBgtryRoy3+LPnaRvBCbMYnrAa/LOOc6IM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r3vOUYPyEeXpSsGMIclpdn92ZCfovIzt0vjEe2XxUaz060OTOMuMUkmHq6oOYiYGf
	 GFQKSLkUJQGtBVq9zai8MOzj/uDs/AaTIfDI6G6jqVidWhEV8/cyTuYpkBoHQUe0Ic
	 0VldWaSgjGK1nJrtHjW5u5gx5H2bG7k+L/+zfT5Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephan Gerhold <stephan@gerhold.net>,
	=?UTF-8?q?Andr=C3=A9=20Apitzsch?= <git@apitzsch.eu>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 382/737] arm64: dts: qcom: msm8916-longcheer-l8910: Add front flash LED
Date: Mon, 11 Sep 2023 15:44:01 +0200
Message-ID: <20230911134701.247361529@linuxfoundation.org>
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

From: André Apitzsch <git@apitzsch.eu>

[ Upstream commit 5d8d9330921770fb953e8e749bbd049ac0fae988 ]

l8910 uses OCP8110 flash LED driver. Add it to the device tree.

Tested-by: Stephan Gerhold <stephan@gerhold.net>
Signed-off-by: André Apitzsch <git@apitzsch.eu>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20230514-x5_front_flash-v2-1-845a8bb0483b@apitzsch.eu
Stable-dep-of: 4facccb44a82 ("arm64: dts: qcom: apq8016-sbc: Rename ov5640 enable-gpios to powerdown-gpios")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../boot/dts/qcom/msm8916-longcheer-l8910.dts | 22 +++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/msm8916-longcheer-l8910.dts b/arch/arm64/boot/dts/qcom/msm8916-longcheer-l8910.dts
index b79e80913af9f..6046e2c1f1586 100644
--- a/arch/arm64/boot/dts/qcom/msm8916-longcheer-l8910.dts
+++ b/arch/arm64/boot/dts/qcom/msm8916-longcheer-l8910.dts
@@ -20,6 +20,21 @@ chosen {
 		stdout-path = "serial0";
 	};
 
+	flash-led-controller {
+		compatible = "ocs,ocp8110";
+		enable-gpios = <&msmgpio 49 GPIO_ACTIVE_HIGH>;
+		flash-gpios = <&msmgpio 119 GPIO_ACTIVE_HIGH>;
+
+		pinctrl-0 = <&camera_front_flash_default>;
+		pinctrl-names = "default";
+
+		flash_led: led {
+			function = LED_FUNCTION_FLASH;
+			color = <LED_COLOR_ID_WHITE>;
+			flash-max-timeout-us = <250000>;
+		};
+	};
+
 	gpio-keys {
 		compatible = "gpio-keys";
 
@@ -246,6 +261,13 @@ button_backlight_default: button-backlight-default-state {
 		bias-disable;
 	};
 
+	camera_front_flash_default: camera-front-flash-default-state {
+		pins = "gpio49", "gpio119";
+		function = "gpio";
+		drive-strength = <2>;
+		bias-disable;
+	};
+
 	gpio_keys_default: gpio-keys-default-state {
 		pins = "gpio107";
 		function = "gpio";
-- 
2.40.1



