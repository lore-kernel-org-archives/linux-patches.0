Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB95530E829;
	Sat, 30 May 2026 17:20:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780161622; cv=none; b=svYUQsld3FiQGMqFKOm9cNT79roqMkuaUsA9aFVXHFlcJvZbmjZw+aAzgbtcn96YCXT75Nlq7zRzBWN8c1Od9H9yb3zpYvWGuSUP/NNJK7FP5U9tuKQ4+Lw5CRC0MXgUfrdq0GXrKy9Quy55/b2dQCub9wqwIDXHMyIhj5RvT6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780161622; c=relaxed/simple;
	bh=+R+JX6ICdasNLnmdaI5rCEblXhqatQgbfDvlDeHsjVA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K3w2eOa+SaY9mjySZCKjnYC1hdUrdTMsurR7AGBiO+UKi8voxTB05vFQyIbEqJLBemACgbuCYpG5GGZowK5xiMhMcwaJzrI0JISFY2JWqVHuxngV1TK7R0BcMRr+9SIEbrjp8ZjQWo9Y0ztE5Ymx+DovK7srL2Fy+Je6CvjxSgI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z7gUgkLI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z7gUgkLI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F10341F00893;
	Sat, 30 May 2026 17:20:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780161621;
	bh=U4XoHfdW+Xm0cBoVdhpiS9qyNYHfUJ7YTkoxOtpoQBY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=z7gUgkLICCRLfkE5jMqUtvoGKlt8hldwEhGQOGMBnMdb3PAPQUcj5Y5tiqqMlzRWF
	 TRu0NsnFESqxu1UD/v/3N8d9ESnCizQ95nM63F6Ytq9xNkPLL1sbPqFDU3QnxolYaF
	 IvKnPZL5Mg1xG5Pnjckkn0HX1kxk+OsJGVHii2JE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peng Fan <peng.fan@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 678/969] arm64: dts: imx8mn-tqma8mqnl: Correct PAD settings for PMIC_nINT
Date: Sat, 30 May 2026 18:03:22 +0200
Message-ID: <20260530160319.220277393@linuxfoundation.org>
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

[ Upstream commit 0fb37990774113afd943eaa91323679388584b6d ]

With commit 5d0efaf47ee90 ("regulator: pca9450: Correct interrupt type"),
there might be interrupt storm for this board. Need to set PAD PUE and PU
together to make pull up work properly.

Fixes: 3e56e354db6d3 ("arm64: dts: freescale: add initial device tree for TQMa8MQNL with i.MX8MN")
Signed-off-by: Peng Fan <peng.fan@nxp.com>
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx8mn-tqma8mqnl.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/freescale/imx8mn-tqma8mqnl.dtsi b/arch/arm64/boot/dts/freescale/imx8mn-tqma8mqnl.dtsi
index 0ed3475feb164..6d43327927b9b 100644
--- a/arch/arm64/boot/dts/freescale/imx8mn-tqma8mqnl.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mn-tqma8mqnl.dtsi
@@ -282,7 +282,7 @@ pinctrl_i2c1_gpio: i2c1gpiogrp {
 	};
 
 	pinctrl_pmic: pmicgrp {
-		fsl,pins = <MX8MN_IOMUXC_GPIO1_IO08_GPIO1_IO8	0x84>;
+		fsl,pins = <MX8MN_IOMUXC_GPIO1_IO08_GPIO1_IO8	0x1c4>;
 	};
 
 	pinctrl_reg_usdhc2_vmmc: regusdhc2vmmcgrp {
-- 
2.53.0



