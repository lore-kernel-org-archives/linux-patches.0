Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B58012B176;
	Tue, 30 Apr 2024 11:02:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714474927; cv=none; b=tIQ+uF8Cqf8xzK092TzseU5uO2tMHoUVUwWgRv0JgI9pKbYn1SSvybzpn+bfUtAyOjzlyT4tQx5xIj9xz/WkJnkNbOCAZ4JsUz+Bz5hnYkQfv0cwX/hdhUPeKtjh1do577+cIZMEGsZWxLE/O5MxInRE/OtCkUG+1sDdmy6PCoE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714474927; c=relaxed/simple;
	bh=0d/iwT6mTbtvXcAg7UR7t4v2nH+r5rnd04bCOLt8KAQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j3Vu2BNjuJnht2uqUnpRimI2qYIpWIZUWI8C/PEJY+g3V182shKb4uXPtEe6Vg83z6TYzjB6nY4TNA/+07m1Y1CE4bM18lGHW2VvlvYzbJALPatFFm4lZdZuJedUiC5Dq6WTyCFVmH0gFMrobOg8M02gf7fRAZ4bfwEcRjGWiRE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XmrgKaHW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XmrgKaHW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 865B1C4AF18;
	Tue, 30 Apr 2024 11:02:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714474926;
	bh=0d/iwT6mTbtvXcAg7UR7t4v2nH+r5rnd04bCOLt8KAQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XmrgKaHWn+af7Bemfzq9XyKW3Sky0VnBxshxwXXF3TIEE56uD2Qylk0ABx4qttxmb
	 XtXMSkndqEfxyDwOgQO3ScuV2JGvAUKhJtWh3hoeZyJMtk7F9MZSngwsKZ3Ngi+Jq4
	 jQt0HnNvRS6po6ekNgXfG1s9/PNQjZr9le9GIaGw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 077/138] arm64: dts: mediatek: mt7622: introduce nodes for Wireless Ethernet Dispatch
Date: Tue, 30 Apr 2024 12:39:22 +0200
Message-ID: <20240430103051.692592901@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103049.422035273@linuxfoundation.org>
References: <20240430103049.422035273@linuxfoundation.org>
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
index 07b4d3ba55612..ab218229b7ea1 100644
--- a/arch/arm64/boot/dts/mediatek/mt7622.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt7622.dtsi
@@ -893,6 +893,11 @@
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
@@ -911,6 +916,26 @@
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
@@ -938,6 +963,9 @@
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



