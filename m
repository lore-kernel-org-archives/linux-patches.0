Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 428A418E046;
	Tue, 30 Jul 2024 16:11:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722355866; cv=none; b=pikGnaTwAc9SjqnvBdn6HFXomWcyqtmzxVsvfVuNshqh6gIxcx+4aNXAxwTe7WXAlyUSVu5nk+cWsgI54mTo4A6PksEeGZ6MyZ/WbxRnh2kXO+C0wuD4P5/d5LIwFPkBhlX7WzM1EFDA/aOhSIQxrm900NP7ydvPxUBanSSvdQY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722355866; c=relaxed/simple;
	bh=UZgkvaTq4bR93/r80pQ5f7VCeu1PwUxXBvzjN16L61o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bXfzHNv3+2MHOZMeDNOupo/Z+NuGViwTDDMWMkZE84MWWSpMGW4nEv+JZWHI1fWeolMbtTdn7evGfqZLzuYkXn/5PNoAe09O14oQs0BIkzUTsNVTVpr8KH8dZ87s5rDQMefD4NLrquqqQKhxPQ/g3Br/I8ZKyy8NNwJTCnsx1Ag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mYn2eUBW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mYn2eUBW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACF77C32782;
	Tue, 30 Jul 2024 16:11:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722355866;
	bh=UZgkvaTq4bR93/r80pQ5f7VCeu1PwUxXBvzjN16L61o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mYn2eUBWlr6/rEnecIakTwRXpHEQcYtBBwKr4gp+kM3r7TFcMPKZg1wVfRAdZHYZf
	 o6tGmmBL12AJs47rYZIRgGcWOamoNCEA81rbWBQ/ykl/O89c2A7QMIPczznpNoIoSz
	 4Gr9kYoEKQxFRwI4zepmJRj9XQF751fNWPqOnHiA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chukun Pan <amadeus@jmu.edu.cn>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 097/568] arm64: dts: rockchip: fix usb regulator for Lunzn Fastrhino R6xS
Date: Tue, 30 Jul 2024 17:43:24 +0200
Message-ID: <20240730151643.666959012@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chukun Pan <amadeus@jmu.edu.cn>

[ Upstream commit 9e823ba92118510c0d1c050b67bb000f9b9a73d7 ]

Remove the non-existent usb_host regulator and fix the supply according
to the schematic. Also remove the unnecessary always-on and boot-on for
the usb_otg regulator.

Fixes: c79dab407afd ("arm64: dts: rockchip: Add Lunzn Fastrhino R66S")
Signed-off-by: Chukun Pan <amadeus@jmu.edu.cn>
Link: https://lore.kernel.org/r/20240701143028.1203997-2-amadeus@jmu.edu.cn
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../boot/dts/rockchip/rk3568-fastrhino-r66s.dtsi | 16 ++++------------
 1 file changed, 4 insertions(+), 12 deletions(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3568-fastrhino-r66s.dtsi b/arch/arm64/boot/dts/rockchip/rk3568-fastrhino-r66s.dtsi
index 93987c8740f7b..8f587978fa3b6 100644
--- a/arch/arm64/boot/dts/rockchip/rk3568-fastrhino-r66s.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3568-fastrhino-r66s.dtsi
@@ -78,15 +78,6 @@ vcc5v0_sys: vcc5v0-sys-regulator {
 		vin-supply = <&vcc12v_dcin>;
 	};
 
-	vcc5v0_usb_host: vcc5v0-usb-host-regulator {
-		compatible = "regulator-fixed";
-		regulator-name = "vcc5v0_usb_host";
-		regulator-always-on;
-		regulator-boot-on;
-		regulator-min-microvolt = <5000000>;
-		regulator-max-microvolt = <5000000>;
-	};
-
 	vcc5v0_usb_otg: vcc5v0-usb-otg-regulator {
 		compatible = "regulator-fixed";
 		enable-active-high;
@@ -94,8 +85,9 @@ vcc5v0_usb_otg: vcc5v0-usb-otg-regulator {
 		pinctrl-names = "default";
 		pinctrl-0 = <&vcc5v0_usb_otg_en>;
 		regulator-name = "vcc5v0_usb_otg";
-		regulator-always-on;
-		regulator-boot-on;
+		regulator-min-microvolt = <5000000>;
+		regulator-max-microvolt = <5000000>;
+		vin-supply = <&vcc5v0_sys>;
 	};
 };
 
@@ -460,7 +452,7 @@ &usb2phy0 {
 };
 
 &usb2phy0_host {
-	phy-supply = <&vcc5v0_usb_host>;
+	phy-supply = <&vcc5v0_sys>;
 	status = "okay";
 };
 
-- 
2.43.0



