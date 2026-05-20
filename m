Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2712369D6E;
	Wed, 20 May 2026 16:58:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779296311; cv=none; b=GV0SuljRaufclofoH5Vi8PsCT50turCfN73LYZuZo6zxYX9lsBjInxQSRTOkhUBo0Vw5ZdCmhBJphiemIVdWzBqs8GwHzKI6QkBUG+ndfHTXsiFdzvs77D6uLTvG/yKsWk0+Jy8xRbwfplhz+EtvhsI4bOH+eso3PagtQkC3w8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779296311; c=relaxed/simple;
	bh=bv18WOzk2fRABz03uZNjZ/U4qs/Z3MgOBU5SLO1mrq8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a+EjR0I53T29AM0ZEUUo94dDXx//kFbbHJ/kVAf32p67cMDhjkwJCmLRFRZTEcIyN2IAi4cAONi1dZsG0ht/kLX5Z02qzRvefDq5Cp6cDFk8iLZtzJHix8WcdWzQsjQWM/Cqu5Fm1SnAGbEH5Wl7WHi6rg3yYXrVafO9mtBJuF4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qp9gTIGC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qp9gTIGC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4312C1F000E9;
	Wed, 20 May 2026 16:58:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779296310;
	bh=FA/IVUY9f2a3Ug3Es47rMaa7reHCBLJiY1emuLtyzz8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Qp9gTIGCkl6fuvEWAhj+/NaS+/IGgQNxogWgyTWHPwTqfoJL7P3dOINRABY2AI+Wv
	 2AMe4BJ7eBN6VnHCpzAwvBOEbEAqET8mTV7qY+GvPBGVa1k/T/GKadDeA+ocBwtU8b
	 IjYwt2e5OKkK2lu5xHiVxjBsUMyWptxuNUjzr5s0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peng Fan <peng.fan@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0752/1146] arm64: dts: imx8mp-navqp: Correct PAD settings for PMIC_nINT
Date: Wed, 20 May 2026 18:16:42 +0200
Message-ID: <20260520162205.230172633@linuxfoundation.org>
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

[ Upstream commit 741d6ac1a2a2e0f3e2cae5eef3516cdd75119e83 ]

With commit 5d0efaf47ee90 ("regulator: pca9450: Correct interrupt type"),
there will be interrupt storm for i.MX8MP NAVQP. Per schematic, there
is no on board PULL-UP resistors for GPIO1_IO03, so need to set PAD
PUE and PU together to make pull up work properly.

Fixes: 682729a9d506d ("arm64: dts: freescale: Add device tree for Emcraft Systems NavQ+ Kit")
Signed-off-by: Peng Fan <peng.fan@nxp.com>
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx8mp-navqp.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/freescale/imx8mp-navqp.dts b/arch/arm64/boot/dts/freescale/imx8mp-navqp.dts
index 4a4f7c1adc23f..9dedb9f11145e 100644
--- a/arch/arm64/boot/dts/freescale/imx8mp-navqp.dts
+++ b/arch/arm64/boot/dts/freescale/imx8mp-navqp.dts
@@ -356,7 +356,7 @@ MX8MP_IOMUXC_I2C4_SDA__I2C4_SDA					0x400001c3
 
 	pinctrl_pmic: pmicgrp {
 		fsl,pins = <
-			MX8MP_IOMUXC_GPIO1_IO03__GPIO1_IO03				0x41
+			MX8MP_IOMUXC_GPIO1_IO03__GPIO1_IO03				0x1c0
 		>;
 	};
 
-- 
2.53.0



