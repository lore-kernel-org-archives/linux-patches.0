Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 461816BB29;
	Thu, 11 Apr 2024 10:45:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712832325; cv=none; b=Ln3/ZFa4WhLLdxez0rzk5qTwSBMgQyBo2nb2PxC1PFJPkGs/0x8VhDWQ16bgNCrOso9pFcmVWN4bgvN4p4wdEIcKP8DmlDGp1MIIX8iosrZEsXEdNy5LtbpgKj77H4qBucd4DkWBTDiBVlRyNxnUhxsXvFrYX8XBgFbuInb2THM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712832325; c=relaxed/simple;
	bh=E3KsEd78TU8gtv6VAsMk4p1eZ/Ipxz0xtnH7E2y07Q8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BuoBXHMBoBsOM6GeMXBSqZI9P+I27/HGM8/TjEsB5tgylulp7k9S0YQVXo0nw0UKAvZIKY+kEACpFyov5GvY2EVQmJc8KPxpCgiMI4Ft5/i6Sa/fYAizjbVhPwh+9fyBZjmMMpDW0iCaWS1RDJMLIaQCwdlVNbg30m14ZzVcBbk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yECMbTFb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yECMbTFb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BF7BC433F1;
	Thu, 11 Apr 2024 10:45:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712832324;
	bh=E3KsEd78TU8gtv6VAsMk4p1eZ/Ipxz0xtnH7E2y07Q8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yECMbTFbfmo+Yr0AIiJD2Dx6f3oufiN79iPY85fMfeRlqeVNdImSh5m9zNddo8gBl
	 pMnTXBXtf4WIzPZKEATJdEwbJr94SFgoVhfsPK84iP272Q+zTidRYI+uISFNEz3Q3f
	 uK0QYoU4PnUQOK4VawtEn9hvf2If/9r71/WDx1wE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Jonker <jbx6244@gmail.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 11/83] arm64: dts: rockchip: fix rk3399 hdmi ports node
Date: Thu, 11 Apr 2024 11:56:43 +0200
Message-ID: <20240411095413.017030642@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095412.671665933@linuxfoundation.org>
References: <20240411095412.671665933@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Jonker <jbx6244@gmail.com>

[ Upstream commit f051b6ace7ffcc48d6d1017191f167c0a85799f6 ]

Fix rk3399 hdmi ports node so that it matches the
rockchip,dw-hdmi.yaml binding.

Signed-off-by: Johan Jonker <jbx6244@gmail.com>
Link: https://lore.kernel.org/r/a6ab6f75-3b80-40b1-bd30-3113e14becdd@gmail.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3399.dtsi | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3399.dtsi b/arch/arm64/boot/dts/rockchip/rk3399.dtsi
index a7e6eccb14cc6..8363cc13ec517 100644
--- a/arch/arm64/boot/dts/rockchip/rk3399.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3399.dtsi
@@ -1906,6 +1906,7 @@ simple-audio-card,codec {
 	hdmi: hdmi@ff940000 {
 		compatible = "rockchip,rk3399-dw-hdmi";
 		reg = <0x0 0xff940000 0x0 0x20000>;
+		reg-io-width = <4>;
 		interrupts = <GIC_SPI 23 IRQ_TYPE_LEVEL_HIGH 0>;
 		clocks = <&cru PCLK_HDMI_CTRL>,
 			 <&cru SCLK_HDMI_SFR>,
@@ -1914,13 +1915,16 @@ hdmi: hdmi@ff940000 {
 			 <&cru PLL_VPLL>;
 		clock-names = "iahb", "isfr", "cec", "grf", "ref";
 		power-domains = <&power RK3399_PD_HDCP>;
-		reg-io-width = <4>;
 		rockchip,grf = <&grf>;
 		#sound-dai-cells = <0>;
 		status = "disabled";
 
 		ports {
-			hdmi_in: port {
+			#address-cells = <1>;
+			#size-cells = <0>;
+
+			hdmi_in: port@0 {
+				reg = <0>;
 				#address-cells = <1>;
 				#size-cells = <0>;
 
@@ -1933,6 +1937,10 @@ hdmi_in_vopl: endpoint@1 {
 					remote-endpoint = <&vopl_out_hdmi>;
 				};
 			};
+
+			hdmi_out: port@1 {
+				reg = <1>;
+			};
 		};
 	};
 
-- 
2.43.0



