Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C26EA19EEBD;
	Thu, 15 Aug 2024 13:42:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723729338; cv=none; b=e6zVKCf1d9f8vxblsVxXuSdIIfarVZUdUuzjP1Hrb8ypIa8iYyBKzPn6ePq3bXQnko/16mCowjIqaXY/Tn9ANF2cTTmb9i1hF8VRtF6KZXVVxUhOi7f1dVuCkqOUBeuonNu5m1LDnVVqsyz0uQKx8JWfj6UuONR+j65X5OALcgw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723729338; c=relaxed/simple;
	bh=9pVmLXbH0UtW9Hy8XGWRgg6Zz4GdqbujgffF3maFvk4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=edwzmAtoiBsURrVjj21ttMpWgc1GtUOQad5pTsRn1W7QF7BnfnuXfqFTK7ZKgP8PUH+EH6FqP0ePQWy75EzxqKahtKWVHGtRf6CMgcTiiORS+hlNQ+A63Nu7oLv9xKYJKeDd7fj00qf3PAliAnevWsXFQLkVj9+nRJhbQrWNK2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r4b4Yczj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r4b4Yczj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6CCFC32786;
	Thu, 15 Aug 2024 13:42:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723729338;
	bh=9pVmLXbH0UtW9Hy8XGWRgg6Zz4GdqbujgffF3maFvk4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r4b4YczjkQZyTI+K1axzq1iv32U/iE0zrLXWqJqoYRhprSNYnrxFMAgeuqsL+noA3
	 +5bo/pbkyaZL0cXMuNmBfIfFZRX0QqWLjrA70+MDDiZpzkjZ1Gp8rwfx2lMfFTCBfc
	 oeBHkUfiMbF17U1qn7cERVBnHXMZXyUwslNitkrg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jerome Brunet <jbrunet@baylibre.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 035/484] arm64: dts: amlogic: gx: correct hdmi clocks
Date: Thu, 15 Aug 2024 15:18:13 +0200
Message-ID: <20240815131942.631094863@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



