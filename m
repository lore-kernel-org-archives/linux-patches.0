Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1E611118B;
	Sat,  3 Feb 2024 04:16:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933801; cv=none; b=UsaWi0zi0XBtCWy4sLO0QZZI6hOlvkZtVEQxuKlWjtg/P9D7h9MfH2pQ6Ek/bgkfJX8fOj38HPkCJpyB/yAb0xF7m4jHFgKPZqLgb1nxwbz1AkJSsaMXiAv6av+KQay9e6Kh47U26jddsbGbWqI48P3VVt1Gxvwj18Z8SDGllHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933801; c=relaxed/simple;
	bh=DiR5lg7hy4eylnIeejvjhofWdaaI4cJN2Nslfkvcez8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CSMT2SBofDsGxQrJ/iIDbLZx8KjWUpHNlF8i/EG0wN6Gq0scvYgOCqMgaMmWs5mTZiNuvAFLBNR92wsMpGwqJpkUTKEkHvUtzWxO2+TwGOYowtJZKDAhpriM7I+VaFTSVb+sr2glLQNFIKJjbIhOLu3RlYqYYzetukd1c1QNWp4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e3YnoeiP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e3YnoeiP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B37BC43390;
	Sat,  3 Feb 2024 04:16:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933801;
	bh=DiR5lg7hy4eylnIeejvjhofWdaaI4cJN2Nslfkvcez8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e3YnoeiPOVB3do4r+bioXoOfNDFp6QVmwbGWGME0jsfg6FF/fI7sp802N6nvu4anM
	 YeZ44nY0GbIF1Iga4YHD0D3CaKOZVK09oSSvlhdDYO/K3w58pGiQX3xknXbTHXiFD6
	 oA+AYOzbU5K9PNalmcW16gVdBzuqPW/hkPCsHSIc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Stein <alexander.stein@ew.tq-group.com>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 089/353] ARM: dts: imx7s: Fix nand-controller #size-cells
Date: Fri,  2 Feb 2024 20:03:27 -0800
Message-ID: <20240203035406.618233980@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035403.657508530@linuxfoundation.org>
References: <20240203035403.657508530@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
index 3bd33255266e..4569d2b8edef 100644
--- a/arch/arm/boot/dts/nxp/imx/imx7s.dtsi
+++ b/arch/arm/boot/dts/nxp/imx/imx7s.dtsi
@@ -1279,7 +1279,7 @@
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



