Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062074;
	b=oPugvwbekY1zePnjB9kA4kJyMEVENXNXB1p5DZXTfifMlQkgl2ditA8hMRE7L9/QCdOT
	 7pDtigFiCykQtqPIRXryq+1J6jvFFbAo7YkRB2hxCmA2f3EdiJOGbHQ50q35zBeMcl4X7
	 AfO3yfEfuv21mCd4S+PQPD/hVjYCMDXCgR3Ktm0j+mG10IdlcPOQaOu7bou1JdpPmH9FQ
	 6BzylD770WLqnzvioz2vZ54H6LHHXN/OL8wzkXOKODeJsPsq1PwMDRzRaUclQbHH2Pxe+
	 WFracaa5YQMOMcfiydtKy6dsmbw+dUqszb0sUrvVT1zvhakEieTgFQmcb4Diqtdw+HQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062074;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ufeiSyOOqHnURJh59AcJvHLR/VOTBuiv4ZeVCAU1Xbw=;
	b=ANjH4ZW+dIuUwF9cFfXHlN1OmRHSVx8jV9imaUGPuXAEbXjnRPoIosylAjfemKdHRjcA
	 lY7JqJAHMfinWSfW/n+2SRtuL6V489KY+14L53RDNpBnULlUEgrnYB1yyV8FwNKN9pdG+
	 /13HXcXe8yS16XIPKWIR/aVQs2Hzy/S5Im35DmUDcqeGjHfuDAxCh4xiDPpmvNVP/7tFj
	 5vYfv3z2QTYuO+MOnMInjWUjP5dIeQJ7lNoHrNxmoJwoOLnAJsL/8ab5i/t6aD5Y57VBA
	 Xw/a2hfCWABvDVYeHoyPXMQGirpn0+BibOCbw6J4fDKFpIyMoVPbCeyuhRpSU2lnVIg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=az8goWyO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A98D606D80F;
	Sat,  7 Nov 2026 14:34:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=az8goWyO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EEA81F0089F;
	Sat,  7 Nov 2026 14:34:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062073;
	bh=ufeiSyOOqHnURJh59AcJvHLR/VOTBuiv4ZeVCAU1Xbw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=az8goWyOa8oebhF8fU/0sDXDdOGvjvjqtJAhdMzCMc8U23JNOSrBexdOfsMrYcvmZ
	 PAT7AEGfI8VtntwymWLvMGMGWJmwrbVq7imb+Jibz7e5UJmXp0AD/CnTiwH2JWJjs9
	 Euq/SzlA8gXzKqqiKFn0us0K3IskJLw+6y+V7w2w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Francesco Dolcini <francesco.dolcini@toradex.com>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1051/1536] arm64: dts: freescale: imx8mp-verdin-yavia: fix external GPIOs
Date: Sat,  7 Nov 2026 08:51:07 -0500
Message-ID: <20261107135027.198783290@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Francesco Dolcini <francesco.dolcini@toradex.com>

[ Upstream commit f377ac5999a5d045168ddd25d204691c6653c06a ]

pinctrl_gpios_ext_yavia (SODIMM 64/66) is defined but never applied to
gpio3, so those pins stay at their NAND reset function instead of GPIO.

Fix SODIMM 64 to the correct pad, MX8MP_IOMUXC_NAND_READY_B (GPIO3_IO16).

Fixes: b694fbe2ff40 ("arm64: dts: imx8mp-verdin: Add yavia carrier board")
Cc: stable@vger.kernel.org
Signed-off-by: Francesco Dolcini <francesco.dolcini@toradex.com>
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx8mp-verdin-yavia.dtsi | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/freescale/imx8mp-verdin-yavia.dtsi b/arch/arm64/boot/dts/freescale/imx8mp-verdin-yavia.dtsi
index cc389cda2af2e..20d99012d4f32 100644
--- a/arch/arm64/boot/dts/freescale/imx8mp-verdin-yavia.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mp-verdin-yavia.dtsi
@@ -117,6 +117,11 @@ &flexcan1 {
 	status = "okay";
 };
 
+&gpio3 {
+	pinctrl-names = "default";
+	pinctrl-0 = <&pinctrl_gpios_ext_yavia>;
+};
+
 &gpio4 {
 	pinctrl-names = "default";
 	pinctrl-0 = <&pinctrl_ctrl_sleep_moci>;
@@ -262,7 +267,7 @@ MX8MP_IOMUXC_NAND_DATA03__GPIO3_IO09	0x106	/* SODIMM 62 */
 
 	pinctrl_gpios_ext_yavia: gpiosextyaviagrp {
 		fsl,pins = <
-			MX8MP_IOMUXC_NAND_CE1_B__GPIO3_IO02	0x106	/* SODIMM 64 */
+			MX8MP_IOMUXC_NAND_READY_B__GPIO3_IO16	0x106	/* SODIMM 64 */
 			MX8MP_IOMUXC_NAND_DQS__GPIO3_IO14	0x106	/* SODIMM 66 */
 		>;
 	};
-- 
2.53.0



