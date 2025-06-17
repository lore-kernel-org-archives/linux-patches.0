Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B34892EE605;
	Tue, 17 Jun 2025 15:50:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750175400; cv=none; b=kRaAXOaJeo85nzv8QpQfY32tPj1RHeoanuNX080U0N/h/4OHbZwFh5n67bwvp8WwlDpJwi8Xr0DiinHknMXlNEpECe/jKabO3FzEWdyrD6uY4PY8FYx5fSkM119QzM+q6mkh29vRpaEKYleI6KaB+xgcsCS5Kh13hl8LhTjGv18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750175400; c=relaxed/simple;
	bh=eJbZOraSOVxaC1M8YohBUKTSbFqJXrhpdznRGJoF428=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZhAj0EbOPRyarv3uUz2JjVCfI1vNI6jeGBbr8kADacn9tP7sEhTTc5fTzuEXT26nItSwcs0SeQoF6oUY+WHHwO/FDh2EwZklfjkDWoGYxFzwTnSHpVxL5/YVg4ZsRWhreQvRscCe8KwRGnVjYPs+7hcY8dmOCRoLpudMo2TC7gU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LCalOfvU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LCalOfvU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5CE8C4CEE3;
	Tue, 17 Jun 2025 15:49:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750175400;
	bh=eJbZOraSOVxaC1M8YohBUKTSbFqJXrhpdznRGJoF428=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LCalOfvUWKIQ+sDDYH33yIflWfK2yrDMHKg55MrJ9ROi7cqj1lf2sk8eNMBE3szKZ
	 XHsBsSV9OEXsNx7gL91PGs2bCFNVRfAexbKD4uTmlWRnshCfTqFuw3NUpwPgq0YWPw
	 jc8lU2dlAaoTAmyfb0nBPP/QrBsyRj64C+eWuh3U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"=?UTF-8?q?N=C3=ADcolas=20F . =20R . =20A . =20Prado?=" <nfraprado@collabora.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 173/356] arm64: dts: mediatek: mt6357: Drop regulator-fixed compatibles
Date: Tue, 17 Jun 2025 17:24:48 +0200
Message-ID: <20250617152345.180577529@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152338.212798615@linuxfoundation.org>
References: <20250617152338.212798615@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nícolas F. R. A. Prado <nfraprado@collabora.com>

[ Upstream commit d77e89b7b03fb945b4353f2dcc4a70b34baa7bcb ]

Some of the regulators in the MT6357 PMIC dtsi have compatible set to
regulator-fixed, even though they don't serve any purpose: all those
regulators are handled as a whole by the mt6357-regulator driver. In
fact this is the only dtsi in this family of chips where this is the
case: mt6359 and mt6358 don't have any such compatibles.

A side-effect caused by this is that the DT kselftest, which is supposed
to identify nodes with compatibles that can be probed, but haven't,
shows these nodes as failures.

Remove the useless compatibles to move the dtsi in line with the others
in its family and fix the DT kselftest failures.

Fixes: 55749bb478f8 ("arm64: dts: mediatek: add mt6357 device-tree")
Signed-off-by: Nícolas F. R. A. Prado <nfraprado@collabora.com>
Link: https://lore.kernel.org/r/20250502-mt6357-regulator-fixed-compatibles-removal-v1-1-a582c16743fe@collabora.com
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/mediatek/mt6357.dtsi | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/arch/arm64/boot/dts/mediatek/mt6357.dtsi b/arch/arm64/boot/dts/mediatek/mt6357.dtsi
index 5fafa842d312f..dca4e5c3d8e21 100644
--- a/arch/arm64/boot/dts/mediatek/mt6357.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt6357.dtsi
@@ -60,7 +60,6 @@
 			};
 
 			mt6357_vfe28_reg: ldo-vfe28 {
-				compatible = "regulator-fixed";
 				regulator-name = "vfe28";
 				regulator-min-microvolt = <2800000>;
 				regulator-max-microvolt = <2800000>;
@@ -75,7 +74,6 @@
 			};
 
 			mt6357_vrf18_reg: ldo-vrf18 {
-				compatible = "regulator-fixed";
 				regulator-name = "vrf18";
 				regulator-min-microvolt = <1800000>;
 				regulator-max-microvolt = <1800000>;
@@ -83,7 +81,6 @@
 			};
 
 			mt6357_vrf12_reg: ldo-vrf12 {
-				compatible = "regulator-fixed";
 				regulator-name = "vrf12";
 				regulator-min-microvolt = <1200000>;
 				regulator-max-microvolt = <1200000>;
@@ -112,7 +109,6 @@
 			};
 
 			mt6357_vcn28_reg: ldo-vcn28 {
-				compatible = "regulator-fixed";
 				regulator-name = "vcn28";
 				regulator-min-microvolt = <2800000>;
 				regulator-max-microvolt = <2800000>;
@@ -120,7 +116,6 @@
 			};
 
 			mt6357_vcn18_reg: ldo-vcn18 {
-				compatible = "regulator-fixed";
 				regulator-name = "vcn18";
 				regulator-min-microvolt = <1800000>;
 				regulator-max-microvolt = <1800000>;
@@ -142,7 +137,6 @@
 			};
 
 			mt6357_vcamio_reg: ldo-vcamio18 {
-				compatible = "regulator-fixed";
 				regulator-name = "vcamio";
 				regulator-min-microvolt = <1800000>;
 				regulator-max-microvolt = <1800000>;
@@ -175,7 +169,6 @@
 			};
 
 			mt6357_vaux18_reg: ldo-vaux18 {
-				compatible = "regulator-fixed";
 				regulator-name = "vaux18";
 				regulator-min-microvolt = <1800000>;
 				regulator-max-microvolt = <1800000>;
@@ -183,7 +176,6 @@
 			};
 
 			mt6357_vaud28_reg: ldo-vaud28 {
-				compatible = "regulator-fixed";
 				regulator-name = "vaud28";
 				regulator-min-microvolt = <2800000>;
 				regulator-max-microvolt = <2800000>;
@@ -191,7 +183,6 @@
 			};
 
 			mt6357_vio28_reg: ldo-vio28 {
-				compatible = "regulator-fixed";
 				regulator-name = "vio28";
 				regulator-min-microvolt = <2800000>;
 				regulator-max-microvolt = <2800000>;
@@ -199,7 +190,6 @@
 			};
 
 			mt6357_vio18_reg: ldo-vio18 {
-				compatible = "regulator-fixed";
 				regulator-name = "vio18";
 				regulator-min-microvolt = <1800000>;
 				regulator-max-microvolt = <1800000>;
-- 
2.39.5



