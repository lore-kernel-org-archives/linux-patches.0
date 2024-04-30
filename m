Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D4E0211C;
	Tue, 30 Apr 2024 11:16:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714475765; cv=none; b=itWGQ3w4DqBmoHAWSeLfPRLuBypaOQ2rnxLwnZp1ZS5L3omQZ9d1K6h788DO6Ld4O+SsDoumDQYiZKgjQj5B/XzG9QVx4tprAOx3lUdQhR+TWlGY6ESwX3TROsVRSKY6bS3nbGBY8OHtR47GaRDkMGM4WaS32vxivgLLl0+BIA8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714475765; c=relaxed/simple;
	bh=6F5tmjA5CRXY5sVLeXtn/sB6Tz9CzlKfceX033SoZ+g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d2DuonU9atad19NT1BtO24ozvKv5LPr0asjBdf4Mtrfxpyiep16s1U442GZVj6Toddz0j+7OJvxGtRZlLWpeumhAM7y4ZYjRk5T70vBU79vRE4MQSjj5tobmxw/PqwtYOTukXnLurg9Uq2byZCr1xR0q5YDGdcNgSo8AGvghtFM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zrplhVQY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zrplhVQY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94461C2BBFC;
	Tue, 30 Apr 2024 11:16:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714475765;
	bh=6F5tmjA5CRXY5sVLeXtn/sB6Tz9CzlKfceX033SoZ+g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zrplhVQY/vHo+PdLZXYgB7cRTS1ZVkrDjCsrUPt97cZV9ElrH7FX4oD/utG2Wv/bE
	 CKGJ0goAqyrmBdfp8Tq2l6SaGScfo12KYlnn5b33TM1C9pOloumlDJSZk+9kzvY10n
	 a8jUEI0u09jGt1oSmCc5saW71vxQXE9o3pbANWOk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 11/80] arm64: dts: mediatek: mt7622: introduce nodes for Wireless Ethernet Dispatch
Date: Tue, 30 Apr 2024 12:39:43 +0200
Message-ID: <20240430103043.745012657@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103043.397234724@linuxfoundation.org>
References: <20240430103043.397234724@linuxfoundation.org>
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

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit e9b65ecb7c3050dd34ee22ce17f1cf95e8405b15 ]

Introduce wed0 and wed1 nodes in order to enable offloading forwarding
between ethernet and wireless devices on the mt7622 chipset.

Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 3ba5a6159434 ("arm64: dts: mediatek: mt7622: fix clock controllers")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/mediatek/mt7622.dtsi | 28 ++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/arch/arm64/boot/dts/mediatek/mt7622.dtsi b/arch/arm64/boot/dts/mediatek/mt7622.dtsi
index 8a332a3d3718a..636783511779a 100644
--- a/arch/arm64/boot/dts/mediatek/mt7622.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt7622.dtsi
@@ -894,6 +894,11 @@
 		};
 	};
 
+	hifsys: syscon@1af00000 {
+		compatible = "mediatek,mt7622-hifsys", "syscon";
+		reg = <0 0x1af00000 0 0x70>;
+	};
+
 	ethsys: syscon@1b000000 {
 		compatible = "mediatek,mt7622-ethsys",
 			     "syscon";
@@ -912,6 +917,26 @@
 		#dma-cells = <1>;
 	};
 
+	pcie_mirror: pcie-mirror@10000400 {
+		compatible = "mediatek,mt7622-pcie-mirror",
+			     "syscon";
+		reg = <0 0x10000400 0 0x10>;
+	};
+
+	wed0: wed@1020a000 {
+		compatible = "mediatek,mt7622-wed",
+			     "syscon";
+		reg = <0 0x1020a000 0 0x1000>;
+		interrupts = <GIC_SPI 214 IRQ_TYPE_LEVEL_LOW>;
+	};
+
+	wed1: wed@1020b000 {
+		compatible = "mediatek,mt7622-wed",
+			     "syscon";
+		reg = <0 0x1020b000 0 0x1000>;
+		interrupts = <GIC_SPI 215 IRQ_TYPE_LEVEL_LOW>;
+	};
+
 	eth: ethernet@1b100000 {
 		compatible = "mediatek,mt7622-eth",
 			     "mediatek,mt2701-eth",
@@ -939,6 +964,9 @@
 		mediatek,ethsys = <&ethsys>;
 		mediatek,sgmiisys = <&sgmiisys>;
 		mediatek,cci-control = <&cci_control2>;
+		mediatek,wed = <&wed0>, <&wed1>;
+		mediatek,pcie-mirror = <&pcie_mirror>;
+		mediatek,hifsys = <&hifsys>;
 		dma-coherent;
 		#address-cells = <1>;
 		#size-cells = <0>;
-- 
2.43.0



