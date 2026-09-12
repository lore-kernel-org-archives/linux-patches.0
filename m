Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18CEA27AC31;
	Sat, 12 Sep 2026 07:58:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789199937; cv=none; b=cAnQ9oKIIZlD6BX0ihR5anfNP/OX6R44izquzQqr6jdxMg2EBhhnYKJ52y956U8/VBSaRh7Iq+WiKjzaCZ4nTfYGdaPOjl4r7zne7x990BVOOs9jY8lZqeucKTU5SN36eNHWvAiSunu0azDX/C0Da+XjbUynuADLuHnlmehN4oU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789199937; c=relaxed/simple;
	bh=evbI0DTWq5FoA69WKaFgHp+yr5Ojdeknm/mEFXDhiDY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WlAFBiah/YhTljdil7SFuN5jOUJLouGzMS12RTJyDNcvR21VyMDdGiz2Br/L0BKaeioLIckpkUXUhJcFVdiCCIMEa8i+Pw1FLvSCW/bIfqHFXLdj8g7MGlmkTh/H9CRl5tGugm0Ck5UBPmZUqieycWKcXWDgPLOD7k6AjGGOHh8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RGAej7GI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RGAej7GI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B95D41F000FF;
	Sat, 12 Sep 2026 07:58:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789199935;
	bh=XB0WhqJc5ntvl3LXDt12d3MWJ+DSTKCx6SW678iFr5U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RGAej7GIMMFzLN3WPEPTsFRP1zLWm7kUDvCk24dows/AfsjGKHnR4UPGqj8spZ9Po
	 J23ffB5JWxCPIlyvhlgXhw2F0wWxR+UGtHMaH+A/SRZGlqfCgdSLA8PglYqb6/cfI7
	 d2ZQcZ8m8gM9ztHuTzX5TlSN/jDRqfwgcD/Epi5k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fabio Estevam <festevam@gmail.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0644/1815] arm64: dts: rockchip: Fix Gru WLAN sideband interrupt
Date: Sat, 12 Sep 2026 08:39:54 +0200
Message-ID: <20260912065704.000086045@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 3f3cb0eb58096..5435fbc270954 100644
--- a/arch/arm64/boot/dts/rockchip/rk3399-gru-chromebook.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3399-gru-chromebook.dtsi
@@ -505,8 +505,7 @@ &pci_rootport {
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



