Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD1C93AC00;
	Wed, 20 May 2026 16:47:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295648; cv=none; b=tNzD41s6g0t7wxOkSALJCm9fEMb98O9+7XhS94y3F3BofAhkPG4QXafjfFYyUEw6USoMJtfpCDxnKbY/hLJbHwlBOlgHswEpD3CjPcID7dYJarD1dGn++vbjOqbdLTWmQekMQjQyBxV2JGYy6CROMhoDHbQf21AyrV06SUokwYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295648; c=relaxed/simple;
	bh=QpBJy3agHhM/YTswXpcACZXsDfIOJwGEENIgMIV758c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l/epLstv/+aB5uq/F2tWM2DqAsZBdkiHHoY/gphZ7s1bRTNWM/GoJJhyTnYjFhsauNgYwauE71OjwdRAwBWgefBz5SIrsPYqQgRYV8RmULmmJIp1iQEYzLeqTP8Jo7oDOHrFWvEdW03xSmxAoHbc+nPh+lDOZop65FxhA5biHEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1/0qgaj1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1/0qgaj1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F5071F000E9;
	Wed, 20 May 2026 16:47:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295647;
	bh=KwHCK8eDQmicvzGEua83gnyRhow6/x5ID2vlFbRiZoc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1/0qgaj1VjisirW41hTRnPOD2jVwt9o01hm26smx1MNtWHUqwBKahBe99sBmShOPh
	 4HSrGIdFGXsNRxGNGOUXnewU2ejnusg5NXlfzjAEG+wJK9ELjOAuaiQLylFLlUJI8i
	 vMJ2OZhGyY9asy1KVP6NVfJbxh6qMGNsflMUFAHQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Hewitt <christianshewitt@gmail.com>,
	Alex Bee <knaerzche@gmail.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0499/1146] Revert "arm64: dts: rockchip: add SPDIF audio to Beelink A1"
Date: Wed, 20 May 2026 18:12:29 +0200
Message-ID: <20260520162159.484682753@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Robin Murphy <robin.murphy@arm.com>

[ Upstream commit 03978cb18059ecd27e3d955508b18cf2a1196142 ]

This reverts commit bdc4d388c6452498ab62ef2564589f40e0c8c262.

While Beelink A1 mostly follows the high-end RK3328 reference design,
it does not in fact have the S/PDIF connector, only HDMI and a 3.5mm
jack for the analog audio/TV codecs - the tiny form factor literally
doesn't have room to fit more!

Cc: Christian Hewitt <christianshewitt@gmail.com>
Cc: Alex Bee <knaerzche@gmail.com>
Fixes: bdc4d388c645 ("arm64: dts: rockchip: add SPDIF audio to Beelink A1")
Signed-off-by: Robin Murphy <robin.murphy@arm.com>
Link: https://patch.msgid.link/0af77a02c2b0806d4ca72066392a5453fcc89a8f.1767111968.git.robin.murphy@arm.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3328-a1.dts | 23 ----------------------
 1 file changed, 23 deletions(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3328-a1.dts b/arch/arm64/boot/dts/rockchip/rk3328-a1.dts
index 30bdb38f0727a..e810ed146451c 100644
--- a/arch/arm64/boot/dts/rockchip/rk3328-a1.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3328-a1.dts
@@ -58,24 +58,6 @@ ir-receiver {
 		gpios = <&gpio2 RK_PA2 GPIO_ACTIVE_LOW>;
 		linux,rc-map-name = "rc-beelink-gs1";
 	};
-
-	spdif_dit: spdif-dit {
-		compatible = "linux,spdif-dit";
-		#sound-dai-cells = <0>;
-	};
-
-	spdif_sound: spdif-sound {
-		compatible = "simple-audio-card";
-		simple-audio-card,name = "SPDIF";
-
-		simple-audio-card,cpu {
-			sound-dai = <&spdif>;
-		};
-
-		simple-audio-card,codec {
-			sound-dai = <&spdif_dit>;
-		};
-	};
 };
 
 &analog_sound {
@@ -343,11 +325,6 @@ &sdmmc {
 	status = "okay";
 };
 
-&spdif {
-	pinctrl-0 = <&spdifm0_tx>;
-	status = "okay";
-};
-
 &tsadc {
 	rockchip,hw-tshut-mode = <0>;
 	rockchip,hw-tshut-polarity = <0>;
-- 
2.53.0



