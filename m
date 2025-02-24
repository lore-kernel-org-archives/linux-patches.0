Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22A0F23371B;
	Mon, 24 Feb 2025 14:48:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740408519; cv=none; b=OV1gDsU3c1CDrpISNq4Y/dNgu9viomcFj8LnDCZOFh2KujYEONDAdH48ncaRG/XsU+OuZPwpiplMcfsXPu/DGNxX2PbAQXNC4qyI1r5gI9N3yMNxI7KRTPCAqZ5fep7Tq5SzpaTMQQtt8CzUAf4MTZhAB/GOCNxmao48wgwNods=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740408519; c=relaxed/simple;
	bh=f/obqDhn5MXGIJdewsYZYilywWkiVRfEyp77aMT+7Uk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ilBsnNBb6Vinvsd5ExYUyXganhp1BIRe2jrAM4RGWbB+PJPciu5QalojxCYy/JIbb2fx+VIDv25iLe1Kij56eZVWFS1q0ChdfMejj9kPXw/pIMoxsoZPPHYKmdVS17ZjkHblB1kdh05Gx47xShQccNnF3HcrhxPz9rZdq/7Fp24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H9P5P4an; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H9P5P4an"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78B4FC4CEE8;
	Mon, 24 Feb 2025 14:48:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740408519;
	bh=f/obqDhn5MXGIJdewsYZYilywWkiVRfEyp77aMT+7Uk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H9P5P4an4psuAqdZYU1i+q0oBRSNKDdbsx4rf5bQ2MIdvbMct7EY4kC8kY+NuAsOu
	 yWfKeEWQFsNeTKoe88+zDm01rEJPDK7Pxq3daZTZlHFqcmaec8iGoTudJVBIQdEkuf
	 9xxkRI58xlfuOHnOxx00N/XHy1Cnr1Tp9tZFCsbo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Yan <andyshrk@163.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 081/154] arm64: dts: rockchip: Fix lcdpwr_en pin for Cool Pi GenBook
Date: Mon, 24 Feb 2025 15:34:40 +0100
Message-ID: <20250224142610.249287406@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224142607.058226288@linuxfoundation.org>
References: <20250224142607.058226288@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 6418286efe40d..762d36ad733ab 100644
--- a/arch/arm64/boot/dts/rockchip/rk3588-coolpi-cm5-genbook.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3588-coolpi-cm5-genbook.dts
@@ -101,7 +101,7 @@ vcc3v3_lcd: vcc3v3-lcd-regulator {
 		compatible = "regulator-fixed";
 		regulator-name = "vcc3v3_lcd";
 		enable-active-high;
-		gpio = <&gpio1 RK_PC4 GPIO_ACTIVE_HIGH>;
+		gpio = <&gpio0 RK_PC4 GPIO_ACTIVE_HIGH>;
 		pinctrl-names = "default";
 		pinctrl-0 = <&lcdpwr_en>;
 		vin-supply = <&vcc3v3_sys>;
@@ -207,7 +207,7 @@ &pcie3x4 {
 &pinctrl {
 	lcd {
 		lcdpwr_en: lcdpwr-en {
-			rockchip,pins = <1 RK_PC4 RK_FUNC_GPIO &pcfg_pull_down>;
+			rockchip,pins = <0 RK_PC4 RK_FUNC_GPIO &pcfg_pull_down>;
 		};
 
 		bl_en: bl-en {
-- 
2.39.5



