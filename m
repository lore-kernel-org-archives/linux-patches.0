Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC7142571C3;
	Mon, 24 Feb 2025 14:56:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740408992; cv=none; b=PR8VGljxF8q2O/Am+yf2K8d/LMDfdOSEpMvN6Pd5Tx7ABJhx3fXj2Y9h/atUrBhgs7YcN8d0dk+KjxOOyg4q2H7OKRpdisUN58LfHW21D66HKGs06hZQgf9fvsmcsNf5eoqxoViKLh+E/4F4mJDoqOxP4evgpxD4XTkoS9x9BOA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740408992; c=relaxed/simple;
	bh=a+RiTtWwAKAGysSKXz5XLve0kA8FO1383OQcAgqFHVo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SrMzoiFiYk9SCDxWkj3NBUVLImtlSIfQxsYfz0ZGGoVWBoQQAoqABEIG8Gy6JwAjRuYyhwFyHAP0FS8S4eJjNahfe29rNCRDoFldNB8gkd9IbiJefHdic9+GLLokNGmhQVBaSUseERJ1YIIwM5OSR9LVe4WDNRDsB8u235rc1wc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LMVlsv8B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LMVlsv8B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 325CEC4CED6;
	Mon, 24 Feb 2025 14:56:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740408992;
	bh=a+RiTtWwAKAGysSKXz5XLve0kA8FO1383OQcAgqFHVo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LMVlsv8B1gOUjQ0Hf60GY5zp+JkIuKzNcRk1xAelONm17g/2CH1t8Dkc78dGAKJVU
	 uugHilGRfiyraMmN3XZqTLZFbyIldvMJlBB+PD9PQ3FKxMAmZiOBua7/u2GmAwJnZc
	 TzBhAYuH3o2+MFaGTqwn8PiyTE07hGc7SHyC+cv0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Yan <andyshrk@163.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 058/138] arm64: dts: rockchip: Fix lcdpwr_en pin for Cool Pi GenBook
Date: Mon, 24 Feb 2025 15:34:48 +0100
Message-ID: <20250224142606.761103697@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224142604.442289573@linuxfoundation.org>
References: <20250224142604.442289573@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Yan <andyshrk@163.com>

[ Upstream commit a1d939055a22be06d8c12bf53afb258b9d38575f ]

According to the schematic, the lcdpwr_en pin is GPIO0_C4,
not GPIO1_C4.

Fixes: 4a8c1161b843 ("arm64: dts: rockchip: Add support for rk3588 based Cool Pi CM5 GenBook")
Signed-off-by: Andy Yan <andyshrk@163.com>
Link: https://lore.kernel.org/r/20250113104825.2390427-1-andyshrk@163.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3588-coolpi-cm5-genbook.dts | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3588-coolpi-cm5-genbook.dts b/arch/arm64/boot/dts/rockchip/rk3588-coolpi-cm5-genbook.dts
index 92f0ed83c9902..bc6b43a771537 100644
--- a/arch/arm64/boot/dts/rockchip/rk3588-coolpi-cm5-genbook.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3588-coolpi-cm5-genbook.dts
@@ -113,7 +113,7 @@ vcc3v3_lcd: regulator-vcc3v3-lcd {
 		compatible = "regulator-fixed";
 		regulator-name = "vcc3v3_lcd";
 		enable-active-high;
-		gpio = <&gpio1 RK_PC4 GPIO_ACTIVE_HIGH>;
+		gpio = <&gpio0 RK_PC4 GPIO_ACTIVE_HIGH>;
 		pinctrl-names = "default";
 		pinctrl-0 = <&lcdpwr_en>;
 		vin-supply = <&vcc3v3_sys>;
@@ -241,7 +241,7 @@ &pcie3x4 {
 &pinctrl {
 	lcd {
 		lcdpwr_en: lcdpwr-en {
-			rockchip,pins = <1 RK_PC4 RK_FUNC_GPIO &pcfg_pull_down>;
+			rockchip,pins = <0 RK_PC4 RK_FUNC_GPIO &pcfg_pull_down>;
 		};
 
 		bl_en: bl-en {
-- 
2.39.5



