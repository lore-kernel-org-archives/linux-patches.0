Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9BCC30FF1D;
	Fri,  9 Jan 2026 11:53:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767959598; cv=none; b=jruzBHefRP82niN5V3LZK9oxR/ga8WjPiigx4XNtjT+mhlHjS0WmfB48ZwF4QjQTVWNrxkIqKgsWPJDsDZIKlEE91Qa1o6yftyLgctb8AarIsuYN92HPNj9jRlgNSG4hsgmJmzbQswcGwBrDzjvrXF2cExG2sTtT/noHiGq77I4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767959598; c=relaxed/simple;
	bh=GZaB/zoGwq8kKnY1umzC/a4CMGTWrcqxmfiC4yWEGZM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aUKcr23huRE2Flkvq9rYPEKUVm/Lc7auAZNlYB2UThx2ejec/Os9LI4cbLZbThf6PfZenWeg+5LcPJRjajnpDxr2Y/BCGR5kea9WQ5WkQIGb137kZOiVMCu0+0e4/OK8m/fFjukATuiHB2SC5NXGGltZwL4nzwL0bonnHjmbXuo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DmZJUnTi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DmZJUnTi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46A39C4CEF1;
	Fri,  9 Jan 2026 11:53:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767959598;
	bh=GZaB/zoGwq8kKnY1umzC/a4CMGTWrcqxmfiC4yWEGZM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DmZJUnTi1m8s88aIHxTQhWjhzBZ0HzvT/cW0hkT65/UXSWBASjkU69Bu4UaSv8BRX
	 bh3YeH+w3/HJlBsTryWCBXYFTRy1pYupbQPqitnPeVyCoxbQhbt5tc9+2+aV9/gFpd
	 uLrQPGSwx9D7rq6pwvDbrxbCqWQJFzJ90xrUG8Ro=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tim Harvey <tharvey@gateworks.com>,
	Peng Fan <peng.fan@nxp.com>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 075/737] arm64: dts: imx8mm-venice-gw72xx: remove unused sdhc1 pinctrl
Date: Fri,  9 Jan 2026 12:33:34 +0100
Message-ID: <20260109112136.817123541@linuxfoundation.org>
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

[ Upstream commit d949b8d12d6e8fa119bca10d3157cd42e810f6f7 ]

The SDHC1 interface is not used on the imx8mm-venice-gw72xx. Remove the
unused pinctrl_usdhc1 iomux node.

Fixes: 6f30b27c5ef5 ("arm64: dts: imx8mm: Add Gateworks i.MX 8M Mini Development Kits")
Signed-off-by: Tim Harvey <tharvey@gateworks.com>
Reviewed-by: Peng Fan <peng.fan@nxp.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../boot/dts/freescale/imx8mm-venice-gw72xx.dtsi      | 11 -----------
 1 file changed, 11 deletions(-)

diff --git a/arch/arm64/boot/dts/freescale/imx8mm-venice-gw72xx.dtsi b/arch/arm64/boot/dts/freescale/imx8mm-venice-gw72xx.dtsi
index 570992a52b759..7263bbf0f0520 100644
--- a/arch/arm64/boot/dts/freescale/imx8mm-venice-gw72xx.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mm-venice-gw72xx.dtsi
@@ -337,17 +337,6 @@ MX8MM_IOMUXC_UART4_TXD_UART4_DCE_TX	0x140
 		>;
 	};
 
-	pinctrl_usdhc1: usdhc1grp {
-		fsl,pins = <
-			MX8MM_IOMUXC_SD1_CLK_USDHC1_CLK		0x190
-			MX8MM_IOMUXC_SD1_CMD_USDHC1_CMD		0x1d0
-			MX8MM_IOMUXC_SD1_DATA0_USDHC1_DATA0	0x1d0
-			MX8MM_IOMUXC_SD1_DATA1_USDHC1_DATA1	0x1d0
-			MX8MM_IOMUXC_SD1_DATA2_USDHC1_DATA2	0x1d0
-			MX8MM_IOMUXC_SD1_DATA3_USDHC1_DATA3	0x1d0
-		>;
-	};
-
 	pinctrl_usdhc2: usdhc2grp {
 		fsl,pins = <
 			MX8MM_IOMUXC_SD2_CLK_USDHC2_CLK		0x190
-- 
2.51.0



