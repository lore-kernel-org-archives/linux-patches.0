Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BE7346AA71;
	Tue, 21 Jul 2026 15:35:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648117; cv=none; b=rv7v1I+aqIZ8H7Cc/flI6F95oin8vRr/QQEHm+8X4QoL8T0DHPkkhepgBgWB0c7ckPnG+Cm84P1cIfkyZV2yMuqvEiu/zqM+AeUj71VKM7OfQoSglKqyaaGTyDD4iLVu+UNjg44wAxTvUAqH/sbSOdoMNL5tb3gDV90HliqAOrE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648117; c=relaxed/simple;
	bh=/JmJJDuwTWNOqjfBGdOjozG1POTtvPMkqn5x5yEC5lg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QU/RgSMtGhP/KpuqCQPiEjyHuffNhOliSBAk4z3sTTtJHo9pK+xP8VK5bkSbuqS2s/S6CdG40US9OjymoXDJrEuZzIOhmHieotMIGb4ucswkefEVSmAYivY7oUOznX18zk3WNUeF6CWpQDrj/j2a7SkhCnfGfyRyzLrTXtcqCBw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s/TQVPgL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s/TQVPgL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABEBE1F00A3A;
	Tue, 21 Jul 2026 15:35:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648116;
	bh=sDJRFdsR8xXiJTPaFlQwumQi9OPw4zDZ+g7seYf6icE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=s/TQVPgLx4KF0W8gw6l9e9ZfOMBDdBcjSM0rprkBxQrVT1tJzEtQ3veLXEYv75VzT
	 juDlzxRMHW9JdDV/BIo6LDQU0tBGPS/Sr2y39pVSthX4DDrVhC6d+xyA1XDG9E6zVJ
	 olv5wFszln0lDA6LYLNQySKohohi4NhXBLVGGfGQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cristian Ciocaltea <cristian.ciocaltea@collabora.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0076/2077] arm64: dts: rockchip: Update vdec register blocks order on RK3588
Date: Tue, 21 Jul 2026 16:55:49 +0200
Message-ID: <20260721152554.486247901@linuxfoundation.org>
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

From: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>

[ Upstream commit b481c11cd20a114c4df35f3b1ecd28b05e622067 ]

With the introduction of the RK3588 SoC, three register blocks have been
provided for the video decoder unit instead of just one, which are
further referenced in the vendor's datasheet by 'link table', 'function'
and 'cache'.  The former is present at the top of the listing, starting
at video decoder unit base address, but the binding got this wrong
initially, i.e. the 'function' block got listed before the 'link' one.

Since the video decoder support for the aforementioned SoC in mainline
driver and devicetrees hasn't been released yet (just landed in
v7.0-rc1), address the problem by providing the register blocks for
vdec0 & vdec1 nodes using the 'link,function,cache' listing, which
ensures the unit address points to the primary register range.

This aligns with a similar fix for RK3576, where DTC also complained
about the bus address format.

Fixes: f61731bd6062 ("arm64: dts: rockchip: Add the vdpu381 Video Decoders on RK3588")
Signed-off-by: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
Link: https://patch.msgid.link/20260304-vdec-reg-order-rk3576-v5-4-7006fad42c3a@collabora.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3588-base.dtsi | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3588-base.dtsi b/arch/arm64/boot/dts/rockchip/rk3588-base.dtsi
index 4fb8888c281c8c..d4dc057e31f0e3 100644
--- a/arch/arm64/boot/dts/rockchip/rk3588-base.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3588-base.dtsi
@@ -1355,10 +1355,10 @@ vepu121_3_mmu: iommu@fdbac800 {
 
 	vdec0: video-codec@fdc38000 {
 		compatible = "rockchip,rk3588-vdec";
-		reg = <0x0 0xfdc38100 0x0 0x500>,
-		      <0x0 0xfdc38000 0x0 0x100>,
+		reg = <0x0 0xfdc38000 0x0 0x100>,
+		      <0x0 0xfdc38100 0x0 0x500>,
 		      <0x0 0xfdc38600 0x0 0x100>;
-		reg-names = "function", "link", "cache";
+		reg-names = "link", "function", "cache";
 		interrupts = <GIC_SPI 95 IRQ_TYPE_LEVEL_HIGH 0>;
 		clocks = <&cru ACLK_RKVDEC0>, <&cru HCLK_RKVDEC0>, <&cru CLK_RKVDEC0_CA>,
 			 <&cru CLK_RKVDEC0_CORE>, <&cru CLK_RKVDEC0_HEVC_CA>;
@@ -1387,10 +1387,10 @@ vdec0_mmu: iommu@fdc38700 {
 
 	vdec1: video-codec@fdc40000 {
 		compatible = "rockchip,rk3588-vdec";
-		reg = <0x0 0xfdc40100 0x0 0x500>,
-		      <0x0 0xfdc40000 0x0 0x100>,
+		reg = <0x0 0xfdc40000 0x0 0x100>,
+		      <0x0 0xfdc40100 0x0 0x500>,
 		      <0x0 0xfdc40600 0x0 0x100>;
-		reg-names = "function", "link", "cache";
+		reg-names = "link", "function", "cache";
 		interrupts = <GIC_SPI 97 IRQ_TYPE_LEVEL_HIGH 0>;
 		clocks = <&cru ACLK_RKVDEC1>, <&cru HCLK_RKVDEC1>, <&cru CLK_RKVDEC1_CA>,
 			 <&cru CLK_RKVDEC1_CORE>, <&cru CLK_RKVDEC1_HEVC_CA>;
-- 
2.53.0



