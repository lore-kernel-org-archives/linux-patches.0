Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B79903EDACC;
	Wed, 20 May 2026 17:42:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779298928; cv=none; b=ovva4Jqx/VA7GLGUbhq+EnAl98iTGiWS6WxCH6tM/yovdO9HKYWr6yWNU9PrZGlPQlRzmlZiW84L8kZio4nuWCj0UOPQZriOT1rCQfvk2dRDEPJxyuaoplBvst3zh4Qqg57OdUY+14qIYUC7JMseNvblNIi2V5VcBxnO2I4MZoo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779298928; c=relaxed/simple;
	bh=omA8LoI767w1fpm1/nwQf3eg0yDd0OD528sWNRGESjw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EMtBKz3ZH0pDzeiIoedWXGZc475XI5CL5iMZFXEmerRNwR/2t7DyfA53tfF50agKfPqSDwBI3+hf5jehsFnpPIPmM5RRXaoMCWePKzb15BpxNwQM1wLgyu1NHSQMQr41Hsxd4X/3ac8XBjkSZn0H4ahnoUF0WKC6zI3zDYJas4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LDR1UT8U; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LDR1UT8U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27E281F000E9;
	Wed, 20 May 2026 17:42:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779298927;
	bh=81G7IPwAEtIf8OlEBqYgby1rAYPvKbkW8LF6W0WzJJI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LDR1UT8UbyaL/aAABqzB0cGUHPUIEWWidD/l7g82bJ1k2ya9Ng1ct8wyTc3QVR/It
	 SSDodHLEBY52n1suFX77Q7tnZUzzvw9ZKMY44/HlR87wciDYM8MUnP2G0FmUVIKnll
	 e6RUsHadLcdjX2cHEzp3Xox8VfVR1bgpbcSNW2Xs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Peng Fan <peng.fan@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 597/957] arm64: dts: imx8mp-debix-model-a: Correct PAD settings for PMIC_nINT
Date: Wed, 20 May 2026 18:18:00 +0200
Message-ID: <20260520162147.480310052@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peng Fan <peng.fan@nxp.com>

[ Upstream commit 3b778178997aee24537b521a8cb60970bc1ce01c ]

With commit 5d0efaf47ee90 ("regulator: pca9450: Correct interrupt type"),
there is interrupt storm for i.MX8MP DEBIX Model A. Per schematic, there
is no on board PULL-UP resistors for GPIO1_IO03, so need to set PAD
PUE and PU together to make pull up work properly.

Fixes: c86d350aae68e ("arm64: dts: Add device tree for the Debix Model A Board")
Reported-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Closes: https://lore.kernel.org/all/20260323105858.GA2185714@killaraus.ideasonboard.com/
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Tested-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Peng Fan <peng.fan@nxp.com>
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx8mp-debix-model-a.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/freescale/imx8mp-debix-model-a.dts b/arch/arm64/boot/dts/freescale/imx8mp-debix-model-a.dts
index af02af9e5334d..740cac4cb31d9 100644
--- a/arch/arm64/boot/dts/freescale/imx8mp-debix-model-a.dts
+++ b/arch/arm64/boot/dts/freescale/imx8mp-debix-model-a.dts
@@ -440,7 +440,7 @@ MX8MP_IOMUXC_SAI5_RXC__I2C6_SDA					0x400001c3
 
 	pinctrl_pmic: pmicirqgrp {
 		fsl,pins = <
-			MX8MP_IOMUXC_GPIO1_IO03__GPIO1_IO03				0x41
+			MX8MP_IOMUXC_GPIO1_IO03__GPIO1_IO03				0x1c0
 		>;
 	};
 
-- 
2.53.0



