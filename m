Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E77B48AE20;
	Sat, 12 Sep 2026 18:51:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789239106; cv=none; b=m8s61L08zwzcVv35N8ftNPnmtEbTM1ay1WCbeYUxJjpXWxF07o3KAEpgk4KBJX/YSMXCcX+SVBfmAL8s7IfxsRazT9OeocwYVDJmm2/uoK2E8881Ph4IHvLybwYX/m88IfQGzYETnrttr1w8wCzhJ00+S5NwhY3Xj42gX0siUrU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789239106; c=relaxed/simple;
	bh=w8wKEdrcyg3yDdnUVx0T3YmZr7/382lRjg9Ct+J/L30=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dzd0hfU6pxh1AMlw51m5WpIroPRmK3msXalEZGXH+WmWe0TrxpKuyxjBxHJo9zFUx9uGUvVqnBaDR4R9fzmYAqFwJEkT72veO2Z+eXAwTZ+PQ0SRNy7HSiyfmgT9gHwCRTbQLh2nuQKTyv+Ca5i4BMA0RHubKdXFi1SQaG6YzLM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s2gUPHLp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s2gUPHLp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD4511F000FF;
	Sat, 12 Sep 2026 18:51:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789239105;
	bh=8lTUbXp0MgbGIf/5OWXkxu5RJ2jtVWH1E4cCnCZNyM0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=s2gUPHLpbLA492orP6hmjmauPjWuIuOJN8lUq8bEi8MANlqR4BagPTWgx0b/gKdYN
	 b7PGym4Yk7H6EMSPElo0pf+aplZ5yFZnv2tRC8ufoX7PWinzfYIo3ho3Ui2QMGxx5+
	 yA7lQYmfMy5xXNhK7zWCa50gEuJF9eFeiJub3H0I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fabio Estevam <festevam@gmail.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 598/935] arm64: dts: rockchip: Fix Gru WLAN sideband interrupt
Date: Sat, 12 Sep 2026 09:00:28 +0200
Message-ID: <20260912065540.556385900@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 3ac88d35c8f15..acff3f8050f67 100644
--- a/arch/arm64/boot/dts/rockchip/rk3399-gru-chromebook.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3399-gru-chromebook.dtsi
@@ -328,8 +328,7 @@ &pci_rootport {
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



