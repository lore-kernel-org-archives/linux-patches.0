Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B0B03346A6;
	Tue, 21 Jul 2026 17:40:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655619; cv=none; b=gBqtLZOU6k2p/O4vP87PeQfS34a8f0or2iiAxJueNPcwnfrgqB2V2MEzWYKZ7ujzqttVr66AsW8y/6FMOf1NJqJsrEXFkH+j1tZMIsy/FZywmCMIHTQE2MIesKB00cqJN3ZJBqhoFVH+EK8gVTbmpeOpdmjG8IzYr3VQ8ueRCq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655619; c=relaxed/simple;
	bh=vMWZD3viHcAetXmCLaWNb3JUAejULGdMQezOkjoVbAM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AWe67AexQV2FQ6BRgWFjaEtwwqv+BP2alu5GJnJ3NYalbQZdPgVC9T/rzOaGxPB29s2BQ19pf5U8oTVlPQ48JGhz7PiewQWjBrY3LWeWFWHdrb9adq5hW+fM/qeaL9wl6zXezFFWpdRDcBw2Zr4Y70OJTPA/+rxYpk9sqwcSfh8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SulXK3BY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SulXK3BY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 913251F000E9;
	Tue, 21 Jul 2026 17:40:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655618;
	bh=TJgxGxutMsP+lAgiA4vCAXahTL+WbWMXCfxDp/IV0ro=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SulXK3BYORScCAiA+eGDdc48tet0jwr2kJB7sTtOd/G2Geel8X/EmnWNHLGUI4oSS
	 2FRRw7wUSWE7j6AtTs6vvE/OJchAhOAx+aUc/9QiBJB7q67Ygj/g6wL5CQkdvb5NGp
	 9nvLX5UcrAM4mbRenWrX/xZvxK/o+tU6NzzQ3zns=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Diederik de Haas <diederik@cknow-tech.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0077/1611] arm64: dts: rockchip: Fix gmac0 reset pin for NanoPi R5S
Date: Tue, 21 Jul 2026 17:03:13 +0200
Message-ID: <20260721152516.573257473@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Diederik de Haas <diederik@cknow-tech.com>

[ Upstream commit c83c4a09d4c01c91d6c52d6d4d77a06892a3e83b ]

According to the NanoPi R5S 2204 schematic on page 6, GPIO0_C4 is for
GMAC0_INT/PMEB_GPIO0_C4, while GPIO0_C5 is for GMAC0_RSTn_GPIO0_C5.
While the 'reset-gpios' property was set correctly, the corresponding
pinctrl didn't match that.

Next to fixing the pinctrl definition, also change the node name and
phandle to match what is used in the schematic.

Fixes: c6629b9a6738 ("arm64: dts: rockchip: Add FriendlyElec Nanopi R5S")
Signed-off-by: Diederik de Haas <diederik@cknow-tech.com>
Link: https://patch.msgid.link/20260401131551.734456-2-diederik@cknow-tech.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3568-nanopi-r5s.dts | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3568-nanopi-r5s.dts b/arch/arm64/boot/dts/rockchip/rk3568-nanopi-r5s.dts
index 718d1a2da8e568..90ce6f0e1dcff7 100644
--- a/arch/arm64/boot/dts/rockchip/rk3568-nanopi-r5s.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3568-nanopi-r5s.dts
@@ -98,7 +98,7 @@ &mdio0 {
 	rgmii_phy0: ethernet-phy@1 {
 		compatible = "ethernet-phy-ieee802.3-c22";
 		reg = <1>;
-		pinctrl-0 = <&eth_phy0_reset_pin>;
+		pinctrl-0 = <&gmac0_rstn_gpio0_c5_pin>;
 		pinctrl-names = "default";
 	};
 };
@@ -132,8 +132,8 @@ &pcie3x2 {
 
 &pinctrl {
 	gmac0 {
-		eth_phy0_reset_pin: eth-phy0-reset-pin {
-			rockchip,pins = <0 RK_PC4 RK_FUNC_GPIO &pcfg_pull_up>;
+		gmac0_rstn_gpio0_c5_pin: gmac0-rstn-gpio0-c5-pin {
+			rockchip,pins = <0 RK_PC5 RK_FUNC_GPIO &pcfg_pull_up>;
 		};
 	};
 
-- 
2.53.0



