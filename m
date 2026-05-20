Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC5023EF647;
	Wed, 20 May 2026 16:59:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779296351; cv=none; b=EVmAdHTQVYQhm3nKic/RDij/mFZ8KiZTSxbkQBEkOpiuzoygLSbb68YaPFVolwP1hxHmEkgD7wwEez8LoXXV30E25FXkqi3Q54dooW+vUolHohNqhw2xHZz15dZ5wNt/XbsXo0Wgg1mmPMK5gtf7rVtLFWe6LFSdaq2Fy4za6zc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779296351; c=relaxed/simple;
	bh=qdhpiAxvE3aTqY0mkTt3mHCEY7CNiVFHGisJJidtMa8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jJNLs0M3l5yff+e1InSvKyOCIgZ2XucoUTgayqnBMIQjkEYFa2YanQrK71kayK/RIFQDcqpKseGayHlq9fMEV/A9AF+gs7W9fvmUFlV8IgUfs5m0lYlSErQwEDKsbpQmAn5YM1aeBY8Tva08+Z7svzKgMDX28uC9xNNxW2DSWkw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZVGGNON5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZVGGNON5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C51731F000E9;
	Wed, 20 May 2026 16:59:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779296350;
	bh=S61C4Xm6t/t35qHa10/hNNNEi+aXz4NRDwKYnB/x2l8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZVGGNON5lTjR/mLjRHIgyCLkT0xeoWZKsDTW+VGwXbWKlxgI3ZhQ1VP8mq8wtXZiD
	 mRztv/FJif+5+NoLDxo3ym+WmbcMjTOheDWp2SV42XUCRRTAS4ugfdk7OMtrt2vlPZ
	 tPz4tkPCdGAQZRc60q+PSv/JP1WVTS8J64vbfEc4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peng Fan <peng.fan@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0765/1146] arm64: dts: imx8mm-tqma8mqml: Correct PAD settings for PMIC_nINT
Date: Wed, 20 May 2026 18:16:55 +0200
Message-ID: <20260520162205.524885005@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peng Fan <peng.fan@nxp.com>

[ Upstream commit 42a9f5a16328ed78a88e0498556965b6c6ec515c ]

With commit 5d0efaf47ee90 ("regulator: pca9450: Correct interrupt type"),
there might be interrupt storm for this board. Need to set PAD PUE and PU
together to make pull up work properly.

Fixes: dfcd1b6f7620e ("arm64: dts: freescale: add initial device tree for TQMa8MQML with i.MX8MM")
Signed-off-by: Peng Fan <peng.fan@nxp.com>
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx8mm-tqma8mqml.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/freescale/imx8mm-tqma8mqml.dtsi b/arch/arm64/boot/dts/freescale/imx8mm-tqma8mqml.dtsi
index 29b298af0d739..1b5ba3c47164f 100644
--- a/arch/arm64/boot/dts/freescale/imx8mm-tqma8mqml.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mm-tqma8mqml.dtsi
@@ -292,7 +292,7 @@ pinctrl_i2c1_gpio: i2c1gpiogrp {
 	};
 
 	pinctrl_pmic: pmicgrp {
-		fsl,pins = <MX8MM_IOMUXC_GPIO1_IO08_GPIO1_IO8		0x94>;
+		fsl,pins = <MX8MM_IOMUXC_GPIO1_IO08_GPIO1_IO8		0x1d4>;
 	};
 
 	pinctrl_reg_usdhc2_vmmc: regusdhc2vmmcgrp {
-- 
2.53.0



