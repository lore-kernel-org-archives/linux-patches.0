Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EA30369D6E;
	Wed, 20 May 2026 16:58:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779296309; cv=none; b=u0lDivgS10V9FiMYEzXABoQuZ6PKq0oU85+TtPyGACBXYFVFizOgnc3IoieWgP4vDMEpzcFvIzRjMP2m2jbDPKvt2yUGjCFqfhz4dOKxEcFPNhmFE9Ds02gWq9CDS3deV+GW1T5XZMSOPtIpZ7bYSW1aMCZbnn4jFa0wFuk++L0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779296309; c=relaxed/simple;
	bh=UX2qWgUHG7WWQ1Nxt8pct5gD1i/N8m347HBIN09X6fI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G0eRUrAMv90yX6pEtLlaVTTCuJFjYmkcniLtvID6YclsklhrevHuUlS5LJVXyhkEhtRRAgAQnlr+jbdE5uuBiokc4Z1O31GUcP2zrJtAuK/MlsEneF9Mqb3L2rqxZDDjeFvjRuPVuJOMZZ4SzSpmPDb80kP4o7W4q8xKLrMqzpo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kpm0xQYh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kpm0xQYh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 937101F000E9;
	Wed, 20 May 2026 16:58:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779296308;
	bh=ZUFM1uJVp4Pl1pWuwFvC/HfdI9JBFVPb0SbFkG6cgdQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kpm0xQYhHihYHA0N0wBwAKIxwzUbhlumlvoQLDWunnm7gwQI+EQez29gtfeNNfHWV
	 AsoTKik7XgYYENaxDY2dcARpSANBQRbGkSPbfM9FBr3YUqunbRVlKal9XA/aJReN5i
	 F1CTfBUGonO+2JWVEX6ydMiAuwaVdCpJgyvRNg8c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Kieran Bingham <kieran.bingham@ideasonboard.com>,
	Peng Fan <peng.fan@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0751/1146] arm64: dts: imx8mp-debix-som-a: Correct PAD settings for PMIC_nINT
Date: Wed, 20 May 2026 18:16:41 +0200
Message-ID: <20260520162205.208456408@linuxfoundation.org>
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

[ Upstream commit 2ea7872048a179b0ea8dadc67771961df3f0fc4a ]

With commit 5d0efaf47ee90 ("regulator: pca9450: Correct interrupt type"),
there is interrupt storm for i.MX8MP DEBIX SOM A. Need to set PAD
PUE and PU together to make pull up work properly.

Fixes: 21baf0b47f81b ("arm64: dts: freescale: Add DEBIX SOM A and SOM A I/O Board support")
Reported-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Closes: https://lore.kernel.org/all/20260323105858.GA2185714@killaraus.ideasonboard.com/
Reported-by: Kieran Bingham <kieran.bingham@ideasonboard.com>
Closes: https://lore.kernel.org/imx/20260324194353.GB2352505@killaraus.ideasonboard.com/T/#m9a07fdc75496369a7d76d52c5e34ed140dcabfe3
Signed-off-by: Peng Fan <peng.fan@nxp.com>
Reviewed-by: Kieran Bingham <kieran.bingham@ideasonboard.com>
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx8mp-debix-som-a-bmb-08.dts | 2 +-
 arch/arm64/boot/dts/freescale/imx8mp-debix-som-a.dtsi       | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/freescale/imx8mp-debix-som-a-bmb-08.dts b/arch/arm64/boot/dts/freescale/imx8mp-debix-som-a-bmb-08.dts
index 04619a7229065..1471ff361b54c 100644
--- a/arch/arm64/boot/dts/freescale/imx8mp-debix-som-a-bmb-08.dts
+++ b/arch/arm64/boot/dts/freescale/imx8mp-debix-som-a-bmb-08.dts
@@ -499,7 +499,7 @@ MX8MP_IOMUXC_SAI1_RXD1__GPIO4_IO03		0x140
 
 	pinctrl_pmic: pmicgrp {
 		fsl,pins = <
-			MX8MP_IOMUXC_GPIO1_IO03__GPIO1_IO03		0x41
+			MX8MP_IOMUXC_GPIO1_IO03__GPIO1_IO03		0x1c0
 		>;
 	};
 
diff --git a/arch/arm64/boot/dts/freescale/imx8mp-debix-som-a.dtsi b/arch/arm64/boot/dts/freescale/imx8mp-debix-som-a.dtsi
index 91094c2277443..b31e8fe95ca74 100644
--- a/arch/arm64/boot/dts/freescale/imx8mp-debix-som-a.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mp-debix-som-a.dtsi
@@ -241,7 +241,7 @@ MX8MP_IOMUXC_I2C4_SDA__I2C4_SDA			0x400001c3
 
 	pinctrl_pmic: pmicgrp {
 		fsl,pins = <
-			MX8MP_IOMUXC_GPIO1_IO03__GPIO1_IO03		0x41
+			MX8MP_IOMUXC_GPIO1_IO03__GPIO1_IO03		0x1c0
 		>;
 	};
 
-- 
2.53.0



