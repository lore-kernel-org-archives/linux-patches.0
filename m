Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022838;
	b=NC7cl+Vow0bdar7FWF0YSjW9zMHWpG6SZhnhWUzgDehlgHCUYAdrKlG/oheuHVvfp9pW
	 bei68qj1t5f3lO/hIei/oBjGXoFoG2bThJ+/BNfWYN1T9tEjP/6HAzQQ4JT1/foKWkuFH
	 RgA/y7AK0JS3TOFPLzjB5XdzMPBYBEzryCsaIF5vbAJKoCJmfJ2cLUOdRi2xV9amQz5Rx
	 Cff2d/FAuGZ1IPlZKNeV2m7hOMqEPghskUcf/MzUFVrbkPFuSRXCiJeVhGZ/w+0goFIdE
	 VtfKxtkodCAx01ca9qm06kxVxWvs8VzG1/uPyvJyYzTBLiZtjXG+Ev3TcFtL33/TZkA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022838;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Aud5+sQ0G041zgrBjgrjQPYAjtxRgEmeEbMKKnaQiVk=;
	b=ujSTUXenR990gbYUbFKZJkg84cVZrJ6qk+eSaTqn096KiInMTiPa37N/2rt9BnKMAmsk
	 TrgoNdMSJSBCJ+syDxJ1huPcIa/NT/Pw10dJLhG/yQ5IPCrtAYymoXm0vPKInOS/Hmml4
	 GYk3io4Z2obUYrf0oJnsH3ZL3W1ze142rtI6880BIWkB9BQb6lJOWiP5CgMVWFwJNM81Z
	 72VSJIkoCPnUz8QUtm2NrN7dOhK0RU9io61G7X3Khh8qvyiekZBrG8hOL2OuZy/94bvha
	 mjn47XZACVtCEPlxv5l8aBi+e/4F9vfqlm/xbJS/nRLDOVHCAT5i4foClU/9t/hqsrA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Z3+5XJ1t;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7F87606B3D7;
	Wed, 18 Nov 2026 17:27:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Z3+5XJ1t
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B90B1F000C5;
	Wed, 18 Nov 2026 17:27:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022838;
	bh=Aud5+sQ0G041zgrBjgrjQPYAjtxRgEmeEbMKKnaQiVk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Z3+5XJ1tjsMAzipriRE4Nt0ZECJMlsB5Hf17jus2rE3pOttYj7RpdmDGIZVtnXf6y
	 nrbi0c7KZ2jS1Zfv1BTPq8v9o5/JqzQsK+khUPHsIfR7EOIK8uw/TfsSNjKdDv5HEF
	 H0kNLDsE4mNWN4Ma8Chq6jhP5AkEC5j71QftSoME=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Gregory CLEMENT <gregory.clement@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0156/2151] ARM: dts: helios4: fix vbus-supply for USB2 PHY
Date: Wed, 18 Nov 2026 15:31:31 +0100
Message-ID: <20261118150127.439482982@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
 arch/arm/boot/dts/marvell/armada-388-helios4.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/marvell/armada-388-helios4.dts b/arch/arm/boot/dts/marvell/armada-388-helios4.dts
index 0545452a983fc..1ed6ddf1719a7 100644
--- a/arch/arm/boot/dts/marvell/armada-388-helios4.dts
+++ b/arch/arm/boot/dts/marvell/armada-388-helios4.dts
@@ -140,7 +140,7 @@ fan2: j17-pwm {
 
 	usb2_phy: usb2-phy {
 		compatible = "usb-nop-xceiv";
-		vbus-regulator = <&reg_5p0v_usb>;
+		vbus-supply = <&reg_5p0v_usb>;
 	};
 
 	usb3_phy: usb3-phy {
-- 
2.53.0



