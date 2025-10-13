Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41F2230C36B;
	Mon, 13 Oct 2025 15:07:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760368059; cv=none; b=KCthyZRzjItS5VfB3QP7H66xi0YpkrdLN9HyyU+yf6QY+JQXfk0XdIc722QSXcD8Kx6K44Ai8/BhyIPgxtlvHy5RjTbBtjZQv8B+8vINJbFWYdIrGe5I2a/EDil9mZ6cvQeYqWgfD1xFrOKW/k8nPLFmSxTtewf82bdxutg4r5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760368059; c=relaxed/simple;
	bh=DeN2E2L2vJ81Rtx513kvi70v3rArmDvbj6IEfcYcv0Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aJr5UGWcvAOXnlPiyHiNLZWCB1T5+hVj5Yj+8CDBvZYn13zrqfSZiAMgkVximwRDtfprMcTxgrN9lAZ9gxFB5+E9TSJttHSNwRdNzK3X5jqIVqO0j6x2catJ7DYHMGxO+Pm8cqA+Jv7md7G7LBbJ7bI2nkWi3AP21zaDR/vu6BQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i4PeL6HW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i4PeL6HW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84223C4CEE7;
	Mon, 13 Oct 2025 15:07:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760368058;
	bh=DeN2E2L2vJ81Rtx513kvi70v3rArmDvbj6IEfcYcv0Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i4PeL6HWm/SrPSDxDXIPZVeTIwXmhnymQxc60+DO81a9YjHP+UkEQd0ylC5JZdnhp
	 0WAVH8yyt+Oih0cJLHfnZ2IA70FR1f50NCcn+7quWJkrxn4ZGSBlJcQY4+nZ7ldh8S
	 9Q2A/OlSO2W6T6xfWupZFPsVweORTZ+pJtBTi3R0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frieder Schrempf <frieder.schrempf@kontron.de>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 029/262] arm64: dts: imx93-kontron: Fix USB port assignment
Date: Mon, 13 Oct 2025 16:42:51 +0200
Message-ID: <20251013144327.182811119@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144326.116493600@linuxfoundation.org>
References: <20251013144326.116493600@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Frieder Schrempf <frieder.schrempf@kontron.de>

[ Upstream commit c94737568b290e0547bff344046f02df49ed6373 ]

The assignment of the USB ports is wrong and needs to be swapped.
The OTG (USB-C) port is on the first port and the host port with
the onboard hub is on the second port.

Signed-off-by: Frieder Schrempf <frieder.schrempf@kontron.de>
Fixes: 2b52fd6035b7 ("arm64: dts: Add support for Kontron i.MX93 OSM-S SoM and BL carrier board")
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../dts/freescale/imx93-kontron-bl-osm-s.dts  | 20 +++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/arch/arm64/boot/dts/freescale/imx93-kontron-bl-osm-s.dts b/arch/arm64/boot/dts/freescale/imx93-kontron-bl-osm-s.dts
index 9a9e5d0daf3ba..c3d2ddd887fdf 100644
--- a/arch/arm64/boot/dts/freescale/imx93-kontron-bl-osm-s.dts
+++ b/arch/arm64/boot/dts/freescale/imx93-kontron-bl-osm-s.dts
@@ -137,6 +137,16 @@ &tpm6 {
 };
 
 &usbotg1 {
+	adp-disable;
+	hnp-disable;
+	srp-disable;
+	disable-over-current;
+	dr_mode = "otg";
+	usb-role-switch;
+	status = "okay";
+};
+
+&usbotg2 {
 	#address-cells = <1>;
 	#size-cells = <0>;
 	disable-over-current;
@@ -149,16 +159,6 @@ usb1@1 {
 	};
 };
 
-&usbotg2 {
-	adp-disable;
-	hnp-disable;
-	srp-disable;
-	disable-over-current;
-	dr_mode = "otg";
-	usb-role-switch;
-	status = "okay";
-};
-
 &usdhc2 {
 	vmmc-supply = <&reg_vdd_3v3>;
 	status = "okay";
-- 
2.51.0



