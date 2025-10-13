Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 845B73093C9;
	Mon, 13 Oct 2025 15:09:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760368159; cv=none; b=pMjj29Hpc9T7j8yp4JoBB7rA+7l/9nol5ZWqfMAVrS/rnJyfIlWk2DrMMkYsqweDXW+VBPPCPSZJQWUJjMqdN5/0I4vi9Hkho3GqUFpEfaDJqvxg0WC8Vrjq8R2XdR/zppRdVVuHqh67wsghYZuHjWoDHpkIv8z9mgRHcxxWwjg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760368159; c=relaxed/simple;
	bh=UnqK5brO30YKIhwtYxoijZ3VRb0bGciiMHlnXBV1oyY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bMHOmvWm4uV1QzUKR9NKVY1UiMuPNGs9DKKxjacb8B1PXK085U8VH/4LTjixMnAtG2visRBBTRhUVwXLPliLkR8mxMKkzPymE5MTLC3jR+e4aPnkQVfwQtW2kZh81oTj4EWAO+4Jmpr2OxeV39UNmyMPDh+on+4taCwmWGUSWds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NEMZ/pZf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NEMZ/pZf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE97BC4CEE7;
	Mon, 13 Oct 2025 15:09:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760368159;
	bh=UnqK5brO30YKIhwtYxoijZ3VRb0bGciiMHlnXBV1oyY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NEMZ/pZf0xfIn/qh/p5fvihz5FMMteNTkD4dZo9T3CcIYtDNZOrtOluq8+9Kg4Ohi
	 bw9ZH4Yigf1wfaNHNfMTS9FRgjJMyWM/atFLu0GuJPfn3h96OtAJXNV2yfVy8stfb0
	 CzMzMQimXb67NXzbCTyUB1bvxGyev8KynZEYI6bI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Fei Shao <fshao@chromium.org>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 063/262] arm64: dts: mediatek: mt8395-kontron-i1200: Fix MT6360 regulator nodes
Date: Mon, 13 Oct 2025 16:43:25 +0200
Message-ID: <20251013144328.398116954@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144326.116493600@linuxfoundation.org>
References: <20251013144326.116493600@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index e2e75b8ff9188..9ab4fee769e40 100644
--- a/arch/arm64/boot/dts/mediatek/mt8395-kontron-3-5-sbc-i1200.dts
+++ b/arch/arm64/boot/dts/mediatek/mt8395-kontron-3-5-sbc-i1200.dts
@@ -351,7 +351,7 @@ regulator {
 			LDO_VIN2-supply = <&vsys>;
 			LDO_VIN3-supply = <&vsys>;
 
-			mt6360_buck1: BUCK1 {
+			mt6360_buck1: buck1 {
 				regulator-name = "emi_vdd2";
 				regulator-min-microvolt = <600000>;
 				regulator-max-microvolt = <1800000>;
@@ -361,7 +361,7 @@ MT6360_OPMODE_LP
 				regulator-always-on;
 			};
 
-			mt6360_buck2: BUCK2 {
+			mt6360_buck2: buck2 {
 				regulator-name = "emi_vddq";
 				regulator-min-microvolt = <300000>;
 				regulator-max-microvolt = <1300000>;
@@ -371,7 +371,7 @@ MT6360_OPMODE_LP
 				regulator-always-on;
 			};
 
-			mt6360_ldo1: LDO1 {
+			mt6360_ldo1: ldo1 {
 				regulator-name = "mt6360_ldo1"; /* Test point */
 				regulator-min-microvolt = <1200000>;
 				regulator-max-microvolt = <3600000>;
@@ -379,7 +379,7 @@ mt6360_ldo1: LDO1 {
 							   MT6360_OPMODE_LP>;
 			};
 
-			mt6360_ldo2: LDO2 {
+			mt6360_ldo2: ldo2 {
 				regulator-name = "panel1_p1v8";
 				regulator-min-microvolt = <1800000>;
 				regulator-max-microvolt = <1800000>;
@@ -387,7 +387,7 @@ mt6360_ldo2: LDO2 {
 							   MT6360_OPMODE_LP>;
 			};
 
-			mt6360_ldo3: LDO3 {
+			mt6360_ldo3: ldo3 {
 				regulator-name = "vmc_pmu";
 				regulator-min-microvolt = <1800000>;
 				regulator-max-microvolt = <3300000>;
@@ -395,7 +395,7 @@ mt6360_ldo3: LDO3 {
 							   MT6360_OPMODE_LP>;
 			};
 
-			mt6360_ldo5: LDO5 {
+			mt6360_ldo5: ldo5 {
 				regulator-name = "vmch_pmu";
 				regulator-min-microvolt = <3300000>;
 				regulator-max-microvolt = <3300000>;
@@ -403,7 +403,7 @@ mt6360_ldo5: LDO5 {
 							   MT6360_OPMODE_LP>;
 			};
 
-			mt6360_ldo6: LDO6 {
+			mt6360_ldo6: ldo6 {
 				regulator-name = "mt6360_ldo6"; /* Test point */
 				regulator-min-microvolt = <500000>;
 				regulator-max-microvolt = <2100000>;
@@ -411,7 +411,7 @@ mt6360_ldo6: LDO6 {
 							   MT6360_OPMODE_LP>;
 			};
 
-			mt6360_ldo7: LDO7 {
+			mt6360_ldo7: ldo7 {
 				regulator-name = "emi_vmddr_en";
 				regulator-min-microvolt = <1800000>;
 				regulator-max-microvolt = <1800000>;
-- 
2.51.0



