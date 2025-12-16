Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE11D2459D7;
	Tue, 16 Dec 2025 11:19:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765883965; cv=none; b=LNn5cS+6O9/hBWT8yj0Q5+pNCBcqVpi2b5u9W+4Fkyknox+DMaHdAEBcoQ8FKSxK67QC0gOwqVLRvj2QsQ1CZEbqLR3v8JDxulbxvKxZ+OF6X9CAbo7+OZd+giDIhpI3bsgzi6iIranv8cIw0o6UiaL/3edexVhwaGguihm/6Dk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765883965; c=relaxed/simple;
	bh=Cyv2UlWQT255qyTQHiwNLh8cBfHfFJzCQ7sedmgSZGE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F9OfjOMMXkhr4LQRm1iEkBupsdhsO9K5sFve6yYzIbZnX1aB1MtGiCBx/BXJQKIrmmSVYPbE+bi35HfmOP6IzSgsEAk4NlNh/8/15sfO/zD9JxM1Taz8DsWJdttGn0LetQLwE7+GjUTEseMQPjCO3VrdHLNa5j6irq4CcMwHtsA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Mijd0Awn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Mijd0Awn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43E22C4CEF1;
	Tue, 16 Dec 2025 11:19:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765883965;
	bh=Cyv2UlWQT255qyTQHiwNLh8cBfHfFJzCQ7sedmgSZGE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Mijd0AwnlLv5KR32LPV680KWyan69m4FB/1qJHTzSGNggA1zFaEcWD1Iyu68R3Bw2
	 c4inYzNrb6ZeZzZ6jX0Nj47ZdtoCFE+R+nagsIC+n7s/ciekjS77bQ05Yl5w4mC44Y
	 KOExo0LA+Khdrm/A2rLoKwLrhlKefDJnq4tq860g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tim Harvey <tharvey@gateworks.com>,
	Peng Fan <peng.fan@nxp.com>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 051/354] arm64: dts: imx8mm-venice-gw72xx: remove unused sdhc1 pinctrl
Date: Tue, 16 Dec 2025 12:10:18 +0100
Message-ID: <20251216111322.765911134@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111320.896758933@linuxfoundation.org>
References: <20251216111320.896758933@linuxfoundation.org>
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
index 752caa38eb03b..266038fbbef97 100644
--- a/arch/arm64/boot/dts/freescale/imx8mm-venice-gw72xx.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mm-venice-gw72xx.dtsi
@@ -351,17 +351,6 @@ MX8MM_IOMUXC_UART4_TXD_UART4_DCE_TX	0x140
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



