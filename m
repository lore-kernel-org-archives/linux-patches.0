Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86D091A705B;
	Thu, 15 Aug 2024 14:25:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723731946; cv=none; b=eFj6rF9z5Ir3zyOjRkbDEzzFAqFc/y/5m1aqnHKfh3RFVDu8addjYxRBQwTQ5mJhXizMuX83Zb4ZFHEFlAipnR9tTe5GFitm+ysH41gbdcP38OzHNmk/5rHjTXPU/EQf96GcZ3sylkLR0KTlyHM8IFT/BgB0Pf3lS3XvvE3EtiE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723731946; c=relaxed/simple;
	bh=sG6K4RK1YOkmAMLR08nUnu6sv0LnLnJncmIwDkoC13w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BeBBrqgBTAwzv6OZDhYJVeUNG9xlWfwCrHmf0FuosxQTYqQcvqUZbHlt4d6LvJ8FpC6zMP18zzBxI+ikbpQzN0V3iiSU6l0Ta2RK49XV4Npww3TJ/njo+zGkQVfa3nU+yITR59eacfqQiExtJBh5fAUowKZ4HaeUZEVoulPgtis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UmUIPe9C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UmUIPe9C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95457C32786;
	Thu, 15 Aug 2024 14:25:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723731946;
	bh=sG6K4RK1YOkmAMLR08nUnu6sv0LnLnJncmIwDkoC13w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UmUIPe9CsKpkf1oRUxoJxdXLq5LPEiza+GDEE1DOQeANx0T4wuEyIDrh0Kvff5Ygu
	 onSSzuzH1BsesvijJvMcnbvKHZU3/I5IMEWU/fZzHh0+/qAQf4Xc9NavqSXo62yvuf
	 FR03mcmkRCII/izv6+2hrU8+Sw4dMIT+IqJBPxMk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jerome Brunet <jbrunet@baylibre.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 027/352] arm64: dts: amlogic: gx: correct hdmi clocks
Date: Thu, 15 Aug 2024 15:21:33 +0200
Message-ID: <20240815131920.270007255@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131919.196120297@linuxfoundation.org>
References: <20240815131919.196120297@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jerome Brunet <jbrunet@baylibre.com>

[ Upstream commit 0602ba0dcd0e76067a0b7543e92b2de3fb231073 ]

The clocks provided to HDMI tx are not consistent between gx and g12:
* gx receives the peripheral clock as 'isfr' while g12 receives it as
  'iahb'
* g12 gets the HDMI system clock as 'isfr' but gx does not even get it.
  It surely needs that clock since the driver is directly poking around
  the clock controller's registers for that clock.

Align gx SoCs with g12 and provide:
 * the HDMI peripheral clock as 'iahb'
 * the HDMI system clock as 'isfr'

Fixes: 6939db7e0dbf ("ARM64: dts: meson-gx: Add support for HDMI output")
Signed-off-by: Jerome Brunet <jbrunet@baylibre.com>
Link: https://lore.kernel.org/r/20240626152733.1350376-2-jbrunet@baylibre.com
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/amlogic/meson-gxbb.dtsi | 4 ++--
 arch/arm64/boot/dts/amlogic/meson-gxl.dtsi  | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/boot/dts/amlogic/meson-gxbb.dtsi b/arch/arm64/boot/dts/amlogic/meson-gxbb.dtsi
index 7c029f552a23b..256c46771db78 100644
--- a/arch/arm64/boot/dts/amlogic/meson-gxbb.dtsi
+++ b/arch/arm64/boot/dts/amlogic/meson-gxbb.dtsi
@@ -311,8 +311,8 @@ &hdmi_tx {
 		 <&reset RESET_HDMI_SYSTEM_RESET>,
 		 <&reset RESET_HDMI_TX>;
 	reset-names = "hdmitx_apb", "hdmitx", "hdmitx_phy";
-	clocks = <&clkc CLKID_HDMI_PCLK>,
-		 <&clkc CLKID_CLK81>,
+	clocks = <&clkc CLKID_HDMI>,
+		 <&clkc CLKID_HDMI_PCLK>,
 		 <&clkc CLKID_GCLK_VENCI_INT0>;
 	clock-names = "isfr", "iahb", "venci";
 };
diff --git a/arch/arm64/boot/dts/amlogic/meson-gxl.dtsi b/arch/arm64/boot/dts/amlogic/meson-gxl.dtsi
index 3500229350522..a689bd14ece99 100644
--- a/arch/arm64/boot/dts/amlogic/meson-gxl.dtsi
+++ b/arch/arm64/boot/dts/amlogic/meson-gxl.dtsi
@@ -323,8 +323,8 @@ &hdmi_tx {
 		 <&reset RESET_HDMI_SYSTEM_RESET>,
 		 <&reset RESET_HDMI_TX>;
 	reset-names = "hdmitx_apb", "hdmitx", "hdmitx_phy";
-	clocks = <&clkc CLKID_HDMI_PCLK>,
-		 <&clkc CLKID_CLK81>,
+	clocks = <&clkc CLKID_HDMI>,
+		 <&clkc CLKID_HDMI_PCLK>,
 		 <&clkc CLKID_GCLK_VENCI_INT0>;
 	clock-names = "isfr", "iahb", "venci";
 };
-- 
2.43.0



