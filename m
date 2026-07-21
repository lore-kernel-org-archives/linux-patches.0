Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2EA246AA6B;
	Tue, 21 Jul 2026 15:38:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648311; cv=none; b=qsN55EYspx6OL3ghFWokbwj0TgZExX0mmUUWb8pC5kJwiRTyGfvySIiZ6Fyyl8qYWg6E6jcmbYwSOdIbQObKoi83GgbuOljiS3lRaaY0mDbR81AGOpDbj10csuBAIBMsgH62cRWuJ6xZVXkJK2SBSEEdGmIVQsOdOroTO8jSOjc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648311; c=relaxed/simple;
	bh=43pA45Eda+CWffh1/AtWeG/AP4KXBOIjUW7D3p90WM8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tEitDkqJ9HGqb/9dXOJIX39cmKteFZTQOCLMtvWWEbcJuL+YkmKFPuemAF6Fz2ynqGgDcH18PEpG5Jr9ENKwCMI/xMUzoVl+O2+VVzpN/Z6i4MLJ/NScZCG9BF9Jus/FVV3aAUp8vRAgf6NDJDOEw1nL35EofFgnmxcVV9RGPAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=klGG09Rb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="klGG09Rb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 555DD1F000E9;
	Tue, 21 Jul 2026 15:38:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648309;
	bh=5gg7PGosjfbOgtfe37xZYLoQ1j1N2No07IZD/e7fWc8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=klGG09RbJHVFnQRCHzCg+RIpGTt8rhcsAGKmNVMwcjaqPGwqD2uCTi14MPESCSvTE
	 /jBlJ7E7ijKteChGJ7s/k+7TJ86JWho61suvRoWIsi7/vB2Jha6wovEhxAm+MoALkF
	 B8AZN+iUOqHU/c2LO8k8hRkHgwD9Ab6tkTsDJbhs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peng Fan <peng.fan@nxp.com>,
	Daniel Baluta <daniel.baluta@nxp.com>,
	Alexander Stein <alexander.stein@ew.tq-group.com>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0151/2077] arm64: dts: imx8x-colibri: Correct SODIMM PAD settings
Date: Tue, 21 Jul 2026 16:57:04 +0200
Message-ID: <20260721152556.247156439@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peng Fan <peng.fan@nxp.com>

[ Upstream commit 0a03ee38a262cab0d9754e9947d565e089a9f7a5 ]

SION is BIT(30), not BIT(26). Correct it.

Fixes: 7ece3cbc8b1ef ("arm64: dts: colibri-imx8x: Add atmel pinctrl groups")
Signed-off-by: Peng Fan <peng.fan@nxp.com>
Reviewed-by: Daniel Baluta <daniel.baluta@nxp.com>
Reviewed-by: Alexander Stein <alexander.stein@ew.tq-group.com>
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx8x-colibri.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/freescale/imx8x-colibri.dtsi b/arch/arm64/boot/dts/freescale/imx8x-colibri.dtsi
index 47895ff8cb244e..2415487d3a5dea 100644
--- a/arch/arm64/boot/dts/freescale/imx8x-colibri.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8x-colibri.dtsi
@@ -631,12 +631,12 @@ pinctrl_adc0: adc0grp {
 	 */
 	pinctrl_atmel_adap: atmeladaptergrp {
 		fsl,pins = <IMX8QXP_UART1_RX_LSIO_GPIO0_IO22			0x21>,		/* SODIMM  30 */
-			   <IMX8QXP_UART1_TX_LSIO_GPIO0_IO21			0x4000021>;	/* SODIMM  28 */
+			   <IMX8QXP_UART1_TX_LSIO_GPIO0_IO21			0x40000021>;	/* SODIMM  28 */
 	};
 
 	/* Atmel MXT touchsceen + boards with built-in Capacitive Touch Connector */
 	pinctrl_atmel_conn: atmelconnectorgrp {
-		fsl,pins = <IMX8QXP_QSPI0B_DATA2_LSIO_GPIO3_IO20		0x4000021>,	/* SODIMM 107 */
+		fsl,pins = <IMX8QXP_QSPI0B_DATA2_LSIO_GPIO3_IO20		0x40000021>,	/* SODIMM 107 */
 			   <IMX8QXP_QSPI0B_SS1_B_LSIO_GPIO3_IO24		0x21>;		/* SODIMM 106 */
 	};
 
-- 
2.53.0



