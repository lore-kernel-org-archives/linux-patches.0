Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC9B02367A0;
	Tue, 17 Jun 2025 16:31:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750177888; cv=none; b=WlGrjswKqeJ68ifg6a+EhmkTVZD7hWmON5ZolBB9BHEcKv5eaLKS4qvw8puNIpqEhut4xa7oG8cEgSvKja+pz2aQUY1YqmsvyXuJJmoxV5LFoIFjaiKqbdH+ZEkEnraEIhmC0Q5TYtecpcG8iWAJyMmVuzav4c3l+MAb1ei1fYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750177888; c=relaxed/simple;
	bh=ormodN7vNi7sbyvVNr9SanqQaxHLt4jsHuZqwRxF+lA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZgYBySv7DdySG3Nkuke45ClnKAQDzDpvFGiPsmE9KNMk9Gov916G5xqE1AxWrpoHjCIg0BHhYCA19yBbvWNwX1r6V+Z3Oent4eOwNWYz3R8YA4Gj0Rl1kuVuHwPykwi/ePTbRLaXM3C6t8XXQMQKlucS/Zg6n2EJjgmgolz/8Us=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RfW+sFjy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RfW+sFjy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BCB1C4CEE3;
	Tue, 17 Jun 2025 16:31:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750177887;
	bh=ormodN7vNi7sbyvVNr9SanqQaxHLt4jsHuZqwRxF+lA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RfW+sFjylInuvzYlR+X8ZvFyv7+6kVA2TbCG62dwHvW2aqlu46JZYZAG5vdnm4LdQ
	 YR514NvJjAIM/13uUvx2nwPC+RgAKxZahyf8Yx1x312cF6KdOeE1ts62a38C99eywV
	 iqO0qiTgeCJhX0/LKpzshbOr3JvSmVSEw6XVJ0hU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"=?UTF-8?q?N=C3=ADcolas=20F . =20R . =20A . =20Prado?=" <nfraprado@collabora.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 377/780] arm64: dts: mediatek: mt6357: Drop regulator-fixed compatibles
Date: Tue, 17 Jun 2025 17:21:25 +0200
Message-ID: <20250617152506.809605120@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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



