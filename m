Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 123273F1AC7;
	Wed, 20 May 2026 16:59:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779296346; cv=none; b=iHQuE6Rxh7Yiugb/ipcSHRiAlsHRWv6NUeUmIHbKD5XCOsvBUJrvlGCU6ogJuoUcbhLqHto1nVoz9vAcp10RxztbD8+PVoM70MEV2bUiDoY57Wjn65O52h1KKi5Y0P5Po6BeUqWCQnDev2+lpeAanSZ6jSQYSkdd32mCbKJ5xA8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779296346; c=relaxed/simple;
	bh=FfPQ9pulKsfbEoGFTlcWYtzyfc35ssUle+c4YDJBHWs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u5rAsQTqtwaj+JVLizS3LZgXdOfjSdTvav99rMPTNHNhkPD8L97c1J9HU8VZEUM0yh/kV2s2P5OWFMYUKdTiAXm3EIxQjyEVIwZQv50Up67Y6sCA5Z85u+FIQHGoVDwwoFTjaoW70YoKitNjC8KIieXlcS92zjqmD/BDoqdrzmI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eXlgNaiO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eXlgNaiO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78B9F1F00893;
	Wed, 20 May 2026 16:59:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779296345;
	bh=idmJP9ZDwUq+s15lzOQqZjgqg5x7+SBS9j8wGld/dm0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eXlgNaiOliGUJGx2+U2otqC31D0TYjGyTipW/UtjSs9auoMCCpnvXunae/6TB5xwS
	 mnpnQKGPiJKhVa9Y8cF5kBmkmIrtaBOBKBFzUxzFU/zY8wQRESOgnMc7rwSRFIdwV+
	 dQ+tLV7VQ7HOUTbXWlk2FDcegoSzG3J8XOlsupJ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peng Fan <peng.fan@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0763/1146] arm64: dts: imx8mm-emtop-som: Correct PAD settings for PMIC_nINT
Date: Wed, 20 May 2026 18:16:53 +0200
Message-ID: <20260520162205.478466483@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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



