Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023535;
	b=w6dWxkbp/ZltlF9Wbfp8XJqeES+GZN2lqNhHuOjLPiizSE1w+ci38kL3AIc7vDb7DacD
	 Ccyhqqgg124xb1gYd3Ms8iPl2t0WNqleI2Ef+2njqmaAr+j80JKlvl+YLouFARpwD8EoW
	 XVgl0FXfOk6x8GrCPA/A1JlSCB7nr/Rlo8HxCLpQlbPpFhGJPWHl52l4dUrfRV5bmhe+T
	 dywI+i99w01f3BQfS2Ry/57G4y1djgD68pqxCMr+ppmdMHOSJWxCssdDF8RIPtttQrIB1
	 i0b3ma+FTWp2+CWiba1Nwl5KeR8DjsD8WTOIoEl2corGMn6n79AWmpn5Nyf0zpHTTWw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023535;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZOMuMOeua56e/5gM/It9k3xu2GXPz+kzy84aoON2cig=;
	b=w2a4OS+9pNZcnvJbxV6WIQpvePI+WJACD4x8/Scd085e7c9Cs14A2Lb3+apJkRiaCZeU
	 jKAKYPbZXKgURRQCURnyPGO3iqSQWwrt4D9BtUHiquOvFyTOIxz7k0TZM5URxwJqExyLH
	 ISWuX3qjTzrm/+CIulNi8S2Lr90kj/4b2MxLE81t0VSTw9dSygktAtrcRmxzjn6PdBEUw
	 YjZStmKPAlgvlO6EALpHc20akpPwInSvTRvulBrk9eeZ3/GiX9apCZ23CNnshxH0SNmwb
	 PB4xM7subblOPDK1sIAYY41VI3P4w0LeOzBUTDjSBk7/85QugFrviMFke06OtAVlsQA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sWrs7bLZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59C49606A332;
	Wed, 18 Nov 2026 17:38:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sWrs7bLZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96D5F1F000C4;
	Wed, 18 Nov 2026 17:38:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023535;
	bh=ZOMuMOeua56e/5gM/It9k3xu2GXPz+kzy84aoON2cig=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sWrs7bLZknhon8gymWSh/ihWb/U2Oh6o5SRDQLapNGLkpsC0f5avv+b6YmibidhDk
	 JBiwv1G371fhHPKB2I5Sjq4GcGCAttzuMEAyl7jn6VlIfGRy/Wre5N4Wck4r2D7X1F
	 R+yRsVE095x9fl7/bl9Onjsy/Bxy1nJXqLyp4Imk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Vasut <marex@nabladev.com>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0404/2151] ARM: dts: stm32: Drop bias-disable from STM32MP15xx DHCOM SoM sdmmc1_b4_pins_a
Date: Wed, 18 Nov 2026 15:35:39 +0100
Message-ID: <20261118150136.778570793@linuxfoundation.org>
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

From: Marek Vasut <marex@nabladev.com>

[ Upstream commit 3572825773791f4258b553391f4e2187df321731 ]

Drop bias-disable property from STM32MP15xx DHCOM SoM sdmmc1_b4_pins_a
to fix the following DT checker warning. The bias-pull-up property is
the only bias-related property that has to be present in those pinctrl
node subnodes.

"
arch/arm/boot/dts/st/stm32mp153c-dhcom-drc02.dtb: pinctrl@50002000 (st,stm32mp157-pinctrl): sdmmc1-b4-0:pins1: {'pinmux': [10253, 10509, 10765, 11021, 12813], 'slew-rate': 1, 'drive-push-pull': True, 'bias-disable': True, 'bias-pull-up': True} is valid under each of {'required': ['bias-pull-up']}, {'required': ['bias-disable']}
"

Fixes: 7cd8567d988a ("ARM: dts: stm32: Enable internal pull-ups for SDMMC1 on DHCOM SoM")
Signed-off-by: Marek Vasut <marex@nabladev.com>
Link: https://lore.kernel.org/r/20260828150111.173089-1-marex@nabladev.com
Signed-off-by: Alexandre Torgue <alexandre.torgue@foss.st.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/st/stm32mp15xx-dhcom-som.dtsi | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm/boot/dts/st/stm32mp15xx-dhcom-som.dtsi b/arch/arm/boot/dts/st/stm32mp15xx-dhcom-som.dtsi
index 4cc633683c6b7..0a4263e6209d8 100644
--- a/arch/arm/boot/dts/st/stm32mp15xx-dhcom-som.dtsi
+++ b/arch/arm/boot/dts/st/stm32mp15xx-dhcom-som.dtsi
@@ -505,9 +505,11 @@ &sdmmc1_b4_pins_a {
 	 * - mandatory on SoMs without SD voltage translator
 	 */
 	pins1 {
+		/delete-property/ bias-disable;
 		bias-pull-up;
 	};
 	pins2 {
+		/delete-property/ bias-disable;
 		bias-pull-up;
 	};
 };
-- 
2.53.0



