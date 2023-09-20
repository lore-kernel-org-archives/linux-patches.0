Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83F212E63B
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 12:11:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 083E8C433C7;
	Wed, 20 Sep 2023 12:11:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695211912;
	bh=UiNKlivq7CXaKuZ3GEys7jUibboRtqWKS33lNlMG+Pk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x9YXSlhluCqUBz2mHz8IDfr0lQskLXKSbx6kAlq60VdrqMv/Fjns8xKdTsw5puc9/
	 JCy0cwVfA9vqpc5ZpWoMvqNImdHnBJLKydZ6kXaJX3rG/V8JEvFK1r2V4uPSuQx0AQ
	 zZq058g/Tjy3cM3qMcfuCsgBHakRTopH+IyHeg/s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Serge Semin <Sergey.Semin@baikalelectronics.ru>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Krzysztof Kozlowski <krzk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 081/273] ARM: dts: BCM5301X: Harmonize EHCI/OHCI DT nodes name
Date: Wed, 20 Sep 2023 13:28:41 +0200
Message-ID: <20230920112848.954864197@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Serge Semin <Sergey.Semin@baikalelectronics.ru>

[ Upstream commit 74abbfe99f43eb7466d26d9e48fbeb46b8f3d804 ]

In accordance with the Generic EHCI/OHCI bindings the corresponding node
name is suppose to comply with the Generic USB HCD DT schema, which
requires the USB nodes to have the name acceptable by the regexp:
"^usb(@.*)?" . Make sure the "generic-ehci" and "generic-ohci"-compatible
nodes are correctly named.

Signed-off-by: Serge Semin <Sergey.Semin@baikalelectronics.ru>
Acked-by: Florian Fainelli <f.fainelli@gmail.com>
Acked-by: Krzysztof Kozlowski <krzk@kernel.org>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Stable-dep-of: 05d2c3d552b8 ("ARM: dts: BCM53573: Drop nonexistent #usb-cells")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/bcm5301x.dtsi | 4 ++--
 arch/arm/boot/dts/bcm53573.dtsi | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm/boot/dts/bcm5301x.dtsi b/arch/arm/boot/dts/bcm5301x.dtsi
index a6406a347690e..c331217ce21b3 100644
--- a/arch/arm/boot/dts/bcm5301x.dtsi
+++ b/arch/arm/boot/dts/bcm5301x.dtsi
@@ -260,7 +260,7 @@ usb2: usb2@21000 {
 
 			interrupt-parent = <&gic>;
 
-			ehci: ehci@21000 {
+			ehci: usb@21000 {
 				#usb-cells = <0>;
 
 				compatible = "generic-ehci";
@@ -282,7 +282,7 @@ ehci_port2: port@2 {
 				};
 			};
 
-			ohci: ohci@22000 {
+			ohci: usb@22000 {
 				#usb-cells = <0>;
 
 				compatible = "generic-ohci";
diff --git a/arch/arm/boot/dts/bcm53573.dtsi b/arch/arm/boot/dts/bcm53573.dtsi
index 453a2a37dabd3..d38f103db8a64 100644
--- a/arch/arm/boot/dts/bcm53573.dtsi
+++ b/arch/arm/boot/dts/bcm53573.dtsi
@@ -135,7 +135,7 @@ usb2: usb2@4000 {
 			#address-cells = <1>;
 			#size-cells = <1>;
 
-			ehci: ehci@4000 {
+			ehci: usb@4000 {
 				compatible = "generic-ehci";
 				reg = <0x4000 0x1000>;
 				interrupt-parent = <&gic>;
@@ -155,7 +155,7 @@ ehci_port2: port@2 {
 				};
 			};
 
-			ohci: ohci@d000 {
+			ohci: usb@d000 {
 				#usb-cells = <0>;
 
 				compatible = "generic-ohci";
-- 
2.40.1



