Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054732;
	b=zb5ckq+Vl86/96H32pR489VJ4l3HFN0QcgTHmKjTA6i1TzhdNM0J/uJ/ykSl0ANNthH3
	 f0m1nszmZvjxJB2mdQS55HA8aAJ6lL7lNsqI/Djovnrp8/ZwRQ/5g8bJyn3fgCQrXUpmr
	 Ed5YzG6vEC0RRlGrSBwJHefsqNkojwAyKk2sJ+KILnugtWvPKYkEWP0ewA5+POIGpR523
	 bMeID6nCYTh1YuqnjGxyNUv3VFnoJ5MAs3/v0dGCsMJ27Jhi2lKl2TkCB3xhDI6adbnxh
	 bk/6fub7IQbfEqf8oAhl5DWLWuJnWJ5tELHu/uC98lWD8v6Na0hzqRpOJbYh3VeEupg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054732;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=aXB99oSWKXzDMMTaEOLfiP5C5D/C+hLYIvvLeFgBt/w=;
	b=ZeFxJCuTretmp5zsR4MqcOYa5DLRtugrOBOPWPi1k3DxFMBvSylERAse6CZLQ7Jor6Mu
	 0jjq2ZGAd3CZNDx9KPhPh5WP55vlRnEJQ0nomjMYjwWyHK2RTfy1XcLdNHqWT9czhpJxe
	 yqRStMqUd7yiFPG0R/F95RIAdeZgCOvPTe22P2cejpf8CC/8RzZEiYUwSnAjGKhel6y39
	 s2awhzHQf0+XMVJ/ArHS82x7n/tWcxDseOpNyDfJDL/2sIKo4YVLi5+Am+4r9BNCBk6dc
	 e09GeQbzZc2mQCWz779m6GJ86wE+1EugNp4LKag1GTeQ7T5A+xlBbNIfS3/bEgd/iew==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WJ3CFvwB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 579F8606A31C;
	Thu, 19 Nov 2026 02:18:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WJ3CFvwB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 596F51F000C4;
	Thu, 19 Nov 2026 02:18:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054731;
	bh=aXB99oSWKXzDMMTaEOLfiP5C5D/C+hLYIvvLeFgBt/w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WJ3CFvwBXss8AfZ3wuUUAAO60MV3toNXfRvqKuazLJ1HSlXvmwGcQ4Dbr7m/Dkaqo
	 vxrvXmTO2o67anLwlP7V+B3r2LqL89qb9WDdq5A/16P06hU6xMGuSL1RNsELIOZx99
	 h2TreR0cQaUmZNG/qpAK/4zbDL58KW4MoMdnBEwA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Gregory CLEMENT <gregory.clement@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1338/2214] ARM: dts: armada-388-helios4: fix vmmc property name
Date: Wed, 18 Nov 2026 15:50:14 +0100
Message-ID: <20261118150104.965884053@linuxfoundation.org>
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
 arch/arm/boot/dts/armada-388-helios4.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/armada-388-helios4.dts b/arch/arm/boot/dts/armada-388-helios4.dts
index f5ae4bea1211f..0545452a983fc 100644
--- a/arch/arm/boot/dts/armada-388-helios4.dts
+++ b/arch/arm/boot/dts/armada-388-helios4.dts
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



