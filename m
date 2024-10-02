Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F8301D0438;
	Wed,  2 Oct 2024 14:29:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727879393; cv=none; b=PEMpKkGPtENNtgx6o5kVcM4NGuVrk9rmtORRiBOLKhYSaSqs2Z1Vxs7V82Y4VenE8ZkBo4krwsY8x6Zoz79dUAaG25YOXA4EPfZTqnfRtwAy6ioGxM07SgHn70s2/1EzkndIkmicHqnVJP6Ngn5TtR08x6F8X+NB3GfhKVOtVWI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727879393; c=relaxed/simple;
	bh=AZOsf4thOLpiBHuEsZqVnlS5L9vuOOrqhYJTpLCM038=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZEUW5cOdXmN05xRWB5uijrQsmQ5midLynrhcjoClechdKXVdkvo4/SmED6YSKwqq8emUZD18feNhw6HNYqDqycuWg9Z5HC4S2Ot3OtUYpLL7bx/aphCyOJUetd7N1JG161V2zLV8ZJjLfKCCphJKCMxSfupLgt0qzztUnvnoFJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xflSlUpu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xflSlUpu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C528FC4CEC2;
	Wed,  2 Oct 2024 14:29:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727879393;
	bh=AZOsf4thOLpiBHuEsZqVnlS5L9vuOOrqhYJTpLCM038=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xflSlUpuc/jYRXqJlgwuMfRsziK0uoYiQkY+bDVN9q3efYTnPhm57PgAbzfyWLdIO
	 Clmk48Db0/YdRegoiqRsnmitWJ+KsWWqqZ3s99z2n+PEI8equN0ePVATVTX0qVnkWa
	 35hFfoASB05YCdrfuCEB6sH0+GDLVtnSnMGIF5OM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 104/538] ARM: dts: imx7d-zii-rmu2: fix Ethernet PHY pinctrl property
Date: Wed,  2 Oct 2024 14:55:43 +0200
Message-ID: <20241002125756.338136336@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

[ Upstream commit 0e49cfe364dea4345551516eb2fe53135a10432b ]

There is no "fsl,phy" property in pin controller pincfg nodes:

  imx7d-zii-rmu2.dtb: pinctrl@302c0000: enet1phyinterruptgrp: 'fsl,pins' is a required property
  imx7d-zii-rmu2.dtb: pinctrl@302c0000: enet1phyinterruptgrp: 'fsl,phy' does not match any of the regexes: 'pinctrl-[0-9]+'

Fixes: f496e6750083 ("ARM: dts: Add ZII support for ZII i.MX7 RMU2 board")
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/nxp/imx/imx7d-zii-rmu2.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/nxp/imx/imx7d-zii-rmu2.dts b/arch/arm/boot/dts/nxp/imx/imx7d-zii-rmu2.dts
index 521493342fe97..8f5566027c25a 100644
--- a/arch/arm/boot/dts/nxp/imx/imx7d-zii-rmu2.dts
+++ b/arch/arm/boot/dts/nxp/imx/imx7d-zii-rmu2.dts
@@ -350,7 +350,7 @@ MX7D_PAD_SD3_RESET_B__SD3_RESET_B	0x59
 
 &iomuxc_lpsr {
 	pinctrl_enet1_phy_interrupt: enet1phyinterruptgrp {
-		fsl,phy = <
+		fsl,pins = <
 			MX7D_PAD_LPSR_GPIO1_IO02__GPIO1_IO2	0x08
 		>;
 	};
-- 
2.43.0



