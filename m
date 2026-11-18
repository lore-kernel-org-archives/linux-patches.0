Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039155;
	b=HARw9NDXC8niLuXyXrCsEKQPDHRfOi5xrKPG9MsL13SGKwckA2uJiHSp6PAoU/c/DAb1
	 bFw7lNwAXrO0FIDwXYvnNPx/aQcyu8m8hFg3lqsCGc5Wz2UTWAymJuRySv0zeX+yxyPbs
	 Fkrg/GNrQ0//qxLqKCUkccp3E4+T61dpenVFxnqqvWBCLBTW1JU/YIszekVK18Xy2QhYZ
	 4+atqvzOG0dQthqHsD1H/JAN27Pz9PgFKRe6xLNe3xXzz464lYe0Sc5ok6+oOf5ldjQ83
	 exmWwvvslj1zsrDn/d3Kp0x5db9PV7qtZozpBw3tDxathrVJ+bJktLQMrVzcEnEWFZQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039155;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xDm/9uFcbWiOf9VXz9na8IWvW1cHyu6K36T5TKUwb3g=;
	b=rePgRNmXbQpQGxvwFMAPYV5sPvZgHBeWwlpUywRHkbdVDexSP3pWKl43X51Uapwfx5Oi
	 lE4sLZVdaQ6zKfiTmiHp3Eus/goIC3YaB8QLZohtlpeCYh3Am6m3nLhBavJJAyjtlGTOt
	 XamD96/0HAxKSer97YuCftBnKKpjl3YE1SC2is+T07wMuZb+V66SOkcX/KCniZZSQ32d8
	 U6++RjstEJm8mQxCMB02ABduFDLzR35lLO/kjLUuMb8+kBp1NnLEGjC1zKigEk8x9e9Y3
	 F5CSyaaC+t9SBeRGXZMpHlj5kupDrU+Y9+BLgTIN8tKdfN4zvXuW2lDoKN/zJN8xhGg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=U3qLUzOO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC988606A31C;
	Wed, 18 Nov 2026 21:59:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=U3qLUzOO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D81A1F000C4;
	Wed, 18 Nov 2026 21:59:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039155;
	bh=xDm/9uFcbWiOf9VXz9na8IWvW1cHyu6K36T5TKUwb3g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=U3qLUzOO/VuMTubygC3ejIul/nyUQIMKrY9osNVOcAl4zE1EZZkP76N+dMgX4Dius
	 9GWZkf+R0yYm9LPoGACd+IS7W4si5tOoftFwFUk7ZTTPnzsRT6L4i2DdPgqeXUGr7H
	 AnHjjrvSChTnyyRJ4ITy6zAbm0ZdeIYH5zkhdMCE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Gregory CLEMENT <gregory.clement@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1998/3318] ARM: dts: armada-388-helios4: fix vmmc property name
Date: Wed, 18 Nov 2026 15:43:40 +0100
Message-ID: <20261118150421.993558357@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rosen Penev <rosenp@gmail.com>

[ Upstream commit 008e9faadef8c0aaa9b8a3ff05a2126e3c5b08b7 ]

The sdhci@d8000 node references the 3.3V regulator through a bare
"vmmc" property, which is not part of the mmc controller DT
binding. The binding requires supply properties in the form
"vmmc-supply", so the current entry is ignored by the driver.

Rename the property to "vmmc-supply" so the fixed regulator is
correctly wired up as the card power supply.

Fixes: ced8025b569e ("ARM: dts: armada388-helios4")
Assisted-by: opencode:big-pickle
Signed-off-by: Rosen Penev <rosenp@gmail.com>
Signed-off-by: Gregory CLEMENT <gregory.clement@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/marvell/armada-388-helios4.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/marvell/armada-388-helios4.dts b/arch/arm/boot/dts/marvell/armada-388-helios4.dts
index f5ae4bea1211f..0545452a983fc 100644
--- a/arch/arm/boot/dts/marvell/armada-388-helios4.dts
+++ b/arch/arm/boot/dts/marvell/armada-388-helios4.dts
@@ -269,7 +269,7 @@ sdhci@d8000 {
 					     &helios_sdhci_cd_pins>;
 				pinctrl-names = "default";
 				status = "okay";
-				vmmc = <&reg_3p3v>;
+				vmmc-supply = <&reg_3p3v>;
 				wp-inverted;
 			};
 
-- 
2.53.0



