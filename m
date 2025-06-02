Received: from mail11.truemail.it (mail11.truemail.it [217.194.8.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8096A223DEE
	for <patches@lists.linux.dev>; Mon,  2 Jun 2025 15:59:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.194.8.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748879948; cv=none; b=VV7XHQyhZHkscrGpCRrrBUHba/uDmeWox3QH+toZvqVTCUyIEhX+Pf+w53R+P+rVF2NyXcBtTNc3A54llNHIoAmcFba+As9whlXJs9mAXAmO5xu4zVJ/QKWuJd3ufR0AONk46lu1raSHnXKDX/6W++OKjoSr7lg1pXcw4DGdODg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748879948; c=relaxed/simple;
	bh=pF2ZL1p4Ei/qjK+21n7JunfkAAqlUb8ntxONs3Z572o=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=tfL5PjrfcHqeuMh7rTHVs+FaOXXVfydZsA78SRQIucX5Am3Z0mHinDHYIhc/63x+nUQPfYS5ED5KlkNJn5uoXKf3V+ZdgJ7Ue/A1QwW4LV0MLm5PF4vrX2xQLYbJ1gS+0EbRXZEHsP3N4n+jW1JK4Xlinn2qafGve8qOWX5NgxU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=dolcini.it; spf=pass smtp.mailfrom=dolcini.it; dkim=pass (2048-bit key) header.d=dolcini.it header.i=@dolcini.it header.b=NsH/XNzm; arc=none smtp.client-ip=217.194.8.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=dolcini.it
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dolcini.it
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dolcini.it header.i=@dolcini.it header.b="NsH/XNzm"
Received: from francesco-nb.pivistrello.it (93-49-2-63.ip317.fastwebnet.it [93.49.2.63])
	by mail11.truemail.it (Postfix) with ESMTPA id 4B6A81FA87;
	Mon,  2 Jun 2025 17:59:03 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dolcini.it;
	s=default; t=1748879943;
	bh=EKCdMnhXKbL9nx4aXADmXEXPpwklZe+ysQFobHyuiso=; h=From:To:Subject;
	b=NsH/XNzmlC1hrziF1koKU5UagtNFerZ171lYTq/Zr843VsX5ZyMzUKHEXGPaXtN+O
	 KHpVCFWu1wXzpqsizu2QtyAnFx7vNMWfdtps+Kxnr7SA3/ErAGoCxx2L1zYE+0VaA2
	 Y5DtaPxAKObdkmDCel3c68uJ2FfphJS3G0LyIH1XrWZTIBZLKSnA32l7XJCDGU9ZkM
	 ioY/tNcaJrxY7gQ/r9HTpO9R+scMCPWcShJ72QkGIfYKf7AFZ3gZgLhGcOclGYFdZ3
	 1p6+VRhFV0v8djDYSSo13C+VBNZixRu049qQ1Hf0wmrHRQ2fdh3j/D1YJEc8Rmle4L
	 y4hNuW/AW5uNA==
From: Francesco Dolcini <francesco@dolcini.it>
To: stable@vger.kernel.org
Cc: Marek Vasut <marex@denx.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>,
	Frieder Schrempf <frieder.schrempf@kontron.de>,
	Shawn Guo <shawnguo@kernel.org>
Subject: [PATCH 6.1.y] arm64: dts: imx8mm: Drop sd-vsel-gpios from i.MX8M Mini Verdin SoM
Date: Mon,  2 Jun 2025 17:58:45 +0200
Message-Id: <20250602155845.227354-1-francesco@dolcini.it>
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
---
6.1.y is currently broken on imx8mm-verdin, because commit
5591ce0069ddda97cdbbea596bed53e698f399c2, that was backported correctly on 6.1,
depends on this one.

This fixes the following error:

[    1.735149] gpio-regulator: probe of regulator-usdhc2-vqmmc failed with error -16

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

