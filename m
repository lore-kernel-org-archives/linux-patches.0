Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA43828DC4;
	Wed, 20 May 2026 17:42:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779298949; cv=none; b=pXHZCLWSalkYgCvg521mdRF+RdmHcWYeqU1ehhLwMc4Y9IyqfbitdIvPoJGQfJkTkc+ARuXwJDJ1W6INCv82n0YmPNKA9q1Y1/AyVfzBUtBAbi8cYtkQ27PRjfEyAGQSa5kWrAV+5sYs51U+YFG6u7aD3a98XfdovkHFHKXdjiA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779298949; c=relaxed/simple;
	bh=q+/uDbEiWqtuZpcH2REV2doM3tJU4ecc/gM5p4090bE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=toFZwoR+Eek0hJTD67llSjM/M4/1HtaoMINw6a7CooxbHe1ZS1yiuj+Qy/A0cHWKNYDZiLWXuGiNfPNz591xZAF7S9gJI8DSVQ9ONmc75uz/Cw755HCHEoS0qAkWjbPGdIzE5thHBOriSfCryOVMMJod8AoSp2AVZFoqIEeSYxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uTNehUzE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uTNehUzE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B6F61F000E9;
	Wed, 20 May 2026 17:42:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779298948;
	bh=XtW9LJfVrsQD/brMJHJTu9yCBGBCvjNKylfwVKLxd7A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uTNehUzEqEimlsHCFwjsE08M+9Ue8SO8IiKyG6T+xNYyZnrFQr6fi0+CE509CQkvL
	 gQcBYHcqTF+bNtNsG1ssC/sHHJH9PXbrTiJc0viNxI6lpPSyTmnkFCFl947grQ0OQm
	 xOkNLYGvf7kcbyXuEJHTIinfgFAhcF+SAsJeXMWk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peng Fan <peng.fan@nxp.com>,
	Josua Mayer <josua@solid-run.com>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 604/957] arm64: dts: imx8mp-sr-som: Correct PAD settings for PMIC_nINT
Date: Wed, 20 May 2026 18:18:07 +0200
Message-ID: <20260520162147.633238820@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peng Fan <peng.fan@nxp.com>

[ Upstream commit 695a476275cfb9c798a696aeaa43967701d5c78a ]

With commit 5d0efaf47ee90 ("regulator: pca9450: Correct interrupt type"),
there might be interrupt storm for this board. Need to set PAD PUE and PU
together to make pull up work properly.

Fixes: a009c0c66ecb4 ("arm64: dts: add description for solidrun imx8mp som and cubox-m")
Signed-off-by: Peng Fan <peng.fan@nxp.com>
Reviewed-by: Josua Mayer <josua@solid-run.com>
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx8mp-sr-som.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/freescale/imx8mp-sr-som.dtsi b/arch/arm64/boot/dts/freescale/imx8mp-sr-som.dtsi
index 4e6629f940bfa..82a3ed80235a8 100644
--- a/arch/arm64/boot/dts/freescale/imx8mp-sr-som.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mp-sr-som.dtsi
@@ -174,7 +174,7 @@ pmic: pmic@25 {
 		pinctrl-0 = <&pmic_pins>;
 		pinctrl-names = "default";
 		interrupt-parent = <&gpio1>;
-		interrupts = <3 GPIO_ACTIVE_LOW>;
+		interrupts = <3 IRQ_TYPE_LEVEL_LOW>;
 		nxp,i2c-lt-enable;
 
 		regulators {
@@ -417,7 +417,7 @@ MX8MP_IOMUXC_SAI1_RXD1__GPIO4_IO03		0x160
 
 	pmic_pins: pinctrl-pmic-grp {
 		fsl,pins = <
-			MX8MP_IOMUXC_GPIO1_IO03__GPIO1_IO03		0x41
+			MX8MP_IOMUXC_GPIO1_IO03__GPIO1_IO03		0x1c0
 		>;
 	};
 
-- 
2.53.0



