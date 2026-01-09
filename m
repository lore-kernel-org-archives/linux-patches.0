Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74CD532FA3D;
	Fri,  9 Jan 2026 11:53:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767959601; cv=none; b=ONmcnKWPg1qJq9CxMd0Pt+sQBfwy5fIQ69cfXkhj3kW1wr2WGbzOkuQSAXGjoAdan3rC/4TsAyPP8ohVkSvrrbAsVLkWvM9lBQlHBdiZP64sBLKBYzvsG+dChxNEHJ1JdVgATTrTjsVpBygglo+NfdR3H1h3QI6Py/9EYb9Y9wY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767959601; c=relaxed/simple;
	bh=JjAGbGm3urBwhr2srS772xaGj1jcxn4VuiWZfXZzPFo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SyV4OtdO4npVSlRxE+a3Tqfi5UAXN7vUmqgA9WUZyfBiHcKL2qCvc1gDX0x/fdir+ExswiNyWFtbWb6d3bv4w5nxlt78nKi+TUMO24Ch31FNivXyP0NRMWBZKNkgy1O+w6rOZM19q0Mi/O1E42VuuFi04KkwQtE9ceSUcy+rDFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tSj6LIN3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tSj6LIN3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02834C4CEF1;
	Fri,  9 Jan 2026 11:53:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767959601;
	bh=JjAGbGm3urBwhr2srS772xaGj1jcxn4VuiWZfXZzPFo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tSj6LIN3AkiG5kCe8SYL+H/maljWxdNjyAXZknYcAAJR8CITspL2eVsY0tXc+K1Oa
	 1HLp0ubFFscOsLugOtZAGOEug5T4P5UH6L9sr7lEYbCxI2SsZWXESswcjJgX676PcI
	 1tBVh5RNUQsTqEd0gDyCMXXzUSG7oQq1nsd6ccjY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tim Harvey <tharvey@gateworks.com>,
	Peng Fan <peng.fan@nxp.com>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 076/737] arm64: dts: imx8mp-venice-gw702x: remove off-board uart
Date: Fri,  9 Jan 2026 12:33:35 +0100
Message-ID: <20260109112136.854400460@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index f541360cb5548..ac5b3a8ce729b 100644
--- a/arch/arm64/boot/dts/freescale/imx8mp-venice-gw702x.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mp-venice-gw702x.dtsi
@@ -373,13 +373,6 @@ &i2c3 {
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
@@ -387,13 +380,6 @@ &uart2 {
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
@@ -496,13 +482,6 @@ MX8MP_IOMUXC_I2C3_SDA__GPIO5_IO19	0x400001c2
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
@@ -510,13 +489,6 @@ MX8MP_IOMUXC_UART2_TXD__UART2_DCE_TX	0x140
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



