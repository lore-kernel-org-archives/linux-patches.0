Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E88534CFB2;
	Tue, 16 Dec 2025 12:08:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765886909; cv=none; b=hDApmiPQYDNzPEj73OfbrY1l9R+UXLdZ9cRUt4Srb+IofgxRKgSw42CeUCNh4SndOqi89gyleer8sYlPbdJYyq/a7bqEbninJRB5STq3erq4llWVvuOGYmh4AcstvQx8Sy5m+lSBVRvZNMplBn7zBgKJM01zIIHTftF86mkZvv4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765886909; c=relaxed/simple;
	bh=STcxQaTWMXW0GyxaPk+munzksdW4iokZY0tmxz2D+rU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lFgJUQbXfm1Ekm3aLAJFocFq2aT/vHNndCudXbaJG89C74IXw3uodGtMqvkmN//bMHjwwjU0/dmMg+0Cxqv1I3E/mwtlyF1De0zh3QMGH2rWmO6nvuWJy11oxUS0lCxBh9yH/xmEjaD8O2cwDuCvROaA82ula4vE0LAKkVx29VA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fAKgOiGw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fAKgOiGw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B02B0C4CEF5;
	Tue, 16 Dec 2025 12:08:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765886909;
	bh=STcxQaTWMXW0GyxaPk+munzksdW4iokZY0tmxz2D+rU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fAKgOiGwb8jReqkjVPX10gTr8fyuDgtY5HHX7sdDBRlWZRNHqyUO0CaXfAxjp9ciV
	 So8btxGYbRxgNZHjcymj1e9jlhZpAoh/sbfcN3ypCsk0gSy5KW1IdGDjYhmZcmGiqo
	 XLOwJctVUbfqqdOJfzrRu82tUu9AblDSCvf/FyZY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tim Harvey <tharvey@gateworks.com>,
	Peng Fan <peng.fan@nxp.com>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 070/614] arm64: dts: imx8mp-venice-gw702x: remove off-board uart
Date: Tue, 16 Dec 2025 12:07:17 +0100
Message-ID: <20251216111403.850916985@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

From: Tim Harvey <tharvey@gateworks.com>

[ Upstream commit effe98060f70eb96e142f656e750d6af275ceac3 ]

UART1 and UART3 go to a connector for use on a baseboard and as such are
defined in the baseboard device-trees. Remove them from the gw702x SOM
device-tree.

Fixes: 0d5b288c2110 ("arm64: dts: freescale: Add imx8mp-venice-gw7905-2x")
Signed-off-by: Tim Harvey <tharvey@gateworks.com>
Reviewed-by: Peng Fan <peng.fan@nxp.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../dts/freescale/imx8mp-venice-gw702x.dtsi   | 28 -------------------
 1 file changed, 28 deletions(-)

diff --git a/arch/arm64/boot/dts/freescale/imx8mp-venice-gw702x.dtsi b/arch/arm64/boot/dts/freescale/imx8mp-venice-gw702x.dtsi
index 303995a8adce8..086ee4510cd83 100644
--- a/arch/arm64/boot/dts/freescale/imx8mp-venice-gw702x.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mp-venice-gw702x.dtsi
@@ -395,13 +395,6 @@ &i2c3 {
 	status = "okay";
 };
 
-/* off-board header */
-&uart1 {
-	pinctrl-names = "default";
-	pinctrl-0 = <&pinctrl_uart1>;
-	status = "okay";
-};
-
 /* console */
 &uart2 {
 	pinctrl-names = "default";
@@ -409,13 +402,6 @@ &uart2 {
 	status = "okay";
 };
 
-/* off-board header */
-&uart3 {
-	pinctrl-names = "default";
-	pinctrl-0 = <&pinctrl_uart3>;
-	status = "okay";
-};
-
 /* off-board */
 &usdhc1 {
 	pinctrl-names = "default";
@@ -520,13 +506,6 @@ MX8MP_IOMUXC_I2C3_SDA__GPIO5_IO19	0x400001c2
 		>;
 	};
 
-	pinctrl_uart1: uart1grp {
-		fsl,pins = <
-			MX8MP_IOMUXC_UART1_RXD__UART1_DCE_RX	0x140
-			MX8MP_IOMUXC_UART1_TXD__UART1_DCE_TX	0x140
-		>;
-	};
-
 	pinctrl_uart2: uart2grp {
 		fsl,pins = <
 			MX8MP_IOMUXC_UART2_RXD__UART2_DCE_RX	0x140
@@ -534,13 +513,6 @@ MX8MP_IOMUXC_UART2_TXD__UART2_DCE_TX	0x140
 		>;
 	};
 
-	pinctrl_uart3: uart3grp {
-		fsl,pins = <
-			MX8MP_IOMUXC_UART3_RXD__UART3_DCE_RX	0x140
-			MX8MP_IOMUXC_UART3_TXD__UART3_DCE_TX	0x140
-		>;
-	};
-
 	pinctrl_usdhc1: usdhc1grp {
 		fsl,pins = <
 			MX8MP_IOMUXC_SD1_CLK__USDHC1_CLK	0x190
-- 
2.51.0



