Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064124;
	b=Bih8A5+xaOm/XmTe7HoEQycIrI6heO8LEfsIzxZroorMGbm3jgc1Gbc2vNfVjfyitVHB
	 YMsxJbV2gvWN+RGfwZqoiLpXbyTsFhiAV0Y/1TGSyhDDJg1jgFVFh+FOsnkOU1Fx/r5NG
	 cg+MyzDJWUFW6Hqb429QC7L6MmE11XxGA8sRnTh172izjAELF5Zs4qrDLnMq7d8Kcm6Ox
	 TD3XtKJ70cQy2ta/3ZN/r/8ZHKv8GmJPxVPnSXtCEE1v5288+Yvpv6EUPAe2l5H9bAaki
	 OiOb+/f+loc6lZz2zrf8mqstTBKCjBzx4bzRXNCVIj+kLimXyQQAyhBpCfvJsurkZtg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064124;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=cS+bNjUhb23yaSEYQPrgSf4oD8hVDIAwAf3/+KS9Jl8=;
	b=nc10vleBRbGK426ArzutODqiHqCgZ6Bsl4fKE5U/XWtdHhGw+1juX3s+ahQCRojZxQ3C
	 Wxs4ZaeoKO/+yrq+DQhalvrUTjS0BtaOvJbEJ2r4pE65Ha/faNYvrtY1XMPGzzOmlBiTo
	 iMSo5xP784wyQEXHC/2svHvX3OGEy+ODUuq2qFgMootNAtyzBLwY3MSGO8h1VM+14ClpE
	 dajsqyWsaN8ys5xQMPAikj3wg74r3I97jDfuaC5JzI+sF8kwZRK2zjmQiqCmS6pVIPPvj
	 ar5pL7vPkunFwjwaD1fPBOggnbG5PHYhmNYwAczUgaoSlf7tAKn/BBOmQ2vFsryxDhw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oeCEzNpI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79EDC606B88E;
	Sat,  7 Nov 2026 15:08:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oeCEzNpI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F06C91F0089F;
	Sat,  7 Nov 2026 15:08:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064124;
	bh=cS+bNjUhb23yaSEYQPrgSf4oD8hVDIAwAf3/+KS9Jl8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oeCEzNpIe5xAeziHJSUf9mN9OfHiWVgJodE8ON+/mdSznAo/BJwKelqDn+54WPs/t
	 aMA32vpdzpSAK4LelFascWSpGpTFjIr5Z+F9oOD3/hMTpg2EbBHdZO30KF/shnrtN0
	 FiiAutAltcX8PC6/q5Vh+gPihOnDWnDS3gUEdXT4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Francesco Dolcini <francesco.dolcini@toradex.com>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0278/1257] arm64: dts: freescale: imx8mp-verdin-yavia: fix external GPIOs
Date: Sat,  7 Nov 2026 08:42:54 -0500
Message-ID: <20261107134947.156024980@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index f3d28e23ba6c6..2a90f312fb275 100644
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
@@ -266,7 +271,7 @@ MX8MP_IOMUXC_NAND_DATA03__GPIO3_IO09	0x106	/* SODIMM 62 */
 
 	pinctrl_gpios_ext_yavia: gpiosextyaviagrp {
 		fsl,pins = <
-			MX8MP_IOMUXC_NAND_CE1_B__GPIO3_IO02	0x106	/* SODIMM 64 */
+			MX8MP_IOMUXC_NAND_READY_B__GPIO3_IO16	0x106	/* SODIMM 64 */
 			MX8MP_IOMUXC_NAND_DQS__GPIO3_IO14	0x106	/* SODIMM 66 */
 		>;
 	};
-- 
2.53.0



