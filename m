Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9499E371CEA;
	Wed, 20 May 2026 18:42:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779302547; cv=none; b=tUBMSybEgC0gMNDvzkKtwePPSOci4YrxNy9tDA/tl0rS+OPM0iKsEIt5dIFx79zaAWlAyfd7PI+cM23C0BOXHy3+UiXsnpxQvcWn2RRNxybURX0Kv7rWY2T78qCrW6+bkkMe0OwLqZ4B4f7+x1ykSmpSTnMo6QXYvW8HXhmMoco=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779302547; c=relaxed/simple;
	bh=Dq2PEbjNXpT4Et48/EOJdqzEb9oanR/oQ3Xb3ysBOhM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d+ahNhfz37F55HeieNVP1oJpPpt4hYgm/zK/8AXsyz0DTkDZ2KVh4rqP1uuGfiLaOzHqFl+mchZJhU3kadqp1wgYODWrPS3TIjcanHsWscezXqb3NEtajYnWWj2FM0sIP176oQvgo1nPWcPSWwtoSQqfb6ZT6ikmWub87sTIHdk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ED/riI4e; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ED/riI4e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5C401F000E9;
	Wed, 20 May 2026 18:42:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779302546;
	bh=hF75MiiwmDUvzv/SpX99PsHYQHLXDkZYzbLN3HGDO8E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ED/riI4eFUYx+NmlaVJnwXWDDwJ400xI6O+qaa4L+ZmpyrZjf5eUFiAQYo/DSz1z4
	 C76M4C+AzkP7PSt3nu0ST7d5W/HPHRzuMY0AL0CypeoQbuEKPSKOLFUbs726dau00s
	 lphYhjgabAwvR2oY1nZ/0xWvuzQ70euwtN322b+I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peng Fan <peng.fan@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 309/508] arm64: dts: imx8mn-tqma8mqnl: Correct PAD settings for PMIC_nINT
Date: Wed, 20 May 2026 18:22:12 +0200
Message-ID: <20260520162105.336343230@linuxfoundation.org>
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
index 78aaa04ebbc08..ca02f7ff37645 100644
--- a/arch/arm64/boot/dts/freescale/imx8mn-tqma8mqnl.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mn-tqma8mqnl.dtsi
@@ -284,7 +284,7 @@ pinctrl_i2c1_gpio: i2c1gpiogrp {
 	};
 
 	pinctrl_pmic: pmicgrp {
-		fsl,pins = <MX8MN_IOMUXC_GPIO1_IO08_GPIO1_IO8	0x84>;
+		fsl,pins = <MX8MN_IOMUXC_GPIO1_IO08_GPIO1_IO8	0x1c4>;
 	};
 
 	pinctrl_reg_usdhc2_vmmc: regusdhc2vmmcgrp {
-- 
2.53.0



