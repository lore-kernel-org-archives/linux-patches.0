Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB1991D014A;
	Wed,  2 Oct 2024 13:26:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727875608; cv=none; b=n5L/DFo9xuSy2NRL1Edb77b+d04AYzQUM4KHs+COq4/dcWmMzidjzqn52tmcZMm/mp3JnPvyXjbt6lzVwvIgTWeanOBoyItBlIg2HiB0p/sPM7ggwD70KDRgIvYBs9OlCd82b9ZD7etUS8FSaWOM2S69erIshJdCddsqZWlrho4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727875608; c=relaxed/simple;
	bh=DgXJFb/nc4G6YyGxbekQ36oWxKVjjMJMctkpL5tMinU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pbV03LrHbq5L9ofvPXyYsnzLwafOVwMU0ZwcI8/yKneWktZAol1uUknWL9a5xo1lB16xbViLTHpZL/DmT2cCQcVYBAOwY1Ty0Rk/tOGIrSWCdw6TSgx9DCIruLs0JEoj3+BGhemsUktwQg6/yZA0kvk7f8qZqd1RZf5MKwxQ5YM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2TufrGEq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2TufrGEq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9476C4CECD;
	Wed,  2 Oct 2024 13:26:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727875608;
	bh=DgXJFb/nc4G6YyGxbekQ36oWxKVjjMJMctkpL5tMinU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2TufrGEqXgfCnzbS5GSXS5ry+owcVgZhypygkY9YgnJvZ6EWGq10rwgxcrMKRvoo+
	 7g32gAxd1I2EW/+7KLolfVboasUqlsLTcugJase7U5dnCNPn5Y704vHMTtaak0Spit
	 jLMTpzSLTR2MrCV6xeuJpNNHAYNMLwipW2U1nXbY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 152/695] ARM: dts: imx7d-zii-rmu2: fix Ethernet PHY pinctrl property
Date: Wed,  2 Oct 2024 14:52:30 +0200
Message-ID: <20241002125828.548019543@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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



