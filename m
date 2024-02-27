Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8467E13A259;
	Tue, 27 Feb 2024 14:10:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709043033; cv=none; b=Y7DgrbUod3btjZfhFf3ZDYf5HyFS0ZldlNXZOGOJJIGFdXLG1zxkfxf+rSw+93iY/hLNgsqmP3wfE0WAGSzAwIJwEVkvBMnQlTfWB9p4s0TxeAqZ5X5LZIGaSm2ejYEtaFRetEg1hdaxdR5fl6j1A8+92MvNcn7r/7Eped2tqAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709043033; c=relaxed/simple;
	bh=ktVG5eetdJ+o7oxozaWYj3Cena4OqKPyHTRTiFXM0VM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jc9t7z308VyXS68+T8WucNgP6YfTULnLWgOy/u/fA/7HVWOz+y1r/uU06MfaPqMmCoxdLi+C2PNMlwa5df+RndweN7IMQ7eQ4SjiXIzcjzpMDjEWcf5X/ZdIe35uhc1h5OluDppgLCwqO8DlbX//krCGZfh1Qy/0hgQRwRL9EPg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yeSHjkr8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yeSHjkr8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEA46C43394;
	Tue, 27 Feb 2024 14:10:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709043033;
	bh=ktVG5eetdJ+o7oxozaWYj3Cena4OqKPyHTRTiFXM0VM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yeSHjkr87PJ9eV/GcGjC9WZJGVtNB4gNynzYG3zwua2nxtADmZ9Q6O5x1jOap67Dj
	 99bFs9v1iVmkheKM+QGH1vIL1izqMnxSCm27aAn4ZjDtjvbUPtY4k53alP0ujoaKmC
	 M75YCxzw0lvbygMO4aWYqJ3AQVccKRof7K6fNSwM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiko Stuebner <heiko.stuebner@cherry.de>,
	Quentin Schulz <quentin.schulz@theobroma-systems.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 209/245] arm64: dts: rockchip: set num-cs property for spi on px30
Date: Tue, 27 Feb 2024 14:26:37 +0100
Message-ID: <20240227131621.981424349@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131615.098467438@linuxfoundation.org>
References: <20240227131615.098467438@linuxfoundation.org>
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
index 5200d0bbd9e9c..b2dae28a98502 100644
--- a/arch/arm64/boot/dts/rockchip/px30.dtsi
+++ b/arch/arm64/boot/dts/rockchip/px30.dtsi
@@ -585,6 +585,7 @@
 		clock-names = "spiclk", "apb_pclk";
 		dmas = <&dmac 12>, <&dmac 13>;
 		dma-names = "tx", "rx";
+		num-cs = <2>;
 		pinctrl-names = "default";
 		pinctrl-0 = <&spi0_clk &spi0_csn &spi0_miso &spi0_mosi>;
 		#address-cells = <1>;
@@ -600,6 +601,7 @@
 		clock-names = "spiclk", "apb_pclk";
 		dmas = <&dmac 14>, <&dmac 15>;
 		dma-names = "tx", "rx";
+		num-cs = <2>;
 		pinctrl-names = "default";
 		pinctrl-0 = <&spi1_clk &spi1_csn0 &spi1_csn1 &spi1_miso &spi1_mosi>;
 		#address-cells = <1>;
-- 
2.43.0



