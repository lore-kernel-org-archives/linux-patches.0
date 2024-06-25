Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08FF0149C58;
	Tue, 25 Jun 2024 09:54:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719309266; cv=none; b=Klu/bLv1Fd/vknkTI1ZksLim9XKc9tLKRaLlC9zSkQtc4++Y/nlIj+8RCp/auJhdIjiK7JfjKjQxUzhcYRk9iaUg+pYubD41ijEvugQ4OEBnxlCs13wgnnAzVcP4DB25DiwEQAzF1Dz+vkMWgGTtmnfcvDX2rulu7idUcVe8cIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719309266; c=relaxed/simple;
	bh=TQCuvb0dsZLXTGrXTJlHGipYLB+I8UwABERIPweGZhI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XgjuUVvyNR1iNr7oMdTaAzEt+M9usoWcGOiiJ5/K8BO1/d/mXKwEnDq/FXPdMRkaDU/7mC5522dk63rZtqeTffUyEaB8hnTXe6titseP9icHzb4xDbgk0RTPuykxpBZxX6whVaVA8fUvtTS5rO9Y+/HSb3Rdcd1sDTskTtrbHCs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MXF/AqIk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MXF/AqIk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42D46C32781;
	Tue, 25 Jun 2024 09:54:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719309265;
	bh=TQCuvb0dsZLXTGrXTJlHGipYLB+I8UwABERIPweGZhI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MXF/AqIkNKgppgCr8WPeT/L9lprahCs2H5lsZEN6FqKNY++C5sJ+ZDqXIsdAws4ie
	 7a64Hx4X4rquH4mJ8lts2tQtj41SjNop20PORiKsGvdeEMp4m14WIu2f3kREgdRACH
	 /nfcniuzhFTEFIj/coRdmTwJMPJRGobp/MDuUoTg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Max Krummenacher <max.krummenacher@toradex.com>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 120/192] arm64: dts: freescale: imx8mm-verdin: enable hysteresis on slow input pin
Date: Tue, 25 Jun 2024 11:33:12 +0200
Message-ID: <20240625085541.776966260@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085537.150087723@linuxfoundation.org>
References: <20240625085537.150087723@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Max Krummenacher <max.krummenacher@toradex.com>

[ Upstream commit 67cc6125fb39902169707cb6277f010e56d4a40a ]

SODIMM 17 can be used as an edge triggered interrupt supplied from an
off board source.

Enable hysteresis on the pinmuxing to increase immunity against noise
on the signal.

Fixes: 60f01b5b5c7d ("arm64: dts: imx8mm-verdin: update iomux configuration")
Signed-off-by: Max Krummenacher <max.krummenacher@toradex.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx8mm-verdin.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/freescale/imx8mm-verdin.dtsi b/arch/arm64/boot/dts/freescale/imx8mm-verdin.dtsi
index 6f0811587142d..14d20a33af8e1 100644
--- a/arch/arm64/boot/dts/freescale/imx8mm-verdin.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mm-verdin.dtsi
@@ -929,7 +929,7 @@
 	/* Verdin GPIO_9_DSI (pulled-up as active-low) */
 	pinctrl_gpio_9_dsi: gpio9dsigrp {
 		fsl,pins =
-			<MX8MM_IOMUXC_NAND_RE_B_GPIO3_IO15		0x146>;	/* SODIMM 17 */
+			<MX8MM_IOMUXC_NAND_RE_B_GPIO3_IO15		0x1c6>;	/* SODIMM 17 */
 	};
 
 	/* Verdin GPIO_10_DSI (pulled-up as active-low) */
-- 
2.43.0



