Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF6AB2367A0;
	Tue, 17 Jun 2025 16:31:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750177893; cv=none; b=Z9u/l1dJiDOMgJD/Ob7GVM0aeHUo4M8Y+TCWsyc7mMdLgtX+MHb82+h9CnjXODG8UTbK+hiM2+ZENr3CSEHnWzkABJ0kjgdf6KiKWyUCCds/XX2h1Arufyc51gRwVSjViHn/XdkaMp+5LHDnNt8B7HJZReHoOqR6ZX5DNvtfoAE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750177893; c=relaxed/simple;
	bh=0q2H0dH9pIfTIdHVcGAGiGAT023fF9ZuXDLaBsGmZ8M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q6JQ9iGWg+X5MuoB85nWFJk7E5k64Z/2IUQswU8UvI12mXJ580QWqgs3RTN/y22dryqO5PZe3Gr/y6Bu1UBNzO/fC71J0kjZkzNmOsIYpSbUt2TuQBbR4txKPT5CsVR6qtjo4idorGijbZRrGN5Lr223oLeN0Rrp7NwoynIEYVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dgE/r/RS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dgE/r/RS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55A02C4CEE3;
	Tue, 17 Jun 2025 16:31:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750177893;
	bh=0q2H0dH9pIfTIdHVcGAGiGAT023fF9ZuXDLaBsGmZ8M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dgE/r/RSpksrzIMT72O7tuQyYWBcDaPxipfGeaMXBLlLy1ASLC8cfZtqXFOmCVHON
	 h/gF81grPBYSTUOZKPS9hA/PqT80sfw3YQT6GZq0tIp5IfphqWNd1mFsCLn8tp+oS9
	 b45wMwpB67sU7stwU5hfnNE1j5xqt7thLvunQiQI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 378/780] arm64: dts: mediatek: mt8390-genio-common: Set ssusb2 default dual role mode to host
Date: Tue, 17 Jun 2025 17:21:26 +0200
Message-ID: <20250617152506.848713236@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>

[ Upstream commit f9167f15dd4e70b124023a2f7ba2b09401b3b6ff ]

On the Mediatek Genio 510-EVK and 700-EVK boards, ssusb2 controller is
one but has two ports: one is routed to the M.2 slot, the other is on
the RPi header who does support full OTG.
Since Mediatek Genio 700-EVK USB support was added, dual role mode
property is set to otg for ssusb2. This config prevents the M.2
Wifi/Bluetooth module, present on those boards and exposing Bluetooth
as an USB device to be properly detected at startup as the default role
is device.
To keep the OTG functionality and make the M.2 module be detected at
the same time, add role-switch-default-mode property set to host and
also fix the polarity of GPIO associated to the USB connector, so the
ssusb2 controller role is properly set to host when the other port is
unused.

Fixes: 1afaeca17238 ("arm64: dts: mediatek: mt8390-genio-700: Add USB, TypeC Controller, MUX")
Signed-off-by: Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>
Link: https://lore.kernel.org/r/20250502-mtk-genio-510-700-fix-bt-detection-v2-1-870aa2145480@collabora.com
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../arm64/boot/dts/mediatek/mt8390-genio-common.dtsi | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/mediatek/mt8390-genio-common.dtsi b/arch/arm64/boot/dts/mediatek/mt8390-genio-common.dtsi
index 60139e6dffd8e..6a75b230282ed 100644
--- a/arch/arm64/boot/dts/mediatek/mt8390-genio-common.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt8390-genio-common.dtsi
@@ -1199,8 +1199,18 @@
 };
 
 &ssusb2 {
+	/*
+	 * the ssusb2 controller is one but we got two ports : one is routed
+	 * to the M.2 slot, the other is on the RPi header who does support
+	 * full OTG.
+	 * As the controller is shared between them, the role switch default
+	 * mode is set to host to make any peripheral inserted in the M.2
+	 * slot (i.e BT/WIFI module) be detected when the other port is
+	 * unused.
+	 */
 	dr_mode = "otg";
 	maximum-speed = "high-speed";
+	role-switch-default-mode = "host";
 	usb-role-switch;
 	vusb33-supply = <&mt6359_vusb_ldo_reg>;
 	wakeup-source;
@@ -1211,7 +1221,7 @@
 	connector {
 		compatible = "gpio-usb-b-connector", "usb-b-connector";
 		type = "micro";
-		id-gpios = <&pio 89 GPIO_ACTIVE_HIGH>;
+		id-gpios = <&pio 89 GPIO_ACTIVE_LOW>;
 		vbus-supply = <&usb_p2_vbus>;
 	};
 };
-- 
2.39.5



