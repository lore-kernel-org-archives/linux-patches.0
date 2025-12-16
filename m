Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7431D36B046;
	Tue, 16 Dec 2025 12:16:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765887407; cv=none; b=mh+eflHv/5MTN8d4MYvryIu/joyaHw7QNAPamZU85ZOm+uj8c6sqGAEYfi3BdamP9tWwaRRdblJKBwcEFqr1juOCxdYedkj50K8zu4Pk0B/UR77Xr+35auo2vNU4DFJEMsPTTB1c/R6ItWCxFcsjp/lhuiO2PHaQ3QLKEtVXglU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765887407; c=relaxed/simple;
	bh=b107guZ2DAN/jlsOw9DIDOnYe9QfMVP/7LvlOcQbqto=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fzUjGsAj/vkyFiqCMYzk2YdvKjwBjiLPL0qhvD914+uQ4wk+kGwbSWe9cW/F8ZE8y1G48qGlMDMH/yr/N5hgJ/RsoUSKxM/5zYsaBSFZDVf9fmy4uXTfiS5+ddIvPdntGAdmiSmfLXBzDK+KdDs8xn64dhYoWHHbwyr9YWYrcJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XSoUmfhz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XSoUmfhz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E87DDC4CEF1;
	Tue, 16 Dec 2025 12:16:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765887407;
	bh=b107guZ2DAN/jlsOw9DIDOnYe9QfMVP/7LvlOcQbqto=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XSoUmfhzRHW1qYdcoIzDDiZO1mMTfpZ/AtyTvKkX+dVeyQbd/4uVrfTzpI3mQaPfQ
	 eQs6vjtCvir1KN1pbLfVjSOAj4xXIfL0K9AwIb5RQuSAYtcZFGqgZvABKtoca5C4O6
	 KOrH8wNOclJjQU5pSxWq7HBuR08bbF9LZ+nYaeTA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	FUKAUMI Naoki <naoki@radxa.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 221/614] arm64: dts: rockchip: Fix USB Type-C host mode for Radxa ROCK 5B+/5T
Date: Tue, 16 Dec 2025 12:09:48 +0100
Message-ID: <20251216111409.381364761@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: FUKAUMI Naoki <naoki@radxa.com>

[ Upstream commit fbf90d1b697faf61bb8b3ed72be6a8ebeb09de3d ]

The Radxa ROCK 5B+/5T USB Type-C port supports Dual Role Data and
should also act as a host. However, currently, when acting as a host,
only self-powered devices work.

Since the ROCK 5B+ supports Dual Role Power, set the power-role
property to "dual" and the try-power-role property to "sink". (along
with related properties)

The ROCK 5T should only support the "source" power-role.

This allows the port to act as a host, supply power to the port, and
allow bus-powered devices to work.

Note that on the ROCK 5T, with this patch applied, it has been
observed that some bus-powered devices do not work correctly. Also,
it has been observed that after connecting a device (and the data-role
switches to host), connecting a host device does not switch the
data-role back to the device role. These issues should be addressed
separately.

Note that there is a separate known issue where USB 3.0 SuperSpeed
devices do not work when oriented in reverse. This issue should also be
addressed separately. (USB 2.0/1.1 devices work in both orientations)

Fixes: 67b2c15d8fb3c ("arm64: dts: rockchip: add USB-C support for ROCK 5B/5B+/5T")
Signed-off-by: FUKAUMI Naoki <naoki@radxa.com>
Link: https://patch.msgid.link/20251104085227.820-1-naoki@radxa.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3588-rock-5b-5bp-5t.dtsi | 4 ++--
 arch/arm64/boot/dts/rockchip/rk3588-rock-5b-plus.dts    | 5 +++++
 arch/arm64/boot/dts/rockchip/rk3588-rock-5b.dts         | 4 ++++
 arch/arm64/boot/dts/rockchip/rk3588-rock-5t.dts         | 4 ++++
 4 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3588-rock-5b-5bp-5t.dtsi b/arch/arm64/boot/dts/rockchip/rk3588-rock-5b-5bp-5t.dtsi
index 3bbe78810ec6f..7aac77dfc5f16 100644
--- a/arch/arm64/boot/dts/rockchip/rk3588-rock-5b-5bp-5t.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3588-rock-5b-5bp-5t.dtsi
@@ -331,12 +331,12 @@ usb_con: connector {
 			data-role = "dual";
 			/* fusb302 supports PD Rev 2.0 Ver 1.2 */
 			pd-revision = /bits/ 8 <0x2 0x0 0x1 0x2>;
-			power-role = "sink";
-			try-power-role = "sink";
 			op-sink-microwatt = <1000000>;
 			sink-pdos =
 				<PDO_FIXED(5000, 3000, PDO_FIXED_USB_COMM)>,
 				<PDO_VAR(5000, 20000, 5000)>;
+			source-pdos =
+				<PDO_FIXED(5000, 3000, PDO_FIXED_USB_COMM)>;
 
 			altmodes {
 				displayport {
diff --git a/arch/arm64/boot/dts/rockchip/rk3588-rock-5b-plus.dts b/arch/arm64/boot/dts/rockchip/rk3588-rock-5b-plus.dts
index 5e984a44120e4..07a840d9b3859 100644
--- a/arch/arm64/boot/dts/rockchip/rk3588-rock-5b-plus.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3588-rock-5b-plus.dts
@@ -110,6 +110,11 @@ vcc5v0_host_en: vcc5v0-host-en {
 	};
 };
 
+&usb_con {
+	power-role = "dual";
+	try-power-role = "sink";
+};
+
 &usbdp_phy0 {
 	pinctrl-names = "default";
 	pinctrl-0 = <&usbc_sbu_dc>;
diff --git a/arch/arm64/boot/dts/rockchip/rk3588-rock-5b.dts b/arch/arm64/boot/dts/rockchip/rk3588-rock-5b.dts
index 8ef01010d985b..da13dafcbc823 100644
--- a/arch/arm64/boot/dts/rockchip/rk3588-rock-5b.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3588-rock-5b.dts
@@ -49,6 +49,10 @@ vcc5v0_host_en: vcc5v0-host-en {
 	};
 };
 
+&usb_con {
+	power-role = "sink";
+};
+
 &usbdp_phy0 {
 	pinctrl-names = "default";
 	pinctrl-0 = <&usbc_sbu_dc>;
diff --git a/arch/arm64/boot/dts/rockchip/rk3588-rock-5t.dts b/arch/arm64/boot/dts/rockchip/rk3588-rock-5t.dts
index c1763835f53d4..0dd90c744380b 100644
--- a/arch/arm64/boot/dts/rockchip/rk3588-rock-5t.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3588-rock-5t.dts
@@ -130,6 +130,10 @@ usbc_sbu_dc: usbc-sbu-dc {
 	};
 };
 
+&usb_con {
+	power-role = "source";
+};
+
 &usbdp_phy0 {
 	pinctrl-names = "default";
 	pinctrl-0 = <&usbc_sbu_dc>;
-- 
2.51.0



