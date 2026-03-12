Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8A8234A797;
	Thu, 12 Mar 2026 20:19:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773346766; cv=none; b=pgbZ75oTZJ2ma1E8RGL0oLbzvCcqCsbrAzhT1NOlycVt2tgyQ+5drbqGkVENykEHHZwd5GXQjoFCW48B9MtkKO/E0qPgG9pUDxCSchEd3krZpvQuzezcm6XKb3P5J9PQdkaPn1eDo9c//TtcocBZHIFuGgdvwUlQNlo5jja1AK4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773346766; c=relaxed/simple;
	bh=X+teHf4ULmpw510uhRzKW4y8tBo5IjiqeezQyryGyVM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jTss4w6czBsQoA1lZ0gR8TbwQ1mBKYizQPzsED1729y84rctof7tInnMWfPuHBgSGlRO3WPgspUM6ovtHGzmkHBTzTb+lQygevoVGat56FeMuDSTPu++0V5ThMVLljsA2G91np7rMtkkX0M2e5BbjOERxpbXctc1p32+m0yBRn0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gk9ciOM8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gk9ciOM8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50A82C19425;
	Thu, 12 Mar 2026 20:19:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773346766;
	bh=X+teHf4ULmpw510uhRzKW4y8tBo5IjiqeezQyryGyVM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gk9ciOM8hQlUx4KMQCwDX/qtb8ZFuUCvuLiCrJyq0fXHuiLt026qcZe4L0H+qR2vn
	 7K7pgA1ElkyxDUGOPy1hVWKrfAoWhxBsy1eO+bb4SO49X+rF9JJmxM2B7HPh8X9Un7
	 etX4onLChwZ69aDFTqHT8YaBQv+IPzUijlWi331U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Shawn Lin <shawn.lin@rock-chips.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 086/265] arm64: dts: rockchip: Fix rk3588 PCIe range mappings
Date: Thu, 12 Mar 2026 21:07:53 +0100
Message-ID: <20260312201021.326489204@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260312201018.128816016@linuxfoundation.org>
References: <20260312201018.128816016@linuxfoundation.org>
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

From: Shawn Lin <shawn.lin@rock-chips.com>

[ Upstream commit 46c56b737161060dfa468f25ae699749047902a2 ]

The pcie bus address should be mapped 1:1 to the cpu side MMIO address, so
that there is no same address allocated from normal system memory. Otherwise
it's broken if the same address assigned to the EP for DMA purpose.Fix it to
sync with the vendor BSP.

Fixes: 0acf4fa7f187 ("arm64: dts: rockchip: add PCIe3 support for rk3588")
Fixes: 8d81b77f4c49 ("arm64: dts: rockchip: add rk3588 PCIe2 support")
Cc: stable@vger.kernel.org
Cc: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Shawn Lin <shawn.lin@rock-chips.com>
Link: https://patch.msgid.link/1767600929-195341-2-git-send-email-shawn.lin@rock-chips.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3588-base.dtsi  | 4 ++--
 arch/arm64/boot/dts/rockchip/rk3588-extra.dtsi | 6 +++---
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3588-base.dtsi b/arch/arm64/boot/dts/rockchip/rk3588-base.dtsi
index ad4331bc07806..68801eb5713d1 100644
--- a/arch/arm64/boot/dts/rockchip/rk3588-base.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3588-base.dtsi
@@ -1650,7 +1650,7 @@ pcie2x1l1: pcie@fe180000 {
 		power-domains = <&power RK3588_PD_PCIE>;
 		ranges = <0x01000000 0x0 0xf3100000 0x0 0xf3100000 0x0 0x00100000>,
 			 <0x02000000 0x0 0xf3200000 0x0 0xf3200000 0x0 0x00e00000>,
-			 <0x03000000 0x0 0x40000000 0x9 0xc0000000 0x0 0x40000000>;
+			 <0x03000000 0x9 0xc0000000 0x9 0xc0000000 0x0 0x40000000>;
 		reg = <0xa 0x40c00000 0x0 0x00400000>,
 		      <0x0 0xfe180000 0x0 0x00010000>,
 		      <0x0 0xf3000000 0x0 0x00100000>;
@@ -1701,7 +1701,7 @@ pcie2x1l2: pcie@fe190000 {
 		power-domains = <&power RK3588_PD_PCIE>;
 		ranges = <0x01000000 0x0 0xf4100000 0x0 0xf4100000 0x0 0x00100000>,
 			 <0x02000000 0x0 0xf4200000 0x0 0xf4200000 0x0 0x00e00000>,
-			 <0x03000000 0x0 0x40000000 0xa 0x00000000 0x0 0x40000000>;
+			 <0x03000000 0xa 0x00000000 0xa 0x00000000 0x0 0x40000000>;
 		reg = <0xa 0x41000000 0x0 0x00400000>,
 		      <0x0 0xfe190000 0x0 0x00010000>,
 		      <0x0 0xf4000000 0x0 0x00100000>;
diff --git a/arch/arm64/boot/dts/rockchip/rk3588-extra.dtsi b/arch/arm64/boot/dts/rockchip/rk3588-extra.dtsi
index 0ce0934ec6b79..8af2e5b59e1ac 100644
--- a/arch/arm64/boot/dts/rockchip/rk3588-extra.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3588-extra.dtsi
@@ -168,7 +168,7 @@ pcie3x4: pcie@fe150000 {
 		power-domains = <&power RK3588_PD_PCIE>;
 		ranges = <0x01000000 0x0 0xf0100000 0x0 0xf0100000 0x0 0x00100000>,
 			 <0x02000000 0x0 0xf0200000 0x0 0xf0200000 0x0 0x00e00000>,
-			 <0x03000000 0x0 0x40000000 0x9 0x00000000 0x0 0x40000000>;
+			 <0x03000000 0x9 0x00000000 0x9 0x00000000 0x0 0x40000000>;
 		reg = <0xa 0x40000000 0x0 0x00400000>,
 		      <0x0 0xfe150000 0x0 0x00010000>,
 		      <0x0 0xf0000000 0x0 0x00100000>;
@@ -254,7 +254,7 @@ pcie3x2: pcie@fe160000 {
 		power-domains = <&power RK3588_PD_PCIE>;
 		ranges = <0x01000000 0x0 0xf1100000 0x0 0xf1100000 0x0 0x00100000>,
 			 <0x02000000 0x0 0xf1200000 0x0 0xf1200000 0x0 0x00e00000>,
-			 <0x03000000 0x0 0x40000000 0x9 0x40000000 0x0 0x40000000>;
+			 <0x03000000 0x9 0x40000000 0x9 0x40000000 0x0 0x40000000>;
 		reg = <0xa 0x40400000 0x0 0x00400000>,
 		      <0x0 0xfe160000 0x0 0x00010000>,
 		      <0x0 0xf1000000 0x0 0x00100000>;
@@ -303,7 +303,7 @@ pcie2x1l0: pcie@fe170000 {
 		power-domains = <&power RK3588_PD_PCIE>;
 		ranges = <0x01000000 0x0 0xf2100000 0x0 0xf2100000 0x0 0x00100000>,
 			 <0x02000000 0x0 0xf2200000 0x0 0xf2200000 0x0 0x00e00000>,
-			 <0x03000000 0x0 0x40000000 0x9 0x80000000 0x0 0x40000000>;
+			 <0x03000000 0x9 0x80000000 0x9 0x80000000 0x0 0x40000000>;
 		reg = <0xa 0x40800000 0x0 0x00400000>,
 		      <0x0 0xfe170000 0x0 0x00010000>,
 		      <0x0 0xf2000000 0x0 0x00100000>;
-- 
2.51.0



