Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EE3C12B9C
	for <patches@lists.linux.dev>; Thu, 24 Aug 2023 17:16:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4A18C433C7;
	Thu, 24 Aug 2023 17:16:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1692897362;
	bh=9ng7+gjTvXR3BleGUtcEwM5nYqJtj7cPGfCoEML3/nY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DphmrsX0H5lGQ1Q1fBHOgsGAhY9BJbySXz7x0vKJY2+5LEx463REW/FAYUrsMkt7z
	 NnlZunFt9R/SN2c6O6q/thCW2HKFk7fOeSht8CegaNdpT2mCFRVxW4Fwsz9WO5+gsr
	 AseQfIQUizAMr3rRw0yGTROMw+s1pl4wU1Vjx8X8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleksij Rempel <o.rempel@pengutronix.de>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 012/135] ARM: dts: imx6dl: prtrvt, prtvt7, prti6q, prtwd2: fix USB related warnings
Date: Thu, 24 Aug 2023 19:08:04 +0200
Message-ID: <20230824170617.638081971@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230824170617.074557800@linuxfoundation.org>
References: <20230824170617.074557800@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oleksij Rempel <o.rempel@pengutronix.de>

[ Upstream commit 1d14bd943fa2bbdfda1efbcc080b298fed5f1803 ]

Fix USB-related warnings in prtrvt, prtvt7, prti6q and prtwd2 device trees
by disabling unused usbphynop1 and usbphynop2 USB PHYs and providing proper
configuration for the over-current detection. This fixes the following
warnings with the current kernel:
 usb_phy_generic usbphynop1: dummy supplies not allowed for exclusive requests
 usb_phy_generic usbphynop2: dummy supplies not allowed for exclusive requests
 imx_usb 2184200.usb: No over current polarity defined

By the way, fix over-current detection on usbotg port for prtvt7, prti6q
and prtwd2 boards. Only prtrvt do not have OC on USB OTG port.

Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/imx6dl-prtrvt.dts   |  4 ++++
 arch/arm/boot/dts/imx6qdl-prti6q.dtsi | 11 ++++++++++-
 2 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/imx6dl-prtrvt.dts b/arch/arm/boot/dts/imx6dl-prtrvt.dts
index 5ac84445e9cc1..90e01de8c2c15 100644
--- a/arch/arm/boot/dts/imx6dl-prtrvt.dts
+++ b/arch/arm/boot/dts/imx6dl-prtrvt.dts
@@ -126,6 +126,10 @@ &usbh1 {
 	status = "disabled";
 };
 
+&usbotg {
+	disable-over-current;
+};
+
 &vpu {
 	status = "disabled";
 };
diff --git a/arch/arm/boot/dts/imx6qdl-prti6q.dtsi b/arch/arm/boot/dts/imx6qdl-prti6q.dtsi
index 19578f660b092..70dfa07a16981 100644
--- a/arch/arm/boot/dts/imx6qdl-prti6q.dtsi
+++ b/arch/arm/boot/dts/imx6qdl-prti6q.dtsi
@@ -69,6 +69,7 @@ &usbh1 {
 	vbus-supply = <&reg_usb_h1_vbus>;
 	phy_type = "utmi";
 	dr_mode = "host";
+	disable-over-current;
 	status = "okay";
 };
 
@@ -78,10 +79,18 @@ &usbotg {
 	pinctrl-0 = <&pinctrl_usbotg>;
 	phy_type = "utmi";
 	dr_mode = "host";
-	disable-over-current;
+	over-current-active-low;
 	status = "okay";
 };
 
+&usbphynop1 {
+	status = "disabled";
+};
+
+&usbphynop2 {
+	status = "disabled";
+};
+
 &usdhc1 {
 	pinctrl-names = "default";
 	pinctrl-0 = <&pinctrl_usdhc1>;
-- 
2.40.1



