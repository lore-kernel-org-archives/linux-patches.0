Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE408BA49
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 18:44:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E72DC433D2;
	Tue,  7 Mar 2023 18:44:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678214684;
	bh=BfDgy3MW6tdF01FishuZbSBalPpj1pCc/sgdM0abLEs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PD9QfzHm2cc1uxDxNYJUJ71Cx+JSrxKsON3ZjJG1XUOd6hHMqxhvItH3NlZm2LnIR
	 KziOCHN8mZNRvc1FKrFr2uk0Hn5lL+pTzBxTmiKBxcEi34YMaGmZb9SAvv2OVtHI1k
	 Mv+tP0/vjmA/6stAEAMR+uOG8P8t8S8Kw9ryctWw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 016/567] arm64: dts: meson-g12a: Fix internal Ethernet PHY unit name
Date: Tue,  7 Mar 2023 17:55:52 +0100
Message-Id: <20230307165906.541508614@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307165905.838066027@linuxfoundation.org>
References: <20230307165905.838066027@linuxfoundation.org>
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
index 2526d6e3a3dcb..899cfe416aef4 100644
--- a/arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi
+++ b/arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi
@@ -1733,7 +1733,7 @@ int_mdio: mdio@1 {
 					#address-cells = <1>;
 					#size-cells = <0>;
 
-					internal_ephy: ethernet_phy@8 {
+					internal_ephy: ethernet-phy@8 {
 						compatible = "ethernet-phy-id0180.3301",
 							     "ethernet-phy-ieee802.3-c22";
 						interrupts = <GIC_SPI 9 IRQ_TYPE_LEVEL_HIGH>;
-- 
2.39.2



