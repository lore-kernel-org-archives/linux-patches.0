Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD9E63D1CC6;
	Wed, 20 May 2026 18:20:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779301239; cv=none; b=K4bBDJkr4WwLxA1uQTNjGSZ4+AJ55hCFWNGqwZ/P2+s7qYg51siYlMLiQBJvj2kPhrI4xNQId7C+KiYINZwUM1CjVPCStveQ++yLHmaoIhwZHp67Lyh4NaQPHBK9nwBhY1Yb86H+DO2EMSjefOm6X/iTiRC3pNuwtitcEtQs7kg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779301239; c=relaxed/simple;
	bh=yd3+6sMs3g+a9/7sors5axYE3roTBVvSJTPPwZMEbDQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mCFTM/JVYxjICsqx3pxZFMFziJLo6sJvsNWRGBP/KtEcxsmJk2j2P6W4qqlFBBlyG+EPVVBSbNscAlyMgEZ7cq+gbpRsgJdxjg1a1SA7m5qgSzylSyJzfOzQCRKjr+FhYTS3ftjltnW99tJiofbrpqDavrBMlBaii+A/XWLTjSQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i8tdfZ9M; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i8tdfZ9M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F8361F000E9;
	Wed, 20 May 2026 18:20:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779301238;
	bh=WuB/64yXOl4RiRFbSCK+AESxgPF2LRm30QEZ+1E7A8Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=i8tdfZ9MtyO+REorDoeL/2gTL9lUD3k0ipzW4h0oVR2aIUDn+M8QgwWDqf4jDQEfU
	 BUwMS0FUo7/fNu2dm5FZgQjeV6G2ES+rcxy/z5SbH4VCmSbmqhCLXlhdKQHGGTp6uE
	 02yX7mabKfSPOfBJWH7reZk5mwmM7KqSVFzbQSmk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peng Fan <peng.fan@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 437/666] arm64: dts: imx8mp-dhcom-som: Correct PAD settings for PMIC_nINT
Date: Wed, 20 May 2026 18:20:48 +0200
Message-ID: <20260520162120.744598329@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 1141b26d6b6f9..f2e6391ca3b17 100644
--- a/arch/arm64/boot/dts/freescale/imx8mp-dhcom-som.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mp-dhcom-som.dtsi
@@ -989,7 +989,7 @@ MX8MP_IOMUXC_SAI5_RXC__GPIO3_IO20		0x22
 	pinctrl_pmic: dhcom-pmic-grp {
 		fsl,pins = <
 			/* PMIC_nINT */
-			MX8MP_IOMUXC_GPIO1_IO03__GPIO1_IO03		0x40000090
+			MX8MP_IOMUXC_GPIO1_IO03__GPIO1_IO03		0x1c0
 		>;
 	};
 
-- 
2.53.0



