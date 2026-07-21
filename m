Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C83F46AA6B;
	Tue, 21 Jul 2026 15:35:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648122; cv=none; b=KtSI2Q/3nfX0LzFaoiG9lk5O1Inhi02DdPDeO4fE7UHmgkthXZeHgFOxK1jVItMZJH4fI1AQjgFgOYi/aerTJRlChbfoFalUaovUW458Rq9D+KCyFnuC4081+xVLBW/NbL02lDVZiWLsZVqlQR6mFUjUMznQTjH97E3NrONWJAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648122; c=relaxed/simple;
	bh=782t4NbR5cwJK9KxaZumlJs49EXaUrjW8kpxgEsVpks=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fFa0ndDGY/BuwpNMuQWAzwwUBv0MEfSCoKsUHDmFsR8jSqNH1lu2yGE11CSRwcVNt5FQrF168k/ebrhj49gIsqPoWw/ryvytblsp+IvGqZAY5ir8KsqDDcWgbxaZJCY+/rsMwYDbDVn3G+GhiUuX6DwNn0Sat8GYI7vGrx9xK50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2hsf2nMT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2hsf2nMT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1F2F1F000E9;
	Tue, 21 Jul 2026 15:35:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648121;
	bh=yLEtu0Hu0QtUxfcb85UE3nh3vsou1FUOgfQrTszMnNE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2hsf2nMTKkfUMv99M+UwKjIn5XY5XAv8ksOXn+X7h9gg+kQqUZyzevXbNY9rdDqkx
	 HQ5G8CEXJDhXCvl9JH/+VwczOSoVGkZPmCRKe5R4RyRuZYVz8wrKMrEIdwRaGsL0vZ
	 C4CiRY9/ve2aN35mUMpY0bAvGuRwZjOZKm/VZ36g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Diederik de Haas <diederik@cknow-tech.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0078/2077] arm64: dts: rockchip: Fix gmac0 reset pin for NanoPi R5S
Date: Tue, 21 Jul 2026 16:55:51 +0200
Message-ID: <20260721152554.532912497@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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



