Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDF5428ED
	for <patches@lists.linux.dev>; Mon, 12 Dec 2022 13:27:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EBF4C433EF;
	Mon, 12 Dec 2022 13:27:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1670851642;
	bh=YQ/0GsNfBgxYaNPE7beSyGgE2iIyKK5zr2JLwJQ8tx8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eeGMQo0bREhIQE8/rj3eCbh9KnJUQAkzJ5wDIRNclF0MX50cM9kMQLe1OY+/OVCXu
	 hXY3S7fbW0jVTnECupdSA1mjGD0b9lQHTJ0zqXIYk3rPBjQNOB1f11XDUfaYz9hXei
	 rldnRCvgPkclddcbbf6uMku8J12RdAIW+ZncRIwE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Francesco Dolcini <francesco.dolcini@toradex.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Marek Vasut <marex@denx.de>,
	Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 5.15 041/123] Revert "ARM: dts: imx7: Fix NAND controller size-cells"
Date: Mon, 12 Dec 2022 14:16:47 +0100
Message-Id: <20221212130928.639530525@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221212130926.811961601@linuxfoundation.org>
References: <20221212130926.811961601@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Francesco Dolcini <francesco.dolcini@toradex.com>

commit ef19964da8a668c683f1d38274f6fb756e047945 upstream.

This reverts commit 753395ea1e45c724150070b5785900b6a44bd5fb.

It introduced a boot regression on colibri-imx7, and potentially any
other i.MX7 boards with MTD partition list generated into the fdt by
U-Boot.

While the commit we are reverting here is not obviously wrong, it fixes
only a dt binding checker warning that is non-functional, while it
introduces a boot regression and there is no obvious fix ready.

Fixes: 753395ea1e45 ("ARM: dts: imx7: Fix NAND controller size-cells")
Signed-off-by: Francesco Dolcini <francesco.dolcini@toradex.com>
Reviewed-by: Miquel Raynal <miquel.raynal@bootlin.com>
Acked-by: Marek Vasut <marex@denx.de>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/all/Y4dgBTGNWpM6SQXI@francesco-nb.int.toradex.com/
Link: https://lore.kernel.org/all/20221205144917.6514168a@xps-13/
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/boot/dts/imx7s.dtsi |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/arm/boot/dts/imx7s.dtsi
+++ b/arch/arm/boot/dts/imx7s.dtsi
@@ -1252,10 +1252,10 @@
 			clocks = <&clks IMX7D_NAND_USDHC_BUS_RAWNAND_CLK>;
 		};
 
-		gpmi: nand-controller@33002000 {
+		gpmi: nand-controller@33002000{
 			compatible = "fsl,imx7d-gpmi-nand";
 			#address-cells = <1>;
-			#size-cells = <0>;
+			#size-cells = <1>;
 			reg = <0x33002000 0x2000>, <0x33004000 0x4000>;
 			reg-names = "gpmi-nand", "bch";
 			interrupts = <GIC_SPI 14 IRQ_TYPE_LEVEL_HIGH>;


