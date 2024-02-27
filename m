Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27D9413B78F;
	Tue, 27 Feb 2024 13:41:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709041264; cv=none; b=ZyY9+I7lRxRoRvMcO7P2LNVtKV2TZobqzfGE9DK9Rp1GxlpVGRqXGM+t+XWW1ZwxO4d2Z2HpOCLBbEQHV08Ju8j7j9pzAJOYOpYz4tM/MyT8/HbGKqyRHlI6wx2xPm8H/CnNXGyHjtoYU1I8pUv+AKZfnsykpx+vP7IGsmOiZq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709041264; c=relaxed/simple;
	bh=YIJUsh/VEf1Tv72zqV1gqXkUScbmitfjk3py+tadAOM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=diml9fqgg2RIkqGQtkdqCIOMx317Be2NmCJc+uuZIpAUNn+JokX7chM0bViqJ9y0dHupEVh/NgMSmSvnv8yG7sSjuDvvzb4OzgAuW0OmM6qpuCiJWfx//HqHTk+r8a+5hVcOHxl5mI60ymAjxuLmxTNz6JCXe+IZlSw98SyeXyg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ajyzFcbx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ajyzFcbx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A31EBC433F1;
	Tue, 27 Feb 2024 13:41:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709041264;
	bh=YIJUsh/VEf1Tv72zqV1gqXkUScbmitfjk3py+tadAOM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ajyzFcbxSJOxBbNZ0XawsJQMNufi6y8MFTS+wcnNf9zSooqpBEuBCXVxKuxQlgwlf
	 DSKTYdo4/Gr6jwqySuRQmGORrs39TzTeA+vFJLSaQSYW7uRDYN8kqqYYnsguGZorAY
	 9/OtBkYj6c4au1MKa7R1uq0COdMu+DMMCcoHHJ5U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiko Stuebner <heiko.stuebner@cherry.de>,
	Quentin Schulz <quentin.schulz@theobroma-systems.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 249/334] arm64: dts: rockchip: set num-cs property for spi on px30
Date: Tue, 27 Feb 2024 14:21:47 +0100
Message-ID: <20240227131638.940208636@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131630.636392135@linuxfoundation.org>
References: <20240227131630.636392135@linuxfoundation.org>
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
index 42ce78beb4134..20955556b624d 100644
--- a/arch/arm64/boot/dts/rockchip/px30.dtsi
+++ b/arch/arm64/boot/dts/rockchip/px30.dtsi
@@ -632,6 +632,7 @@
 		clock-names = "spiclk", "apb_pclk";
 		dmas = <&dmac 12>, <&dmac 13>;
 		dma-names = "tx", "rx";
+		num-cs = <2>;
 		pinctrl-names = "default";
 		pinctrl-0 = <&spi0_clk &spi0_csn &spi0_miso &spi0_mosi>;
 		#address-cells = <1>;
@@ -647,6 +648,7 @@
 		clock-names = "spiclk", "apb_pclk";
 		dmas = <&dmac 14>, <&dmac 15>;
 		dma-names = "tx", "rx";
+		num-cs = <2>;
 		pinctrl-names = "default";
 		pinctrl-0 = <&spi1_clk &spi1_csn0 &spi1_csn1 &spi1_miso &spi1_mosi>;
 		#address-cells = <1>;
-- 
2.43.0



