Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 802841863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 15:06:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D745AC433EF;
	Wed, 28 Dec 2022 15:06:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672239981;
	bh=E94tIr8VF5Gcq9Jt72HTq+kB9HuTQbiSzV3P+XEg5Ak=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A+G5PgEf/uUtK8cHDjsoruF83xUBoOHWuLgVvQhVanOjmHAyiOE39YuDRETwFFu8D
	 GY4Y+6Y2HsAdi3PE5oj7Ornbb40BAelhg7p5tcGPAsJ5LmKUnWHJvlscfC5SJ89TVk
	 Aa9AjwxPjACs0bd8wFC4P3VUZDfGT9pzI7r6wWd8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Conor Dooley <conor.dooley@microchip.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0067/1146] riscv: dts: microchip: remove pcie node from the sev kit
Date: Wed, 28 Dec 2022 15:26:46 +0100
Message-Id: <20221228144331.977463313@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Conor Dooley <conor.dooley@microchip.com>

[ Upstream commit 1150f4cff831e1d7db673417bcb81833d6544cf8 ]

The SEV kit reference design does not hook up the PCIe root port to the
core complex including it is misleading.
The entry is a re-use mistake - I was not aware of this when I moved
the PCIe node out of mpfs.dtsi so that individual bistreams could
connect it to different fics etc.

The node is disabled, so there should be no functional change here.

Fixes: 978a17d1a688 ("riscv: dts: microchip: add sevkit device tree")
Signed-off-by: Conor Dooley <conor.dooley@microchip.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../dts/microchip/mpfs-sev-kit-fabric.dtsi    | 29 -------------------
 1 file changed, 29 deletions(-)

diff --git a/arch/riscv/boot/dts/microchip/mpfs-sev-kit-fabric.dtsi b/arch/riscv/boot/dts/microchip/mpfs-sev-kit-fabric.dtsi
index 8545baf4d129..39a77df489ab 100644
--- a/arch/riscv/boot/dts/microchip/mpfs-sev-kit-fabric.dtsi
+++ b/arch/riscv/boot/dts/microchip/mpfs-sev-kit-fabric.dtsi
@@ -13,33 +13,4 @@ fabric_clk1: fabric-clk1 {
 		#clock-cells = <0>;
 		clock-frequency = <125000000>;
 	};
-
-	pcie: pcie@2000000000 {
-		compatible = "microchip,pcie-host-1.0";
-		#address-cells = <0x3>;
-		#interrupt-cells = <0x1>;
-		#size-cells = <0x2>;
-		device_type = "pci";
-		reg = <0x20 0x0 0x0 0x8000000>, <0x0 0x43000000 0x0 0x10000>;
-		reg-names = "cfg", "apb";
-		bus-range = <0x0 0x7f>;
-		interrupt-parent = <&plic>;
-		interrupts = <119>;
-		interrupt-map = <0 0 0 1 &pcie_intc 0>,
-				<0 0 0 2 &pcie_intc 1>,
-				<0 0 0 3 &pcie_intc 2>,
-				<0 0 0 4 &pcie_intc 3>;
-		interrupt-map-mask = <0 0 0 7>;
-		clocks = <&fabric_clk1>, <&fabric_clk1>, <&fabric_clk3>;
-		clock-names = "fic0", "fic1", "fic3";
-		ranges = <0x3000000 0x0 0x8000000 0x20 0x8000000 0x0 0x80000000>;
-		msi-parent = <&pcie>;
-		msi-controller;
-		status = "disabled";
-		pcie_intc: interrupt-controller {
-			#address-cells = <0>;
-			#interrupt-cells = <1>;
-			interrupt-controller;
-		};
-	};
 };
-- 
2.35.1



