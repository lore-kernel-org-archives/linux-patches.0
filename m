Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015229;
	b=cbLSxlSvzqrYddix9Bwv5fwlNVMRLKJyGeFyzTGeaMuettIJCdEclZm+QBJgLatNpKho
	 8wO5x6Nv00OUv5nh2fgf8m1jYmFEm+KYwwkkBMBRF+pQEf3Qu+lbXjd0+OPX74uHfscx0
	 UKfDd0RfwgREWJkr9INb06mFJi+Hgj0+v8Iv0HOkHGsvVYoM57UC7xCfgd+1oe+1GmRYf
	 u+2z+R1mKDU3fYKxMNgCWzVWW1yInviX3b/htE/lV9ZvxqpIpv0+BQOIPGJIVTAxY2jPv
	 AptDnMGHoSPNMlW6yPV/WsSXzbplprW7usXgWbMGX5lZ2j6zA5jBapt/zwhXGgxoxgw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015229;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=s9ZhO2L2Ft4y+BjIBgYVdQnGrrw3aQT21UvyaPI3OEc=;
	b=uGV1Sy0DZNaj8JmanYBVjhsOlRhf3soOG17llTMe+wNF66I58DtxACgga0XZeHwbTfV3
	 mHq4P5n5Dx3uh5W0RSL2tXqn3T0f3ajzhspdWJj1nB2G+O4SC8ixrdluED7jygz7pnFm/
	 PLmOQc8okLxvc68QxPOEOuzSd2MRGEIROBbqPGKZiR1Rc4RzulUGMVXOYTH08ujvnl7Ta
	 lQWW+jgE5IEvZvCnjylK1ufUmI3OFHUknOwg7ie3xSKvPxyhgcccHGV9NjVwWDB901hME
	 Dg2XP4DFMurP6D9+rnl1BKPaEd5E7anwCXRXaAnb57M5X99G9A+m1OdBfYcESi8SY9w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mHQg1sGD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B053B606A320;
	Wed, 18 Nov 2026 15:20:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mHQg1sGD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 146981F000CB;
	Wed, 18 Nov 2026 15:20:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015229;
	bh=s9ZhO2L2Ft4y+BjIBgYVdQnGrrw3aQT21UvyaPI3OEc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mHQg1sGDyXbU/O1f+pYrZwecm+8EGZLKGcdpCPBls/ikZVgvTfIr4wTeMafQKt/nH
	 QgNtMmFlLrH+w4LTBaPuxdKJhfQx0RsyBSN7Kk+pffrcfdO+bcOzWoJ2HAuKA48KQb
	 GvNhgEqbym3rzbxNt+fR0FvVZD7shRm5huF1yYOE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Gregory CLEMENT <gregory.clement@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0099/2651] ARM: dts: armada-385-clearfog-gtr: fix vmmc property name
Date: Wed, 18 Nov 2026 15:22:19 +0100
Message-ID: <20261118150251.459685967@linuxfoundation.org>
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
 arch/arm/boot/dts/marvell/armada-385-clearfog-gtr.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/marvell/armada-385-clearfog-gtr.dtsi b/arch/arm/boot/dts/marvell/armada-385-clearfog-gtr.dtsi
index 7aa71a9aa1bbc..16e9a258876ce 100644
--- a/arch/arm/boot/dts/marvell/armada-385-clearfog-gtr.dtsi
+++ b/arch/arm/boot/dts/marvell/armada-385-clearfog-gtr.dtsi
@@ -235,7 +235,7 @@ sdhci@d8000 {
 				pinctrl-0 = <&cf_gtr_sdhci_pins>;
 				pinctrl-names = "default";
 				status = "okay";
-				vmmc = <&reg_3p3v>;
+				vmmc-supply = <&reg_3p3v>;
 				wp-inverted;
 			};
 
-- 
2.53.0



