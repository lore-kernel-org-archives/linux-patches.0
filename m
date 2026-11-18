Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023017;
	b=sB7H6TFTcVQU/dyeNlQyf64J30SE0AeXfnkjGRj92ZYPOMJSXuAV5LfYu3PHPGtccEju
	 anzE23nCuOUUguPmMWX6pkzzFv/yGTMTu45yLa84Da76IDVmm+83nKRSJ5eQa6fY31wd8
	 eEYLxZjVYvw0Z9pz8V2t139z55TIEc09u8QGGfXtNJG9Vw2wVzO0gOEo9LdBs6gO0/30/
	 53rdvp7PPieN55ecsSAkkb7LjFDVemd8wlTOwMzsZ2TIPFSH1pFNgRyhoeXDz+cPkorLb
	 B8u6QOIuTGI1Kujw208aH3ARq9yxCtNl//VJ3tRp+CtzHdeoBe8Getzys68Q3bM7YTA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023017;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=alueTs9ffTLW1W+Cx3TkpiXfToc18Lck/uOa2vArjnk=;
	b=3/otLPJDhi4Bwy54sKNoi7t15XWjDH8BKR+mxsny9CXe8HJl5l5Hx15haCZCM5oayEJn
	 Z1UknqkSw8yJ8nZKC3P0TIkwDBy3Ni7GbUgg750hu8Cct9ucU2HOfWUMfVUhiMH8gQtP0
	 3OrhhyvQtt2QU79Y1PEkx1EjDRg9VDRP1ACLUjnoJQQzNnmCvWqkX9MhvLwfeFmvzjT73
	 +jGMTU38ADM5C+FaRUZBPbHH5RkV51n1zcZfJy72mYI/aBhNXiBtmnwlVEFBmOzFP7Bd7
	 2JRrDdLIgoKntLBfpSSTAPS2+KVd4RxXT+b/ZTGI2XV4IUizhlDWT5ujpNJiPIRxFxQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BHMUA6Zf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4B72606A31C;
	Wed, 18 Nov 2026 17:30:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BHMUA6Zf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0707C1F000C5;
	Wed, 18 Nov 2026 17:30:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023017;
	bh=alueTs9ffTLW1W+Cx3TkpiXfToc18Lck/uOa2vArjnk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BHMUA6ZfgwtqADBHhz8Hr2O4bmdxNoco+72kudDuWc9WIZlpUP1Ac6HPRudTZgeHp
	 MOz5GAcpy6LAyRiolMT4wsHM4A9ha33X+BLJdqLmdWQEmg1wnyEFcJwEZLKJUiLFAs
	 nCz74SqxMQ45Nx/Ycry6O6D/jJdjHpgKfLCroA8w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ma=C3=ADra=20Canal?= <mcanal@igalia.com>,
	Stefan Wahren <wahrenst@gmx.net>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0218/2151] arm64: dts: broadcom: bcm2712: Add V3D device node
Date: Wed, 18 Nov 2026 15:32:33 +0100
Message-ID: <20261118150129.726744414@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maíra Canal <mcanal@igalia.com>

[ Upstream commit 80ebada3dbcc811f3f64fc65e49d87857fe9272b ]

Commits 0ad5bc1ce463 ("drm/v3d: fix up register addresses for V3D 7.x")
and 6fd9487147c4 ("drm/v3d: add brcm,2712-v3d as a compatible V3D device")
added driver support for V3D on BCM2712, but the corresponding device
tree node is still missing.

Add the V3D device tree node to the BCM2712 DTS.

Signed-off-by: Maíra Canal <mcanal@igalia.com>
Reviewed-by: Stefan Wahren <wahrenst@gmx.net>
Link: https://lore.kernel.org/r/20260114120610.82531-1-mcanal@igalia.com
Signed-off-by: Florian Fainelli <florian.fainelli@broadcom.com>
Stable-dep-of: 1cda59c6790b ("arm64: dts: broadcom: bcm2712: adjust display status")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../boot/dts/broadcom/bcm2712-rpi-5-b-ovl-rp1.dts  |  4 ++++
 arch/arm64/boot/dts/broadcom/bcm2712.dtsi          | 14 ++++++++++++++
 2 files changed, 18 insertions(+)

diff --git a/arch/arm64/boot/dts/broadcom/bcm2712-rpi-5-b-ovl-rp1.dts b/arch/arm64/boot/dts/broadcom/bcm2712-rpi-5-b-ovl-rp1.dts
index 04738bf281ebd..dbfba51ebe915 100644
--- a/arch/arm64/boot/dts/broadcom/bcm2712-rpi-5-b-ovl-rp1.dts
+++ b/arch/arm64/boot/dts/broadcom/bcm2712-rpi-5-b-ovl-rp1.dts
@@ -252,3 +252,7 @@ &pcie1 {
 &pcie2 {
 	status = "okay";
 };
+
+&v3d {
+	clocks = <&firmware_clocks 5>;
+};
diff --git a/arch/arm64/boot/dts/broadcom/bcm2712.dtsi b/arch/arm64/boot/dts/broadcom/bcm2712.dtsi
index 45a382f75b5ec..8eeaf7ffd2046 100644
--- a/arch/arm64/boot/dts/broadcom/bcm2712.dtsi
+++ b/arch/arm64/boot/dts/broadcom/bcm2712.dtsi
@@ -1,5 +1,6 @@
 // SPDX-License-Identifier: (GPL-2.0 OR MIT)
 #include <dt-bindings/interrupt-controller/arm-gic.h>
+#include <dt-bindings/soc/bcm2835-pm.h>
 
 / {
 	compatible = "brcm,bcm2712";
@@ -640,6 +641,19 @@ mip1: msi-controller@1000131000 {
 			msi-ranges = <&gicv2 GIC_SPI 247 IRQ_TYPE_EDGE_RISING 8>;
 			brcm,msi-offset = <8>;
 		};
+
+		v3d: gpu@1002000000 {
+			compatible = "brcm,2712-v3d";
+			reg = <0x10 0x02000000 0x00 0x4000>,
+			      <0x10 0x02008000 0x00 0x6000>,
+			      <0x10 0x02030800 0x00 0x0700>;
+			reg-names = "hub", "core0", "sms";
+
+			power-domains = <&pm BCM2835_POWER_DOMAIN_GRAFX_V3D>;
+			resets = <&pm BCM2835_RESET_V3D>;
+			interrupts = <GIC_SPI 250 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 249 IRQ_TYPE_LEVEL_HIGH>;
+		};
 	};
 
 	timer {
-- 
2.53.0



