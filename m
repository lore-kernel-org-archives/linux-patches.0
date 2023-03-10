Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A7528481
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 14:14:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 024F2C433EF;
	Fri, 10 Mar 2023 14:14:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678457665;
	bh=8D3S1plG5/IvHPJ038Bp2u2e3KxjRArLhnPbFBTqzSM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P1j5PI7zlVzgDloLjHGDW1uRKT2UFzKE8++cIFFkGs7gatw7/qyxyT6/IpPSQaeHC
	 iL7tWMU0Awb9SFl0/1ltW/WtdrvC9XtkSvhsULA4uaLV8bWUtEY3wIrbKcLtClMDfu
	 YoXyrhpVh6HaWV0VPrt8ewd9WGw/oOICX+SX5ng0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 016/252] arm64: dts: amlogic: meson-gxl: add missing unit address to eth-phy-mux node name
Date: Fri, 10 Mar 2023 14:36:26 +0100
Message-Id: <20230310133719.322312452@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133718.803482157@linuxfoundation.org>
References: <20230310133718.803482157@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Neil Armstrong <neil.armstrong@linaro.org>

[ Upstream commit d19189f70ba596798ea49166d2d1ef36a8df5289 ]

Fixes:
bus@c8834000: eth-phy-mux: {...} should not be valid under {'type': 'object'}

Link: https://lore.kernel.org/r/20230124-b4-amlogic-bindings-fixups-v1-9-44351528957e@linaro.org
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/amlogic/meson-gxl.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/amlogic/meson-gxl.dtsi b/arch/arm64/boot/dts/amlogic/meson-gxl.dtsi
index 5d7724b3a6123..f999a92d174b7 100644
--- a/arch/arm64/boot/dts/amlogic/meson-gxl.dtsi
+++ b/arch/arm64/boot/dts/amlogic/meson-gxl.dtsi
@@ -636,7 +636,7 @@ mux {
 		};
 	};
 
-	eth-phy-mux {
+	eth-phy-mux@55c {
 		compatible = "mdio-mux-mmioreg", "mdio-mux";
 		#address-cells = <1>;
 		#size-cells = <0>;
-- 
2.39.2



