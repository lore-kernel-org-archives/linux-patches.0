Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0653C11184
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:02:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15366C433C9;
	Mon, 11 Sep 2023 14:02:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694440964;
	bh=DQ92JH069beotqUfZAP+XjkG7Gh4CYJG53DRJ6S4JT4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xw0stDP0GBQsO4Z18XJi+0/duqXdoF1745jomAx67fhnS2JOK4u/Wu4qF+O2AuRed
	 PVlq2OR7mGZk04a7u2yfgSe1xnj0WHG8g9CCOuwfhiwwW57/clQM+bB+rg8luuO3l6
	 9MsMnkpD124C2VOg7CAb8TEVwyP+hl1Y5/b+IW34=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 247/739] ARM: dts: BCM53573: Drop nonexistent #usb-cells
Date: Mon, 11 Sep 2023 15:40:46 +0200
Message-ID: <20230911134658.057885925@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.921299741@linuxfoundation.org>
References: <20230911134650.921299741@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

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
 arch/arm/boot/dts/broadcom/bcm53573.dtsi | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/arm/boot/dts/broadcom/bcm53573.dtsi b/arch/arm/boot/dts/broadcom/bcm53573.dtsi
index 3f03a381db0f2..3cb71829e8597 100644
--- a/arch/arm/boot/dts/broadcom/bcm53573.dtsi
+++ b/arch/arm/boot/dts/broadcom/bcm53573.dtsi
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



