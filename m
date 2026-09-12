Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F64334752E;
	Sat, 12 Sep 2026 07:58:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789199932; cv=none; b=SKdork+kQNT1ejVDm2bQBlg1G4Vfay3289gXVKRfBeZJH//ahDhcwuNv54BmcaBiwdHZPyMsvOXIchiEdekHd6T+rRSu8oekdzRwWs1my8Ildm37laCdwfjCdL3Gc/eLkM5A63jkMLJ3g9pPlGBLJnP26Yjz/qBN+4JyRedBzZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789199932; c=relaxed/simple;
	bh=zyU7ERbtlO8SP9OT0wSgP85vCok6nkRpyaPkdAv08gU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A47iAuEbDftOsxLIPVfVohNzikaMAGFh2oI95QFzPi1jd1rlNgfkcXeGA7H8ezlv+E9xE+vH+6mKHRJz8FKkURQwZltDfzWxs9o3IFGMVmek3U6vwQyThT4cYk6QhS1nlC6+8/Y5E99YWVZQuSQp5nXc+42PvoUzcwXU0mPVfMk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pfeVXCl5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pfeVXCl5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3FC51F000FF;
	Sat, 12 Sep 2026 07:58:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789199931;
	bh=4lDkrvHp32Miu4ZhWh3tUfF/ctntF+cKmsrN9X3acvY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pfeVXCl5pYxvczHaHUFVc3R2DwBRDMnoe6fMxewB3/ZwJuKcDR1A7rG4MsarykW+d
	 BS1SRSRul1mL3y7NkXlsSYYNJ5OuYnBVdI63OJsYm6AbS10mLSxKpTjwtuhCNvW54f
	 9+a0urn3TYmeuKgwtkAncRRwg/mzok1GOV8kjJFM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damon Ding <damon.ding@rock-chips.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0643/1815] arm64: dts: rockchip: Add missing hclk for RK3588 eDP1
Date: Sat, 12 Sep 2026 08:39:53 +0200
Message-ID: <20260912065703.975164549@linuxfoundation.org>
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

From: Damon Ding <damon.ding@rock-chips.com>

[ Upstream commit 09820811c549ee2c408defe36b210b13c7a85fcf ]

Add the required HCLK_VO1 bus clock to RK3588 eDP1 node with
corresponding clock-name "hclk". This clock is necessary for
the eDP controller to access video output GRF and work properly.

Previously the clock was enabled implicitly via GRF phandle
reference. Add it explicitly now to align with updated binding.

Fixes: a481bb0b1ad9 ("arm64: dts: rockchip: Add eDP1 dt node for rk3588")
Signed-off-by: Damon Ding <damon.ding@rock-chips.com>
Link: https://patch.msgid.link/20260605022305.3058853-3-damon.ding@rock-chips.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3588-extra.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3588-extra.dtsi b/arch/arm64/boot/dts/rockchip/rk3588-extra.dtsi
index a2640014ee042..b251bb129cdbf 100644
--- a/arch/arm64/boot/dts/rockchip/rk3588-extra.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3588-extra.dtsi
@@ -285,8 +285,8 @@ hdmi1_out: port@1 {
 	edp1: edp@fded0000 {
 		compatible = "rockchip,rk3588-edp";
 		reg = <0x0 0xfded0000 0x0 0x1000>;
-		clocks = <&cru CLK_EDP1_24M>, <&cru PCLK_EDP1>;
-		clock-names = "dp", "pclk";
+		clocks = <&cru CLK_EDP1_24M>, <&cru PCLK_EDP1>, <&cru HCLK_VO1>;
+		clock-names = "dp", "pclk", "hclk";
 		interrupts = <GIC_SPI 164 IRQ_TYPE_LEVEL_HIGH 0>;
 		phys = <&hdptxphy1>;
 		phy-names = "dp";
-- 
2.53.0



