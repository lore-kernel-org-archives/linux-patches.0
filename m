Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE279326D44;
	Tue, 21 Jul 2026 17:41:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655718; cv=none; b=rZHda/7w/Ga4W6CpAVBQ0OUwK5bV6GzX/kE7WOGWNzPh+DJ3WuXLKmOkLuDd8udKSnXkbnjlutEobipACna6fbsLXUqwmwFika3knbjN36tIjHC8vau/yc02l4iHUVPYQO6SLl8TntFjEofNlXoQRM9hrByhTs2qlGene47C2p8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655718; c=relaxed/simple;
	bh=PtcvejPyc271wMEjoSrtrDg8dOvpCcFyp3ImDknFNGY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RphjbzhwrwZZHCZJnYiWTqntwd36nAnAwyvhRI0M4juMoVwrdQnk6FV6Xxkymrd4D5LaKGmLz4AiOmaSzSLJwgWI5hpCHlfoHX59mtFYotY0f7rkKKcY9ffmst++gPekh75G1QjVSnjRbdl5VlI+KBGrVm10sJ09bHhm+yN2HEE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uYef4Vx2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uYef4Vx2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 407D31F000E9;
	Tue, 21 Jul 2026 17:41:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655717;
	bh=Ypucml4f6ZUw6YHsH6/jUtrpBd9P+SJwvVlBQxgnhJ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uYef4Vx2tLX9otxbihig1F9yY6rp1LpN1W0PvQzVo1J1sbZekzCTjkV/42FEMLyBs
	 PEd0lt2B5jAOiR30Qhqi2Z15239dZXpGwtV0ed/7OJ/IahVnXp2z5Olf4QjdQqC3kn
	 VL9foe9YOBbtPA5ZuHCxT6t8Y/XyLB5TDAVtrKzU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peng Fan <peng.fan@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0115/1611] Revert "arm64: dts: imx8mp-kontron: Add support for reading SD_VSEL signal"
Date: Tue, 21 Jul 2026 17:03:51 +0200
Message-ID: <20260721152517.441958332@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peng Fan <peng.fan@nxp.com>

[ Upstream commit 22465a195af370ed6311be3adee479fb7c683685 ]

This reverts commit 39e4189d9d63a0b6fc15458ce0136e99ecdfb1b8.

The board uses SDHC VSELECT to automatically switch between 1.8v and
3.3v. It does not use GPIO to control the PMIC SD_VSEL signal.
The original commit intends to read back SD_VSEL value from GPIO,
but it is wrong. When MUX is configured as SDHC VSELECT, it is
impossible to read back the value from GPIO controller. Setting SION
could only enable the input path for the mux function. It could not
redirect the input to GPIO.

Fixes: 39e4189d9d63a ("arm64: dts: imx8mp-kontron: Add support for reading SD_VSEL signal")
Signed-off-by: Peng Fan <peng.fan@nxp.com>
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx8mp-kontron-osm-s.dtsi | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/boot/dts/freescale/imx8mp-kontron-osm-s.dtsi b/arch/arm64/boot/dts/freescale/imx8mp-kontron-osm-s.dtsi
index bc1a261bb000ed..ea69c639b30b8f 100644
--- a/arch/arm64/boot/dts/freescale/imx8mp-kontron-osm-s.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mp-kontron-osm-s.dtsi
@@ -311,7 +311,6 @@ reg_nvcc_sd: LDO5 {
 				regulator-name = "NVCC_SD (LDO5)";
 				regulator-min-microvolt = <1800000>;
 				regulator-max-microvolt = <3300000>;
-				sd-vsel-gpios = <&gpio1 4 GPIO_ACTIVE_HIGH>;
 			};
 		};
 	};
@@ -815,7 +814,7 @@ MX8MP_IOMUXC_SD2_DATA0__USDHC2_DATA0		0x1d0 /* SDIO_A_D0 */
 			MX8MP_IOMUXC_SD2_DATA1__USDHC2_DATA1		0x1d0 /* SDIO_A_D1 */
 			MX8MP_IOMUXC_SD2_DATA2__USDHC2_DATA2		0x1d0 /* SDIO_A_D2 */
 			MX8MP_IOMUXC_SD2_DATA3__USDHC2_DATA3		0x1d0 /* SDIO_A_D3 */
-			MX8MP_IOMUXC_GPIO1_IO04__USDHC2_VSELECT		0x400001d0
+			MX8MP_IOMUXC_GPIO1_IO04__USDHC2_VSELECT		0x1d0
 		>;
 	};
 
@@ -827,7 +826,7 @@ MX8MP_IOMUXC_SD2_DATA0__USDHC2_DATA0		0x1d4 /* SDIO_A_D0 */
 			MX8MP_IOMUXC_SD2_DATA1__USDHC2_DATA1		0x1d4 /* SDIO_A_D1 */
 			MX8MP_IOMUXC_SD2_DATA2__USDHC2_DATA2		0x1d4 /* SDIO_A_D2 */
 			MX8MP_IOMUXC_SD2_DATA3__USDHC2_DATA3		0x1d4 /* SDIO_A_D3 */
-			MX8MP_IOMUXC_GPIO1_IO04__USDHC2_VSELECT		0x400001d0
+			MX8MP_IOMUXC_GPIO1_IO04__USDHC2_VSELECT		0x1d0
 		>;
 	};
 
@@ -839,7 +838,7 @@ MX8MP_IOMUXC_SD2_DATA0__USDHC2_DATA0		0x1d6 /* SDIO_A_D0 */
 			MX8MP_IOMUXC_SD2_DATA1__USDHC2_DATA1		0x1d6 /* SDIO_A_D1 */
 			MX8MP_IOMUXC_SD2_DATA2__USDHC2_DATA2		0x1d6 /* SDIO_A_D2 */
 			MX8MP_IOMUXC_SD2_DATA3__USDHC2_DATA3		0x1d6 /* SDIO_A_D3 */
-			MX8MP_IOMUXC_GPIO1_IO04__USDHC2_VSELECT		0x400001d0
+			MX8MP_IOMUXC_GPIO1_IO04__USDHC2_VSELECT		0x1d0
 		>;
 	};
 
-- 
2.53.0



