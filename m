Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5CF76FA7
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 20:04:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C42FEC433C7;
	Sun, 17 Sep 2023 20:04:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694981074;
	bh=v7W+IyRQHEJNlQ2709gQ19MhmDLDlH39PP1VCbacJx8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pGI9++eiaOWDWjFhyAqF/N0xBNynMkrICLjLDjamU7Ohr65OCAYO9rCNilvWoGUui
	 lgaxwhBpOqwf3Wb6xz1z2vQvzvuC3F0O7G6GKFt53wds9a6vxr5EXn12ktDILoBApE
	 0ILi6T597uVk3WIhUgC/gc4vCkv1A3b6JA9GsCcY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Vasut <marex@denx.de>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 002/511] ARM: dts: imx7s: Drop dma-apb interrupt-names
Date: Sun, 17 Sep 2023 21:07:09 +0200
Message-ID: <20230917191113.895524741@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191113.831992765@linuxfoundation.org>
References: <20230917191113.831992765@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marek Vasut <marex@denx.de>

[ Upstream commit 9928f0a9e7c0cee3360ca1442b4001d34ad67556 ]

Drop "interrupt-names" property, since it is broken. The drivers/dma/mxs-dma.c
in Linux kernel does not use it, the property contains duplicate array entries
in existing DTs, and even malformed entries (gmpi, should have been gpmi). Get
rid of that optional property altogether.

Signed-off-by: Marek Vasut <marex@denx.de>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Stable-dep-of: be18293e47cb ("ARM: dts: imx: Set default tuning step for imx7d usdhc")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/imx7s.dtsi | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm/boot/dts/imx7s.dtsi b/arch/arm/boot/dts/imx7s.dtsi
index 5951f9a22af86..5d62781451cb0 100644
--- a/arch/arm/boot/dts/imx7s.dtsi
+++ b/arch/arm/boot/dts/imx7s.dtsi
@@ -1246,7 +1246,6 @@
 				     <GIC_SPI 12 IRQ_TYPE_LEVEL_HIGH>,
 				     <GIC_SPI 12 IRQ_TYPE_LEVEL_HIGH>,
 				     <GIC_SPI 12 IRQ_TYPE_LEVEL_HIGH>;
-			interrupt-names = "gpmi0", "gpmi1", "gpmi2", "gpmi3";
 			#dma-cells = <1>;
 			dma-channels = <4>;
 			clocks = <&clks IMX7D_NAND_USDHC_BUS_RAWNAND_CLK>;
-- 
2.40.1



