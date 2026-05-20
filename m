Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A7F63FD126;
	Wed, 20 May 2026 18:44:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779302655; cv=none; b=sqY/5JwVL23vF0UxHJG0k6CrbY+0KIj7v5M+nkAp93kIJBAYW++V4ILxfWqqmhsd7P81lirdog69nXmvVxa7c3oNQgH0QPzCUGfe9Aep+ov8alkUI2GZ74g5f5oywNrQPhWle9VLMa9uuikXzasdknYKGAIpljdoID5MZlpF+ig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779302655; c=relaxed/simple;
	bh=V1jRKmh2pT7Kxu9s6VTuywyr7gjkQ0eMYDCm/ivt5xo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VNJofo3b7X+rYJG4vMVhJOkUw6++/wQMk3PL83C+Ol+kqozsqIx7ZJrCMzIJKaKo4gFyLVzRlzrXHJGghUVt9wH5hDJ+i197K+N0gmt7MIgrUr/Un6MR0ZNB9qWSW9jBO0LDJhpS3LuWoQobH0oB46Z5RnJ6EVOAKu/ROn1eiGE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X9X1dvzw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X9X1dvzw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 701A21F000E9;
	Wed, 20 May 2026 18:44:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779302653;
	bh=K+LB1tvbeCYq4v5ISxIFYcEDs2rvF24mWSfF4w5Lmrs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=X9X1dvzwoKwAa33DY5GHEhncxaqnoNxtTCui5dXDPecRibewhuVIFq4atvFus7SmY
	 p+76v5ueGKsjdpkZ+pci2nO2pHnYKOCK2/hr/eVavZJjGskxEWCSjAeF7IzUJlPX2J
	 pLosuAWh17ZRTQDGxjCjTd4KTY4aLBqe83VHqJXE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peng Fan <peng.fan@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 308/508] arm64: dts: imx8mm-emtop-som: Correct PAD settings for PMIC_nINT
Date: Wed, 20 May 2026 18:22:11 +0200
Message-ID: <20260520162105.315461778@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162058.573354582@linuxfoundation.org>
References: <20260520162058.573354582@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peng Fan <peng.fan@nxp.com>

[ Upstream commit 721dec3ee9ff5231d13a412ff87df63b966d137b ]

With commit 5d0efaf47ee90 ("regulator: pca9450: Correct interrupt type"),
there might be interrupt storm for this board. Need to set PAD PUE and PU
together to make pull up work properly.

While at here, also correct interrupt type as IRQ_TYPE_LEVEL_LOW.

Fixes: cbd3ef64eb9d1 ("arm64: dts: Add support for Emtop SoM & Baseboard")
Signed-off-by: Peng Fan <peng.fan@nxp.com>
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx8mm-emtop-som.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/freescale/imx8mm-emtop-som.dtsi b/arch/arm64/boot/dts/freescale/imx8mm-emtop-som.dtsi
index 67d22d3768aa8..507d1824d99d9 100644
--- a/arch/arm64/boot/dts/freescale/imx8mm-emtop-som.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mm-emtop-som.dtsi
@@ -60,7 +60,7 @@ pmic@25 {
 		pinctrl-names = "default";
 		pinctrl-0 = <&pinctrl_pmic>;
 		interrupt-parent = <&gpio1>;
-		interrupts = <3 IRQ_TYPE_EDGE_RISING>;
+		interrupts = <3 IRQ_TYPE_LEVEL_LOW>;
 
 		regulators {
 			buck1: BUCK1 {
@@ -194,7 +194,7 @@ MX8MM_IOMUXC_I2C1_SDA_I2C1_SDA				0x400001c3
 
 	pinctrl_pmic: emtop-pmic-grp {
 		fsl,pins = <
-			MX8MM_IOMUXC_GPIO1_IO03_GPIO1_IO3			0x41
+			MX8MM_IOMUXC_GPIO1_IO03_GPIO1_IO3			0x141
 		>;
 	};
 
-- 
2.53.0



