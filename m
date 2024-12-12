Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C235A229678;
	Thu, 12 Dec 2024 16:46:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734021988; cv=none; b=Cg/v5R45m1mzFzFdK9hFC29qmZgp2//7do39dKYbedXo7zGvkLcLW/6EB9I06s5vkaGjDfPfzCOQQu3q5fkD5SieEHR4BasbM2Z6xRW2hQika2RUOxp2osaMztx6YTu4TO4gKHvcNFhtCyCjavuPv485LhhTNgbmVY43fLqdAao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734021988; c=relaxed/simple;
	bh=em301b9uhZGaIC9F7AMsLwWwziqOyL1DmjYuXEwijNE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OKZS9lRLpiemz24CVqOEl5rhpHfyK0WW6lsBb/e+kF9jlgx81/diVGXet/JEG+lHS1oUiI2njX1KGQnNfGDs6g7E1DY9BVC/mjyqu1ZiAsvtvpk0z3ggmdktQ1PPj07PBWI+1nqJasclnNldpJkDBUaGnKxhrO/kAjxMWiXTDvw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1R1Yiuq2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1R1Yiuq2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 180FCC4CECE;
	Thu, 12 Dec 2024 16:46:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734021988;
	bh=em301b9uhZGaIC9F7AMsLwWwziqOyL1DmjYuXEwijNE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1R1Yiuq2NYPTCxmuOiPpoAkX3HTGOik75xoJJ0BGvPzj0fSOwwjRpSTnPKtmHUsgU
	 wG1Ipjar4k+I9Rj7ohG6LB9xNWXa7NxHEB5aic/Dl1yTbthYLCsWXVzl03hqgPGcfp
	 6E7/IyWvm8sqcfNV2sljdoJSS8P/3qA48kR2zYaM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hsin-Te Yuan <yuanhsinte@chromium.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 116/565] arm64: dts: mt8183: krane: Fix the address of eeprom at i2c4
Date: Thu, 12 Dec 2024 15:55:11 +0100
Message-ID: <20241212144316.070339922@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
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

From: Hsin-Te Yuan <yuanhsinte@chromium.org>

[ Upstream commit e9c60c34948662b5d47573490ee538439b29e462 ]

The address of eeprom should be 50.

Fixes: cd894e274b74 ("arm64: dts: mt8183: Add krane-sku176 board")
Signed-off-by: Hsin-Te Yuan <yuanhsinte@chromium.org>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Reviewed-by: Matthias Brugger <matthias.bgg@gmail.com>
Link: https://lore.kernel.org/r/20240909-eeprom-v1-1-1ed2bc5064f4@chromium.org
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/mediatek/mt8183-kukui-krane.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/mediatek/mt8183-kukui-krane.dtsi b/arch/arm64/boot/dts/mediatek/mt8183-kukui-krane.dtsi
index be0ac786bcbc9..ed05212ab7f89 100644
--- a/arch/arm64/boot/dts/mediatek/mt8183-kukui-krane.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt8183-kukui-krane.dtsi
@@ -88,9 +88,9 @@ &i2c4 {
 	clock-frequency = <400000>;
 	vbus-supply = <&mt6358_vcn18_reg>;
 
-	eeprom@54 {
+	eeprom@50 {
 		compatible = "atmel,24c32";
-		reg = <0x54>;
+		reg = <0x50>;
 		pagesize = <32>;
 		vcc-supply = <&mt6358_vcn18_reg>;
 	};
-- 
2.43.0



