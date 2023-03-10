Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCE90881F
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 14:44:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B34BC433D2;
	Fri, 10 Mar 2023 14:44:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678459461;
	bh=HL1Pq4Cxb3AdTXOeblMW66KY7uEqRPVcd3KtZAnO9Go=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ngx53NM0/Cd+sBtK0w5gAFRzgeF8mblWyI9HSrFlOpxrLe/2sUuPTMQsV7xazdxES
	 fmWucPipbEHJRorJs58LWMZa1IA0yELBpYo+5MCrft2oyvq+cL6sseSKAIfM1Ka97f
	 Kwh2nHc65XNdlBAvrvwuZC8amMOcq6Ph4/hmNIa0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 012/529] arm64: dts: meson-g12a: Fix internal Ethernet PHY unit name
Date: Fri, 10 Mar 2023 14:32:35 +0100
Message-Id: <20230310133805.590730046@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133804.978589368@linuxfoundation.org>
References: <20230310133804.978589368@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>

[ Upstream commit e7303651bbc76c848007f1cfac1fbeaa65f600d1 ]

Documentation/devicetree/bindings/net/ethernet-phy.yaml defines that the
node name for Ethernet PHYs should match the following pattern:
  ^ethernet-phy(@[a-f0-9]+)?$

Replace the underscore with a hyphen to adhere to this binding.

Fixes: 280c17df8fbf ("arm64: dts: meson: g12a: add mdio multiplexer")
Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://lore.kernel.org/r/20230111211350.1461860-6-martin.blumenstingl@googlemail.com
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi b/arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi
index 2091db7c9b8af..c0defb36592d0 100644
--- a/arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi
+++ b/arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi
@@ -1727,7 +1727,7 @@ int_mdio: mdio@1 {
 					#address-cells = <1>;
 					#size-cells = <0>;
 
-					internal_ephy: ethernet_phy@8 {
+					internal_ephy: ethernet-phy@8 {
 						compatible = "ethernet-phy-id0180.3301",
 							     "ethernet-phy-ieee802.3-c22";
 						interrupts = <GIC_SPI 9 IRQ_TYPE_LEVEL_HIGH>;
-- 
2.39.2



