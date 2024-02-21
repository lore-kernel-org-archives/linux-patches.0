Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5EDA7EEE2;
	Wed, 21 Feb 2024 13:35:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708522543; cv=none; b=sV2GK3PuWYNUiCDjzKbw33CyzA0rbX2+odllMTLr0I2uDj6cW+OrZpPQPuymIxqS2+8X7HFAG0GHF72K0obZxRaOEEOoltTY6958/IRVFc4GrWO6Akiuzg+Dj38VemvItb16mZq0k2LDG3HaoZeRAaA3XCKlxjcSEFYbORUX/dI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708522543; c=relaxed/simple;
	bh=mDMkqC+Nhj7B5BhUAvU3WhzXk0AxVk0TFBecsFaIe3Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aX7tipFl/3VZlc8JdzAj6FsVAgxRSHeiMvxnEEDIAjivbt4neKkJbI8MPz5kVpX5dMlCCjX2xofzaF+3QMSQgN7tznovRcaE7bdnXgL7/DmWO4xz2x/dH1KMULvSvgQUdUqmnP5bQU1cOEsKsdCM7YU3RAdQwUk5SUWWa8rmFok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cfhjw1ip; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cfhjw1ip"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15E84C433C7;
	Wed, 21 Feb 2024 13:35:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708522543;
	bh=mDMkqC+Nhj7B5BhUAvU3WhzXk0AxVk0TFBecsFaIe3Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cfhjw1ippjZkto2xs3CbEcRv1+vx50Ypx06njgfZbJm3hUrGFTTuTXX/8T2GlSyNu
	 AA5aUe58d3Hn0nQL4+Hg1SN3MPJTzP8QUiexD9lrTOfLuVB4fvHsOudktS5Ep4FMMU
	 lYC3ubmK4udUSOR9fuy4YP6tqAkyL1X2suVOMF1g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fabio Estevam <festevam@denx.de>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 192/476] ARM: dts: imx23/28: Fix the DMA controller node name
Date: Wed, 21 Feb 2024 14:04:03 +0100
Message-ID: <20240221130015.012468571@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
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

From: Fabio Estevam <festevam@denx.de>

[ Upstream commit 858d83ca4b50bbc8693d95cc94310e6d791fb2e6 ]

Per fsl,mxs-dma.yaml, the node name should be 'dma-controller'.

Change it to fix the following dt-schema warning.

imx28-apf28.dtb: dma-apbx@80024000: $nodename:0: 'dma-apbx@80024000' does not match '^dma-controller(@.*)?$'
	from schema $id: http://devicetree.org/schemas/dma/fsl,mxs-dma.yaml#

Signed-off-by: Fabio Estevam <festevam@denx.de>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/imx23.dtsi | 2 +-
 arch/arm/boot/dts/imx28.dtsi | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/imx23.dtsi b/arch/arm/boot/dts/imx23.dtsi
index ce3d6360a7ef..b236d23f8071 100644
--- a/arch/arm/boot/dts/imx23.dtsi
+++ b/arch/arm/boot/dts/imx23.dtsi
@@ -414,7 +414,7 @@
 				status = "disabled";
 			};
 
-			dma_apbx: dma-apbx@80024000 {
+			dma_apbx: dma-controller@80024000 {
 				compatible = "fsl,imx23-dma-apbx";
 				reg = <0x80024000 0x2000>;
 				interrupts = <7 5 9 26
diff --git a/arch/arm/boot/dts/imx28.dtsi b/arch/arm/boot/dts/imx28.dtsi
index 10eab221bc05..7fcc0d35d31c 100644
--- a/arch/arm/boot/dts/imx28.dtsi
+++ b/arch/arm/boot/dts/imx28.dtsi
@@ -992,7 +992,7 @@
 				status = "disabled";
 			};
 
-			dma_apbx: dma-apbx@80024000 {
+			dma_apbx: dma-controller@80024000 {
 				compatible = "fsl,imx28-dma-apbx";
 				reg = <0x80024000 0x2000>;
 				interrupts = <78 79 66 0
-- 
2.43.0



