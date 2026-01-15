Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A4893BC4EE;
	Thu, 15 Jan 2026 16:55:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768496116; cv=none; b=ZxPBsQnUtBaBEbY6vuv44bV5usuJQouhrS0U+NYgpOSsHsLO4WTbkZAer8aFXujjuUZivKEIFovcD1dNp/pYTF75fO1TZXnMHBp1LaOkoCpnk6pxagl9TYXlwhF+KSWIs1oHzVgte3UNwIMMn/aa+IPll+Qil9c6RdhryOLM33k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768496116; c=relaxed/simple;
	bh=qoDigbCvRqdaRdAvnCIy6PYwtlEDHzEVGV20KDo0hIA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PQQQTOMKwEtBHB8pItm486odZy2L0C+Xq1+VjlYhqijWJgkVybOzjpO7ztYL9y3XEx8CRJhJKyFNpzFT2CqtDccHZrPieVvPQgulIgb6keR+AT7Dt9a8/zHPa5qs/4DOcD+MovH7Vgbzvv+Tw+BlWorw3Ehynl7aGu20PEnlu+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2DRx/TNK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2DRx/TNK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 190FCC116D0;
	Thu, 15 Jan 2026 16:55:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768496111;
	bh=qoDigbCvRqdaRdAvnCIy6PYwtlEDHzEVGV20KDo0hIA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2DRx/TNK80FUHpVRCNVI7RAp//818TBwxkkN6LJIQWx7aG/uGB/XAMkww+7IYsic2
	 H8yZoAUw1shboI5En3QKg73wAL4loYsOKSwoEy/CYN6lR9oFJQZugEalURhdMNDTnC
	 r9+laOo7YE9CsxLAk3Ud5sSKuNFW/O6aHrsLwU6c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maud Spierings <maudspierings@gocontroll.com>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 082/181] arm64: dts: freescale: moduline-display: fix compatible
Date: Thu, 15 Jan 2026 17:46:59 +0100
Message-ID: <20260115164205.287344065@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164202.305475649@linuxfoundation.org>
References: <20260115164202.305475649@linuxfoundation.org>
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

From: Maud Spierings <maudspierings@gocontroll.com>

[ Upstream commit 056c68875122dd342782e5956ed145fe9e059614 ]

The compatibles should include the SoM compatible, this board is based
on the Ka-Ro TX8P-ML81 SoM, so add it to allow using shared code in the
bootloader which uses upstream Linux devicetrees as a base.

Also add the hardware revision to the board compatible to handle
revision specific quirks in the bootloader/userspace.

This is a breaking change, but it is early enough that it can be
corrected without causing any issues.

Fixes: 03f07be54cdc ("arm64: dts: freescale: Add the GOcontroll Moduline Display baseboard")
Signed-off-by: Maud Spierings <maudspierings@gocontroll.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../dts/freescale/imx8mp-tx8p-ml81-moduline-display-106.dts     | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/freescale/imx8mp-tx8p-ml81-moduline-display-106.dts b/arch/arm64/boot/dts/freescale/imx8mp-tx8p-ml81-moduline-display-106.dts
index 88ad422c27603..399230144ce39 100644
--- a/arch/arm64/boot/dts/freescale/imx8mp-tx8p-ml81-moduline-display-106.dts
+++ b/arch/arm64/boot/dts/freescale/imx8mp-tx8p-ml81-moduline-display-106.dts
@@ -9,7 +9,7 @@
 #include "imx8mp-tx8p-ml81.dtsi"
 
 / {
-	compatible = "gocontroll,moduline-display", "fsl,imx8mp";
+	compatible = "gocontroll,moduline-display-106", "karo,tx8p-ml81", "fsl,imx8mp";
 	chassis-type = "embedded";
 	hardware = "Moduline Display V1.06";
 	model = "GOcontroll Moduline Display baseboard";
-- 
2.51.0



