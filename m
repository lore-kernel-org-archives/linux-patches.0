Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF4743A3833;
	Wed, 20 May 2026 16:58:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779296325; cv=none; b=bnOtGn2KRx1G6WN+x2H5+PgqMlhILOQWVoqP10Uk/xVBfzRiKYvTEw44hZjl4QnmTD+YahIOfIUizabXZt8YVympm4So2UnJlwlpmkO8cI0R9uhPgD5x2gh/X7PTNmgXyxb/X8UTgoNZODEgbJJsk2vhSkUg8TSt/6GweTltOVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779296325; c=relaxed/simple;
	bh=c0EkPkGh7NgAe0i1wR4eDIv19sDGTlonrDyknxaoT5E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ICEM0pMAB70Q1FcZicJ6hFBQvvZ9lyI39Q9oZJvFYdkQ2QDjSVn3sziQgyDn4iF+RBKtQlHsVdP7t88pW/dfNneq1z0w609b/xrI09diYfuE46m3I8Aab9uYUFOxpHQnPpGy1EvlsVX/nypwgfbSMZaTO8nbS1KxvzZ6Pc2pCYw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZvkxpzRH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZvkxpzRH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FB301F00896;
	Wed, 20 May 2026 16:58:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779296323;
	bh=kB7edRbC9eBHEjF1viIUCiUKG6aKixPKnfzweVIeyF8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZvkxpzRHF/uRFKUY+Ke7CIJTTMQZHGNFSnii3a0ud/2DN3fKILwl9ECy68MDrI24T
	 tWSwWXnfWPvjbdVL8Jram+tetdA8WozhMCgJ6lSM8GdwVdK0uGfIC0u/8fGfgysH2A
	 M0B+exXgyePi/RprEtnZR8uAlM/q84EW85KfAs08=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peng Fan <peng.fan@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0756/1146] arm64: dts: imx8mp-nitrogen-som: Correct PAD settings for PMIC_nINT
Date: Wed, 20 May 2026 18:16:46 +0200
Message-ID: <20260520162205.320412079@linuxfoundation.org>
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

[ Upstream commit 16611eda2c7584a1a7d6f80511d825e5108f026c ]

With commit 5d0efaf47ee90 ("regulator: pca9450: Correct interrupt type"),
there might be interrupt storm for this board. Need to set PAD PUE and PU
together to make pull up work properly.

Fixes: ab4d874c9f44e ("arm64: dts: imx8mp: Add device tree for Nitrogen8M Plus ENC Carrier Board")
Signed-off-by: Peng Fan <peng.fan@nxp.com>
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx8mp-nitrogen-som.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/freescale/imx8mp-nitrogen-som.dtsi b/arch/arm64/boot/dts/freescale/imx8mp-nitrogen-som.dtsi
index f658309612eff..8465b36d440ae 100644
--- a/arch/arm64/boot/dts/freescale/imx8mp-nitrogen-som.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mp-nitrogen-som.dtsi
@@ -296,7 +296,7 @@ MX8MP_IOMUXC_I2C4_SDA__I2C4_SDA		0x400001c3
 
 	pinctrl_pmic: pmicirqgrp {
 		fsl,pins = <
-			MX8MP_IOMUXC_NAND_ALE__GPIO3_IO00	0x41
+			MX8MP_IOMUXC_NAND_ALE__GPIO3_IO00	0x1c0
 		>;
 	};
 
-- 
2.53.0



