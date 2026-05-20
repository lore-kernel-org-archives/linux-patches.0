Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED8C2371CEA;
	Wed, 20 May 2026 18:42:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779302550; cv=none; b=e02c+YJab70q+IhTgFZw+n2pM+ZjcLtjVNA2uIzhuI1qDdcUpRuHlrg95mX+B4FxgGo7SFkNisly2HdY89xCLizXUiZi6u/4JcnopbhdPjh8+eGLMV9s7AIDDwGfIr1ctn4aTU7BLbmu87ufWG0bRHD2yNAvUJAIe1X1nbd4sTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779302550; c=relaxed/simple;
	bh=ix7/5OPRrrUH7a4wxtYCR/cUNvpnazttgTu5+GVafUo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OAM9F9nU0Rr2JKng1q99bC8H4tKY9tR8EDuLhVFIZAkLoy309v8MRS65F4IJzku9QbPuMdBY0E2jAiHXICO+9vB0I1zLR8cboRDYV4Dbbtj1NKQFymTIYwOeg+MywAL/GXPcb0O/ERrVV+vflGV+1qpK4gID4fTVFzHPXxRMwcM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aSFwvAOe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aSFwvAOe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EDA41F000E9;
	Wed, 20 May 2026 18:42:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779302548;
	bh=ShuTyB4hwDgn5E5Fg0EpRNePhk+WwkkvCUVDZQB6q0g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aSFwvAOe80rFJMiVQNzmXAL43yhK0pgdyAXW8EqbeJNbuzM98dxxBvA2M7hYQlgaW
	 95zRNQoNPfrkJOL0Z6l0P0Gc5NjDbIrzayVkDzxM+2vczz6clmqf4gi3I+EmWs/gzi
	 F2YDGYqKCyCqahJ2kzqnCz57arSUK/YBX4Ircua0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peng Fan <peng.fan@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 310/508] arm64: dts: imx8mm-tqma8mqml: Correct PAD settings for PMIC_nINT
Date: Wed, 20 May 2026 18:22:13 +0200
Message-ID: <20260520162105.357307496@linuxfoundation.org>
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

[ Upstream commit 42a9f5a16328ed78a88e0498556965b6c6ec515c ]

With commit 5d0efaf47ee90 ("regulator: pca9450: Correct interrupt type"),
there might be interrupt storm for this board. Need to set PAD PUE and PU
together to make pull up work properly.

Fixes: dfcd1b6f7620e ("arm64: dts: freescale: add initial device tree for TQMa8MQML with i.MX8MM")
Signed-off-by: Peng Fan <peng.fan@nxp.com>
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx8mm-tqma8mqml.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/freescale/imx8mm-tqma8mqml.dtsi b/arch/arm64/boot/dts/freescale/imx8mm-tqma8mqml.dtsi
index b4466a26d838a..6d79447b8fa08 100644
--- a/arch/arm64/boot/dts/freescale/imx8mm-tqma8mqml.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mm-tqma8mqml.dtsi
@@ -282,7 +282,7 @@ pinctrl_i2c1_gpio: i2c1gpiogrp {
 	};
 
 	pinctrl_pmic: pmicgrp {
-		fsl,pins = <MX8MM_IOMUXC_GPIO1_IO08_GPIO1_IO8		0x94>;
+		fsl,pins = <MX8MM_IOMUXC_GPIO1_IO08_GPIO1_IO8		0x1d4>;
 	};
 
 	pinctrl_reg_usdhc2_vmmc: regusdhc2vmmcgrp {
-- 
2.53.0



