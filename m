Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 441DE19F411;
	Wed,  2 Oct 2024 14:01:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727877710; cv=none; b=bwiNjTWSOVrhZcLamglf2p5YWyMOPwFTStVsP/kl7P1vx3m3hqp0Ynkreo9SVZIJSj5crchBrqQGhoAlvrZgojPD6sZ6fGNMTMsJXG+tS/ku9YhCOv3god+mx1hgW9+yFLOGNAv4CDY+dEkONvKIq4ljIRHRVP2hTm6BMSuVPt8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727877710; c=relaxed/simple;
	bh=jaF8KKF7PBOP7axcJCrDSZ7ur3LX/bxhqwshOW5tF0k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cLuK+qcMM1SYYB1LNWiN4ZxoOYpaBnR3iWAk3N111QOMDFFkFE/yOeYvhP7Nk4VpMwZF+Pi0D/7F5X4LaRhnAvr/oo5EDJuCSpWRK6E0VwipblJ48pXZrWK1b7+qAFMr7ZLoyY7h21NMogm4acHiPnU+j0VPd2Hu9xeMOdyJ/ZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LzZtyPsJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LzZtyPsJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52443C4CEC2;
	Wed,  2 Oct 2024 14:01:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727877709;
	bh=jaF8KKF7PBOP7axcJCrDSZ7ur3LX/bxhqwshOW5tF0k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LzZtyPsJh1hyUk++MW3v974GDqLckebOXT1jl+Rw94DzeyzFFm6yFrmptSN8pEUdq
	 eBe6AxxUYKm1cmfAbBr9uWDTM2nAuxZH3I7w3+oI3u2fbZ+o450iiDQPo592q4PTqG
	 Spol6xmN76zMQSWUvjG3Mrg0k/dy1Dm9fcfT32wA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 136/634] ARM: dts: imx7d-zii-rmu2: fix Ethernet PHY pinctrl property
Date: Wed,  2 Oct 2024 14:53:56 +0200
Message-ID: <20241002125816.477067699@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -350,7 +350,7 @@
 
 &iomuxc_lpsr {
 	pinctrl_enet1_phy_interrupt: enet1phyinterruptgrp {
-		fsl,phy = <
+		fsl,pins = <
 			MX7D_PAD_LPSR_GPIO1_IO02__GPIO1_IO2	0x08
 		>;
 	};
-- 
2.43.0



