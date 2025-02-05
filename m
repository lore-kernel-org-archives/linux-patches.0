Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 745AA1FECDE;
	Wed,  5 Feb 2025 14:50:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738767046; cv=none; b=L9xNP0cZxaG0gnqZJ/i6oMkr0uecNqrERhKbvjddVNkSSx65RwfYGXSEufC/G/tI79bmpdsvtGOflSLopQCk+c3YZCIU8/HHxxnv7UbZVyfMo+JsYYX4PjnLb74eFwl2m/IBoBOeOZCN+J3j/dDLNyzru1nFD6iYDcHh8QUyGH0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738767046; c=relaxed/simple;
	bh=GqCh1+SoWDwJJ7JckmdnqjTefvBXQxo8sdbl9KxSAKM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JmnxlzDUGnRkN+ne7dmzOgZw/x9ujLql/YI62NpP6vfHTIhcwBS6hE1slGAoyfdFDz1G+3F1jVYx5GZ6xwjr9nQDDokdxdP6YumtrQxiJsZM/q24M33ZP4TOGRnUWZBtck0bBOXjOqE1DjCWkdaoWIhF05MBvq5cZXu9Rw8QZkg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L+JVL31I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L+JVL31I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF3B4C4CED1;
	Wed,  5 Feb 2025 14:50:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738767046;
	bh=GqCh1+SoWDwJJ7JckmdnqjTefvBXQxo8sdbl9KxSAKM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L+JVL31ImS7E9GKPCJA1BWwzI+nYY+zN9r5K8f40VMZp8HyQD1+Siffo98YwfsmDc
	 bIq6vZ8TBrBPe4DwILmlJrMnch3PPznTBSNtbj0aFgeTTgfTxXuk/GjJO11yzeGXGg
	 v4+AxLD4Fdf+/Upk1DDyppq1l3NWw+MS4DBESMGw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen-Yu Tsai <wenst@chromium.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 349/623] arm64: dts: mediatek: mt8195-demo: Drop regulator-compatible property
Date: Wed,  5 Feb 2025 14:41:31 +0100
Message-ID: <20250205134509.577495773@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

From: Chen-Yu Tsai <wenst@chromium.org>

[ Upstream commit 2a8af9b95f504260a6d8200a11f0ae5c90e9f787 ]

The "regulator-compatible" property has been deprecated since 2012 in
commit 13511def87b9 ("regulator: deprecate regulator-compatible DT
property"), which is so old it's not even mentioned in the converted
regulator bindings YAML file. It is also not listed in the MT6360
regulator and charger bindings.

Drop the "regulator-compatible" property from the board dts. The MT6360
bindings actually require the lowercase name, so with the property
present the regulators were likely not actually working.

Fixes: 6147314aeedc ("arm64: dts: mediatek: Add device-tree for MT8195 Demo board")
Signed-off-by: Chen-Yu Tsai <wenst@chromium.org>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://lore.kernel.org/r/20241211052427.4178367-7-wenst@chromium.org
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/mediatek/mt8195-demo.dts | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/arch/arm64/boot/dts/mediatek/mt8195-demo.dts b/arch/arm64/boot/dts/mediatek/mt8195-demo.dts
index 31d424b8fc7ce..bfb75296795c3 100644
--- a/arch/arm64/boot/dts/mediatek/mt8195-demo.dts
+++ b/arch/arm64/boot/dts/mediatek/mt8195-demo.dts
@@ -137,7 +137,6 @@
 			richtek,vinovp-microvolt = <14500000>;
 
 			otg_vbus_regulator: usb-otg-vbus-regulator {
-				regulator-compatible = "usb-otg-vbus";
 				regulator-name = "usb-otg-vbus";
 				regulator-min-microvolt = <4425000>;
 				regulator-max-microvolt = <5825000>;
@@ -149,7 +148,6 @@
 			LDO_VIN3-supply = <&mt6360_buck2>;
 
 			mt6360_buck1: buck1 {
-				regulator-compatible = "BUCK1";
 				regulator-name = "mt6360,buck1";
 				regulator-min-microvolt = <300000>;
 				regulator-max-microvolt = <1300000>;
@@ -160,7 +158,6 @@
 			};
 
 			mt6360_buck2: buck2 {
-				regulator-compatible = "BUCK2";
 				regulator-name = "mt6360,buck2";
 				regulator-min-microvolt = <300000>;
 				regulator-max-microvolt = <1300000>;
@@ -171,7 +168,6 @@
 			};
 
 			mt6360_ldo1: ldo1 {
-				regulator-compatible = "LDO1";
 				regulator-name = "mt6360,ldo1";
 				regulator-min-microvolt = <1200000>;
 				regulator-max-microvolt = <3600000>;
@@ -180,7 +176,6 @@
 			};
 
 			mt6360_ldo2: ldo2 {
-				regulator-compatible = "LDO2";
 				regulator-name = "mt6360,ldo2";
 				regulator-min-microvolt = <1200000>;
 				regulator-max-microvolt = <3600000>;
@@ -189,7 +184,6 @@
 			};
 
 			mt6360_ldo3: ldo3 {
-				regulator-compatible = "LDO3";
 				regulator-name = "mt6360,ldo3";
 				regulator-min-microvolt = <1200000>;
 				regulator-max-microvolt = <3600000>;
@@ -198,7 +192,6 @@
 			};
 
 			mt6360_ldo5: ldo5 {
-				regulator-compatible = "LDO5";
 				regulator-name = "mt6360,ldo5";
 				regulator-min-microvolt = <2700000>;
 				regulator-max-microvolt = <3600000>;
@@ -207,7 +200,6 @@
 			};
 
 			mt6360_ldo6: ldo6 {
-				regulator-compatible = "LDO6";
 				regulator-name = "mt6360,ldo6";
 				regulator-min-microvolt = <500000>;
 				regulator-max-microvolt = <2100000>;
@@ -216,7 +208,6 @@
 			};
 
 			mt6360_ldo7: ldo7 {
-				regulator-compatible = "LDO7";
 				regulator-name = "mt6360,ldo7";
 				regulator-min-microvolt = <500000>;
 				regulator-max-microvolt = <2100000>;
-- 
2.39.5



