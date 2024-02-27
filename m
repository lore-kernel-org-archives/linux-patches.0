Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 683D91482EE;
	Tue, 27 Feb 2024 14:30:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709044225; cv=none; b=KZhImgxv4D/70099n612trsbS8UefOXBU/QxmCIOrUIUGO0EGwRTHIjVXTuKTV0zFpqvOcUpfiWFJgtI6m6TCsH2GE0y3enwhddKvgA+SnKZCsK7HElthnjwdpNcYoCIMEGVzwcRWRRE3MDk3koz9fc5l9bsxbjNAuIJkWj+fgQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709044225; c=relaxed/simple;
	bh=tvuoUv+CvljkWH3wcGmJ/6kCmI6ulCcN/0ajo+38yIY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lD3biCNctHfSUmDAZvnYPDYUZfi68WIJmqO9pHUCaECTnwLxv0sVz5Q+Eb/WzN3OzxrdoflUchTSdJFbVP9FMUD5jL/d4cdmJ2nthAeBlEgCNTfOBZu14ZspCsJexyMc4NL0Sqo8Wh6xkzHqpFK8YqxcV1bB36CPWydiupJL8zY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1EBhc4To; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1EBhc4To"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCB4BC433F1;
	Tue, 27 Feb 2024 14:30:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709044225;
	bh=tvuoUv+CvljkWH3wcGmJ/6kCmI6ulCcN/0ajo+38yIY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1EBhc4Tod8TQgtMSxhGrU4q81yKbcmaBtOEHlNrp2zyN1IJXgLciKY5DEw/EXtOSF
	 Jjy3fYH9nwbHRN4hASPOtu4D3XhrZcued4nIYxdfLUkg4qWqCHGeJRdFJTuAs3WSk7
	 nmPmL3H0aGV35il9OYXipHj75Sp0CSVuZa5/KpzA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiko Stuebner <heiko.stuebner@cherry.de>,
	Quentin Schulz <quentin.schulz@theobroma-systems.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 100/122] arm64: dts: rockchip: set num-cs property for spi on px30
Date: Tue, 27 Feb 2024 14:27:41 +0100
Message-ID: <20240227131601.973467549@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131558.694096204@linuxfoundation.org>
References: <20240227131558.694096204@linuxfoundation.org>
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

From: Heiko Stuebner <heiko.stuebner@cherry.de>

[ Upstream commit 334bf0710c98d391f4067b72f535d6c4c84dfb6f ]

The px30 has two spi controllers with two chip-selects each.
The num-cs property is specified as the total number of chip
selects a controllers has and is used since 2020 to find uses
of chipselects outside that range in the Rockchip spi driver.

Without the property set, the default is 1, so spi devices
using the second chipselect will not be created.

Fixes: eb1262e3cc8b ("spi: spi-rockchip: use num-cs property and ctlr->enable_gpiods")
Signed-off-by: Heiko Stuebner <heiko.stuebner@cherry.de>
Reviewed-by: Quentin Schulz <quentin.schulz@theobroma-systems.com>
Link: https://lore.kernel.org/r/20240119101656.965744-1-heiko@sntech.de
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/px30.dtsi | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/boot/dts/rockchip/px30.dtsi b/arch/arm64/boot/dts/rockchip/px30.dtsi
index 0d6761074b11a..f241e7c318bcd 100644
--- a/arch/arm64/boot/dts/rockchip/px30.dtsi
+++ b/arch/arm64/boot/dts/rockchip/px30.dtsi
@@ -577,6 +577,7 @@
 		clock-names = "spiclk", "apb_pclk";
 		dmas = <&dmac 12>, <&dmac 13>;
 		dma-names = "tx", "rx";
+		num-cs = <2>;
 		pinctrl-names = "default";
 		pinctrl-0 = <&spi0_clk &spi0_csn &spi0_miso &spi0_mosi>;
 		#address-cells = <1>;
@@ -592,6 +593,7 @@
 		clock-names = "spiclk", "apb_pclk";
 		dmas = <&dmac 14>, <&dmac 15>;
 		dma-names = "tx", "rx";
+		num-cs = <2>;
 		pinctrl-names = "default";
 		pinctrl-0 = <&spi1_clk &spi1_csn0 &spi1_csn1 &spi1_miso &spi1_mosi>;
 		#address-cells = <1>;
-- 
2.43.0



