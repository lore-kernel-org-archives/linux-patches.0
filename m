Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1654679DAE;
	Wed, 21 Feb 2024 14:03:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708524197; cv=none; b=eCKtq1Y68McYV3gETxfG5kfMLcdZfNWSPI4SSTncoXiph4k7uIHUfcJlERSiCi1yZ8lCvJFss19rSXyoG4SZl9NLAL0z80bYGqUf+zuCEAaZ3jFfoU1O5R0gMkYkB/2ZY0PF6DIKCT8MRvO+YsmGBjRc5pzT1gXrWKuYCcZWvbo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708524197; c=relaxed/simple;
	bh=hSyROmg61W4hMOY4e/Ih1FVamFq+tmlx5Cwy06vvor4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j3KFQ0+03/cycXEbd2ug863K2nEgWk52bT56HLTZn8oU15tGGs1JZfKP6BXAbDKBmBfMInRwadmto781pAUtriAKCe6uEE0PcSyQFDWXUI/a9rCNMQ0qanx79JlfMMaUU6csUZQSzeVCFGoqBKYDjJaH7HZKxHwTdFHLSSA3F2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=crop6bKi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="crop6bKi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A070C43390;
	Wed, 21 Feb 2024 14:03:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708524197;
	bh=hSyROmg61W4hMOY4e/Ih1FVamFq+tmlx5Cwy06vvor4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=crop6bKi1h0CRBkGNs1rt3zX83SMGr/5fEo/JoYcGBgXghDX857V0QPgDpt3fW0KH
	 QULUkULvyQRiuPtmnNVqyfwPtpIuZsoUcU6B0E3XnlcbkZsaAKa0rM5o6kY5Bryyte
	 mxHqxIKDNw4H757UFpAPr2cWI+PU+ilpa9MGDDhM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fabio Estevam <festevam@denx.de>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 156/379] ARM: dts: imx1: Fix sram node
Date: Wed, 21 Feb 2024 14:05:35 +0100
Message-ID: <20240221125959.533534944@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125954.917878865@linuxfoundation.org>
References: <20240221125954.917878865@linuxfoundation.org>
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
index 9b940987864c..8d6e900a9081 100644
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



