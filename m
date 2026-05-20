Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D1CB28DC4;
	Wed, 20 May 2026 17:42:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779298947; cv=none; b=At7wWVowYRFxdIa2sJoYS7SKqGOfU7zQPm3kNo5M1t122s9Ln/a5zsu6po47GxWwOwkHwwPpdRDjn3KRHOTU0aw0VACLjC12h3XvIgOVivKpM0HlLksTblNaBzp70Z/W851s/ifJRyXjXFZg6gvkk7u+URuvePyr5TYny9LND/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779298947; c=relaxed/simple;
	bh=9E3ht2MOUpHjQup1Hko3DSVobQMyRHM56vaScfmqzbY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=saEs5bpSqirsj2XHiR5vFGjB1QD/ZNGzQ31HS89+2oUIp6bes/+EgumUPfB7meLMuhDR1jrpzGaJfMo1AaejwTgehZyA9i7Dmef03HQA/YU4JtLapqeI79j+NjngZtKth9syvnjURgwYZ9mppIxIdUsd0l+cUsR3KrGjH3Ul/gY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WE8QTuXz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WE8QTuXz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 928071F000E9;
	Wed, 20 May 2026 17:42:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779298946;
	bh=VdS12/iP5OBX1A4tTyiyOcyjAVJ6jjwz/0CgKyvP0rk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WE8QTuXzq+0X/4/1KLsOvghUcoS+7eZNtVhaI1iaPzTXQ+7w8nTWz5fStHBOr7gCk
	 t/Lb0Dl1wB7vmhWU2p4qztVBVNfs8qI2rH86uPxFFEqNKqjNhXtV8kN5+XVX9pK5hk
	 x3ao8Kj/LPI48SQMpAyY5QpQSOuSfXUlpCtCXaIA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peng Fan <peng.fan@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 603/957] arm64: dts: imx8mp-nitrogen-som: Correct PAD settings for PMIC_nINT
Date: Wed, 20 May 2026 18:18:06 +0200
Message-ID: <20260520162147.610993291@linuxfoundation.org>
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



