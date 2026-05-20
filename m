Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1974A2701C4;
	Wed, 20 May 2026 18:44:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779302647; cv=none; b=MqanezukikMtsQSbYxC1+JFDBnBSQDoMifndcSyuetWiytZan9AI6Ulb99esOkgaOSOV7E4CwrNiD6rjl3nr2B36+Vd5XDZX5UA25eH2e0ukpcf4e8fArY7zzHMuLpJUDgMZdPM/yVNPbyE5cSwhk0ctRvWh8cXEsLg/N+tkIbY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779302647; c=relaxed/simple;
	bh=pHDD8F972suN3fnAPJsmcpHmNvATQlk9YdsxW+IX6j8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JMzUkTGl571jlE2kqa6gEv0behII0ZCJmDKXlEtQOu/qTMdaXRnJA94RkHp+AS1NRoMfG3SMKKjWRX0kIWbCdJDsXWkpwLv4bOlxMhGgC0WIb7GBQksu8YwoO7gkoiSbpdnRk8qq1FHBsywjeDP1Z4144Or3QD1trY9Lk+Dqmfc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DMZOxR7m; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DMZOxR7m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 800381F000E9;
	Wed, 20 May 2026 18:44:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779302646;
	bh=ocT/Z0zwR0F2HIa3j4Eh49ZOZ34y0HcQ3t4/BcpX4IY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DMZOxR7m8ss+eJkyZQ5wof/GykekBTt+AgF9blZxC0mrV74kq/jbXvu9f4NasSIfz
	 djZwPm0CGkgfnVvRuRA+TAaw2GNfXMD+65HfsxAQ6fWWy/lb9aqLeNR+3JyuEogUD+
	 VKDmusvH5ykrjeH1o/gDqfDWFm20kRzpUFqgPmc8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peng Fan <peng.fan@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 305/508] arm64: dts: imx8mp-dhcom-som: Correct PAD settings for PMIC_nINT
Date: Wed, 20 May 2026 18:22:08 +0200
Message-ID: <20260520162105.249399272@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162058.573354582@linuxfoundation.org>
References: <20260520162058.573354582@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peng Fan <peng.fan@nxp.com>

[ Upstream commit f9ed5afc988da3e22543725e35be6addbb0497bc ]

PMIC_nINT is low level triggered, but the current PAD settings is
PE=0,PUE=0,FSEL_1_FAST_SLEW_RATE=1,SION=1. So PAD needs to be configured
as PULL UP with PULL Enable, no need SION. Correct it.

Fixes: 8d6712695bc8e ("arm64: dts: imx8mp: Add support for DH electronics i.MX8M Plus DHCOM and PDK2")
Signed-off-by: Peng Fan <peng.fan@nxp.com>
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx8mp-dhcom-som.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/freescale/imx8mp-dhcom-som.dtsi b/arch/arm64/boot/dts/freescale/imx8mp-dhcom-som.dtsi
index 2ff47f6ec7979..e1b2b1d4ff39f 100644
--- a/arch/arm64/boot/dts/freescale/imx8mp-dhcom-som.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mp-dhcom-som.dtsi
@@ -902,7 +902,7 @@ MX8MP_IOMUXC_HDMI_DDC_SDA__GPIO3_IO27		0x84
 	pinctrl_pmic: dhcom-pmic-grp {
 		fsl,pins = <
 			/* PMIC_nINT */
-			MX8MP_IOMUXC_GPIO1_IO03__GPIO1_IO03		0x40000090
+			MX8MP_IOMUXC_GPIO1_IO03__GPIO1_IO03		0x1c0
 		>;
 	};
 
-- 
2.53.0



