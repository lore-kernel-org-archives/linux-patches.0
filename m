Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060247;
	b=jfkfpQPS+NMQlUKYLOZwDi5bf6eYZOo2g/J+aEQikGUb9WebEQud8CVCdFZ3mC83e0Ha
	 tirHInvOJ9RtzsTIGkZ36Q5Q7VcSKHipFBTQVuJ1q5UnIlhxCIjSNPfzYs0W9HJ8vE/nw
	 4+fLLl28wwXsW7oxSuLZoMA+w20BMAysX21TBXojhS2bdp3ocZUFgdZAklZapFKZ5AC1z
	 Tj3QqtywndqsV3d7cru1h+qAEL0bnRpqRELSJZn8ulcsWe1+wfPRXjROlZECs7J1qtrtX
	 PHzhLgjiYc6xr813cLsC7wi5TD9uRFsYP+ZQnl5tg7GEHSSvdUBT2mkzMA80QPIWbyg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060247;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tom0ULnGYazndKk/lWmi/XnGAMyC++dpupLZgvlrJdk=;
	b=c9LvnEKm0aiUxNS/n4FKHKrfJn+oPuAtB+1Q6T0oSO5eUrAeiuzTmjUaIxtByml79dRH
	 aCLe/rcCJx3Q1mdZLvWhA8Y1e8ob22VDyiAfNgKtLL9gMiBchHuxs0LpRG0vdlX8A6NP8
	 L2Z77VhxT6Q/uc6FJ98VW2knG8lb8WG5mHgzM+nFWIOqxfW+ucatcY8K/2wc++1ep2vqI
	 cXXLUHHGIQy1tUTgJvEJvalxYUHKqa2gxRUrcoRO68AaZ/UfQwXbQk+uRD2TR899lIyd8
	 ZdFI+pY0jE6iYDv5IK5Q50aD1n2IdpapeDL6mCtdH19u0EFUJ3+YrRg7Y8bHaldE5Yw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=b4ggnukg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 113B9606A326;
	Thu, 19 Nov 2026 03:50:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=b4ggnukg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 642541F000C5;
	Thu, 19 Nov 2026 03:50:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060246;
	bh=tom0ULnGYazndKk/lWmi/XnGAMyC++dpupLZgvlrJdk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=b4ggnukgLn2b9p6aQ0eeYvOWQnNFJq+5U9skKndAQc4mmX2lbJComqPIjxa+J+QeB
	 OFfVmsFbQsfgpJsiDeNXolQpEoVQfdx4HlCdKLddqbWx6XgciwSU7rMNOkjc+TGeg8
	 5kBMFD2uThmbAav+RGW0gklq1K6zIVFrIyh0BhD8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Gregory CLEMENT <gregory.clement@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1130/1848] ARM: dts: helios4: fix vbus-supply for USB2 PHY
Date: Wed, 18 Nov 2026 15:52:48 +0100
Message-ID: <20261118150006.599016106@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 0e0e254366b4c..c397e13e78afd 100644
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



