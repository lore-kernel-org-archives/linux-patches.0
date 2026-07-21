Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4689F403B13;
	Tue, 21 Jul 2026 20:27:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784665648; cv=none; b=UxqAMcu3sMB0PXTeT2iWEjL/VAvomEAMKoF+QLxFgzuO+o06vSea0Vd331y/oTdPNGDVFYlzX+hAVDXoAExikr0FBAY87ZDQOf+rBFzbC9NpbKXPibJu8BjRE9ogN/MjsTj8MwmER8cBqs82qzdUnAP9P6d81fVhl1SFTy0iHm0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784665648; c=relaxed/simple;
	bh=p0DpB+NwBGXxIo1UOvdlwexJ/h830Ly7B2RFgvugtUI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MZU4XlEUFKY92jMgdgxUU+VnYxotZpCZV2BU8xq4Ttx9BRt8ZgrTc6Tnqfuo+XkRCxYu+iaUiqPWSIairshQxk2ZKt8oIDsR4KDdPJtvB1hoNYi7yA6f7nBU6+3GldlW1DnULna+DFBz36cRBTi4HwjWv7TSMQWtShpXcqRXhaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YBXkd/rj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YBXkd/rj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC72A1F000E9;
	Tue, 21 Jul 2026 20:27:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784665647;
	bh=sXmSo+wyi1Vtux6bwbC1pny7lXDGoHzcOx9Ld/F9iug=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YBXkd/rj0XGSFPYePpaZCGleonnbJEsQqdCQ3+KLScoX/Jl5GVcGB75PLSvMXfRKQ
	 Aur7sUyRlCnaQfVEc7xwuE1NUgxQ0WHq8UEB6Wk0I2PvlQN4KsVjXWMhQh3GlAd4Jh
	 ZqTPpy3U49Y5o9n4E3XpMtEz1YZ42KRzPwPVnJMA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Diederik de Haas <diederik@cknow-tech.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0366/1266] arm64: dts: rockchip: Fix gmac0 reset pin for NanoPi R5S
Date: Tue, 21 Jul 2026 17:13:23 +0200
Message-ID: <20260721152450.016581637@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index b6ad8328c7ebc4..b9f4b6e63d47d2 100644
--- a/arch/arm64/boot/dts/rockchip/rk3568-nanopi-r5s.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3568-nanopi-r5s.dts
@@ -77,7 +77,7 @@ &mdio0 {
 	rgmii_phy0: ethernet-phy@1 {
 		compatible = "ethernet-phy-ieee802.3-c22";
 		reg = <1>;
-		pinctrl-0 = <&eth_phy0_reset_pin>;
+		pinctrl-0 = <&gmac0_rstn_gpio0_c5_pin>;
 		pinctrl-names = "default";
 	};
 };
@@ -111,8 +111,8 @@ &pcie3x2 {
 
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



