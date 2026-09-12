Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30BDA47AF6A;
	Sat, 12 Sep 2026 12:29:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789216177; cv=none; b=MCTk3L37JqxqhHP6I2GtA6NHEZT8YSbS0o2YucDmyyjY1e5ZpX7wwu03TgaUXrlWvBlX1s/PYfWRCMBULreuHrZ/1+Yj2ZR52RBHHA8SHS75Fm9kt5SnEHekTQBQlFL8AiM6KNkJbUyBrc5muZGxFcv4OYyoUNJjAuP+0GzMZSQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789216177; c=relaxed/simple;
	bh=q4BB2GAsUDKwsSgKJAWJl5HfEszBoczhSjGQc/6hyJY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pXuVK247J+WVWco/YoFrYsFeIyYJSlI6VuIYQ5awvLvxhOoRNbHiG9Tg2Ms6RwC2/nKvXJyMVEbXx23IBY126V0+qLh8qsShCLbqIsVEUaw7jfE77jFuYfWW8rW1+jqlkTNWBFYBocB+VLWA30Wo6d9mlruNJQPlyW0SWqbOyEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2IspY4Vq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2IspY4Vq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E61281F000FF;
	Sat, 12 Sep 2026 12:29:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789216174;
	bh=g90mQ/pnFl2QoOz4H+kcAXNSbCwFi94bJjsyK966fn8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2IspY4VqhhshwAkzm4yXnn4VIsa+MRjjiw/2ES2br9MhyPlLTwvOtgroVu6WeB46i
	 iOqCwiPWMGm/O9RNviJ+tll/UF2N4PCmUQHORsHV0EkfwcgNtD13Vas3eyBUqGStIC
	 o3qJnbpuTApKwKgfXje3NtxFHFHwlSIynnYcZBY4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fabio Estevam <festevam@gmail.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0682/1376] arm64: dts: rockchip: Fix Gru WLAN sideband interrupt
Date: Sat, 12 Sep 2026 08:51:48 +0200
Message-ID: <20260912065622.746374696@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index cacbad35cfc85..cf9fdb7d0cfb0 100644
--- a/arch/arm64/boot/dts/rockchip/rk3399-gru-chromebook.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3399-gru-chromebook.dtsi
@@ -510,8 +510,7 @@ &pci_rootport {
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



