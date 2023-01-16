Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 213F646B5
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 16:09:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97D2FC433D2;
	Mon, 16 Jan 2023 16:09:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673885399;
	bh=VkOGQVvq00v0ywfBoPAG3BZ/xYbbBHq6n1fF/NSG7m0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xjYqP9EI3vU95J+mWeIP6+BZO3P/2mPUAHugJkE/Xb/5z+Ub9BN5fOzI/xhQ/mDDC
	 UzoqKWm22aaPmAgfKoFPztdIH6t/jhqvYg4+kymi+oYSgjCJQ2q8C2NSudNDW1ULg1
	 84figLucDE2itRt2wPBslXMq4WVWYc3o3iw+CF0k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
	Gregory CLEMENT <gregory.clement@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 037/658] ARM: dts: dove: Fix assigned-addresses for every PCIe Root Port
Date: Mon, 16 Jan 2023 16:42:05 +0100
Message-Id: <20230116154911.316737312@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154909.645460653@linuxfoundation.org>
References: <20230116154909.645460653@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Pali Rohár <pali@kernel.org>

[ Upstream commit dcc7d8c72b64a479b8017e4332d99179deb8802d ]

BDF of resource in DT assigned-addresses property of Marvell PCIe Root Port
(PCI-to-PCI bridge) should match BDF in address part in that DT node name
as specified resource belongs to Marvell PCIe Root Port itself.

Fixes: 74ecaa403a74 ("ARM: dove: add PCIe controllers to SoC DT")
Signed-off-by: Pali Rohár <pali@kernel.org>
Signed-off-by: Gregory CLEMENT <gregory.clement@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/dove.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/dove.dtsi b/arch/arm/boot/dts/dove.dtsi
index 2e8a3977219f..347624ea96cd 100644
--- a/arch/arm/boot/dts/dove.dtsi
+++ b/arch/arm/boot/dts/dove.dtsi
@@ -129,7 +129,7 @@ pcie0: pcie@1 {
 			pcie1: pcie@2 {
 				device_type = "pci";
 				status = "disabled";
-				assigned-addresses = <0x82002800 0 0x80000 0 0x2000>;
+				assigned-addresses = <0x82001000 0 0x80000 0 0x2000>;
 				reg = <0x1000 0 0 0 0>;
 				clocks = <&gate_clk 5>;
 				marvell,pcie-port = <1>;
-- 
2.35.1



