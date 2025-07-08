Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B9878F5B;
	Tue,  8 Jul 2025 16:42:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751992964; cv=none; b=azJ0+mrX7sgOpPFpLCnHZmgm0EADp9f9NNCxYCy6hmtMApe3yrwuXy3U5iaMvS9FERZWaLF+rMp79PxJovgVWtbwibQngUgT5L9BWsiFgsxE1YwmFbjSoZwk4eqI1chV+H5nH+rgpD5QDIvF8yYymbjniJYPOEgIrAO0QaC0URk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751992964; c=relaxed/simple;
	bh=BwHeBEZ7lOwXvg5NNAGBW+ccl0lDm3ytNdCi5dL6Bg8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IAEs7aMCe8+y1EngRQBvPp4IIPUDqSbpcluYPmi8Qho79+oMVHi8QkPKJkrp5HU6+pL1SNe6ZmigZZ2K2v9+Fdh+p/z/72FKjeqyr/uaIciTLzmNSNH0pPx4uEMy00UrMYkl+iaJFl8YhQ76tuIFuiVYOZG1VDQVz9aSvXoYTMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GxicGePc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GxicGePc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E093FC4CEED;
	Tue,  8 Jul 2025 16:42:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751992964;
	bh=BwHeBEZ7lOwXvg5NNAGBW+ccl0lDm3ytNdCi5dL6Bg8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GxicGePccMSlT/B34Ea8ZSKoHmxRN/+XpAgS1/Kc2xpsV0P+sTlzJ+DoRbvKVbuZW
	 UXiJ0kt+I5/+fJ78MkCDYqrFeN2F4lTCwcipX+68mwx0E95XLCPtaxAkAhRb+O8jEZ
	 6k1vBnQRLpMkwJw0r2K04AlNZni2u6AD/X9hAgt8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	=?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund+renesas@ragnatech.se>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 142/232] arm64: dts: renesas: white-hawk-single: Improve Ethernet TSN description
Date: Tue,  8 Jul 2025 18:22:18 +0200
Message-ID: <20250708162245.158828157@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162241.426806072@linuxfoundation.org>
References: <20250708162241.426806072@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit 8ffec7d62c6956199f442dac3b2d5d02231c3977 ]

  - Add the missing "ethernet3" alias for the Ethernet TSN port, so
    U-Boot will fill its local-mac-address property based on the
    "eth3addr" environment variable (if set), avoiding a random MAC
    address being assigned by the OS,
  - Rename the numerical Ethernet PHY label to "tsn0_phy", to avoid
    future conflicts, and for consistency with the "avbN_phy" labels.

Fixes: 3d8e475bd7a724a9 ("arm64: dts: renesas: white-hawk-single: Wire-up Ethernet TSN")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
Link: https://lore.kernel.org/367f10a18aa196ff1c96734dd9bd5634b312c421.1746624368.git.geert+renesas@glider.be
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/renesas/white-hawk-single.dtsi | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/renesas/white-hawk-single.dtsi b/arch/arm64/boot/dts/renesas/white-hawk-single.dtsi
index 20e8232f2f323..976a3ab44e5a5 100644
--- a/arch/arm64/boot/dts/renesas/white-hawk-single.dtsi
+++ b/arch/arm64/boot/dts/renesas/white-hawk-single.dtsi
@@ -11,6 +11,10 @@
 / {
 	model = "Renesas White Hawk Single board";
 	compatible = "renesas,white-hawk-single";
+
+	aliases {
+		ethernet3 = &tsn0;
+	};
 };
 
 &hscif0 {
@@ -53,7 +57,7 @@ &tsn0 {
 	pinctrl-0 = <&tsn0_pins>;
 	pinctrl-names = "default";
 	phy-mode = "rgmii";
-	phy-handle = <&phy3>;
+	phy-handle = <&tsn0_phy>;
 	status = "okay";
 
 	mdio {
@@ -63,7 +67,7 @@ mdio {
 		reset-gpios = <&gpio1 23 GPIO_ACTIVE_LOW>;
 		reset-post-delay-us = <4000>;
 
-		phy3: ethernet-phy@0 {
+		tsn0_phy: ethernet-phy@0 {
 			compatible = "ethernet-phy-id002b.0980",
 				     "ethernet-phy-ieee802.3-c22";
 			reg = <0>;
-- 
2.39.5



