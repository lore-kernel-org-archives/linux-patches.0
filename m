Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018227;
	b=isrJkNxYF4ZJKj1qMCnFFvEu313+pQli95itO37VaHWM6DJTxWtHJ6IEUwRf/wAPdfyd
	 oala9QIeWB2ryYG4jhdj4/wY6CgPzBNjhvBRlSph54go3nYE4Airnsa7XYBKuxQGdr04X
	 BaPCYhxlGu3Jk9Rz719qhcPrz9CahJWQKzvFfADD/RZW1rx1mt8oq2kWQ5U031wYKXZbL
	 glMA4Uw4myWA9HyzeGxkxsp9Zghd0hTOyeSSFBC6i0xWkzXfIj3p2wteL/uzqlyqtZpNa
	 YWODeHtBXVZUlzgdp+JsGrOa1foSDcc8lhgvwnNcnXbS6stgrMZFQ3HhV9YNrfrL2uw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018227;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=AheosJinlzLv+JtDPKqeaqWcqTeWlMCMAPfx6einJxY=;
	b=XQ5b+beeGp96xPPOpBqyL8m1O5gLhyIo32f6UKN6/vocO95zBCePbaFAzXN0b1GtgbOA
	 QQO+5dUi2h71U+hheuTVSMJzX8Pm+v6Hzjpcq2ixXQOg8+ls6MQi1sP5wlC9EpejuoD0y
	 IyFvWFTTj/Na+/z7HVYMQwNOr67AHK5bvpOugeVdQTunxgUUyDAYKX1XBi1LldXRZwq/e
	 dr1bT2OqyPnOLGszx3l5x/M+KMy1BsL/oZvYcq6hGaGVCHBc+HeFiXJ2zIU9dP1dUbtaS
	 yj/Nc2tOCYYlUXQ/vk0pdIOf4WF4YWzkWo8sm4R6vnYXUruceaT6SuROzDP1CTpODVA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sKibfbL8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FA50606A334;
	Wed, 18 Nov 2026 16:10:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sKibfbL8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0C3A1F000C4;
	Wed, 18 Nov 2026 16:10:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018227;
	bh=AheosJinlzLv+JtDPKqeaqWcqTeWlMCMAPfx6einJxY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sKibfbL83X3315Yopu71nUQhP5VWEl9wEwevSmkoIVsq5zZmZ+w59LGV2qo+idWeF
	 A1wX1sMd3amkJ2LlDul6e1czBvcVBBS5m3OIz1wSPQ20QiTa/ySl2QJpw3hltbHmnn
	 jUcqgPdGVrziv7h5gpuWjF6BwdTqKoaY6UistUN4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Inochi Amaoto <inochiama@gmail.com>,
	Aurelien Jarno <aurelien@aurel32.net>,
	Yixun Lan <dlan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1164/2651] riscv: dts: spacemit: k3: move USB3 phy to board level
Date: Wed, 18 Nov 2026 15:40:04 +0100
Message-ID: <20261118150329.918220646@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aurelien Jarno <aurelien@aurel32.net>

[ Upstream commit a87ca1e5b5d28dee5af42f59f3c6f833c5ad1da0 ]

On the SpacemiT K3 SoC, the combo phy provides 8 lines that can
either be used for PCIe or USB3, depending on its configuration
(spacemit,apmu). This configuration is defined at the board level, and
assigning a phy line to a USB3 controller while it is configured as PCIe
results in an "Invalid PHY mode" error.

Move the USB phy definitions at the board level, as it is done for the
submitted PCIe controller [1]. As a consequence, boards that do not
enable a USB3 controller node will not match the DT schema due to
missing PHY entries. This is not an issue as dtbs_check only validates
enabled nodes.

[1] https://lore.kernel.org/spacemit/20260923015016.64069-1-inochiama@gmail.com

Fixes: 46380e4b1534 ("riscv: dts: spacemit: k3: add USB controller and USB phy support")
Cc: Inochi Amaoto <inochiama@gmail.com>
Signed-off-by: Aurelien Jarno <aurelien@aurel32.net>
Reviewed-by: Yixun Lan <dlan@kernel.org>
Link: https://patch.msgid.link/20260928205012.3689405-2-aurelien@aurel32.net
Signed-off-by: Yixun Lan <dlan@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/boot/dts/spacemit/k3-pico-itx.dts | 2 ++
 arch/riscv/boot/dts/spacemit/k3.dtsi         | 3 ---
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/riscv/boot/dts/spacemit/k3-pico-itx.dts b/arch/riscv/boot/dts/spacemit/k3-pico-itx.dts
index b084a35aa00e3..0a6f669d509a9 100644
--- a/arch/riscv/boot/dts/spacemit/k3-pico-itx.dts
+++ b/arch/riscv/boot/dts/spacemit/k3-pico-itx.dts
@@ -328,5 +328,7 @@ &usb3d_u2phy {
 };
 
 &usb3d {
+	phys = <&usb3d_u2phy>, <&combophy 4 PHY_TYPE_USB3>;
+	phy-names = "usb2-phy", "usb3-phy";
 	status = "okay";
 };
diff --git a/arch/riscv/boot/dts/spacemit/k3.dtsi b/arch/riscv/boot/dts/spacemit/k3.dtsi
index 86ccfb82e295c..b8c3fe5dbaa80 100644
--- a/arch/riscv/boot/dts/spacemit/k3.dtsi
+++ b/arch/riscv/boot/dts/spacemit/k3.dtsi
@@ -452,9 +452,6 @@ usb3d: usb@81a00000 {
 				 <&syscon_apmu RESET_APMU_USB3_D_VCC>,
 				 <&syscon_apmu RESET_APMU_USB3_D_PHY>;
 			reset-names = "ahb", "vcc", "phy";
-			phys = <&usb3d_u2phy>,
-			       <&combophy 4 PHY_TYPE_USB3>;
-			phy-names = "usb2-phy", "usb3-phy";
 			phy_type = "utmi";
 			snps,dis_enblslpm_quirk;
 			snps,dis_u2_susphy_quirk;
-- 
2.53.0



