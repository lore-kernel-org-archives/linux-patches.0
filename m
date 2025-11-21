Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F5C326CE33;
	Fri, 21 Nov 2025 13:20:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763731247; cv=none; b=kzRJ5vquqQJ6OhsLMK2hIPj7eTDkmuo5aHdyezO9kBHM/6IV4t1hD60dqpp3p4YzpksEh30AFlMlAuhxjdF7NdZc7vXcZUzYZgZ1t/kKLLYW1W+UVsMWxUDJj6OH0pG96Fghcdedv4BqTqfGbmORDgsEAvowDDeXyenEdM4txXg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763731247; c=relaxed/simple;
	bh=ivqBYN+6ThktE3XzatE0XzD+468QmYQOFbJRoYZvACU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HBpgV/kxtwRcPqlTW8zAYMnJwW/+A+4BkJ/abXSAmXq97Vpx1KbSPBcPGax3n0G4vtwzF0xf22hHe8RehBgcyi97kAKX63NFvj6c5gipzolocOW2KzIwn5YC2NufCl3ufuhVJcDZq/EqAytMmcaRx9FgD2h63JLDc6prTFvuwuE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZXmjq8aT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZXmjq8aT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02537C4CEF1;
	Fri, 21 Nov 2025 13:20:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763731247;
	bh=ivqBYN+6ThktE3XzatE0XzD+468QmYQOFbJRoYZvACU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZXmjq8aTzyd2X6Wm/cILsTlnR49Va+vYhoAmfNGB5EnTVnJvCPdIPYjj6V60AReek
	 Bby1aB/Q/S2ksBlQLbBG73pM7NwIAniwGYD2bwIqZiE3VUgcE/aNJoZARxBZsfuVRc
	 CdXwLuAG2/1ld2l0/ynkZ8RPUI3S2Hy2/4iGLKTA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frieder Schrempf <frieder.schrempf@kontron.de>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 141/247] arm64: dts: imx8mp-kontron: Fix USB OTG role switching
Date: Fri, 21 Nov 2025 14:11:28 +0100
Message-ID: <20251121130159.786748219@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130154.587656062@linuxfoundation.org>
References: <20251121130154.587656062@linuxfoundation.org>
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

From: Frieder Schrempf <frieder.schrempf@kontron.de>

[ Upstream commit 6504297872c7a5d0d06247970d32940eba26b8b3 ]

The VBUS supply regulator is currently assigned to the PHY node.
This causes the VBUS to be always on, even when the controller
needs to be switched to peripheral mode.

Fix the OTG role switching by adding a connector node and moving
the VBUS supply regulator to that node. This way the VBUS gets
correctly switched according to the current role.

Fixes: 946ab10e3f40 ("arm64: dts: Add support for Kontron OSM-S i.MX8MP SoM and BL carrier board")
Signed-off-by: Frieder Schrempf <frieder.schrempf@kontron.de>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../dts/freescale/imx8mp-kontron-bl-osm-s.dts | 24 +++++++++++++++----
 1 file changed, 19 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/boot/dts/freescale/imx8mp-kontron-bl-osm-s.dts b/arch/arm64/boot/dts/freescale/imx8mp-kontron-bl-osm-s.dts
index 0eb9e726a9b81..6c63f0a5fa91b 100644
--- a/arch/arm64/boot/dts/freescale/imx8mp-kontron-bl-osm-s.dts
+++ b/arch/arm64/boot/dts/freescale/imx8mp-kontron-bl-osm-s.dts
@@ -16,11 +16,20 @@
 		ethernet1 = &eqos;
 	};
 
-	extcon_usbc: usbc {
-		compatible = "linux,extcon-usb-gpio";
+	connector {
+		compatible = "gpio-usb-b-connector", "usb-b-connector";
+		id-gpios = <&gpio1 10 GPIO_ACTIVE_HIGH>;
+		label = "Type-C";
 		pinctrl-names = "default";
 		pinctrl-0 = <&pinctrl_usb1_id>;
-		id-gpios = <&gpio1 10 GPIO_ACTIVE_HIGH>;
+		type = "micro";
+		vbus-supply = <&reg_usb1_vbus>;
+
+		port {
+			usb_dr_connector: endpoint {
+				remote-endpoint = <&usb3_dwc>;
+			};
+		};
 	};
 
 	leds {
@@ -230,9 +239,15 @@
 	hnp-disable;
 	srp-disable;
 	dr_mode = "otg";
-	extcon = <&extcon_usbc>;
 	usb-role-switch;
+	role-switch-default-mode = "peripheral";
 	status = "okay";
+
+	port {
+		usb3_dwc: endpoint {
+			remote-endpoint = <&usb_dr_connector>;
+		};
+	};
 };
 
 &usb_dwc3_1 {
@@ -261,7 +276,6 @@
 };
 
 &usb3_phy0 {
-	vbus-supply = <&reg_usb1_vbus>;
 	status = "okay";
 };
 
-- 
2.51.0



