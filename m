Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015243;
	b=0rUFNAl86yhTbDNpW2nKkODFg0Acqxn9x7WyLHOPSuvLRnTbe737NVYS43+QhQWGuy6T
	 l2J7FE0qSivEAQZRH2TDYZcgPdFtyhjgU5c/UI/wcBqYo1w0s2qenT/RH/COaQ4LttgpQ
	 dQs9q4YyJVlDiufKbS9yzccMvJE2eks+fCpiNUmYgwpn2zT4g9AQpLqAms1g3nTkX79np
	 8mWMQ2Eg+cCHSxKhnejB1t9sbjfnXLhttRCj5SfD5NWuoWrWXSuEEeVqBqZvLqZa6CQ5y
	 XGzt1WWEIOUJN0FcdWUOVmRdj1OwLHF+ES4S6u4PXIN6ombeUEopRmMzGYgIxSwHI3w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015243;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6+UKCK7d5R5J3kjdvg2kZep8SpnPtR4jZRk4qx+ogEc=;
	b=KeUNNfQhr6cxCFeR82XSp3FYJASTPThlwfkIHjVxBTMe0zBJ6JaXdo5W0MIBnuChap7y
	 daEC/IakI291nu9Bg8mBSdF943yReXVy0QbwVI2hqbMGHE3IgPBb/gwL5MmBXZvkhInFU
	 cLwxp0XNqU3zRlsGrEtlWYCIw1Y7BdCkXQCXqJWXTyByr9FqfJyZDGtTBARih5M0dCTIF
	 sgcnsDr50Jvgv7p4T2j6HEQAlclN7ivv2osMc/Qcai2t88mgpEcKKS21T9Z1a7fWmA4qe
	 cOeasZA3yKXhMgjsC7Yo+xngo81s7lYkhim8vg4RxtqT+1jtCvAU+2PqaNTZuETc73g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xRVRzd3U;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B270B60A2613;
	Wed, 18 Nov 2026 15:20:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xRVRzd3U
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D00BA1F000C7;
	Wed, 18 Nov 2026 15:20:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015243;
	bh=6+UKCK7d5R5J3kjdvg2kZep8SpnPtR4jZRk4qx+ogEc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xRVRzd3Uzylk6OMWOqEQ0JQz9VAGjb0moevsEnpb/KWqAksY1lhzd8Fd9eEXzIGL2
	 FLNM/UbWRHqvoHipBn2uN8kF7lDPz1Vw6LaK6HWsB+y7akkTbO1sEVZB6rSA+Wl/Ei
	 Y9uk+/1axgB7vskkl96EghW5/G44ndj7qeVfiCwA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Gregory CLEMENT <gregory.clement@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0103/2651] ARM: dts: helios4: fix vbus-supply for USB2 PHY
Date: Wed, 18 Nov 2026 15:22:23 +0100
Message-ID: <20261118150251.597157227@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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



