Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6C2F2E8E0D;
	Tue, 17 Jun 2025 16:35:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750178121; cv=none; b=TPUBFzMBDk4GTceiFhgl63/Jh9BwMRLQyUA2rsUoEW+OGQUmWTKmHDFd/5Od/siiS7DBPzurJPvOtHkF9+TRFwOdHE6E1OSxQuKLtYGdja/m4dn0KBV3WHu6yYiBXBs8yBFABK58tmYhWx6jjstn2uoLSsKrbWDN30c9/i7LSnc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750178121; c=relaxed/simple;
	bh=7zNNP52xCK0NhXuCfU0wAuQTNdqqn8nKQ+ZaofuTaH4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oL1vlLqxdDQOuDQ/pbvwlNgrWNcKbW9zokbtbYSVxitSAzQl52YtmhxBrW1RkA54MzfaCUiKrFttF866G6al8DCBDyXDxBJpoxhfkaYBfpadv655iaXwNQ7LUStk28VE8bfeHy/Gaq9yPJcKIsBytAzXYpqAmP71EqKmtqIbPVc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qD/1NWXb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qD/1NWXb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48239C4CEE3;
	Tue, 17 Jun 2025 16:35:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750178121;
	bh=7zNNP52xCK0NhXuCfU0wAuQTNdqqn8nKQ+ZaofuTaH4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qD/1NWXb4wF3qsZnCR1h77uKuHa7EZzkzSFJb/SK2+c1Wvn9Wl0BYMKIERAT3rwxT
	 xhjUyIquHmDSA+4Ky/mVb++Ld80uam4CUPhGLSBJsG/bKxiMQ8Ren+/yhzrwFCEAhu
	 sqSFm2tlS4MhbJO24RVC7QyzqHifIOXGdTFse5D8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Quentin Schulz <quentin.schulz@cherry.de>,
	Lukasz Czechowski <lukasz.czechowski@thaumatec.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 404/780] arm64: dts: rockchip: disable unrouted USB controllers and PHY on RK3399 Puma
Date: Tue, 17 Jun 2025 17:21:52 +0200
Message-ID: <20250617152507.910592020@linuxfoundation.org>
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

From: Quentin Schulz <quentin.schulz@cherry.de>

[ Upstream commit 3373af1d76bacd054b37f3e10266dd335ce425f8 ]

The u2phy1_host port is the part of the USB PHY1 (namely the
HOST1_DP/DM lanes) which routes directly to the USB2.0 HOST
controller[1]. The other lanes of the PHY are routed to the USB3.0 OTG
controller (dwc3), which we do use.

The HOST1_DP/DM lanes aren't routed on RK3399 Puma so let's simply
disable the USB2.0 controllers and associated part in USB2.0 PHY.

No intended functional change.

[1] https://rockchip.fr/Rockchip%20RK3399%20TRM%20V1.3%20Part2.pdf
    Chapter 2 USB2.0 PHY

Fixes: 2c66fc34e945 ("arm64: dts: rockchip: add RK3399-Q7 (Puma) SoM")
Signed-off-by: Quentin Schulz <quentin.schulz@cherry.de>
Signed-off-by: Lukasz Czechowski <lukasz.czechowski@thaumatec.com>
Link: https://lore.kernel.org/r/20250425-onboard_usb_dev-v2-4-4a76a474a010@thaumatec.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3399-puma.dtsi | 12 ------------
 1 file changed, 12 deletions(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3399-puma.dtsi b/arch/arm64/boot/dts/rockchip/rk3399-puma.dtsi
index 314d9dfdba573..587e89d7fc5e4 100644
--- a/arch/arm64/boot/dts/rockchip/rk3399-puma.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3399-puma.dtsi
@@ -585,10 +585,6 @@
 	u2phy1_otg: otg-port {
 		status = "okay";
 	};
-
-	u2phy1_host: host-port {
-		status = "okay";
-	};
 };
 
 &usbdrd3_1 {
@@ -622,11 +618,3 @@
 		vdd2-supply = <&vcc3v3_sys>;
 	};
 };
-
-&usb_host1_ehci {
-	status = "okay";
-};
-
-&usb_host1_ohci {
-	status = "okay";
-};
-- 
2.39.5



