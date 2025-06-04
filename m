Received: from mail11.truemail.it (mail11.truemail.it [217.194.8.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F24A139B
	for <patches@lists.linux.dev>; Wed,  4 Jun 2025 21:24:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.194.8.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749072262; cv=none; b=KQ/8zNN7CJ7OIB7XEuq0bqKuv8rtJc2MhoSw+G9qNY8CvNIyKs4og0DQRxhTLt/a6WF+VJ23Hy5KJ9z5vQzU2bpl9CgNbOQkZo/O6R3WFtKH4uPmHW4ftDjf6br9VkSiCjUORCMBdibHex/PublHl911ANC4ZukWW67oTaj+TNc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749072262; c=relaxed/simple;
	bh=/9erwkhwqi0h1lwgfVJki3OpxULjesesHk90MsOoBC0=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=jUMBQJzPpFyHI4QbmQr2VvXghuf2wPWkXFdbeOzT56ELr3eLkeX5Z/i8OdenTcmeVY0Y7Mhui8Kpqm9X37AVJfoWqkNelrPs9R6qvZSX3uIVfHeRnq2BLItrrJjbGU6wLc9/siZ0OGMWaVVCXf5H7hsdPzfNNIqBkol/HSf50Ms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=dolcini.it; spf=pass smtp.mailfrom=dolcini.it; dkim=pass (2048-bit key) header.d=dolcini.it header.i=@dolcini.it header.b=Iq192ji5; arc=none smtp.client-ip=217.194.8.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=dolcini.it
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dolcini.it
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dolcini.it header.i=@dolcini.it header.b="Iq192ji5"
Received: from francesco-nb.pivistrello.it (93-49-2-63.ip317.fastwebnet.it [93.49.2.63])
	by mail11.truemail.it (Postfix) with ESMTPA id 70F1920F55;
	Wed,  4 Jun 2025 23:24:09 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dolcini.it;
	s=default; t=1749072249;
	bh=ja6K+hbMRaEib+YyShBEhif3bEZ2iqFZ2M4Zpcf8Tlk=; h=From:To:Subject;
	b=Iq192ji5s/lZqHREJ8wANsgKU9Qy3VAhIpa5f3ggnNhtES5a3KqI9Wib594RfuFtI
	 cyIvu31/qtYlMxD7/qBybTw3GtGEJcatnq8rEM3bnPbqWC+F7OE2YHO0Cp7r3ZTBxn
	 4h56cmfDhFjm+YOetncCo0IPR7yvuRvT3kAmgDLn7qXz8AVK5qdFnrPImDrrl22d3w
	 Cndvot080wt3K8xVuekQ/jGLPpBD80mjbbpjhzfqPbbZmR1jN1Dn6bAD/IlxDnGMAA
	 ROsNEMWzUHB+VsbSmCu2gwEGU+2h5oIX0jii/dUeCK2BiXj0/GHDLUG1OMHr7gGgbs
	 bOBo8XR9vU/XQ==
From: Francesco Dolcini <francesco@dolcini.it>
To: stable@vger.kernel.org
Cc: Francesco Dolcini <francesco@dolcini.it>,
	Marek Vasut <marex@denx.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>,
	Frieder Schrempf <frieder.schrempf@kontron.de>,
	Shawn Guo <shawnguo@kernel.org>,
	Francesco Dolcini <francesco.dolcini@toradex.com>
Subject: [PATCH 6.1.y v2] arm64: dts: imx8mm: Drop sd-vsel-gpios from i.MX8M Mini Verdin SoM
Date: Wed,  4 Jun 2025 23:24:01 +0200
Message-Id: <20250604212401.8486-1-francesco@dolcini.it>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Marek Vasut <marex@denx.de>

[ Upstream commit 8bad8c923f217d238ba4f1a6d19d761e53bfbd26 ]

The VSELECT pin is configured as MX8MM_IOMUXC_GPIO1_IO04_USDHC2_VSELECT
and not as a GPIO, drop the bogus sd-vsel-gpios property as the eSDHC
block handles the VSELECT pin on its own.

Signed-off-by: Marek Vasut <marex@denx.de>
Reviewed-by: Frieder Schrempf <frieder.schrempf@kontron.de>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Francesco Dolcini <francesco.dolcini@toradex.com>
---
6.1.y is currently broken on imx8mm-verdin, because commit
5591ce0069ddda97cdbbea596bed53e698f399c2, that was backported correctly on 6.1,
depends on this one.

This fixes the following error:

[    1.735149] gpio-regulator: probe of regulator-usdhc2-vqmmc failed with error -16

v2: add missing s-o-b francesco
---
 arch/arm64/boot/dts/freescale/imx8mm-verdin.dtsi | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm64/boot/dts/freescale/imx8mm-verdin.dtsi b/arch/arm64/boot/dts/freescale/imx8mm-verdin.dtsi
index 5b2493bb8dd9..37acaf62f5c7 100644
--- a/arch/arm64/boot/dts/freescale/imx8mm-verdin.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mm-verdin.dtsi
@@ -362,7 +362,6 @@ pca9450: pmic@25 {
 		pinctrl-names = "default";
 		pinctrl-0 = <&pinctrl_pmic>;
 		reg = <0x25>;
-		sd-vsel-gpios = <&gpio1 4 GPIO_ACTIVE_HIGH>;
 
 		/*
 		 * The bootloader is expected to switch on the I2C level shifter for the TLA2024 ADC
-- 
2.39.5


