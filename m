Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E7641C2DC8;
	Mon, 14 Oct 2024 14:53:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728917603; cv=none; b=RXOKO82sWpOT/bsZ5N35bUh+VoK1NdXXexpL1cH6LD/XN12fMgMraQ9Y1Xx7Yz38AvdhYn4vjlR7CPjF2mGFPmqbgvIcjxTWPA5rpcVNFYzgUs16qE6UT2TpcUK+JQxFkvCby1QGNaChzLDra/kHAd+VXU5rjZS7twthnK6IEzQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728917603; c=relaxed/simple;
	bh=FgjVvk5cA7VvLlH1MN/DShO35A8L5UIij3jvYdyTrpQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hLaqV/a4QlId3AjcGajiwjf0C5G7ob1J0a5dulT7/6BiU2NulFm87ImtQFT9TvsRNCJzQlX4QJg95ZIc8iB/nHLdUJDwuK1Xki1lV3W7kr8YLmhPAEHDid6uwibqHZzwvsy9InoWLHdaCPeCW/aPsXhHPrhMmKuVnpZ8VAqTYeY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=slfE48ZC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="slfE48ZC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1631C4CEC3;
	Mon, 14 Oct 2024 14:53:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728917603;
	bh=FgjVvk5cA7VvLlH1MN/DShO35A8L5UIij3jvYdyTrpQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=slfE48ZC5GI5QBPaOOiOYCT3k4gmiDeFFTZhTWN2bWSNRdPdVITGyzzW+ZXH1gczz
	 yxC4FGsiUCDEzAJPxyRRPBI7q8qxYTuAPil51JEgoece51PtauCz8UKUNgvaxT3NFm
	 sgPCdi9DfCNsL8DqW3mgwtTD6uRtvhl+LXzdGflo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 079/798] ARM: dts: imx7d-zii-rmu2: fix Ethernet PHY pinctrl property
Date: Mon, 14 Oct 2024 16:10:33 +0200
Message-ID: <20241014141221.039482378@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
 arch/arm/boot/dts/imx7d-zii-rmu2.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/imx7d-zii-rmu2.dts b/arch/arm/boot/dts/imx7d-zii-rmu2.dts
index 1c9f25848bf7f..5b43d1d3d46db 100644
--- a/arch/arm/boot/dts/imx7d-zii-rmu2.dts
+++ b/arch/arm/boot/dts/imx7d-zii-rmu2.dts
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



