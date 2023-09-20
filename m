Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0816B2E63B
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 12:11:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74DD3C433C8;
	Wed, 20 Sep 2023 12:11:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695211917;
	bh=ViIEFlEjwtlvmEUgF5QoJ3Ss6rPRLylVPY2jHvj7+0k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JAV8ZXf01aFuFDo99xIM2JuMRFUaaRDwsRHxq2HVNCro9rM4wqS8x1ZwzhMNcCYl0
	 q7roA//HOlUE00Dqy2tCDMoHWK6OoFaoOQlHZ6LRSO50VNe0yiP68cxO3I4dI8V49t
	 4CXj7llQwhLRNg+xSE0YHjXZXx1ah2v4Zj8Dvfxo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 083/273] ARM: dts: BCM53573: Drop nonexistent #usb-cells
Date: Wed, 20 Sep 2023 13:28:43 +0200
Message-ID: <20230920112849.013555845@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230920112846.440597133@linuxfoundation.org>
References: <20230920112846.440597133@linuxfoundation.org>
User-Agent: quilt/0.67
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rafał Miłecki <rafal@milecki.pl>

[ Upstream commit 05d2c3d552b8c92fc397377d9d1112fc58e2cd59 ]

Such property simply doesn't exist (is not documented or used anywhere).

This fixes:
arch/arm/boot/dts/broadcom/bcm47189-luxul-xap-1440.dtb: usb@d000: Unevaluated properties are not allowed ('#usb-cells' was unexpected)
        From schema: Documentation/devicetree/bindings/usb/generic-ohci.yaml

Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
Link: https://lore.kernel.org/r/20230707114004.2740-2-zajec5@gmail.com
Signed-off-by: Florian Fainelli <florian.fainelli@broadcom.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/bcm53573.dtsi | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/arm/boot/dts/bcm53573.dtsi b/arch/arm/boot/dts/bcm53573.dtsi
index 5aef9fd651049..c065d6348c015 100644
--- a/arch/arm/boot/dts/bcm53573.dtsi
+++ b/arch/arm/boot/dts/bcm53573.dtsi
@@ -156,8 +156,6 @@ ehci_port2: port@2 {
 			};
 
 			ohci: usb@d000 {
-				#usb-cells = <0>;
-
 				compatible = "generic-ohci";
 				reg = <0xd000 0x1000>;
 				interrupt-parent = <&gic>;
-- 
2.40.1



