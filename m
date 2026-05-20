Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76C9E363C4C;
	Wed, 20 May 2026 17:42:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779298952; cv=none; b=apm9n4ZNWzD6BK6lOA8mq+WtfTDQhRBLRdJG8liZd98o/9FFaMjiKcePxnIwJsA2BM40yS1UqbjBoT47OlGnFdXhN/K2n/GfmGOHtjtaxTiw2LmQ/hP0ZxN+P+RBsT6h/GI5JZW8jXjKz/+cS7lQGcA6CEsu8NCYrEV+Kn/EJhs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779298952; c=relaxed/simple;
	bh=a+GsLqmB1e76SerArkJeQfaUG2+HaxMNbtVimI/Zik8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GrEc2lPKBp/BpZ5783sVusIb9+2WA0zA4fDTYgRd0p14A2H7xH7ZwvpX0I8TTe/EnT5bV6CYFy/TaHDUEiAvqMneA2RzfBqYIthT4avMATfUUehaUJMMFif/IfAXF/quG/ue1Cn2OSJCdtfuRkt/9EeiuwXzi015lzAsj6XZbD8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1vRNfTU3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1vRNfTU3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB9511F000E9;
	Wed, 20 May 2026 17:42:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779298951;
	bh=w6du0ELgf6iPc9b7EZkXamR7ilk7OSeDPZxIiTGuj5M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1vRNfTU3mmN96xR7DX4enk5V8EHwi9EwPgQn3Bn48qilYLEgNVdOPv7oi5AqquNB3
	 7i6/yMnl+x040Hmqlr4UIHkGR7QYN/N0n0JBqVj+MNy2D9lKB7hNnZv4Kg3HUsw2K8
	 FEKgeqegFfpXpkvDjhsyirfvYC4lavnkTyrn+z5k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peng Fan <peng.fan@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 605/957] arm64: dts: imx8mp-ultra-mach-sbc: Correct PAD settings for PMIC_nINT
Date: Wed, 20 May 2026 18:18:08 +0200
Message-ID: <20260520162147.655278872@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

From: Peng Fan <peng.fan@nxp.com>

[ Upstream commit daaf41ee72fb5fad936e7051a015cccae9b33937 ]

With commit 5d0efaf47ee90 ("regulator: pca9450: Correct interrupt type"),
there might be interrupt storm for this board. Need to set PAD PUE and PU
together to make pull up work properly.

Fixes: d1c1400bd3b8b ("arm64: dts: imx8mp: Add initial support for Ultratronik imx8mp-ultra-mach-sbc board")
Signed-off-by: Peng Fan <peng.fan@nxp.com>
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx8mp-ultra-mach-sbc.dts | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/freescale/imx8mp-ultra-mach-sbc.dts b/arch/arm64/boot/dts/freescale/imx8mp-ultra-mach-sbc.dts
index 9ecec1a418781..3e6f9c88cc200 100644
--- a/arch/arm64/boot/dts/freescale/imx8mp-ultra-mach-sbc.dts
+++ b/arch/arm64/boot/dts/freescale/imx8mp-ultra-mach-sbc.dts
@@ -275,7 +275,7 @@ pmic@25 {
 		reg = <0x25>;
 		pinctrl-0 = <&pinctrl_pmic>;
 		interrupt-parent = <&gpio1>;
-		interrupts = <3 GPIO_ACTIVE_LOW>;
+		interrupts = <3 IRQ_TYPE_LEVEL_LOW>;
 
 		/*
 		 * i.MX 8M Plus Data Sheet for Consumer Products
@@ -739,7 +739,7 @@ MX8MP_IOMUXC_GPIO1_IO07__GPIO1_IO07		0x40	/* NFC_INT */
 
 	pinctrl_pmic: pmic-grp {
 		fsl,pins = <
-			MX8MP_IOMUXC_GPIO1_IO03__GPIO1_IO03		0x40	/* #PMIC_INT */
+			MX8MP_IOMUXC_GPIO1_IO03__GPIO1_IO03		0x1c0	/* #PMIC_INT */
 		>;
 	};
 
-- 
2.53.0



