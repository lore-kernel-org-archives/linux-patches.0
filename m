Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 337E046AA6B;
	Tue, 21 Jul 2026 15:38:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648324; cv=none; b=qeI4QG829j4ETO07Djh3V7jSsMu7zQIgjx8GMHoTBBqhZ6jE0GGcXkvAoivJwt9EzU7vD9I2qw48iyIAp3drbtFaL9lAWJzew880ORBafCj9VwyO6JomTXnPH+mv2YSRQTPzdcd+IZbepJwrFt+3MHI/Ht9XSUaQ+L0uett2pbc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648324; c=relaxed/simple;
	bh=1uLI7kwA4MkqZCqH8D/sRpZlOH87Y6OzskqulBHXkNg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WfzGEUIwJToZP6W7BmAruxETUJVnoG1J4R4YUsFESmEFbHXnwI58pt94KnXCcyuYJLTMhaQ2wN+/7clUs3rmsQdT02Ob93CRjYzmy8EOtVqpjJ87DISrL3n6GFuihysR1Qa+GRFNzd/d5Sdw1aNWazNQoEcWmztbFiM8o9+KlUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Zz5jX2O/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Zz5jX2O/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 989A61F000E9;
	Tue, 21 Jul 2026 15:38:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648323;
	bh=hnZnjyddmrbqeHKEqc7ieHM19qldrck4S1myYmAyYZk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Zz5jX2O/T0Odt1X0q1ydMN9x8ykMlizQOziz5VwGUWVyMwDDcaX0XuPYm71Zx8mJL
	 gS5Ybn0pUQmTOUfIdT0ednZU68CeW3oOrV7Xivgmr6J884qx/RiPda/ozoNaMdsBMg
	 X0yeeZWikMx4SjuzF25nj0xHS+HJAzRHfN1XFtCU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peng Fan <peng.fan@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0156/2077] Revert "arm64: dts: imx8mp-kontron: Add support for reading SD_VSEL signal"
Date: Tue, 21 Jul 2026 16:57:09 +0200
Message-ID: <20260721152556.364301413@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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



