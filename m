Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FEC21AC8AE;
	Thu, 15 Aug 2024 14:11:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723731102; cv=none; b=RSKNPgB4ACCa9Cm4KVSbN6IAUX/DJDtPTyknUVeuUc+QX1pd/xrZGukYruD5VoRoCRxR3OsnFKeZkUHG72ugSp9AobCnR0fSd8uzJ0loUjb91ZbulPmut+UphGQR4aPViIcY8FmjqndQJAcWxmW43zdQYjtkB1dBkFY8SHqpvFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723731102; c=relaxed/simple;
	bh=+A6HNYE4mP174co2MKTPXxaDV4lAYCwfwOQN0GONfEo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tGHBHt5QECKvAFz4TLm8gzsylgl7hFlrmQyUGjIf8FDuNP3Y3lX6UrBpY9aw5b9o2KJKakjScKsTvUAxCUoQGvkYi3qHQl11RtVovAbntbNpkRo5rYEo2WU+TvhtsGQAPhdYRjXoAqW7RPeo+ptA6AX+30/QLoDYCf9DtH1qFaw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0dIz/Ok0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0dIz/Ok0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A9D4C32786;
	Thu, 15 Aug 2024 14:11:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723731101;
	bh=+A6HNYE4mP174co2MKTPXxaDV4lAYCwfwOQN0GONfEo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0dIz/Ok0z/BsE/+8eiZY48/G79QC1lhKDyVd5SehA8Bk/d/BmtNSc873GSYyG28Pp
	 ABYSpSKuaLh57M0piiyk1VAzvyMKVZxl7w+clApS64DQ0enCKVuqt4jw1zifXxAhyF
	 pU9X7DwPtDb4HSA5mtGrJsd25kpRk4BpClMr+ndo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jerome Brunet <jbrunet@baylibre.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 023/259] arm64: dts: amlogic: gx: correct hdmi clocks
Date: Thu, 15 Aug 2024 15:22:36 +0200
Message-ID: <20240815131903.693509085@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131902.779125794@linuxfoundation.org>
References: <20240815131902.779125794@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 0cb40326b0d3f..e54473f98b022 100644
--- a/arch/arm64/boot/dts/amlogic/meson-gxbb.dtsi
+++ b/arch/arm64/boot/dts/amlogic/meson-gxbb.dtsi
@@ -326,8 +326,8 @@ &hdmi_tx {
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
index 6809f495a5030..308db3bc417b9 100644
--- a/arch/arm64/boot/dts/amlogic/meson-gxl.dtsi
+++ b/arch/arm64/boot/dts/amlogic/meson-gxl.dtsi
@@ -273,8 +273,8 @@ &hdmi_tx {
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



