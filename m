Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 756302837B;
	Mon, 24 Feb 2025 14:58:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740409109; cv=none; b=nL8JbDlaEVLthiGOR7nRmrgG6cL0drNq173IImCMYwV8To12JdtBhBdrA65XARCS3yi/MdlCy76+Ul6LT4ial6o9WqdUAKtDmiHotp/q5jDC8kRAd8up2JQQ0w24PIiOkA5P9353RufG8N3Z7qdSW/4fpFyyHkvN/eNb/e7YAok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740409109; c=relaxed/simple;
	bh=ObWWzwQ74B94EIa0MlTo9srgheqzWi5jS6eN/zL0+iU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fHBT4UtJS80tR8EjzIbKnIsIDi60sPKwfSc3A75DOR5ebQExSbe8CaFw++DE180J9aqJeF5fvPBMfrVrJc7tRupjNGe7Z5Y7HYMLxSqn0PGgODzif1vuoaeDSxqApkUXkMXfeR8Z+lc4IjlSYWytkVL0Ok3HBqKsizXjoYb+sRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mM6L/rDT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mM6L/rDT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69541C4CED6;
	Mon, 24 Feb 2025 14:58:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740409109;
	bh=ObWWzwQ74B94EIa0MlTo9srgheqzWi5jS6eN/zL0+iU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mM6L/rDTiQnHpgRdRXMjXYkOJVs9n2/KpzKhBJWCo1c8j5XbodoxoWlsjQ+0nlHPw
	 uQYJ/L1hF+y3L3rXtWye0xZl7HyEj7iO/7r7pmZJvAoTT8ykdu6GdYOdwG90da5yJH
	 S4cq8dpQVNHya8aeffbkKKzb6rqajPuNQ7xS3JH4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vicente Bergas <vicencb@gmail.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 057/138] arm64: dts: rockchip: fix fixed-regulator renames on rk3399-gru devices
Date: Mon, 24 Feb 2025 15:34:47 +0100
Message-ID: <20250224142606.722324736@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224142604.442289573@linuxfoundation.org>
References: <20250224142604.442289573@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heiko Stuebner <heiko@sntech.de>

[ Upstream commit 2f9eb5262e63396a315c7da34a6c80c5d335df9f ]

rk3399-gru chromebooks have a regulator chains where one named regulator
supplies multiple regulators pp900-usb pp900_pcie that supply
the named peripherals.

The dtsi used somewhat creative structure to describe that in creating
the base node 3 times with different phandles and describing the EC
dependency in a comment.

This didn't register in the recent regulator-node renaming, as the
additional nodes were empty, so adapt the missing node names for now.

Fixes: 5c96e6330197 ("arm64: dts: rockchip: adapt regulator nodenames to preferred form")
Tested-by: Vicente Bergas <vicencb@gmail.com>
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Link: https://lore.kernel.org/r/20250116143631.3650469-1-heiko@sntech.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../dts/rockchip/rk3399-gru-chromebook.dtsi   |  8 +++----
 .../boot/dts/rockchip/rk3399-gru-scarlet.dtsi |  6 ++---
 arch/arm64/boot/dts/rockchip/rk3399-gru.dtsi  | 22 +++++++++----------
 3 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3399-gru-chromebook.dtsi b/arch/arm64/boot/dts/rockchip/rk3399-gru-chromebook.dtsi
index 988e6ca32fac9..a9ea4b0daa04c 100644
--- a/arch/arm64/boot/dts/rockchip/rk3399-gru-chromebook.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3399-gru-chromebook.dtsi
@@ -22,11 +22,11 @@ pp900_ap: regulator-pp900-ap {
 	};
 
 	/* EC turns on w/ pp900_usb_en */
-	pp900_usb: pp900-ap {
+	pp900_usb: regulator-pp900-ap {
 	};
 
 	/* EC turns on w/ pp900_pcie_en */
-	pp900_pcie: pp900-ap {
+	pp900_pcie: regulator-pp900-ap {
 	};
 
 	pp3000: regulator-pp3000 {
@@ -126,7 +126,7 @@ pp1800_pcie: regulator-pp1800-pcie {
 	};
 
 	/* Always on; plain and simple */
-	pp3000_ap: pp3000_emmc: pp3000 {
+	pp3000_ap: pp3000_emmc: regulator-pp3000 {
 	};
 
 	pp1500_ap_io: regulator-pp1500-ap-io {
@@ -160,7 +160,7 @@ pp3300_disp: regulator-pp3300-disp {
 	};
 
 	/* EC turns on w/ pp3300_usb_en_l */
-	pp3300_usb: pp3300 {
+	pp3300_usb: regulator-pp3300 {
 	};
 
 	/* gpio is shared with pp1800_pcie and pinctrl is set there */
diff --git a/arch/arm64/boot/dts/rockchip/rk3399-gru-scarlet.dtsi b/arch/arm64/boot/dts/rockchip/rk3399-gru-scarlet.dtsi
index 19b23b4389658..5e068377a0a28 100644
--- a/arch/arm64/boot/dts/rockchip/rk3399-gru-scarlet.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3399-gru-scarlet.dtsi
@@ -92,7 +92,7 @@ pp900_s3: regulator-pp900-s3 {
 	};
 
 	/* EC turns on pp1800_s3_en */
-	pp1800_s3: pp1800 {
+	pp1800_s3: regulator-pp1800 {
 	};
 
 	/* pp3300 children, sorted by name */
@@ -109,11 +109,11 @@ pp2800_cam: regulator-pp2800-avdd {
 	};
 
 	/* EC turns on pp3300_s0_en */
-	pp3300_s0: pp3300 {
+	pp3300_s0: regulator-pp3300 {
 	};
 
 	/* EC turns on pp3300_s3_en */
-	pp3300_s3: pp3300 {
+	pp3300_s3: regulator-pp3300 {
 	};
 
 	/*
diff --git a/arch/arm64/boot/dts/rockchip/rk3399-gru.dtsi b/arch/arm64/boot/dts/rockchip/rk3399-gru.dtsi
index 6d9e60b01225e..7eca1da78cffa 100644
--- a/arch/arm64/boot/dts/rockchip/rk3399-gru.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3399-gru.dtsi
@@ -189,39 +189,39 @@ ppvar_gpu: ppvar-gpu {
 	};
 
 	/* EC turns on w/ pp900_ddrpll_en */
-	pp900_ddrpll: pp900-ap {
+	pp900_ddrpll: regulator-pp900-ap {
 	};
 
 	/* EC turns on w/ pp900_pll_en */
-	pp900_pll: pp900-ap {
+	pp900_pll: regulator-pp900-ap {
 	};
 
 	/* EC turns on w/ pp900_pmu_en */
-	pp900_pmu: pp900-ap {
+	pp900_pmu: regulator-pp900-ap {
 	};
 
 	/* EC turns on w/ pp1800_s0_en_l */
-	pp1800_ap_io: pp1800_emmc: pp1800_nfc: pp1800_s0: pp1800 {
+	pp1800_ap_io: pp1800_emmc: pp1800_nfc: pp1800_s0: regulator-pp1800 {
 	};
 
 	/* EC turns on w/ pp1800_avdd_en_l */
-	pp1800_avdd: pp1800 {
+	pp1800_avdd: regulator-pp1800 {
 	};
 
 	/* EC turns on w/ pp1800_lid_en_l */
-	pp1800_lid: pp1800_mic: pp1800 {
+	pp1800_lid: pp1800_mic: regulator-pp1800 {
 	};
 
 	/* EC turns on w/ lpddr_pwr_en */
-	pp1800_lpddr: pp1800 {
+	pp1800_lpddr: regulator-pp1800 {
 	};
 
 	/* EC turns on w/ pp1800_pmu_en_l */
-	pp1800_pmu: pp1800 {
+	pp1800_pmu: regulator-pp1800 {
 	};
 
 	/* EC turns on w/ pp1800_usb_en_l */
-	pp1800_usb: pp1800 {
+	pp1800_usb: regulator-pp1800 {
 	};
 
 	pp3000_sd_slot: regulator-pp3000-sd-slot {
@@ -259,11 +259,11 @@ ppvar_sd_card_io: ppvar-sd-card-io {
 	};
 
 	/* EC turns on w/ pp3300_trackpad_en_l */
-	pp3300_trackpad: pp3300-trackpad {
+	pp3300_trackpad: regulator-pp3300-trackpad {
 	};
 
 	/* EC turns on w/ usb_a_en */
-	pp5000_usb_a_vbus: pp5000 {
+	pp5000_usb_a_vbus: regulator-pp5000 {
 	};
 
 	ap_rtc_clk: ap-rtc-clk {
-- 
2.39.5



