Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35AFC269CE6;
	Sun,  7 Sep 2025 20:40:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757277619; cv=none; b=BI33WHfY5SRqNlc+9m7MVi1Lg1muu7TSaKWjkYiyrXBO53snvHhFFmUYz90BjQ/R8NfhSclmtL+wRh/pSNVy0O/qNm1rbB1mrqim+h+czQjI9vmO6YMCX7LfoZ+jNbQHkzgMfJ90i7e3FJSiAOQP0230qrT1lZB4PdoOkOjStn8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757277619; c=relaxed/simple;
	bh=kLR2W7WQORODb4uMG2jfnVS7OmsYrjsXoRjGYxvR2ig=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fsIy0VakAKECDioacMyHCSSIWDGNfwoe7Q18sxskv9AADzys9LpCJOYqDEdGQxPoBYEQu5CmnJXItY3lnGlhdA1sjbEoEX+PTSQOf6+DP9TRXCeiqNbbbPCG6tcKjdxcg6nxykJVFDzIWDx75b5fjOAsdvofWpqp0VDJTEN08LI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I1Jz89yB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I1Jz89yB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAD12C4CEF0;
	Sun,  7 Sep 2025 20:40:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757277619;
	bh=kLR2W7WQORODb4uMG2jfnVS7OmsYrjsXoRjGYxvR2ig=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I1Jz89yBEGHNKxR62dVYvD3BtbvpnBdPJ0bzUiSFlHeoc67GZfH7BEcCtEddgSXlF
	 kotpnYSJCJKTAwLHDeKvZb4izLcYWaJ4Z/zMzntekTjBKyeLy621Lv9JJisdx3SY+3
	 jIx69y2xoMz+i2b6iCsVrWChG0/nF0bI4HyKUPxE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Vasut <marek.vasut@mailbox.org>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 026/183] arm64: dts: imx8mp: Fix missing microSD slot vqmmc on Data Modul i.MX8M Plus eDM SBC
Date: Sun,  7 Sep 2025 21:57:33 +0200
Message-ID: <20250907195616.398342924@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195615.802693401@linuxfoundation.org>
References: <20250907195615.802693401@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marek Vasut <marek.vasut@mailbox.org>

[ Upstream commit 80733306290f6d2e05f0632e5d3e98cd16105c3c ]

Add missing microSD slot vqmmc-supply property, otherwise the kernel
might shut down LDO5 regulator and that would power off the microSD
card slot, possibly while it is in use. Add the property to make sure
the kernel is aware of the LDO5 regulator which supplies the microSD
slot and keeps the LDO5 enabled.

Fixes: 562d222f23f0 ("arm64: dts: imx8mp: Add support for Data Modul i.MX8M Plus eDM SBC")
Signed-off-by: Marek Vasut <marek.vasut@mailbox.org>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx8mp-data-modul-edm-sbc.dts | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/boot/dts/freescale/imx8mp-data-modul-edm-sbc.dts b/arch/arm64/boot/dts/freescale/imx8mp-data-modul-edm-sbc.dts
index d0fc5977258fb..16078ff60ef08 100644
--- a/arch/arm64/boot/dts/freescale/imx8mp-data-modul-edm-sbc.dts
+++ b/arch/arm64/boot/dts/freescale/imx8mp-data-modul-edm-sbc.dts
@@ -555,6 +555,7 @@ &usdhc2 {
 	pinctrl-2 = <&pinctrl_usdhc2_200mhz>, <&pinctrl_usdhc2_gpio>;
 	cd-gpios = <&gpio2 12 GPIO_ACTIVE_LOW>;
 	vmmc-supply = <&reg_usdhc2_vmmc>;
+	vqmmc-supply = <&ldo5>;
 	bus-width = <4>;
 	status = "okay";
 };
-- 
2.50.1



