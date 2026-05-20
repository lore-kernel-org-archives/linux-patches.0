Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47B3E36D9EA;
	Wed, 20 May 2026 18:19:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779301142; cv=none; b=jUR9PXRx2N7XoeqqZbd+2qmiTzJmMFbPcXULaUIE659GYXWCF6WJu90l7ywAnxHHOkfDYhc2RtZwqp63SRZOLvr6Xtu/MggoP/wqHvWxGtvb6Wka+91gatAKqYING9Af1e1OsRPk2QbSnBpzThsQF/Yj2Qijg3K5n0v7BGCTgzg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779301142; c=relaxed/simple;
	bh=f+Oj9vj3Zwg7sG6FLzskgdjASBgNEdogucl3mIttwUs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vDoYqxFl+VBV8vhCxuAuxxk3dUtVOoMi+YVjnDyP88AU919Ih/cbT4CZeZcRgyfMQZ580+7twZwZ4aVCAuMHl/N0uoJyCel8hegAZenZg2kgB8t6em4zd70OxKVlEPv2XpxGeqE+1OUBgFN+qorsPh63/9yaFaoITetylDCuMH8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sr5LcaeM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sr5LcaeM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD2F71F000E9;
	Wed, 20 May 2026 18:19:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779301141;
	bh=QrmcneeExR1LWSTEFzyUzZ+BL/xcKxTSpo8Ik1mfEkE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sr5LcaeMrFnN2FLRBUU+EyoWue9xH2wF1rC0+DiyR583it5vqI9M8aBY9bcodujZK
	 DiDBl5CNaDXrkCcLqo6ccTyggZpafIsGCQa3VAm76aCTqIro7ppfhWtB0RmRbFOH0V
	 4C4q9/zcRjoS7HvbyrJISGsyiJynjSvpbJpNxeY8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gabor Juhos <j4g8y7@gmail.com>,
	Gregory CLEMENT <gregory.clement@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 443/666] arm64: dts: marvell: armada-37xx: use usb2-phy in USB3 controllers phy-names
Date: Wed, 20 May 2026 18:20:54 +0200
Message-ID: <20260520162120.874066383@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 9603223dd761f..16b2b70529506 100644
--- a/arch/arm64/boot/dts/marvell/armada-37xx.dtsi
+++ b/arch/arm64/boot/dts/marvell/armada-37xx.dtsi
@@ -375,7 +375,7 @@ usb3: usb@58000 {
 				interrupts = <GIC_SPI 3 IRQ_TYPE_LEVEL_HIGH>;
 				clocks = <&sb_periph_clk 12>;
 				phys = <&comphy0 0>, <&usb2_utmi_otg_phy>;
-				phy-names = "usb3-phy", "usb2-utmi-otg-phy";
+				phy-names = "usb3-phy", "usb2-phy";
 				status = "disabled";
 			};
 
-- 
2.53.0



