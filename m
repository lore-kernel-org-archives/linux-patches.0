Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D17529B78D;
	Wed, 20 May 2026 18:18:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779301139; cv=none; b=XmhTqIKn6jNzdtgu3z2FhTB1AHUe7B/x31oevhGMC5y6NtDyMutYdljzbnYtFuskDhljEOnpAIAPplk/vpH+X7eCp8OaF5hGZaoD8mg4zXbKsS/5qb/22OzzPiEJjyDx/ECzR021hqeH+rCBOq2oTm7YbulAU7ylpckLBHuk0jI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779301139; c=relaxed/simple;
	bh=aWyUKNYCst1hq+Tj3XezqXla+2YNGTqI5TbUXJSV/j4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qCWjiY/8m96arKRGCkonijsHSnyZNYFJ0ExTtZ+pTX6PTN9PnsYXTwUUi3ae4/6ZZnRDlkAFYS26ocuLCCQa7kMXW6Eq2acsgAfXwGzbp/98P9rK9SMc8I3uN4pof/TnPbCYwmfT0HuJttC/NgcsLAB8bRAje5WFvDdY0Mtb0vk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w/Gr5MWE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w/Gr5MWE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E1821F000E9;
	Wed, 20 May 2026 18:18:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779301138;
	bh=ABMvOCgfh8wsK7CZEmjRdVg/aHDf1LObaeqcuW7w9XQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=w/Gr5MWEm1gyBOlGUktD77c2tUE5BROfaNTo90HrOfxHtTzUN5WDB57L1f28C9Xiy
	 6U+VxbcspfB9r95kj4BWx0jn6ODl2hlml8hiOKhl+aFJdCLkK2697vQkfduEWg9udk
	 1fYspwpcQ2oKPLvWMFEf4newOx23HYXZcUMqxX28=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peng Fan <peng.fan@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 442/666] arm64: dts: imx8mm-tqma8mqml: Correct PAD settings for PMIC_nINT
Date: Wed, 20 May 2026 18:20:53 +0200
Message-ID: <20260520162120.850857236@linuxfoundation.org>
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
index 8f58c84e14c8e..d94a59715ee0b 100644
--- a/arch/arm64/boot/dts/freescale/imx8mm-tqma8mqml.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mm-tqma8mqml.dtsi
@@ -290,7 +290,7 @@ pinctrl_i2c1_gpio: i2c1gpiogrp {
 	};
 
 	pinctrl_pmic: pmicgrp {
-		fsl,pins = <MX8MM_IOMUXC_GPIO1_IO08_GPIO1_IO8		0x94>;
+		fsl,pins = <MX8MM_IOMUXC_GPIO1_IO08_GPIO1_IO8		0x1d4>;
 	};
 
 	pinctrl_reg_usdhc2_vmmc: regusdhc2vmmcgrp {
-- 
2.53.0



