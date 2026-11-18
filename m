Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054726;
	b=mH6yTFW/ychgKm0bwkseOTfla3ZvYJY4ReDlMrqfe3xq/cuslJmD/nE1tweGxBTGNTDb
	 qS9Az3G3cgW8O8BU83wBFee3kS0SyYYICDhKYVvhWpKb83s6eqlr053PTrzqMPhA/rkMW
	 50zEKlnU9bMhe1ehyhH1MHnsBbv9afaCueCpsv5nTW5Dn899rhEN+Bbj1OCU5CX5gVGsS
	 YGhSAsVwHFo4vDnVuG0FpIhjlU2gLx0uFeKPQwB8oyw6O6DhFfBgIKuR4U5VZryAF3MUf
	 C0h6Af6o7emrWp0DsPTjdC8ULgmBjDyo9suwKCs8AnO5zOfb5P6Tm9wVjwnjPfuECRQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054726;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hfzWmyb0aqxpV9aojR48jw1fQutF+8VjaMiBUJN8pIA=;
	b=gk/cD98UiZLVV18nWFAneRPG7Zj72sozeallN5KibWHA3fXxmh0ob8DJAocZQ/HYkpeC
	 gaMzyWAjmCjglXvVSk553S2fQFFN4ijGSW1lydSyVWcTQo3lTrnlH5vmMX6Qhkxsu+KYq
	 bzH4sOPfYM6RwiVRgGo/jUnbaXApCA9+s8daaEajLidq3Jr7G02vuJlMh3WsGRXiq+eE4
	 40LaoHeR51fZ6I2pUqyBnXObcl4o0OXYMt9i5mIDbUuzCqsvFX4g2WUT9Ch/9jD6pp62T
	 e3D8lnOExfUdlvix3su/vs57YJws4tqUkBw1AztEiI14FtrCLOjHR1SVx4wM7MqMZEw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wcaFtS7e;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 495C1606A31C;
	Thu, 19 Nov 2026 02:18:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wcaFtS7e
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9984F1F000C4;
	Thu, 19 Nov 2026 02:18:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054726;
	bh=hfzWmyb0aqxpV9aojR48jw1fQutF+8VjaMiBUJN8pIA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wcaFtS7eR1JfeKXVCfRWUuS9O4yKshAsoZxmR/W65Ii9AxwhtEceIG9S0o2wqMmYC
	 s23ylD/5l+QrenojND+ZqUHqEYz9XbI832ImILlzmMuYl4C98AqcdCBojnw+alGaLq
	 kgvFikC2spwdd/YXhBavtddLZEwrypLO/ZG6CHD4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Gregory CLEMENT <gregory.clement@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1336/2214] ARM: dts: armada-385-clearfog-gtr: fix vmmc property name
Date: Wed, 18 Nov 2026 15:50:12 +0100
Message-ID: <20261118150104.867525104@linuxfoundation.org>
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

[ Upstream commit 337d10963f601d5a3dfb4b7aa273ca8c0b4d5172 ]

The SDHCI node references the 3.3V regulator through a bare "vmmc"
property, which is not part of the mmc controller DT binding; the
correct property is "vmmc-supply".

Fixes: aecc313490ae ("ARM: dts: mvebu: add support for SolidRun Clearfog GTR")
Assisted-by: opencode:big-pickle
Signed-off-by: Rosen Penev <rosenp@gmail.com>
Signed-off-by: Gregory CLEMENT <gregory.clement@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/armada-385-clearfog-gtr.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/armada-385-clearfog-gtr.dtsi b/arch/arm/boot/dts/armada-385-clearfog-gtr.dtsi
index 624bbcae68c09..b64645b0aea60 100644
--- a/arch/arm/boot/dts/armada-385-clearfog-gtr.dtsi
+++ b/arch/arm/boot/dts/armada-385-clearfog-gtr.dtsi
@@ -202,7 +202,7 @@ sdhci@d8000 {
 				pinctrl-0 = <&cf_gtr_sdhci_pins>;
 				pinctrl-names = "default";
 				status = "okay";
-				vmmc = <&reg_3p3v>;
+				vmmc-supply = <&reg_3p3v>;
 				wp-inverted;
 			};
 
-- 
2.53.0



