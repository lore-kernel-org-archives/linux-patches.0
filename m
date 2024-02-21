Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90A756A037;
	Wed, 21 Feb 2024 13:15:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708521340; cv=none; b=fC7AsfNlPsQHy4dashNxp3enPKMpAh3You2NPgJJgSNCs+iy60puHagMdSiTzyb2QkiFCy2227hgMj2XCLybvqIxIHbrCU3yKr4jBFvaLEezA3TiIlCR2qtgDxvKpuBSWtQAg3vhzxozVen5kjZ0yR1sGmLhptweaOy262JKsqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708521340; c=relaxed/simple;
	bh=aeeGFiMkS+BGqPAbPDJJ27jAr8GMRHfyyZt9N7MuNLo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EBdxVSGSIdA1gtp5mBRg/TMCeE/utXFXa2PXZhnsqLPMRtFogloZJmPwd9/mykrWzaVJBvgQq6Q897k3zjyvCENLLYH49y4rsNMnnLCQEZp/Cz+8QIzuoOM302B8htdumM8KOztdg4Rn5A9b665xO0/J3Nwx5jnPDCMSATQFD28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TR2CPOWX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TR2CPOWX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 628FBC433C7;
	Wed, 21 Feb 2024 13:15:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708521340;
	bh=aeeGFiMkS+BGqPAbPDJJ27jAr8GMRHfyyZt9N7MuNLo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TR2CPOWXTWJVDOv8o219/aiyctdUIh4yj0tDfLyQDRb0FpxQf6iTKLqwG06iRjNfR
	 cyp8mP7zqukiPHiFJMyJNL2MXYhRY33XSszp8GrIzQvbbTQFH4Be5OZEf0x/ej4G+6
	 7P4KUU+4K6w/YLxiJEjThGg5ZCGXAgcHgDIRDzjQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fabio Estevam <festevam@denx.de>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 088/202] ARM: dts: imx1: Fix sram node
Date: Wed, 21 Feb 2024 14:06:29 +0100
Message-ID: <20240221125934.636478433@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125931.742034354@linuxfoundation.org>
References: <20240221125931.742034354@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fabio Estevam <festevam@denx.de>

[ Upstream commit c248e535973088ba7071ff6f26ab7951143450af ]

Per sram.yaml, address-cells, size-cells and ranges are mandatory.

The node name should be sram.

Change the node name and pass the required properties to fix the
following dt-schema warnings:

imx1-apf9328.dtb: esram@300000: $nodename:0: 'esram@300000' does not match '^sram(@.*)?'
	from schema $id: http://devicetree.org/schemas/sram/sram.yaml#
imx1-apf9328.dtb: esram@300000: '#address-cells' is a required property
	from schema $id: http://devicetree.org/schemas/sram/sram.yaml#
imx1-apf9328.dtb: esram@300000: '#size-cells' is a required property
	from schema $id: http://devicetree.org/schemas/sram/sram.yaml#
imx1-apf9328.dtb: esram@300000: 'ranges' is a required property
	from schema $id: http://devicetree.org/schemas/sram/sram.yaml#

Signed-off-by: Fabio Estevam <festevam@denx.de>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/imx1.dtsi | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/imx1.dtsi b/arch/arm/boot/dts/imx1.dtsi
index 2b6e77029de4..8c4c7464b133 100644
--- a/arch/arm/boot/dts/imx1.dtsi
+++ b/arch/arm/boot/dts/imx1.dtsi
@@ -268,9 +268,12 @@
 			status = "disabled";
 		};
 
-		esram: esram@300000 {
+		esram: sram@300000 {
 			compatible = "mmio-sram";
 			reg = <0x00300000 0x20000>;
+			ranges = <0 0x00300000 0x20000>;
+			#address-cells = <1>;
+			#size-cells = <1>;
 		};
 	};
 };
-- 
2.43.0



