Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AC381A3BCE;
	Thu, 15 Aug 2024 14:27:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723732025; cv=none; b=J+rVt6F00FWFwQ9ii4MNwzF5XRsQKSDagvVifZ5WTs6T7VikuMNBCAHITRYSerow+dp0Oe32h6iJFCiM/lg9401qQD3AKxTSzjcZIooqRMV65gQJzF1Vu3w465sqUXYB9x52CYnml4Wf6Xzpi7iPKJdo7V0KkxNWV3/vEzPIqEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723732025; c=relaxed/simple;
	bh=9o2K4zlulNDRLOp0won8FnnPxVmXDB9zRe2VNlurMiY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FKNOLWbttYXIGygSgXS9VSQmDXIXpQNLGXD3KduVVWYWAbZaU8VQyxepZLAMACi35kc+/D3Z3p/9iOv0uVNTbuesfFjK2xvQ+5ekCsBFVZh/rtz71RueuCoyml0Y6qDMVnO4adJtMmtQp/iSg5IRcICElcjiFhKCrLnO6Erelks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b80xARSG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b80xARSG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9AE6C32786;
	Thu, 15 Aug 2024 14:27:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723732025;
	bh=9o2K4zlulNDRLOp0won8FnnPxVmXDB9zRe2VNlurMiY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b80xARSGCZRoeH/mriL3NIBNfSZsZYtZHFg7q0RpPczuxI1yneFRFVpUfB4ha7JJO
	 0RziDDGgh/S1QlqmcDhmKcLJeUbXuQhW2eNs7uyl2VjOgrQvy2sR+LTMz4gciFOgzk
	 +nIwaRL00p6O1cvMcPiFsP7gXYxL2oxQuzpaz/s4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marco Felsch <m.felsch@pengutronix.de>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 020/352] ARM: dts: imx6qdl-kontron-samx6i: move phy reset into phy-node
Date: Thu, 15 Aug 2024 15:21:26 +0200
Message-ID: <20240815131919.997601208@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131919.196120297@linuxfoundation.org>
References: <20240815131919.196120297@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marco Felsch <m.felsch@pengutronix.de>

[ Upstream commit 5694eed98cca5c164ebb5b831b65b4c9eee4b2d5 ]

Add ethernet-phy node so we can drop the deprecated fec phy-reset-gpios
property. The reset-assert-us value is taken from the existing logic
since the fec driver will add an 1ms assert delay per default if
phy-reset-gpios is used and phy-reset-duration is not specified.

Signed-off-by: Marco Felsch <m.felsch@pengutronix.de>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Stable-dep-of: edfea889a049 ("ARM: dts: imx6qdl-kontron-samx6i: fix PHY reset")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/imx6qdl-kontron-samx6i.dtsi | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/imx6qdl-kontron-samx6i.dtsi b/arch/arm/boot/dts/imx6qdl-kontron-samx6i.dtsi
index 37d94aa45a8b7..e2b7bfddedcda 100644
--- a/arch/arm/boot/dts/imx6qdl-kontron-samx6i.dtsi
+++ b/arch/arm/boot/dts/imx6qdl-kontron-samx6i.dtsi
@@ -260,7 +260,19 @@ &fec {
 	pinctrl-names = "default";
 	pinctrl-0 = <&pinctrl_enet>;
 	phy-mode = "rgmii";
-	phy-reset-gpios = <&gpio1 25 GPIO_ACTIVE_LOW>;
+	phy-handle = <&ethphy>;
+
+	mdio {
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		ethphy: ethernet-phy@1 {
+			compatible = "ethernet-phy-ieee802.3-c22";
+			reg = <1>;
+			reset-gpios = <&gpio1 25 GPIO_ACTIVE_LOW>;
+			reset-assert-us = <1000>;
+		};
+	};
 };
 
 &i2c_intern {
-- 
2.43.0



