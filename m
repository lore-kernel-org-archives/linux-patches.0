Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2039E3081C8;
	Mon, 13 Oct 2025 15:26:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369162; cv=none; b=DCJe3x4NPI2XEyZrXqPuvR6NNhPPHl78TIzjoKNuAjh4Uev4eSq4XcaJQLA5UWfTR+1DLW+Zhi9DknJqo4lKAP0iPrBlzGPmbkhWzjdSiIF/Qfq+Ob+TpL52yi51EqZ9cWdKeyV+MBXOQc9GCuS66cytPbsmLXvKo/flgNkUB1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369162; c=relaxed/simple;
	bh=hijtLW5mTlQQIuQRni4zwA42d4D++GfD2+eiYjq2i1k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nLxZRxXhCLCPzjUEtrN5GJ1Q+gX174rl1huvIBmo/f4RG5fMQJCysPDKVp0wrRd812IIV5jOZAwz/17e20GHCVOjO8lOOgEgTiIJ1L2K2S2Umn+p5vv4HIqAq6Krj6NP/WBFyP/9xfqP84IbKJxh5yT5WrSqedO7dw6h7LAwYfM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1vgxvM28; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1vgxvM28"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E5C9C4CEFE;
	Mon, 13 Oct 2025 15:26:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369162;
	bh=hijtLW5mTlQQIuQRni4zwA42d4D++GfD2+eiYjq2i1k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1vgxvM28WxsX/c7/04I50Y7goNLJ9TSfXMpLCzmiMcQosX86naiQJ8bPk6N8LGYOj
	 ZpMUtT9lwKBL1ilXaMIKabLEJjVUaXy7UlLbHR5cFngAg8alGTdFu0MGD4F9LOUa0f
	 wmQyCOs3hWX39s9t5bBnLZSBgoPdn6MUzRZkHdgI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Fei Shao <fshao@chromium.org>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 149/563] arm64: dts: mediatek: mt8395-kontron-i1200: Fix MT6360 regulator nodes
Date: Mon, 13 Oct 2025 16:40:10 +0200
Message-ID: <20251013144416.689156121@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>

[ Upstream commit 09a1e9c973973aff26e66a5673c19442d91b9e3d ]

All of the MT6360 regulator nodes were wrong and would not probe
because the regulator names are supposed to be lower case, but
they are upper case in this devicetree.

Change all nodes to be lower case to get working regulators.

Fixes: 94aaf79a6af5 ("arm64: dts: mediatek: add Kontron 3.5"-SBC-i1200")
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Reviewed-by: Fei Shao <fshao@chromium.org>
Link: https://lore.kernel.org/r/20250724083914.61351-38-angelogioacchino.delregno@collabora.com
Signed-off-by: Matthias Brugger <matthias.bgg@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../mediatek/mt8395-kontron-3-5-sbc-i1200.dts    | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/boot/dts/mediatek/mt8395-kontron-3-5-sbc-i1200.dts b/arch/arm64/boot/dts/mediatek/mt8395-kontron-3-5-sbc-i1200.dts
index 4985b65925a9e..d16f545cbbb27 100644
--- a/arch/arm64/boot/dts/mediatek/mt8395-kontron-3-5-sbc-i1200.dts
+++ b/arch/arm64/boot/dts/mediatek/mt8395-kontron-3-5-sbc-i1200.dts
@@ -352,7 +352,7 @@ regulator {
 			LDO_VIN2-supply = <&vsys>;
 			LDO_VIN3-supply = <&vsys>;
 
-			mt6360_buck1: BUCK1 {
+			mt6360_buck1: buck1 {
 				regulator-name = "emi_vdd2";
 				regulator-min-microvolt = <600000>;
 				regulator-max-microvolt = <1800000>;
@@ -362,7 +362,7 @@ MT6360_OPMODE_LP
 				regulator-always-on;
 			};
 
-			mt6360_buck2: BUCK2 {
+			mt6360_buck2: buck2 {
 				regulator-name = "emi_vddq";
 				regulator-min-microvolt = <300000>;
 				regulator-max-microvolt = <1300000>;
@@ -372,7 +372,7 @@ MT6360_OPMODE_LP
 				regulator-always-on;
 			};
 
-			mt6360_ldo1: LDO1 {
+			mt6360_ldo1: ldo1 {
 				regulator-name = "mt6360_ldo1"; /* Test point */
 				regulator-min-microvolt = <1200000>;
 				regulator-max-microvolt = <3600000>;
@@ -380,7 +380,7 @@ mt6360_ldo1: LDO1 {
 							   MT6360_OPMODE_LP>;
 			};
 
-			mt6360_ldo2: LDO2 {
+			mt6360_ldo2: ldo2 {
 				regulator-name = "panel1_p1v8";
 				regulator-min-microvolt = <1800000>;
 				regulator-max-microvolt = <1800000>;
@@ -388,7 +388,7 @@ mt6360_ldo2: LDO2 {
 							   MT6360_OPMODE_LP>;
 			};
 
-			mt6360_ldo3: LDO3 {
+			mt6360_ldo3: ldo3 {
 				regulator-name = "vmc_pmu";
 				regulator-min-microvolt = <1800000>;
 				regulator-max-microvolt = <3300000>;
@@ -396,7 +396,7 @@ mt6360_ldo3: LDO3 {
 							   MT6360_OPMODE_LP>;
 			};
 
-			mt6360_ldo5: LDO5 {
+			mt6360_ldo5: ldo5 {
 				regulator-name = "vmch_pmu";
 				regulator-min-microvolt = <3300000>;
 				regulator-max-microvolt = <3300000>;
@@ -404,7 +404,7 @@ mt6360_ldo5: LDO5 {
 							   MT6360_OPMODE_LP>;
 			};
 
-			mt6360_ldo6: LDO6 {
+			mt6360_ldo6: ldo6 {
 				regulator-name = "mt6360_ldo6"; /* Test point */
 				regulator-min-microvolt = <500000>;
 				regulator-max-microvolt = <2100000>;
@@ -412,7 +412,7 @@ mt6360_ldo6: LDO6 {
 							   MT6360_OPMODE_LP>;
 			};
 
-			mt6360_ldo7: LDO7 {
+			mt6360_ldo7: ldo7 {
 				regulator-name = "emi_vmddr_en";
 				regulator-min-microvolt = <1800000>;
 				regulator-max-microvolt = <1800000>;
-- 
2.51.0



