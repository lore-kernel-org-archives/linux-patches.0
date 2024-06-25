Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5657113C90B;
	Tue, 25 Jun 2024 10:00:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719309653; cv=none; b=UtJpqrps69INwhHGZOKZCXdpZcjlS1avdG4ZM6XWIhjpuIRIpqZe6wRvpWXVzn2XYtnrzs5oO3gK0YfU0gW5P9N3sOGHhejYDMbXMcm5cmqyXjaOkLAjP4AM/86bB9QPiS+r3Z6Ez6dDsRvsSRx7qQaIV5zMQkDJ2mJKaGx89HU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719309653; c=relaxed/simple;
	bh=2yoJE0NVGLMS8meaFQNW0OW+eN7I1az5nng8VtO5uQU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IuLFeSzJ/1o+p7xsmYMSMgyRBIypDwbIUGTF++b+5zxdqwAvTuiWQwi139eAyP1eIyodS2lLWKujCMMfahvRAeluHT38JVpR28zKMH5lNBqC9DDg9fA4o4cAXV/lCIpW52AbBNQx7t1ocRSACuG4tmNEDoNZYvmPc/T3951J/n0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tRuw4dYk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tRuw4dYk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2737C32781;
	Tue, 25 Jun 2024 10:00:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719309653;
	bh=2yoJE0NVGLMS8meaFQNW0OW+eN7I1az5nng8VtO5uQU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tRuw4dYkl24fUnCtZe0dpeTBRc+cB+sHf9FteiXqu+6nArppDoJPFOIMXDqG0lnfY
	 6JuELOBe7ju4fBK3JNpnDcRAxxZoV2s4Zq2i+S5SrLMg7QO6gugoTJTnuXnMQyx+Ow
	 Kiiyg6mveCpK369GYgGmaZlZQ3vSuZRr0CkD3gBY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Max Krummenacher <max.krummenacher@toradex.com>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 088/131] arm64: dts: freescale: imx8mm-verdin: enable hysteresis on slow input pin
Date: Tue, 25 Jun 2024 11:34:03 +0200
Message-ID: <20240625085529.282279041@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085525.931079317@linuxfoundation.org>
References: <20240625085525.931079317@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index b4aef79650c69..0dd2f79c4f20f 100644
--- a/arch/arm64/boot/dts/freescale/imx8mm-verdin.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mm-verdin.dtsi
@@ -930,7 +930,7 @@
 	/* Verdin GPIO_9_DSI (pulled-up as active-low) */
 	pinctrl_gpio_9_dsi: gpio9dsigrp {
 		fsl,pins =
-			<MX8MM_IOMUXC_NAND_RE_B_GPIO3_IO15		0x146>;	/* SODIMM 17 */
+			<MX8MM_IOMUXC_NAND_RE_B_GPIO3_IO15		0x1c6>;	/* SODIMM 17 */
 	};
 
 	/* Verdin GPIO_10_DSI (pulled-up as active-low) */
-- 
2.43.0



