Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D22179DC;
	Sat, 30 Dec 2023 12:01:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TTU6QRiw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF763C433C8;
	Sat, 30 Dec 2023 12:01:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1703937661;
	bh=c/4r+6lrbHVe9HnWezhy3TMzqcQIlxtRqfcYjDXPMc0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TTU6QRiwi+6A8mfa3U0EFfIiXN3Q+wCGOkBpjuJ39qMSuonAuRioitJP9eO7Zk936
	 dvM4cOaL5eUzQFh1DoqwnZW81L9sEzp11BNM2fzzlqFO2/uQo8u3Ilh2UlmGv/5zid
	 Tb/g92MI/28GAFNwEHrAC7yhLdgV05SbdKhQvMY0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chukun Pan <amadeus@jmu.edu.cn>,
	Jernej Skrabec <jernej.skrabec@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 014/156] arm64: dts: allwinner: h616: update emac for Orange Pi Zero 3
Date: Sat, 30 Dec 2023 11:57:48 +0000
Message-ID: <20231230115812.844083563@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231230115812.333117904@linuxfoundation.org>
References: <20231230115812.333117904@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chukun Pan <amadeus@jmu.edu.cn>

[ Upstream commit b9622937d95809ef89904583191571a9fa326402 ]

The current emac setting is not suitable for Orange Pi Zero 3,
move it back to Orange Pi Zero 2 DT. Also update phy mode and
delay values for emac on Orange Pi Zero 3.
With these changes, Ethernet now looks stable.

Fixes: 322bf103204b ("arm64: dts: allwinner: h616: Split Orange Pi Zero 2 DT")
Signed-off-by: Chukun Pan <amadeus@jmu.edu.cn>
Reviewed-by: Jernej Skrabec <jernej.skrabec@gmail.com>
Link: https://lore.kernel.org/r/20231029074009.7820-2-amadeus@jmu.edu.cn
Signed-off-by: Jernej Skrabec <jernej.skrabec@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/allwinner/sun50i-h616-orangepi-zero.dtsi | 3 ---
 arch/arm64/boot/dts/allwinner/sun50i-h616-orangepi-zero2.dts | 3 +++
 arch/arm64/boot/dts/allwinner/sun50i-h618-orangepi-zero3.dts | 2 ++
 3 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/boot/dts/allwinner/sun50i-h616-orangepi-zero.dtsi b/arch/arm64/boot/dts/allwinner/sun50i-h616-orangepi-zero.dtsi
index 15290e6892fca..fc7315b944065 100644
--- a/arch/arm64/boot/dts/allwinner/sun50i-h616-orangepi-zero.dtsi
+++ b/arch/arm64/boot/dts/allwinner/sun50i-h616-orangepi-zero.dtsi
@@ -68,10 +68,7 @@
 &emac0 {
 	pinctrl-names = "default";
 	pinctrl-0 = <&ext_rgmii_pins>;
-	phy-mode = "rgmii";
 	phy-handle = <&ext_rgmii_phy>;
-	allwinner,rx-delay-ps = <3100>;
-	allwinner,tx-delay-ps = <700>;
 	status = "okay";
 };
 
diff --git a/arch/arm64/boot/dts/allwinner/sun50i-h616-orangepi-zero2.dts b/arch/arm64/boot/dts/allwinner/sun50i-h616-orangepi-zero2.dts
index d83852e72f063..b5d713926a341 100644
--- a/arch/arm64/boot/dts/allwinner/sun50i-h616-orangepi-zero2.dts
+++ b/arch/arm64/boot/dts/allwinner/sun50i-h616-orangepi-zero2.dts
@@ -13,6 +13,9 @@
 };
 
 &emac0 {
+	allwinner,rx-delay-ps = <3100>;
+	allwinner,tx-delay-ps = <700>;
+	phy-mode = "rgmii";
 	phy-supply = <&reg_dcdce>;
 };
 
diff --git a/arch/arm64/boot/dts/allwinner/sun50i-h618-orangepi-zero3.dts b/arch/arm64/boot/dts/allwinner/sun50i-h618-orangepi-zero3.dts
index 00fe28caac939..b3b1b8692125f 100644
--- a/arch/arm64/boot/dts/allwinner/sun50i-h618-orangepi-zero3.dts
+++ b/arch/arm64/boot/dts/allwinner/sun50i-h618-orangepi-zero3.dts
@@ -13,6 +13,8 @@
 };
 
 &emac0 {
+	allwinner,tx-delay-ps = <700>;
+	phy-mode = "rgmii-rxid";
 	phy-supply = <&reg_dldo1>;
 };
 
-- 
2.43.0



