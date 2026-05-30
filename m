Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9037630E829;
	Sat, 30 May 2026 17:20:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780161612; cv=none; b=qteLT5oea0Q92DPeEIXXL2FMqrVXo28REUZWm1iJGdhYgeSw4uKUF8vJWh+fRr+B+KztqBLF1P/9lthEToqHMj4oTy6uYbDmDuncim6m+zN3UivvTBqdIO+8Vt1CZRY6HJrjliZmiKUem5w6pWS7knVCNhDRvbEK1ppyAZoLEhI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780161612; c=relaxed/simple;
	bh=CM2IUZLubtRsZ/2AuSK1Hn+TbzfWaXToVw0nI8PotSE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jmgNTRBaKwaTOD22GieCKJsc5oMc/bkaBQQBoRbMxRx2YPFgkrnXGvuAktMbm6JtLvDDRTA9AEA5RWVf1whqsXv0cpr4LzQVJql90s8pBeHg+QLTP8Io8RB0UlFD4+lhR4+OA3k574YYkiDznUe078REwo6YMbZxI2tzTMMrLqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dlCTZ2Oh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dlCTZ2Oh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3A5C1F00893;
	Sat, 30 May 2026 17:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780161611;
	bh=rAkNp028NpTYqyJMnC+S6hvc3dp7CPHh4wMC4Et198I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dlCTZ2OhaFp68jekr5XLGY4WgCZh3QnlWdkCnFBQCQTakEosOBKU+2PKJUget6ukv
	 OU2c++6USoLvaPsbfVvqQwbHvZtTLSdDRBCJpmLSe8B9yB/L55vEBJWOPyAljQR+lT
	 pSfOshJlQLE3I8gWvP6Ha5UdrceWrMpgZfJNPzcQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peng Fan <peng.fan@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 675/969] arm64: dts: imx8mp-icore-mx8mp: Correct PAD settings for PMIC_nINT
Date: Sat, 30 May 2026 18:03:19 +0200
Message-ID: <20260530160319.136584485@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peng Fan <peng.fan@nxp.com>

[ Upstream commit ea8c90f5c7ceeb6657a8fe564aa7b190dce298a6 ]

With commit 5d0efaf47ee90 ("regulator: pca9450: Correct interrupt type"),
there might be interrupt storm for this board. Need to set PAD PUE and PU
together to make pull up work properly.

Fixes: eefe06b295087 ("arm64: dts: imx8mp: Add Engicam i.Core MX8M Plus SoM")
Signed-off-by: Peng Fan <peng.fan@nxp.com>
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx8mp-icore-mx8mp.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/freescale/imx8mp-icore-mx8mp.dtsi b/arch/arm64/boot/dts/freescale/imx8mp-icore-mx8mp.dtsi
index a6319824ea2eb..69558ffefa9a6 100644
--- a/arch/arm64/boot/dts/freescale/imx8mp-icore-mx8mp.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mp-icore-mx8mp.dtsi
@@ -132,7 +132,7 @@ MX8MP_IOMUXC_I2C1_SDA__I2C1_SDA		0x400001c3
 
 	pinctrl_pmic: pmicgrp {
 		fsl,pins = <
-			MX8MP_IOMUXC_NAND_CE0_B__GPIO3_IO01	  0x41
+			MX8MP_IOMUXC_NAND_CE0_B__GPIO3_IO01	0x1c0
 		>;
 	};
 
-- 
2.53.0



