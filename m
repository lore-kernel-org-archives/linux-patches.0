Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBD3E1CD28;
	Sat,  3 Feb 2024 04:12:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933538; cv=none; b=bw+yCPLjmhoo0IYz5EbOFdg2mk0WvT0JKJq0VdY3i38BFclq7RQNnZoPj3t9M3iyIFM35wBZb6mvt45PZcO5Xw2vXVa3emVG33rK3K5O/sZzTBth7Pmi7HE3MGp8/Ez5Rm9N4/+h+M7jzj1HDXL8XgApt9pGjylPDJZBsChqg3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933538; c=relaxed/simple;
	bh=NRxZuAiIHzFKGBz4Uzk/3WmPdBu6853sb0Xrd8FKXs8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nQ7Hl3AxPrrZtQmAOP8ZrqbvKy4uERdTX12GxmvbP8lxV6Si5aZ2466yvkomGEir5MII5shrEO2glDPJidI++yXOfVN4/bnXLvioOX2lZ9HxzFPeUUa2QnQ2RiTmA47Rwi4Y99P7wlgAvHNApjbvfrVZlh9uPCNnrHTXkwPykw4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NC2PkEYf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NC2PkEYf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4556DC433F1;
	Sat,  3 Feb 2024 04:12:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933538;
	bh=NRxZuAiIHzFKGBz4Uzk/3WmPdBu6853sb0Xrd8FKXs8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NC2PkEYfl9DW4YBwF5rGNfyH6YQqRM3wSehlzbqfhqaJsTOaTXS80RiYjRBbsxnE3
	 R79XZLliTys6bFAbv/1G3I2zc7A7HvpAzOdaQEZSJxWYQI6KDAAdydaHMMtVIJdQh3
	 WkvsTjk/YyvIeYYvwwInMFPajQtNmoO9fuQmbWwg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Stein <alexander.stein@ew.tq-group.com>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 084/322] ARM: dts: imx7s: Fix nand-controller #size-cells
Date: Fri,  2 Feb 2024 20:03:01 -0800
Message-ID: <20240203035401.876754369@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035359.041730947@linuxfoundation.org>
References: <20240203035359.041730947@linuxfoundation.org>
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

From: Alexander Stein <alexander.stein@ew.tq-group.com>

[ Upstream commit 4aadb841ed49bada1415c48c44d21f5b69e01299 ]

nand-controller.yaml bindings says #size-cells shall be set to 0.
Fixes the dtbs_check warning:
arch/arm/boot/dts/nxp/imx/imx7s-mba7.dtb: nand-controller@33002000:
 #size-cells:0:0: 0 was expected
  from schema $id: http://devicetree.org/schemas/mtd/gpmi-nand.yaml#

Signed-off-by: Alexander Stein <alexander.stein@ew.tq-group.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/nxp/imx/imx7s.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/nxp/imx/imx7s.dtsi b/arch/arm/boot/dts/nxp/imx/imx7s.dtsi
index b6d03794d8d9..39e9f1411ebb 100644
--- a/arch/arm/boot/dts/nxp/imx/imx7s.dtsi
+++ b/arch/arm/boot/dts/nxp/imx/imx7s.dtsi
@@ -1282,7 +1282,7 @@
 		gpmi: nand-controller@33002000 {
 			compatible = "fsl,imx7d-gpmi-nand";
 			#address-cells = <1>;
-			#size-cells = <1>;
+			#size-cells = <0>;
 			reg = <0x33002000 0x2000>, <0x33004000 0x4000>;
 			reg-names = "gpmi-nand", "bch";
 			interrupts = <GIC_SPI 14 IRQ_TYPE_LEVEL_HIGH>;
-- 
2.43.0



