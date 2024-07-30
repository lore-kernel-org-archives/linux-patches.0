Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B85C21A616E;
	Tue, 30 Jul 2024 16:17:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722356239; cv=none; b=RtdUyeu9+iu4IwHuI/a44GOTPwYr4LdAwNqmisO16ye8iuG9zNEbGk8silYaHRjMAgal/beS60jOCgpqfQ5/U/NTm3RO9F5OMywBOtRAd/qakKqsZSoctYu1AOe+bTxjyzCkadcZWWtRiwYeqgxFYlD/NEW0X7dMNju0jaQySNM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722356239; c=relaxed/simple;
	bh=aYGLLEVU7xAWUsbM0uZG8w0CNiq5K0Cy312lxp/+VMk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oCpGeoHaA5aAupPS30QGReuO5ncHzs4NDIc2FKZGkxK4zHCAEFO1LS74Adhquncm9c+/VEj7V9SndnLd+4WE87zxYhGKu+s62EINJ7aSmCdm3NfoCZ3ipiJHc8/94JaEe9VbyVcAj2ELcIZnoSsaz9qSLvJmX8VDNbMkWwPcyqU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yK1ZDR9q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yK1ZDR9q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E2ABC4AF0A;
	Tue, 30 Jul 2024 16:17:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722356239;
	bh=aYGLLEVU7xAWUsbM0uZG8w0CNiq5K0Cy312lxp/+VMk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yK1ZDR9qX7YTMRT9+oQcaJ9NC5UWFod77GrEaaR9vGujuJn2b7Chzg/13TlYxLcoV
	 GAFiH3d0YAhtfB+OqAJO7mfPYT1ioop4Ms6vgoz5jSSLaV+RXxJ3CSxV9nJ8bsXq9x
	 72Hc0xFQ86Zy2n+uRYzXsiZGSbIvvjm61FZn9Fkk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chukun Pan <amadeus@jmu.edu.cn>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 132/809] arm64: dts: rockchip: fix usb regulator for Lunzn Fastrhino R6xS
Date: Tue, 30 Jul 2024 17:40:08 +0200
Message-ID: <20240730151729.830191385@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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



