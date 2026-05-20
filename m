Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 390983A3E9C;
	Wed, 20 May 2026 17:42:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779298976; cv=none; b=tlD51vae8Y61D+haO4C/IX0XPfZV/ldXSbgShdJ6f9mtmcpkWfOUwkiaeHB5KVbixDpe+Oz359HtZdxv99V92el/fP1rCAxRCMZQ6fGjMdmMMaBDyRRh/wu679f0TJYpN3DT91VHleTJ6vWgm7fJD47D/8i6gjVBZgisWWfw2zI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779298976; c=relaxed/simple;
	bh=6gBJkxLLP+LhJ8jK6fzhofnyGnzFU9zqF1O2Lmoo5Hk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nDQHA6mZ2FBnIzuRmsOmmiZlqa3OlKidEqSOdFhsYlsRNJota42c6jrV4Z7gGFoBP06jBa8hThEdj9s6zoZNIzLntVDUvkK2r7AQWcIiKfnJpE+ZqqoaHTO4H8odHsp/gcbqnVpV2n9Qy3EJe33udaqFNJkeynneMo2NC0uLH9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F0nFY4ld; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F0nFY4ld"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 907BB1F000E9;
	Wed, 20 May 2026 17:42:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779298975;
	bh=aBnL7ClRyHKUbz/IJ1y9l2cFNTgTRVmiiQ4C/7Pnkeo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F0nFY4ldNK3yPe0aPA1WJYsqNteFuM6+G080e090mOqqWnYR9rZCf6riallgiR3fs
	 mPylVBtUTs0J298YJvhNH1p7KKaHKGB6me+s6WdaSc64YWBPj0A3DqgWWSSeR30DeS
	 wejAbzjLn0fjPQpV1Asppf8zhLcM5tKJTlc/CR8I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gabor Juhos <j4g8y7@gmail.com>,
	Gregory CLEMENT <gregory.clement@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 613/957] arm64: dts: marvell: armada-37xx: use usb2-phy in USB3 controllers phy-names
Date: Wed, 20 May 2026 18:18:16 +0200
Message-ID: <20260520162147.828587849@linuxfoundation.org>
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

From: Gabor Juhos <j4g8y7@gmail.com>

[ Upstream commit 0fef19844624f8bc07651b4d26088d8940affba3 ]

Instead of the generic 'usb2-phy' name, the Armada 37xx device trees
are using a custom 'usb2-utmi-otg-phy' name for the USB2 PHY in the USB3
controller node. Since commit 53a2d95df836 ("usb: core: add phy notify
connect and disconnect"), this triggers a bug [1] in the USB core which
causes double use of the USB3 PHY.

Change the PHY name to 'usb2-phy' in the SoC and in the uDPU specific
dtsi files in order to avoid triggering the bug and also to keep the
names in line with the ones used by other platforms.

Link: https://lore.kernel.org/r/20260330-usb-avoid-usb3-phy-double-use-v1-1-d2113aecb535@gmail.com # [1]
Fixes: 53a2d95df836 ("usb: core: add phy notify connect and disconnect")
Signed-off-by: Gabor Juhos <j4g8y7@gmail.com>
Signed-off-by: Gregory CLEMENT <gregory.clement@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/marvell/armada-3720-uDPU.dtsi | 2 +-
 arch/arm64/boot/dts/marvell/armada-37xx.dtsi      | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/marvell/armada-3720-uDPU.dtsi b/arch/arm64/boot/dts/marvell/armada-3720-uDPU.dtsi
index cd856c0aba71e..12deacb741ccb 100644
--- a/arch/arm64/boot/dts/marvell/armada-3720-uDPU.dtsi
+++ b/arch/arm64/boot/dts/marvell/armada-3720-uDPU.dtsi
@@ -161,7 +161,7 @@ &eth1 {
 &usb3 {
 	status = "okay";
 	phys = <&usb2_utmi_otg_phy>;
-	phy-names = "usb2-utmi-otg-phy";
+	phy-names = "usb2-phy";
 };
 
 &uart0 {
diff --git a/arch/arm64/boot/dts/marvell/armada-37xx.dtsi b/arch/arm64/boot/dts/marvell/armada-37xx.dtsi
index c612317043ea7..a66157cb439b4 100644
--- a/arch/arm64/boot/dts/marvell/armada-37xx.dtsi
+++ b/arch/arm64/boot/dts/marvell/armada-37xx.dtsi
@@ -373,7 +373,7 @@ usb3: usb@58000 {
 				interrupts = <GIC_SPI 3 IRQ_TYPE_LEVEL_HIGH>;
 				clocks = <&sb_periph_clk 12>;
 				phys = <&comphy0 0>, <&usb2_utmi_otg_phy>;
-				phy-names = "usb3-phy", "usb2-utmi-otg-phy";
+				phy-names = "usb3-phy", "usb2-phy";
 				status = "disabled";
 			};
 
-- 
2.53.0



