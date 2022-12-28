Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1E741863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 15:07:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55C09C433D2;
	Wed, 28 Dec 2022 15:07:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672240062;
	bh=+e4kKoYMfsgLA0QIIilo188036g+bAIfSq9Ae03fcaw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qeZrcYyD01DnQ6HfCGVl/Vfvc/58/7EuxaOcNfJSuA2SSausoE+9igkBQCJSwxJgk
	 VHVW/GYWjydEvdGXOrJMg8g/nDUguJpftW3p8gt+Wo8SnYRqj9RDBf7BpFB39IcO7/
	 te/3I4dI8bTbq/ObcEVu8GkvNgIrm9HkSVDu31cQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0076/1146] arm64: dts: mediatek: pumpkin-common: Fix devicetree warnings
Date: Wed, 28 Dec 2022 15:26:55 +0100
Message-Id: <20221228144332.215175544@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>

[ Upstream commit 509438336ce75c8b4e6ce8e8d507dc77d0783bdd ]

Fix the pinctrl submodes and optee node to remove unneeded unit address,
fixing all unit_address_vs_reg warnings.

Fixes: 9983822c8cf9 ("arm64: dts: mediatek: add pumpkin board dts")
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://lore.kernel.org/r/20221013152212.416661-8-angelogioacchino.delregno@collabora.com
Signed-off-by: Matthias Brugger <matthias.bgg@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/mediatek/pumpkin-common.dtsi | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/boot/dts/mediatek/pumpkin-common.dtsi b/arch/arm64/boot/dts/mediatek/pumpkin-common.dtsi
index 8ee1529683a3..ec8dfb3d1c6d 100644
--- a/arch/arm64/boot/dts/mediatek/pumpkin-common.dtsi
+++ b/arch/arm64/boot/dts/mediatek/pumpkin-common.dtsi
@@ -17,7 +17,7 @@ chosen {
 	};
 
 	firmware {
-		optee: optee@4fd00000 {
+		optee: optee {
 			compatible = "linaro,optee-tz";
 			method = "smc";
 		};
@@ -209,7 +209,7 @@ pins_cmd_dat {
 		};
 	};
 
-	i2c0_pins_a: i2c0@0 {
+	i2c0_pins_a: i2c0 {
 		pins1 {
 			pinmux = <MT8516_PIN_58_SDA0__FUNC_SDA0_0>,
 				 <MT8516_PIN_59_SCL0__FUNC_SCL0_0>;
@@ -217,7 +217,7 @@ pins1 {
 		};
 	};
 
-	i2c2_pins_a: i2c2@0 {
+	i2c2_pins_a: i2c2 {
 		pins1 {
 			pinmux = <MT8516_PIN_60_SDA2__FUNC_SDA2_0>,
 				 <MT8516_PIN_61_SCL2__FUNC_SCL2_0>;
-- 
2.35.1



