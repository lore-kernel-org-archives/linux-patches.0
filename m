Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047724;
	b=kMYJ28lB4XneZJw6w5kMwIham3Vs5H8/ZeV1dI8bTqTaX6cPZWM5e0GZETjcE9wLKJv8
	 JqfIAPXIRmzho7NIZ0QvRaeATB/g+S77r4P2tvoa70t886zOrQc4Z54lT29osqezNNxJo
	 lr49XAO4EDdBw8DMPMfZF0tLBDGZlppQ6hhi5TOI311kywg1G2pGdz8SYy9m1tME6abfz
	 wwKv1xUi4Ts5yAlYBskSJudMVYtIhlhYluYKrNby132fBTixyQAxIlX19UJpL/YvBqU3U
	 +Crxdc4W6UrefSPdAr8x8Fy0PXCcRTjyu48nGc5A5mljG+9NaCiqZJVEpsoJHbDsdIw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047724;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qWE/m91jdCfG1b/30MopWkx999esxojAKpZzJ5i+0Jc=;
	b=4Ud2J3Sh4pmQ+lpBYHSadOmPpPRmDoaKIeXIeDX9lkUf2U8APfmueCAGaK72zZKcfCFI
	 y8exGLahsseDWAol9aPNs1BTxOoeWi2gylWVHeL84vcLfD1ckSfIxc6ErOwxrA9igKs+J
	 Cc3Gf/XUQHwRYacOBhjgzzARrt58lwsTsOIEkGAR8rY/dWZZUfQek1jbB8vSa6eMxyBNm
	 AKEy8BXdU0DHJO3Ms7AC36yGbSrln1IclJVb0HXeg4F4L9CVAe9kZzb8EqllqF9JgXDS5
	 rvWhn8e0OOpE/nySQ1G5/tlZhgcuijhL2PwESfwUwXTVXx3WIzaelGvff9fE9Qd4yTQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=P8YD2qEY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79BA2606A31C;
	Thu, 19 Nov 2026 00:22:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=P8YD2qEY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB6AE1F000CC;
	Thu, 19 Nov 2026 00:22:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047724;
	bh=qWE/m91jdCfG1b/30MopWkx999esxojAKpZzJ5i+0Jc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=P8YD2qEYhc72WyfYdA/Hh2w94WT+7EDLuZcBvopsZs9X4+Jy0vYPT0w+wqKLwFhsN
	 GPWQttutt9pf1qZkbmap082DWYS48upXLaaGCYbU+y+YeFdeOezkrpBSBSTlOuVza0
	 RZqCYgPDhX4rV0El9wZyOCsVjy6BY2CRiWW11NoA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Gregory CLEMENT <gregory.clement@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1742/2857] ARM: dts: helios4: fix vbus-supply for USB2 PHY
Date: Wed, 18 Nov 2026 15:46:16 +0100
Message-ID: <20261118150304.026811719@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rosen Penev <rosenp@gmail.com>

[ Upstream commit a132798a133e76a7bb575ba95b2b64eadd245438 ]

The usb-nop-xceiv binding and driver use "vbus-supply"; the driver
acquires the VBUS regulator via devm_regulator_get_exclusive("vbus")
(phy-generic.c). The stale "vbus-regulator" name is never read by
the driver and dtbs_check rejects it as an unknown property. Rename
the property so reg_5p0v_usb is honored.

Fixes: ced8025b569e ("ARM: dts: armada388-helios4")
Assisted-by: opencode:big-pickle
Signed-off-by: Rosen Penev <rosenp@gmail.com>
Signed-off-by: Gregory CLEMENT <gregory.clement@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/armada-388-helios4.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/armada-388-helios4.dts b/arch/arm/boot/dts/armada-388-helios4.dts
index 0545452a983fc..1ed6ddf1719a7 100644
--- a/arch/arm/boot/dts/armada-388-helios4.dts
+++ b/arch/arm/boot/dts/armada-388-helios4.dts
@@ -140,7 +140,7 @@ fan2: j17-pwm {
 
 	usb2_phy: usb2-phy {
 		compatible = "usb-nop-xceiv";
-		vbus-regulator = <&reg_5p0v_usb>;
+		vbus-supply = <&reg_5p0v_usb>;
 	};
 
 	usb3_phy: usb3-phy {
-- 
2.53.0



