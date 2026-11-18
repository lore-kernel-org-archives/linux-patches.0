Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023020;
	b=mAqR98OfaKrIy94Fh3NA7xJ+//nUA1wRy4CmKwahWySU/nC7lRGn7MeBsbtJH9mR5yZ9
	 ZafkEUZ4E4KlHRVb9Qwbi9ndudCf4v9YJopIntotcI/k70Zjbyh1vkiI4jnjFcJxvEuxp
	 LwYGMX0kBAafHO0NoN4JnOfckQio2g+MEtlZ9l1DbJKX9lyAg141uutnvoOcaxUb5EKOZ
	 myFlvKFvHoiOcu1zrZas8kYIEVGUFwhL2OWunxd8DZeUhYHP5l+MYGvdFQ9PZ9H495aUP
	 7IztBiiIJvoV1Cl1CM2S1pE359TqHBTokQ2gPjbrVbwOCzrPTr2i5YkB6qNRR/gBBag==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023020;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=CWo/OKIEfDPtm8rpUMbZeyLrPVKYGQLJr45OzKsChqk=;
	b=J24yNYP1QszlMKFqwexzAztW4Y5rv3MS/PI7Nk7ZMIj3Tc4slcBx1hnSbXZBkP8rL8bf
	 vWyMsiuO5UmRxpUcyfYWxV8VMhRJ46UPcB6E63nsxjiTaTv5MS/21cXp2jxveajLNkeqs
	 KYuyUAm61sUt7schU0eQi+U59d0sTVwgoWKPqqu6kFXUGiGJlL9Z5rZHWx2FwcEfygVyj
	 7pCrbUgoAmGMJ7NqkAw2Te2r37D9lxWe1n4oNB+jqMi+fMiCCrOv84TlyrlYxyOs/XGNp
	 /G64bxdZyJwLtbDGA0uaUuEt5wNS9ekMXWDF95ZmLHSYGFeRCLKJpQzGkyUDUfM8JYA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hZVU51K1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76592606A31C;
	Wed, 18 Nov 2026 17:30:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hZVU51K1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA2A51F000C4;
	Wed, 18 Nov 2026 17:30:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023020;
	bh=CWo/OKIEfDPtm8rpUMbZeyLrPVKYGQLJr45OzKsChqk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hZVU51K1kSdrOlpIZC1AneISpFYR+P2GzJRB11V9U7lLw7P67O0eYKJguYKYTEHDr
	 mKB/Gir9o7Wc0pYVRs7TFzaHc+mhcm37vcNPYe9IDDO7YR9XmYViA2eEQ+bkC4xmJq
	 /8lKGyrgsZMA9U39x7cyFZAYrnXb11IVqoWnWX8A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0219/2151] arm64: dts: broadcom: bcm2712: Move non simple-bus nodes to root level
Date: Wed, 18 Nov 2026 15:32:34 +0100
Message-ID: <20261118150129.767334420@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rob Herring (Arm) <robh@kernel.org>

[ Upstream commit 0acb1de2b4df426a62dba33bcd80f3939636f97b ]

The 'gpu' and 'firmware' nodes are not MMIO devices, so they should not
be under a 'simple-bus', but at the root level.

Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
Link: https://lore.kernel.org/r/20260320154809.1246064-2-robh@kernel.org
Signed-off-by: Florian Fainelli <florian.fainelli@broadcom.com>
Stable-dep-of: 1cda59c6790b ("arm64: dts: broadcom: bcm2712: adjust display status")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../dts/broadcom/bcm2712-rpi-5-b-ovl-rp1.dts  | 51 +++++++++----------
 arch/arm64/boot/dts/broadcom/bcm2712.dtsi     |  8 +--
 2 files changed, 28 insertions(+), 31 deletions(-)

diff --git a/arch/arm64/boot/dts/broadcom/bcm2712-rpi-5-b-ovl-rp1.dts b/arch/arm64/boot/dts/broadcom/bcm2712-rpi-5-b-ovl-rp1.dts
index dbfba51ebe915..b7a6bc34ae1ab 100644
--- a/arch/arm64/boot/dts/broadcom/bcm2712-rpi-5-b-ovl-rp1.dts
+++ b/arch/arm64/boot/dts/broadcom/bcm2712-rpi-5-b-ovl-rp1.dts
@@ -44,6 +44,30 @@ power_button: power-button {
 		};
 	};
 
+	firmware {
+		firmware: rpi-firmware {
+			compatible = "raspberrypi,bcm2835-firmware", "simple-mfd";
+
+			mboxes = <&mailbox>;
+
+			firmware_clocks: clocks {
+				compatible = "raspberrypi,firmware-clocks";
+				#clock-cells = <1>;
+			};
+
+			reset: reset {
+				compatible = "raspberrypi,firmware-reset";
+				#reset-cells = <1>;
+			};
+
+			power: power {
+				compatible = "raspberrypi,bcm2835-power";
+				firmware = <&firmware>;
+				#power-domain-cells = <1>;
+			};
+		};
+	};
+
 	sd_io_1v8_reg: sd-io-1v8-reg {
 		compatible = "regulator-gpio";
 		regulator-name = "vdd-sd-io";
@@ -189,33 +213,6 @@ wifi: wifi@1 {
 	};
 };
 
-&soc {
-	firmware: firmware {
-		compatible = "raspberrypi,bcm2835-firmware", "simple-mfd";
-		#address-cells = <1>;
-		#size-cells = <1>;
-
-		mboxes = <&mailbox>;
-		dma-ranges;
-
-		firmware_clocks: clocks {
-			compatible = "raspberrypi,firmware-clocks";
-			#clock-cells = <1>;
-		};
-
-		reset: reset {
-			compatible = "raspberrypi,firmware-reset";
-			#reset-cells = <1>;
-		};
-	};
-
-	power: power {
-		compatible = "raspberrypi,bcm2835-power";
-		firmware = <&firmware>;
-		#power-domain-cells = <1>;
-	};
-};
-
 /* uarta communicates with the BT module */
 &uarta {
 	uart-has-rtscts;
diff --git a/arch/arm64/boot/dts/broadcom/bcm2712.dtsi b/arch/arm64/boot/dts/broadcom/bcm2712.dtsi
index 8eeaf7ffd2046..9add69f1726fd 100644
--- a/arch/arm64/boot/dts/broadcom/bcm2712.dtsi
+++ b/arch/arm64/boot/dts/broadcom/bcm2712.dtsi
@@ -503,10 +503,6 @@ axi: axi {
 			     <0x18 0x00000000  0x18 0x00000000  0x04 0x00000000>,
 			     <0x1c 0x00000000  0x1c 0x00000000  0x04 0x00000000>;
 
-		vc4: gpu {
-			compatible = "brcm,bcm2712-vc6";
-		};
-
 		pcie0: pcie@1000100000 {
 			compatible = "brcm,bcm2712-pcie";
 			reg = <0x10 0x00100000 0x00 0x9310>;
@@ -656,6 +652,10 @@ v3d: gpu@1002000000 {
 		};
 	};
 
+	vc4: gpu {
+		compatible = "brcm,bcm2712-vc6";
+	};
+
 	timer {
 		compatible = "arm,armv8-timer";
 		interrupts = <GIC_PPI 13 (GIC_CPU_MASK_SIMPLE(4) |
-- 
2.53.0



