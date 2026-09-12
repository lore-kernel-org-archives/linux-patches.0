Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 610404248DB;
	Sat, 12 Sep 2026 10:16:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789208201; cv=none; b=h+W/4CDrRpYlmmmzuZ3+Te4KytNAEtW/HfoOdle0iVE4atyBRaG3VgyYgQskBwSpQcGL3SRWNCO4Sj7+AzO85hUt/rSpJ2qso4/BbimgXP2w97TyTzfqZkLL+E5XOSjXFnIdY1f97gICWjyLuaDDPfL82fmWeQWNjrKd1UB1BYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789208201; c=relaxed/simple;
	bh=6n4EvJ/jiJs8diiGKT8SSjyOiLnrgTHprSmdeIyncHM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CmB89ToL1Rgp2cB0W9mS9fewz5KdmR5oyMEqvIlf0+7IBYkpWKP4fAAzLzLpUaezwOQQw5atDGQHQxgfdQPoQ7SNHOCQQIK9BoVZFjqmlhGIiQUKUgFnKN4nqTOdMkbwDBgfkNmfD8AWde/0ej1io0gqBZQ3EANi1jVddVQbwkE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mWrPVg3f; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mWrPVg3f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 018571F000FF;
	Sat, 12 Sep 2026 10:16:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789208192;
	bh=1dgT/wxtI05GhcOQNBqAkrm4JGHLZyarb2U5TdhVvFg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mWrPVg3fuvB2l53CjGj6WHw5r6DFz7xkslB040NN7DjYL6LQISv4/7K9NxEYPbVG+
	 uV4WzwUgL6kWm7iIdfe2Ct+PYxMpt7UjcASr8ndUY33QNlWEq4o4vB0b9AfCE0V5Yy
	 q1jkArXnXQGa2TiYjh8KpqAIjkmiTd7Cyr2Ew9wY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fabio Estevam <festevam@gmail.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0569/1518] arm64: dts: rockchip: Fix Gru WLAN sideband interrupt
Date: Sat, 12 Sep 2026 08:45:38 +0200
Message-ID: <20260912065636.304010268@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

From: Fabio Estevam <festevam@gmail.com>

[ Upstream commit a761818d9ee11183df0aefd16bf9fe46cc1c4c6d ]

The Marvell WLAN host wake interrupt is wired to GPIO0 8 and is not
one of the PCI INTx interrupts. The PCI device schema therefore
interprets the two-cell GPIO interrupt specifier as an invalid PCI
interrupt and reports dtbs_check warnings:

pcie@0,0: wifi@0,0:interrupts:0:0: 8 is not one of [1, 2, 3, 4]
pcie@0,0: wifi@0,0:interrupts:0: [8, 8] is too long

Describe the sideband interrupt with interrupts-extended, which
explicitly carries the interrupt controller and removes the ambiguity.

Fixes: 48f4d9796d99 ("arm64: dts: rockchip: add Gru/Kevin DTS")
Signed-off-by: Fabio Estevam <festevam@gmail.com>
Link: https://patch.msgid.link/20260721133445.44283-1-festevam@gmail.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3399-gru-chromebook.dtsi | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3399-gru-chromebook.dtsi b/arch/arm64/boot/dts/rockchip/rk3399-gru-chromebook.dtsi
index 9d07353df52c8..b44668c902b79 100644
--- a/arch/arm64/boot/dts/rockchip/rk3399-gru-chromebook.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3399-gru-chromebook.dtsi
@@ -503,8 +503,7 @@ &pci_rootport {
 	mvl_wifi: wifi@0,0 {
 		compatible = "pci1b4b,2b42";
 		reg = <0x0000 0x0 0x0 0x0 0x0>;
-		interrupt-parent = <&gpio0>;
-		interrupts = <8 IRQ_TYPE_LEVEL_LOW>;
+		interrupts-extended = <&gpio0 8 IRQ_TYPE_LEVEL_LOW>;
 		pinctrl-names = "default";
 		pinctrl-0 = <&wlan_host_wake_l>;
 		wakeup-source;
-- 
2.53.0



