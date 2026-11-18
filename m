Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054735;
	b=qC3l5kGzz8TrQvFH2d+Dwp4usUVkrkrBiFc8D0G5lHEp3HJhkzClSzQm3PtvbSR3Gyln
	 fxDRQ4SzgGUO1NHupylFM/8TOsCbiAlbP4IVWBVgswbC9REBuFxM47LuIj69hibx4UN2i
	 4JO1y753tb/bM+3qEQ4RH3tpEa+h+DLXzhf8wcG777z7+FnjYOdbhEoIy1/W8UdglLr1o
	 N8qcjW4kmZntd119kOO7qfCmZG/vi3UpRWNaAhEgz1JvcIL5llhh8+wxyesZYbzITkNre
	 R05wmXlXGCn3Yap7Z5KTj3j/EAiPvGbYtWT1pbLi3B60Ycb7vsqEFPIARcCpkoIfl2A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054735;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wQbroDynchnSW1DJRv9+faPrJ2cr/gZcdZ5lbM7vDwA=;
	b=pdTu7QU+8soGW6+LZgHgCi5wlMfox5dYmuHfacq9N9rpv/XfXD7Ex56aRzSUpkPtM6Rw
	 JhSum3/O0RgiXP85FQTnAW1Qs+RnsWCWtsQrul/4yjSyge9PX9LST/qE0e3F6ajb6WJyL
	 P+ncENY3hxj9z0EQ3Yr+spuia3K5Gmc9tpK6/nwJ2LK5F62oOHFMmSD1FvJ4X5WjQVmlk
	 whogdpNyZiatnwcvPU7M8gpIthEa3tnJFAbgogUZZbxU97spGcMIVeTQKXSZGY+n7T+Wm
	 Mbh0ZTOVaTKJupKd/Zr91Ktj8skH9XwDxZNEW/sJMQINRjw2Y/YFHbX+8M4c/uii2/Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AJqgRUmJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68A3F606A31C;
	Thu, 19 Nov 2026 02:18:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AJqgRUmJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 268A51F000C4;
	Thu, 19 Nov 2026 02:18:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054734;
	bh=wQbroDynchnSW1DJRv9+faPrJ2cr/gZcdZ5lbM7vDwA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AJqgRUmJxgIO+BLskEVIxhs2iYRmOOPTPc7Z8FOWHDDKM8fum4YeCbxgtQk18Qj6o
	 s+G4JY5iss80y/L9IVyo1zQC1euwiPamazNLbU2kF+Vx5TtZQFea31foTpcxe24Eci
	 OA+Gh/X3066RQHc80RfyhN6Trrghh8HKVtDrTZUA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Gregory CLEMENT <gregory.clement@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1339/2214] ARM: dts: helios4: fix vbus-supply for USB2 PHY
Date: Wed, 18 Nov 2026 15:50:15 +0100
Message-ID: <20261118150105.003647002@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



