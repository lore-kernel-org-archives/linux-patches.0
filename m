Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24EF113DBB3;
	Tue, 27 Feb 2024 14:18:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709043528; cv=none; b=GKJ5I/Zv9cdhSzGgJPak52uxzcnBV+Ib2IMxkQEKaJc54P+xQxoAyL7ogrxa+fOAlv3jk7hBhjzdmFFaBVJ2hORpg4j/yTj3IAogiF7au1bQpzTFFbTDA296+T84huF6DECRH7r/MkTv05cfdWxW25CSfzcbkho5fwMHOk/fN88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709043528; c=relaxed/simple;
	bh=AoIQbTSLxz1LeWoI0WqdwmlXofzGk020ZByK2YVXidE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HBrVoYU2hxXW+LK6zjnP0tPRJKtaD9N1aeUj2IOAXIhtVP9Kqw0Fd/wR0D2Nu8ONuGnkEGQ96361XEWTf69K5wfDh9CPKxskb6apf2NTzdQ4dH9lnlAl7KsNIDtB7B+e1hlOzYHSpXUzkqpW/gjGia9MPWc5iuEdVIMk7xznLwQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c9U4AoxU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c9U4AoxU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E4EBC433C7;
	Tue, 27 Feb 2024 14:18:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709043528;
	bh=AoIQbTSLxz1LeWoI0WqdwmlXofzGk020ZByK2YVXidE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c9U4AoxUW13uhFJkqTBt5hLyVvZYvTFp4FZ6gGBhlbGVrWRhSGpz/uaKaSbCKKPTe
	 j12JI5GaUeedXZTaTO9Sng1i6Hom1Y+N00ik+ytjvBDz3gm5DefQw+i4OACURiaVmp
	 Z/JhAHLI27gJzgMHgs6LbaUZF9rmex1R+QQ2QYTU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiko Stuebner <heiko.stuebner@cherry.de>,
	Quentin Schulz <quentin.schulz@theobroma-systems.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 141/195] arm64: dts: rockchip: set num-cs property for spi on px30
Date: Tue, 27 Feb 2024 14:26:42 +0100
Message-ID: <20240227131615.086308556@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131610.391465389@linuxfoundation.org>
References: <20240227131610.391465389@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index bfa3580429d10..61f0186447dad 100644
--- a/arch/arm64/boot/dts/rockchip/px30.dtsi
+++ b/arch/arm64/boot/dts/rockchip/px30.dtsi
@@ -607,6 +607,7 @@
 		clock-names = "spiclk", "apb_pclk";
 		dmas = <&dmac 12>, <&dmac 13>;
 		dma-names = "tx", "rx";
+		num-cs = <2>;
 		pinctrl-names = "default";
 		pinctrl-0 = <&spi0_clk &spi0_csn &spi0_miso &spi0_mosi>;
 		#address-cells = <1>;
@@ -622,6 +623,7 @@
 		clock-names = "spiclk", "apb_pclk";
 		dmas = <&dmac 14>, <&dmac 15>;
 		dma-names = "tx", "rx";
+		num-cs = <2>;
 		pinctrl-names = "default";
 		pinctrl-0 = <&spi1_clk &spi1_csn0 &spi1_csn1 &spi1_miso &spi1_mosi>;
 		#address-cells = <1>;
-- 
2.43.0



