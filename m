Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FAA8168AD
	for <patches@lists.linux.dev>; Mon,  8 May 2023 10:26:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAA3FC433A0;
	Mon,  8 May 2023 10:26:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683541561;
	bh=N7Otzb3vKDEs95nXGMMYN1FSpF+JLCgN5hMTbGsyMqE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mmsPV9GCjxKcXlV9ymlNTVPDwld2sNgsYMznGguW0SLPbhMEyn1qDUIL3IHo2cw3B
	 R2rJhxbdvlqr7uWvc+cCN1hV1RPerTB6or0Ol1BTfopg2ohh0dYYsvI/P4Bzz7Qny5
	 Vv0UDOTWgN+qAgpHJEvaVl5Aog3H4PHzVdx6ln0o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 154/663] arm64: dts: broadcom: bcmbca: bcm4908: fix NAND interrupt name
Date: Mon,  8 May 2023 11:39:40 +0200
Message-Id: <20230508094433.501083566@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094428.384831245@linuxfoundation.org>
References: <20230508094428.384831245@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Rafał Miłecki <rafal@milecki.pl>

[ Upstream commit 5cca02449490e767289bda38db1577e2c375c084 ]

This fixes:
arch/arm64/boot/dts/broadcom/bcmbca/bcm94908.dtb: nand-controller@1800: interrupt-names:0: 'nand_ctlrdy' was expected
        From schema: Documentation/devicetree/bindings/mtd/brcm,brcmnand.yaml
arch/arm64/boot/dts/broadcom/bcmbca/bcm94908.dtb: nand-controller@1800: Unevaluated properties are not allowed ('interrupt-names' was unexpected)
        From schema: Documentation/devicetree/bindings/mtd/brcm,brcmnand.yaml

Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
Link: https://lore.kernel.org/all/20230228144400.21689-1-zajec5@gmail.com/
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/broadcom/bcmbca/bcm4908.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/broadcom/bcmbca/bcm4908.dtsi b/arch/arm64/boot/dts/broadcom/bcmbca/bcm4908.dtsi
index eb2a78f4e0332..af5dc04aa1878 100644
--- a/arch/arm64/boot/dts/broadcom/bcmbca/bcm4908.dtsi
+++ b/arch/arm64/boot/dts/broadcom/bcmbca/bcm4908.dtsi
@@ -538,7 +538,7 @@
 			reg = <0x1800 0x600>, <0x2000 0x10>;
 			reg-names = "nand", "nand-int-base";
 			interrupts = <GIC_SPI 37 IRQ_TYPE_LEVEL_HIGH>;
-			interrupt-names = "nand";
+			interrupt-names = "nand_ctlrdy";
 			status = "okay";
 
 			nandcs: nand@0 {
-- 
2.39.2



